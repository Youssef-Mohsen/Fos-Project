
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 1c 0f 00 00       	call   800f52 <libmain>
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
  800055:	68 00 49 80 00       	push   $0x804900
  80005a:	e8 ef 12 00 00       	call   80134e <cprintf>
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
  8000a5:	68 30 49 80 00       	push   $0x804930
  8000aa:	e8 9f 12 00 00       	call   80134e <cprintf>
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
  8000c6:	81 ec dc 00 00 00    	sub    $0xdc,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 01                	push   $0x1
  8000d1:	e8 08 2a 00 00       	call   802ade <sys_set_uheap_strategy>
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
  8000f6:	68 69 49 80 00       	push   $0x804969
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 85 49 80 00       	push   $0x804985
  800102:	e8 8a 0f 00 00       	call   801091 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	/*=================================================*/

	int eval = 0;
  800107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  80010e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800115:	c7 45 b8 00 00 30 00 	movl   $0x300000,-0x48(%ebp)

	void * va ;
	int idx = 0;
  80011c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800123:	e8 03 26 00 00       	call   80272b <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 b0 25 00 00       	call   8026e0 <sys_calculate_free_frames>
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
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
  80013d:	68 98 49 80 00       	push   $0x804998
  800142:	e8 07 12 00 00       	call   80134e <cprintf>
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
  80017d:	89 45 ac             	mov    %eax,-0x54(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 ac             	pushl  -0x54(%ebp)
  800186:	e8 73 1f 00 00       	call   8020fe <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 c2                	mov    %eax,%edx
  800190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800193:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
  80019a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80019d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8001a4:	89 45 a8             	mov    %eax,-0x58(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  8001a7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001aa:	d1 e8                	shr    %eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	89 14 85 60 8c 80 00 	mov    %edx,0x808c60(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001c0:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c6:	01 c2                	add    %eax,%edx
  8001c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cb:	89 14 85 60 76 80 00 	mov    %edx,0x807660(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
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
  8001f5:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  8001fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8001ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	48                   	dec    %eax
  800205:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800208:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	f7 75 a0             	divl   -0x60(%ebp)
  800213:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800216:	29 d0                	sub    %edx,%eax
  800218:	89 45 98             	mov    %eax,-0x68(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80021b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800221:	89 45 94             	mov    %eax,-0x6c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800224:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  800228:	7e 48                	jle    800272 <_main+0x1b2>
  80022a:	83 7d 94 0f          	cmpl   $0xf,-0x6c(%ebp)
  80022e:	7f 42                	jg     800272 <_main+0x1b2>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800230:	c7 45 90 00 10 00 00 	movl   $0x1000,-0x70(%ebp)
  800237:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80023d:	01 d0                	add    %edx,%eax
  80023f:	48                   	dec    %eax
  800240:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800243:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	f7 75 90             	divl   -0x70(%ebp)
  80024e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800251:	29 d0                	sub    %edx,%eax
  800253:	83 e8 04             	sub    $0x4,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800259:	8b 45 98             	mov    -0x68(%ebp),%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800262:	8b 55 94             	mov    -0x6c(%ebp),%edx
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
  80028a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80028d:	ff 75 a8             	pushl  -0x58(%ebp)
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
  8002ac:	68 f0 49 80 00       	push   $0x8049f0
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 85 49 80 00       	push   $0x804985
  8002b8:	e8 d4 0d 00 00       	call   801091 <_panic>
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
  8002dd:	c7 45 88 00 10 00 00 	movl   $0x1000,-0x78(%ebp)
  8002e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8002e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	48                   	dec    %eax
  8002ed:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8002f0:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	f7 75 88             	divl   -0x78(%ebp)
  8002fb:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002fe:	29 d0                	sub    %edx,%eax
  800300:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 remainSize = (roundedTotalSize - curTotalSize) - sizeof(int) /*END block*/;
  800303:	8b 45 98             	mov    -0x68(%ebp),%eax
  800306:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800309:	83 e8 04             	sub    $0x4,%eax
  80030c:	89 45 80             	mov    %eax,-0x80(%ebp)
	if (remainSize >= (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  80030f:	83 7d 80 0f          	cmpl   $0xf,-0x80(%ebp)
  800313:	76 7b                	jbe    800390 <_main+0x2d0>
	{
		cprintf("Filling the remaining size of %d\n\n", remainSize);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	ff 75 80             	pushl  -0x80(%ebp)
  80031b:	68 18 4a 80 00       	push   $0x804a18
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 e7 28 00 00       	call   802c20 <alloc_block>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800341:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
  800348:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034b:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  800352:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = curVA + sizeOfMetaData/2;
  800355:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800358:	83 c0 04             	add    $0x4,%eax
  80035b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (check_block(va, expectedVA, remainSize, 1) == 0)
  80035e:	6a 01                	push   $0x1
  800360:	ff 75 80             	pushl  -0x80(%ebp)
  800363:	ff 75 a4             	pushl  -0x5c(%ebp)
  800366:	ff 75 a8             	pushl  -0x58(%ebp)
  800369:	e8 ca fc ff ff       	call   800038 <check_block>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	85 c0                	test   %eax,%eax
  800373:	75 1b                	jne    800390 <_main+0x2d0>
		{
			is_correct = 0;
  800375:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			panic("alloc_block_xx #PRQ.oo: WRONG ALLOC\n", idx);
  80037c:	ff 75 dc             	pushl  -0x24(%ebp)
  80037f:	68 3c 4a 80 00       	push   $0x804a3c
  800384:	6a 7f                	push   $0x7f
  800386:	68 85 49 80 00       	push   $0x804985
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 4b 23 00 00       	call   8026e0 <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 64 4a 80 00       	push   $0x804a64
  8003a0:	e8 a9 0f 00 00       	call   80134e <cprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8003af:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  8003b6:	e9 98 00 00 00       	jmp    800453 <_main+0x393>
		{
			free(startVAs[i*allocCntPerSize]);
  8003bb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	c1 e0 02             	shl    $0x2,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	c1 e0 03             	shl    $0x3,%eax
  8003d1:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	50                   	push   %eax
  8003dc:	e8 3c 1f 00 00       	call   80231d <free>
  8003e1:	83 c4 10             	add    $0x10,%esp
			if (check_block(startVAs[i*allocCntPerSize], startVAs[i*allocCntPerSize], allocSizes[i], 0) == 0)
  8003e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003e7:	8b 0c 85 00 60 80 00 	mov    0x806000(,%eax,4),%ecx
  8003ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f1:	89 d0                	mov    %edx,%eax
  8003f3:	c1 e0 02             	shl    $0x2,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ff:	01 d0                	add    %edx,%eax
  800401:	c1 e0 03             	shl    $0x3,%eax
  800404:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  80040b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80040e:	89 d8                	mov    %ebx,%eax
  800410:	c1 e0 02             	shl    $0x2,%eax
  800413:	01 d8                	add    %ebx,%eax
  800415:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  80041c:	01 d8                	add    %ebx,%eax
  80041e:	c1 e0 03             	shl    $0x3,%eax
  800421:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  800428:	6a 00                	push   $0x0
  80042a:	51                   	push   %ecx
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	e8 06 fc ff ff       	call   800038 <check_block>
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	85 c0                	test   %eax,%eax
  800437:	75 17                	jne    800450 <_main+0x390>
			{
				is_correct = 0;
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #1.1: WRONG FREE!\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 ac 4a 80 00       	push   $0x804aac
  800448:	e8 01 0f 00 00       	call   80134e <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  800450:	ff 45 c4             	incl   -0x3c(%ebp)
  800453:	83 7d c4 06          	cmpl   $0x6,-0x3c(%ebp)
  800457:	0f 8e 5e ff ff ff    	jle    8003bb <_main+0x2fb>
				cprintf("test_free_2 #1.1: WRONG FREE!\n");
			}
		}

		//Free block before last
		free(startVAs[numOfAllocs*allocCntPerSize - 1]);
  80045d:	a1 3c 76 80 00       	mov    0x80763c,%eax
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	50                   	push   %eax
  800466:	e8 b2 1e 00 00       	call   80231d <free>
  80046b:	83 c4 10             	add    $0x10,%esp

		if (check_block(startVAs[numOfAllocs*allocCntPerSize - 1], startVAs[numOfAllocs*allocCntPerSize - 1], allocSizes[numOfAllocs-1], 0) == 0)
  80046e:	8b 0d 18 60 80 00    	mov    0x806018,%ecx
  800474:	8b 15 3c 76 80 00    	mov    0x80763c,%edx
  80047a:	a1 3c 76 80 00       	mov    0x80763c,%eax
  80047f:	6a 00                	push   $0x0
  800481:	51                   	push   %ecx
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	e8 af fb ff ff       	call   800038 <check_block>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	85 c0                	test   %eax,%eax
  80048e:	75 17                	jne    8004a7 <_main+0x3e7>
		{
			is_correct = 0;
  800490:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.2: WRONG FREE!\n");
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	68 cc 4a 80 00       	push   $0x804acc
  80049f:	e8 aa 0e 00 00       	call   80134e <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
		}

		//Reallocate first block
		actualSize = allocSizes[0] - sizeOfMetaData;
  8004a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8004ac:	83 e8 08             	sub    $0x8,%eax
  8004af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		va = malloc(actualSize);
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	ff 75 ac             	pushl  -0x54(%ebp)
  8004b8:	e8 41 1c 00 00       	call   8020fe <malloc>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = (void*)(USER_HEAP_START + sizeof(int) + sizeOfMetaData/2);
  8004c3:	c7 45 a4 08 00 00 80 	movl   $0x80000008,-0x5c(%ebp)
		if (check_block(va, expectedVA, allocSizes[0], 1) == 0)
  8004ca:	a1 00 60 80 00       	mov    0x806000,%eax
  8004cf:	6a 01                	push   $0x1
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8004d5:	ff 75 a8             	pushl  -0x58(%ebp)
  8004d8:	e8 5b fb ff ff       	call   800038 <check_block>
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	75 17                	jne    8004fb <_main+0x43b>
		{
			is_correct = 0;
  8004e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.3: WRONG ALLOCATE AFTER FREE!\n");
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	68 ec 4a 80 00       	push   $0x804aec
  8004f3:	e8 56 0e 00 00       	call   80134e <cprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
		}

		//Free 2nd block
		free(startVAs[1]);
  8004fb:	a1 64 60 80 00       	mov    0x806064,%eax
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	50                   	push   %eax
  800504:	e8 14 1e 00 00       	call   80231d <free>
  800509:	83 c4 10             	add    $0x10,%esp
		if (check_block(startVAs[1],startVAs[1], allocSizes[0], 0) == 0)
  80050c:	8b 0d 00 60 80 00    	mov    0x806000,%ecx
  800512:	8b 15 64 60 80 00    	mov    0x806064,%edx
  800518:	a1 64 60 80 00       	mov    0x806064,%eax
  80051d:	6a 00                	push   $0x0
  80051f:	51                   	push   %ecx
  800520:	52                   	push   %edx
  800521:	50                   	push   %eax
  800522:	e8 11 fb ff ff       	call   800038 <check_block>
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	75 17                	jne    800545 <_main+0x485>
		{
			is_correct = 0;
  80052e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.4: WRONG FREE!\n");
  800535:	83 ec 0c             	sub    $0xc,%esp
  800538:	68 1c 4b 80 00       	push   $0x804b1c
  80053d:	e8 0c 0e 00 00       	call   80134e <cprintf>
  800542:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800549:	74 04                	je     80054f <_main+0x48f>
		{
			eval += 10;
  80054b:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*free Scenario 2: Merge with previous ONLY (AT the tail)*/
	cprintf("2: Free some allocated blocks [Merge with previous ONLY]\n\n") ;
  80054f:	83 ec 0c             	sub    $0xc,%esp
  800552:	68 3c 4b 80 00       	push   $0x804b3c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 77 4b 80 00       	push   $0x804b77
  800567:	e8 e2 0d 00 00       	call   80134e <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  80056f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		//Free last block (coalesce with previous)
		blockIndex = numOfAllocs*allocCntPerSize;
  800576:	c7 85 7c ff ff ff 78 	movl   $0x578,-0x84(%ebp)
  80057d:	05 00 00 
		free(startVAs[blockIndex]);
  800580:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800586:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	50                   	push   %eax
  800591:	e8 87 1d 00 00       	call   80231d <free>
  800596:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[numOfAllocs-1] + remainSize;
  800599:	8b 15 18 60 80 00    	mov    0x806018,%edx
  80059f:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005a2:	01 d0                	add    %edx,%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  8005a7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005ad:	48                   	dec    %eax
  8005ae:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  8005b5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8005c3:	6a 00                	push   $0x0
  8005c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	e8 69 fa ff ff       	call   800038 <check_block>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	75 17                	jne    8005ed <_main+0x52d>
		{
			is_correct = 0;
  8005d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #2.1: WRONG FREE!\n");
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	68 8c 4b 80 00       	push   $0x804b8c
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 ab 4b 80 00       	push   $0x804bab
  8005f5:	e8 54 0d 00 00       	call   80134e <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
		blockIndex = 2*allocCntPerSize+1 ;
  8005fd:	c7 85 7c ff ff ff 91 	movl   $0x191,-0x84(%ebp)
  800604:	01 00 00 
		free(startVAs[blockIndex]);
  800607:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80060d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	50                   	push   %eax
  800618:	e8 00 1d 00 00       	call   80231d <free>
  80061d:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[2]+allocSizes[2];
  800620:	8b 15 08 60 80 00    	mov    0x806008,%edx
  800626:	a1 08 60 80 00       	mov    0x806008,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  800630:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800636:	48                   	dec    %eax
  800637:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  80063e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800644:	48                   	dec    %eax
  800645:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80064c:	6a 00                	push   $0x0
  80064e:	ff 75 d8             	pushl  -0x28(%ebp)
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 e0 f9 ff ff       	call   800038 <check_block>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	85 c0                	test   %eax,%eax
  80065d:	75 17                	jne    800676 <_main+0x5b6>
		{
			is_correct = 0;
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #2.2: WRONG FREE!\n");
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 c4 4b 80 00       	push   $0x804bc4
  80066e:	e8 db 0c 00 00       	call   80134e <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	74 04                	je     800680 <_main+0x5c0>
		{
			eval += 10;
  80067c:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
	}


	//====================================================================//
	/*free Scenario 4: Merge with next ONLY (AT the head)*/
	cprintf("3: Free some allocated blocks [Merge with next ONLY]\n\n") ;
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	68 e4 4b 80 00       	push   $0x804be4
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 1b 4c 80 00       	push   $0x804c1b
  800698:	e8 b1 0c 00 00       	call   80134e <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8006a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		blockIndex = 0 ;
  8006a7:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  8006ae:	00 00 00 
		free(startVAs[blockIndex]);
  8006b1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006b7:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	50                   	push   %eax
  8006c2:	e8 56 1c 00 00       	call   80231d <free>
  8006c7:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[0]+allocSizes[0];
  8006ca:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8006d0:	a1 00 60 80 00       	mov    0x806000,%eax
  8006d5:	01 d0                	add    %edx,%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex],startVAs[blockIndex], expectedSize, 0) == 0)
  8006da:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006e0:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  8006e7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006ed:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8006f4:	6a 00                	push   $0x0
  8006f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	e8 38 f9 ff ff       	call   800038 <check_block>
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	75 17                	jne    80071e <_main+0x65e>
		{
			is_correct = 0;
  800707:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #3.1: WRONG FREE!\n");
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	68 30 4c 80 00       	push   $0x804c30
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 4f 4c 80 00       	push   $0x804c4f
  800726:	e8 23 0c 00 00       	call   80134e <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
		blockIndex = 1*allocCntPerSize - 1 ;
  80072e:	c7 85 7c ff ff ff c7 	movl   $0xc7,-0x84(%ebp)
  800735:	00 00 00 
		free(startVAs[blockIndex]);
  800738:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80073e:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	50                   	push   %eax
  800749:	e8 cf 1b 00 00       	call   80231d <free>
  80074e:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  800751:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800757:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	50                   	push   %eax
  800762:	e8 82 24 00 00       	call   802be9 <get_block_size>
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		expectedSize = allocSizes[0]+allocSizes[1];
  800770:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800776:	a1 04 60 80 00       	mov    0x806004,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex],startVAs[blockIndex], expectedSize, 0) == 0)
  800780:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800786:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  80078d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800793:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80079a:	6a 00                	push   $0x0
  80079c:	ff 75 d8             	pushl  -0x28(%ebp)
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	e8 92 f8 ff ff       	call   800038 <check_block>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	85 c0                	test   %eax,%eax
  8007ab:	75 17                	jne    8007c4 <_main+0x704>
		{
			is_correct = 0;
  8007ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #3.2: WRONG FREE!\n");
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	68 68 4c 80 00       	push   $0x804c68
  8007bc:	e8 8d 0b 00 00       	call   80134e <cprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  8007c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c8:	74 04                	je     8007ce <_main+0x70e>
		{
			eval += 10;
  8007ca:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*free Scenario 6: Merge with prev & next */
	cprintf("4: Free some allocated blocks [Merge with previous & next]\n\n") ;
  8007ce:	83 ec 0c             	sub    $0xc,%esp
  8007d1:	68 88 4c 80 00       	push   $0x804c88
  8007d6:	e8 73 0b 00 00       	call   80134e <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8007de:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		blockIndex = 4*allocCntPerSize - 2 ;
  8007e5:	c7 85 7c ff ff ff 1e 	movl   $0x31e,-0x84(%ebp)
  8007ec:	03 00 00 
		free(startVAs[blockIndex]);
  8007ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8007f5:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	50                   	push   %eax
  800800:	e8 18 1b 00 00       	call   80231d <free>
  800805:	83 c4 10             	add    $0x10,%esp

		blockIndex = 4*allocCntPerSize - 1 ;
  800808:	c7 85 7c ff ff ff 1f 	movl   $0x31f,-0x84(%ebp)
  80080f:	03 00 00 
		free(startVAs[blockIndex]);
  800812:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800818:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	50                   	push   %eax
  800823:	e8 f5 1a 00 00       	call   80231d <free>
  800828:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  80082b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800831:	48                   	dec    %eax
  800832:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  800839:	83 ec 0c             	sub    $0xc,%esp
  80083c:	50                   	push   %eax
  80083d:	e8 a7 23 00 00       	call   802be9 <get_block_size>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		expectedSize = allocSizes[3]+allocSizes[3]+allocSizes[4];
  80084b:	8b 15 0c 60 80 00    	mov    0x80600c,%edx
  800851:	a1 0c 60 80 00       	mov    0x80600c,%eax
  800856:	01 c2                	add    %eax,%edx
  800858:	a1 10 60 80 00       	mov    0x806010,%eax
  80085d:	01 d0                	add    %edx,%eax
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  800862:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800868:	48                   	dec    %eax
  800869:	8b 14 85 60 60 80 00 	mov    0x806060(,%eax,4),%edx
  800870:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800876:	48                   	dec    %eax
  800877:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80087e:	6a 00                	push   $0x0
  800880:	ff 75 d8             	pushl  -0x28(%ebp)
  800883:	52                   	push   %edx
  800884:	50                   	push   %eax
  800885:	e8 ae f7 ff ff       	call   800038 <check_block>
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	85 c0                	test   %eax,%eax
  80088f:	75 17                	jne    8008a8 <_main+0x7e8>
		{
			is_correct = 0;
  800891:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #4: WRONG FREE!\n");
  800898:	83 ec 0c             	sub    $0xc,%esp
  80089b:	68 c5 4c 80 00       	push   $0x804cc5
  8008a0:	e8 a9 0a 00 00       	call   80134e <cprintf>
  8008a5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008ac:	74 04                	je     8008b2 <_main+0x7f2>
		{
			eval += 20;
  8008ae:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*Allocate After Free Scenarios */
	cprintf("5: Allocate After Free [should be placed in coalesced blocks]\n\n") ;
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 e4 4c 80 00       	push   $0x804ce4
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 24 4d 80 00       	push   $0x804d24
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 49 4d 80 00       	push   $0x804d49
  8008e1:	e8 68 0a 00 00       	call   80134e <cprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 4*sizeof(int);
  8008e9:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  8008f0:	c7 85 74 ff ff ff 02 	movl   $0x2,-0x8c(%ebp)
  8008f7:	00 00 00 
  8008fa:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8008fd:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	83 c0 07             	add    $0x7,%eax
  800908:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  80090e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
  80091f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800925:	29 d0                	sub    %edx,%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  80092a:	83 ec 0c             	sub    $0xc,%esp
  80092d:	ff 75 ac             	pushl  -0x54(%ebp)
  800930:	e8 c9 17 00 00       	call   8020fe <malloc>
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = (void*)(USER_HEAP_START + sizeOfMetaData);
  80093b:	c7 45 a4 08 00 00 80 	movl   $0x80000008,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800942:	6a 01                	push   $0x1
  800944:	ff 75 d8             	pushl  -0x28(%ebp)
  800947:	ff 75 a4             	pushl  -0x5c(%ebp)
  80094a:	ff 75 a8             	pushl  -0x58(%ebp)
  80094d:	e8 e6 f6 ff ff       	call   800038 <check_block>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	85 c0                	test   %eax,%eax
  800957:	75 17                	jne    800970 <_main+0x8b0>
			{
				is_correct = 0;
  800959:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.1: WRONG ALLOCATE AFTER FREE!\n");
  800960:	83 ec 0c             	sub    $0xc,%esp
  800963:	68 60 4d 80 00       	push   $0x804d60
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 90 4d 80 00       	push   $0x804d90
  800978:	e8 d1 09 00 00       	call   80134e <cprintf>
  80097d:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 2*sizeof(int) ;
  800980:	c7 45 ac 08 00 00 00 	movl   $0x8,-0x54(%ebp)
			va = malloc(actualSize);
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	ff 75 ac             	pushl  -0x54(%ebp)
  80098d:	e8 6c 17 00 00       	call   8020fe <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 a8             	mov    %eax,-0x58(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800998:	c7 85 6c ff ff ff 02 	movl   $0x2,-0x94(%ebp)
  80099f:	00 00 00 
  8009a2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8009a5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	83 c0 07             	add    $0x7,%eax
  8009b0:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8009b6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c1:	f7 b5 6c ff ff ff    	divl   -0x94(%ebp)
  8009c7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009cd:	29 d0                	sub    %edx,%eax
  8009cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			//Check returned va
			expectedVA = (void*)(USER_HEAP_START + sizeOfMetaData + 4*sizeof(int) + sizeOfMetaData);
  8009d2:	c7 45 a4 20 00 00 80 	movl   $0x80000020,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  8009d9:	6a 01                	push   $0x1
  8009db:	ff 75 d8             	pushl  -0x28(%ebp)
  8009de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8009e1:	ff 75 a8             	pushl  -0x58(%ebp)
  8009e4:	e8 4f f6 ff ff       	call   800038 <check_block>
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	85 c0                	test   %eax,%eax
  8009ee:	75 17                	jne    800a07 <_main+0x947>
			{
				is_correct = 0;
  8009f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.2: WRONG ALLOCATE AFTER FREE!\n");
  8009f7:	83 ec 0c             	sub    $0xc,%esp
  8009fa:	68 bc 4d 80 00       	push   $0x804dbc
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 ec 4d 80 00       	push   $0x804dec
  800a0f:	e8 3a 09 00 00       	call   80134e <cprintf>
  800a14:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 5*sizeof(int); //20B
  800a17:	c7 45 ac 14 00 00 00 	movl   $0x14,-0x54(%ebp)
			expectedSize = allocSizes[0] + allocSizes[1]; //20B + 16B [Internal Fragmentation of 8 Bytes]
  800a1e:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800a24:	a1 04 60 80 00       	mov    0x806004,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  800a2e:	83 ec 0c             	sub    $0xc,%esp
  800a31:	ff 75 ac             	pushl  -0x54(%ebp)
  800a34:	e8 c5 16 00 00       	call   8020fe <malloc>
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = startVAs[1*allocCntPerSize - 1];
  800a3f:	a1 7c 63 80 00       	mov    0x80637c,%eax
  800a44:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800a47:	6a 01                	push   $0x1
  800a49:	ff 75 d8             	pushl  -0x28(%ebp)
  800a4c:	ff 75 a4             	pushl  -0x5c(%ebp)
  800a4f:	ff 75 a8             	pushl  -0x58(%ebp)
  800a52:	e8 e1 f5 ff ff       	call   800038 <check_block>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	75 17                	jne    800a75 <_main+0x9b5>
			{
				is_correct = 0;
  800a5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.3: WRONG ALLOCATE AFTER FREE!\n");
  800a65:	83 ec 0c             	sub    $0xc,%esp
  800a68:	68 2c 4e 80 00       	push   $0x804e2c
  800a6d:	e8 dc 08 00 00       	call   80134e <cprintf>
  800a72:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (is_correct)
  800a75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a79:	74 04                	je     800a7f <_main+0x9bf>
		{
			eval += 10;
  800a7b:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}

		cprintf("	5.2: in block coalesces with PREV & NEXT\n\n") ;
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	68 5c 4e 80 00       	push   $0x804e5c
  800a87:	e8 c2 08 00 00       	call   80134e <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a8f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 3*kilo/2;
  800a96:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800a9d:	c7 85 64 ff ff ff 02 	movl   $0x2,-0x9c(%ebp)
  800aa4:	00 00 00 
  800aa7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800aaa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	83 c0 07             	add    $0x7,%eax
  800ab5:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800abb:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac6:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
  800acc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800ad2:	29 d0                	sub    %edx,%eax
  800ad4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		va = malloc(actualSize);
  800ad7:	83 ec 0c             	sub    $0xc,%esp
  800ada:	ff 75 ac             	pushl  -0x54(%ebp)
  800add:	e8 1c 16 00 00       	call   8020fe <malloc>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = startVAs[4*allocCntPerSize - 2];
  800ae8:	a1 d8 6c 80 00       	mov    0x806cd8,%eax
  800aed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800af0:	6a 01                	push   $0x1
  800af2:	ff 75 d8             	pushl  -0x28(%ebp)
  800af5:	ff 75 a4             	pushl  -0x5c(%ebp)
  800af8:	ff 75 a8             	pushl  -0x58(%ebp)
  800afb:	e8 38 f5 ff ff       	call   800038 <check_block>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	85 c0                	test   %eax,%eax
  800b05:	75 17                	jne    800b1e <_main+0xa5e>
		{
			is_correct = 0;
  800b07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #5.2: WRONG ALLOCATE AFTER FREE!\n");
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	68 88 4e 80 00       	push   $0x804e88
  800b16:	e8 33 08 00 00       	call   80134e <cprintf>
  800b1b:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800b1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b22:	74 04                	je     800b28 <_main+0xa68>
		{
			eval += 10;
  800b24:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}

		cprintf("	5.3: in block coalesces with PREV\n\n") ;
  800b28:	83 ec 0c             	sub    $0xc,%esp
  800b2b:	68 b8 4e 80 00       	push   $0x804eb8
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 e0 4e 80 00       	push   $0x804ee0
  800b40:	e8 09 08 00 00       	call   80134e <cprintf>
  800b45:	83 c4 10             	add    $0x10,%esp
		{
			is_correct = 1;
  800b48:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			actualSize = 30*sizeof(char) ;
  800b4f:	c7 45 ac 1e 00 00 00 	movl   $0x1e,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800b56:	c7 85 5c ff ff ff 02 	movl   $0x2,-0xa4(%ebp)
  800b5d:	00 00 00 
  800b60:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800b63:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b69:	01 d0                	add    %edx,%eax
  800b6b:	83 c0 07             	add    $0x7,%eax
  800b6e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800b74:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7f:	f7 b5 5c ff ff ff    	divl   -0xa4(%ebp)
  800b85:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b8b:	29 d0                	sub    %edx,%eax
  800b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	ff 75 ac             	pushl  -0x54(%ebp)
  800b96:	e8 63 15 00 00       	call   8020fe <malloc>
  800b9b:	83 c4 10             	add    $0x10,%esp
  800b9e:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = startVAs[2*allocCntPerSize];
  800ba1:	a1 a0 66 80 00       	mov    0x8066a0,%eax
  800ba6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800ba9:	6a 01                	push   $0x1
  800bab:	ff 75 d8             	pushl  -0x28(%ebp)
  800bae:	ff 75 a4             	pushl  -0x5c(%ebp)
  800bb1:	ff 75 a8             	pushl  -0x58(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <check_block>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	75 17                	jne    800bd7 <_main+0xb17>
			{
				is_correct = 0;
  800bc0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.1: WRONG ALLOCATE AFTER FREE!\n");
  800bc7:	83 ec 0c             	sub    $0xc,%esp
  800bca:	68 00 4f 80 00       	push   $0x804f00
  800bcf:	e8 7a 07 00 00       	call   80134e <cprintf>
  800bd4:	83 c4 10             	add    $0x10,%esp
			}
		}
		actualSize = 3*kilo/2 - sizeOfMetaData ;
  800bd7:	c7 45 ac f8 05 00 00 	movl   $0x5f8,-0x54(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800bde:	c7 85 54 ff ff ff 02 	movl   $0x2,-0xac(%ebp)
  800be5:	00 00 00 
  800be8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800beb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	83 c0 07             	add    $0x7,%eax
  800bf6:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800bfc:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	f7 b5 54 ff ff ff    	divl   -0xac(%ebp)
  800c0d:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c13:	29 d0                	sub    %edx,%eax
  800c15:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//dummy allocation to consume the 1st 1.5 KB free block
		{
			va = malloc(actualSize);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	ff 75 ac             	pushl  -0x54(%ebp)
  800c1e:	e8 db 14 00 00       	call   8020fe <malloc>
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	89 45 a8             	mov    %eax,-0x58(%ebp)
		}
		//dummy allocation to consume the 1st 2 KB free block
		{
			va = malloc(actualSize);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	ff 75 ac             	pushl  -0x54(%ebp)
  800c2f:	e8 ca 14 00 00       	call   8020fe <malloc>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	89 45 a8             	mov    %eax,-0x58(%ebp)
		}

		cprintf("	5.3.2: b. at tail\n\n") ;
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	68 30 4f 80 00       	push   $0x804f30
  800c42:	e8 07 07 00 00       	call   80134e <cprintf>
  800c47:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 3*kilo/2 ;
  800c4a:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800c51:	c7 85 4c ff ff ff 02 	movl   $0x2,-0xb4(%ebp)
  800c58:	00 00 00 
  800c5b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800c5e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	83 c0 07             	add    $0x7,%eax
  800c69:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800c6f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	f7 b5 4c ff ff ff    	divl   -0xb4(%ebp)
  800c80:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c86:	29 d0                	sub    %edx,%eax
  800c88:	89 45 d8             	mov    %eax,-0x28(%ebp)

			print_blocks_list(freeBlocksList);
  800c8b:	83 ec 10             	sub    $0x10,%esp
  800c8e:	89 e0                	mov    %esp,%eax
  800c90:	89 c2                	mov    %eax,%edx
  800c92:	bb 44 60 80 00       	mov    $0x806044,%ebx
  800c97:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9c:	89 d7                	mov    %edx,%edi
  800c9e:	89 de                	mov    %ebx,%esi
  800ca0:	89 c1                	mov    %eax,%ecx
  800ca2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca4:	e8 06 20 00 00       	call   802caf <print_blocks_list>
  800ca9:	83 c4 10             	add    $0x10,%esp

			va = malloc(actualSize);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	ff 75 ac             	pushl  -0x54(%ebp)
  800cb2:	e8 47 14 00 00       	call   8020fe <malloc>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 a8             	mov    %eax,-0x58(%ebp)

			//Check returned va
			expectedVA = startVAs[numOfAllocs*allocCntPerSize-1];
  800cbd:	a1 3c 76 80 00       	mov    0x80763c,%eax
  800cc2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800cc5:	6a 01                	push   $0x1
  800cc7:	ff 75 d8             	pushl  -0x28(%ebp)
  800cca:	ff 75 a4             	pushl  -0x5c(%ebp)
  800ccd:	ff 75 a8             	pushl  -0x58(%ebp)
  800cd0:	e8 63 f3 ff ff       	call   800038 <check_block>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	75 17                	jne    800cf3 <_main+0xc33>
			{
				is_correct = 0;
  800cdc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.2: WRONG ALLOCATE AFTER FREE!\n");
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	68 48 4f 80 00       	push   $0x804f48
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 78 4f 80 00       	push   $0x804f78
  800cfb:	e8 4e 06 00 00       	call   80134e <cprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 3*kilo/2 ;
  800d03:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800d0a:	c7 85 44 ff ff ff 02 	movl   $0x2,-0xbc(%ebp)
  800d11:	00 00 00 
  800d14:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800d17:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d1d:	01 d0                	add    %edx,%eax
  800d1f:	83 c0 07             	add    $0x7,%eax
  800d22:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800d28:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d33:	f7 b5 44 ff ff ff    	divl   -0xbc(%ebp)
  800d39:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3f:	29 d0                	sub    %edx,%eax
  800d41:	89 45 d8             	mov    %eax,-0x28(%ebp)

			va = malloc(actualSize);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	ff 75 ac             	pushl  -0x54(%ebp)
  800d4a:	e8 af 13 00 00       	call   8020fe <malloc>
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	89 45 a8             	mov    %eax,-0x58(%ebp)

			//Check returned va
			expectedVA = (void*)startVAs[numOfAllocs*allocCntPerSize-1] + 3*kilo/2 + sizeOfMetaData;
  800d55:	a1 3c 76 80 00       	mov    0x80763c,%eax
  800d5a:	05 08 06 00 00       	add    $0x608,%eax
  800d5f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800d62:	6a 01                	push   $0x1
  800d64:	ff 75 d8             	pushl  -0x28(%ebp)
  800d67:	ff 75 a4             	pushl  -0x5c(%ebp)
  800d6a:	ff 75 a8             	pushl  -0x58(%ebp)
  800d6d:	e8 c6 f2 ff ff       	call   800038 <check_block>
  800d72:	83 c4 10             	add    $0x10,%esp
  800d75:	85 c0                	test   %eax,%eax
  800d77:	75 17                	jne    800d90 <_main+0xcd0>
			{
				is_correct = 0;
  800d79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.3: WRONG ALLOCATE AFTER FREE!\n");
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	68 b0 4f 80 00       	push   $0x804fb0
  800d88:	e8 c1 05 00 00       	call   80134e <cprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (is_correct)
  800d90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d94:	74 04                	je     800d9a <_main+0xcda>
		{
			eval += 10;
  800d96:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*Check memory allocation*/
	cprintf("6: Check memory allocation [should not be changed due to free]\n\n") ;
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	68 e0 4f 80 00       	push   $0x804fe0
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 2a 19 00 00       	call   8026e0 <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 24 50 80 00       	push   $0x805024
  800dc7:	e8 82 05 00 00       	call   80134e <cprintf>
  800dcc:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800dcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		}
		if (is_correct)
  800dd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dda:	74 04                	je     800de0 <_main+0xd20>
		{
			eval += 10;
  800ddc:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	uint32 expectedAllocatedSize = curTotalSize;
  800de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800de3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  800de9:	c7 85 38 ff ff ff 00 	movl   $0x1000,-0xc8(%ebp)
  800df0:	10 00 00 
  800df3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800df9:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	48                   	dec    %eax
  800e02:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800e08:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e13:	f7 b5 38 ff ff ff    	divl   -0xc8(%ebp)
  800e19:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800e1f:	29 d0                	sub    %edx,%eax
  800e21:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800e27:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e2d:	c1 e8 0c             	shr    $0xc,%eax
  800e30:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800e36:	c7 85 2c ff ff ff 00 	movl   $0x400000,-0xd4(%ebp)
  800e3d:	00 40 00 
  800e40:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800e46:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	48                   	dec    %eax
  800e4f:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800e55:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	f7 b5 2c ff ff ff    	divl   -0xd4(%ebp)
  800e66:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e6c:	29 d0                	sub    %edx,%eax
  800e6e:	c1 e8 16             	shr    $0x16,%eax
  800e71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)

	//====================================================================//
	/*Check WS elements*/
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	68 90 50 80 00       	push   $0x805090
  800e7f:	e8 ca 04 00 00       	call   80134e <cprintf>
  800e84:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800e87:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800e8e:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800e94:	c1 e0 02             	shl    $0x2,%eax
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	e8 5e 12 00 00       	call   8020fe <malloc>
  800ea0:	83 c4 10             	add    $0x10,%esp
  800ea3:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		int i = 0;
  800ea9:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800eb0:	c7 45 bc 00 00 00 80 	movl   $0x80000000,-0x44(%ebp)
  800eb7:	eb 24                	jmp    800edd <_main+0xe1d>
		{
			expectedVAs[i++] = va;
  800eb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 c0             	mov    %edx,-0x40(%ebp)
  800ec2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec9:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800ecf:	01 c2                	add    %eax,%edx
  800ed1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800ed4:	89 02                	mov    %eax,(%edx)
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800ed6:	81 45 bc 00 10 00 00 	addl   $0x1000,-0x44(%ebp)
  800edd:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ee3:	05 00 00 00 80       	add    $0x80000000,%eax
  800ee8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800eeb:	77 cc                	ja     800eb9 <_main+0xdf9>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800eed:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800ef3:	6a 02                	push   $0x2
  800ef5:	6a 00                	push   $0x0
  800ef7:	50                   	push   %eax
  800ef8:	ff b5 20 ff ff ff    	pushl  -0xe0(%ebp)
  800efe:	e8 38 1c 00 00       	call   802b3b <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 cc 50 80 00       	push   $0x8050cc
  800f1d:	e8 2c 04 00 00       	call   80134e <cprintf>
  800f22:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800f25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		}
		if (is_correct)
  800f2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f30:	74 04                	je     800f36 <_main+0xe76>
		{
			eval += 10;
  800f32:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	cprintf("%~test free() with FIRST FIT completed [DYNAMIC ALLOCATOR]. Evaluation = %d%\n", eval);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3c:	68 10 51 80 00       	push   $0x805110
  800f41:	e8 08 04 00 00       	call   80134e <cprintf>
  800f46:	83 c4 10             	add    $0x10,%esp

	return;
  800f49:	90                   	nop
}
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800f58:	e8 4c 19 00 00       	call   8028a9 <sys_getenvindex>
  800f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f63:	89 d0                	mov    %edx,%eax
  800f65:	c1 e0 03             	shl    $0x3,%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800f71:	01 c8                	add    %ecx,%eax
  800f73:	01 c0                	add    %eax,%eax
  800f75:	01 d0                	add    %edx,%eax
  800f77:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800f7e:	01 c8                	add    %ecx,%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f87:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800f8c:	a1 20 60 80 00       	mov    0x806020,%eax
  800f91:	8a 40 20             	mov    0x20(%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	74 0d                	je     800fa5 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800f98:	a1 20 60 80 00       	mov    0x806020,%eax
  800f9d:	83 c0 20             	add    $0x20,%eax
  800fa0:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa9:	7e 0a                	jle    800fb5 <libmain+0x63>
		binaryname = argv[0];
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	8b 00                	mov    (%eax),%eax
  800fb0:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// call user main routine
	_main(argc, argv);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	ff 75 08             	pushl  0x8(%ebp)
  800fbe:	e8 fd f0 ff ff       	call   8000c0 <_main>
  800fc3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800fc6:	e8 62 16 00 00       	call   80262d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 78 51 80 00       	push   $0x805178
  800fd3:	e8 76 03 00 00       	call   80134e <cprintf>
  800fd8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800fdb:	a1 20 60 80 00       	mov    0x806020,%eax
  800fe0:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800fe6:	a1 20 60 80 00       	mov    0x806020,%eax
  800feb:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800ff1:	83 ec 04             	sub    $0x4,%esp
  800ff4:	52                   	push   %edx
  800ff5:	50                   	push   %eax
  800ff6:	68 a0 51 80 00       	push   $0x8051a0
  800ffb:	e8 4e 03 00 00       	call   80134e <cprintf>
  801000:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801003:	a1 20 60 80 00       	mov    0x806020,%eax
  801008:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80100e:	a1 20 60 80 00       	mov    0x806020,%eax
  801013:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  801019:	a1 20 60 80 00       	mov    0x806020,%eax
  80101e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801024:	51                   	push   %ecx
  801025:	52                   	push   %edx
  801026:	50                   	push   %eax
  801027:	68 c8 51 80 00       	push   $0x8051c8
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 20 52 80 00       	push   $0x805220
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 78 51 80 00       	push   $0x805178
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 e2 15 00 00       	call   802647 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  801065:	e8 19 00 00 00       	call   801083 <exit>
}
  80106a:	90                   	nop
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	6a 00                	push   $0x0
  801078:	e8 f8 17 00 00       	call   802875 <sys_destroy_env>
  80107d:	83 c4 10             	add    $0x10,%esp
}
  801080:	90                   	nop
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <exit>:

void
exit(void)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801089:	e8 4d 18 00 00       	call   8028db <sys_exit_env>
}
  80108e:	90                   	nop
  80108f:	c9                   	leave  
  801090:	c3                   	ret    

00801091 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801097:	8d 45 10             	lea    0x10(%ebp),%eax
  80109a:	83 c0 04             	add    $0x4,%eax
  80109d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8010a0:	a1 54 a2 80 00       	mov    0x80a254,%eax
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	74 16                	je     8010bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8010a9:	a1 54 a2 80 00       	mov    0x80a254,%eax
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	50                   	push   %eax
  8010b2:	68 34 52 80 00       	push   $0x805234
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 39 52 80 00       	push   $0x805239
  8010d0:	e8 79 02 00 00       	call   80134e <cprintf>
  8010d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	e8 fc 01 00 00       	call   8012e3 <vcprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	6a 00                	push   $0x0
  8010ef:	68 55 52 80 00       	push   $0x805255
  8010f4:	e8 ea 01 00 00       	call   8012e3 <vcprintf>
  8010f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8010fc:	e8 82 ff ff ff       	call   801083 <exit>

	// should not return here
	while (1) ;
  801101:	eb fe                	jmp    801101 <_panic+0x70>

00801103 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801109:	a1 20 60 80 00       	mov    0x806020,%eax
  80110e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	39 c2                	cmp    %eax,%edx
  801119:	74 14                	je     80112f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	68 58 52 80 00       	push   $0x805258
  801123:	6a 26                	push   $0x26
  801125:	68 a4 52 80 00       	push   $0x8052a4
  80112a:	e8 62 ff ff ff       	call   801091 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80112f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801136:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80113d:	e9 c5 00 00 00       	jmp    801207 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801145:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	01 d0                	add    %edx,%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	85 c0                	test   %eax,%eax
  801155:	75 08                	jne    80115f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801157:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80115a:	e9 a5 00 00 00       	jmp    801204 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80115f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801166:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80116d:	eb 69                	jmp    8011d8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80116f:	a1 20 60 80 00       	mov    0x806020,%eax
  801174:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80117a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80117d:	89 d0                	mov    %edx,%eax
  80117f:	01 c0                	add    %eax,%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	c1 e0 03             	shl    $0x3,%eax
  801186:	01 c8                	add    %ecx,%eax
  801188:	8a 40 04             	mov    0x4(%eax),%al
  80118b:	84 c0                	test   %al,%al
  80118d:	75 46                	jne    8011d5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80118f:	a1 20 60 80 00       	mov    0x806020,%eax
  801194:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80119a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80119d:	89 d0                	mov    %edx,%eax
  80119f:	01 c0                	add    %eax,%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	c1 e0 03             	shl    $0x3,%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8b 00                	mov    (%eax),%eax
  8011aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8011b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	01 c8                	add    %ecx,%eax
  8011c6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8011c8:	39 c2                	cmp    %eax,%edx
  8011ca:	75 09                	jne    8011d5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8011cc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8011d3:	eb 15                	jmp    8011ea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8011d5:	ff 45 e8             	incl   -0x18(%ebp)
  8011d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8011dd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8011e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011e6:	39 c2                	cmp    %eax,%edx
  8011e8:	77 85                	ja     80116f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8011ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ee:	75 14                	jne    801204 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	68 b0 52 80 00       	push   $0x8052b0
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 a4 52 80 00       	push   $0x8052a4
  8011ff:	e8 8d fe ff ff       	call   801091 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801204:	ff 45 f0             	incl   -0x10(%ebp)
  801207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80120d:	0f 8c 2f ff ff ff    	jl     801142 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801213:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80121a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801221:	eb 26                	jmp    801249 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801223:	a1 20 60 80 00       	mov    0x806020,%eax
  801228:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80122e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801231:	89 d0                	mov    %edx,%eax
  801233:	01 c0                	add    %eax,%eax
  801235:	01 d0                	add    %edx,%eax
  801237:	c1 e0 03             	shl    $0x3,%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 40 04             	mov    0x4(%eax),%al
  80123f:	3c 01                	cmp    $0x1,%al
  801241:	75 03                	jne    801246 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801243:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801246:	ff 45 e0             	incl   -0x20(%ebp)
  801249:	a1 20 60 80 00       	mov    0x806020,%eax
  80124e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801257:	39 c2                	cmp    %eax,%edx
  801259:	77 c8                	ja     801223 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801261:	74 14                	je     801277 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	68 04 53 80 00       	push   $0x805304
  80126b:	6a 44                	push   $0x44
  80126d:	68 a4 52 80 00       	push   $0x8052a4
  801272:	e8 1a fe ff ff       	call   801091 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801277:	90                   	nop
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	8b 00                	mov    (%eax),%eax
  801285:	8d 48 01             	lea    0x1(%eax),%ecx
  801288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128b:	89 0a                	mov    %ecx,(%edx)
  80128d:	8b 55 08             	mov    0x8(%ebp),%edx
  801290:	88 d1                	mov    %dl,%cl
  801292:	8b 55 0c             	mov    0xc(%ebp),%edx
  801295:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012a3:	75 2c                	jne    8012d1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8012a5:	a0 40 60 80 00       	mov    0x806040,%al
  8012aa:	0f b6 c0             	movzbl %al,%eax
  8012ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b0:	8b 12                	mov    (%edx),%edx
  8012b2:	89 d1                	mov    %edx,%ecx
  8012b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b7:	83 c2 08             	add    $0x8,%edx
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	50                   	push   %eax
  8012be:	51                   	push   %ecx
  8012bf:	52                   	push   %edx
  8012c0:	e8 26 13 00 00       	call   8025eb <sys_cputs>
  8012c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8b 40 04             	mov    0x4(%eax),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8012e0:	90                   	nop
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8012ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8012f3:	00 00 00 
	b.cnt = 0;
  8012f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8012fd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	ff 75 08             	pushl  0x8(%ebp)
  801306:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	68 7a 12 80 00       	push   $0x80127a
  801312:	e8 11 02 00 00       	call   801528 <vprintfmt>
  801317:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80131a:	a0 40 60 80 00       	mov    0x806040,%al
  80131f:	0f b6 c0             	movzbl %al,%eax
  801322:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801328:	83 ec 04             	sub    $0x4,%esp
  80132b:	50                   	push   %eax
  80132c:	52                   	push   %edx
  80132d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801333:	83 c0 08             	add    $0x8,%eax
  801336:	50                   	push   %eax
  801337:	e8 af 12 00 00       	call   8025eb <sys_cputs>
  80133c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80133f:	c6 05 40 60 80 00 00 	movb   $0x0,0x806040
	return b.cnt;
  801346:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801354:	c6 05 40 60 80 00 01 	movb   $0x1,0x806040
	va_start(ap, fmt);
  80135b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80135e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	ff 75 f4             	pushl  -0xc(%ebp)
  80136a:	50                   	push   %eax
  80136b:	e8 73 ff ff ff       	call   8012e3 <vcprintf>
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801381:	e8 a7 12 00 00       	call   80262d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801386:	8d 45 0c             	lea    0xc(%ebp),%eax
  801389:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	ff 75 f4             	pushl  -0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	e8 48 ff ff ff       	call   8012e3 <vcprintf>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8013a1:	e8 a1 12 00 00       	call   802647 <sys_unlock_cons>
	return cnt;
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	53                   	push   %ebx
  8013af:	83 ec 14             	sub    $0x14,%esp
  8013b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8013be:	8b 45 18             	mov    0x18(%ebp),%eax
  8013c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8013c9:	77 55                	ja     801420 <printnum+0x75>
  8013cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8013ce:	72 05                	jb     8013d5 <printnum+0x2a>
  8013d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d3:	77 4b                	ja     801420 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8013d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8013db:	8b 45 18             	mov    0x18(%ebp),%eax
  8013de:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e3:	52                   	push   %edx
  8013e4:	50                   	push   %eax
  8013e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013eb:	e8 94 32 00 00       	call   804684 <__udivdi3>
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	ff 75 20             	pushl  0x20(%ebp)
  8013f9:	53                   	push   %ebx
  8013fa:	ff 75 18             	pushl  0x18(%ebp)
  8013fd:	52                   	push   %edx
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 a1 ff ff ff       	call   8013ab <printnum>
  80140a:	83 c4 20             	add    $0x20,%esp
  80140d:	eb 1a                	jmp    801429 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	ff 75 20             	pushl  0x20(%ebp)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	ff d0                	call   *%eax
  80141d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801420:	ff 4d 1c             	decl   0x1c(%ebp)
  801423:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801427:	7f e6                	jg     80140f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801429:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80142c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801437:	53                   	push   %ebx
  801438:	51                   	push   %ecx
  801439:	52                   	push   %edx
  80143a:	50                   	push   %eax
  80143b:	e8 54 33 00 00       	call   804794 <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 74 55 80 00       	add    $0x805574,%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	50                   	push   %eax
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	ff d0                	call   *%eax
  801459:	83 c4 10             	add    $0x10,%esp
}
  80145c:	90                   	nop
  80145d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801465:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801469:	7e 1c                	jle    801487 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8b 00                	mov    (%eax),%eax
  801470:	8d 50 08             	lea    0x8(%eax),%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 10                	mov    %edx,(%eax)
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	83 e8 08             	sub    $0x8,%eax
  801480:	8b 50 04             	mov    0x4(%eax),%edx
  801483:	8b 00                	mov    (%eax),%eax
  801485:	eb 40                	jmp    8014c7 <getuint+0x65>
	else if (lflag)
  801487:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148b:	74 1e                	je     8014ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8b 00                	mov    (%eax),%eax
  801492:	8d 50 04             	lea    0x4(%eax),%edx
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	89 10                	mov    %edx,(%eax)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	83 e8 04             	sub    $0x4,%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a9:	eb 1c                	jmp    8014c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8b 00                	mov    (%eax),%eax
  8014b0:	8d 50 04             	lea    0x4(%eax),%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	89 10                	mov    %edx,(%eax)
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8b 00                	mov    (%eax),%eax
  8014bd:	83 e8 04             	sub    $0x4,%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8014cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8014d0:	7e 1c                	jle    8014ee <getint+0x25>
		return va_arg(*ap, long long);
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8b 00                	mov    (%eax),%eax
  8014d7:	8d 50 08             	lea    0x8(%eax),%edx
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	89 10                	mov    %edx,(%eax)
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	83 e8 08             	sub    $0x8,%eax
  8014e7:	8b 50 04             	mov    0x4(%eax),%edx
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	eb 38                	jmp    801526 <getint+0x5d>
	else if (lflag)
  8014ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f2:	74 1a                	je     80150e <getint+0x45>
		return va_arg(*ap, long);
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	8d 50 04             	lea    0x4(%eax),%edx
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 10                	mov    %edx,(%eax)
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	83 e8 04             	sub    $0x4,%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	99                   	cltd   
  80150c:	eb 18                	jmp    801526 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8b 00                	mov    (%eax),%eax
  801513:	8d 50 04             	lea    0x4(%eax),%edx
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	89 10                	mov    %edx,(%eax)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8b 00                	mov    (%eax),%eax
  801520:	83 e8 04             	sub    $0x4,%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	99                   	cltd   
}
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
  80152d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801530:	eb 17                	jmp    801549 <vprintfmt+0x21>
			if (ch == '\0')
  801532:	85 db                	test   %ebx,%ebx
  801534:	0f 84 c1 03 00 00    	je     8018fb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	53                   	push   %ebx
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	ff d0                	call   *%eax
  801546:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	8d 50 01             	lea    0x1(%eax),%edx
  80154f:	89 55 10             	mov    %edx,0x10(%ebp)
  801552:	8a 00                	mov    (%eax),%al
  801554:	0f b6 d8             	movzbl %al,%ebx
  801557:	83 fb 25             	cmp    $0x25,%ebx
  80155a:	75 d6                	jne    801532 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80155c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801560:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801567:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80156e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801575:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80157c:	8b 45 10             	mov    0x10(%ebp),%eax
  80157f:	8d 50 01             	lea    0x1(%eax),%edx
  801582:	89 55 10             	mov    %edx,0x10(%ebp)
  801585:	8a 00                	mov    (%eax),%al
  801587:	0f b6 d8             	movzbl %al,%ebx
  80158a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80158d:	83 f8 5b             	cmp    $0x5b,%eax
  801590:	0f 87 3d 03 00 00    	ja     8018d3 <vprintfmt+0x3ab>
  801596:	8b 04 85 98 55 80 00 	mov    0x805598(,%eax,4),%eax
  80159d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80159f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8015a3:	eb d7                	jmp    80157c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8015a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8015a9:	eb d1                	jmp    80157c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8015b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	01 d8                	add    %ebx,%eax
  8015c0:	83 e8 30             	sub    $0x30,%eax
  8015c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8015ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8015d1:	7e 3e                	jle    801611 <vprintfmt+0xe9>
  8015d3:	83 fb 39             	cmp    $0x39,%ebx
  8015d6:	7f 39                	jg     801611 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8015db:	eb d5                	jmp    8015b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8015dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e0:	83 c0 04             	add    $0x4,%eax
  8015e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8015e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e9:	83 e8 04             	sub    $0x4,%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8015f1:	eb 1f                	jmp    801612 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8015f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015f7:	79 83                	jns    80157c <vprintfmt+0x54>
				width = 0;
  8015f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801600:	e9 77 ff ff ff       	jmp    80157c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801605:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80160c:	e9 6b ff ff ff       	jmp    80157c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801611:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801612:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801616:	0f 89 60 ff ff ff    	jns    80157c <vprintfmt+0x54>
				width = precision, precision = -1;
  80161c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801622:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801629:	e9 4e ff ff ff       	jmp    80157c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80162e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801631:	e9 46 ff ff ff       	jmp    80157c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801636:	8b 45 14             	mov    0x14(%ebp),%eax
  801639:	83 c0 04             	add    $0x4,%eax
  80163c:	89 45 14             	mov    %eax,0x14(%ebp)
  80163f:	8b 45 14             	mov    0x14(%ebp),%eax
  801642:	83 e8 04             	sub    $0x4,%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	50                   	push   %eax
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	ff d0                	call   *%eax
  801653:	83 c4 10             	add    $0x10,%esp
			break;
  801656:	e9 9b 02 00 00       	jmp    8018f6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80165b:	8b 45 14             	mov    0x14(%ebp),%eax
  80165e:	83 c0 04             	add    $0x4,%eax
  801661:	89 45 14             	mov    %eax,0x14(%ebp)
  801664:	8b 45 14             	mov    0x14(%ebp),%eax
  801667:	83 e8 04             	sub    $0x4,%eax
  80166a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80166c:	85 db                	test   %ebx,%ebx
  80166e:	79 02                	jns    801672 <vprintfmt+0x14a>
				err = -err;
  801670:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801672:	83 fb 64             	cmp    $0x64,%ebx
  801675:	7f 0b                	jg     801682 <vprintfmt+0x15a>
  801677:	8b 34 9d e0 53 80 00 	mov    0x8053e0(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 85 55 80 00       	push   $0x805585
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 70 02 00 00       	call   801903 <printfmt>
  801693:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801696:	e9 5b 02 00 00       	jmp    8018f6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80169b:	56                   	push   %esi
  80169c:	68 8e 55 80 00       	push   $0x80558e
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	e8 57 02 00 00       	call   801903 <printfmt>
  8016ac:	83 c4 10             	add    $0x10,%esp
			break;
  8016af:	e9 42 02 00 00       	jmp    8018f6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b7:	83 c0 04             	add    $0x4,%eax
  8016ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8016bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c0:	83 e8 04             	sub    $0x4,%eax
  8016c3:	8b 30                	mov    (%eax),%esi
  8016c5:	85 f6                	test   %esi,%esi
  8016c7:	75 05                	jne    8016ce <vprintfmt+0x1a6>
				p = "(null)";
  8016c9:	be 91 55 80 00       	mov    $0x805591,%esi
			if (width > 0 && padc != '-')
  8016ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016d2:	7e 6d                	jle    801741 <vprintfmt+0x219>
  8016d4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8016d8:	74 67                	je     801741 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8016da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	50                   	push   %eax
  8016e1:	56                   	push   %esi
  8016e2:	e8 1e 03 00 00       	call   801a05 <strnlen>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8016ed:	eb 16                	jmp    801705 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8016ef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	ff d0                	call   *%eax
  8016ff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801702:	ff 4d e4             	decl   -0x1c(%ebp)
  801705:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801709:	7f e4                	jg     8016ef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80170b:	eb 34                	jmp    801741 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80170d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801711:	74 1c                	je     80172f <vprintfmt+0x207>
  801713:	83 fb 1f             	cmp    $0x1f,%ebx
  801716:	7e 05                	jle    80171d <vprintfmt+0x1f5>
  801718:	83 fb 7e             	cmp    $0x7e,%ebx
  80171b:	7e 12                	jle    80172f <vprintfmt+0x207>
					putch('?', putdat);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	ff 75 0c             	pushl  0xc(%ebp)
  801723:	6a 3f                	push   $0x3f
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	ff d0                	call   *%eax
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	eb 0f                	jmp    80173e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	53                   	push   %ebx
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	ff d0                	call   *%eax
  80173b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80173e:	ff 4d e4             	decl   -0x1c(%ebp)
  801741:	89 f0                	mov    %esi,%eax
  801743:	8d 70 01             	lea    0x1(%eax),%esi
  801746:	8a 00                	mov    (%eax),%al
  801748:	0f be d8             	movsbl %al,%ebx
  80174b:	85 db                	test   %ebx,%ebx
  80174d:	74 24                	je     801773 <vprintfmt+0x24b>
  80174f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801753:	78 b8                	js     80170d <vprintfmt+0x1e5>
  801755:	ff 4d e0             	decl   -0x20(%ebp)
  801758:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175c:	79 af                	jns    80170d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80175e:	eb 13                	jmp    801773 <vprintfmt+0x24b>
				putch(' ', putdat);
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	6a 20                	push   $0x20
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	ff d0                	call   *%eax
  80176d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801770:	ff 4d e4             	decl   -0x1c(%ebp)
  801773:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801777:	7f e7                	jg     801760 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801779:	e9 78 01 00 00       	jmp    8018f6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 e8             	pushl  -0x18(%ebp)
  801784:	8d 45 14             	lea    0x14(%ebp),%eax
  801787:	50                   	push   %eax
  801788:	e8 3c fd ff ff       	call   8014c9 <getint>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801793:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179c:	85 d2                	test   %edx,%edx
  80179e:	79 23                	jns    8017c3 <vprintfmt+0x29b>
				putch('-', putdat);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	6a 2d                	push   $0x2d
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	ff d0                	call   *%eax
  8017ad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b6:	f7 d8                	neg    %eax
  8017b8:	83 d2 00             	adc    $0x0,%edx
  8017bb:	f7 da                	neg    %edx
  8017bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8017c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8017ca:	e9 bc 00 00 00       	jmp    80188b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8017d8:	50                   	push   %eax
  8017d9:	e8 84 fc ff ff       	call   801462 <getuint>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8017e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8017ee:	e9 98 00 00 00       	jmp    80188b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	6a 58                	push   $0x58
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	ff d0                	call   *%eax
  801800:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	6a 58                	push   $0x58
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	ff d0                	call   *%eax
  801810:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	6a 58                	push   $0x58
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	ff d0                	call   *%eax
  801820:	83 c4 10             	add    $0x10,%esp
			break;
  801823:	e9 ce 00 00 00       	jmp    8018f6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801828:	83 ec 08             	sub    $0x8,%esp
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	6a 30                	push   $0x30
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	ff d0                	call   *%eax
  801835:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	6a 78                	push   $0x78
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	ff d0                	call   *%eax
  801845:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801848:	8b 45 14             	mov    0x14(%ebp),%eax
  80184b:	83 c0 04             	add    $0x4,%eax
  80184e:	89 45 14             	mov    %eax,0x14(%ebp)
  801851:	8b 45 14             	mov    0x14(%ebp),%eax
  801854:	83 e8 04             	sub    $0x4,%eax
  801857:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801859:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801863:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80186a:	eb 1f                	jmp    80188b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	ff 75 e8             	pushl  -0x18(%ebp)
  801872:	8d 45 14             	lea    0x14(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	e8 e7 fb ff ff       	call   801462 <getuint>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801881:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801884:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80188b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80188f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801892:	83 ec 04             	sub    $0x4,%esp
  801895:	52                   	push   %edx
  801896:	ff 75 e4             	pushl  -0x1c(%ebp)
  801899:	50                   	push   %eax
  80189a:	ff 75 f4             	pushl  -0xc(%ebp)
  80189d:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	e8 00 fb ff ff       	call   8013ab <printnum>
  8018ab:	83 c4 20             	add    $0x20,%esp
			break;
  8018ae:	eb 46                	jmp    8018f6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	53                   	push   %ebx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	ff d0                	call   *%eax
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	eb 35                	jmp    8018f6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8018c1:	c6 05 40 60 80 00 00 	movb   $0x0,0x806040
			break;
  8018c8:	eb 2c                	jmp    8018f6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8018ca:	c6 05 40 60 80 00 01 	movb   $0x1,0x806040
			break;
  8018d1:	eb 23                	jmp    8018f6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	6a 25                	push   $0x25
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	ff d0                	call   *%eax
  8018e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018e3:	ff 4d 10             	decl   0x10(%ebp)
  8018e6:	eb 03                	jmp    8018eb <vprintfmt+0x3c3>
  8018e8:	ff 4d 10             	decl   0x10(%ebp)
  8018eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ee:	48                   	dec    %eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	3c 25                	cmp    $0x25,%al
  8018f3:	75 f3                	jne    8018e8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8018f5:	90                   	nop
		}
	}
  8018f6:	e9 35 fc ff ff       	jmp    801530 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8018fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801909:	8d 45 10             	lea    0x10(%ebp),%eax
  80190c:	83 c0 04             	add    $0x4,%eax
  80190f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801912:	8b 45 10             	mov    0x10(%ebp),%eax
  801915:	ff 75 f4             	pushl  -0xc(%ebp)
  801918:	50                   	push   %eax
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 04 fc ff ff       	call   801528 <vprintfmt>
  801924:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	8b 40 08             	mov    0x8(%eax),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	8b 10                	mov    (%eax),%edx
  801941:	8b 45 0c             	mov    0xc(%ebp),%eax
  801944:	8b 40 04             	mov    0x4(%eax),%eax
  801947:	39 c2                	cmp    %eax,%edx
  801949:	73 12                	jae    80195d <sprintputch+0x33>
		*b->buf++ = ch;
  80194b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	8d 48 01             	lea    0x1(%eax),%ecx
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	89 0a                	mov    %ecx,(%edx)
  801958:	8b 55 08             	mov    0x8(%ebp),%edx
  80195b:	88 10                	mov    %dl,(%eax)
}
  80195d:	90                   	nop
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80197a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801981:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801985:	74 06                	je     80198d <vsnprintf+0x2d>
  801987:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80198b:	7f 07                	jg     801994 <vsnprintf+0x34>
		return -E_INVAL;
  80198d:	b8 03 00 00 00       	mov    $0x3,%eax
  801992:	eb 20                	jmp    8019b4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801994:	ff 75 14             	pushl  0x14(%ebp)
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	68 2a 19 80 00       	push   $0x80192a
  8019a3:	e8 80 fb ff ff       	call   801528 <vprintfmt>
  8019a8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8019bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8019bf:	83 c0 04             	add    $0x4,%eax
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8019c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	e8 89 ff ff ff       	call   801960 <vsnprintf>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8019e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019ef:	eb 06                	jmp    8019f7 <strlen+0x15>
		n++;
  8019f1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8019f4:	ff 45 08             	incl   0x8(%ebp)
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	84 c0                	test   %al,%al
  8019fe:	75 f1                	jne    8019f1 <strlen+0xf>
		n++;
	return n;
  801a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a12:	eb 09                	jmp    801a1d <strnlen+0x18>
		n++;
  801a14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a17:	ff 45 08             	incl   0x8(%ebp)
  801a1a:	ff 4d 0c             	decl   0xc(%ebp)
  801a1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a21:	74 09                	je     801a2c <strnlen+0x27>
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8a 00                	mov    (%eax),%al
  801a28:	84 c0                	test   %al,%al
  801a2a:	75 e8                	jne    801a14 <strnlen+0xf>
		n++;
	return n;
  801a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801a3d:	90                   	nop
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8d 50 01             	lea    0x1(%eax),%edx
  801a44:	89 55 08             	mov    %edx,0x8(%ebp)
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801a50:	8a 12                	mov    (%edx),%dl
  801a52:	88 10                	mov    %dl,(%eax)
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	84 c0                	test   %al,%al
  801a58:	75 e4                	jne    801a3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  801a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801a6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a72:	eb 1f                	jmp    801a93 <strncpy+0x34>
		*dst++ = *src;
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8d 50 01             	lea    0x1(%eax),%edx
  801a7a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8a 12                	mov    (%edx),%dl
  801a82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	8a 00                	mov    (%eax),%al
  801a89:	84 c0                	test   %al,%al
  801a8b:	74 03                	je     801a90 <strncpy+0x31>
			src++;
  801a8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a90:	ff 45 fc             	incl   -0x4(%ebp)
  801a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a96:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a99:	72 d9                	jb     801a74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801aac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab0:	74 30                	je     801ae2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801ab2:	eb 16                	jmp    801aca <strlcpy+0x2a>
			*dst++ = *src++;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8d 50 01             	lea    0x1(%eax),%edx
  801aba:	89 55 08             	mov    %edx,0x8(%ebp)
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ac3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ac6:	8a 12                	mov    (%edx),%dl
  801ac8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801aca:	ff 4d 10             	decl   0x10(%ebp)
  801acd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad1:	74 09                	je     801adc <strlcpy+0x3c>
  801ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	84 c0                	test   %al,%al
  801ada:	75 d8                	jne    801ab4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae8:	29 c2                	sub    %eax,%edx
  801aea:	89 d0                	mov    %edx,%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801af1:	eb 06                	jmp    801af9 <strcmp+0xb>
		p++, q++;
  801af3:	ff 45 08             	incl   0x8(%ebp)
  801af6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	8a 00                	mov    (%eax),%al
  801afe:	84 c0                	test   %al,%al
  801b00:	74 0e                	je     801b10 <strcmp+0x22>
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	8a 10                	mov    (%eax),%dl
  801b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	38 c2                	cmp    %al,%dl
  801b0e:	74 e3                	je     801af3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	8a 00                	mov    (%eax),%al
  801b15:	0f b6 d0             	movzbl %al,%edx
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	8a 00                	mov    (%eax),%al
  801b1d:	0f b6 c0             	movzbl %al,%eax
  801b20:	29 c2                	sub    %eax,%edx
  801b22:	89 d0                	mov    %edx,%eax
}
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801b29:	eb 09                	jmp    801b34 <strncmp+0xe>
		n--, p++, q++;
  801b2b:	ff 4d 10             	decl   0x10(%ebp)
  801b2e:	ff 45 08             	incl   0x8(%ebp)
  801b31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801b34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b38:	74 17                	je     801b51 <strncmp+0x2b>
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8a 00                	mov    (%eax),%al
  801b3f:	84 c0                	test   %al,%al
  801b41:	74 0e                	je     801b51 <strncmp+0x2b>
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 10                	mov    (%eax),%dl
  801b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4b:	8a 00                	mov    (%eax),%al
  801b4d:	38 c2                	cmp    %al,%dl
  801b4f:	74 da                	je     801b2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801b51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b55:	75 07                	jne    801b5e <strncmp+0x38>
		return 0;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	eb 14                	jmp    801b72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	8a 00                	mov    (%eax),%al
  801b63:	0f b6 d0             	movzbl %al,%edx
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	8a 00                	mov    (%eax),%al
  801b6b:	0f b6 c0             	movzbl %al,%eax
  801b6e:	29 c2                	sub    %eax,%edx
  801b70:	89 d0                	mov    %edx,%eax
}
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    

00801b74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801b80:	eb 12                	jmp    801b94 <strchr+0x20>
		if (*s == c)
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	8a 00                	mov    (%eax),%al
  801b87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801b8a:	75 05                	jne    801b91 <strchr+0x1d>
			return (char *) s;
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	eb 11                	jmp    801ba2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b91:	ff 45 08             	incl   0x8(%ebp)
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8a 00                	mov    (%eax),%al
  801b99:	84 c0                	test   %al,%al
  801b9b:	75 e5                	jne    801b82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801bb0:	eb 0d                	jmp    801bbf <strfind+0x1b>
		if (*s == c)
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	8a 00                	mov    (%eax),%al
  801bb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801bba:	74 0e                	je     801bca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801bbc:	ff 45 08             	incl   0x8(%ebp)
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	8a 00                	mov    (%eax),%al
  801bc4:	84 c0                	test   %al,%al
  801bc6:	75 ea                	jne    801bb2 <strfind+0xe>
  801bc8:	eb 01                	jmp    801bcb <strfind+0x27>
		if (*s == c)
			break;
  801bca:	90                   	nop
	return (char *) s;
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801be2:	eb 0e                	jmp    801bf2 <memset+0x22>
		*p++ = c;
  801be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be7:	8d 50 01             	lea    0x1(%eax),%edx
  801bea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801bf2:	ff 4d f8             	decl   -0x8(%ebp)
  801bf5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801bf9:	79 e9                	jns    801be4 <memset+0x14>
		*p++ = c;

	return v;
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801c12:	eb 16                	jmp    801c2a <memcpy+0x2a>
		*d++ = *s++;
  801c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c26:	8a 12                	mov    (%edx),%dl
  801c28:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c30:	89 55 10             	mov    %edx,0x10(%ebp)
  801c33:	85 c0                	test   %eax,%eax
  801c35:	75 dd                	jne    801c14 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c54:	73 50                	jae    801ca6 <memmove+0x6a>
  801c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c59:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5c:	01 d0                	add    %edx,%eax
  801c5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c61:	76 43                	jbe    801ca6 <memmove+0x6a>
		s += n;
  801c63:	8b 45 10             	mov    0x10(%ebp),%eax
  801c66:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801c6f:	eb 10                	jmp    801c81 <memmove+0x45>
			*--d = *--s;
  801c71:	ff 4d f8             	decl   -0x8(%ebp)
  801c74:	ff 4d fc             	decl   -0x4(%ebp)
  801c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c7a:	8a 10                	mov    (%eax),%dl
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801c81:	8b 45 10             	mov    0x10(%ebp),%eax
  801c84:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c87:	89 55 10             	mov    %edx,0x10(%ebp)
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 e3                	jne    801c71 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801c8e:	eb 23                	jmp    801cb3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c93:	8d 50 01             	lea    0x1(%eax),%edx
  801c96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ca2:	8a 12                	mov    (%edx),%dl
  801ca4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ca6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cac:	89 55 10             	mov    %edx,0x10(%ebp)
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	75 dd                	jne    801c90 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801cca:	eb 2a                	jmp    801cf6 <memcmp+0x3e>
		if (*s1 != *s2)
  801ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ccf:	8a 10                	mov    (%eax),%dl
  801cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	38 c2                	cmp    %al,%dl
  801cd8:	74 16                	je     801cf0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cdd:	8a 00                	mov    (%eax),%al
  801cdf:	0f b6 d0             	movzbl %al,%edx
  801ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	0f b6 c0             	movzbl %al,%eax
  801cea:	29 c2                	sub    %eax,%edx
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	eb 18                	jmp    801d08 <memcmp+0x50>
		s1++, s2++;
  801cf0:	ff 45 fc             	incl   -0x4(%ebp)
  801cf3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cfc:	89 55 10             	mov    %edx,0x10(%ebp)
  801cff:	85 c0                	test   %eax,%eax
  801d01:	75 c9                	jne    801ccc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801d10:	8b 55 08             	mov    0x8(%ebp),%edx
  801d13:	8b 45 10             	mov    0x10(%ebp),%eax
  801d16:	01 d0                	add    %edx,%eax
  801d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801d1b:	eb 15                	jmp    801d32 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8a 00                	mov    (%eax),%al
  801d22:	0f b6 d0             	movzbl %al,%edx
  801d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d28:	0f b6 c0             	movzbl %al,%eax
  801d2b:	39 c2                	cmp    %eax,%edx
  801d2d:	74 0d                	je     801d3c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801d2f:	ff 45 08             	incl   0x8(%ebp)
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d38:	72 e3                	jb     801d1d <memfind+0x13>
  801d3a:	eb 01                	jmp    801d3d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801d3c:	90                   	nop
	return (void *) s;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801d4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d56:	eb 03                	jmp    801d5b <strtol+0x19>
		s++;
  801d58:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8a 00                	mov    (%eax),%al
  801d60:	3c 20                	cmp    $0x20,%al
  801d62:	74 f4                	je     801d58 <strtol+0x16>
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	3c 09                	cmp    $0x9,%al
  801d6b:	74 eb                	je     801d58 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	8a 00                	mov    (%eax),%al
  801d72:	3c 2b                	cmp    $0x2b,%al
  801d74:	75 05                	jne    801d7b <strtol+0x39>
		s++;
  801d76:	ff 45 08             	incl   0x8(%ebp)
  801d79:	eb 13                	jmp    801d8e <strtol+0x4c>
	else if (*s == '-')
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	8a 00                	mov    (%eax),%al
  801d80:	3c 2d                	cmp    $0x2d,%al
  801d82:	75 0a                	jne    801d8e <strtol+0x4c>
		s++, neg = 1;
  801d84:	ff 45 08             	incl   0x8(%ebp)
  801d87:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d92:	74 06                	je     801d9a <strtol+0x58>
  801d94:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801d98:	75 20                	jne    801dba <strtol+0x78>
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	8a 00                	mov    (%eax),%al
  801d9f:	3c 30                	cmp    $0x30,%al
  801da1:	75 17                	jne    801dba <strtol+0x78>
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	40                   	inc    %eax
  801da7:	8a 00                	mov    (%eax),%al
  801da9:	3c 78                	cmp    $0x78,%al
  801dab:	75 0d                	jne    801dba <strtol+0x78>
		s += 2, base = 16;
  801dad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801db1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801db8:	eb 28                	jmp    801de2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dbe:	75 15                	jne    801dd5 <strtol+0x93>
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	8a 00                	mov    (%eax),%al
  801dc5:	3c 30                	cmp    $0x30,%al
  801dc7:	75 0c                	jne    801dd5 <strtol+0x93>
		s++, base = 8;
  801dc9:	ff 45 08             	incl   0x8(%ebp)
  801dcc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801dd3:	eb 0d                	jmp    801de2 <strtol+0xa0>
	else if (base == 0)
  801dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dd9:	75 07                	jne    801de2 <strtol+0xa0>
		base = 10;
  801ddb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	8a 00                	mov    (%eax),%al
  801de7:	3c 2f                	cmp    $0x2f,%al
  801de9:	7e 19                	jle    801e04 <strtol+0xc2>
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	8a 00                	mov    (%eax),%al
  801df0:	3c 39                	cmp    $0x39,%al
  801df2:	7f 10                	jg     801e04 <strtol+0xc2>
			dig = *s - '0';
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	8a 00                	mov    (%eax),%al
  801df9:	0f be c0             	movsbl %al,%eax
  801dfc:	83 e8 30             	sub    $0x30,%eax
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e02:	eb 42                	jmp    801e46 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	8a 00                	mov    (%eax),%al
  801e09:	3c 60                	cmp    $0x60,%al
  801e0b:	7e 19                	jle    801e26 <strtol+0xe4>
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	8a 00                	mov    (%eax),%al
  801e12:	3c 7a                	cmp    $0x7a,%al
  801e14:	7f 10                	jg     801e26 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	8a 00                	mov    (%eax),%al
  801e1b:	0f be c0             	movsbl %al,%eax
  801e1e:	83 e8 57             	sub    $0x57,%eax
  801e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e24:	eb 20                	jmp    801e46 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	8a 00                	mov    (%eax),%al
  801e2b:	3c 40                	cmp    $0x40,%al
  801e2d:	7e 39                	jle    801e68 <strtol+0x126>
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8a 00                	mov    (%eax),%al
  801e34:	3c 5a                	cmp    $0x5a,%al
  801e36:	7f 30                	jg     801e68 <strtol+0x126>
			dig = *s - 'A' + 10;
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	8a 00                	mov    (%eax),%al
  801e3d:	0f be c0             	movsbl %al,%eax
  801e40:	83 e8 37             	sub    $0x37,%eax
  801e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e4c:	7d 19                	jge    801e67 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801e4e:	ff 45 08             	incl   0x8(%ebp)
  801e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e54:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e58:	89 c2                	mov    %eax,%edx
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	01 d0                	add    %edx,%eax
  801e5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801e62:	e9 7b ff ff ff       	jmp    801de2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801e67:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6c:	74 08                	je     801e76 <strtol+0x134>
		*endptr = (char *) s;
  801e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e71:	8b 55 08             	mov    0x8(%ebp),%edx
  801e74:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e7a:	74 07                	je     801e83 <strtol+0x141>
  801e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7f:	f7 d8                	neg    %eax
  801e81:	eb 03                	jmp    801e86 <strtol+0x144>
  801e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <ltostr>:

void
ltostr(long value, char *str)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801e8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801e95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801e9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea0:	79 13                	jns    801eb5 <ltostr+0x2d>
	{
		neg = 1;
  801ea2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801eaf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801eb2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801ebd:	99                   	cltd   
  801ebe:	f7 f9                	idiv   %ecx
  801ec0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ec6:	8d 50 01             	lea    0x1(%eax),%edx
  801ec9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ecc:	89 c2                	mov    %eax,%edx
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed6:	83 c2 30             	add    $0x30,%edx
  801ed9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ede:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ee3:	f7 e9                	imul   %ecx
  801ee5:	c1 fa 02             	sar    $0x2,%edx
  801ee8:	89 c8                	mov    %ecx,%eax
  801eea:	c1 f8 1f             	sar    $0x1f,%eax
  801eed:	29 c2                	sub    %eax,%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef8:	75 bb                	jne    801eb5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801efa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f04:	48                   	dec    %eax
  801f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f0c:	74 3d                	je     801f4b <ltostr+0xc3>
		start = 1 ;
  801f0e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801f15:	eb 34                	jmp    801f4b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	8a 00                	mov    (%eax),%al
  801f21:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	01 c2                	add    %eax,%edx
  801f2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f32:	01 c8                	add    %ecx,%eax
  801f34:	8a 00                	mov    (%eax),%al
  801f36:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801f38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3e:	01 c2                	add    %eax,%edx
  801f40:	8a 45 eb             	mov    -0x15(%ebp),%al
  801f43:	88 02                	mov    %al,(%edx)
		start++ ;
  801f45:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801f48:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f51:	7c c4                	jl     801f17 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801f53:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801f67:	ff 75 08             	pushl  0x8(%ebp)
  801f6a:	e8 73 fa ff ff       	call   8019e2 <strlen>
  801f6f:	83 c4 04             	add    $0x4,%esp
  801f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801f75:	ff 75 0c             	pushl  0xc(%ebp)
  801f78:	e8 65 fa ff ff       	call   8019e2 <strlen>
  801f7d:	83 c4 04             	add    $0x4,%esp
  801f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f91:	eb 17                	jmp    801faa <strcconcat+0x49>
		final[s] = str1[s] ;
  801f93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f96:	8b 45 10             	mov    0x10(%ebp),%eax
  801f99:	01 c2                	add    %eax,%edx
  801f9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	01 c8                	add    %ecx,%eax
  801fa3:	8a 00                	mov    (%eax),%al
  801fa5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801fa7:	ff 45 fc             	incl   -0x4(%ebp)
  801faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fb0:	7c e1                	jl     801f93 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801fb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801fc0:	eb 1f                	jmp    801fe1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc5:	8d 50 01             	lea    0x1(%eax),%edx
  801fc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801fcb:	89 c2                	mov    %eax,%edx
  801fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd0:	01 c2                	add    %eax,%edx
  801fd2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	01 c8                	add    %ecx,%eax
  801fda:	8a 00                	mov    (%eax),%al
  801fdc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801fde:	ff 45 f8             	incl   -0x8(%ebp)
  801fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fe4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fe7:	7c d9                	jl     801fc2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fec:	8b 45 10             	mov    0x10(%ebp),%eax
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	c6 00 00             	movb   $0x0,(%eax)
}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ffa:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802003:	8b 45 14             	mov    0x14(%ebp),%eax
  802006:	8b 00                	mov    (%eax),%eax
  802008:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80200f:	8b 45 10             	mov    0x10(%ebp),%eax
  802012:	01 d0                	add    %edx,%eax
  802014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80201a:	eb 0c                	jmp    802028 <strsplit+0x31>
			*string++ = 0;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	8d 50 01             	lea    0x1(%eax),%edx
  802022:	89 55 08             	mov    %edx,0x8(%ebp)
  802025:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	8a 00                	mov    (%eax),%al
  80202d:	84 c0                	test   %al,%al
  80202f:	74 18                	je     802049 <strsplit+0x52>
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	8a 00                	mov    (%eax),%al
  802036:	0f be c0             	movsbl %al,%eax
  802039:	50                   	push   %eax
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	e8 32 fb ff ff       	call   801b74 <strchr>
  802042:	83 c4 08             	add    $0x8,%esp
  802045:	85 c0                	test   %eax,%eax
  802047:	75 d3                	jne    80201c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	84 c0                	test   %al,%al
  802050:	74 5a                	je     8020ac <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802052:	8b 45 14             	mov    0x14(%ebp),%eax
  802055:	8b 00                	mov    (%eax),%eax
  802057:	83 f8 0f             	cmp    $0xf,%eax
  80205a:	75 07                	jne    802063 <strsplit+0x6c>
		{
			return 0;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	eb 66                	jmp    8020c9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802063:	8b 45 14             	mov    0x14(%ebp),%eax
  802066:	8b 00                	mov    (%eax),%eax
  802068:	8d 48 01             	lea    0x1(%eax),%ecx
  80206b:	8b 55 14             	mov    0x14(%ebp),%edx
  80206e:	89 0a                	mov    %ecx,(%edx)
  802070:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802077:	8b 45 10             	mov    0x10(%ebp),%eax
  80207a:	01 c2                	add    %eax,%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802081:	eb 03                	jmp    802086 <strsplit+0x8f>
			string++;
  802083:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	84 c0                	test   %al,%al
  80208d:	74 8b                	je     80201a <strsplit+0x23>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8a 00                	mov    (%eax),%al
  802094:	0f be c0             	movsbl %al,%eax
  802097:	50                   	push   %eax
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	e8 d4 fa ff ff       	call   801b74 <strchr>
  8020a0:	83 c4 08             	add    $0x8,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	74 dc                	je     802083 <strsplit+0x8c>
			string++;
	}
  8020a7:	e9 6e ff ff ff       	jmp    80201a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8020ac:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8020ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8020c4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	68 08 57 80 00       	push   $0x805708
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 2a 57 80 00       	push   $0x80572a
  8020e3:	e8 a9 ef ff ff       	call   801091 <_panic>

008020e8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	ff 75 08             	pushl  0x8(%ebp)
  8020f4:	e8 9d 0a 00 00       	call   802b96 <sys_sbrk>
  8020f9:	83 c4 10             	add    $0x10,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802108:	75 0a                	jne    802114 <malloc+0x16>
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	e9 07 02 00 00       	jmp    80231b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  802114:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80211b:	8b 55 08             	mov    0x8(%ebp),%edx
  80211e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802121:	01 d0                	add    %edx,%eax
  802123:	48                   	dec    %eax
  802124:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802127:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80212a:	ba 00 00 00 00       	mov    $0x0,%edx
  80212f:	f7 75 dc             	divl   -0x24(%ebp)
  802132:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802135:	29 d0                	sub    %edx,%eax
  802137:	c1 e8 0c             	shr    $0xc,%eax
  80213a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80213d:	a1 20 60 80 00       	mov    0x806020,%eax
  802142:	8b 40 78             	mov    0x78(%eax),%eax
  802145:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80214a:	29 c2                	sub    %eax,%edx
  80214c:	89 d0                	mov    %edx,%eax
  80214e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802151:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802154:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802159:	c1 e8 0c             	shr    $0xc,%eax
  80215c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80215f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802166:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80216d:	77 42                	ja     8021b1 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80216f:	e8 a6 08 00 00       	call   802a1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 e6 0d 00 00       	call   802f69 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 b8 08 00 00       	call   802a4b <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 7f 12 00 00       	call   803425 <alloc_block_BF>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	e9 67 01 00 00       	jmp    802318 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8021b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021b4:	48                   	dec    %eax
  8021b5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8021b8:	0f 86 53 01 00 00    	jbe    802311 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8021be:	a1 20 60 80 00       	mov    0x806020,%eax
  8021c3:	8b 40 78             	mov    0x78(%eax),%eax
  8021c6:	05 00 10 00 00       	add    $0x1000,%eax
  8021cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8021ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8021d5:	e9 de 00 00 00       	jmp    8022b8 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8021da:	a1 20 60 80 00       	mov    0x806020,%eax
  8021df:	8b 40 78             	mov    0x78(%eax),%eax
  8021e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e5:	29 c2                	sub    %eax,%edx
  8021e7:	89 d0                	mov    %edx,%eax
  8021e9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021ee:	c1 e8 0c             	shr    $0xc,%eax
  8021f1:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	0f 85 ab 00 00 00    	jne    8022ab <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	05 00 10 00 00       	add    $0x1000,%eax
  802208:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80220b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  802212:	eb 47                	jmp    80225b <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  802214:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80221b:	76 0a                	jbe    802227 <malloc+0x129>
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
  802222:	e9 f4 00 00 00       	jmp    80231b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  802227:	a1 20 60 80 00       	mov    0x806020,%eax
  80222c:	8b 40 78             	mov    0x78(%eax),%eax
  80222f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802232:	29 c2                	sub    %eax,%edx
  802234:	89 d0                	mov    %edx,%eax
  802236:	2d 00 10 00 00       	sub    $0x1000,%eax
  80223b:	c1 e8 0c             	shr    $0xc,%eax
  80223e:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 08                	je     802251 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  802249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80224c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80224f:	eb 5a                	jmp    8022ab <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802251:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  802258:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80225b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80225e:	48                   	dec    %eax
  80225f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802262:	77 b0                	ja     802214 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  802264:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80226b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802272:	eb 2f                	jmp    8022a3 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  802274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802277:	c1 e0 0c             	shl    $0xc,%eax
  80227a:	89 c2                	mov    %eax,%edx
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	01 c2                	add    %eax,%edx
  802281:	a1 20 60 80 00       	mov    0x806020,%eax
  802286:	8b 40 78             	mov    0x78(%eax),%eax
  802289:	29 c2                	sub    %eax,%edx
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802292:	c1 e8 0c             	shr    $0xc,%eax
  802295:	c7 04 85 60 a2 80 00 	movl   $0x1,0x80a260(,%eax,4)
  80229c:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8022a0:	ff 45 e0             	incl   -0x20(%ebp)
  8022a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8022a9:	72 c9                	jb     802274 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8022ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022af:	75 16                	jne    8022c7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8022b1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8022b8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8022bf:	0f 86 15 ff ff ff    	jbe    8021da <malloc+0xdc>
  8022c5:	eb 01                	jmp    8022c8 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8022c7:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8022c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022cc:	75 07                	jne    8022d5 <malloc+0x1d7>
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 46                	jmp    80231b <malloc+0x21d>
		ptr = (void*)i;
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8022db:	a1 20 60 80 00       	mov    0x806020,%eax
  8022e0:	8b 40 78             	mov    0x78(%eax),%eax
  8022e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e6:	29 c2                	sub    %eax,%edx
  8022e8:	89 d0                	mov    %edx,%eax
  8022ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8022ef:	c1 e8 0c             	shr    $0xc,%eax
  8022f2:	89 c2                	mov    %eax,%edx
  8022f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f7:	89 04 95 60 a2 88 00 	mov    %eax,0x88a260(,%edx,4)
		sys_allocate_user_mem(i, size);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	ff 75 f0             	pushl  -0x10(%ebp)
  802307:	e8 c1 08 00 00       	call   802bcd <sys_allocate_user_mem>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	eb 07                	jmp    802318 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	eb 03                	jmp    80231b <malloc+0x21d>
	}
	return ptr;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  802323:	a1 20 60 80 00       	mov    0x806020,%eax
  802328:	8b 40 78             	mov    0x78(%eax),%eax
  80232b:	05 00 10 00 00       	add    $0x1000,%eax
  802330:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  802333:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80233a:	a1 20 60 80 00       	mov    0x806020,%eax
  80233f:	8b 50 78             	mov    0x78(%eax),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	76 24                	jbe    80236d <free+0x50>
		size = get_block_size(va);
  802349:	83 ec 0c             	sub    $0xc,%esp
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	e8 95 08 00 00       	call   802be9 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 c8 1a 00 00       	call   803e2d <free_block>
  802365:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802368:	e9 ac 00 00 00       	jmp    802419 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802373:	0f 82 89 00 00 00    	jb     802402 <free+0xe5>
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802381:	77 7f                	ja     802402 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  802383:	8b 55 08             	mov    0x8(%ebp),%edx
  802386:	a1 20 60 80 00       	mov    0x806020,%eax
  80238b:	8b 40 78             	mov    0x78(%eax),%eax
  80238e:	29 c2                	sub    %eax,%edx
  802390:	89 d0                	mov    %edx,%eax
  802392:	2d 00 10 00 00       	sub    $0x1000,%eax
  802397:	c1 e8 0c             	shr    $0xc,%eax
  80239a:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
  8023a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8023a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a7:	c1 e0 0c             	shl    $0xc,%eax
  8023aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8023ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023b4:	eb 2f                	jmp    8023e5 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	c1 e0 0c             	shl    $0xc,%eax
  8023bc:	89 c2                	mov    %eax,%edx
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	01 c2                	add    %eax,%edx
  8023c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8023c8:	8b 40 78             	mov    0x78(%eax),%eax
  8023cb:	29 c2                	sub    %eax,%edx
  8023cd:	89 d0                	mov    %edx,%eax
  8023cf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023d4:	c1 e8 0c             	shr    $0xc,%eax
  8023d7:	c7 04 85 60 a2 80 00 	movl   $0x0,0x80a260(,%eax,4)
  8023de:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8023e2:	ff 45 f4             	incl   -0xc(%ebp)
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8023eb:	72 c9                	jb     8023b6 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	83 ec 08             	sub    $0x8,%esp
  8023f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8023f6:	50                   	push   %eax
  8023f7:	e8 b5 07 00 00       	call   802bb1 <sys_free_user_mem>
  8023fc:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8023ff:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802400:	eb 17                	jmp    802419 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 38 57 80 00       	push   $0x805738
  80240a:	68 84 00 00 00       	push   $0x84
  80240f:	68 62 57 80 00       	push   $0x805762
  802414:	e8 78 ec ff ff       	call   801091 <_panic>
	}
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 28             	sub    $0x28,%esp
  802421:	8b 45 10             	mov    0x10(%ebp),%eax
  802424:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80242b:	75 07                	jne    802434 <smalloc+0x19>
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	eb 74                	jmp    8024a8 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802434:	8b 45 0c             	mov    0xc(%ebp),%eax
  802437:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	39 d0                	cmp    %edx,%eax
  802449:	73 02                	jae    80244d <smalloc+0x32>
  80244b:	89 d0                	mov    %edx,%eax
  80244d:	83 ec 0c             	sub    $0xc,%esp
  802450:	50                   	push   %eax
  802451:	e8 a8 fc ff ff       	call   8020fe <malloc>
  802456:	83 c4 10             	add    $0x10,%esp
  802459:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80245c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802460:	75 07                	jne    802469 <smalloc+0x4e>
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	eb 3f                	jmp    8024a8 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802469:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80246d:	ff 75 ec             	pushl  -0x14(%ebp)
  802470:	50                   	push   %eax
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	e8 3c 03 00 00       	call   8027b8 <sys_createSharedObject>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802482:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802486:	74 06                	je     80248e <smalloc+0x73>
  802488:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80248c:	75 07                	jne    802495 <smalloc+0x7a>
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	eb 13                	jmp    8024a8 <smalloc+0x8d>
	 cprintf("153\n");
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	68 6e 57 80 00       	push   $0x80576e
  80249d:	e8 ac ee ff ff       	call   80134e <cprintf>
  8024a2:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8024b0:	83 ec 08             	sub    $0x8,%esp
  8024b3:	ff 75 0c             	pushl  0xc(%ebp)
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	e8 24 03 00 00       	call   8027e2 <sys_getSizeOfSharedObject>
  8024be:	83 c4 10             	add    $0x10,%esp
  8024c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8024c4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024c8:	75 07                	jne    8024d1 <sget+0x27>
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	eb 5c                	jmp    80252d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	39 d0                	cmp    %edx,%eax
  8024e6:	7d 02                	jge    8024ea <sget+0x40>
  8024e8:	89 d0                	mov    %edx,%eax
  8024ea:	83 ec 0c             	sub    $0xc,%esp
  8024ed:	50                   	push   %eax
  8024ee:	e8 0b fc ff ff       	call   8020fe <malloc>
  8024f3:	83 c4 10             	add    $0x10,%esp
  8024f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8024f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024fd:	75 07                	jne    802506 <sget+0x5c>
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	eb 27                	jmp    80252d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	ff 75 e8             	pushl  -0x18(%ebp)
  80250c:	ff 75 0c             	pushl  0xc(%ebp)
  80250f:	ff 75 08             	pushl  0x8(%ebp)
  802512:	e8 e8 02 00 00       	call   8027ff <sys_getSharedObject>
  802517:	83 c4 10             	add    $0x10,%esp
  80251a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80251d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802521:	75 07                	jne    80252a <sget+0x80>
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	eb 03                	jmp    80252d <sget+0x83>
	return ptr;
  80252a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 74 57 80 00       	push   $0x805774
  80253d:	68 c2 00 00 00       	push   $0xc2
  802542:	68 62 57 80 00       	push   $0x805762
  802547:	e8 45 eb ff ff       	call   801091 <_panic>

0080254c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 98 57 80 00       	push   $0x805798
  80255a:	68 d9 00 00 00       	push   $0xd9
  80255f:	68 62 57 80 00       	push   $0x805762
  802564:	e8 28 eb ff ff       	call   801091 <_panic>

00802569 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 be 57 80 00       	push   $0x8057be
  802577:	68 e5 00 00 00       	push   $0xe5
  80257c:	68 62 57 80 00       	push   $0x805762
  802581:	e8 0b eb ff ff       	call   801091 <_panic>

00802586 <shrink>:

}
void shrink(uint32 newSize)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 be 57 80 00       	push   $0x8057be
  802594:	68 ea 00 00 00       	push   $0xea
  802599:	68 62 57 80 00       	push   $0x805762
  80259e:	e8 ee ea ff ff       	call   801091 <_panic>

008025a3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 be 57 80 00       	push   $0x8057be
  8025b1:	68 ef 00 00 00       	push   $0xef
  8025b6:	68 62 57 80 00       	push   $0x805762
  8025bb:	e8 d1 ea ff ff       	call   801091 <_panic>

008025c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	57                   	push   %edi
  8025c4:	56                   	push   %esi
  8025c5:	53                   	push   %ebx
  8025c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025db:	cd 30                	int    $0x30
  8025dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	5b                   	pop    %ebx
  8025e7:	5e                   	pop    %esi
  8025e8:	5f                   	pop    %edi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    

008025eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8025f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	52                   	push   %edx
  802603:	ff 75 0c             	pushl  0xc(%ebp)
  802606:	50                   	push   %eax
  802607:	6a 00                	push   $0x0
  802609:	e8 b2 ff ff ff       	call   8025c0 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
}
  802611:	90                   	nop
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <sys_cgetc>:

int
sys_cgetc(void)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 02                	push   $0x2
  802623:	e8 98 ff ff ff       	call   8025c0 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 03                	push   $0x3
  80263c:	e8 7f ff ff ff       	call   8025c0 <syscall>
  802641:	83 c4 18             	add    $0x18,%esp
}
  802644:	90                   	nop
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 04                	push   $0x4
  802656:	e8 65 ff ff ff       	call   8025c0 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	90                   	nop
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802664:	8b 55 0c             	mov    0xc(%ebp),%edx
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	52                   	push   %edx
  802671:	50                   	push   %eax
  802672:	6a 08                	push   $0x8
  802674:	e8 47 ff ff ff       	call   8025c0 <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	56                   	push   %esi
  802682:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802683:	8b 75 18             	mov    0x18(%ebp),%esi
  802686:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802689:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80268c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	56                   	push   %esi
  802693:	53                   	push   %ebx
  802694:	51                   	push   %ecx
  802695:	52                   	push   %edx
  802696:	50                   	push   %eax
  802697:	6a 09                	push   $0x9
  802699:	e8 22 ff ff ff       	call   8025c0 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    

008026a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	52                   	push   %edx
  8026b8:	50                   	push   %eax
  8026b9:	6a 0a                	push   $0xa
  8026bb:	e8 00 ff ff ff       	call   8025c0 <syscall>
  8026c0:	83 c4 18             	add    $0x18,%esp
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	ff 75 0c             	pushl  0xc(%ebp)
  8026d1:	ff 75 08             	pushl  0x8(%ebp)
  8026d4:	6a 0b                	push   $0xb
  8026d6:	e8 e5 fe ff ff       	call   8025c0 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 0c                	push   $0xc
  8026ef:	e8 cc fe ff ff       	call   8025c0 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 0d                	push   $0xd
  802708:	e8 b3 fe ff ff       	call   8025c0 <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 0e                	push   $0xe
  802721:	e8 9a fe ff ff       	call   8025c0 <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 0f                	push   $0xf
  80273a:	e8 81 fe ff ff       	call   8025c0 <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	ff 75 08             	pushl  0x8(%ebp)
  802752:	6a 10                	push   $0x10
  802754:	e8 67 fe ff ff       	call   8025c0 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 11                	push   $0x11
  80276d:	e8 4e fe ff ff       	call   8025c0 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
}
  802775:	90                   	nop
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_cputc>:

void
sys_cputc(const char c)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802784:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	50                   	push   %eax
  802791:	6a 01                	push   $0x1
  802793:	e8 28 fe ff ff       	call   8025c0 <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
}
  80279b:	90                   	nop
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 14                	push   $0x14
  8027ad:	e8 0e fe ff ff       	call   8025c0 <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
}
  8027b5:	90                   	nop
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	6a 00                	push   $0x0
  8027d0:	51                   	push   %ecx
  8027d1:	52                   	push   %edx
  8027d2:	ff 75 0c             	pushl  0xc(%ebp)
  8027d5:	50                   	push   %eax
  8027d6:	6a 15                	push   $0x15
  8027d8:	e8 e3 fd ff ff       	call   8025c0 <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	52                   	push   %edx
  8027f2:	50                   	push   %eax
  8027f3:	6a 16                	push   $0x16
  8027f5:	e8 c6 fd ff ff       	call   8025c0 <syscall>
  8027fa:	83 c4 18             	add    $0x18,%esp
}
  8027fd:	c9                   	leave  
  8027fe:	c3                   	ret    

008027ff <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027ff:	55                   	push   %ebp
  802800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802805:	8b 55 0c             	mov    0xc(%ebp),%edx
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	51                   	push   %ecx
  802810:	52                   	push   %edx
  802811:	50                   	push   %eax
  802812:	6a 17                	push   $0x17
  802814:	e8 a7 fd ff ff       	call   8025c0 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
}
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802821:	8b 55 0c             	mov    0xc(%ebp),%edx
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	52                   	push   %edx
  80282e:	50                   	push   %eax
  80282f:	6a 18                	push   $0x18
  802831:	e8 8a fd ff ff       	call   8025c0 <syscall>
  802836:	83 c4 18             	add    $0x18,%esp
}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	6a 00                	push   $0x0
  802843:	ff 75 14             	pushl  0x14(%ebp)
  802846:	ff 75 10             	pushl  0x10(%ebp)
  802849:	ff 75 0c             	pushl  0xc(%ebp)
  80284c:	50                   	push   %eax
  80284d:	6a 19                	push   $0x19
  80284f:	e8 6c fd ff ff       	call   8025c0 <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
}
  802857:	c9                   	leave  
  802858:	c3                   	ret    

00802859 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	50                   	push   %eax
  802868:	6a 1a                	push   $0x1a
  80286a:	e8 51 fd ff ff       	call   8025c0 <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
}
  802872:	90                   	nop
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	50                   	push   %eax
  802884:	6a 1b                	push   $0x1b
  802886:	e8 35 fd ff ff       	call   8025c0 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 05                	push   $0x5
  80289f:	e8 1c fd ff ff       	call   8025c0 <syscall>
  8028a4:	83 c4 18             	add    $0x18,%esp
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 06                	push   $0x6
  8028b8:	e8 03 fd ff ff       	call   8025c0 <syscall>
  8028bd:	83 c4 18             	add    $0x18,%esp
}
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 07                	push   $0x7
  8028d1:	e8 ea fc ff ff       	call   8025c0 <syscall>
  8028d6:	83 c4 18             	add    $0x18,%esp
}
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    

008028db <sys_exit_env>:


void sys_exit_env(void)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 1c                	push   $0x1c
  8028ea:	e8 d1 fc ff ff       	call   8025c0 <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028fe:	8d 50 04             	lea    0x4(%eax),%edx
  802901:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	52                   	push   %edx
  80290b:	50                   	push   %eax
  80290c:	6a 1d                	push   $0x1d
  80290e:	e8 ad fc ff ff       	call   8025c0 <syscall>
  802913:	83 c4 18             	add    $0x18,%esp
	return result;
  802916:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80291c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80291f:	89 01                	mov    %eax,(%ecx)
  802921:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	c9                   	leave  
  802928:	c2 04 00             	ret    $0x4

0080292b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	ff 75 10             	pushl  0x10(%ebp)
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	ff 75 08             	pushl  0x8(%ebp)
  80293b:	6a 13                	push   $0x13
  80293d:	e8 7e fc ff ff       	call   8025c0 <syscall>
  802942:	83 c4 18             	add    $0x18,%esp
	return ;
  802945:	90                   	nop
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <sys_rcr2>:
uint32 sys_rcr2()
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 1e                	push   $0x1e
  802957:	e8 64 fc ff ff       	call   8025c0 <syscall>
  80295c:	83 c4 18             	add    $0x18,%esp
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80296d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	50                   	push   %eax
  80297a:	6a 1f                	push   $0x1f
  80297c:	e8 3f fc ff ff       	call   8025c0 <syscall>
  802981:	83 c4 18             	add    $0x18,%esp
	return ;
  802984:	90                   	nop
}
  802985:	c9                   	leave  
  802986:	c3                   	ret    

00802987 <rsttst>:
void rsttst()
{
  802987:	55                   	push   %ebp
  802988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 21                	push   $0x21
  802996:	e8 25 fc ff ff       	call   8025c0 <syscall>
  80299b:	83 c4 18             	add    $0x18,%esp
	return ;
  80299e:	90                   	nop
}
  80299f:	c9                   	leave  
  8029a0:	c3                   	ret    

008029a1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8029aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029ad:	8b 55 18             	mov    0x18(%ebp),%edx
  8029b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029b4:	52                   	push   %edx
  8029b5:	50                   	push   %eax
  8029b6:	ff 75 10             	pushl  0x10(%ebp)
  8029b9:	ff 75 0c             	pushl  0xc(%ebp)
  8029bc:	ff 75 08             	pushl  0x8(%ebp)
  8029bf:	6a 20                	push   $0x20
  8029c1:	e8 fa fb ff ff       	call   8025c0 <syscall>
  8029c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029c9:	90                   	nop
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <chktst>:
void chktst(uint32 n)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	ff 75 08             	pushl  0x8(%ebp)
  8029da:	6a 22                	push   $0x22
  8029dc:	e8 df fb ff ff       	call   8025c0 <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e4:	90                   	nop
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <inctst>:

void inctst()
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 23                	push   $0x23
  8029f6:	e8 c5 fb ff ff       	call   8025c0 <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fe:	90                   	nop
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <gettst>:
uint32 gettst()
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 24                	push   $0x24
  802a10:	e8 ab fb ff ff       	call   8025c0 <syscall>
  802a15:	83 c4 18             	add    $0x18,%esp
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 25                	push   $0x25
  802a2c:	e8 8f fb ff ff       	call   8025c0 <syscall>
  802a31:	83 c4 18             	add    $0x18,%esp
  802a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a3b:	75 07                	jne    802a44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a42:	eb 05                	jmp    802a49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 25                	push   $0x25
  802a5d:	e8 5e fb ff ff       	call   8025c0 <syscall>
  802a62:	83 c4 18             	add    $0x18,%esp
  802a65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a6c:	75 07                	jne    802a75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	eb 05                	jmp    802a7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 25                	push   $0x25
  802a8e:	e8 2d fb ff ff       	call   8025c0 <syscall>
  802a93:	83 c4 18             	add    $0x18,%esp
  802a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a9d:	75 07                	jne    802aa6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a9f:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa4:	eb 05                	jmp    802aab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
  802ab0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 25                	push   $0x25
  802abf:	e8 fc fa ff ff       	call   8025c0 <syscall>
  802ac4:	83 c4 18             	add    $0x18,%esp
  802ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802aca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ace:	75 07                	jne    802ad7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ad0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad5:	eb 05                	jmp    802adc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	ff 75 08             	pushl  0x8(%ebp)
  802aec:	6a 26                	push   $0x26
  802aee:	e8 cd fa ff ff       	call   8025c0 <syscall>
  802af3:	83 c4 18             	add    $0x18,%esp
	return ;
  802af6:	90                   	nop
}
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

00802af9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802afd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	6a 00                	push   $0x0
  802b0b:	53                   	push   %ebx
  802b0c:	51                   	push   %ecx
  802b0d:	52                   	push   %edx
  802b0e:	50                   	push   %eax
  802b0f:	6a 27                	push   $0x27
  802b11:	e8 aa fa ff ff       	call   8025c0 <syscall>
  802b16:	83 c4 18             	add    $0x18,%esp
}
  802b19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	52                   	push   %edx
  802b2e:	50                   	push   %eax
  802b2f:	6a 28                	push   $0x28
  802b31:	e8 8a fa ff ff       	call   8025c0 <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	6a 00                	push   $0x0
  802b49:	51                   	push   %ecx
  802b4a:	ff 75 10             	pushl  0x10(%ebp)
  802b4d:	52                   	push   %edx
  802b4e:	50                   	push   %eax
  802b4f:	6a 29                	push   $0x29
  802b51:	e8 6a fa ff ff       	call   8025c0 <syscall>
  802b56:	83 c4 18             	add    $0x18,%esp
}
  802b59:	c9                   	leave  
  802b5a:	c3                   	ret    

00802b5b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	ff 75 10             	pushl  0x10(%ebp)
  802b65:	ff 75 0c             	pushl  0xc(%ebp)
  802b68:	ff 75 08             	pushl  0x8(%ebp)
  802b6b:	6a 12                	push   $0x12
  802b6d:	e8 4e fa ff ff       	call   8025c0 <syscall>
  802b72:	83 c4 18             	add    $0x18,%esp
	return ;
  802b75:	90                   	nop
}
  802b76:	c9                   	leave  
  802b77:	c3                   	ret    

00802b78 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b78:	55                   	push   %ebp
  802b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	6a 00                	push   $0x0
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	52                   	push   %edx
  802b88:	50                   	push   %eax
  802b89:	6a 2a                	push   $0x2a
  802b8b:	e8 30 fa ff ff       	call   8025c0 <syscall>
  802b90:	83 c4 18             	add    $0x18,%esp
	return;
  802b93:	90                   	nop
}
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 00                	push   $0x0
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	50                   	push   %eax
  802ba5:	6a 2b                	push   $0x2b
  802ba7:	e8 14 fa ff ff       	call   8025c0 <syscall>
  802bac:	83 c4 18             	add    $0x18,%esp
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	ff 75 0c             	pushl  0xc(%ebp)
  802bbd:	ff 75 08             	pushl  0x8(%ebp)
  802bc0:	6a 2c                	push   $0x2c
  802bc2:	e8 f9 f9 ff ff       	call   8025c0 <syscall>
  802bc7:	83 c4 18             	add    $0x18,%esp
	return;
  802bca:	90                   	nop
}
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    

00802bcd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bcd:	55                   	push   %ebp
  802bce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	ff 75 0c             	pushl  0xc(%ebp)
  802bd9:	ff 75 08             	pushl  0x8(%ebp)
  802bdc:	6a 2d                	push   $0x2d
  802bde:	e8 dd f9 ff ff       	call   8025c0 <syscall>
  802be3:	83 c4 18             	add    $0x18,%esp
	return;
  802be6:	90                   	nop
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
  802bec:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	83 e8 04             	sub    $0x4,%eax
  802bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    

00802c02 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c02:	55                   	push   %ebp
  802c03:	89 e5                	mov    %esp,%ebp
  802c05:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	83 e8 04             	sub    $0x4,%eax
  802c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	83 e0 01             	and    $0x1,%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	0f 94 c0             	sete   %al
}
  802c1e:	c9                   	leave  
  802c1f:	c3                   	ret    

00802c20 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c30:	83 f8 02             	cmp    $0x2,%eax
  802c33:	74 2b                	je     802c60 <alloc_block+0x40>
  802c35:	83 f8 02             	cmp    $0x2,%eax
  802c38:	7f 07                	jg     802c41 <alloc_block+0x21>
  802c3a:	83 f8 01             	cmp    $0x1,%eax
  802c3d:	74 0e                	je     802c4d <alloc_block+0x2d>
  802c3f:	eb 58                	jmp    802c99 <alloc_block+0x79>
  802c41:	83 f8 03             	cmp    $0x3,%eax
  802c44:	74 2d                	je     802c73 <alloc_block+0x53>
  802c46:	83 f8 04             	cmp    $0x4,%eax
  802c49:	74 3b                	je     802c86 <alloc_block+0x66>
  802c4b:	eb 4c                	jmp    802c99 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c4d:	83 ec 0c             	sub    $0xc,%esp
  802c50:	ff 75 08             	pushl  0x8(%ebp)
  802c53:	e8 11 03 00 00       	call   802f69 <alloc_block_FF>
  802c58:	83 c4 10             	add    $0x10,%esp
  802c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c5e:	eb 4a                	jmp    802caa <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802c60:	83 ec 0c             	sub    $0xc,%esp
  802c63:	ff 75 08             	pushl  0x8(%ebp)
  802c66:	e8 fa 19 00 00       	call   804665 <alloc_block_NF>
  802c6b:	83 c4 10             	add    $0x10,%esp
  802c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c71:	eb 37                	jmp    802caa <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802c73:	83 ec 0c             	sub    $0xc,%esp
  802c76:	ff 75 08             	pushl  0x8(%ebp)
  802c79:	e8 a7 07 00 00       	call   803425 <alloc_block_BF>
  802c7e:	83 c4 10             	add    $0x10,%esp
  802c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c84:	eb 24                	jmp    802caa <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802c86:	83 ec 0c             	sub    $0xc,%esp
  802c89:	ff 75 08             	pushl  0x8(%ebp)
  802c8c:	e8 b7 19 00 00       	call   804648 <alloc_block_WF>
  802c91:	83 c4 10             	add    $0x10,%esp
  802c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c97:	eb 11                	jmp    802caa <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802c99:	83 ec 0c             	sub    $0xc,%esp
  802c9c:	68 d0 57 80 00       	push   $0x8057d0
  802ca1:	e8 a8 e6 ff ff       	call   80134e <cprintf>
  802ca6:	83 c4 10             	add    $0x10,%esp
		break;
  802ca9:	90                   	nop
	}
	return va;
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802cad:	c9                   	leave  
  802cae:	c3                   	ret    

00802caf <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802caf:	55                   	push   %ebp
  802cb0:	89 e5                	mov    %esp,%ebp
  802cb2:	53                   	push   %ebx
  802cb3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802cb6:	83 ec 0c             	sub    $0xc,%esp
  802cb9:	68 f0 57 80 00       	push   $0x8057f0
  802cbe:	e8 8b e6 ff ff       	call   80134e <cprintf>
  802cc3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	68 1b 58 80 00       	push   $0x80581b
  802cce:	e8 7b e6 ff ff       	call   80134e <cprintf>
  802cd3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdc:	eb 37                	jmp    802d15 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802cde:	83 ec 0c             	sub    $0xc,%esp
  802ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ce4:	e8 19 ff ff ff       	call   802c02 <is_free_block>
  802ce9:	83 c4 10             	add    $0x10,%esp
  802cec:	0f be d8             	movsbl %al,%ebx
  802cef:	83 ec 0c             	sub    $0xc,%esp
  802cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  802cf5:	e8 ef fe ff ff       	call   802be9 <get_block_size>
  802cfa:	83 c4 10             	add    $0x10,%esp
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	53                   	push   %ebx
  802d01:	50                   	push   %eax
  802d02:	68 33 58 80 00       	push   $0x805833
  802d07:	e8 42 e6 ff ff       	call   80134e <cprintf>
  802d0c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d19:	74 07                	je     802d22 <print_blocks_list+0x73>
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 00                	mov    (%eax),%eax
  802d20:	eb 05                	jmp    802d27 <print_blocks_list+0x78>
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
  802d27:	89 45 10             	mov    %eax,0x10(%ebp)
  802d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	75 ad                	jne    802cde <print_blocks_list+0x2f>
  802d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d35:	75 a7                	jne    802cde <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802d37:	83 ec 0c             	sub    $0xc,%esp
  802d3a:	68 f0 57 80 00       	push   $0x8057f0
  802d3f:	e8 0a e6 ff ff       	call   80134e <cprintf>
  802d44:	83 c4 10             	add    $0x10,%esp

}
  802d47:	90                   	nop
  802d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d56:	83 e0 01             	and    $0x1,%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 03                	je     802d60 <initialize_dynamic_allocator+0x13>
  802d5d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d64:	0f 84 c7 01 00 00    	je     802f31 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802d6a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802d71:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802d74:	8b 55 08             	mov    0x8(%ebp),%edx
  802d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7a:	01 d0                	add    %edx,%eax
  802d7c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802d81:	0f 87 ad 01 00 00    	ja     802f34 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	0f 89 a5 01 00 00    	jns    802f37 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802d92:	8b 55 08             	mov    0x8(%ebp),%edx
  802d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	83 e8 04             	sub    $0x4,%eax
  802d9d:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802da9:	a1 44 60 80 00       	mov    0x806044,%eax
  802dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db1:	e9 87 00 00 00       	jmp    802e3d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	75 14                	jne    802dd0 <initialize_dynamic_allocator+0x83>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 4b 58 80 00       	push   $0x80584b
  802dc4:	6a 79                	push   $0x79
  802dc6:	68 69 58 80 00       	push   $0x805869
  802dcb:	e8 c1 e2 ff ff       	call   801091 <_panic>
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 10                	je     802de9 <initialize_dynamic_allocator+0x9c>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de1:	8b 52 04             	mov    0x4(%edx),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 0b                	jmp    802df4 <initialize_dynamic_allocator+0xa7>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	a3 48 60 80 00       	mov    %eax,0x806048
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 0f                	je     802e0d <initialize_dynamic_allocator+0xc0>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e07:	8b 12                	mov    (%edx),%edx
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	eb 0a                	jmp    802e17 <initialize_dynamic_allocator+0xca>
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	a3 44 60 80 00       	mov    %eax,0x806044
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 50 60 80 00       	mov    0x806050,%eax
  802e2f:	48                   	dec    %eax
  802e30:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802e35:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	74 07                	je     802e4a <initialize_dynamic_allocator+0xfd>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	eb 05                	jmp    802e4f <initialize_dynamic_allocator+0x102>
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802e54:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	0f 85 55 ff ff ff    	jne    802db6 <initialize_dynamic_allocator+0x69>
  802e61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e65:	0f 85 4b ff ff ff    	jne    802db6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802e7a:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802e7f:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802e84:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802e89:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	83 c0 08             	add    $0x8,%eax
  802e95:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	83 c0 04             	add    $0x4,%eax
  802e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea1:	83 ea 08             	sub    $0x8,%edx
  802ea4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	01 d0                	add    %edx,%eax
  802eae:	83 e8 08             	sub    $0x8,%eax
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	83 ea 08             	sub    $0x8,%edx
  802eb7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802ecc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ed0:	75 17                	jne    802ee9 <initialize_dynamic_allocator+0x19c>
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 84 58 80 00       	push   $0x805884
  802eda:	68 90 00 00 00       	push   $0x90
  802edf:	68 69 58 80 00       	push   $0x805869
  802ee4:	e8 a8 e1 ff ff       	call   801091 <_panic>
  802ee9:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	89 10                	mov    %edx,(%eax)
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0d                	je     802f0a <initialize_dynamic_allocator+0x1bd>
  802efd:	a1 44 60 80 00       	mov    0x806044,%eax
  802f02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f05:	89 50 04             	mov    %edx,0x4(%eax)
  802f08:	eb 08                	jmp    802f12 <initialize_dynamic_allocator+0x1c5>
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	a3 48 60 80 00       	mov    %eax,0x806048
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	a3 44 60 80 00       	mov    %eax,0x806044
  802f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 50 60 80 00       	mov    0x806050,%eax
  802f29:	40                   	inc    %eax
  802f2a:	a3 50 60 80 00       	mov    %eax,0x806050
  802f2f:	eb 07                	jmp    802f38 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f31:	90                   	nop
  802f32:	eb 04                	jmp    802f38 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802f34:	90                   	nop
  802f35:	eb 01                	jmp    802f38 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802f37:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f40:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	83 e8 04             	sub    $0x4,%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	83 e0 fe             	and    $0xfffffffe,%eax
  802f59:	8d 50 f8             	lea    -0x8(%eax),%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	01 c2                	add    %eax,%edx
  802f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f64:	89 02                	mov    %eax,(%edx)
}
  802f66:	90                   	nop
  802f67:	5d                   	pop    %ebp
  802f68:	c3                   	ret    

00802f69 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802f69:	55                   	push   %ebp
  802f6a:	89 e5                	mov    %esp,%ebp
  802f6c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	83 e0 01             	and    $0x1,%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 03                	je     802f7c <alloc_block_FF+0x13>
  802f79:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f7c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f80:	77 07                	ja     802f89 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f82:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f89:	a1 24 60 80 00       	mov    0x806024,%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	75 73                	jne    803005 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	83 c0 10             	add    $0x10,%eax
  802f98:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f9b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	01 d0                	add    %edx,%eax
  802faa:	48                   	dec    %eax
  802fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb6:	f7 75 ec             	divl   -0x14(%ebp)
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	29 d0                	sub    %edx,%eax
  802fbe:	c1 e8 0c             	shr    $0xc,%eax
  802fc1:	83 ec 0c             	sub    $0xc,%esp
  802fc4:	50                   	push   %eax
  802fc5:	e8 1e f1 ff ff       	call   8020e8 <sbrk>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fd0:	83 ec 0c             	sub    $0xc,%esp
  802fd3:	6a 00                	push   $0x0
  802fd5:	e8 0e f1 ff ff       	call   8020e8 <sbrk>
  802fda:	83 c4 10             	add    $0x10,%esp
  802fdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802fe6:	83 ec 08             	sub    $0x8,%esp
  802fe9:	50                   	push   %eax
  802fea:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fed:	e8 5b fd ff ff       	call   802d4d <initialize_dynamic_allocator>
  802ff2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ff5:	83 ec 0c             	sub    $0xc,%esp
  802ff8:	68 a7 58 80 00       	push   $0x8058a7
  802ffd:	e8 4c e3 ff ff       	call   80134e <cprintf>
  803002:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803005:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803009:	75 0a                	jne    803015 <alloc_block_FF+0xac>
	        return NULL;
  80300b:	b8 00 00 00 00       	mov    $0x0,%eax
  803010:	e9 0e 04 00 00       	jmp    803423 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80301c:	a1 44 60 80 00       	mov    0x806044,%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803024:	e9 f3 02 00 00       	jmp    80331c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80302f:	83 ec 0c             	sub    $0xc,%esp
  803032:	ff 75 bc             	pushl  -0x44(%ebp)
  803035:	e8 af fb ff ff       	call   802be9 <get_block_size>
  80303a:	83 c4 10             	add    $0x10,%esp
  80303d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	83 c0 08             	add    $0x8,%eax
  803046:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803049:	0f 87 c5 02 00 00    	ja     803314 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	83 c0 18             	add    $0x18,%eax
  803055:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803058:	0f 87 19 02 00 00    	ja     803277 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80305e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803061:	2b 45 08             	sub    0x8(%ebp),%eax
  803064:	83 e8 08             	sub    $0x8,%eax
  803067:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8d 50 08             	lea    0x8(%eax),%edx
  803070:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803073:	01 d0                	add    %edx,%eax
  803075:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	83 c0 08             	add    $0x8,%eax
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	6a 01                	push   $0x1
  803083:	50                   	push   %eax
  803084:	ff 75 bc             	pushl  -0x44(%ebp)
  803087:	e8 ae fe ff ff       	call   802f3a <set_block_data>
  80308c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	75 68                	jne    803101 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803099:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80309d:	75 17                	jne    8030b6 <alloc_block_FF+0x14d>
  80309f:	83 ec 04             	sub    $0x4,%esp
  8030a2:	68 84 58 80 00       	push   $0x805884
  8030a7:	68 d7 00 00 00       	push   $0xd7
  8030ac:	68 69 58 80 00       	push   $0x805869
  8030b1:	e8 db df ff ff       	call   801091 <_panic>
  8030b6:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8030bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0d                	je     8030d7 <alloc_block_FF+0x16e>
  8030ca:	a1 44 60 80 00       	mov    0x806044,%eax
  8030cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030d2:	89 50 04             	mov    %edx,0x4(%eax)
  8030d5:	eb 08                	jmp    8030df <alloc_block_FF+0x176>
  8030d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030da:	a3 48 60 80 00       	mov    %eax,0x806048
  8030df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030e2:	a3 44 60 80 00       	mov    %eax,0x806044
  8030e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 50 60 80 00       	mov    0x806050,%eax
  8030f6:	40                   	inc    %eax
  8030f7:	a3 50 60 80 00       	mov    %eax,0x806050
  8030fc:	e9 dc 00 00 00       	jmp    8031dd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 00                	mov    (%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	75 65                	jne    80316f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80310a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80310e:	75 17                	jne    803127 <alloc_block_FF+0x1be>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 b8 58 80 00       	push   $0x8058b8
  803118:	68 db 00 00 00       	push   $0xdb
  80311d:	68 69 58 80 00       	push   $0x805869
  803122:	e8 6a df ff ff       	call   801091 <_panic>
  803127:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80312d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0c                	je     803149 <alloc_block_FF+0x1e0>
  80313d:	a1 48 60 80 00       	mov    0x806048,%eax
  803142:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803145:	89 10                	mov    %edx,(%eax)
  803147:	eb 08                	jmp    803151 <alloc_block_FF+0x1e8>
  803149:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80314c:	a3 44 60 80 00       	mov    %eax,0x806044
  803151:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803154:	a3 48 60 80 00       	mov    %eax,0x806048
  803159:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80315c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803162:	a1 50 60 80 00       	mov    0x806050,%eax
  803167:	40                   	inc    %eax
  803168:	a3 50 60 80 00       	mov    %eax,0x806050
  80316d:	eb 6e                	jmp    8031dd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80316f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803173:	74 06                	je     80317b <alloc_block_FF+0x212>
  803175:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803179:	75 17                	jne    803192 <alloc_block_FF+0x229>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 dc 58 80 00       	push   $0x8058dc
  803183:	68 df 00 00 00       	push   $0xdf
  803188:	68 69 58 80 00       	push   $0x805869
  80318d:	e8 ff de ff ff       	call   801091 <_panic>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 10                	mov    (%eax),%edx
  803197:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0b                	je     8031b0 <alloc_block_FF+0x247>
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031ad:	89 50 04             	mov    %edx,0x4(%eax)
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031be:	89 50 04             	mov    %edx,0x4(%eax)
  8031c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	75 08                	jne    8031d2 <alloc_block_FF+0x269>
  8031ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031cd:	a3 48 60 80 00       	mov    %eax,0x806048
  8031d2:	a1 50 60 80 00       	mov    0x806050,%eax
  8031d7:	40                   	inc    %eax
  8031d8:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	75 17                	jne    8031fa <alloc_block_FF+0x291>
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	68 4b 58 80 00       	push   $0x80584b
  8031eb:	68 e1 00 00 00       	push   $0xe1
  8031f0:	68 69 58 80 00       	push   $0x805869
  8031f5:	e8 97 de ff ff       	call   801091 <_panic>
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 10                	je     803213 <alloc_block_FF+0x2aa>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320b:	8b 52 04             	mov    0x4(%edx),%edx
  80320e:	89 50 04             	mov    %edx,0x4(%eax)
  803211:	eb 0b                	jmp    80321e <alloc_block_FF+0x2b5>
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	a3 48 60 80 00       	mov    %eax,0x806048
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 40 04             	mov    0x4(%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 0f                	je     803237 <alloc_block_FF+0x2ce>
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803231:	8b 12                	mov    (%edx),%edx
  803233:	89 10                	mov    %edx,(%eax)
  803235:	eb 0a                	jmp    803241 <alloc_block_FF+0x2d8>
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	a3 44 60 80 00       	mov    %eax,0x806044
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803254:	a1 50 60 80 00       	mov    0x806050,%eax
  803259:	48                   	dec    %eax
  80325a:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  80325f:	83 ec 04             	sub    $0x4,%esp
  803262:	6a 00                	push   $0x0
  803264:	ff 75 b4             	pushl  -0x4c(%ebp)
  803267:	ff 75 b0             	pushl  -0x50(%ebp)
  80326a:	e8 cb fc ff ff       	call   802f3a <set_block_data>
  80326f:	83 c4 10             	add    $0x10,%esp
  803272:	e9 95 00 00 00       	jmp    80330c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803277:	83 ec 04             	sub    $0x4,%esp
  80327a:	6a 01                	push   $0x1
  80327c:	ff 75 b8             	pushl  -0x48(%ebp)
  80327f:	ff 75 bc             	pushl  -0x44(%ebp)
  803282:	e8 b3 fc ff ff       	call   802f3a <set_block_data>
  803287:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	75 17                	jne    8032a7 <alloc_block_FF+0x33e>
  803290:	83 ec 04             	sub    $0x4,%esp
  803293:	68 4b 58 80 00       	push   $0x80584b
  803298:	68 e8 00 00 00       	push   $0xe8
  80329d:	68 69 58 80 00       	push   $0x805869
  8032a2:	e8 ea dd ff ff       	call   801091 <_panic>
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 10                	je     8032c0 <alloc_block_FF+0x357>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b8:	8b 52 04             	mov    0x4(%edx),%edx
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	eb 0b                	jmp    8032cb <alloc_block_FF+0x362>
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	a3 48 60 80 00       	mov    %eax,0x806048
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0f                	je     8032e4 <alloc_block_FF+0x37b>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	8b 12                	mov    (%edx),%edx
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	eb 0a                	jmp    8032ee <alloc_block_FF+0x385>
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	a3 44 60 80 00       	mov    %eax,0x806044
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 50 60 80 00       	mov    0x806050,%eax
  803306:	48                   	dec    %eax
  803307:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  80330c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80330f:	e9 0f 01 00 00       	jmp    803423 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803314:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80331c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803320:	74 07                	je     803329 <alloc_block_FF+0x3c0>
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	eb 05                	jmp    80332e <alloc_block_FF+0x3c5>
  803329:	b8 00 00 00 00       	mov    $0x0,%eax
  80332e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803333:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	0f 85 e9 fc ff ff    	jne    803029 <alloc_block_FF+0xc0>
  803340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803344:	0f 85 df fc ff ff    	jne    803029 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	83 c0 08             	add    $0x8,%eax
  803350:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803353:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80335a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80335d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803360:	01 d0                	add    %edx,%eax
  803362:	48                   	dec    %eax
  803363:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803366:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803369:	ba 00 00 00 00       	mov    $0x0,%edx
  80336e:	f7 75 d8             	divl   -0x28(%ebp)
  803371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803374:	29 d0                	sub    %edx,%eax
  803376:	c1 e8 0c             	shr    $0xc,%eax
  803379:	83 ec 0c             	sub    $0xc,%esp
  80337c:	50                   	push   %eax
  80337d:	e8 66 ed ff ff       	call   8020e8 <sbrk>
  803382:	83 c4 10             	add    $0x10,%esp
  803385:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803388:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80338c:	75 0a                	jne    803398 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80338e:	b8 00 00 00 00       	mov    $0x0,%eax
  803393:	e9 8b 00 00 00       	jmp    803423 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803398:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80339f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	48                   	dec    %eax
  8033a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8033ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8033b3:	f7 75 cc             	divl   -0x34(%ebp)
  8033b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b9:	29 d0                	sub    %edx,%eax
  8033bb:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  8033c8:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8033cd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033d3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033e0:	01 d0                	add    %edx,%eax
  8033e2:	48                   	dec    %eax
  8033e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033e6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ee:	f7 75 c4             	divl   -0x3c(%ebp)
  8033f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033f4:	29 d0                	sub    %edx,%eax
  8033f6:	83 ec 04             	sub    $0x4,%esp
  8033f9:	6a 01                	push   $0x1
  8033fb:	50                   	push   %eax
  8033fc:	ff 75 d0             	pushl  -0x30(%ebp)
  8033ff:	e8 36 fb ff ff       	call   802f3a <set_block_data>
  803404:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803407:	83 ec 0c             	sub    $0xc,%esp
  80340a:	ff 75 d0             	pushl  -0x30(%ebp)
  80340d:	e8 1b 0a 00 00       	call   803e2d <free_block>
  803412:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803415:	83 ec 0c             	sub    $0xc,%esp
  803418:	ff 75 08             	pushl  0x8(%ebp)
  80341b:	e8 49 fb ff ff       	call   802f69 <alloc_block_FF>
  803420:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803423:	c9                   	leave  
  803424:	c3                   	ret    

00803425 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
  803428:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	83 e0 01             	and    $0x1,%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 03                	je     803438 <alloc_block_BF+0x13>
  803435:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803438:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80343c:	77 07                	ja     803445 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80343e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803445:	a1 24 60 80 00       	mov    0x806024,%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	75 73                	jne    8034c1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	83 c0 10             	add    $0x10,%eax
  803454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803457:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80345e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803461:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803464:	01 d0                	add    %edx,%eax
  803466:	48                   	dec    %eax
  803467:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80346a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80346d:	ba 00 00 00 00       	mov    $0x0,%edx
  803472:	f7 75 e0             	divl   -0x20(%ebp)
  803475:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803478:	29 d0                	sub    %edx,%eax
  80347a:	c1 e8 0c             	shr    $0xc,%eax
  80347d:	83 ec 0c             	sub    $0xc,%esp
  803480:	50                   	push   %eax
  803481:	e8 62 ec ff ff       	call   8020e8 <sbrk>
  803486:	83 c4 10             	add    $0x10,%esp
  803489:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80348c:	83 ec 0c             	sub    $0xc,%esp
  80348f:	6a 00                	push   $0x0
  803491:	e8 52 ec ff ff       	call   8020e8 <sbrk>
  803496:	83 c4 10             	add    $0x10,%esp
  803499:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80349c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8034a2:	83 ec 08             	sub    $0x8,%esp
  8034a5:	50                   	push   %eax
  8034a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8034a9:	e8 9f f8 ff ff       	call   802d4d <initialize_dynamic_allocator>
  8034ae:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8034b1:	83 ec 0c             	sub    $0xc,%esp
  8034b4:	68 a7 58 80 00       	push   $0x8058a7
  8034b9:	e8 90 de ff ff       	call   80134e <cprintf>
  8034be:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8034c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8034c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8034cf:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8034d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8034dd:	a1 44 60 80 00       	mov    0x806044,%eax
  8034e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e5:	e9 1d 01 00 00       	jmp    803607 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8034f0:	83 ec 0c             	sub    $0xc,%esp
  8034f3:	ff 75 a8             	pushl  -0x58(%ebp)
  8034f6:	e8 ee f6 ff ff       	call   802be9 <get_block_size>
  8034fb:	83 c4 10             	add    $0x10,%esp
  8034fe:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	83 c0 08             	add    $0x8,%eax
  803507:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80350a:	0f 87 ef 00 00 00    	ja     8035ff <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	83 c0 18             	add    $0x18,%eax
  803516:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803519:	77 1d                	ja     803538 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803521:	0f 86 d8 00 00 00    	jbe    8035ff <alloc_block_BF+0x1da>
				{
					best_va = va;
  803527:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80352a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80352d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803530:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803533:	e9 c7 00 00 00       	jmp    8035ff <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	83 c0 08             	add    $0x8,%eax
  80353e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803541:	0f 85 9d 00 00 00    	jne    8035e4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	6a 01                	push   $0x1
  80354c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80354f:	ff 75 a8             	pushl  -0x58(%ebp)
  803552:	e8 e3 f9 ff ff       	call   802f3a <set_block_data>
  803557:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80355a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355e:	75 17                	jne    803577 <alloc_block_BF+0x152>
  803560:	83 ec 04             	sub    $0x4,%esp
  803563:	68 4b 58 80 00       	push   $0x80584b
  803568:	68 2c 01 00 00       	push   $0x12c
  80356d:	68 69 58 80 00       	push   $0x805869
  803572:	e8 1a db ff ff       	call   801091 <_panic>
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	74 10                	je     803590 <alloc_block_BF+0x16b>
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803588:	8b 52 04             	mov    0x4(%edx),%edx
  80358b:	89 50 04             	mov    %edx,0x4(%eax)
  80358e:	eb 0b                	jmp    80359b <alloc_block_BF+0x176>
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	a3 48 60 80 00       	mov    %eax,0x806048
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	85 c0                	test   %eax,%eax
  8035a3:	74 0f                	je     8035b4 <alloc_block_BF+0x18f>
  8035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a8:	8b 40 04             	mov    0x4(%eax),%eax
  8035ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ae:	8b 12                	mov    (%edx),%edx
  8035b0:	89 10                	mov    %edx,(%eax)
  8035b2:	eb 0a                	jmp    8035be <alloc_block_BF+0x199>
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	a3 44 60 80 00       	mov    %eax,0x806044
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d1:	a1 50 60 80 00       	mov    0x806050,%eax
  8035d6:	48                   	dec    %eax
  8035d7:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  8035dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8035df:	e9 24 04 00 00       	jmp    803a08 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8035ea:	76 13                	jbe    8035ff <alloc_block_BF+0x1da>
					{
						internal = 1;
  8035ec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8035f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8035f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8035f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8035fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8035ff:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360b:	74 07                	je     803614 <alloc_block_BF+0x1ef>
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	eb 05                	jmp    803619 <alloc_block_BF+0x1f4>
  803614:	b8 00 00 00 00       	mov    $0x0,%eax
  803619:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80361e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	0f 85 bf fe ff ff    	jne    8034ea <alloc_block_BF+0xc5>
  80362b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362f:	0f 85 b5 fe ff ff    	jne    8034ea <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803639:	0f 84 26 02 00 00    	je     803865 <alloc_block_BF+0x440>
  80363f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803643:	0f 85 1c 02 00 00    	jne    803865 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364c:	2b 45 08             	sub    0x8(%ebp),%eax
  80364f:	83 e8 08             	sub    $0x8,%eax
  803652:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	8d 50 08             	lea    0x8(%eax),%edx
  80365b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365e:	01 d0                	add    %edx,%eax
  803660:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	83 c0 08             	add    $0x8,%eax
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	6a 01                	push   $0x1
  80366e:	50                   	push   %eax
  80366f:	ff 75 f0             	pushl  -0x10(%ebp)
  803672:	e8 c3 f8 ff ff       	call   802f3a <set_block_data>
  803677:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367d:	8b 40 04             	mov    0x4(%eax),%eax
  803680:	85 c0                	test   %eax,%eax
  803682:	75 68                	jne    8036ec <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803684:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803688:	75 17                	jne    8036a1 <alloc_block_BF+0x27c>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 84 58 80 00       	push   $0x805884
  803692:	68 45 01 00 00       	push   $0x145
  803697:	68 69 58 80 00       	push   $0x805869
  80369c:	e8 f0 d9 ff ff       	call   801091 <_panic>
  8036a1:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8036a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036aa:	89 10                	mov    %edx,(%eax)
  8036ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	74 0d                	je     8036c2 <alloc_block_BF+0x29d>
  8036b5:	a1 44 60 80 00       	mov    0x806044,%eax
  8036ba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 08                	jmp    8036ca <alloc_block_BF+0x2a5>
  8036c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036c5:	a3 48 60 80 00       	mov    %eax,0x806048
  8036ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036cd:	a3 44 60 80 00       	mov    %eax,0x806044
  8036d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036dc:	a1 50 60 80 00       	mov    0x806050,%eax
  8036e1:	40                   	inc    %eax
  8036e2:	a3 50 60 80 00       	mov    %eax,0x806050
  8036e7:	e9 dc 00 00 00       	jmp    8037c8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8036ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	85 c0                	test   %eax,%eax
  8036f3:	75 65                	jne    80375a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036f9:	75 17                	jne    803712 <alloc_block_BF+0x2ed>
  8036fb:	83 ec 04             	sub    $0x4,%esp
  8036fe:	68 b8 58 80 00       	push   $0x8058b8
  803703:	68 4a 01 00 00       	push   $0x14a
  803708:	68 69 58 80 00       	push   $0x805869
  80370d:	e8 7f d9 ff ff       	call   801091 <_panic>
  803712:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803718:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803721:	8b 40 04             	mov    0x4(%eax),%eax
  803724:	85 c0                	test   %eax,%eax
  803726:	74 0c                	je     803734 <alloc_block_BF+0x30f>
  803728:	a1 48 60 80 00       	mov    0x806048,%eax
  80372d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803730:	89 10                	mov    %edx,(%eax)
  803732:	eb 08                	jmp    80373c <alloc_block_BF+0x317>
  803734:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803737:	a3 44 60 80 00       	mov    %eax,0x806044
  80373c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80373f:	a3 48 60 80 00       	mov    %eax,0x806048
  803744:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803747:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80374d:	a1 50 60 80 00       	mov    0x806050,%eax
  803752:	40                   	inc    %eax
  803753:	a3 50 60 80 00       	mov    %eax,0x806050
  803758:	eb 6e                	jmp    8037c8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80375a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80375e:	74 06                	je     803766 <alloc_block_BF+0x341>
  803760:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803764:	75 17                	jne    80377d <alloc_block_BF+0x358>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 dc 58 80 00       	push   $0x8058dc
  80376e:	68 4f 01 00 00       	push   $0x14f
  803773:	68 69 58 80 00       	push   $0x805869
  803778:	e8 14 d9 ff ff       	call   801091 <_panic>
  80377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803780:	8b 10                	mov    (%eax),%edx
  803782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803785:	89 10                	mov    %edx,(%eax)
  803787:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	74 0b                	je     80379b <alloc_block_BF+0x376>
  803790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803798:	89 50 04             	mov    %edx,0x4(%eax)
  80379b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037a1:	89 10                	mov    %edx,(%eax)
  8037a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a9:	89 50 04             	mov    %edx,0x4(%eax)
  8037ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	75 08                	jne    8037bd <alloc_block_BF+0x398>
  8037b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037b8:	a3 48 60 80 00       	mov    %eax,0x806048
  8037bd:	a1 50 60 80 00       	mov    0x806050,%eax
  8037c2:	40                   	inc    %eax
  8037c3:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8037c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cc:	75 17                	jne    8037e5 <alloc_block_BF+0x3c0>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 4b 58 80 00       	push   $0x80584b
  8037d6:	68 51 01 00 00       	push   $0x151
  8037db:	68 69 58 80 00       	push   $0x805869
  8037e0:	e8 ac d8 ff ff       	call   801091 <_panic>
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	8b 00                	mov    (%eax),%eax
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	74 10                	je     8037fe <alloc_block_BF+0x3d9>
  8037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f6:	8b 52 04             	mov    0x4(%edx),%edx
  8037f9:	89 50 04             	mov    %edx,0x4(%eax)
  8037fc:	eb 0b                	jmp    803809 <alloc_block_BF+0x3e4>
  8037fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803801:	8b 40 04             	mov    0x4(%eax),%eax
  803804:	a3 48 60 80 00       	mov    %eax,0x806048
  803809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380c:	8b 40 04             	mov    0x4(%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 0f                	je     803822 <alloc_block_BF+0x3fd>
  803813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803816:	8b 40 04             	mov    0x4(%eax),%eax
  803819:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381c:	8b 12                	mov    (%edx),%edx
  80381e:	89 10                	mov    %edx,(%eax)
  803820:	eb 0a                	jmp    80382c <alloc_block_BF+0x407>
  803822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	a3 44 60 80 00       	mov    %eax,0x806044
  80382c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383f:	a1 50 60 80 00       	mov    0x806050,%eax
  803844:	48                   	dec    %eax
  803845:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  80384a:	83 ec 04             	sub    $0x4,%esp
  80384d:	6a 00                	push   $0x0
  80384f:	ff 75 d0             	pushl  -0x30(%ebp)
  803852:	ff 75 cc             	pushl  -0x34(%ebp)
  803855:	e8 e0 f6 ff ff       	call   802f3a <set_block_data>
  80385a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80385d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803860:	e9 a3 01 00 00       	jmp    803a08 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803865:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803869:	0f 85 9d 00 00 00    	jne    80390c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	6a 01                	push   $0x1
  803874:	ff 75 ec             	pushl  -0x14(%ebp)
  803877:	ff 75 f0             	pushl  -0x10(%ebp)
  80387a:	e8 bb f6 ff ff       	call   802f3a <set_block_data>
  80387f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803882:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803886:	75 17                	jne    80389f <alloc_block_BF+0x47a>
  803888:	83 ec 04             	sub    $0x4,%esp
  80388b:	68 4b 58 80 00       	push   $0x80584b
  803890:	68 58 01 00 00       	push   $0x158
  803895:	68 69 58 80 00       	push   $0x805869
  80389a:	e8 f2 d7 ff ff       	call   801091 <_panic>
  80389f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a2:	8b 00                	mov    (%eax),%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	74 10                	je     8038b8 <alloc_block_BF+0x493>
  8038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038b0:	8b 52 04             	mov    0x4(%edx),%edx
  8038b3:	89 50 04             	mov    %edx,0x4(%eax)
  8038b6:	eb 0b                	jmp    8038c3 <alloc_block_BF+0x49e>
  8038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bb:	8b 40 04             	mov    0x4(%eax),%eax
  8038be:	a3 48 60 80 00       	mov    %eax,0x806048
  8038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c6:	8b 40 04             	mov    0x4(%eax),%eax
  8038c9:	85 c0                	test   %eax,%eax
  8038cb:	74 0f                	je     8038dc <alloc_block_BF+0x4b7>
  8038cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d0:	8b 40 04             	mov    0x4(%eax),%eax
  8038d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d6:	8b 12                	mov    (%edx),%edx
  8038d8:	89 10                	mov    %edx,(%eax)
  8038da:	eb 0a                	jmp    8038e6 <alloc_block_BF+0x4c1>
  8038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	a3 44 60 80 00       	mov    %eax,0x806044
  8038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f9:	a1 50 60 80 00       	mov    0x806050,%eax
  8038fe:	48                   	dec    %eax
  8038ff:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803907:	e9 fc 00 00 00       	jmp    803a08 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	83 c0 08             	add    $0x8,%eax
  803912:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803915:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80391c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80391f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803922:	01 d0                	add    %edx,%eax
  803924:	48                   	dec    %eax
  803925:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803928:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80392b:	ba 00 00 00 00       	mov    $0x0,%edx
  803930:	f7 75 c4             	divl   -0x3c(%ebp)
  803933:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803936:	29 d0                	sub    %edx,%eax
  803938:	c1 e8 0c             	shr    $0xc,%eax
  80393b:	83 ec 0c             	sub    $0xc,%esp
  80393e:	50                   	push   %eax
  80393f:	e8 a4 e7 ff ff       	call   8020e8 <sbrk>
  803944:	83 c4 10             	add    $0x10,%esp
  803947:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80394a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80394e:	75 0a                	jne    80395a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803950:	b8 00 00 00 00       	mov    $0x0,%eax
  803955:	e9 ae 00 00 00       	jmp    803a08 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80395a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803961:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803964:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803967:	01 d0                	add    %edx,%eax
  803969:	48                   	dec    %eax
  80396a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80396d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803970:	ba 00 00 00 00       	mov    $0x0,%edx
  803975:	f7 75 b8             	divl   -0x48(%ebp)
  803978:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80397b:	29 d0                	sub    %edx,%eax
  80397d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803980:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803983:	01 d0                	add    %edx,%eax
  803985:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  80398a:	a1 48 a2 80 00       	mov    0x80a248,%eax
  80398f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803995:	83 ec 0c             	sub    $0xc,%esp
  803998:	68 10 59 80 00       	push   $0x805910
  80399d:	e8 ac d9 ff ff       	call   80134e <cprintf>
  8039a2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8039a5:	83 ec 08             	sub    $0x8,%esp
  8039a8:	ff 75 bc             	pushl  -0x44(%ebp)
  8039ab:	68 15 59 80 00       	push   $0x805915
  8039b0:	e8 99 d9 ff ff       	call   80134e <cprintf>
  8039b5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8039b8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8039bf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039c5:	01 d0                	add    %edx,%eax
  8039c7:	48                   	dec    %eax
  8039c8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8039cb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8039ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8039d3:	f7 75 b0             	divl   -0x50(%ebp)
  8039d6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8039d9:	29 d0                	sub    %edx,%eax
  8039db:	83 ec 04             	sub    $0x4,%esp
  8039de:	6a 01                	push   $0x1
  8039e0:	50                   	push   %eax
  8039e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8039e4:	e8 51 f5 ff ff       	call   802f3a <set_block_data>
  8039e9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8039ec:	83 ec 0c             	sub    $0xc,%esp
  8039ef:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f2:	e8 36 04 00 00       	call   803e2d <free_block>
  8039f7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8039fa:	83 ec 0c             	sub    $0xc,%esp
  8039fd:	ff 75 08             	pushl  0x8(%ebp)
  803a00:	e8 20 fa ff ff       	call   803425 <alloc_block_BF>
  803a05:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a08:	c9                   	leave  
  803a09:	c3                   	ret    

00803a0a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a0a:	55                   	push   %ebp
  803a0b:	89 e5                	mov    %esp,%ebp
  803a0d:	53                   	push   %ebx
  803a0e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a23:	74 1e                	je     803a43 <merging+0x39>
  803a25:	ff 75 08             	pushl  0x8(%ebp)
  803a28:	e8 bc f1 ff ff       	call   802be9 <get_block_size>
  803a2d:	83 c4 04             	add    $0x4,%esp
  803a30:	89 c2                	mov    %eax,%edx
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	01 d0                	add    %edx,%eax
  803a37:	3b 45 10             	cmp    0x10(%ebp),%eax
  803a3a:	75 07                	jne    803a43 <merging+0x39>
		prev_is_free = 1;
  803a3c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a47:	74 1e                	je     803a67 <merging+0x5d>
  803a49:	ff 75 10             	pushl  0x10(%ebp)
  803a4c:	e8 98 f1 ff ff       	call   802be9 <get_block_size>
  803a51:	83 c4 04             	add    $0x4,%esp
  803a54:	89 c2                	mov    %eax,%edx
  803a56:	8b 45 10             	mov    0x10(%ebp),%eax
  803a59:	01 d0                	add    %edx,%eax
  803a5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a5e:	75 07                	jne    803a67 <merging+0x5d>
		next_is_free = 1;
  803a60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6b:	0f 84 cc 00 00 00    	je     803b3d <merging+0x133>
  803a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a75:	0f 84 c2 00 00 00    	je     803b3d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803a7b:	ff 75 08             	pushl  0x8(%ebp)
  803a7e:	e8 66 f1 ff ff       	call   802be9 <get_block_size>
  803a83:	83 c4 04             	add    $0x4,%esp
  803a86:	89 c3                	mov    %eax,%ebx
  803a88:	ff 75 10             	pushl  0x10(%ebp)
  803a8b:	e8 59 f1 ff ff       	call   802be9 <get_block_size>
  803a90:	83 c4 04             	add    $0x4,%esp
  803a93:	01 c3                	add    %eax,%ebx
  803a95:	ff 75 0c             	pushl  0xc(%ebp)
  803a98:	e8 4c f1 ff ff       	call   802be9 <get_block_size>
  803a9d:	83 c4 04             	add    $0x4,%esp
  803aa0:	01 d8                	add    %ebx,%eax
  803aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803aa5:	6a 00                	push   $0x0
  803aa7:	ff 75 ec             	pushl  -0x14(%ebp)
  803aaa:	ff 75 08             	pushl  0x8(%ebp)
  803aad:	e8 88 f4 ff ff       	call   802f3a <set_block_data>
  803ab2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803ab5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ab9:	75 17                	jne    803ad2 <merging+0xc8>
  803abb:	83 ec 04             	sub    $0x4,%esp
  803abe:	68 4b 58 80 00       	push   $0x80584b
  803ac3:	68 7d 01 00 00       	push   $0x17d
  803ac8:	68 69 58 80 00       	push   $0x805869
  803acd:	e8 bf d5 ff ff       	call   801091 <_panic>
  803ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad5:	8b 00                	mov    (%eax),%eax
  803ad7:	85 c0                	test   %eax,%eax
  803ad9:	74 10                	je     803aeb <merging+0xe1>
  803adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ae3:	8b 52 04             	mov    0x4(%edx),%edx
  803ae6:	89 50 04             	mov    %edx,0x4(%eax)
  803ae9:	eb 0b                	jmp    803af6 <merging+0xec>
  803aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aee:	8b 40 04             	mov    0x4(%eax),%eax
  803af1:	a3 48 60 80 00       	mov    %eax,0x806048
  803af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af9:	8b 40 04             	mov    0x4(%eax),%eax
  803afc:	85 c0                	test   %eax,%eax
  803afe:	74 0f                	je     803b0f <merging+0x105>
  803b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b03:	8b 40 04             	mov    0x4(%eax),%eax
  803b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b09:	8b 12                	mov    (%edx),%edx
  803b0b:	89 10                	mov    %edx,(%eax)
  803b0d:	eb 0a                	jmp    803b19 <merging+0x10f>
  803b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	a3 44 60 80 00       	mov    %eax,0x806044
  803b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2c:	a1 50 60 80 00       	mov    0x806050,%eax
  803b31:	48                   	dec    %eax
  803b32:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803b37:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b38:	e9 ea 02 00 00       	jmp    803e27 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b41:	74 3b                	je     803b7e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803b43:	83 ec 0c             	sub    $0xc,%esp
  803b46:	ff 75 08             	pushl  0x8(%ebp)
  803b49:	e8 9b f0 ff ff       	call   802be9 <get_block_size>
  803b4e:	83 c4 10             	add    $0x10,%esp
  803b51:	89 c3                	mov    %eax,%ebx
  803b53:	83 ec 0c             	sub    $0xc,%esp
  803b56:	ff 75 10             	pushl  0x10(%ebp)
  803b59:	e8 8b f0 ff ff       	call   802be9 <get_block_size>
  803b5e:	83 c4 10             	add    $0x10,%esp
  803b61:	01 d8                	add    %ebx,%eax
  803b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b66:	83 ec 04             	sub    $0x4,%esp
  803b69:	6a 00                	push   $0x0
  803b6b:	ff 75 e8             	pushl  -0x18(%ebp)
  803b6e:	ff 75 08             	pushl  0x8(%ebp)
  803b71:	e8 c4 f3 ff ff       	call   802f3a <set_block_data>
  803b76:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b79:	e9 a9 02 00 00       	jmp    803e27 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803b7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b82:	0f 84 2d 01 00 00    	je     803cb5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803b88:	83 ec 0c             	sub    $0xc,%esp
  803b8b:	ff 75 10             	pushl  0x10(%ebp)
  803b8e:	e8 56 f0 ff ff       	call   802be9 <get_block_size>
  803b93:	83 c4 10             	add    $0x10,%esp
  803b96:	89 c3                	mov    %eax,%ebx
  803b98:	83 ec 0c             	sub    $0xc,%esp
  803b9b:	ff 75 0c             	pushl  0xc(%ebp)
  803b9e:	e8 46 f0 ff ff       	call   802be9 <get_block_size>
  803ba3:	83 c4 10             	add    $0x10,%esp
  803ba6:	01 d8                	add    %ebx,%eax
  803ba8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803bab:	83 ec 04             	sub    $0x4,%esp
  803bae:	6a 00                	push   $0x0
  803bb0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bb3:	ff 75 10             	pushl  0x10(%ebp)
  803bb6:	e8 7f f3 ff ff       	call   802f3a <set_block_data>
  803bbb:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  803bc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bc8:	74 06                	je     803bd0 <merging+0x1c6>
  803bca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bce:	75 17                	jne    803be7 <merging+0x1dd>
  803bd0:	83 ec 04             	sub    $0x4,%esp
  803bd3:	68 24 59 80 00       	push   $0x805924
  803bd8:	68 8d 01 00 00       	push   $0x18d
  803bdd:	68 69 58 80 00       	push   $0x805869
  803be2:	e8 aa d4 ff ff       	call   801091 <_panic>
  803be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bea:	8b 50 04             	mov    0x4(%eax),%edx
  803bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bf0:	89 50 04             	mov    %edx,0x4(%eax)
  803bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bf9:	89 10                	mov    %edx,(%eax)
  803bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	85 c0                	test   %eax,%eax
  803c03:	74 0d                	je     803c12 <merging+0x208>
  803c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c08:	8b 40 04             	mov    0x4(%eax),%eax
  803c0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c0e:	89 10                	mov    %edx,(%eax)
  803c10:	eb 08                	jmp    803c1a <merging+0x210>
  803c12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c15:	a3 44 60 80 00       	mov    %eax,0x806044
  803c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c20:	89 50 04             	mov    %edx,0x4(%eax)
  803c23:	a1 50 60 80 00       	mov    0x806050,%eax
  803c28:	40                   	inc    %eax
  803c29:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c32:	75 17                	jne    803c4b <merging+0x241>
  803c34:	83 ec 04             	sub    $0x4,%esp
  803c37:	68 4b 58 80 00       	push   $0x80584b
  803c3c:	68 8e 01 00 00       	push   $0x18e
  803c41:	68 69 58 80 00       	push   $0x805869
  803c46:	e8 46 d4 ff ff       	call   801091 <_panic>
  803c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4e:	8b 00                	mov    (%eax),%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	74 10                	je     803c64 <merging+0x25a>
  803c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c5c:	8b 52 04             	mov    0x4(%edx),%edx
  803c5f:	89 50 04             	mov    %edx,0x4(%eax)
  803c62:	eb 0b                	jmp    803c6f <merging+0x265>
  803c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c67:	8b 40 04             	mov    0x4(%eax),%eax
  803c6a:	a3 48 60 80 00       	mov    %eax,0x806048
  803c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c72:	8b 40 04             	mov    0x4(%eax),%eax
  803c75:	85 c0                	test   %eax,%eax
  803c77:	74 0f                	je     803c88 <merging+0x27e>
  803c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c7c:	8b 40 04             	mov    0x4(%eax),%eax
  803c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c82:	8b 12                	mov    (%edx),%edx
  803c84:	89 10                	mov    %edx,(%eax)
  803c86:	eb 0a                	jmp    803c92 <merging+0x288>
  803c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8b:	8b 00                	mov    (%eax),%eax
  803c8d:	a3 44 60 80 00       	mov    %eax,0x806044
  803c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca5:	a1 50 60 80 00       	mov    0x806050,%eax
  803caa:	48                   	dec    %eax
  803cab:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803cb0:	e9 72 01 00 00       	jmp    803e27 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  803cb8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803cbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cbf:	74 79                	je     803d3a <merging+0x330>
  803cc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cc5:	74 73                	je     803d3a <merging+0x330>
  803cc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ccb:	74 06                	je     803cd3 <merging+0x2c9>
  803ccd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cd1:	75 17                	jne    803cea <merging+0x2e0>
  803cd3:	83 ec 04             	sub    $0x4,%esp
  803cd6:	68 dc 58 80 00       	push   $0x8058dc
  803cdb:	68 94 01 00 00       	push   $0x194
  803ce0:	68 69 58 80 00       	push   $0x805869
  803ce5:	e8 a7 d3 ff ff       	call   801091 <_panic>
  803cea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ced:	8b 10                	mov    (%eax),%edx
  803cef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf2:	89 10                	mov    %edx,(%eax)
  803cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	85 c0                	test   %eax,%eax
  803cfb:	74 0b                	je     803d08 <merging+0x2fe>
  803cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d05:	89 50 04             	mov    %edx,0x4(%eax)
  803d08:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d0e:	89 10                	mov    %edx,(%eax)
  803d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d13:	8b 55 08             	mov    0x8(%ebp),%edx
  803d16:	89 50 04             	mov    %edx,0x4(%eax)
  803d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1c:	8b 00                	mov    (%eax),%eax
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	75 08                	jne    803d2a <merging+0x320>
  803d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d25:	a3 48 60 80 00       	mov    %eax,0x806048
  803d2a:	a1 50 60 80 00       	mov    0x806050,%eax
  803d2f:	40                   	inc    %eax
  803d30:	a3 50 60 80 00       	mov    %eax,0x806050
  803d35:	e9 ce 00 00 00       	jmp    803e08 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803d3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d3e:	74 65                	je     803da5 <merging+0x39b>
  803d40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d44:	75 17                	jne    803d5d <merging+0x353>
  803d46:	83 ec 04             	sub    $0x4,%esp
  803d49:	68 b8 58 80 00       	push   $0x8058b8
  803d4e:	68 95 01 00 00       	push   $0x195
  803d53:	68 69 58 80 00       	push   $0x805869
  803d58:	e8 34 d3 ff ff       	call   801091 <_panic>
  803d5d:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803d63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d66:	89 50 04             	mov    %edx,0x4(%eax)
  803d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d6c:	8b 40 04             	mov    0x4(%eax),%eax
  803d6f:	85 c0                	test   %eax,%eax
  803d71:	74 0c                	je     803d7f <merging+0x375>
  803d73:	a1 48 60 80 00       	mov    0x806048,%eax
  803d78:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d7b:	89 10                	mov    %edx,(%eax)
  803d7d:	eb 08                	jmp    803d87 <merging+0x37d>
  803d7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d82:	a3 44 60 80 00       	mov    %eax,0x806044
  803d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d8a:	a3 48 60 80 00       	mov    %eax,0x806048
  803d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d98:	a1 50 60 80 00       	mov    0x806050,%eax
  803d9d:	40                   	inc    %eax
  803d9e:	a3 50 60 80 00       	mov    %eax,0x806050
  803da3:	eb 63                	jmp    803e08 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803da5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803da9:	75 17                	jne    803dc2 <merging+0x3b8>
  803dab:	83 ec 04             	sub    $0x4,%esp
  803dae:	68 84 58 80 00       	push   $0x805884
  803db3:	68 98 01 00 00       	push   $0x198
  803db8:	68 69 58 80 00       	push   $0x805869
  803dbd:	e8 cf d2 ff ff       	call   801091 <_panic>
  803dc2:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803dc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dcb:	89 10                	mov    %edx,(%eax)
  803dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	74 0d                	je     803de3 <merging+0x3d9>
  803dd6:	a1 44 60 80 00       	mov    0x806044,%eax
  803ddb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dde:	89 50 04             	mov    %edx,0x4(%eax)
  803de1:	eb 08                	jmp    803deb <merging+0x3e1>
  803de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de6:	a3 48 60 80 00       	mov    %eax,0x806048
  803deb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dee:	a3 44 60 80 00       	mov    %eax,0x806044
  803df3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfd:	a1 50 60 80 00       	mov    0x806050,%eax
  803e02:	40                   	inc    %eax
  803e03:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803e08:	83 ec 0c             	sub    $0xc,%esp
  803e0b:	ff 75 10             	pushl  0x10(%ebp)
  803e0e:	e8 d6 ed ff ff       	call   802be9 <get_block_size>
  803e13:	83 c4 10             	add    $0x10,%esp
  803e16:	83 ec 04             	sub    $0x4,%esp
  803e19:	6a 00                	push   $0x0
  803e1b:	50                   	push   %eax
  803e1c:	ff 75 10             	pushl  0x10(%ebp)
  803e1f:	e8 16 f1 ff ff       	call   802f3a <set_block_data>
  803e24:	83 c4 10             	add    $0x10,%esp
	}
}
  803e27:	90                   	nop
  803e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e2b:	c9                   	leave  
  803e2c:	c3                   	ret    

00803e2d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e2d:	55                   	push   %ebp
  803e2e:	89 e5                	mov    %esp,%ebp
  803e30:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803e33:	a1 44 60 80 00       	mov    0x806044,%eax
  803e38:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803e3b:	a1 48 60 80 00       	mov    0x806048,%eax
  803e40:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e43:	73 1b                	jae    803e60 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803e45:	a1 48 60 80 00       	mov    0x806048,%eax
  803e4a:	83 ec 04             	sub    $0x4,%esp
  803e4d:	ff 75 08             	pushl  0x8(%ebp)
  803e50:	6a 00                	push   $0x0
  803e52:	50                   	push   %eax
  803e53:	e8 b2 fb ff ff       	call   803a0a <merging>
  803e58:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e5b:	e9 8b 00 00 00       	jmp    803eeb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803e60:	a1 44 60 80 00       	mov    0x806044,%eax
  803e65:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e68:	76 18                	jbe    803e82 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803e6a:	a1 44 60 80 00       	mov    0x806044,%eax
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	ff 75 08             	pushl  0x8(%ebp)
  803e75:	50                   	push   %eax
  803e76:	6a 00                	push   $0x0
  803e78:	e8 8d fb ff ff       	call   803a0a <merging>
  803e7d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e80:	eb 69                	jmp    803eeb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803e82:	a1 44 60 80 00       	mov    0x806044,%eax
  803e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8a:	eb 39                	jmp    803ec5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e92:	73 29                	jae    803ebd <free_block+0x90>
  803e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e97:	8b 00                	mov    (%eax),%eax
  803e99:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e9c:	76 1f                	jbe    803ebd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea1:	8b 00                	mov    (%eax),%eax
  803ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ea6:	83 ec 04             	sub    $0x4,%esp
  803ea9:	ff 75 08             	pushl  0x8(%ebp)
  803eac:	ff 75 f0             	pushl  -0x10(%ebp)
  803eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  803eb2:	e8 53 fb ff ff       	call   803a0a <merging>
  803eb7:	83 c4 10             	add    $0x10,%esp
			break;
  803eba:	90                   	nop
		}
	}
}
  803ebb:	eb 2e                	jmp    803eeb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ebd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ec5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ec9:	74 07                	je     803ed2 <free_block+0xa5>
  803ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	eb 05                	jmp    803ed7 <free_block+0xaa>
  803ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed7:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803edc:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803ee1:	85 c0                	test   %eax,%eax
  803ee3:	75 a7                	jne    803e8c <free_block+0x5f>
  803ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ee9:	75 a1                	jne    803e8c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803eeb:	90                   	nop
  803eec:	c9                   	leave  
  803eed:	c3                   	ret    

00803eee <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803eee:	55                   	push   %ebp
  803eef:	89 e5                	mov    %esp,%ebp
  803ef1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803ef4:	ff 75 08             	pushl  0x8(%ebp)
  803ef7:	e8 ed ec ff ff       	call   802be9 <get_block_size>
  803efc:	83 c4 04             	add    $0x4,%esp
  803eff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f09:	eb 17                	jmp    803f22 <copy_data+0x34>
  803f0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f11:	01 c2                	add    %eax,%edx
  803f13:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f16:	8b 45 08             	mov    0x8(%ebp),%eax
  803f19:	01 c8                	add    %ecx,%eax
  803f1b:	8a 00                	mov    (%eax),%al
  803f1d:	88 02                	mov    %al,(%edx)
  803f1f:	ff 45 fc             	incl   -0x4(%ebp)
  803f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f28:	72 e1                	jb     803f0b <copy_data+0x1d>
}
  803f2a:	90                   	nop
  803f2b:	c9                   	leave  
  803f2c:	c3                   	ret    

00803f2d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f2d:	55                   	push   %ebp
  803f2e:	89 e5                	mov    %esp,%ebp
  803f30:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803f33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f37:	75 23                	jne    803f5c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803f39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f3d:	74 13                	je     803f52 <realloc_block_FF+0x25>
  803f3f:	83 ec 0c             	sub    $0xc,%esp
  803f42:	ff 75 0c             	pushl  0xc(%ebp)
  803f45:	e8 1f f0 ff ff       	call   802f69 <alloc_block_FF>
  803f4a:	83 c4 10             	add    $0x10,%esp
  803f4d:	e9 f4 06 00 00       	jmp    804646 <realloc_block_FF+0x719>
		return NULL;
  803f52:	b8 00 00 00 00       	mov    $0x0,%eax
  803f57:	e9 ea 06 00 00       	jmp    804646 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803f5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f60:	75 18                	jne    803f7a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803f62:	83 ec 0c             	sub    $0xc,%esp
  803f65:	ff 75 08             	pushl  0x8(%ebp)
  803f68:	e8 c0 fe ff ff       	call   803e2d <free_block>
  803f6d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803f70:	b8 00 00 00 00       	mov    $0x0,%eax
  803f75:	e9 cc 06 00 00       	jmp    804646 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803f7a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803f7e:	77 07                	ja     803f87 <realloc_block_FF+0x5a>
  803f80:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f8a:	83 e0 01             	and    $0x1,%eax
  803f8d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f93:	83 c0 08             	add    $0x8,%eax
  803f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803f99:	83 ec 0c             	sub    $0xc,%esp
  803f9c:	ff 75 08             	pushl  0x8(%ebp)
  803f9f:	e8 45 ec ff ff       	call   802be9 <get_block_size>
  803fa4:	83 c4 10             	add    $0x10,%esp
  803fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fad:	83 e8 08             	sub    $0x8,%eax
  803fb0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb6:	83 e8 04             	sub    $0x4,%eax
  803fb9:	8b 00                	mov    (%eax),%eax
  803fbb:	83 e0 fe             	and    $0xfffffffe,%eax
  803fbe:	89 c2                	mov    %eax,%edx
  803fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc3:	01 d0                	add    %edx,%eax
  803fc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803fc8:	83 ec 0c             	sub    $0xc,%esp
  803fcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fce:	e8 16 ec ff ff       	call   802be9 <get_block_size>
  803fd3:	83 c4 10             	add    $0x10,%esp
  803fd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fdc:	83 e8 08             	sub    $0x8,%eax
  803fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fe8:	75 08                	jne    803ff2 <realloc_block_FF+0xc5>
	{
		 return va;
  803fea:	8b 45 08             	mov    0x8(%ebp),%eax
  803fed:	e9 54 06 00 00       	jmp    804646 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ff8:	0f 83 e5 03 00 00    	jae    8043e3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804001:	2b 45 0c             	sub    0xc(%ebp),%eax
  804004:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804007:	83 ec 0c             	sub    $0xc,%esp
  80400a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80400d:	e8 f0 eb ff ff       	call   802c02 <is_free_block>
  804012:	83 c4 10             	add    $0x10,%esp
  804015:	84 c0                	test   %al,%al
  804017:	0f 84 3b 01 00 00    	je     804158 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80401d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804020:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804023:	01 d0                	add    %edx,%eax
  804025:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804028:	83 ec 04             	sub    $0x4,%esp
  80402b:	6a 01                	push   $0x1
  80402d:	ff 75 f0             	pushl  -0x10(%ebp)
  804030:	ff 75 08             	pushl  0x8(%ebp)
  804033:	e8 02 ef ff ff       	call   802f3a <set_block_data>
  804038:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80403b:	8b 45 08             	mov    0x8(%ebp),%eax
  80403e:	83 e8 04             	sub    $0x4,%eax
  804041:	8b 00                	mov    (%eax),%eax
  804043:	83 e0 fe             	and    $0xfffffffe,%eax
  804046:	89 c2                	mov    %eax,%edx
  804048:	8b 45 08             	mov    0x8(%ebp),%eax
  80404b:	01 d0                	add    %edx,%eax
  80404d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804050:	83 ec 04             	sub    $0x4,%esp
  804053:	6a 00                	push   $0x0
  804055:	ff 75 cc             	pushl  -0x34(%ebp)
  804058:	ff 75 c8             	pushl  -0x38(%ebp)
  80405b:	e8 da ee ff ff       	call   802f3a <set_block_data>
  804060:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804063:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804067:	74 06                	je     80406f <realloc_block_FF+0x142>
  804069:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80406d:	75 17                	jne    804086 <realloc_block_FF+0x159>
  80406f:	83 ec 04             	sub    $0x4,%esp
  804072:	68 dc 58 80 00       	push   $0x8058dc
  804077:	68 f6 01 00 00       	push   $0x1f6
  80407c:	68 69 58 80 00       	push   $0x805869
  804081:	e8 0b d0 ff ff       	call   801091 <_panic>
  804086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804089:	8b 10                	mov    (%eax),%edx
  80408b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80408e:	89 10                	mov    %edx,(%eax)
  804090:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804093:	8b 00                	mov    (%eax),%eax
  804095:	85 c0                	test   %eax,%eax
  804097:	74 0b                	je     8040a4 <realloc_block_FF+0x177>
  804099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409c:	8b 00                	mov    (%eax),%eax
  80409e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040a1:	89 50 04             	mov    %edx,0x4(%eax)
  8040a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040aa:	89 10                	mov    %edx,(%eax)
  8040ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040b2:	89 50 04             	mov    %edx,0x4(%eax)
  8040b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040b8:	8b 00                	mov    (%eax),%eax
  8040ba:	85 c0                	test   %eax,%eax
  8040bc:	75 08                	jne    8040c6 <realloc_block_FF+0x199>
  8040be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040c1:	a3 48 60 80 00       	mov    %eax,0x806048
  8040c6:	a1 50 60 80 00       	mov    0x806050,%eax
  8040cb:	40                   	inc    %eax
  8040cc:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040d5:	75 17                	jne    8040ee <realloc_block_FF+0x1c1>
  8040d7:	83 ec 04             	sub    $0x4,%esp
  8040da:	68 4b 58 80 00       	push   $0x80584b
  8040df:	68 f7 01 00 00       	push   $0x1f7
  8040e4:	68 69 58 80 00       	push   $0x805869
  8040e9:	e8 a3 cf ff ff       	call   801091 <_panic>
  8040ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f1:	8b 00                	mov    (%eax),%eax
  8040f3:	85 c0                	test   %eax,%eax
  8040f5:	74 10                	je     804107 <realloc_block_FF+0x1da>
  8040f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040fa:	8b 00                	mov    (%eax),%eax
  8040fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ff:	8b 52 04             	mov    0x4(%edx),%edx
  804102:	89 50 04             	mov    %edx,0x4(%eax)
  804105:	eb 0b                	jmp    804112 <realloc_block_FF+0x1e5>
  804107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410a:	8b 40 04             	mov    0x4(%eax),%eax
  80410d:	a3 48 60 80 00       	mov    %eax,0x806048
  804112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804115:	8b 40 04             	mov    0x4(%eax),%eax
  804118:	85 c0                	test   %eax,%eax
  80411a:	74 0f                	je     80412b <realloc_block_FF+0x1fe>
  80411c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411f:	8b 40 04             	mov    0x4(%eax),%eax
  804122:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804125:	8b 12                	mov    (%edx),%edx
  804127:	89 10                	mov    %edx,(%eax)
  804129:	eb 0a                	jmp    804135 <realloc_block_FF+0x208>
  80412b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412e:	8b 00                	mov    (%eax),%eax
  804130:	a3 44 60 80 00       	mov    %eax,0x806044
  804135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80413e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804148:	a1 50 60 80 00       	mov    0x806050,%eax
  80414d:	48                   	dec    %eax
  80414e:	a3 50 60 80 00       	mov    %eax,0x806050
  804153:	e9 83 02 00 00       	jmp    8043db <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804158:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80415c:	0f 86 69 02 00 00    	jbe    8043cb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804162:	83 ec 04             	sub    $0x4,%esp
  804165:	6a 01                	push   $0x1
  804167:	ff 75 f0             	pushl  -0x10(%ebp)
  80416a:	ff 75 08             	pushl  0x8(%ebp)
  80416d:	e8 c8 ed ff ff       	call   802f3a <set_block_data>
  804172:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804175:	8b 45 08             	mov    0x8(%ebp),%eax
  804178:	83 e8 04             	sub    $0x4,%eax
  80417b:	8b 00                	mov    (%eax),%eax
  80417d:	83 e0 fe             	and    $0xfffffffe,%eax
  804180:	89 c2                	mov    %eax,%edx
  804182:	8b 45 08             	mov    0x8(%ebp),%eax
  804185:	01 d0                	add    %edx,%eax
  804187:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80418a:	a1 50 60 80 00       	mov    0x806050,%eax
  80418f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804192:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804196:	75 68                	jne    804200 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804198:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80419c:	75 17                	jne    8041b5 <realloc_block_FF+0x288>
  80419e:	83 ec 04             	sub    $0x4,%esp
  8041a1:	68 84 58 80 00       	push   $0x805884
  8041a6:	68 06 02 00 00       	push   $0x206
  8041ab:	68 69 58 80 00       	push   $0x805869
  8041b0:	e8 dc ce ff ff       	call   801091 <_panic>
  8041b5:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8041bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041be:	89 10                	mov    %edx,(%eax)
  8041c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c3:	8b 00                	mov    (%eax),%eax
  8041c5:	85 c0                	test   %eax,%eax
  8041c7:	74 0d                	je     8041d6 <realloc_block_FF+0x2a9>
  8041c9:	a1 44 60 80 00       	mov    0x806044,%eax
  8041ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041d1:	89 50 04             	mov    %edx,0x4(%eax)
  8041d4:	eb 08                	jmp    8041de <realloc_block_FF+0x2b1>
  8041d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041d9:	a3 48 60 80 00       	mov    %eax,0x806048
  8041de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e1:	a3 44 60 80 00       	mov    %eax,0x806044
  8041e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041f0:	a1 50 60 80 00       	mov    0x806050,%eax
  8041f5:	40                   	inc    %eax
  8041f6:	a3 50 60 80 00       	mov    %eax,0x806050
  8041fb:	e9 b0 01 00 00       	jmp    8043b0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804200:	a1 44 60 80 00       	mov    0x806044,%eax
  804205:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804208:	76 68                	jbe    804272 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80420a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80420e:	75 17                	jne    804227 <realloc_block_FF+0x2fa>
  804210:	83 ec 04             	sub    $0x4,%esp
  804213:	68 84 58 80 00       	push   $0x805884
  804218:	68 0b 02 00 00       	push   $0x20b
  80421d:	68 69 58 80 00       	push   $0x805869
  804222:	e8 6a ce ff ff       	call   801091 <_panic>
  804227:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80422d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804230:	89 10                	mov    %edx,(%eax)
  804232:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804235:	8b 00                	mov    (%eax),%eax
  804237:	85 c0                	test   %eax,%eax
  804239:	74 0d                	je     804248 <realloc_block_FF+0x31b>
  80423b:	a1 44 60 80 00       	mov    0x806044,%eax
  804240:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804243:	89 50 04             	mov    %edx,0x4(%eax)
  804246:	eb 08                	jmp    804250 <realloc_block_FF+0x323>
  804248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80424b:	a3 48 60 80 00       	mov    %eax,0x806048
  804250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804253:	a3 44 60 80 00       	mov    %eax,0x806044
  804258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80425b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804262:	a1 50 60 80 00       	mov    0x806050,%eax
  804267:	40                   	inc    %eax
  804268:	a3 50 60 80 00       	mov    %eax,0x806050
  80426d:	e9 3e 01 00 00       	jmp    8043b0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804272:	a1 44 60 80 00       	mov    0x806044,%eax
  804277:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80427a:	73 68                	jae    8042e4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80427c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804280:	75 17                	jne    804299 <realloc_block_FF+0x36c>
  804282:	83 ec 04             	sub    $0x4,%esp
  804285:	68 b8 58 80 00       	push   $0x8058b8
  80428a:	68 10 02 00 00       	push   $0x210
  80428f:	68 69 58 80 00       	push   $0x805869
  804294:	e8 f8 cd ff ff       	call   801091 <_panic>
  804299:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80429f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042a2:	89 50 04             	mov    %edx,0x4(%eax)
  8042a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042a8:	8b 40 04             	mov    0x4(%eax),%eax
  8042ab:	85 c0                	test   %eax,%eax
  8042ad:	74 0c                	je     8042bb <realloc_block_FF+0x38e>
  8042af:	a1 48 60 80 00       	mov    0x806048,%eax
  8042b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042b7:	89 10                	mov    %edx,(%eax)
  8042b9:	eb 08                	jmp    8042c3 <realloc_block_FF+0x396>
  8042bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042be:	a3 44 60 80 00       	mov    %eax,0x806044
  8042c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042c6:	a3 48 60 80 00       	mov    %eax,0x806048
  8042cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042d4:	a1 50 60 80 00       	mov    0x806050,%eax
  8042d9:	40                   	inc    %eax
  8042da:	a3 50 60 80 00       	mov    %eax,0x806050
  8042df:	e9 cc 00 00 00       	jmp    8043b0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8042e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8042eb:	a1 44 60 80 00       	mov    0x806044,%eax
  8042f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042f3:	e9 8a 00 00 00       	jmp    804382 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042fe:	73 7a                	jae    80437a <realloc_block_FF+0x44d>
  804300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804303:	8b 00                	mov    (%eax),%eax
  804305:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804308:	73 70                	jae    80437a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80430a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80430e:	74 06                	je     804316 <realloc_block_FF+0x3e9>
  804310:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804314:	75 17                	jne    80432d <realloc_block_FF+0x400>
  804316:	83 ec 04             	sub    $0x4,%esp
  804319:	68 dc 58 80 00       	push   $0x8058dc
  80431e:	68 1a 02 00 00       	push   $0x21a
  804323:	68 69 58 80 00       	push   $0x805869
  804328:	e8 64 cd ff ff       	call   801091 <_panic>
  80432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804330:	8b 10                	mov    (%eax),%edx
  804332:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804335:	89 10                	mov    %edx,(%eax)
  804337:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80433a:	8b 00                	mov    (%eax),%eax
  80433c:	85 c0                	test   %eax,%eax
  80433e:	74 0b                	je     80434b <realloc_block_FF+0x41e>
  804340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804343:	8b 00                	mov    (%eax),%eax
  804345:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804348:	89 50 04             	mov    %edx,0x4(%eax)
  80434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80434e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804351:	89 10                	mov    %edx,(%eax)
  804353:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804359:	89 50 04             	mov    %edx,0x4(%eax)
  80435c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80435f:	8b 00                	mov    (%eax),%eax
  804361:	85 c0                	test   %eax,%eax
  804363:	75 08                	jne    80436d <realloc_block_FF+0x440>
  804365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804368:	a3 48 60 80 00       	mov    %eax,0x806048
  80436d:	a1 50 60 80 00       	mov    0x806050,%eax
  804372:	40                   	inc    %eax
  804373:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  804378:	eb 36                	jmp    8043b0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80437a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80437f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804386:	74 07                	je     80438f <realloc_block_FF+0x462>
  804388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80438b:	8b 00                	mov    (%eax),%eax
  80438d:	eb 05                	jmp    804394 <realloc_block_FF+0x467>
  80438f:	b8 00 00 00 00       	mov    $0x0,%eax
  804394:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804399:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80439e:	85 c0                	test   %eax,%eax
  8043a0:	0f 85 52 ff ff ff    	jne    8042f8 <realloc_block_FF+0x3cb>
  8043a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043aa:	0f 85 48 ff ff ff    	jne    8042f8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8043b0:	83 ec 04             	sub    $0x4,%esp
  8043b3:	6a 00                	push   $0x0
  8043b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8043b8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8043bb:	e8 7a eb ff ff       	call   802f3a <set_block_data>
  8043c0:	83 c4 10             	add    $0x10,%esp
				return va;
  8043c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c6:	e9 7b 02 00 00       	jmp    804646 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8043cb:	83 ec 0c             	sub    $0xc,%esp
  8043ce:	68 59 59 80 00       	push   $0x805959
  8043d3:	e8 76 cf ff ff       	call   80134e <cprintf>
  8043d8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8043db:	8b 45 08             	mov    0x8(%ebp),%eax
  8043de:	e9 63 02 00 00       	jmp    804646 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8043e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8043e9:	0f 86 4d 02 00 00    	jbe    80463c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8043ef:	83 ec 0c             	sub    $0xc,%esp
  8043f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8043f5:	e8 08 e8 ff ff       	call   802c02 <is_free_block>
  8043fa:	83 c4 10             	add    $0x10,%esp
  8043fd:	84 c0                	test   %al,%al
  8043ff:	0f 84 37 02 00 00    	je     80463c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804405:	8b 45 0c             	mov    0xc(%ebp),%eax
  804408:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80440b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80440e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804411:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804414:	76 38                	jbe    80444e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804416:	83 ec 0c             	sub    $0xc,%esp
  804419:	ff 75 08             	pushl  0x8(%ebp)
  80441c:	e8 0c fa ff ff       	call   803e2d <free_block>
  804421:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804424:	83 ec 0c             	sub    $0xc,%esp
  804427:	ff 75 0c             	pushl  0xc(%ebp)
  80442a:	e8 3a eb ff ff       	call   802f69 <alloc_block_FF>
  80442f:	83 c4 10             	add    $0x10,%esp
  804432:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804435:	83 ec 08             	sub    $0x8,%esp
  804438:	ff 75 c0             	pushl  -0x40(%ebp)
  80443b:	ff 75 08             	pushl  0x8(%ebp)
  80443e:	e8 ab fa ff ff       	call   803eee <copy_data>
  804443:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804446:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804449:	e9 f8 01 00 00       	jmp    804646 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80444e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804451:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804454:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804457:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80445b:	0f 87 a0 00 00 00    	ja     804501 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804461:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804465:	75 17                	jne    80447e <realloc_block_FF+0x551>
  804467:	83 ec 04             	sub    $0x4,%esp
  80446a:	68 4b 58 80 00       	push   $0x80584b
  80446f:	68 38 02 00 00       	push   $0x238
  804474:	68 69 58 80 00       	push   $0x805869
  804479:	e8 13 cc ff ff       	call   801091 <_panic>
  80447e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804481:	8b 00                	mov    (%eax),%eax
  804483:	85 c0                	test   %eax,%eax
  804485:	74 10                	je     804497 <realloc_block_FF+0x56a>
  804487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80448a:	8b 00                	mov    (%eax),%eax
  80448c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80448f:	8b 52 04             	mov    0x4(%edx),%edx
  804492:	89 50 04             	mov    %edx,0x4(%eax)
  804495:	eb 0b                	jmp    8044a2 <realloc_block_FF+0x575>
  804497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80449a:	8b 40 04             	mov    0x4(%eax),%eax
  80449d:	a3 48 60 80 00       	mov    %eax,0x806048
  8044a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044a5:	8b 40 04             	mov    0x4(%eax),%eax
  8044a8:	85 c0                	test   %eax,%eax
  8044aa:	74 0f                	je     8044bb <realloc_block_FF+0x58e>
  8044ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044af:	8b 40 04             	mov    0x4(%eax),%eax
  8044b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044b5:	8b 12                	mov    (%edx),%edx
  8044b7:	89 10                	mov    %edx,(%eax)
  8044b9:	eb 0a                	jmp    8044c5 <realloc_block_FF+0x598>
  8044bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044be:	8b 00                	mov    (%eax),%eax
  8044c0:	a3 44 60 80 00       	mov    %eax,0x806044
  8044c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044d8:	a1 50 60 80 00       	mov    0x806050,%eax
  8044dd:	48                   	dec    %eax
  8044de:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8044e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8044e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044e9:	01 d0                	add    %edx,%eax
  8044eb:	83 ec 04             	sub    $0x4,%esp
  8044ee:	6a 01                	push   $0x1
  8044f0:	50                   	push   %eax
  8044f1:	ff 75 08             	pushl  0x8(%ebp)
  8044f4:	e8 41 ea ff ff       	call   802f3a <set_block_data>
  8044f9:	83 c4 10             	add    $0x10,%esp
  8044fc:	e9 36 01 00 00       	jmp    804637 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804501:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804504:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804507:	01 d0                	add    %edx,%eax
  804509:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80450c:	83 ec 04             	sub    $0x4,%esp
  80450f:	6a 01                	push   $0x1
  804511:	ff 75 f0             	pushl  -0x10(%ebp)
  804514:	ff 75 08             	pushl  0x8(%ebp)
  804517:	e8 1e ea ff ff       	call   802f3a <set_block_data>
  80451c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80451f:	8b 45 08             	mov    0x8(%ebp),%eax
  804522:	83 e8 04             	sub    $0x4,%eax
  804525:	8b 00                	mov    (%eax),%eax
  804527:	83 e0 fe             	and    $0xfffffffe,%eax
  80452a:	89 c2                	mov    %eax,%edx
  80452c:	8b 45 08             	mov    0x8(%ebp),%eax
  80452f:	01 d0                	add    %edx,%eax
  804531:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804534:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804538:	74 06                	je     804540 <realloc_block_FF+0x613>
  80453a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80453e:	75 17                	jne    804557 <realloc_block_FF+0x62a>
  804540:	83 ec 04             	sub    $0x4,%esp
  804543:	68 dc 58 80 00       	push   $0x8058dc
  804548:	68 44 02 00 00       	push   $0x244
  80454d:	68 69 58 80 00       	push   $0x805869
  804552:	e8 3a cb ff ff       	call   801091 <_panic>
  804557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80455a:	8b 10                	mov    (%eax),%edx
  80455c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80455f:	89 10                	mov    %edx,(%eax)
  804561:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804564:	8b 00                	mov    (%eax),%eax
  804566:	85 c0                	test   %eax,%eax
  804568:	74 0b                	je     804575 <realloc_block_FF+0x648>
  80456a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80456d:	8b 00                	mov    (%eax),%eax
  80456f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804572:	89 50 04             	mov    %edx,0x4(%eax)
  804575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804578:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80457b:	89 10                	mov    %edx,(%eax)
  80457d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804580:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804583:	89 50 04             	mov    %edx,0x4(%eax)
  804586:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804589:	8b 00                	mov    (%eax),%eax
  80458b:	85 c0                	test   %eax,%eax
  80458d:	75 08                	jne    804597 <realloc_block_FF+0x66a>
  80458f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804592:	a3 48 60 80 00       	mov    %eax,0x806048
  804597:	a1 50 60 80 00       	mov    0x806050,%eax
  80459c:	40                   	inc    %eax
  80459d:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045a6:	75 17                	jne    8045bf <realloc_block_FF+0x692>
  8045a8:	83 ec 04             	sub    $0x4,%esp
  8045ab:	68 4b 58 80 00       	push   $0x80584b
  8045b0:	68 45 02 00 00       	push   $0x245
  8045b5:	68 69 58 80 00       	push   $0x805869
  8045ba:	e8 d2 ca ff ff       	call   801091 <_panic>
  8045bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c2:	8b 00                	mov    (%eax),%eax
  8045c4:	85 c0                	test   %eax,%eax
  8045c6:	74 10                	je     8045d8 <realloc_block_FF+0x6ab>
  8045c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045cb:	8b 00                	mov    (%eax),%eax
  8045cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045d0:	8b 52 04             	mov    0x4(%edx),%edx
  8045d3:	89 50 04             	mov    %edx,0x4(%eax)
  8045d6:	eb 0b                	jmp    8045e3 <realloc_block_FF+0x6b6>
  8045d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045db:	8b 40 04             	mov    0x4(%eax),%eax
  8045de:	a3 48 60 80 00       	mov    %eax,0x806048
  8045e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e6:	8b 40 04             	mov    0x4(%eax),%eax
  8045e9:	85 c0                	test   %eax,%eax
  8045eb:	74 0f                	je     8045fc <realloc_block_FF+0x6cf>
  8045ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f0:	8b 40 04             	mov    0x4(%eax),%eax
  8045f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045f6:	8b 12                	mov    (%edx),%edx
  8045f8:	89 10                	mov    %edx,(%eax)
  8045fa:	eb 0a                	jmp    804606 <realloc_block_FF+0x6d9>
  8045fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ff:	8b 00                	mov    (%eax),%eax
  804601:	a3 44 60 80 00       	mov    %eax,0x806044
  804606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80460f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804619:	a1 50 60 80 00       	mov    0x806050,%eax
  80461e:	48                   	dec    %eax
  80461f:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804624:	83 ec 04             	sub    $0x4,%esp
  804627:	6a 00                	push   $0x0
  804629:	ff 75 bc             	pushl  -0x44(%ebp)
  80462c:	ff 75 b8             	pushl  -0x48(%ebp)
  80462f:	e8 06 e9 ff ff       	call   802f3a <set_block_data>
  804634:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804637:	8b 45 08             	mov    0x8(%ebp),%eax
  80463a:	eb 0a                	jmp    804646 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80463c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804643:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804646:	c9                   	leave  
  804647:	c3                   	ret    

00804648 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804648:	55                   	push   %ebp
  804649:	89 e5                	mov    %esp,%ebp
  80464b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80464e:	83 ec 04             	sub    $0x4,%esp
  804651:	68 60 59 80 00       	push   $0x805960
  804656:	68 58 02 00 00       	push   $0x258
  80465b:	68 69 58 80 00       	push   $0x805869
  804660:	e8 2c ca ff ff       	call   801091 <_panic>

00804665 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804665:	55                   	push   %ebp
  804666:	89 e5                	mov    %esp,%ebp
  804668:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80466b:	83 ec 04             	sub    $0x4,%esp
  80466e:	68 88 59 80 00       	push   $0x805988
  804673:	68 61 02 00 00       	push   $0x261
  804678:	68 69 58 80 00       	push   $0x805869
  80467d:	e8 0f ca ff ff       	call   801091 <_panic>
  804682:	66 90                	xchg   %ax,%ax

00804684 <__udivdi3>:
  804684:	55                   	push   %ebp
  804685:	57                   	push   %edi
  804686:	56                   	push   %esi
  804687:	53                   	push   %ebx
  804688:	83 ec 1c             	sub    $0x1c,%esp
  80468b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80468f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80469b:	89 ca                	mov    %ecx,%edx
  80469d:	89 f8                	mov    %edi,%eax
  80469f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046a3:	85 f6                	test   %esi,%esi
  8046a5:	75 2d                	jne    8046d4 <__udivdi3+0x50>
  8046a7:	39 cf                	cmp    %ecx,%edi
  8046a9:	77 65                	ja     804710 <__udivdi3+0x8c>
  8046ab:	89 fd                	mov    %edi,%ebp
  8046ad:	85 ff                	test   %edi,%edi
  8046af:	75 0b                	jne    8046bc <__udivdi3+0x38>
  8046b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8046b6:	31 d2                	xor    %edx,%edx
  8046b8:	f7 f7                	div    %edi
  8046ba:	89 c5                	mov    %eax,%ebp
  8046bc:	31 d2                	xor    %edx,%edx
  8046be:	89 c8                	mov    %ecx,%eax
  8046c0:	f7 f5                	div    %ebp
  8046c2:	89 c1                	mov    %eax,%ecx
  8046c4:	89 d8                	mov    %ebx,%eax
  8046c6:	f7 f5                	div    %ebp
  8046c8:	89 cf                	mov    %ecx,%edi
  8046ca:	89 fa                	mov    %edi,%edx
  8046cc:	83 c4 1c             	add    $0x1c,%esp
  8046cf:	5b                   	pop    %ebx
  8046d0:	5e                   	pop    %esi
  8046d1:	5f                   	pop    %edi
  8046d2:	5d                   	pop    %ebp
  8046d3:	c3                   	ret    
  8046d4:	39 ce                	cmp    %ecx,%esi
  8046d6:	77 28                	ja     804700 <__udivdi3+0x7c>
  8046d8:	0f bd fe             	bsr    %esi,%edi
  8046db:	83 f7 1f             	xor    $0x1f,%edi
  8046de:	75 40                	jne    804720 <__udivdi3+0x9c>
  8046e0:	39 ce                	cmp    %ecx,%esi
  8046e2:	72 0a                	jb     8046ee <__udivdi3+0x6a>
  8046e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8046e8:	0f 87 9e 00 00 00    	ja     80478c <__udivdi3+0x108>
  8046ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8046f3:	89 fa                	mov    %edi,%edx
  8046f5:	83 c4 1c             	add    $0x1c,%esp
  8046f8:	5b                   	pop    %ebx
  8046f9:	5e                   	pop    %esi
  8046fa:	5f                   	pop    %edi
  8046fb:	5d                   	pop    %ebp
  8046fc:	c3                   	ret    
  8046fd:	8d 76 00             	lea    0x0(%esi),%esi
  804700:	31 ff                	xor    %edi,%edi
  804702:	31 c0                	xor    %eax,%eax
  804704:	89 fa                	mov    %edi,%edx
  804706:	83 c4 1c             	add    $0x1c,%esp
  804709:	5b                   	pop    %ebx
  80470a:	5e                   	pop    %esi
  80470b:	5f                   	pop    %edi
  80470c:	5d                   	pop    %ebp
  80470d:	c3                   	ret    
  80470e:	66 90                	xchg   %ax,%ax
  804710:	89 d8                	mov    %ebx,%eax
  804712:	f7 f7                	div    %edi
  804714:	31 ff                	xor    %edi,%edi
  804716:	89 fa                	mov    %edi,%edx
  804718:	83 c4 1c             	add    $0x1c,%esp
  80471b:	5b                   	pop    %ebx
  80471c:	5e                   	pop    %esi
  80471d:	5f                   	pop    %edi
  80471e:	5d                   	pop    %ebp
  80471f:	c3                   	ret    
  804720:	bd 20 00 00 00       	mov    $0x20,%ebp
  804725:	89 eb                	mov    %ebp,%ebx
  804727:	29 fb                	sub    %edi,%ebx
  804729:	89 f9                	mov    %edi,%ecx
  80472b:	d3 e6                	shl    %cl,%esi
  80472d:	89 c5                	mov    %eax,%ebp
  80472f:	88 d9                	mov    %bl,%cl
  804731:	d3 ed                	shr    %cl,%ebp
  804733:	89 e9                	mov    %ebp,%ecx
  804735:	09 f1                	or     %esi,%ecx
  804737:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80473b:	89 f9                	mov    %edi,%ecx
  80473d:	d3 e0                	shl    %cl,%eax
  80473f:	89 c5                	mov    %eax,%ebp
  804741:	89 d6                	mov    %edx,%esi
  804743:	88 d9                	mov    %bl,%cl
  804745:	d3 ee                	shr    %cl,%esi
  804747:	89 f9                	mov    %edi,%ecx
  804749:	d3 e2                	shl    %cl,%edx
  80474b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80474f:	88 d9                	mov    %bl,%cl
  804751:	d3 e8                	shr    %cl,%eax
  804753:	09 c2                	or     %eax,%edx
  804755:	89 d0                	mov    %edx,%eax
  804757:	89 f2                	mov    %esi,%edx
  804759:	f7 74 24 0c          	divl   0xc(%esp)
  80475d:	89 d6                	mov    %edx,%esi
  80475f:	89 c3                	mov    %eax,%ebx
  804761:	f7 e5                	mul    %ebp
  804763:	39 d6                	cmp    %edx,%esi
  804765:	72 19                	jb     804780 <__udivdi3+0xfc>
  804767:	74 0b                	je     804774 <__udivdi3+0xf0>
  804769:	89 d8                	mov    %ebx,%eax
  80476b:	31 ff                	xor    %edi,%edi
  80476d:	e9 58 ff ff ff       	jmp    8046ca <__udivdi3+0x46>
  804772:	66 90                	xchg   %ax,%ax
  804774:	8b 54 24 08          	mov    0x8(%esp),%edx
  804778:	89 f9                	mov    %edi,%ecx
  80477a:	d3 e2                	shl    %cl,%edx
  80477c:	39 c2                	cmp    %eax,%edx
  80477e:	73 e9                	jae    804769 <__udivdi3+0xe5>
  804780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804783:	31 ff                	xor    %edi,%edi
  804785:	e9 40 ff ff ff       	jmp    8046ca <__udivdi3+0x46>
  80478a:	66 90                	xchg   %ax,%ax
  80478c:	31 c0                	xor    %eax,%eax
  80478e:	e9 37 ff ff ff       	jmp    8046ca <__udivdi3+0x46>
  804793:	90                   	nop

00804794 <__umoddi3>:
  804794:	55                   	push   %ebp
  804795:	57                   	push   %edi
  804796:	56                   	push   %esi
  804797:	53                   	push   %ebx
  804798:	83 ec 1c             	sub    $0x1c,%esp
  80479b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80479f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047b3:	89 f3                	mov    %esi,%ebx
  8047b5:	89 fa                	mov    %edi,%edx
  8047b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047bb:	89 34 24             	mov    %esi,(%esp)
  8047be:	85 c0                	test   %eax,%eax
  8047c0:	75 1a                	jne    8047dc <__umoddi3+0x48>
  8047c2:	39 f7                	cmp    %esi,%edi
  8047c4:	0f 86 a2 00 00 00    	jbe    80486c <__umoddi3+0xd8>
  8047ca:	89 c8                	mov    %ecx,%eax
  8047cc:	89 f2                	mov    %esi,%edx
  8047ce:	f7 f7                	div    %edi
  8047d0:	89 d0                	mov    %edx,%eax
  8047d2:	31 d2                	xor    %edx,%edx
  8047d4:	83 c4 1c             	add    $0x1c,%esp
  8047d7:	5b                   	pop    %ebx
  8047d8:	5e                   	pop    %esi
  8047d9:	5f                   	pop    %edi
  8047da:	5d                   	pop    %ebp
  8047db:	c3                   	ret    
  8047dc:	39 f0                	cmp    %esi,%eax
  8047de:	0f 87 ac 00 00 00    	ja     804890 <__umoddi3+0xfc>
  8047e4:	0f bd e8             	bsr    %eax,%ebp
  8047e7:	83 f5 1f             	xor    $0x1f,%ebp
  8047ea:	0f 84 ac 00 00 00    	je     80489c <__umoddi3+0x108>
  8047f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8047f5:	29 ef                	sub    %ebp,%edi
  8047f7:	89 fe                	mov    %edi,%esi
  8047f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047fd:	89 e9                	mov    %ebp,%ecx
  8047ff:	d3 e0                	shl    %cl,%eax
  804801:	89 d7                	mov    %edx,%edi
  804803:	89 f1                	mov    %esi,%ecx
  804805:	d3 ef                	shr    %cl,%edi
  804807:	09 c7                	or     %eax,%edi
  804809:	89 e9                	mov    %ebp,%ecx
  80480b:	d3 e2                	shl    %cl,%edx
  80480d:	89 14 24             	mov    %edx,(%esp)
  804810:	89 d8                	mov    %ebx,%eax
  804812:	d3 e0                	shl    %cl,%eax
  804814:	89 c2                	mov    %eax,%edx
  804816:	8b 44 24 08          	mov    0x8(%esp),%eax
  80481a:	d3 e0                	shl    %cl,%eax
  80481c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804820:	8b 44 24 08          	mov    0x8(%esp),%eax
  804824:	89 f1                	mov    %esi,%ecx
  804826:	d3 e8                	shr    %cl,%eax
  804828:	09 d0                	or     %edx,%eax
  80482a:	d3 eb                	shr    %cl,%ebx
  80482c:	89 da                	mov    %ebx,%edx
  80482e:	f7 f7                	div    %edi
  804830:	89 d3                	mov    %edx,%ebx
  804832:	f7 24 24             	mull   (%esp)
  804835:	89 c6                	mov    %eax,%esi
  804837:	89 d1                	mov    %edx,%ecx
  804839:	39 d3                	cmp    %edx,%ebx
  80483b:	0f 82 87 00 00 00    	jb     8048c8 <__umoddi3+0x134>
  804841:	0f 84 91 00 00 00    	je     8048d8 <__umoddi3+0x144>
  804847:	8b 54 24 04          	mov    0x4(%esp),%edx
  80484b:	29 f2                	sub    %esi,%edx
  80484d:	19 cb                	sbb    %ecx,%ebx
  80484f:	89 d8                	mov    %ebx,%eax
  804851:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804855:	d3 e0                	shl    %cl,%eax
  804857:	89 e9                	mov    %ebp,%ecx
  804859:	d3 ea                	shr    %cl,%edx
  80485b:	09 d0                	or     %edx,%eax
  80485d:	89 e9                	mov    %ebp,%ecx
  80485f:	d3 eb                	shr    %cl,%ebx
  804861:	89 da                	mov    %ebx,%edx
  804863:	83 c4 1c             	add    $0x1c,%esp
  804866:	5b                   	pop    %ebx
  804867:	5e                   	pop    %esi
  804868:	5f                   	pop    %edi
  804869:	5d                   	pop    %ebp
  80486a:	c3                   	ret    
  80486b:	90                   	nop
  80486c:	89 fd                	mov    %edi,%ebp
  80486e:	85 ff                	test   %edi,%edi
  804870:	75 0b                	jne    80487d <__umoddi3+0xe9>
  804872:	b8 01 00 00 00       	mov    $0x1,%eax
  804877:	31 d2                	xor    %edx,%edx
  804879:	f7 f7                	div    %edi
  80487b:	89 c5                	mov    %eax,%ebp
  80487d:	89 f0                	mov    %esi,%eax
  80487f:	31 d2                	xor    %edx,%edx
  804881:	f7 f5                	div    %ebp
  804883:	89 c8                	mov    %ecx,%eax
  804885:	f7 f5                	div    %ebp
  804887:	89 d0                	mov    %edx,%eax
  804889:	e9 44 ff ff ff       	jmp    8047d2 <__umoddi3+0x3e>
  80488e:	66 90                	xchg   %ax,%ax
  804890:	89 c8                	mov    %ecx,%eax
  804892:	89 f2                	mov    %esi,%edx
  804894:	83 c4 1c             	add    $0x1c,%esp
  804897:	5b                   	pop    %ebx
  804898:	5e                   	pop    %esi
  804899:	5f                   	pop    %edi
  80489a:	5d                   	pop    %ebp
  80489b:	c3                   	ret    
  80489c:	3b 04 24             	cmp    (%esp),%eax
  80489f:	72 06                	jb     8048a7 <__umoddi3+0x113>
  8048a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048a5:	77 0f                	ja     8048b6 <__umoddi3+0x122>
  8048a7:	89 f2                	mov    %esi,%edx
  8048a9:	29 f9                	sub    %edi,%ecx
  8048ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048af:	89 14 24             	mov    %edx,(%esp)
  8048b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048ba:	8b 14 24             	mov    (%esp),%edx
  8048bd:	83 c4 1c             	add    $0x1c,%esp
  8048c0:	5b                   	pop    %ebx
  8048c1:	5e                   	pop    %esi
  8048c2:	5f                   	pop    %edi
  8048c3:	5d                   	pop    %ebp
  8048c4:	c3                   	ret    
  8048c5:	8d 76 00             	lea    0x0(%esi),%esi
  8048c8:	2b 04 24             	sub    (%esp),%eax
  8048cb:	19 fa                	sbb    %edi,%edx
  8048cd:	89 d1                	mov    %edx,%ecx
  8048cf:	89 c6                	mov    %eax,%esi
  8048d1:	e9 71 ff ff ff       	jmp    804847 <__umoddi3+0xb3>
  8048d6:	66 90                	xchg   %ax,%ax
  8048d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8048dc:	72 ea                	jb     8048c8 <__umoddi3+0x134>
  8048de:	89 d9                	mov    %ebx,%ecx
  8048e0:	e9 62 ff ff ff       	jmp    804847 <__umoddi3+0xb3>
