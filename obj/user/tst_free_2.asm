
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
  800055:	68 20 49 80 00       	push   $0x804920
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
  8000a5:	68 50 49 80 00       	push   $0x804950
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
  8000d1:	e8 63 2a 00 00       	call   802b39 <sys_set_uheap_strategy>
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
  8000f6:	68 89 49 80 00       	push   $0x804989
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 a5 49 80 00       	push   $0x8049a5
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
  800123:	e8 5e 26 00 00       	call   802786 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 0b 26 00 00       	call   80273b <sys_calculate_free_frames>
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
  80013d:	68 b8 49 80 00       	push   $0x8049b8
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
  8002ac:	68 10 4a 80 00       	push   $0x804a10
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 a5 49 80 00       	push   $0x8049a5
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
  80031b:	68 38 4a 80 00       	push   $0x804a38
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 42 29 00 00       	call   802c7b <alloc_block>
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
  80037f:	68 5c 4a 80 00       	push   $0x804a5c
  800384:	6a 7f                	push   $0x7f
  800386:	68 a5 49 80 00       	push   $0x8049a5
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 a6 23 00 00       	call   80273b <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 84 4a 80 00       	push   $0x804a84
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
  800443:	68 cc 4a 80 00       	push   $0x804acc
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
  80049a:	68 ec 4a 80 00       	push   $0x804aec
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
  8004ee:	68 0c 4b 80 00       	push   $0x804b0c
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
  800538:	68 3c 4b 80 00       	push   $0x804b3c
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
  800552:	68 5c 4b 80 00       	push   $0x804b5c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 97 4b 80 00       	push   $0x804b97
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
  8005e0:	68 ac 4b 80 00       	push   $0x804bac
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 cb 4b 80 00       	push   $0x804bcb
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
  800669:	68 e4 4b 80 00       	push   $0x804be4
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
  800683:	68 04 4c 80 00       	push   $0x804c04
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 3b 4c 80 00       	push   $0x804c3b
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
  800711:	68 50 4c 80 00       	push   $0x804c50
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 6f 4c 80 00       	push   $0x804c6f
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
  800762:	e8 dd 24 00 00       	call   802c44 <get_block_size>
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
  8007b7:	68 88 4c 80 00       	push   $0x804c88
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
  8007d1:	68 a8 4c 80 00       	push   $0x804ca8
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
  80083d:	e8 02 24 00 00       	call   802c44 <get_block_size>
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
  80089b:	68 e5 4c 80 00       	push   $0x804ce5
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
  8008b5:	68 04 4d 80 00       	push   $0x804d04
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 44 4d 80 00       	push   $0x804d44
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 69 4d 80 00       	push   $0x804d69
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
  800963:	68 80 4d 80 00       	push   $0x804d80
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 b0 4d 80 00       	push   $0x804db0
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
  8009fa:	68 dc 4d 80 00       	push   $0x804ddc
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 0c 4e 80 00       	push   $0x804e0c
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
  800a68:	68 4c 4e 80 00       	push   $0x804e4c
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
  800a82:	68 7c 4e 80 00       	push   $0x804e7c
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
  800b11:	68 a8 4e 80 00       	push   $0x804ea8
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
  800b2b:	68 d8 4e 80 00       	push   $0x804ed8
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 00 4f 80 00       	push   $0x804f00
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
  800bca:	68 20 4f 80 00       	push   $0x804f20
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
  800c3d:	68 50 4f 80 00       	push   $0x804f50
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
  800ca4:	e8 61 20 00 00       	call   802d0a <print_blocks_list>
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
  800ce6:	68 68 4f 80 00       	push   $0x804f68
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 98 4f 80 00       	push   $0x804f98
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
  800d83:	68 d0 4f 80 00       	push   $0x804fd0
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
  800d9d:	68 00 50 80 00       	push   $0x805000
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 85 19 00 00       	call   80273b <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 44 50 80 00       	push   $0x805044
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
  800e7a:	68 b0 50 80 00       	push   $0x8050b0
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
  800efe:	e8 93 1c 00 00       	call   802b96 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 ec 50 80 00       	push   $0x8050ec
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
  800f3c:	68 30 51 80 00       	push   $0x805130
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
  800f58:	e8 a7 19 00 00       	call   802904 <sys_getenvindex>
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
  800fc6:	e8 bd 16 00 00       	call   802688 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 98 51 80 00       	push   $0x805198
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
  800ff6:	68 c0 51 80 00       	push   $0x8051c0
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
  801027:	68 e8 51 80 00       	push   $0x8051e8
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 40 52 80 00       	push   $0x805240
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 98 51 80 00       	push   $0x805198
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 3d 16 00 00       	call   8026a2 <sys_unlock_cons>
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
  801078:	e8 53 18 00 00       	call   8028d0 <sys_destroy_env>
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
  801089:	e8 a8 18 00 00       	call   802936 <sys_exit_env>
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
  8010b2:	68 54 52 80 00       	push   $0x805254
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 59 52 80 00       	push   $0x805259
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
  8010ef:	68 75 52 80 00       	push   $0x805275
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
  80111e:	68 78 52 80 00       	push   $0x805278
  801123:	6a 26                	push   $0x26
  801125:	68 c4 52 80 00       	push   $0x8052c4
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
  8011f3:	68 d0 52 80 00       	push   $0x8052d0
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 c4 52 80 00       	push   $0x8052c4
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
  801266:	68 24 53 80 00       	push   $0x805324
  80126b:	6a 44                	push   $0x44
  80126d:	68 c4 52 80 00       	push   $0x8052c4
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
  8012c0:	e8 81 13 00 00       	call   802646 <sys_cputs>
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
  801337:	e8 0a 13 00 00       	call   802646 <sys_cputs>
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
  801381:	e8 02 13 00 00       	call   802688 <sys_lock_cons>
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
  8013a1:	e8 fc 12 00 00       	call   8026a2 <sys_unlock_cons>
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
  8013eb:	e8 bc 32 00 00       	call   8046ac <__udivdi3>
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
  80143b:	e8 7c 33 00 00       	call   8047bc <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 94 55 80 00       	add    $0x805594,%eax
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
  801596:	8b 04 85 b8 55 80 00 	mov    0x8055b8(,%eax,4),%eax
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
  801677:	8b 34 9d 00 54 80 00 	mov    0x805400(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 a5 55 80 00       	push   $0x8055a5
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
  80169c:	68 ae 55 80 00       	push   $0x8055ae
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
  8016c9:	be b1 55 80 00       	mov    $0x8055b1,%esi
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
  8020d4:	68 28 57 80 00       	push   $0x805728
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 4a 57 80 00       	push   $0x80574a
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
  8020f4:	e8 f8 0a 00 00       	call   802bf1 <sys_sbrk>
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
  80216f:	e8 01 09 00 00       	call   802a75 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 41 0e 00 00       	call   802fc4 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 13 09 00 00       	call   802aa6 <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 da 12 00 00       	call   803480 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8021da:	a1 20 60 80 00       	mov    0x806020,%eax
  8021df:	8b 40 78             	mov    0x78(%eax),%eax
  8021e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e5:	29 c2                	sub    %eax,%edx
  8021e7:	89 d0                	mov    %edx,%eax
  8021e9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021ee:	c1 e8 0c             	shr    $0xc,%eax
  8021f1:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	0f 85 ab 00 00 00    	jne    8022ab <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	05 00 10 00 00       	add    $0x1000,%eax
  802208:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80220b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  80223e:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 08                	je     802251 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  802295:	c7 04 85 60 a2 88 00 	movl   $0x1,0x88a260(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  8022ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022af:	75 16                	jne    8022c7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8022b1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8022b8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8022bf:	0f 86 15 ff ff ff    	jbe    8021da <malloc+0xdc>
  8022c5:	eb 01                	jmp    8022c8 <malloc+0x1ca>
				}
				

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
  8022f7:	89 04 95 60 a2 90 00 	mov    %eax,0x90a260(,%edx,4)
		sys_allocate_user_mem(i, size);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	ff 75 f0             	pushl  -0x10(%ebp)
  802307:	e8 1c 09 00 00       	call   802c28 <sys_allocate_user_mem>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	eb 07                	jmp    802318 <malloc+0x21a>
		
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
  80234f:	e8 f0 08 00 00       	call   802c44 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 00 1b 00 00       	call   803e65 <free_block>
  802365:	83 c4 10             	add    $0x10,%esp
		}

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
  80239a:	8b 04 85 60 a2 90 00 	mov    0x90a260(,%eax,4),%eax
  8023a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8023a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a7:	c1 e0 0c             	shl    $0xc,%eax
  8023aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8023ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023b4:	eb 42                	jmp    8023f8 <free+0xdb>
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
  8023d7:	c7 04 85 60 a2 88 00 	movl   $0x0,0x88a260(,%eax,4)
  8023de:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8023e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	83 ec 08             	sub    $0x8,%esp
  8023eb:	52                   	push   %edx
  8023ec:	50                   	push   %eax
  8023ed:	e8 1a 08 00 00       	call   802c0c <sys_free_user_mem>
  8023f2:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8023f5:	ff 45 f4             	incl   -0xc(%ebp)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8023fe:	72 b6                	jb     8023b6 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802400:	eb 17                	jmp    802419 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 58 57 80 00       	push   $0x805758
  80240a:	68 87 00 00 00       	push   $0x87
  80240f:	68 82 57 80 00       	push   $0x805782
  802414:	e8 78 ec ff ff       	call   801091 <_panic>
	}
}
  802419:	90                   	nop
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 28             	sub    $0x28,%esp
  802422:	8b 45 10             	mov    0x10(%ebp),%eax
  802425:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802428:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80242c:	75 0a                	jne    802438 <smalloc+0x1c>
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
  802433:	e9 87 00 00 00       	jmp    8024bf <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	39 d0                	cmp    %edx,%eax
  80244d:	73 02                	jae    802451 <smalloc+0x35>
  80244f:	89 d0                	mov    %edx,%eax
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	50                   	push   %eax
  802455:	e8 a4 fc ff ff       	call   8020fe <malloc>
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802464:	75 07                	jne    80246d <smalloc+0x51>
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
  80246b:	eb 52                	jmp    8024bf <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80246d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802471:	ff 75 ec             	pushl  -0x14(%ebp)
  802474:	50                   	push   %eax
  802475:	ff 75 0c             	pushl  0xc(%ebp)
  802478:	ff 75 08             	pushl  0x8(%ebp)
  80247b:	e8 93 03 00 00       	call   802813 <sys_createSharedObject>
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802486:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80248a:	74 06                	je     802492 <smalloc+0x76>
  80248c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802490:	75 07                	jne    802499 <smalloc+0x7d>
  802492:	b8 00 00 00 00       	mov    $0x0,%eax
  802497:	eb 26                	jmp    8024bf <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802499:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80249c:	a1 20 60 80 00       	mov    0x806020,%eax
  8024a1:	8b 40 78             	mov    0x78(%eax),%eax
  8024a4:	29 c2                	sub    %eax,%edx
  8024a6:	89 d0                	mov    %edx,%eax
  8024a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024ad:	c1 e8 0c             	shr    $0xc,%eax
  8024b0:	89 c2                	mov    %eax,%edx
  8024b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b5:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  8024bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8024c7:	83 ec 08             	sub    $0x8,%esp
  8024ca:	ff 75 0c             	pushl  0xc(%ebp)
  8024cd:	ff 75 08             	pushl  0x8(%ebp)
  8024d0:	e8 68 03 00 00       	call   80283d <sys_getSizeOfSharedObject>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8024db:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024df:	75 07                	jne    8024e8 <sget+0x27>
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	eb 7f                	jmp    802567 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	39 d0                	cmp    %edx,%eax
  8024fd:	73 02                	jae    802501 <sget+0x40>
  8024ff:	89 d0                	mov    %edx,%eax
  802501:	83 ec 0c             	sub    $0xc,%esp
  802504:	50                   	push   %eax
  802505:	e8 f4 fb ff ff       	call   8020fe <malloc>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802510:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802514:	75 07                	jne    80251d <sget+0x5c>
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	eb 4a                	jmp    802567 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	ff 75 e8             	pushl  -0x18(%ebp)
  802523:	ff 75 0c             	pushl  0xc(%ebp)
  802526:	ff 75 08             	pushl  0x8(%ebp)
  802529:	e8 2c 03 00 00       	call   80285a <sys_getSharedObject>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802534:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802537:	a1 20 60 80 00       	mov    0x806020,%eax
  80253c:	8b 40 78             	mov    0x78(%eax),%eax
  80253f:	29 c2                	sub    %eax,%edx
  802541:	89 d0                	mov    %edx,%eax
  802543:	2d 00 10 00 00       	sub    $0x1000,%eax
  802548:	c1 e8 0c             	shr    $0xc,%eax
  80254b:	89 c2                	mov    %eax,%edx
  80254d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802550:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802557:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80255b:	75 07                	jne    802564 <sget+0xa3>
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	eb 03                	jmp    802567 <sget+0xa6>
	return ptr;
  802564:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80256f:	8b 55 08             	mov    0x8(%ebp),%edx
  802572:	a1 20 60 80 00       	mov    0x806020,%eax
  802577:	8b 40 78             	mov    0x78(%eax),%eax
  80257a:	29 c2                	sub    %eax,%edx
  80257c:	89 d0                	mov    %edx,%eax
  80257e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802583:	c1 e8 0c             	shr    $0xc,%eax
  802586:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802590:	83 ec 08             	sub    $0x8,%esp
  802593:	ff 75 08             	pushl  0x8(%ebp)
  802596:	ff 75 f4             	pushl  -0xc(%ebp)
  802599:	e8 db 02 00 00       	call   802879 <sys_freeSharedObject>
  80259e:	83 c4 10             	add    $0x10,%esp
  8025a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8025a4:	90                   	nop
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 90 57 80 00       	push   $0x805790
  8025b5:	68 e4 00 00 00       	push   $0xe4
  8025ba:	68 82 57 80 00       	push   $0x805782
  8025bf:	e8 cd ea ff ff       	call   801091 <_panic>

008025c4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 b6 57 80 00       	push   $0x8057b6
  8025d2:	68 f0 00 00 00       	push   $0xf0
  8025d7:	68 82 57 80 00       	push   $0x805782
  8025dc:	e8 b0 ea ff ff       	call   801091 <_panic>

008025e1 <shrink>:

}
void shrink(uint32 newSize)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	68 b6 57 80 00       	push   $0x8057b6
  8025ef:	68 f5 00 00 00       	push   $0xf5
  8025f4:	68 82 57 80 00       	push   $0x805782
  8025f9:	e8 93 ea ff ff       	call   801091 <_panic>

008025fe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 b6 57 80 00       	push   $0x8057b6
  80260c:	68 fa 00 00 00       	push   $0xfa
  802611:	68 82 57 80 00       	push   $0x805782
  802616:	e8 76 ea ff ff       	call   801091 <_panic>

0080261b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	57                   	push   %edi
  80261f:	56                   	push   %esi
  802620:	53                   	push   %ebx
  802621:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80262d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802630:	8b 7d 18             	mov    0x18(%ebp),%edi
  802633:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802636:	cd 30                	int    $0x30
  802638:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80263b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 04             	sub    $0x4,%esp
  80264c:	8b 45 10             	mov    0x10(%ebp),%eax
  80264f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802652:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	52                   	push   %edx
  80265e:	ff 75 0c             	pushl  0xc(%ebp)
  802661:	50                   	push   %eax
  802662:	6a 00                	push   $0x0
  802664:	e8 b2 ff ff ff       	call   80261b <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
}
  80266c:	90                   	nop
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <sys_cgetc>:

int
sys_cgetc(void)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 02                	push   $0x2
  80267e:	e8 98 ff ff ff       	call   80261b <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 03                	push   $0x3
  802697:	e8 7f ff ff ff       	call   80261b <syscall>
  80269c:	83 c4 18             	add    $0x18,%esp
}
  80269f:	90                   	nop
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 04                	push   $0x4
  8026b1:	e8 65 ff ff ff       	call   80261b <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
}
  8026b9:	90                   	nop
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	52                   	push   %edx
  8026cc:	50                   	push   %eax
  8026cd:	6a 08                	push   $0x8
  8026cf:	e8 47 ff ff ff       	call   80261b <syscall>
  8026d4:	83 c4 18             	add    $0x18,%esp
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	56                   	push   %esi
  8026dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026de:	8b 75 18             	mov    0x18(%ebp),%esi
  8026e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	56                   	push   %esi
  8026ee:	53                   	push   %ebx
  8026ef:	51                   	push   %ecx
  8026f0:	52                   	push   %edx
  8026f1:	50                   	push   %eax
  8026f2:	6a 09                	push   $0x9
  8026f4:	e8 22 ff ff ff       	call   80261b <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
}
  8026fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ff:	5b                   	pop    %ebx
  802700:	5e                   	pop    %esi
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    

00802703 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802706:	8b 55 0c             	mov    0xc(%ebp),%edx
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	52                   	push   %edx
  802713:	50                   	push   %eax
  802714:	6a 0a                	push   $0xa
  802716:	e8 00 ff ff ff       	call   80261b <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	ff 75 0c             	pushl  0xc(%ebp)
  80272c:	ff 75 08             	pushl  0x8(%ebp)
  80272f:	6a 0b                	push   $0xb
  802731:	e8 e5 fe ff ff       	call   80261b <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 0c                	push   $0xc
  80274a:	e8 cc fe ff ff       	call   80261b <syscall>
  80274f:	83 c4 18             	add    $0x18,%esp
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 0d                	push   $0xd
  802763:	e8 b3 fe ff ff       	call   80261b <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 0e                	push   $0xe
  80277c:	e8 9a fe ff ff       	call   80261b <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 0f                	push   $0xf
  802795:	e8 81 fe ff ff       	call   80261b <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
}
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	ff 75 08             	pushl  0x8(%ebp)
  8027ad:	6a 10                	push   $0x10
  8027af:	e8 67 fe ff ff       	call   80261b <syscall>
  8027b4:	83 c4 18             	add    $0x18,%esp
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 11                	push   $0x11
  8027c8:	e8 4e fe ff ff       	call   80261b <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
}
  8027d0:	90                   	nop
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	50                   	push   %eax
  8027ec:	6a 01                	push   $0x1
  8027ee:	e8 28 fe ff ff       	call   80261b <syscall>
  8027f3:	83 c4 18             	add    $0x18,%esp
}
  8027f6:	90                   	nop
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 14                	push   $0x14
  802808:	e8 0e fe ff ff       	call   80261b <syscall>
  80280d:	83 c4 18             	add    $0x18,%esp
}
  802810:	90                   	nop
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	8b 45 10             	mov    0x10(%ebp),%eax
  80281c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80281f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802822:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	6a 00                	push   $0x0
  80282b:	51                   	push   %ecx
  80282c:	52                   	push   %edx
  80282d:	ff 75 0c             	pushl  0xc(%ebp)
  802830:	50                   	push   %eax
  802831:	6a 15                	push   $0x15
  802833:	e8 e3 fd ff ff       	call   80261b <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802840:	8b 55 0c             	mov    0xc(%ebp),%edx
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	52                   	push   %edx
  80284d:	50                   	push   %eax
  80284e:	6a 16                	push   $0x16
  802850:	e8 c6 fd ff ff       	call   80261b <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80285d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802860:	8b 55 0c             	mov    0xc(%ebp),%edx
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	51                   	push   %ecx
  80286b:	52                   	push   %edx
  80286c:	50                   	push   %eax
  80286d:	6a 17                	push   $0x17
  80286f:	e8 a7 fd ff ff       	call   80261b <syscall>
  802874:	83 c4 18             	add    $0x18,%esp
}
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80287c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	52                   	push   %edx
  802889:	50                   	push   %eax
  80288a:	6a 18                	push   $0x18
  80288c:	e8 8a fd ff ff       	call   80261b <syscall>
  802891:	83 c4 18             	add    $0x18,%esp
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	6a 00                	push   $0x0
  80289e:	ff 75 14             	pushl  0x14(%ebp)
  8028a1:	ff 75 10             	pushl  0x10(%ebp)
  8028a4:	ff 75 0c             	pushl  0xc(%ebp)
  8028a7:	50                   	push   %eax
  8028a8:	6a 19                	push   $0x19
  8028aa:	e8 6c fd ff ff       	call   80261b <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	50                   	push   %eax
  8028c3:	6a 1a                	push   $0x1a
  8028c5:	e8 51 fd ff ff       	call   80261b <syscall>
  8028ca:	83 c4 18             	add    $0x18,%esp
}
  8028cd:	90                   	nop
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	50                   	push   %eax
  8028df:	6a 1b                	push   $0x1b
  8028e1:	e8 35 fd ff ff       	call   80261b <syscall>
  8028e6:	83 c4 18             	add    $0x18,%esp
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 05                	push   $0x5
  8028fa:	e8 1c fd ff ff       	call   80261b <syscall>
  8028ff:	83 c4 18             	add    $0x18,%esp
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 06                	push   $0x6
  802913:	e8 03 fd ff ff       	call   80261b <syscall>
  802918:	83 c4 18             	add    $0x18,%esp
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 00                	push   $0x0
  80292a:	6a 07                	push   $0x7
  80292c:	e8 ea fc ff ff       	call   80261b <syscall>
  802931:	83 c4 18             	add    $0x18,%esp
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <sys_exit_env>:


void sys_exit_env(void)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 1c                	push   $0x1c
  802945:	e8 d1 fc ff ff       	call   80261b <syscall>
  80294a:	83 c4 18             	add    $0x18,%esp
}
  80294d:	90                   	nop
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802956:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802959:	8d 50 04             	lea    0x4(%eax),%edx
  80295c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	52                   	push   %edx
  802966:	50                   	push   %eax
  802967:	6a 1d                	push   $0x1d
  802969:	e8 ad fc ff ff       	call   80261b <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
	return result;
  802971:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802974:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802977:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80297a:	89 01                	mov    %eax,(%ecx)
  80297c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	c9                   	leave  
  802983:	c2 04 00             	ret    $0x4

00802986 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	ff 75 10             	pushl  0x10(%ebp)
  802990:	ff 75 0c             	pushl  0xc(%ebp)
  802993:	ff 75 08             	pushl  0x8(%ebp)
  802996:	6a 13                	push   $0x13
  802998:	e8 7e fc ff ff       	call   80261b <syscall>
  80299d:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a0:	90                   	nop
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 1e                	push   $0x1e
  8029b2:	e8 64 fc ff ff       	call   80261b <syscall>
  8029b7:	83 c4 18             	add    $0x18,%esp
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 04             	sub    $0x4,%esp
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	50                   	push   %eax
  8029d5:	6a 1f                	push   $0x1f
  8029d7:	e8 3f fc ff ff       	call   80261b <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8029df:	90                   	nop
}
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <rsttst>:
void rsttst()
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 21                	push   $0x21
  8029f1:	e8 25 fc ff ff       	call   80261b <syscall>
  8029f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029f9:	90                   	nop
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	8b 45 14             	mov    0x14(%ebp),%eax
  802a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a08:	8b 55 18             	mov    0x18(%ebp),%edx
  802a0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a0f:	52                   	push   %edx
  802a10:	50                   	push   %eax
  802a11:	ff 75 10             	pushl  0x10(%ebp)
  802a14:	ff 75 0c             	pushl  0xc(%ebp)
  802a17:	ff 75 08             	pushl  0x8(%ebp)
  802a1a:	6a 20                	push   $0x20
  802a1c:	e8 fa fb ff ff       	call   80261b <syscall>
  802a21:	83 c4 18             	add    $0x18,%esp
	return ;
  802a24:	90                   	nop
}
  802a25:	c9                   	leave  
  802a26:	c3                   	ret    

00802a27 <chktst>:
void chktst(uint32 n)
{
  802a27:	55                   	push   %ebp
  802a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	ff 75 08             	pushl  0x8(%ebp)
  802a35:	6a 22                	push   $0x22
  802a37:	e8 df fb ff ff       	call   80261b <syscall>
  802a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  802a3f:	90                   	nop
}
  802a40:	c9                   	leave  
  802a41:	c3                   	ret    

00802a42 <inctst>:

void inctst()
{
  802a42:	55                   	push   %ebp
  802a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 23                	push   $0x23
  802a51:	e8 c5 fb ff ff       	call   80261b <syscall>
  802a56:	83 c4 18             	add    $0x18,%esp
	return ;
  802a59:	90                   	nop
}
  802a5a:	c9                   	leave  
  802a5b:	c3                   	ret    

00802a5c <gettst>:
uint32 gettst()
{
  802a5c:	55                   	push   %ebp
  802a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 24                	push   $0x24
  802a6b:	e8 ab fb ff ff       	call   80261b <syscall>
  802a70:	83 c4 18             	add    $0x18,%esp
}
  802a73:	c9                   	leave  
  802a74:	c3                   	ret    

00802a75 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 25                	push   $0x25
  802a87:	e8 8f fb ff ff       	call   80261b <syscall>
  802a8c:	83 c4 18             	add    $0x18,%esp
  802a8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a92:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a96:	75 07                	jne    802a9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a98:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9d:	eb 05                	jmp    802aa4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 25                	push   $0x25
  802ab8:	e8 5e fb ff ff       	call   80261b <syscall>
  802abd:	83 c4 18             	add    $0x18,%esp
  802ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ac3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ac7:	75 07                	jne    802ad0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  802ace:	eb 05                	jmp    802ad5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
  802ada:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 25                	push   $0x25
  802ae9:	e8 2d fb ff ff       	call   80261b <syscall>
  802aee:	83 c4 18             	add    $0x18,%esp
  802af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802af4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802af8:	75 07                	jne    802b01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802afa:	b8 01 00 00 00       	mov    $0x1,%eax
  802aff:	eb 05                	jmp    802b06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 25                	push   $0x25
  802b1a:	e8 fc fa ff ff       	call   80261b <syscall>
  802b1f:	83 c4 18             	add    $0x18,%esp
  802b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b25:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b29:	75 07                	jne    802b32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  802b30:	eb 05                	jmp    802b37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b37:	c9                   	leave  
  802b38:	c3                   	ret    

00802b39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	ff 75 08             	pushl  0x8(%ebp)
  802b47:	6a 26                	push   $0x26
  802b49:	e8 cd fa ff ff       	call   80261b <syscall>
  802b4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b51:	90                   	nop
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
  802b57:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	6a 00                	push   $0x0
  802b66:	53                   	push   %ebx
  802b67:	51                   	push   %ecx
  802b68:	52                   	push   %edx
  802b69:	50                   	push   %eax
  802b6a:	6a 27                	push   $0x27
  802b6c:	e8 aa fa ff ff       	call   80261b <syscall>
  802b71:	83 c4 18             	add    $0x18,%esp
}
  802b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	6a 00                	push   $0x0
  802b88:	52                   	push   %edx
  802b89:	50                   	push   %eax
  802b8a:	6a 28                	push   $0x28
  802b8c:	e8 8a fa ff ff       	call   80261b <syscall>
  802b91:	83 c4 18             	add    $0x18,%esp
}
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b99:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	6a 00                	push   $0x0
  802ba4:	51                   	push   %ecx
  802ba5:	ff 75 10             	pushl  0x10(%ebp)
  802ba8:	52                   	push   %edx
  802ba9:	50                   	push   %eax
  802baa:	6a 29                	push   $0x29
  802bac:	e8 6a fa ff ff       	call   80261b <syscall>
  802bb1:	83 c4 18             	add    $0x18,%esp
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	ff 75 10             	pushl  0x10(%ebp)
  802bc0:	ff 75 0c             	pushl  0xc(%ebp)
  802bc3:	ff 75 08             	pushl  0x8(%ebp)
  802bc6:	6a 12                	push   $0x12
  802bc8:	e8 4e fa ff ff       	call   80261b <syscall>
  802bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd0:	90                   	nop
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	6a 00                	push   $0x0
  802be2:	52                   	push   %edx
  802be3:	50                   	push   %eax
  802be4:	6a 2a                	push   $0x2a
  802be6:	e8 30 fa ff ff       	call   80261b <syscall>
  802beb:	83 c4 18             	add    $0x18,%esp
	return;
  802bee:	90                   	nop
}
  802bef:	c9                   	leave  
  802bf0:	c3                   	ret    

00802bf1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802bf1:	55                   	push   %ebp
  802bf2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	50                   	push   %eax
  802c00:	6a 2b                	push   $0x2b
  802c02:	e8 14 fa ff ff       	call   80261b <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	ff 75 0c             	pushl  0xc(%ebp)
  802c18:	ff 75 08             	pushl  0x8(%ebp)
  802c1b:	6a 2c                	push   $0x2c
  802c1d:	e8 f9 f9 ff ff       	call   80261b <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
	return;
  802c25:	90                   	nop
}
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	ff 75 0c             	pushl  0xc(%ebp)
  802c34:	ff 75 08             	pushl  0x8(%ebp)
  802c37:	6a 2d                	push   $0x2d
  802c39:	e8 dd f9 ff ff       	call   80261b <syscall>
  802c3e:	83 c4 18             	add    $0x18,%esp
	return;
  802c41:	90                   	nop
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	83 e8 04             	sub    $0x4,%eax
  802c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c5b:	c9                   	leave  
  802c5c:	c3                   	ret    

00802c5d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c5d:	55                   	push   %ebp
  802c5e:	89 e5                	mov    %esp,%ebp
  802c60:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	83 e8 04             	sub    $0x4,%eax
  802c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	83 e0 01             	and    $0x1,%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	0f 94 c0             	sete   %al
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
  802c7e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8b:	83 f8 02             	cmp    $0x2,%eax
  802c8e:	74 2b                	je     802cbb <alloc_block+0x40>
  802c90:	83 f8 02             	cmp    $0x2,%eax
  802c93:	7f 07                	jg     802c9c <alloc_block+0x21>
  802c95:	83 f8 01             	cmp    $0x1,%eax
  802c98:	74 0e                	je     802ca8 <alloc_block+0x2d>
  802c9a:	eb 58                	jmp    802cf4 <alloc_block+0x79>
  802c9c:	83 f8 03             	cmp    $0x3,%eax
  802c9f:	74 2d                	je     802cce <alloc_block+0x53>
  802ca1:	83 f8 04             	cmp    $0x4,%eax
  802ca4:	74 3b                	je     802ce1 <alloc_block+0x66>
  802ca6:	eb 4c                	jmp    802cf4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802ca8:	83 ec 0c             	sub    $0xc,%esp
  802cab:	ff 75 08             	pushl  0x8(%ebp)
  802cae:	e8 11 03 00 00       	call   802fc4 <alloc_block_FF>
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cb9:	eb 4a                	jmp    802d05 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802cbb:	83 ec 0c             	sub    $0xc,%esp
  802cbe:	ff 75 08             	pushl  0x8(%ebp)
  802cc1:	e8 c7 19 00 00       	call   80468d <alloc_block_NF>
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ccc:	eb 37                	jmp    802d05 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802cce:	83 ec 0c             	sub    $0xc,%esp
  802cd1:	ff 75 08             	pushl  0x8(%ebp)
  802cd4:	e8 a7 07 00 00       	call   803480 <alloc_block_BF>
  802cd9:	83 c4 10             	add    $0x10,%esp
  802cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cdf:	eb 24                	jmp    802d05 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 08             	pushl  0x8(%ebp)
  802ce7:	e8 84 19 00 00       	call   804670 <alloc_block_WF>
  802cec:	83 c4 10             	add    $0x10,%esp
  802cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cf2:	eb 11                	jmp    802d05 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802cf4:	83 ec 0c             	sub    $0xc,%esp
  802cf7:	68 c8 57 80 00       	push   $0x8057c8
  802cfc:	e8 4d e6 ff ff       	call   80134e <cprintf>
  802d01:	83 c4 10             	add    $0x10,%esp
		break;
  802d04:	90                   	nop
	}
	return va;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802d08:	c9                   	leave  
  802d09:	c3                   	ret    

00802d0a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
  802d0d:	53                   	push   %ebx
  802d0e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802d11:	83 ec 0c             	sub    $0xc,%esp
  802d14:	68 e8 57 80 00       	push   $0x8057e8
  802d19:	e8 30 e6 ff ff       	call   80134e <cprintf>
  802d1e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	68 13 58 80 00       	push   $0x805813
  802d29:	e8 20 e6 ff ff       	call   80134e <cprintf>
  802d2e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d37:	eb 37                	jmp    802d70 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802d3f:	e8 19 ff ff ff       	call   802c5d <is_free_block>
  802d44:	83 c4 10             	add    $0x10,%esp
  802d47:	0f be d8             	movsbl %al,%ebx
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	ff 75 f4             	pushl  -0xc(%ebp)
  802d50:	e8 ef fe ff ff       	call   802c44 <get_block_size>
  802d55:	83 c4 10             	add    $0x10,%esp
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	53                   	push   %ebx
  802d5c:	50                   	push   %eax
  802d5d:	68 2b 58 80 00       	push   $0x80582b
  802d62:	e8 e7 e5 ff ff       	call   80134e <cprintf>
  802d67:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d74:	74 07                	je     802d7d <print_blocks_list+0x73>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	eb 05                	jmp    802d82 <print_blocks_list+0x78>
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d82:	89 45 10             	mov    %eax,0x10(%ebp)
  802d85:	8b 45 10             	mov    0x10(%ebp),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	75 ad                	jne    802d39 <print_blocks_list+0x2f>
  802d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d90:	75 a7                	jne    802d39 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	68 e8 57 80 00       	push   $0x8057e8
  802d9a:	e8 af e5 ff ff       	call   80134e <cprintf>
  802d9f:	83 c4 10             	add    $0x10,%esp

}
  802da2:	90                   	nop
  802da3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802da6:	c9                   	leave  
  802da7:	c3                   	ret    

00802da8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802da8:	55                   	push   %ebp
  802da9:	89 e5                	mov    %esp,%ebp
  802dab:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db1:	83 e0 01             	and    $0x1,%eax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 03                	je     802dbb <initialize_dynamic_allocator+0x13>
  802db8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802dbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbf:	0f 84 c7 01 00 00    	je     802f8c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802dc5:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802dcc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ddc:	0f 87 ad 01 00 00    	ja     802f8f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	0f 89 a5 01 00 00    	jns    802f92 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ded:	8b 55 08             	mov    0x8(%ebp),%edx
  802df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df3:	01 d0                	add    %edx,%eax
  802df5:	83 e8 04             	sub    $0x4,%eax
  802df8:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802dfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802e04:	a1 44 60 80 00       	mov    0x806044,%eax
  802e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0c:	e9 87 00 00 00       	jmp    802e98 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e15:	75 14                	jne    802e2b <initialize_dynamic_allocator+0x83>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 43 58 80 00       	push   $0x805843
  802e1f:	6a 79                	push   $0x79
  802e21:	68 61 58 80 00       	push   $0x805861
  802e26:	e8 66 e2 ff ff       	call   801091 <_panic>
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 10                	je     802e44 <initialize_dynamic_allocator+0x9c>
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3c:	8b 52 04             	mov    0x4(%edx),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 0b                	jmp    802e4f <initialize_dynamic_allocator+0xa7>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	a3 48 60 80 00       	mov    %eax,0x806048
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0f                	je     802e68 <initialize_dynamic_allocator+0xc0>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e62:	8b 12                	mov    (%edx),%edx
  802e64:	89 10                	mov    %edx,(%eax)
  802e66:	eb 0a                	jmp    802e72 <initialize_dynamic_allocator+0xca>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	a3 44 60 80 00       	mov    %eax,0x806044
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e85:	a1 50 60 80 00       	mov    0x806050,%eax
  802e8a:	48                   	dec    %eax
  802e8b:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802e90:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9c:	74 07                	je     802ea5 <initialize_dynamic_allocator+0xfd>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	eb 05                	jmp    802eaa <initialize_dynamic_allocator+0x102>
  802ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eaa:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802eaf:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	0f 85 55 ff ff ff    	jne    802e11 <initialize_dynamic_allocator+0x69>
  802ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec0:	0f 85 4b ff ff ff    	jne    802e11 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ed5:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802eda:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802edf:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802ee4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	83 c0 08             	add    $0x8,%eax
  802ef0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	83 c0 04             	add    $0x4,%eax
  802ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efc:	83 ea 08             	sub    $0x8,%edx
  802eff:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	01 d0                	add    %edx,%eax
  802f09:	83 e8 08             	sub    $0x8,%eax
  802f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0f:	83 ea 08             	sub    $0x8,%edx
  802f12:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802f27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f2b:	75 17                	jne    802f44 <initialize_dynamic_allocator+0x19c>
  802f2d:	83 ec 04             	sub    $0x4,%esp
  802f30:	68 7c 58 80 00       	push   $0x80587c
  802f35:	68 90 00 00 00       	push   $0x90
  802f3a:	68 61 58 80 00       	push   $0x805861
  802f3f:	e8 4d e1 ff ff       	call   801091 <_panic>
  802f44:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0d                	je     802f65 <initialize_dynamic_allocator+0x1bd>
  802f58:	a1 44 60 80 00       	mov    0x806044,%eax
  802f5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	eb 08                	jmp    802f6d <initialize_dynamic_allocator+0x1c5>
  802f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f68:	a3 48 60 80 00       	mov    %eax,0x806048
  802f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f70:	a3 44 60 80 00       	mov    %eax,0x806044
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7f:	a1 50 60 80 00       	mov    0x806050,%eax
  802f84:	40                   	inc    %eax
  802f85:	a3 50 60 80 00       	mov    %eax,0x806050
  802f8a:	eb 07                	jmp    802f93 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f8c:	90                   	nop
  802f8d:	eb 04                	jmp    802f93 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802f8f:	90                   	nop
  802f90:	eb 01                	jmp    802f93 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802f92:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802f98:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	83 e8 04             	sub    $0x4,%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	83 e0 fe             	and    $0xfffffffe,%eax
  802fb4:	8d 50 f8             	lea    -0x8(%eax),%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbf:	89 02                	mov    %eax,(%edx)
}
  802fc1:	90                   	nop
  802fc2:	5d                   	pop    %ebp
  802fc3:	c3                   	ret    

00802fc4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
  802fc7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	83 e0 01             	and    $0x1,%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 03                	je     802fd7 <alloc_block_FF+0x13>
  802fd4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fd7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fdb:	77 07                	ja     802fe4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fdd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802fe4:	a1 24 60 80 00       	mov    0x806024,%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	75 73                	jne    803060 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	83 c0 10             	add    $0x10,%eax
  802ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ff6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ffd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	01 d0                	add    %edx,%eax
  803005:	48                   	dec    %eax
  803006:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	ba 00 00 00 00       	mov    $0x0,%edx
  803011:	f7 75 ec             	divl   -0x14(%ebp)
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	29 d0                	sub    %edx,%eax
  803019:	c1 e8 0c             	shr    $0xc,%eax
  80301c:	83 ec 0c             	sub    $0xc,%esp
  80301f:	50                   	push   %eax
  803020:	e8 c3 f0 ff ff       	call   8020e8 <sbrk>
  803025:	83 c4 10             	add    $0x10,%esp
  803028:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80302b:	83 ec 0c             	sub    $0xc,%esp
  80302e:	6a 00                	push   $0x0
  803030:	e8 b3 f0 ff ff       	call   8020e8 <sbrk>
  803035:	83 c4 10             	add    $0x10,%esp
  803038:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803041:	83 ec 08             	sub    $0x8,%esp
  803044:	50                   	push   %eax
  803045:	ff 75 e4             	pushl  -0x1c(%ebp)
  803048:	e8 5b fd ff ff       	call   802da8 <initialize_dynamic_allocator>
  80304d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803050:	83 ec 0c             	sub    $0xc,%esp
  803053:	68 9f 58 80 00       	push   $0x80589f
  803058:	e8 f1 e2 ff ff       	call   80134e <cprintf>
  80305d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803064:	75 0a                	jne    803070 <alloc_block_FF+0xac>
	        return NULL;
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
  80306b:	e9 0e 04 00 00       	jmp    80347e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803070:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803077:	a1 44 60 80 00       	mov    0x806044,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307f:	e9 f3 02 00 00       	jmp    803377 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80308a:	83 ec 0c             	sub    $0xc,%esp
  80308d:	ff 75 bc             	pushl  -0x44(%ebp)
  803090:	e8 af fb ff ff       	call   802c44 <get_block_size>
  803095:	83 c4 10             	add    $0x10,%esp
  803098:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	83 c0 08             	add    $0x8,%eax
  8030a1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030a4:	0f 87 c5 02 00 00    	ja     80336f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	83 c0 18             	add    $0x18,%eax
  8030b0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030b3:	0f 87 19 02 00 00    	ja     8032d2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8030b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8030bf:	83 e8 08             	sub    $0x8,%eax
  8030c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8d 50 08             	lea    0x8(%eax),%edx
  8030cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030ce:	01 d0                	add    %edx,%eax
  8030d0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	83 c0 08             	add    $0x8,%eax
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	6a 01                	push   $0x1
  8030de:	50                   	push   %eax
  8030df:	ff 75 bc             	pushl  -0x44(%ebp)
  8030e2:	e8 ae fe ff ff       	call   802f95 <set_block_data>
  8030e7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	75 68                	jne    80315c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030f4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030f8:	75 17                	jne    803111 <alloc_block_FF+0x14d>
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	68 7c 58 80 00       	push   $0x80587c
  803102:	68 d7 00 00 00       	push   $0xd7
  803107:	68 61 58 80 00       	push   $0x805861
  80310c:	e8 80 df ff ff       	call   801091 <_panic>
  803111:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803117:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0d                	je     803132 <alloc_block_FF+0x16e>
  803125:	a1 44 60 80 00       	mov    0x806044,%eax
  80312a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	eb 08                	jmp    80313a <alloc_block_FF+0x176>
  803132:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803135:	a3 48 60 80 00       	mov    %eax,0x806048
  80313a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80313d:	a3 44 60 80 00       	mov    %eax,0x806044
  803142:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 50 60 80 00       	mov    0x806050,%eax
  803151:	40                   	inc    %eax
  803152:	a3 50 60 80 00       	mov    %eax,0x806050
  803157:	e9 dc 00 00 00       	jmp    803238 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	75 65                	jne    8031ca <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803165:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803169:	75 17                	jne    803182 <alloc_block_FF+0x1be>
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	68 b0 58 80 00       	push   $0x8058b0
  803173:	68 db 00 00 00       	push   $0xdb
  803178:	68 61 58 80 00       	push   $0x805861
  80317d:	e8 0f df ff ff       	call   801091 <_panic>
  803182:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803188:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0c                	je     8031a4 <alloc_block_FF+0x1e0>
  803198:	a1 48 60 80 00       	mov    0x806048,%eax
  80319d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031a0:	89 10                	mov    %edx,(%eax)
  8031a2:	eb 08                	jmp    8031ac <alloc_block_FF+0x1e8>
  8031a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031a7:	a3 44 60 80 00       	mov    %eax,0x806044
  8031ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031af:	a3 48 60 80 00       	mov    %eax,0x806048
  8031b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bd:	a1 50 60 80 00       	mov    0x806050,%eax
  8031c2:	40                   	inc    %eax
  8031c3:	a3 50 60 80 00       	mov    %eax,0x806050
  8031c8:	eb 6e                	jmp    803238 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8031ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ce:	74 06                	je     8031d6 <alloc_block_FF+0x212>
  8031d0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031d4:	75 17                	jne    8031ed <alloc_block_FF+0x229>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 d4 58 80 00       	push   $0x8058d4
  8031de:	68 df 00 00 00       	push   $0xdf
  8031e3:	68 61 58 80 00       	push   $0x805861
  8031e8:	e8 a4 de ff ff       	call   801091 <_panic>
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 10                	mov    (%eax),%edx
  8031f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0b                	je     80320b <alloc_block_FF+0x247>
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803211:	89 10                	mov    %edx,(%eax)
  803213:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803216:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803219:	89 50 04             	mov    %edx,0x4(%eax)
  80321c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	75 08                	jne    80322d <alloc_block_FF+0x269>
  803225:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803228:	a3 48 60 80 00       	mov    %eax,0x806048
  80322d:	a1 50 60 80 00       	mov    0x806050,%eax
  803232:	40                   	inc    %eax
  803233:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323c:	75 17                	jne    803255 <alloc_block_FF+0x291>
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	68 43 58 80 00       	push   $0x805843
  803246:	68 e1 00 00 00       	push   $0xe1
  80324b:	68 61 58 80 00       	push   $0x805861
  803250:	e8 3c de ff ff       	call   801091 <_panic>
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 10                	je     80326e <alloc_block_FF+0x2aa>
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803266:	8b 52 04             	mov    0x4(%edx),%edx
  803269:	89 50 04             	mov    %edx,0x4(%eax)
  80326c:	eb 0b                	jmp    803279 <alloc_block_FF+0x2b5>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	a3 48 60 80 00       	mov    %eax,0x806048
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 0f                	je     803292 <alloc_block_FF+0x2ce>
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328c:	8b 12                	mov    (%edx),%edx
  80328e:	89 10                	mov    %edx,(%eax)
  803290:	eb 0a                	jmp    80329c <alloc_block_FF+0x2d8>
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	a3 44 60 80 00       	mov    %eax,0x806044
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 50 60 80 00       	mov    0x806050,%eax
  8032b4:	48                   	dec    %eax
  8032b5:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  8032ba:	83 ec 04             	sub    $0x4,%esp
  8032bd:	6a 00                	push   $0x0
  8032bf:	ff 75 b4             	pushl  -0x4c(%ebp)
  8032c2:	ff 75 b0             	pushl  -0x50(%ebp)
  8032c5:	e8 cb fc ff ff       	call   802f95 <set_block_data>
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	e9 95 00 00 00       	jmp    803367 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	6a 01                	push   $0x1
  8032d7:	ff 75 b8             	pushl  -0x48(%ebp)
  8032da:	ff 75 bc             	pushl  -0x44(%ebp)
  8032dd:	e8 b3 fc ff ff       	call   802f95 <set_block_data>
  8032e2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8032e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e9:	75 17                	jne    803302 <alloc_block_FF+0x33e>
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 43 58 80 00       	push   $0x805843
  8032f3:	68 e8 00 00 00       	push   $0xe8
  8032f8:	68 61 58 80 00       	push   $0x805861
  8032fd:	e8 8f dd ff ff       	call   801091 <_panic>
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	85 c0                	test   %eax,%eax
  803309:	74 10                	je     80331b <alloc_block_FF+0x357>
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803313:	8b 52 04             	mov    0x4(%edx),%edx
  803316:	89 50 04             	mov    %edx,0x4(%eax)
  803319:	eb 0b                	jmp    803326 <alloc_block_FF+0x362>
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 40 04             	mov    0x4(%eax),%eax
  803321:	a3 48 60 80 00       	mov    %eax,0x806048
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 04             	mov    0x4(%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 0f                	je     80333f <alloc_block_FF+0x37b>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 40 04             	mov    0x4(%eax),%eax
  803336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803339:	8b 12                	mov    (%edx),%edx
  80333b:	89 10                	mov    %edx,(%eax)
  80333d:	eb 0a                	jmp    803349 <alloc_block_FF+0x385>
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	8b 00                	mov    (%eax),%eax
  803344:	a3 44 60 80 00       	mov    %eax,0x806044
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335c:	a1 50 60 80 00       	mov    0x806050,%eax
  803361:	48                   	dec    %eax
  803362:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  803367:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80336a:	e9 0f 01 00 00       	jmp    80347e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80336f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803374:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337b:	74 07                	je     803384 <alloc_block_FF+0x3c0>
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	eb 05                	jmp    803389 <alloc_block_FF+0x3c5>
  803384:	b8 00 00 00 00       	mov    $0x0,%eax
  803389:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80338e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	0f 85 e9 fc ff ff    	jne    803084 <alloc_block_FF+0xc0>
  80339b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339f:	0f 85 df fc ff ff    	jne    803084 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	83 c0 08             	add    $0x8,%eax
  8033ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033ae:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8033b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033bb:	01 d0                	add    %edx,%eax
  8033bd:	48                   	dec    %eax
  8033be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8033c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c9:	f7 75 d8             	divl   -0x28(%ebp)
  8033cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033cf:	29 d0                	sub    %edx,%eax
  8033d1:	c1 e8 0c             	shr    $0xc,%eax
  8033d4:	83 ec 0c             	sub    $0xc,%esp
  8033d7:	50                   	push   %eax
  8033d8:	e8 0b ed ff ff       	call   8020e8 <sbrk>
  8033dd:	83 c4 10             	add    $0x10,%esp
  8033e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8033e3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8033e7:	75 0a                	jne    8033f3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8033e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ee:	e9 8b 00 00 00       	jmp    80347e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033f3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8033fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803400:	01 d0                	add    %edx,%eax
  803402:	48                   	dec    %eax
  803403:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803406:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803409:	ba 00 00 00 00       	mov    $0x0,%edx
  80340e:	f7 75 cc             	divl   -0x34(%ebp)
  803411:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803414:	29 d0                	sub    %edx,%eax
  803416:	8d 50 fc             	lea    -0x4(%eax),%edx
  803419:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80341c:	01 d0                	add    %edx,%eax
  80341e:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  803423:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803428:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80342e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803435:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803438:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80343b:	01 d0                	add    %edx,%eax
  80343d:	48                   	dec    %eax
  80343e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803441:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803444:	ba 00 00 00 00       	mov    $0x0,%edx
  803449:	f7 75 c4             	divl   -0x3c(%ebp)
  80344c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80344f:	29 d0                	sub    %edx,%eax
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	6a 01                	push   $0x1
  803456:	50                   	push   %eax
  803457:	ff 75 d0             	pushl  -0x30(%ebp)
  80345a:	e8 36 fb ff ff       	call   802f95 <set_block_data>
  80345f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803462:	83 ec 0c             	sub    $0xc,%esp
  803465:	ff 75 d0             	pushl  -0x30(%ebp)
  803468:	e8 f8 09 00 00       	call   803e65 <free_block>
  80346d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	ff 75 08             	pushl  0x8(%ebp)
  803476:	e8 49 fb ff ff       	call   802fc4 <alloc_block_FF>
  80347b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80347e:	c9                   	leave  
  80347f:	c3                   	ret    

00803480 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803480:	55                   	push   %ebp
  803481:	89 e5                	mov    %esp,%ebp
  803483:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	83 e0 01             	and    $0x1,%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	74 03                	je     803493 <alloc_block_BF+0x13>
  803490:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803493:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803497:	77 07                	ja     8034a0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803499:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8034a0:	a1 24 60 80 00       	mov    0x806024,%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	75 73                	jne    80351c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	83 c0 10             	add    $0x10,%eax
  8034af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034b2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8034b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bf:	01 d0                	add    %edx,%eax
  8034c1:	48                   	dec    %eax
  8034c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034cd:	f7 75 e0             	divl   -0x20(%ebp)
  8034d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d3:	29 d0                	sub    %edx,%eax
  8034d5:	c1 e8 0c             	shr    $0xc,%eax
  8034d8:	83 ec 0c             	sub    $0xc,%esp
  8034db:	50                   	push   %eax
  8034dc:	e8 07 ec ff ff       	call   8020e8 <sbrk>
  8034e1:	83 c4 10             	add    $0x10,%esp
  8034e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034e7:	83 ec 0c             	sub    $0xc,%esp
  8034ea:	6a 00                	push   $0x0
  8034ec:	e8 f7 eb ff ff       	call   8020e8 <sbrk>
  8034f1:	83 c4 10             	add    $0x10,%esp
  8034f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8034f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fa:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8034fd:	83 ec 08             	sub    $0x8,%esp
  803500:	50                   	push   %eax
  803501:	ff 75 d8             	pushl  -0x28(%ebp)
  803504:	e8 9f f8 ff ff       	call   802da8 <initialize_dynamic_allocator>
  803509:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	68 9f 58 80 00       	push   $0x80589f
  803514:	e8 35 de ff ff       	call   80134e <cprintf>
  803519:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80351c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80352a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803531:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803538:	a1 44 60 80 00       	mov    0x806044,%eax
  80353d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803540:	e9 1d 01 00 00       	jmp    803662 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803548:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80354b:	83 ec 0c             	sub    $0xc,%esp
  80354e:	ff 75 a8             	pushl  -0x58(%ebp)
  803551:	e8 ee f6 ff ff       	call   802c44 <get_block_size>
  803556:	83 c4 10             	add    $0x10,%esp
  803559:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	83 c0 08             	add    $0x8,%eax
  803562:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803565:	0f 87 ef 00 00 00    	ja     80365a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	83 c0 18             	add    $0x18,%eax
  803571:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803574:	77 1d                	ja     803593 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803579:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80357c:	0f 86 d8 00 00 00    	jbe    80365a <alloc_block_BF+0x1da>
				{
					best_va = va;
  803582:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803585:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803588:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80358b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80358e:	e9 c7 00 00 00       	jmp    80365a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	83 c0 08             	add    $0x8,%eax
  803599:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80359c:	0f 85 9d 00 00 00    	jne    80363f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	6a 01                	push   $0x1
  8035a7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8035aa:	ff 75 a8             	pushl  -0x58(%ebp)
  8035ad:	e8 e3 f9 ff ff       	call   802f95 <set_block_data>
  8035b2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8035b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b9:	75 17                	jne    8035d2 <alloc_block_BF+0x152>
  8035bb:	83 ec 04             	sub    $0x4,%esp
  8035be:	68 43 58 80 00       	push   $0x805843
  8035c3:	68 2c 01 00 00       	push   $0x12c
  8035c8:	68 61 58 80 00       	push   $0x805861
  8035cd:	e8 bf da ff ff       	call   801091 <_panic>
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 10                	je     8035eb <alloc_block_BF+0x16b>
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e3:	8b 52 04             	mov    0x4(%edx),%edx
  8035e6:	89 50 04             	mov    %edx,0x4(%eax)
  8035e9:	eb 0b                	jmp    8035f6 <alloc_block_BF+0x176>
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	a3 48 60 80 00       	mov    %eax,0x806048
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	8b 40 04             	mov    0x4(%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 0f                	je     80360f <alloc_block_BF+0x18f>
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 40 04             	mov    0x4(%eax),%eax
  803606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803609:	8b 12                	mov    (%edx),%edx
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	eb 0a                	jmp    803619 <alloc_block_BF+0x199>
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	a3 44 60 80 00       	mov    %eax,0x806044
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362c:	a1 50 60 80 00       	mov    0x806050,%eax
  803631:	48                   	dec    %eax
  803632:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803637:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80363a:	e9 01 04 00 00       	jmp    803a40 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80363f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803642:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803645:	76 13                	jbe    80365a <alloc_block_BF+0x1da>
					{
						internal = 1;
  803647:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80364e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803651:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803654:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803657:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80365a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80365f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803666:	74 07                	je     80366f <alloc_block_BF+0x1ef>
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	eb 05                	jmp    803674 <alloc_block_BF+0x1f4>
  80366f:	b8 00 00 00 00       	mov    $0x0,%eax
  803674:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803679:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80367e:	85 c0                	test   %eax,%eax
  803680:	0f 85 bf fe ff ff    	jne    803545 <alloc_block_BF+0xc5>
  803686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368a:	0f 85 b5 fe ff ff    	jne    803545 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803690:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803694:	0f 84 26 02 00 00    	je     8038c0 <alloc_block_BF+0x440>
  80369a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80369e:	0f 85 1c 02 00 00    	jne    8038c0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8036a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8036aa:	83 e8 08             	sub    $0x8,%eax
  8036ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	8d 50 08             	lea    0x8(%eax),%edx
  8036b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b9:	01 d0                	add    %edx,%eax
  8036bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	83 c0 08             	add    $0x8,%eax
  8036c4:	83 ec 04             	sub    $0x4,%esp
  8036c7:	6a 01                	push   $0x1
  8036c9:	50                   	push   %eax
  8036ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8036cd:	e8 c3 f8 ff ff       	call   802f95 <set_block_data>
  8036d2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8036d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	75 68                	jne    803747 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036e3:	75 17                	jne    8036fc <alloc_block_BF+0x27c>
  8036e5:	83 ec 04             	sub    $0x4,%esp
  8036e8:	68 7c 58 80 00       	push   $0x80587c
  8036ed:	68 45 01 00 00       	push   $0x145
  8036f2:	68 61 58 80 00       	push   $0x805861
  8036f7:	e8 95 d9 ff ff       	call   801091 <_panic>
  8036fc:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803702:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803705:	89 10                	mov    %edx,(%eax)
  803707:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80370a:	8b 00                	mov    (%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 0d                	je     80371d <alloc_block_BF+0x29d>
  803710:	a1 44 60 80 00       	mov    0x806044,%eax
  803715:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803718:	89 50 04             	mov    %edx,0x4(%eax)
  80371b:	eb 08                	jmp    803725 <alloc_block_BF+0x2a5>
  80371d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803720:	a3 48 60 80 00       	mov    %eax,0x806048
  803725:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803728:	a3 44 60 80 00       	mov    %eax,0x806044
  80372d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803737:	a1 50 60 80 00       	mov    0x806050,%eax
  80373c:	40                   	inc    %eax
  80373d:	a3 50 60 80 00       	mov    %eax,0x806050
  803742:	e9 dc 00 00 00       	jmp    803823 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374a:	8b 00                	mov    (%eax),%eax
  80374c:	85 c0                	test   %eax,%eax
  80374e:	75 65                	jne    8037b5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803750:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803754:	75 17                	jne    80376d <alloc_block_BF+0x2ed>
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	68 b0 58 80 00       	push   $0x8058b0
  80375e:	68 4a 01 00 00       	push   $0x14a
  803763:	68 61 58 80 00       	push   $0x805861
  803768:	e8 24 d9 ff ff       	call   801091 <_panic>
  80376d:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803773:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803776:	89 50 04             	mov    %edx,0x4(%eax)
  803779:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80377c:	8b 40 04             	mov    0x4(%eax),%eax
  80377f:	85 c0                	test   %eax,%eax
  803781:	74 0c                	je     80378f <alloc_block_BF+0x30f>
  803783:	a1 48 60 80 00       	mov    0x806048,%eax
  803788:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80378b:	89 10                	mov    %edx,(%eax)
  80378d:	eb 08                	jmp    803797 <alloc_block_BF+0x317>
  80378f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803792:	a3 44 60 80 00       	mov    %eax,0x806044
  803797:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80379a:	a3 48 60 80 00       	mov    %eax,0x806048
  80379f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a8:	a1 50 60 80 00       	mov    0x806050,%eax
  8037ad:	40                   	inc    %eax
  8037ae:	a3 50 60 80 00       	mov    %eax,0x806050
  8037b3:	eb 6e                	jmp    803823 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8037b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037b9:	74 06                	je     8037c1 <alloc_block_BF+0x341>
  8037bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037bf:	75 17                	jne    8037d8 <alloc_block_BF+0x358>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 d4 58 80 00       	push   $0x8058d4
  8037c9:	68 4f 01 00 00       	push   $0x14f
  8037ce:	68 61 58 80 00       	push   $0x805861
  8037d3:	e8 b9 d8 ff ff       	call   801091 <_panic>
  8037d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037db:	8b 10                	mov    (%eax),%edx
  8037dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 0b                	je     8037f6 <alloc_block_BF+0x376>
  8037eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037fc:	89 10                	mov    %edx,(%eax)
  8037fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803801:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803804:	89 50 04             	mov    %edx,0x4(%eax)
  803807:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	75 08                	jne    803818 <alloc_block_BF+0x398>
  803810:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803813:	a3 48 60 80 00       	mov    %eax,0x806048
  803818:	a1 50 60 80 00       	mov    0x806050,%eax
  80381d:	40                   	inc    %eax
  80381e:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803823:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803827:	75 17                	jne    803840 <alloc_block_BF+0x3c0>
  803829:	83 ec 04             	sub    $0x4,%esp
  80382c:	68 43 58 80 00       	push   $0x805843
  803831:	68 51 01 00 00       	push   $0x151
  803836:	68 61 58 80 00       	push   $0x805861
  80383b:	e8 51 d8 ff ff       	call   801091 <_panic>
  803840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	74 10                	je     803859 <alloc_block_BF+0x3d9>
  803849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384c:	8b 00                	mov    (%eax),%eax
  80384e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803851:	8b 52 04             	mov    0x4(%edx),%edx
  803854:	89 50 04             	mov    %edx,0x4(%eax)
  803857:	eb 0b                	jmp    803864 <alloc_block_BF+0x3e4>
  803859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385c:	8b 40 04             	mov    0x4(%eax),%eax
  80385f:	a3 48 60 80 00       	mov    %eax,0x806048
  803864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	85 c0                	test   %eax,%eax
  80386c:	74 0f                	je     80387d <alloc_block_BF+0x3fd>
  80386e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803871:	8b 40 04             	mov    0x4(%eax),%eax
  803874:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803877:	8b 12                	mov    (%edx),%edx
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	eb 0a                	jmp    803887 <alloc_block_BF+0x407>
  80387d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803880:	8b 00                	mov    (%eax),%eax
  803882:	a3 44 60 80 00       	mov    %eax,0x806044
  803887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803893:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389a:	a1 50 60 80 00       	mov    0x806050,%eax
  80389f:	48                   	dec    %eax
  8038a0:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	6a 00                	push   $0x0
  8038aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8038ad:	ff 75 cc             	pushl  -0x34(%ebp)
  8038b0:	e8 e0 f6 ff ff       	call   802f95 <set_block_data>
  8038b5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bb:	e9 80 01 00 00       	jmp    803a40 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8038c0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8038c4:	0f 85 9d 00 00 00    	jne    803967 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8038ca:	83 ec 04             	sub    $0x4,%esp
  8038cd:	6a 01                	push   $0x1
  8038cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8038d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8038d5:	e8 bb f6 ff ff       	call   802f95 <set_block_data>
  8038da:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8038dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038e1:	75 17                	jne    8038fa <alloc_block_BF+0x47a>
  8038e3:	83 ec 04             	sub    $0x4,%esp
  8038e6:	68 43 58 80 00       	push   $0x805843
  8038eb:	68 58 01 00 00       	push   $0x158
  8038f0:	68 61 58 80 00       	push   $0x805861
  8038f5:	e8 97 d7 ff ff       	call   801091 <_panic>
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	74 10                	je     803913 <alloc_block_BF+0x493>
  803903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80390b:	8b 52 04             	mov    0x4(%edx),%edx
  80390e:	89 50 04             	mov    %edx,0x4(%eax)
  803911:	eb 0b                	jmp    80391e <alloc_block_BF+0x49e>
  803913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	a3 48 60 80 00       	mov    %eax,0x806048
  80391e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803921:	8b 40 04             	mov    0x4(%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 0f                	je     803937 <alloc_block_BF+0x4b7>
  803928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392b:	8b 40 04             	mov    0x4(%eax),%eax
  80392e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803931:	8b 12                	mov    (%edx),%edx
  803933:	89 10                	mov    %edx,(%eax)
  803935:	eb 0a                	jmp    803941 <alloc_block_BF+0x4c1>
  803937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393a:	8b 00                	mov    (%eax),%eax
  80393c:	a3 44 60 80 00       	mov    %eax,0x806044
  803941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80394a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803954:	a1 50 60 80 00       	mov    0x806050,%eax
  803959:	48                   	dec    %eax
  80395a:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  80395f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803962:	e9 d9 00 00 00       	jmp    803a40 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	83 c0 08             	add    $0x8,%eax
  80396d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803970:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803977:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80397a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80397d:	01 d0                	add    %edx,%eax
  80397f:	48                   	dec    %eax
  803980:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803983:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803986:	ba 00 00 00 00       	mov    $0x0,%edx
  80398b:	f7 75 c4             	divl   -0x3c(%ebp)
  80398e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803991:	29 d0                	sub    %edx,%eax
  803993:	c1 e8 0c             	shr    $0xc,%eax
  803996:	83 ec 0c             	sub    $0xc,%esp
  803999:	50                   	push   %eax
  80399a:	e8 49 e7 ff ff       	call   8020e8 <sbrk>
  80399f:	83 c4 10             	add    $0x10,%esp
  8039a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8039a5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8039a9:	75 0a                	jne    8039b5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8039ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b0:	e9 8b 00 00 00       	jmp    803a40 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8039b5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8039bc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c2:	01 d0                	add    %edx,%eax
  8039c4:	48                   	dec    %eax
  8039c5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8039c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8039d0:	f7 75 b8             	divl   -0x48(%ebp)
  8039d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039d6:	29 d0                	sub    %edx,%eax
  8039d8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8039db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8039de:	01 d0                	add    %edx,%eax
  8039e0:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8039e5:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8039ea:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8039f0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8039f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039fd:	01 d0                	add    %edx,%eax
  8039ff:	48                   	dec    %eax
  803a00:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a03:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a06:	ba 00 00 00 00       	mov    $0x0,%edx
  803a0b:	f7 75 b0             	divl   -0x50(%ebp)
  803a0e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a11:	29 d0                	sub    %edx,%eax
  803a13:	83 ec 04             	sub    $0x4,%esp
  803a16:	6a 01                	push   $0x1
  803a18:	50                   	push   %eax
  803a19:	ff 75 bc             	pushl  -0x44(%ebp)
  803a1c:	e8 74 f5 ff ff       	call   802f95 <set_block_data>
  803a21:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803a24:	83 ec 0c             	sub    $0xc,%esp
  803a27:	ff 75 bc             	pushl  -0x44(%ebp)
  803a2a:	e8 36 04 00 00       	call   803e65 <free_block>
  803a2f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803a32:	83 ec 0c             	sub    $0xc,%esp
  803a35:	ff 75 08             	pushl  0x8(%ebp)
  803a38:	e8 43 fa ff ff       	call   803480 <alloc_block_BF>
  803a3d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a40:	c9                   	leave  
  803a41:	c3                   	ret    

00803a42 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a42:	55                   	push   %ebp
  803a43:	89 e5                	mov    %esp,%ebp
  803a45:	53                   	push   %ebx
  803a46:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5b:	74 1e                	je     803a7b <merging+0x39>
  803a5d:	ff 75 08             	pushl  0x8(%ebp)
  803a60:	e8 df f1 ff ff       	call   802c44 <get_block_size>
  803a65:	83 c4 04             	add    $0x4,%esp
  803a68:	89 c2                	mov    %eax,%edx
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	01 d0                	add    %edx,%eax
  803a6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803a72:	75 07                	jne    803a7b <merging+0x39>
		prev_is_free = 1;
  803a74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803a7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a7f:	74 1e                	je     803a9f <merging+0x5d>
  803a81:	ff 75 10             	pushl  0x10(%ebp)
  803a84:	e8 bb f1 ff ff       	call   802c44 <get_block_size>
  803a89:	83 c4 04             	add    $0x4,%esp
  803a8c:	89 c2                	mov    %eax,%edx
  803a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  803a91:	01 d0                	add    %edx,%eax
  803a93:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a96:	75 07                	jne    803a9f <merging+0x5d>
		next_is_free = 1;
  803a98:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa3:	0f 84 cc 00 00 00    	je     803b75 <merging+0x133>
  803aa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aad:	0f 84 c2 00 00 00    	je     803b75 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803ab3:	ff 75 08             	pushl  0x8(%ebp)
  803ab6:	e8 89 f1 ff ff       	call   802c44 <get_block_size>
  803abb:	83 c4 04             	add    $0x4,%esp
  803abe:	89 c3                	mov    %eax,%ebx
  803ac0:	ff 75 10             	pushl  0x10(%ebp)
  803ac3:	e8 7c f1 ff ff       	call   802c44 <get_block_size>
  803ac8:	83 c4 04             	add    $0x4,%esp
  803acb:	01 c3                	add    %eax,%ebx
  803acd:	ff 75 0c             	pushl  0xc(%ebp)
  803ad0:	e8 6f f1 ff ff       	call   802c44 <get_block_size>
  803ad5:	83 c4 04             	add    $0x4,%esp
  803ad8:	01 d8                	add    %ebx,%eax
  803ada:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803add:	6a 00                	push   $0x0
  803adf:	ff 75 ec             	pushl  -0x14(%ebp)
  803ae2:	ff 75 08             	pushl  0x8(%ebp)
  803ae5:	e8 ab f4 ff ff       	call   802f95 <set_block_data>
  803aea:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803aed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803af1:	75 17                	jne    803b0a <merging+0xc8>
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	68 43 58 80 00       	push   $0x805843
  803afb:	68 7d 01 00 00       	push   $0x17d
  803b00:	68 61 58 80 00       	push   $0x805861
  803b05:	e8 87 d5 ff ff       	call   801091 <_panic>
  803b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0d:	8b 00                	mov    (%eax),%eax
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	74 10                	je     803b23 <merging+0xe1>
  803b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b1b:	8b 52 04             	mov    0x4(%edx),%edx
  803b1e:	89 50 04             	mov    %edx,0x4(%eax)
  803b21:	eb 0b                	jmp    803b2e <merging+0xec>
  803b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b26:	8b 40 04             	mov    0x4(%eax),%eax
  803b29:	a3 48 60 80 00       	mov    %eax,0x806048
  803b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b31:	8b 40 04             	mov    0x4(%eax),%eax
  803b34:	85 c0                	test   %eax,%eax
  803b36:	74 0f                	je     803b47 <merging+0x105>
  803b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3b:	8b 40 04             	mov    0x4(%eax),%eax
  803b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b41:	8b 12                	mov    (%edx),%edx
  803b43:	89 10                	mov    %edx,(%eax)
  803b45:	eb 0a                	jmp    803b51 <merging+0x10f>
  803b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4a:	8b 00                	mov    (%eax),%eax
  803b4c:	a3 44 60 80 00       	mov    %eax,0x806044
  803b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b64:	a1 50 60 80 00       	mov    0x806050,%eax
  803b69:	48                   	dec    %eax
  803b6a:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803b6f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b70:	e9 ea 02 00 00       	jmp    803e5f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b79:	74 3b                	je     803bb6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803b7b:	83 ec 0c             	sub    $0xc,%esp
  803b7e:	ff 75 08             	pushl  0x8(%ebp)
  803b81:	e8 be f0 ff ff       	call   802c44 <get_block_size>
  803b86:	83 c4 10             	add    $0x10,%esp
  803b89:	89 c3                	mov    %eax,%ebx
  803b8b:	83 ec 0c             	sub    $0xc,%esp
  803b8e:	ff 75 10             	pushl  0x10(%ebp)
  803b91:	e8 ae f0 ff ff       	call   802c44 <get_block_size>
  803b96:	83 c4 10             	add    $0x10,%esp
  803b99:	01 d8                	add    %ebx,%eax
  803b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b9e:	83 ec 04             	sub    $0x4,%esp
  803ba1:	6a 00                	push   $0x0
  803ba3:	ff 75 e8             	pushl  -0x18(%ebp)
  803ba6:	ff 75 08             	pushl  0x8(%ebp)
  803ba9:	e8 e7 f3 ff ff       	call   802f95 <set_block_data>
  803bae:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bb1:	e9 a9 02 00 00       	jmp    803e5f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803bb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bba:	0f 84 2d 01 00 00    	je     803ced <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803bc0:	83 ec 0c             	sub    $0xc,%esp
  803bc3:	ff 75 10             	pushl  0x10(%ebp)
  803bc6:	e8 79 f0 ff ff       	call   802c44 <get_block_size>
  803bcb:	83 c4 10             	add    $0x10,%esp
  803bce:	89 c3                	mov    %eax,%ebx
  803bd0:	83 ec 0c             	sub    $0xc,%esp
  803bd3:	ff 75 0c             	pushl  0xc(%ebp)
  803bd6:	e8 69 f0 ff ff       	call   802c44 <get_block_size>
  803bdb:	83 c4 10             	add    $0x10,%esp
  803bde:	01 d8                	add    %ebx,%eax
  803be0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803be3:	83 ec 04             	sub    $0x4,%esp
  803be6:	6a 00                	push   $0x0
  803be8:	ff 75 e4             	pushl  -0x1c(%ebp)
  803beb:	ff 75 10             	pushl  0x10(%ebp)
  803bee:	e8 a2 f3 ff ff       	call   802f95 <set_block_data>
  803bf3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  803bf9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c00:	74 06                	je     803c08 <merging+0x1c6>
  803c02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c06:	75 17                	jne    803c1f <merging+0x1dd>
  803c08:	83 ec 04             	sub    $0x4,%esp
  803c0b:	68 08 59 80 00       	push   $0x805908
  803c10:	68 8d 01 00 00       	push   $0x18d
  803c15:	68 61 58 80 00       	push   $0x805861
  803c1a:	e8 72 d4 ff ff       	call   801091 <_panic>
  803c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c22:	8b 50 04             	mov    0x4(%eax),%edx
  803c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c28:	89 50 04             	mov    %edx,0x4(%eax)
  803c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c31:	89 10                	mov    %edx,(%eax)
  803c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c36:	8b 40 04             	mov    0x4(%eax),%eax
  803c39:	85 c0                	test   %eax,%eax
  803c3b:	74 0d                	je     803c4a <merging+0x208>
  803c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c40:	8b 40 04             	mov    0x4(%eax),%eax
  803c43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c46:	89 10                	mov    %edx,(%eax)
  803c48:	eb 08                	jmp    803c52 <merging+0x210>
  803c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c4d:	a3 44 60 80 00       	mov    %eax,0x806044
  803c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c58:	89 50 04             	mov    %edx,0x4(%eax)
  803c5b:	a1 50 60 80 00       	mov    0x806050,%eax
  803c60:	40                   	inc    %eax
  803c61:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803c66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c6a:	75 17                	jne    803c83 <merging+0x241>
  803c6c:	83 ec 04             	sub    $0x4,%esp
  803c6f:	68 43 58 80 00       	push   $0x805843
  803c74:	68 8e 01 00 00       	push   $0x18e
  803c79:	68 61 58 80 00       	push   $0x805861
  803c7e:	e8 0e d4 ff ff       	call   801091 <_panic>
  803c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c86:	8b 00                	mov    (%eax),%eax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	74 10                	je     803c9c <merging+0x25a>
  803c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c94:	8b 52 04             	mov    0x4(%edx),%edx
  803c97:	89 50 04             	mov    %edx,0x4(%eax)
  803c9a:	eb 0b                	jmp    803ca7 <merging+0x265>
  803c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c9f:	8b 40 04             	mov    0x4(%eax),%eax
  803ca2:	a3 48 60 80 00       	mov    %eax,0x806048
  803ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803caa:	8b 40 04             	mov    0x4(%eax),%eax
  803cad:	85 c0                	test   %eax,%eax
  803caf:	74 0f                	je     803cc0 <merging+0x27e>
  803cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb4:	8b 40 04             	mov    0x4(%eax),%eax
  803cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cba:	8b 12                	mov    (%edx),%edx
  803cbc:	89 10                	mov    %edx,(%eax)
  803cbe:	eb 0a                	jmp    803cca <merging+0x288>
  803cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc3:	8b 00                	mov    (%eax),%eax
  803cc5:	a3 44 60 80 00       	mov    %eax,0x806044
  803cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ccd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdd:	a1 50 60 80 00       	mov    0x806050,%eax
  803ce2:	48                   	dec    %eax
  803ce3:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ce8:	e9 72 01 00 00       	jmp    803e5f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803ced:	8b 45 10             	mov    0x10(%ebp),%eax
  803cf0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803cf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cf7:	74 79                	je     803d72 <merging+0x330>
  803cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cfd:	74 73                	je     803d72 <merging+0x330>
  803cff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d03:	74 06                	je     803d0b <merging+0x2c9>
  803d05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d09:	75 17                	jne    803d22 <merging+0x2e0>
  803d0b:	83 ec 04             	sub    $0x4,%esp
  803d0e:	68 d4 58 80 00       	push   $0x8058d4
  803d13:	68 94 01 00 00       	push   $0x194
  803d18:	68 61 58 80 00       	push   $0x805861
  803d1d:	e8 6f d3 ff ff       	call   801091 <_panic>
  803d22:	8b 45 08             	mov    0x8(%ebp),%eax
  803d25:	8b 10                	mov    (%eax),%edx
  803d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2a:	89 10                	mov    %edx,(%eax)
  803d2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	85 c0                	test   %eax,%eax
  803d33:	74 0b                	je     803d40 <merging+0x2fe>
  803d35:	8b 45 08             	mov    0x8(%ebp),%eax
  803d38:	8b 00                	mov    (%eax),%eax
  803d3a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d3d:	89 50 04             	mov    %edx,0x4(%eax)
  803d40:	8b 45 08             	mov    0x8(%ebp),%eax
  803d43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d46:	89 10                	mov    %edx,(%eax)
  803d48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d4e:	89 50 04             	mov    %edx,0x4(%eax)
  803d51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d54:	8b 00                	mov    (%eax),%eax
  803d56:	85 c0                	test   %eax,%eax
  803d58:	75 08                	jne    803d62 <merging+0x320>
  803d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5d:	a3 48 60 80 00       	mov    %eax,0x806048
  803d62:	a1 50 60 80 00       	mov    0x806050,%eax
  803d67:	40                   	inc    %eax
  803d68:	a3 50 60 80 00       	mov    %eax,0x806050
  803d6d:	e9 ce 00 00 00       	jmp    803e40 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803d72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d76:	74 65                	je     803ddd <merging+0x39b>
  803d78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d7c:	75 17                	jne    803d95 <merging+0x353>
  803d7e:	83 ec 04             	sub    $0x4,%esp
  803d81:	68 b0 58 80 00       	push   $0x8058b0
  803d86:	68 95 01 00 00       	push   $0x195
  803d8b:	68 61 58 80 00       	push   $0x805861
  803d90:	e8 fc d2 ff ff       	call   801091 <_panic>
  803d95:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803d9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9e:	89 50 04             	mov    %edx,0x4(%eax)
  803da1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da4:	8b 40 04             	mov    0x4(%eax),%eax
  803da7:	85 c0                	test   %eax,%eax
  803da9:	74 0c                	je     803db7 <merging+0x375>
  803dab:	a1 48 60 80 00       	mov    0x806048,%eax
  803db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803db3:	89 10                	mov    %edx,(%eax)
  803db5:	eb 08                	jmp    803dbf <merging+0x37d>
  803db7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dba:	a3 44 60 80 00       	mov    %eax,0x806044
  803dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc2:	a3 48 60 80 00       	mov    %eax,0x806048
  803dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dd0:	a1 50 60 80 00       	mov    0x806050,%eax
  803dd5:	40                   	inc    %eax
  803dd6:	a3 50 60 80 00       	mov    %eax,0x806050
  803ddb:	eb 63                	jmp    803e40 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803ddd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803de1:	75 17                	jne    803dfa <merging+0x3b8>
  803de3:	83 ec 04             	sub    $0x4,%esp
  803de6:	68 7c 58 80 00       	push   $0x80587c
  803deb:	68 98 01 00 00       	push   $0x198
  803df0:	68 61 58 80 00       	push   $0x805861
  803df5:	e8 97 d2 ff ff       	call   801091 <_panic>
  803dfa:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803e00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e03:	89 10                	mov    %edx,(%eax)
  803e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e08:	8b 00                	mov    (%eax),%eax
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	74 0d                	je     803e1b <merging+0x3d9>
  803e0e:	a1 44 60 80 00       	mov    0x806044,%eax
  803e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e16:	89 50 04             	mov    %edx,0x4(%eax)
  803e19:	eb 08                	jmp    803e23 <merging+0x3e1>
  803e1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1e:	a3 48 60 80 00       	mov    %eax,0x806048
  803e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e26:	a3 44 60 80 00       	mov    %eax,0x806044
  803e2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e35:	a1 50 60 80 00       	mov    0x806050,%eax
  803e3a:	40                   	inc    %eax
  803e3b:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803e40:	83 ec 0c             	sub    $0xc,%esp
  803e43:	ff 75 10             	pushl  0x10(%ebp)
  803e46:	e8 f9 ed ff ff       	call   802c44 <get_block_size>
  803e4b:	83 c4 10             	add    $0x10,%esp
  803e4e:	83 ec 04             	sub    $0x4,%esp
  803e51:	6a 00                	push   $0x0
  803e53:	50                   	push   %eax
  803e54:	ff 75 10             	pushl  0x10(%ebp)
  803e57:	e8 39 f1 ff ff       	call   802f95 <set_block_data>
  803e5c:	83 c4 10             	add    $0x10,%esp
	}
}
  803e5f:	90                   	nop
  803e60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e63:	c9                   	leave  
  803e64:	c3                   	ret    

00803e65 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e65:	55                   	push   %ebp
  803e66:	89 e5                	mov    %esp,%ebp
  803e68:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803e6b:	a1 44 60 80 00       	mov    0x806044,%eax
  803e70:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803e73:	a1 48 60 80 00       	mov    0x806048,%eax
  803e78:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e7b:	73 1b                	jae    803e98 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803e7d:	a1 48 60 80 00       	mov    0x806048,%eax
  803e82:	83 ec 04             	sub    $0x4,%esp
  803e85:	ff 75 08             	pushl  0x8(%ebp)
  803e88:	6a 00                	push   $0x0
  803e8a:	50                   	push   %eax
  803e8b:	e8 b2 fb ff ff       	call   803a42 <merging>
  803e90:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e93:	e9 8b 00 00 00       	jmp    803f23 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803e98:	a1 44 60 80 00       	mov    0x806044,%eax
  803e9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ea0:	76 18                	jbe    803eba <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ea2:	a1 44 60 80 00       	mov    0x806044,%eax
  803ea7:	83 ec 04             	sub    $0x4,%esp
  803eaa:	ff 75 08             	pushl  0x8(%ebp)
  803ead:	50                   	push   %eax
  803eae:	6a 00                	push   $0x0
  803eb0:	e8 8d fb ff ff       	call   803a42 <merging>
  803eb5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803eb8:	eb 69                	jmp    803f23 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803eba:	a1 44 60 80 00       	mov    0x806044,%eax
  803ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ec2:	eb 39                	jmp    803efd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eca:	73 29                	jae    803ef5 <free_block+0x90>
  803ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecf:	8b 00                	mov    (%eax),%eax
  803ed1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ed4:	76 1f                	jbe    803ef5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed9:	8b 00                	mov    (%eax),%eax
  803edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ede:	83 ec 04             	sub    $0x4,%esp
  803ee1:	ff 75 08             	pushl  0x8(%ebp)
  803ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  803ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  803eea:	e8 53 fb ff ff       	call   803a42 <merging>
  803eef:	83 c4 10             	add    $0x10,%esp
			break;
  803ef2:	90                   	nop
		}
	}
}
  803ef3:	eb 2e                	jmp    803f23 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ef5:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f01:	74 07                	je     803f0a <free_block+0xa5>
  803f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f06:	8b 00                	mov    (%eax),%eax
  803f08:	eb 05                	jmp    803f0f <free_block+0xaa>
  803f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f14:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f19:	85 c0                	test   %eax,%eax
  803f1b:	75 a7                	jne    803ec4 <free_block+0x5f>
  803f1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f21:	75 a1                	jne    803ec4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f23:	90                   	nop
  803f24:	c9                   	leave  
  803f25:	c3                   	ret    

00803f26 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803f26:	55                   	push   %ebp
  803f27:	89 e5                	mov    %esp,%ebp
  803f29:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803f2c:	ff 75 08             	pushl  0x8(%ebp)
  803f2f:	e8 10 ed ff ff       	call   802c44 <get_block_size>
  803f34:	83 c4 04             	add    $0x4,%esp
  803f37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f41:	eb 17                	jmp    803f5a <copy_data+0x34>
  803f43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f49:	01 c2                	add    %eax,%edx
  803f4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f51:	01 c8                	add    %ecx,%eax
  803f53:	8a 00                	mov    (%eax),%al
  803f55:	88 02                	mov    %al,(%edx)
  803f57:	ff 45 fc             	incl   -0x4(%ebp)
  803f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f60:	72 e1                	jb     803f43 <copy_data+0x1d>
}
  803f62:	90                   	nop
  803f63:	c9                   	leave  
  803f64:	c3                   	ret    

00803f65 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f65:	55                   	push   %ebp
  803f66:	89 e5                	mov    %esp,%ebp
  803f68:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f6f:	75 23                	jne    803f94 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803f71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f75:	74 13                	je     803f8a <realloc_block_FF+0x25>
  803f77:	83 ec 0c             	sub    $0xc,%esp
  803f7a:	ff 75 0c             	pushl  0xc(%ebp)
  803f7d:	e8 42 f0 ff ff       	call   802fc4 <alloc_block_FF>
  803f82:	83 c4 10             	add    $0x10,%esp
  803f85:	e9 e4 06 00 00       	jmp    80466e <realloc_block_FF+0x709>
		return NULL;
  803f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8f:	e9 da 06 00 00       	jmp    80466e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803f94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f98:	75 18                	jne    803fb2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803f9a:	83 ec 0c             	sub    $0xc,%esp
  803f9d:	ff 75 08             	pushl  0x8(%ebp)
  803fa0:	e8 c0 fe ff ff       	call   803e65 <free_block>
  803fa5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fad:	e9 bc 06 00 00       	jmp    80466e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803fb2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803fb6:	77 07                	ja     803fbf <realloc_block_FF+0x5a>
  803fb8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc2:	83 e0 01             	and    $0x1,%eax
  803fc5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fcb:	83 c0 08             	add    $0x8,%eax
  803fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803fd1:	83 ec 0c             	sub    $0xc,%esp
  803fd4:	ff 75 08             	pushl  0x8(%ebp)
  803fd7:	e8 68 ec ff ff       	call   802c44 <get_block_size>
  803fdc:	83 c4 10             	add    $0x10,%esp
  803fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fe5:	83 e8 08             	sub    $0x8,%eax
  803fe8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803feb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fee:	83 e8 04             	sub    $0x4,%eax
  803ff1:	8b 00                	mov    (%eax),%eax
  803ff3:	83 e0 fe             	and    $0xfffffffe,%eax
  803ff6:	89 c2                	mov    %eax,%edx
  803ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffb:	01 d0                	add    %edx,%eax
  803ffd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804000:	83 ec 0c             	sub    $0xc,%esp
  804003:	ff 75 e4             	pushl  -0x1c(%ebp)
  804006:	e8 39 ec ff ff       	call   802c44 <get_block_size>
  80400b:	83 c4 10             	add    $0x10,%esp
  80400e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804014:	83 e8 08             	sub    $0x8,%eax
  804017:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80401a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80401d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804020:	75 08                	jne    80402a <realloc_block_FF+0xc5>
	{
		 return va;
  804022:	8b 45 08             	mov    0x8(%ebp),%eax
  804025:	e9 44 06 00 00       	jmp    80466e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80402a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804030:	0f 83 d5 03 00 00    	jae    80440b <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804039:	2b 45 0c             	sub    0xc(%ebp),%eax
  80403c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80403f:	83 ec 0c             	sub    $0xc,%esp
  804042:	ff 75 e4             	pushl  -0x1c(%ebp)
  804045:	e8 13 ec ff ff       	call   802c5d <is_free_block>
  80404a:	83 c4 10             	add    $0x10,%esp
  80404d:	84 c0                	test   %al,%al
  80404f:	0f 84 3b 01 00 00    	je     804190 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804055:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804058:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80405b:	01 d0                	add    %edx,%eax
  80405d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804060:	83 ec 04             	sub    $0x4,%esp
  804063:	6a 01                	push   $0x1
  804065:	ff 75 f0             	pushl  -0x10(%ebp)
  804068:	ff 75 08             	pushl  0x8(%ebp)
  80406b:	e8 25 ef ff ff       	call   802f95 <set_block_data>
  804070:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804073:	8b 45 08             	mov    0x8(%ebp),%eax
  804076:	83 e8 04             	sub    $0x4,%eax
  804079:	8b 00                	mov    (%eax),%eax
  80407b:	83 e0 fe             	and    $0xfffffffe,%eax
  80407e:	89 c2                	mov    %eax,%edx
  804080:	8b 45 08             	mov    0x8(%ebp),%eax
  804083:	01 d0                	add    %edx,%eax
  804085:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804088:	83 ec 04             	sub    $0x4,%esp
  80408b:	6a 00                	push   $0x0
  80408d:	ff 75 cc             	pushl  -0x34(%ebp)
  804090:	ff 75 c8             	pushl  -0x38(%ebp)
  804093:	e8 fd ee ff ff       	call   802f95 <set_block_data>
  804098:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80409b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80409f:	74 06                	je     8040a7 <realloc_block_FF+0x142>
  8040a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8040a5:	75 17                	jne    8040be <realloc_block_FF+0x159>
  8040a7:	83 ec 04             	sub    $0x4,%esp
  8040aa:	68 d4 58 80 00       	push   $0x8058d4
  8040af:	68 f6 01 00 00       	push   $0x1f6
  8040b4:	68 61 58 80 00       	push   $0x805861
  8040b9:	e8 d3 cf ff ff       	call   801091 <_panic>
  8040be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c1:	8b 10                	mov    (%eax),%edx
  8040c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040c6:	89 10                	mov    %edx,(%eax)
  8040c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040cb:	8b 00                	mov    (%eax),%eax
  8040cd:	85 c0                	test   %eax,%eax
  8040cf:	74 0b                	je     8040dc <realloc_block_FF+0x177>
  8040d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d4:	8b 00                	mov    (%eax),%eax
  8040d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040d9:	89 50 04             	mov    %edx,0x4(%eax)
  8040dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040e2:	89 10                	mov    %edx,(%eax)
  8040e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ea:	89 50 04             	mov    %edx,0x4(%eax)
  8040ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040f0:	8b 00                	mov    (%eax),%eax
  8040f2:	85 c0                	test   %eax,%eax
  8040f4:	75 08                	jne    8040fe <realloc_block_FF+0x199>
  8040f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040f9:	a3 48 60 80 00       	mov    %eax,0x806048
  8040fe:	a1 50 60 80 00       	mov    0x806050,%eax
  804103:	40                   	inc    %eax
  804104:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804109:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80410d:	75 17                	jne    804126 <realloc_block_FF+0x1c1>
  80410f:	83 ec 04             	sub    $0x4,%esp
  804112:	68 43 58 80 00       	push   $0x805843
  804117:	68 f7 01 00 00       	push   $0x1f7
  80411c:	68 61 58 80 00       	push   $0x805861
  804121:	e8 6b cf ff ff       	call   801091 <_panic>
  804126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804129:	8b 00                	mov    (%eax),%eax
  80412b:	85 c0                	test   %eax,%eax
  80412d:	74 10                	je     80413f <realloc_block_FF+0x1da>
  80412f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804132:	8b 00                	mov    (%eax),%eax
  804134:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804137:	8b 52 04             	mov    0x4(%edx),%edx
  80413a:	89 50 04             	mov    %edx,0x4(%eax)
  80413d:	eb 0b                	jmp    80414a <realloc_block_FF+0x1e5>
  80413f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804142:	8b 40 04             	mov    0x4(%eax),%eax
  804145:	a3 48 60 80 00       	mov    %eax,0x806048
  80414a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414d:	8b 40 04             	mov    0x4(%eax),%eax
  804150:	85 c0                	test   %eax,%eax
  804152:	74 0f                	je     804163 <realloc_block_FF+0x1fe>
  804154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804157:	8b 40 04             	mov    0x4(%eax),%eax
  80415a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80415d:	8b 12                	mov    (%edx),%edx
  80415f:	89 10                	mov    %edx,(%eax)
  804161:	eb 0a                	jmp    80416d <realloc_block_FF+0x208>
  804163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804166:	8b 00                	mov    (%eax),%eax
  804168:	a3 44 60 80 00       	mov    %eax,0x806044
  80416d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804180:	a1 50 60 80 00       	mov    0x806050,%eax
  804185:	48                   	dec    %eax
  804186:	a3 50 60 80 00       	mov    %eax,0x806050
  80418b:	e9 73 02 00 00       	jmp    804403 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  804190:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804194:	0f 86 69 02 00 00    	jbe    804403 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80419a:	83 ec 04             	sub    $0x4,%esp
  80419d:	6a 01                	push   $0x1
  80419f:	ff 75 f0             	pushl  -0x10(%ebp)
  8041a2:	ff 75 08             	pushl  0x8(%ebp)
  8041a5:	e8 eb ed ff ff       	call   802f95 <set_block_data>
  8041aa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b0:	83 e8 04             	sub    $0x4,%eax
  8041b3:	8b 00                	mov    (%eax),%eax
  8041b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8041b8:	89 c2                	mov    %eax,%edx
  8041ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bd:	01 d0                	add    %edx,%eax
  8041bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8041c2:	a1 50 60 80 00       	mov    0x806050,%eax
  8041c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8041ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8041ce:	75 68                	jne    804238 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041d4:	75 17                	jne    8041ed <realloc_block_FF+0x288>
  8041d6:	83 ec 04             	sub    $0x4,%esp
  8041d9:	68 7c 58 80 00       	push   $0x80587c
  8041de:	68 06 02 00 00       	push   $0x206
  8041e3:	68 61 58 80 00       	push   $0x805861
  8041e8:	e8 a4 ce ff ff       	call   801091 <_panic>
  8041ed:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8041f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f6:	89 10                	mov    %edx,(%eax)
  8041f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041fb:	8b 00                	mov    (%eax),%eax
  8041fd:	85 c0                	test   %eax,%eax
  8041ff:	74 0d                	je     80420e <realloc_block_FF+0x2a9>
  804201:	a1 44 60 80 00       	mov    0x806044,%eax
  804206:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804209:	89 50 04             	mov    %edx,0x4(%eax)
  80420c:	eb 08                	jmp    804216 <realloc_block_FF+0x2b1>
  80420e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804211:	a3 48 60 80 00       	mov    %eax,0x806048
  804216:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804219:	a3 44 60 80 00       	mov    %eax,0x806044
  80421e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804228:	a1 50 60 80 00       	mov    0x806050,%eax
  80422d:	40                   	inc    %eax
  80422e:	a3 50 60 80 00       	mov    %eax,0x806050
  804233:	e9 b0 01 00 00       	jmp    8043e8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804238:	a1 44 60 80 00       	mov    0x806044,%eax
  80423d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804240:	76 68                	jbe    8042aa <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804242:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804246:	75 17                	jne    80425f <realloc_block_FF+0x2fa>
  804248:	83 ec 04             	sub    $0x4,%esp
  80424b:	68 7c 58 80 00       	push   $0x80587c
  804250:	68 0b 02 00 00       	push   $0x20b
  804255:	68 61 58 80 00       	push   $0x805861
  80425a:	e8 32 ce ff ff       	call   801091 <_panic>
  80425f:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804268:	89 10                	mov    %edx,(%eax)
  80426a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80426d:	8b 00                	mov    (%eax),%eax
  80426f:	85 c0                	test   %eax,%eax
  804271:	74 0d                	je     804280 <realloc_block_FF+0x31b>
  804273:	a1 44 60 80 00       	mov    0x806044,%eax
  804278:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80427b:	89 50 04             	mov    %edx,0x4(%eax)
  80427e:	eb 08                	jmp    804288 <realloc_block_FF+0x323>
  804280:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804283:	a3 48 60 80 00       	mov    %eax,0x806048
  804288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80428b:	a3 44 60 80 00       	mov    %eax,0x806044
  804290:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804293:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80429a:	a1 50 60 80 00       	mov    0x806050,%eax
  80429f:	40                   	inc    %eax
  8042a0:	a3 50 60 80 00       	mov    %eax,0x806050
  8042a5:	e9 3e 01 00 00       	jmp    8043e8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8042aa:	a1 44 60 80 00       	mov    0x806044,%eax
  8042af:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042b2:	73 68                	jae    80431c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042b8:	75 17                	jne    8042d1 <realloc_block_FF+0x36c>
  8042ba:	83 ec 04             	sub    $0x4,%esp
  8042bd:	68 b0 58 80 00       	push   $0x8058b0
  8042c2:	68 10 02 00 00       	push   $0x210
  8042c7:	68 61 58 80 00       	push   $0x805861
  8042cc:	e8 c0 cd ff ff       	call   801091 <_panic>
  8042d1:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8042d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042da:	89 50 04             	mov    %edx,0x4(%eax)
  8042dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042e0:	8b 40 04             	mov    0x4(%eax),%eax
  8042e3:	85 c0                	test   %eax,%eax
  8042e5:	74 0c                	je     8042f3 <realloc_block_FF+0x38e>
  8042e7:	a1 48 60 80 00       	mov    0x806048,%eax
  8042ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042ef:	89 10                	mov    %edx,(%eax)
  8042f1:	eb 08                	jmp    8042fb <realloc_block_FF+0x396>
  8042f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f6:	a3 44 60 80 00       	mov    %eax,0x806044
  8042fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042fe:	a3 48 60 80 00       	mov    %eax,0x806048
  804303:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80430c:	a1 50 60 80 00       	mov    0x806050,%eax
  804311:	40                   	inc    %eax
  804312:	a3 50 60 80 00       	mov    %eax,0x806050
  804317:	e9 cc 00 00 00       	jmp    8043e8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80431c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804323:	a1 44 60 80 00       	mov    0x806044,%eax
  804328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80432b:	e9 8a 00 00 00       	jmp    8043ba <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804333:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804336:	73 7a                	jae    8043b2 <realloc_block_FF+0x44d>
  804338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433b:	8b 00                	mov    (%eax),%eax
  80433d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804340:	73 70                	jae    8043b2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804346:	74 06                	je     80434e <realloc_block_FF+0x3e9>
  804348:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80434c:	75 17                	jne    804365 <realloc_block_FF+0x400>
  80434e:	83 ec 04             	sub    $0x4,%esp
  804351:	68 d4 58 80 00       	push   $0x8058d4
  804356:	68 1a 02 00 00       	push   $0x21a
  80435b:	68 61 58 80 00       	push   $0x805861
  804360:	e8 2c cd ff ff       	call   801091 <_panic>
  804365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804368:	8b 10                	mov    (%eax),%edx
  80436a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80436d:	89 10                	mov    %edx,(%eax)
  80436f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804372:	8b 00                	mov    (%eax),%eax
  804374:	85 c0                	test   %eax,%eax
  804376:	74 0b                	je     804383 <realloc_block_FF+0x41e>
  804378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437b:	8b 00                	mov    (%eax),%eax
  80437d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804380:	89 50 04             	mov    %edx,0x4(%eax)
  804383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804386:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804389:	89 10                	mov    %edx,(%eax)
  80438b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80438e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804391:	89 50 04             	mov    %edx,0x4(%eax)
  804394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804397:	8b 00                	mov    (%eax),%eax
  804399:	85 c0                	test   %eax,%eax
  80439b:	75 08                	jne    8043a5 <realloc_block_FF+0x440>
  80439d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a0:	a3 48 60 80 00       	mov    %eax,0x806048
  8043a5:	a1 50 60 80 00       	mov    0x806050,%eax
  8043aa:	40                   	inc    %eax
  8043ab:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  8043b0:	eb 36                	jmp    8043e8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8043b2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043be:	74 07                	je     8043c7 <realloc_block_FF+0x462>
  8043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	eb 05                	jmp    8043cc <realloc_block_FF+0x467>
  8043c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043cc:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8043d1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043d6:	85 c0                	test   %eax,%eax
  8043d8:	0f 85 52 ff ff ff    	jne    804330 <realloc_block_FF+0x3cb>
  8043de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043e2:	0f 85 48 ff ff ff    	jne    804330 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8043e8:	83 ec 04             	sub    $0x4,%esp
  8043eb:	6a 00                	push   $0x0
  8043ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8043f0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8043f3:	e8 9d eb ff ff       	call   802f95 <set_block_data>
  8043f8:	83 c4 10             	add    $0x10,%esp
				return va;
  8043fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8043fe:	e9 6b 02 00 00       	jmp    80466e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  804403:	8b 45 08             	mov    0x8(%ebp),%eax
  804406:	e9 63 02 00 00       	jmp    80466e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80440b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80440e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804411:	0f 86 4d 02 00 00    	jbe    804664 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  804417:	83 ec 0c             	sub    $0xc,%esp
  80441a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80441d:	e8 3b e8 ff ff       	call   802c5d <is_free_block>
  804422:	83 c4 10             	add    $0x10,%esp
  804425:	84 c0                	test   %al,%al
  804427:	0f 84 37 02 00 00    	je     804664 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80442d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804430:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804433:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804436:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804439:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80443c:	76 38                	jbe    804476 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80443e:	83 ec 0c             	sub    $0xc,%esp
  804441:	ff 75 0c             	pushl  0xc(%ebp)
  804444:	e8 7b eb ff ff       	call   802fc4 <alloc_block_FF>
  804449:	83 c4 10             	add    $0x10,%esp
  80444c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80444f:	83 ec 08             	sub    $0x8,%esp
  804452:	ff 75 c0             	pushl  -0x40(%ebp)
  804455:	ff 75 08             	pushl  0x8(%ebp)
  804458:	e8 c9 fa ff ff       	call   803f26 <copy_data>
  80445d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804460:	83 ec 0c             	sub    $0xc,%esp
  804463:	ff 75 08             	pushl  0x8(%ebp)
  804466:	e8 fa f9 ff ff       	call   803e65 <free_block>
  80446b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80446e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804471:	e9 f8 01 00 00       	jmp    80466e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804479:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80447c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80447f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804483:	0f 87 a0 00 00 00    	ja     804529 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804489:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80448d:	75 17                	jne    8044a6 <realloc_block_FF+0x541>
  80448f:	83 ec 04             	sub    $0x4,%esp
  804492:	68 43 58 80 00       	push   $0x805843
  804497:	68 38 02 00 00       	push   $0x238
  80449c:	68 61 58 80 00       	push   $0x805861
  8044a1:	e8 eb cb ff ff       	call   801091 <_panic>
  8044a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044a9:	8b 00                	mov    (%eax),%eax
  8044ab:	85 c0                	test   %eax,%eax
  8044ad:	74 10                	je     8044bf <realloc_block_FF+0x55a>
  8044af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b2:	8b 00                	mov    (%eax),%eax
  8044b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044b7:	8b 52 04             	mov    0x4(%edx),%edx
  8044ba:	89 50 04             	mov    %edx,0x4(%eax)
  8044bd:	eb 0b                	jmp    8044ca <realloc_block_FF+0x565>
  8044bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044c2:	8b 40 04             	mov    0x4(%eax),%eax
  8044c5:	a3 48 60 80 00       	mov    %eax,0x806048
  8044ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044cd:	8b 40 04             	mov    0x4(%eax),%eax
  8044d0:	85 c0                	test   %eax,%eax
  8044d2:	74 0f                	je     8044e3 <realloc_block_FF+0x57e>
  8044d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d7:	8b 40 04             	mov    0x4(%eax),%eax
  8044da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044dd:	8b 12                	mov    (%edx),%edx
  8044df:	89 10                	mov    %edx,(%eax)
  8044e1:	eb 0a                	jmp    8044ed <realloc_block_FF+0x588>
  8044e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e6:	8b 00                	mov    (%eax),%eax
  8044e8:	a3 44 60 80 00       	mov    %eax,0x806044
  8044ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804500:	a1 50 60 80 00       	mov    0x806050,%eax
  804505:	48                   	dec    %eax
  804506:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80450b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80450e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804511:	01 d0                	add    %edx,%eax
  804513:	83 ec 04             	sub    $0x4,%esp
  804516:	6a 01                	push   $0x1
  804518:	50                   	push   %eax
  804519:	ff 75 08             	pushl  0x8(%ebp)
  80451c:	e8 74 ea ff ff       	call   802f95 <set_block_data>
  804521:	83 c4 10             	add    $0x10,%esp
  804524:	e9 36 01 00 00       	jmp    80465f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80452c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80452f:	01 d0                	add    %edx,%eax
  804531:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804534:	83 ec 04             	sub    $0x4,%esp
  804537:	6a 01                	push   $0x1
  804539:	ff 75 f0             	pushl  -0x10(%ebp)
  80453c:	ff 75 08             	pushl  0x8(%ebp)
  80453f:	e8 51 ea ff ff       	call   802f95 <set_block_data>
  804544:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804547:	8b 45 08             	mov    0x8(%ebp),%eax
  80454a:	83 e8 04             	sub    $0x4,%eax
  80454d:	8b 00                	mov    (%eax),%eax
  80454f:	83 e0 fe             	and    $0xfffffffe,%eax
  804552:	89 c2                	mov    %eax,%edx
  804554:	8b 45 08             	mov    0x8(%ebp),%eax
  804557:	01 d0                	add    %edx,%eax
  804559:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80455c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804560:	74 06                	je     804568 <realloc_block_FF+0x603>
  804562:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804566:	75 17                	jne    80457f <realloc_block_FF+0x61a>
  804568:	83 ec 04             	sub    $0x4,%esp
  80456b:	68 d4 58 80 00       	push   $0x8058d4
  804570:	68 44 02 00 00       	push   $0x244
  804575:	68 61 58 80 00       	push   $0x805861
  80457a:	e8 12 cb ff ff       	call   801091 <_panic>
  80457f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804582:	8b 10                	mov    (%eax),%edx
  804584:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804587:	89 10                	mov    %edx,(%eax)
  804589:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80458c:	8b 00                	mov    (%eax),%eax
  80458e:	85 c0                	test   %eax,%eax
  804590:	74 0b                	je     80459d <realloc_block_FF+0x638>
  804592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804595:	8b 00                	mov    (%eax),%eax
  804597:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80459a:	89 50 04             	mov    %edx,0x4(%eax)
  80459d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045a0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045a3:	89 10                	mov    %edx,(%eax)
  8045a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045ab:	89 50 04             	mov    %edx,0x4(%eax)
  8045ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045b1:	8b 00                	mov    (%eax),%eax
  8045b3:	85 c0                	test   %eax,%eax
  8045b5:	75 08                	jne    8045bf <realloc_block_FF+0x65a>
  8045b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045ba:	a3 48 60 80 00       	mov    %eax,0x806048
  8045bf:	a1 50 60 80 00       	mov    0x806050,%eax
  8045c4:	40                   	inc    %eax
  8045c5:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045ce:	75 17                	jne    8045e7 <realloc_block_FF+0x682>
  8045d0:	83 ec 04             	sub    $0x4,%esp
  8045d3:	68 43 58 80 00       	push   $0x805843
  8045d8:	68 45 02 00 00       	push   $0x245
  8045dd:	68 61 58 80 00       	push   $0x805861
  8045e2:	e8 aa ca ff ff       	call   801091 <_panic>
  8045e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ea:	8b 00                	mov    (%eax),%eax
  8045ec:	85 c0                	test   %eax,%eax
  8045ee:	74 10                	je     804600 <realloc_block_FF+0x69b>
  8045f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f3:	8b 00                	mov    (%eax),%eax
  8045f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045f8:	8b 52 04             	mov    0x4(%edx),%edx
  8045fb:	89 50 04             	mov    %edx,0x4(%eax)
  8045fe:	eb 0b                	jmp    80460b <realloc_block_FF+0x6a6>
  804600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804603:	8b 40 04             	mov    0x4(%eax),%eax
  804606:	a3 48 60 80 00       	mov    %eax,0x806048
  80460b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80460e:	8b 40 04             	mov    0x4(%eax),%eax
  804611:	85 c0                	test   %eax,%eax
  804613:	74 0f                	je     804624 <realloc_block_FF+0x6bf>
  804615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804618:	8b 40 04             	mov    0x4(%eax),%eax
  80461b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80461e:	8b 12                	mov    (%edx),%edx
  804620:	89 10                	mov    %edx,(%eax)
  804622:	eb 0a                	jmp    80462e <realloc_block_FF+0x6c9>
  804624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804627:	8b 00                	mov    (%eax),%eax
  804629:	a3 44 60 80 00       	mov    %eax,0x806044
  80462e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80463a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804641:	a1 50 60 80 00       	mov    0x806050,%eax
  804646:	48                   	dec    %eax
  804647:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  80464c:	83 ec 04             	sub    $0x4,%esp
  80464f:	6a 00                	push   $0x0
  804651:	ff 75 bc             	pushl  -0x44(%ebp)
  804654:	ff 75 b8             	pushl  -0x48(%ebp)
  804657:	e8 39 e9 ff ff       	call   802f95 <set_block_data>
  80465c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80465f:	8b 45 08             	mov    0x8(%ebp),%eax
  804662:	eb 0a                	jmp    80466e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804664:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80466b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80466e:	c9                   	leave  
  80466f:	c3                   	ret    

00804670 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804670:	55                   	push   %ebp
  804671:	89 e5                	mov    %esp,%ebp
  804673:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804676:	83 ec 04             	sub    $0x4,%esp
  804679:	68 40 59 80 00       	push   $0x805940
  80467e:	68 58 02 00 00       	push   $0x258
  804683:	68 61 58 80 00       	push   $0x805861
  804688:	e8 04 ca ff ff       	call   801091 <_panic>

0080468d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80468d:	55                   	push   %ebp
  80468e:	89 e5                	mov    %esp,%ebp
  804690:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804693:	83 ec 04             	sub    $0x4,%esp
  804696:	68 68 59 80 00       	push   $0x805968
  80469b:	68 61 02 00 00       	push   $0x261
  8046a0:	68 61 58 80 00       	push   $0x805861
  8046a5:	e8 e7 c9 ff ff       	call   801091 <_panic>
  8046aa:	66 90                	xchg   %ax,%ax

008046ac <__udivdi3>:
  8046ac:	55                   	push   %ebp
  8046ad:	57                   	push   %edi
  8046ae:	56                   	push   %esi
  8046af:	53                   	push   %ebx
  8046b0:	83 ec 1c             	sub    $0x1c,%esp
  8046b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8046c3:	89 ca                	mov    %ecx,%edx
  8046c5:	89 f8                	mov    %edi,%eax
  8046c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046cb:	85 f6                	test   %esi,%esi
  8046cd:	75 2d                	jne    8046fc <__udivdi3+0x50>
  8046cf:	39 cf                	cmp    %ecx,%edi
  8046d1:	77 65                	ja     804738 <__udivdi3+0x8c>
  8046d3:	89 fd                	mov    %edi,%ebp
  8046d5:	85 ff                	test   %edi,%edi
  8046d7:	75 0b                	jne    8046e4 <__udivdi3+0x38>
  8046d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8046de:	31 d2                	xor    %edx,%edx
  8046e0:	f7 f7                	div    %edi
  8046e2:	89 c5                	mov    %eax,%ebp
  8046e4:	31 d2                	xor    %edx,%edx
  8046e6:	89 c8                	mov    %ecx,%eax
  8046e8:	f7 f5                	div    %ebp
  8046ea:	89 c1                	mov    %eax,%ecx
  8046ec:	89 d8                	mov    %ebx,%eax
  8046ee:	f7 f5                	div    %ebp
  8046f0:	89 cf                	mov    %ecx,%edi
  8046f2:	89 fa                	mov    %edi,%edx
  8046f4:	83 c4 1c             	add    $0x1c,%esp
  8046f7:	5b                   	pop    %ebx
  8046f8:	5e                   	pop    %esi
  8046f9:	5f                   	pop    %edi
  8046fa:	5d                   	pop    %ebp
  8046fb:	c3                   	ret    
  8046fc:	39 ce                	cmp    %ecx,%esi
  8046fe:	77 28                	ja     804728 <__udivdi3+0x7c>
  804700:	0f bd fe             	bsr    %esi,%edi
  804703:	83 f7 1f             	xor    $0x1f,%edi
  804706:	75 40                	jne    804748 <__udivdi3+0x9c>
  804708:	39 ce                	cmp    %ecx,%esi
  80470a:	72 0a                	jb     804716 <__udivdi3+0x6a>
  80470c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804710:	0f 87 9e 00 00 00    	ja     8047b4 <__udivdi3+0x108>
  804716:	b8 01 00 00 00       	mov    $0x1,%eax
  80471b:	89 fa                	mov    %edi,%edx
  80471d:	83 c4 1c             	add    $0x1c,%esp
  804720:	5b                   	pop    %ebx
  804721:	5e                   	pop    %esi
  804722:	5f                   	pop    %edi
  804723:	5d                   	pop    %ebp
  804724:	c3                   	ret    
  804725:	8d 76 00             	lea    0x0(%esi),%esi
  804728:	31 ff                	xor    %edi,%edi
  80472a:	31 c0                	xor    %eax,%eax
  80472c:	89 fa                	mov    %edi,%edx
  80472e:	83 c4 1c             	add    $0x1c,%esp
  804731:	5b                   	pop    %ebx
  804732:	5e                   	pop    %esi
  804733:	5f                   	pop    %edi
  804734:	5d                   	pop    %ebp
  804735:	c3                   	ret    
  804736:	66 90                	xchg   %ax,%ax
  804738:	89 d8                	mov    %ebx,%eax
  80473a:	f7 f7                	div    %edi
  80473c:	31 ff                	xor    %edi,%edi
  80473e:	89 fa                	mov    %edi,%edx
  804740:	83 c4 1c             	add    $0x1c,%esp
  804743:	5b                   	pop    %ebx
  804744:	5e                   	pop    %esi
  804745:	5f                   	pop    %edi
  804746:	5d                   	pop    %ebp
  804747:	c3                   	ret    
  804748:	bd 20 00 00 00       	mov    $0x20,%ebp
  80474d:	89 eb                	mov    %ebp,%ebx
  80474f:	29 fb                	sub    %edi,%ebx
  804751:	89 f9                	mov    %edi,%ecx
  804753:	d3 e6                	shl    %cl,%esi
  804755:	89 c5                	mov    %eax,%ebp
  804757:	88 d9                	mov    %bl,%cl
  804759:	d3 ed                	shr    %cl,%ebp
  80475b:	89 e9                	mov    %ebp,%ecx
  80475d:	09 f1                	or     %esi,%ecx
  80475f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804763:	89 f9                	mov    %edi,%ecx
  804765:	d3 e0                	shl    %cl,%eax
  804767:	89 c5                	mov    %eax,%ebp
  804769:	89 d6                	mov    %edx,%esi
  80476b:	88 d9                	mov    %bl,%cl
  80476d:	d3 ee                	shr    %cl,%esi
  80476f:	89 f9                	mov    %edi,%ecx
  804771:	d3 e2                	shl    %cl,%edx
  804773:	8b 44 24 08          	mov    0x8(%esp),%eax
  804777:	88 d9                	mov    %bl,%cl
  804779:	d3 e8                	shr    %cl,%eax
  80477b:	09 c2                	or     %eax,%edx
  80477d:	89 d0                	mov    %edx,%eax
  80477f:	89 f2                	mov    %esi,%edx
  804781:	f7 74 24 0c          	divl   0xc(%esp)
  804785:	89 d6                	mov    %edx,%esi
  804787:	89 c3                	mov    %eax,%ebx
  804789:	f7 e5                	mul    %ebp
  80478b:	39 d6                	cmp    %edx,%esi
  80478d:	72 19                	jb     8047a8 <__udivdi3+0xfc>
  80478f:	74 0b                	je     80479c <__udivdi3+0xf0>
  804791:	89 d8                	mov    %ebx,%eax
  804793:	31 ff                	xor    %edi,%edi
  804795:	e9 58 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  80479a:	66 90                	xchg   %ax,%ax
  80479c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047a0:	89 f9                	mov    %edi,%ecx
  8047a2:	d3 e2                	shl    %cl,%edx
  8047a4:	39 c2                	cmp    %eax,%edx
  8047a6:	73 e9                	jae    804791 <__udivdi3+0xe5>
  8047a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047ab:	31 ff                	xor    %edi,%edi
  8047ad:	e9 40 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  8047b2:	66 90                	xchg   %ax,%ax
  8047b4:	31 c0                	xor    %eax,%eax
  8047b6:	e9 37 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  8047bb:	90                   	nop

008047bc <__umoddi3>:
  8047bc:	55                   	push   %ebp
  8047bd:	57                   	push   %edi
  8047be:	56                   	push   %esi
  8047bf:	53                   	push   %ebx
  8047c0:	83 ec 1c             	sub    $0x1c,%esp
  8047c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8047c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047db:	89 f3                	mov    %esi,%ebx
  8047dd:	89 fa                	mov    %edi,%edx
  8047df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047e3:	89 34 24             	mov    %esi,(%esp)
  8047e6:	85 c0                	test   %eax,%eax
  8047e8:	75 1a                	jne    804804 <__umoddi3+0x48>
  8047ea:	39 f7                	cmp    %esi,%edi
  8047ec:	0f 86 a2 00 00 00    	jbe    804894 <__umoddi3+0xd8>
  8047f2:	89 c8                	mov    %ecx,%eax
  8047f4:	89 f2                	mov    %esi,%edx
  8047f6:	f7 f7                	div    %edi
  8047f8:	89 d0                	mov    %edx,%eax
  8047fa:	31 d2                	xor    %edx,%edx
  8047fc:	83 c4 1c             	add    $0x1c,%esp
  8047ff:	5b                   	pop    %ebx
  804800:	5e                   	pop    %esi
  804801:	5f                   	pop    %edi
  804802:	5d                   	pop    %ebp
  804803:	c3                   	ret    
  804804:	39 f0                	cmp    %esi,%eax
  804806:	0f 87 ac 00 00 00    	ja     8048b8 <__umoddi3+0xfc>
  80480c:	0f bd e8             	bsr    %eax,%ebp
  80480f:	83 f5 1f             	xor    $0x1f,%ebp
  804812:	0f 84 ac 00 00 00    	je     8048c4 <__umoddi3+0x108>
  804818:	bf 20 00 00 00       	mov    $0x20,%edi
  80481d:	29 ef                	sub    %ebp,%edi
  80481f:	89 fe                	mov    %edi,%esi
  804821:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804825:	89 e9                	mov    %ebp,%ecx
  804827:	d3 e0                	shl    %cl,%eax
  804829:	89 d7                	mov    %edx,%edi
  80482b:	89 f1                	mov    %esi,%ecx
  80482d:	d3 ef                	shr    %cl,%edi
  80482f:	09 c7                	or     %eax,%edi
  804831:	89 e9                	mov    %ebp,%ecx
  804833:	d3 e2                	shl    %cl,%edx
  804835:	89 14 24             	mov    %edx,(%esp)
  804838:	89 d8                	mov    %ebx,%eax
  80483a:	d3 e0                	shl    %cl,%eax
  80483c:	89 c2                	mov    %eax,%edx
  80483e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804842:	d3 e0                	shl    %cl,%eax
  804844:	89 44 24 04          	mov    %eax,0x4(%esp)
  804848:	8b 44 24 08          	mov    0x8(%esp),%eax
  80484c:	89 f1                	mov    %esi,%ecx
  80484e:	d3 e8                	shr    %cl,%eax
  804850:	09 d0                	or     %edx,%eax
  804852:	d3 eb                	shr    %cl,%ebx
  804854:	89 da                	mov    %ebx,%edx
  804856:	f7 f7                	div    %edi
  804858:	89 d3                	mov    %edx,%ebx
  80485a:	f7 24 24             	mull   (%esp)
  80485d:	89 c6                	mov    %eax,%esi
  80485f:	89 d1                	mov    %edx,%ecx
  804861:	39 d3                	cmp    %edx,%ebx
  804863:	0f 82 87 00 00 00    	jb     8048f0 <__umoddi3+0x134>
  804869:	0f 84 91 00 00 00    	je     804900 <__umoddi3+0x144>
  80486f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804873:	29 f2                	sub    %esi,%edx
  804875:	19 cb                	sbb    %ecx,%ebx
  804877:	89 d8                	mov    %ebx,%eax
  804879:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80487d:	d3 e0                	shl    %cl,%eax
  80487f:	89 e9                	mov    %ebp,%ecx
  804881:	d3 ea                	shr    %cl,%edx
  804883:	09 d0                	or     %edx,%eax
  804885:	89 e9                	mov    %ebp,%ecx
  804887:	d3 eb                	shr    %cl,%ebx
  804889:	89 da                	mov    %ebx,%edx
  80488b:	83 c4 1c             	add    $0x1c,%esp
  80488e:	5b                   	pop    %ebx
  80488f:	5e                   	pop    %esi
  804890:	5f                   	pop    %edi
  804891:	5d                   	pop    %ebp
  804892:	c3                   	ret    
  804893:	90                   	nop
  804894:	89 fd                	mov    %edi,%ebp
  804896:	85 ff                	test   %edi,%edi
  804898:	75 0b                	jne    8048a5 <__umoddi3+0xe9>
  80489a:	b8 01 00 00 00       	mov    $0x1,%eax
  80489f:	31 d2                	xor    %edx,%edx
  8048a1:	f7 f7                	div    %edi
  8048a3:	89 c5                	mov    %eax,%ebp
  8048a5:	89 f0                	mov    %esi,%eax
  8048a7:	31 d2                	xor    %edx,%edx
  8048a9:	f7 f5                	div    %ebp
  8048ab:	89 c8                	mov    %ecx,%eax
  8048ad:	f7 f5                	div    %ebp
  8048af:	89 d0                	mov    %edx,%eax
  8048b1:	e9 44 ff ff ff       	jmp    8047fa <__umoddi3+0x3e>
  8048b6:	66 90                	xchg   %ax,%ax
  8048b8:	89 c8                	mov    %ecx,%eax
  8048ba:	89 f2                	mov    %esi,%edx
  8048bc:	83 c4 1c             	add    $0x1c,%esp
  8048bf:	5b                   	pop    %ebx
  8048c0:	5e                   	pop    %esi
  8048c1:	5f                   	pop    %edi
  8048c2:	5d                   	pop    %ebp
  8048c3:	c3                   	ret    
  8048c4:	3b 04 24             	cmp    (%esp),%eax
  8048c7:	72 06                	jb     8048cf <__umoddi3+0x113>
  8048c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048cd:	77 0f                	ja     8048de <__umoddi3+0x122>
  8048cf:	89 f2                	mov    %esi,%edx
  8048d1:	29 f9                	sub    %edi,%ecx
  8048d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048d7:	89 14 24             	mov    %edx,(%esp)
  8048da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048e2:	8b 14 24             	mov    (%esp),%edx
  8048e5:	83 c4 1c             	add    $0x1c,%esp
  8048e8:	5b                   	pop    %ebx
  8048e9:	5e                   	pop    %esi
  8048ea:	5f                   	pop    %edi
  8048eb:	5d                   	pop    %ebp
  8048ec:	c3                   	ret    
  8048ed:	8d 76 00             	lea    0x0(%esi),%esi
  8048f0:	2b 04 24             	sub    (%esp),%eax
  8048f3:	19 fa                	sbb    %edi,%edx
  8048f5:	89 d1                	mov    %edx,%ecx
  8048f7:	89 c6                	mov    %eax,%esi
  8048f9:	e9 71 ff ff ff       	jmp    80486f <__umoddi3+0xb3>
  8048fe:	66 90                	xchg   %ax,%ax
  804900:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804904:	72 ea                	jb     8048f0 <__umoddi3+0x134>
  804906:	89 d9                	mov    %ebx,%ecx
  804908:	e9 62 ff ff ff       	jmp    80486f <__umoddi3+0xb3>
