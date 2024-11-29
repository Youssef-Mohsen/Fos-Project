
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
  800055:	68 40 4a 80 00       	push   $0x804a40
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
  8000a5:	68 70 4a 80 00       	push   $0x804a70
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
  8000d1:	e8 50 2b 00 00       	call   802c26 <sys_set_uheap_strategy>
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
  8000f6:	68 a9 4a 80 00       	push   $0x804aa9
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 c5 4a 80 00       	push   $0x804ac5
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
  800123:	e8 4b 27 00 00       	call   802873 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 f8 26 00 00       	call   802828 <sys_calculate_free_frames>
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
  80013d:	68 d8 4a 80 00       	push   $0x804ad8
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
  8002ac:	68 30 4b 80 00       	push   $0x804b30
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 c5 4a 80 00       	push   $0x804ac5
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
  80031b:	68 58 4b 80 00       	push   $0x804b58
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 2f 2a 00 00       	call   802d68 <alloc_block>
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
  80037f:	68 7c 4b 80 00       	push   $0x804b7c
  800384:	6a 7f                	push   $0x7f
  800386:	68 c5 4a 80 00       	push   $0x804ac5
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 93 24 00 00       	call   802828 <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 a4 4b 80 00       	push   $0x804ba4
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
  800443:	68 ec 4b 80 00       	push   $0x804bec
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
  80049a:	68 0c 4c 80 00       	push   $0x804c0c
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
  8004ee:	68 2c 4c 80 00       	push   $0x804c2c
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
  800538:	68 5c 4c 80 00       	push   $0x804c5c
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
  800552:	68 7c 4c 80 00       	push   $0x804c7c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 b7 4c 80 00       	push   $0x804cb7
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
  8005e0:	68 cc 4c 80 00       	push   $0x804ccc
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 eb 4c 80 00       	push   $0x804ceb
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
  800669:	68 04 4d 80 00       	push   $0x804d04
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
  800683:	68 24 4d 80 00       	push   $0x804d24
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 5b 4d 80 00       	push   $0x804d5b
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
  800711:	68 70 4d 80 00       	push   $0x804d70
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 8f 4d 80 00       	push   $0x804d8f
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
  800762:	e8 ca 25 00 00       	call   802d31 <get_block_size>
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
  8007b7:	68 a8 4d 80 00       	push   $0x804da8
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
  8007d1:	68 c8 4d 80 00       	push   $0x804dc8
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
  80083d:	e8 ef 24 00 00       	call   802d31 <get_block_size>
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
  80089b:	68 05 4e 80 00       	push   $0x804e05
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
  8008b5:	68 24 4e 80 00       	push   $0x804e24
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 64 4e 80 00       	push   $0x804e64
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 89 4e 80 00       	push   $0x804e89
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
  800963:	68 a0 4e 80 00       	push   $0x804ea0
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 d0 4e 80 00       	push   $0x804ed0
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
  8009fa:	68 fc 4e 80 00       	push   $0x804efc
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 2c 4f 80 00       	push   $0x804f2c
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
  800a68:	68 6c 4f 80 00       	push   $0x804f6c
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
  800a82:	68 9c 4f 80 00       	push   $0x804f9c
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
  800b11:	68 c8 4f 80 00       	push   $0x804fc8
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
  800b2b:	68 f8 4f 80 00       	push   $0x804ff8
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 20 50 80 00       	push   $0x805020
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
  800bca:	68 40 50 80 00       	push   $0x805040
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
  800c3d:	68 70 50 80 00       	push   $0x805070
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
  800ca4:	e8 4e 21 00 00       	call   802df7 <print_blocks_list>
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
  800ce6:	68 88 50 80 00       	push   $0x805088
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 b8 50 80 00       	push   $0x8050b8
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
  800d83:	68 f0 50 80 00       	push   $0x8050f0
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
  800d9d:	68 20 51 80 00       	push   $0x805120
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 72 1a 00 00       	call   802828 <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 64 51 80 00       	push   $0x805164
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
  800e7a:	68 d0 51 80 00       	push   $0x8051d0
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
  800efe:	e8 80 1d 00 00       	call   802c83 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 0c 52 80 00       	push   $0x80520c
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
  800f3c:	68 50 52 80 00       	push   $0x805250
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
  800f58:	e8 94 1a 00 00       	call   8029f1 <sys_getenvindex>
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
  800fc6:	e8 aa 17 00 00       	call   802775 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 b8 52 80 00       	push   $0x8052b8
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
  800ff6:	68 e0 52 80 00       	push   $0x8052e0
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
  801027:	68 08 53 80 00       	push   $0x805308
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 60 53 80 00       	push   $0x805360
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 b8 52 80 00       	push   $0x8052b8
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 2a 17 00 00       	call   80278f <sys_unlock_cons>
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
  801078:	e8 40 19 00 00       	call   8029bd <sys_destroy_env>
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
  801089:	e8 95 19 00 00       	call   802a23 <sys_exit_env>
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
  8010b2:	68 74 53 80 00       	push   $0x805374
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 79 53 80 00       	push   $0x805379
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
  8010ef:	68 95 53 80 00       	push   $0x805395
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
  80111e:	68 98 53 80 00       	push   $0x805398
  801123:	6a 26                	push   $0x26
  801125:	68 e4 53 80 00       	push   $0x8053e4
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
  8011f3:	68 f0 53 80 00       	push   $0x8053f0
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 e4 53 80 00       	push   $0x8053e4
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
  801266:	68 44 54 80 00       	push   $0x805444
  80126b:	6a 44                	push   $0x44
  80126d:	68 e4 53 80 00       	push   $0x8053e4
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
  8012c0:	e8 6e 14 00 00       	call   802733 <sys_cputs>
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
  801337:	e8 f7 13 00 00       	call   802733 <sys_cputs>
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
  801381:	e8 ef 13 00 00       	call   802775 <sys_lock_cons>
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
  8013a1:	e8 e9 13 00 00       	call   80278f <sys_unlock_cons>
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
  8013eb:	e8 dc 33 00 00       	call   8047cc <__udivdi3>
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
  80143b:	e8 9c 34 00 00       	call   8048dc <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 b4 56 80 00       	add    $0x8056b4,%eax
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
  801596:	8b 04 85 d8 56 80 00 	mov    0x8056d8(,%eax,4),%eax
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
  801677:	8b 34 9d 20 55 80 00 	mov    0x805520(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 c5 56 80 00       	push   $0x8056c5
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
  80169c:	68 ce 56 80 00       	push   $0x8056ce
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
  8016c9:	be d1 56 80 00       	mov    $0x8056d1,%esi
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
  8020d4:	68 48 58 80 00       	push   $0x805848
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 6a 58 80 00       	push   $0x80586a
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
  8020f4:	e8 e5 0b 00 00       	call   802cde <sys_sbrk>
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
  80216f:	e8 ee 09 00 00       	call   802b62 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 2e 0f 00 00       	call   8030b1 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 00 0a 00 00       	call   802b93 <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 c7 13 00 00       	call   80356d <alloc_block_BF>
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
  8021f1:	8b 04 85 60 e2 08 01 	mov    0x108e260(,%eax,4),%eax
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
  80223e:	8b 04 85 60 e2 08 01 	mov    0x108e260(,%eax,4),%eax
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
  802295:	c7 04 85 60 e2 08 01 	movl   $0x1,0x108e260(,%eax,4)
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
  8022f7:	89 04 95 60 e2 10 01 	mov    %eax,0x110e260(,%edx,4)
		sys_allocate_user_mem(i, size);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	ff 75 f0             	pushl  -0x10(%ebp)
  802307:	e8 09 0a 00 00       	call   802d15 <sys_allocate_user_mem>
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
  80234f:	e8 dd 09 00 00       	call   802d31 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 10 1c 00 00       	call   803f75 <free_block>
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
  80239a:	8b 04 85 60 e2 10 01 	mov    0x110e260(,%eax,4),%eax
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
  8023d7:	c7 04 85 60 e2 08 01 	movl   $0x0,0x108e260(,%eax,4)
  8023de:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8023e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	83 ec 08             	sub    $0x8,%esp
  8023eb:	52                   	push   %edx
  8023ec:	50                   	push   %eax
  8023ed:	e8 07 09 00 00       	call   802cf9 <sys_free_user_mem>
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
  802405:	68 78 58 80 00       	push   $0x805878
  80240a:	68 88 00 00 00       	push   $0x88
  80240f:	68 a2 58 80 00       	push   $0x8058a2
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
  802433:	e9 ec 00 00 00       	jmp    802524 <smalloc+0x108>
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
  802464:	75 0a                	jne    802470 <smalloc+0x54>
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
  80246b:	e9 b4 00 00 00       	jmp    802524 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802470:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802474:	ff 75 ec             	pushl  -0x14(%ebp)
  802477:	50                   	push   %eax
  802478:	ff 75 0c             	pushl  0xc(%ebp)
  80247b:	ff 75 08             	pushl  0x8(%ebp)
  80247e:	e8 7d 04 00 00       	call   802900 <sys_createSharedObject>
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802489:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80248d:	74 06                	je     802495 <smalloc+0x79>
  80248f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802493:	75 0a                	jne    80249f <smalloc+0x83>
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	e9 85 00 00 00       	jmp    802524 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80249f:	83 ec 08             	sub    $0x8,%esp
  8024a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8024a5:	68 ae 58 80 00       	push   $0x8058ae
  8024aa:	e8 9f ee ff ff       	call   80134e <cprintf>
  8024af:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8024b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8024ba:	8b 40 78             	mov    0x78(%eax),%eax
  8024bd:	29 c2                	sub    %eax,%edx
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024c6:	c1 e8 0c             	shr    $0xc,%eax
  8024c9:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8024cf:	42                   	inc    %edx
  8024d0:	89 15 24 60 80 00    	mov    %edx,0x806024
  8024d6:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8024dc:	89 14 85 60 e2 00 01 	mov    %edx,0x100e260(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8024e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e6:	a1 20 60 80 00       	mov    0x806020,%eax
  8024eb:	8b 40 78             	mov    0x78(%eax),%eax
  8024ee:	29 c2                	sub    %eax,%edx
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024f7:	c1 e8 0c             	shr    $0xc,%eax
  8024fa:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  802501:	a1 20 60 80 00       	mov    0x806020,%eax
  802506:	8b 50 10             	mov    0x10(%eax),%edx
  802509:	89 c8                	mov    %ecx,%eax
  80250b:	c1 e0 02             	shl    $0x2,%eax
  80250e:	89 c1                	mov    %eax,%ecx
  802510:	c1 e1 09             	shl    $0x9,%ecx
  802513:	01 c8                	add    %ecx,%eax
  802515:	01 c2                	add    %eax,%edx
  802517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251a:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  802521:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80252c:	83 ec 08             	sub    $0x8,%esp
  80252f:	ff 75 0c             	pushl  0xc(%ebp)
  802532:	ff 75 08             	pushl  0x8(%ebp)
  802535:	e8 f0 03 00 00       	call   80292a <sys_getSizeOfSharedObject>
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802540:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802544:	75 0a                	jne    802550 <sget+0x2a>
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	e9 e7 00 00 00       	jmp    802637 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802556:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80255d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802563:	39 d0                	cmp    %edx,%eax
  802565:	73 02                	jae    802569 <sget+0x43>
  802567:	89 d0                	mov    %edx,%eax
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	50                   	push   %eax
  80256d:	e8 8c fb ff ff       	call   8020fe <malloc>
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802578:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80257c:	75 0a                	jne    802588 <sget+0x62>
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	e9 af 00 00 00       	jmp    802637 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	ff 75 e8             	pushl  -0x18(%ebp)
  80258e:	ff 75 0c             	pushl  0xc(%ebp)
  802591:	ff 75 08             	pushl  0x8(%ebp)
  802594:	e8 ae 03 00 00       	call   802947 <sys_getSharedObject>
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80259f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8025a7:	8b 40 78             	mov    0x78(%eax),%eax
  8025aa:	29 c2                	sub    %eax,%edx
  8025ac:	89 d0                	mov    %edx,%eax
  8025ae:	2d 00 10 00 00       	sub    $0x1000,%eax
  8025b3:	c1 e8 0c             	shr    $0xc,%eax
  8025b6:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8025bc:	42                   	inc    %edx
  8025bd:	89 15 24 60 80 00    	mov    %edx,0x806024
  8025c3:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8025c9:	89 14 85 60 e2 00 01 	mov    %edx,0x100e260(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8025d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8025d8:	8b 40 78             	mov    0x78(%eax),%eax
  8025db:	29 c2                	sub    %eax,%edx
  8025dd:	89 d0                	mov    %edx,%eax
  8025df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8025e4:	c1 e8 0c             	shr    $0xc,%eax
  8025e7:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  8025ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8025f3:	8b 50 10             	mov    0x10(%eax),%edx
  8025f6:	89 c8                	mov    %ecx,%eax
  8025f8:	c1 e0 02             	shl    $0x2,%eax
  8025fb:	89 c1                	mov    %eax,%ecx
  8025fd:	c1 e1 09             	shl    $0x9,%ecx
  802600:	01 c8                	add    %ecx,%eax
  802602:	01 c2                	add    %eax,%edx
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802607:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80260e:	a1 20 60 80 00       	mov    0x806020,%eax
  802613:	8b 40 10             	mov    0x10(%eax),%eax
  802616:	83 ec 08             	sub    $0x8,%esp
  802619:	50                   	push   %eax
  80261a:	68 bd 58 80 00       	push   $0x8058bd
  80261f:	e8 2a ed ff ff       	call   80134e <cprintf>
  802624:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802627:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80262b:	75 07                	jne    802634 <sget+0x10e>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	eb 03                	jmp    802637 <sget+0x111>
	return ptr;
  802634:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80263f:	8b 55 08             	mov    0x8(%ebp),%edx
  802642:	a1 20 60 80 00       	mov    0x806020,%eax
  802647:	8b 40 78             	mov    0x78(%eax),%eax
  80264a:	29 c2                	sub    %eax,%edx
  80264c:	89 d0                	mov    %edx,%eax
  80264e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802653:	c1 e8 0c             	shr    $0xc,%eax
  802656:	8b 0c 85 60 e2 00 01 	mov    0x100e260(,%eax,4),%ecx
  80265d:	a1 20 60 80 00       	mov    0x806020,%eax
  802662:	8b 50 10             	mov    0x10(%eax),%edx
  802665:	89 c8                	mov    %ecx,%eax
  802667:	c1 e0 02             	shl    $0x2,%eax
  80266a:	89 c1                	mov    %eax,%ecx
  80266c:	c1 e1 09             	shl    $0x9,%ecx
  80266f:	01 c8                	add    %ecx,%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  80267a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80267d:	83 ec 08             	sub    $0x8,%esp
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	ff 75 f4             	pushl  -0xc(%ebp)
  802686:	e8 db 02 00 00       	call   802966 <sys_freeSharedObject>
  80268b:	83 c4 10             	add    $0x10,%esp
  80268e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802691:	90                   	nop
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 cc 58 80 00       	push   $0x8058cc
  8026a2:	68 e5 00 00 00       	push   $0xe5
  8026a7:	68 a2 58 80 00       	push   $0x8058a2
  8026ac:	e8 e0 e9 ff ff       	call   801091 <_panic>

008026b1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 f2 58 80 00       	push   $0x8058f2
  8026bf:	68 f1 00 00 00       	push   $0xf1
  8026c4:	68 a2 58 80 00       	push   $0x8058a2
  8026c9:	e8 c3 e9 ff ff       	call   801091 <_panic>

008026ce <shrink>:

}
void shrink(uint32 newSize)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 f2 58 80 00       	push   $0x8058f2
  8026dc:	68 f6 00 00 00       	push   $0xf6
  8026e1:	68 a2 58 80 00       	push   $0x8058a2
  8026e6:	e8 a6 e9 ff ff       	call   801091 <_panic>

008026eb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	68 f2 58 80 00       	push   $0x8058f2
  8026f9:	68 fb 00 00 00       	push   $0xfb
  8026fe:	68 a2 58 80 00       	push   $0x8058a2
  802703:	e8 89 e9 ff ff       	call   801091 <_panic>

00802708 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	57                   	push   %edi
  80270c:	56                   	push   %esi
  80270d:	53                   	push   %ebx
  80270e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	8b 55 0c             	mov    0xc(%ebp),%edx
  802717:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80271a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80271d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802720:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802723:	cd 30                	int    $0x30
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802728:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80272b:	83 c4 10             	add    $0x10,%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    

00802733 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	8b 45 10             	mov    0x10(%ebp),%eax
  80273c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80273f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	52                   	push   %edx
  80274b:	ff 75 0c             	pushl  0xc(%ebp)
  80274e:	50                   	push   %eax
  80274f:	6a 00                	push   $0x0
  802751:	e8 b2 ff ff ff       	call   802708 <syscall>
  802756:	83 c4 18             	add    $0x18,%esp
}
  802759:	90                   	nop
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <sys_cgetc>:

int
sys_cgetc(void)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 02                	push   $0x2
  80276b:	e8 98 ff ff ff       	call   802708 <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 03                	push   $0x3
  802784:	e8 7f ff ff ff       	call   802708 <syscall>
  802789:	83 c4 18             	add    $0x18,%esp
}
  80278c:	90                   	nop
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 04                	push   $0x4
  80279e:	e8 65 ff ff ff       	call   802708 <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
}
  8027a6:	90                   	nop
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	52                   	push   %edx
  8027b9:	50                   	push   %eax
  8027ba:	6a 08                	push   $0x8
  8027bc:	e8 47 ff ff ff       	call   802708 <syscall>
  8027c1:	83 c4 18             	add    $0x18,%esp
}
  8027c4:	c9                   	leave  
  8027c5:	c3                   	ret    

008027c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027c6:	55                   	push   %ebp
  8027c7:	89 e5                	mov    %esp,%ebp
  8027c9:	56                   	push   %esi
  8027ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8027ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	56                   	push   %esi
  8027db:	53                   	push   %ebx
  8027dc:	51                   	push   %ecx
  8027dd:	52                   	push   %edx
  8027de:	50                   	push   %eax
  8027df:	6a 09                	push   $0x9
  8027e1:	e8 22 ff ff ff       	call   802708 <syscall>
  8027e6:	83 c4 18             	add    $0x18,%esp
}
  8027e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    

008027f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8027f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	52                   	push   %edx
  802800:	50                   	push   %eax
  802801:	6a 0a                	push   $0xa
  802803:	e8 00 ff ff ff       	call   802708 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
}
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	ff 75 0c             	pushl  0xc(%ebp)
  802819:	ff 75 08             	pushl  0x8(%ebp)
  80281c:	6a 0b                	push   $0xb
  80281e:	e8 e5 fe ff ff       	call   802708 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 0c                	push   $0xc
  802837:	e8 cc fe ff ff       	call   802708 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 0d                	push   $0xd
  802850:	e8 b3 fe ff ff       	call   802708 <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 0e                	push   $0xe
  802869:	e8 9a fe ff ff       	call   802708 <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 0f                	push   $0xf
  802882:	e8 81 fe ff ff       	call   802708 <syscall>
  802887:	83 c4 18             	add    $0x18,%esp
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	ff 75 08             	pushl  0x8(%ebp)
  80289a:	6a 10                	push   $0x10
  80289c:	e8 67 fe ff ff       	call   802708 <syscall>
  8028a1:	83 c4 18             	add    $0x18,%esp
}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 11                	push   $0x11
  8028b5:	e8 4e fe ff ff       	call   802708 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
}
  8028bd:	90                   	nop
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	50                   	push   %eax
  8028d9:	6a 01                	push   $0x1
  8028db:	e8 28 fe ff ff       	call   802708 <syscall>
  8028e0:	83 c4 18             	add    $0x18,%esp
}
  8028e3:	90                   	nop
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 14                	push   $0x14
  8028f5:	e8 0e fe ff ff       	call   802708 <syscall>
  8028fa:	83 c4 18             	add    $0x18,%esp
}
  8028fd:	90                   	nop
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	8b 45 10             	mov    0x10(%ebp),%eax
  802909:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80290c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80290f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	6a 00                	push   $0x0
  802918:	51                   	push   %ecx
  802919:	52                   	push   %edx
  80291a:	ff 75 0c             	pushl  0xc(%ebp)
  80291d:	50                   	push   %eax
  80291e:	6a 15                	push   $0x15
  802920:	e8 e3 fd ff ff       	call   802708 <syscall>
  802925:	83 c4 18             	add    $0x18,%esp
}
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80292d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	52                   	push   %edx
  80293a:	50                   	push   %eax
  80293b:	6a 16                	push   $0x16
  80293d:	e8 c6 fd ff ff       	call   802708 <syscall>
  802942:	83 c4 18             	add    $0x18,%esp
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80294a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80294d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	51                   	push   %ecx
  802958:	52                   	push   %edx
  802959:	50                   	push   %eax
  80295a:	6a 17                	push   $0x17
  80295c:	e8 a7 fd ff ff       	call   802708 <syscall>
  802961:	83 c4 18             	add    $0x18,%esp
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	52                   	push   %edx
  802976:	50                   	push   %eax
  802977:	6a 18                	push   $0x18
  802979:	e8 8a fd ff ff       	call   802708 <syscall>
  80297e:	83 c4 18             	add    $0x18,%esp
}
  802981:	c9                   	leave  
  802982:	c3                   	ret    

00802983 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802983:	55                   	push   %ebp
  802984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	6a 00                	push   $0x0
  80298b:	ff 75 14             	pushl  0x14(%ebp)
  80298e:	ff 75 10             	pushl  0x10(%ebp)
  802991:	ff 75 0c             	pushl  0xc(%ebp)
  802994:	50                   	push   %eax
  802995:	6a 19                	push   $0x19
  802997:	e8 6c fd ff ff       	call   802708 <syscall>
  80299c:	83 c4 18             	add    $0x18,%esp
}
  80299f:	c9                   	leave  
  8029a0:	c3                   	ret    

008029a1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	50                   	push   %eax
  8029b0:	6a 1a                	push   $0x1a
  8029b2:	e8 51 fd ff ff       	call   802708 <syscall>
  8029b7:	83 c4 18             	add    $0x18,%esp
}
  8029ba:	90                   	nop
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	50                   	push   %eax
  8029cc:	6a 1b                	push   $0x1b
  8029ce:	e8 35 fd ff ff       	call   802708 <syscall>
  8029d3:	83 c4 18             	add    $0x18,%esp
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 05                	push   $0x5
  8029e7:	e8 1c fd ff ff       	call   802708 <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 06                	push   $0x6
  802a00:	e8 03 fd ff ff       	call   802708 <syscall>
  802a05:	83 c4 18             	add    $0x18,%esp
}
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 07                	push   $0x7
  802a19:	e8 ea fc ff ff       	call   802708 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_exit_env>:


void sys_exit_env(void)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 1c                	push   $0x1c
  802a32:	e8 d1 fc ff ff       	call   802708 <syscall>
  802a37:	83 c4 18             	add    $0x18,%esp
}
  802a3a:	90                   	nop
  802a3b:	c9                   	leave  
  802a3c:	c3                   	ret    

00802a3d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
  802a40:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a46:	8d 50 04             	lea    0x4(%eax),%edx
  802a49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	52                   	push   %edx
  802a53:	50                   	push   %eax
  802a54:	6a 1d                	push   $0x1d
  802a56:	e8 ad fc ff ff       	call   802708 <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
	return result;
  802a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a67:	89 01                	mov    %eax,(%ecx)
  802a69:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	c9                   	leave  
  802a70:	c2 04 00             	ret    $0x4

00802a73 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	ff 75 10             	pushl  0x10(%ebp)
  802a7d:	ff 75 0c             	pushl  0xc(%ebp)
  802a80:	ff 75 08             	pushl  0x8(%ebp)
  802a83:	6a 13                	push   $0x13
  802a85:	e8 7e fc ff ff       	call   802708 <syscall>
  802a8a:	83 c4 18             	add    $0x18,%esp
	return ;
  802a8d:	90                   	nop
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 1e                	push   $0x1e
  802a9f:	e8 64 fc ff ff       	call   802708 <syscall>
  802aa4:	83 c4 18             	add    $0x18,%esp
}
  802aa7:	c9                   	leave  
  802aa8:	c3                   	ret    

00802aa9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ab5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	50                   	push   %eax
  802ac2:	6a 1f                	push   $0x1f
  802ac4:	e8 3f fc ff ff       	call   802708 <syscall>
  802ac9:	83 c4 18             	add    $0x18,%esp
	return ;
  802acc:	90                   	nop
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <rsttst>:
void rsttst()
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 00                	push   $0x0
  802adc:	6a 21                	push   $0x21
  802ade:	e8 25 fc ff ff       	call   802708 <syscall>
  802ae3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae6:	90                   	nop
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	8b 45 14             	mov    0x14(%ebp),%eax
  802af2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802af5:	8b 55 18             	mov    0x18(%ebp),%edx
  802af8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802afc:	52                   	push   %edx
  802afd:	50                   	push   %eax
  802afe:	ff 75 10             	pushl  0x10(%ebp)
  802b01:	ff 75 0c             	pushl  0xc(%ebp)
  802b04:	ff 75 08             	pushl  0x8(%ebp)
  802b07:	6a 20                	push   $0x20
  802b09:	e8 fa fb ff ff       	call   802708 <syscall>
  802b0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b11:	90                   	nop
}
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <chktst>:
void chktst(uint32 n)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	ff 75 08             	pushl  0x8(%ebp)
  802b22:	6a 22                	push   $0x22
  802b24:	e8 df fb ff ff       	call   802708 <syscall>
  802b29:	83 c4 18             	add    $0x18,%esp
	return ;
  802b2c:	90                   	nop
}
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <inctst>:

void inctst()
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 23                	push   $0x23
  802b3e:	e8 c5 fb ff ff       	call   802708 <syscall>
  802b43:	83 c4 18             	add    $0x18,%esp
	return ;
  802b46:	90                   	nop
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <gettst>:
uint32 gettst()
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 24                	push   $0x24
  802b58:	e8 ab fb ff ff       	call   802708 <syscall>
  802b5d:	83 c4 18             	add    $0x18,%esp
}
  802b60:	c9                   	leave  
  802b61:	c3                   	ret    

00802b62 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b62:	55                   	push   %ebp
  802b63:	89 e5                	mov    %esp,%ebp
  802b65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 25                	push   $0x25
  802b74:	e8 8f fb ff ff       	call   802708 <syscall>
  802b79:	83 c4 18             	add    $0x18,%esp
  802b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b7f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b83:	75 07                	jne    802b8c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b85:	b8 01 00 00 00       	mov    $0x1,%eax
  802b8a:	eb 05                	jmp    802b91 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b91:	c9                   	leave  
  802b92:	c3                   	ret    

00802b93 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
  802b96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 25                	push   $0x25
  802ba5:	e8 5e fb ff ff       	call   802708 <syscall>
  802baa:	83 c4 18             	add    $0x18,%esp
  802bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bb0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bb4:	75 07                	jne    802bbd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbb:	eb 05                	jmp    802bc2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc2:	c9                   	leave  
  802bc3:	c3                   	ret    

00802bc4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bc4:	55                   	push   %ebp
  802bc5:	89 e5                	mov    %esp,%ebp
  802bc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 25                	push   $0x25
  802bd6:	e8 2d fb ff ff       	call   802708 <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
  802bde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802be1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802be5:	75 07                	jne    802bee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802be7:	b8 01 00 00 00       	mov    $0x1,%eax
  802bec:	eb 05                	jmp    802bf3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf3:	c9                   	leave  
  802bf4:	c3                   	ret    

00802bf5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
  802bf8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 25                	push   $0x25
  802c07:	e8 fc fa ff ff       	call   802708 <syscall>
  802c0c:	83 c4 18             	add    $0x18,%esp
  802c0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c12:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c16:	75 07                	jne    802c1f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c18:	b8 01 00 00 00       	mov    $0x1,%eax
  802c1d:	eb 05                	jmp    802c24 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c24:	c9                   	leave  
  802c25:	c3                   	ret    

00802c26 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	ff 75 08             	pushl  0x8(%ebp)
  802c34:	6a 26                	push   $0x26
  802c36:	e8 cd fa ff ff       	call   802708 <syscall>
  802c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c3e:	90                   	nop
}
  802c3f:	c9                   	leave  
  802c40:	c3                   	ret    

00802c41 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c41:	55                   	push   %ebp
  802c42:	89 e5                	mov    %esp,%ebp
  802c44:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	6a 00                	push   $0x0
  802c53:	53                   	push   %ebx
  802c54:	51                   	push   %ecx
  802c55:	52                   	push   %edx
  802c56:	50                   	push   %eax
  802c57:	6a 27                	push   $0x27
  802c59:	e8 aa fa ff ff       	call   802708 <syscall>
  802c5e:	83 c4 18             	add    $0x18,%esp
}
  802c61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	52                   	push   %edx
  802c76:	50                   	push   %eax
  802c77:	6a 28                	push   $0x28
  802c79:	e8 8a fa ff ff       	call   802708 <syscall>
  802c7e:	83 c4 18             	add    $0x18,%esp
}
  802c81:	c9                   	leave  
  802c82:	c3                   	ret    

00802c83 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802c83:	55                   	push   %ebp
  802c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802c86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	6a 00                	push   $0x0
  802c91:	51                   	push   %ecx
  802c92:	ff 75 10             	pushl  0x10(%ebp)
  802c95:	52                   	push   %edx
  802c96:	50                   	push   %eax
  802c97:	6a 29                	push   $0x29
  802c99:	e8 6a fa ff ff       	call   802708 <syscall>
  802c9e:	83 c4 18             	add    $0x18,%esp
}
  802ca1:	c9                   	leave  
  802ca2:	c3                   	ret    

00802ca3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ca3:	55                   	push   %ebp
  802ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	ff 75 10             	pushl  0x10(%ebp)
  802cad:	ff 75 0c             	pushl  0xc(%ebp)
  802cb0:	ff 75 08             	pushl  0x8(%ebp)
  802cb3:	6a 12                	push   $0x12
  802cb5:	e8 4e fa ff ff       	call   802708 <syscall>
  802cba:	83 c4 18             	add    $0x18,%esp
	return ;
  802cbd:	90                   	nop
}
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

00802cc0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	52                   	push   %edx
  802cd0:	50                   	push   %eax
  802cd1:	6a 2a                	push   $0x2a
  802cd3:	e8 30 fa ff ff       	call   802708 <syscall>
  802cd8:	83 c4 18             	add    $0x18,%esp
	return;
  802cdb:	90                   	nop
}
  802cdc:	c9                   	leave  
  802cdd:	c3                   	ret    

00802cde <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	6a 00                	push   $0x0
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 00                	push   $0x0
  802cea:	6a 00                	push   $0x0
  802cec:	50                   	push   %eax
  802ced:	6a 2b                	push   $0x2b
  802cef:	e8 14 fa ff ff       	call   802708 <syscall>
  802cf4:	83 c4 18             	add    $0x18,%esp
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

00802cf9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	ff 75 0c             	pushl  0xc(%ebp)
  802d05:	ff 75 08             	pushl  0x8(%ebp)
  802d08:	6a 2c                	push   $0x2c
  802d0a:	e8 f9 f9 ff ff       	call   802708 <syscall>
  802d0f:	83 c4 18             	add    $0x18,%esp
	return;
  802d12:	90                   	nop
}
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802d18:	6a 00                	push   $0x0
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	ff 75 0c             	pushl  0xc(%ebp)
  802d21:	ff 75 08             	pushl  0x8(%ebp)
  802d24:	6a 2d                	push   $0x2d
  802d26:	e8 dd f9 ff ff       	call   802708 <syscall>
  802d2b:	83 c4 18             	add    $0x18,%esp
	return;
  802d2e:	90                   	nop
}
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
  802d34:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	83 e8 04             	sub    $0x4,%eax
  802d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
  802d4d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	83 e8 04             	sub    $0x4,%eax
  802d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	83 e0 01             	and    $0x1,%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	0f 94 c0             	sete   %al
}
  802d66:	c9                   	leave  
  802d67:	c3                   	ret    

00802d68 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d78:	83 f8 02             	cmp    $0x2,%eax
  802d7b:	74 2b                	je     802da8 <alloc_block+0x40>
  802d7d:	83 f8 02             	cmp    $0x2,%eax
  802d80:	7f 07                	jg     802d89 <alloc_block+0x21>
  802d82:	83 f8 01             	cmp    $0x1,%eax
  802d85:	74 0e                	je     802d95 <alloc_block+0x2d>
  802d87:	eb 58                	jmp    802de1 <alloc_block+0x79>
  802d89:	83 f8 03             	cmp    $0x3,%eax
  802d8c:	74 2d                	je     802dbb <alloc_block+0x53>
  802d8e:	83 f8 04             	cmp    $0x4,%eax
  802d91:	74 3b                	je     802dce <alloc_block+0x66>
  802d93:	eb 4c                	jmp    802de1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 08             	pushl  0x8(%ebp)
  802d9b:	e8 11 03 00 00       	call   8030b1 <alloc_block_FF>
  802da0:	83 c4 10             	add    $0x10,%esp
  802da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802da6:	eb 4a                	jmp    802df2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802da8:	83 ec 0c             	sub    $0xc,%esp
  802dab:	ff 75 08             	pushl  0x8(%ebp)
  802dae:	e8 fa 19 00 00       	call   8047ad <alloc_block_NF>
  802db3:	83 c4 10             	add    $0x10,%esp
  802db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802db9:	eb 37                	jmp    802df2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	ff 75 08             	pushl  0x8(%ebp)
  802dc1:	e8 a7 07 00 00       	call   80356d <alloc_block_BF>
  802dc6:	83 c4 10             	add    $0x10,%esp
  802dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dcc:	eb 24                	jmp    802df2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802dce:	83 ec 0c             	sub    $0xc,%esp
  802dd1:	ff 75 08             	pushl  0x8(%ebp)
  802dd4:	e8 b7 19 00 00       	call   804790 <alloc_block_WF>
  802dd9:	83 c4 10             	add    $0x10,%esp
  802ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ddf:	eb 11                	jmp    802df2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802de1:	83 ec 0c             	sub    $0xc,%esp
  802de4:	68 04 59 80 00       	push   $0x805904
  802de9:	e8 60 e5 ff ff       	call   80134e <cprintf>
  802dee:	83 c4 10             	add    $0x10,%esp
		break;
  802df1:	90                   	nop
	}
	return va;
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802df5:	c9                   	leave  
  802df6:	c3                   	ret    

00802df7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802df7:	55                   	push   %ebp
  802df8:	89 e5                	mov    %esp,%ebp
  802dfa:	53                   	push   %ebx
  802dfb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802dfe:	83 ec 0c             	sub    $0xc,%esp
  802e01:	68 24 59 80 00       	push   $0x805924
  802e06:	e8 43 e5 ff ff       	call   80134e <cprintf>
  802e0b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802e0e:	83 ec 0c             	sub    $0xc,%esp
  802e11:	68 4f 59 80 00       	push   $0x80594f
  802e16:	e8 33 e5 ff ff       	call   80134e <cprintf>
  802e1b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e24:	eb 37                	jmp    802e5d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802e26:	83 ec 0c             	sub    $0xc,%esp
  802e29:	ff 75 f4             	pushl  -0xc(%ebp)
  802e2c:	e8 19 ff ff ff       	call   802d4a <is_free_block>
  802e31:	83 c4 10             	add    $0x10,%esp
  802e34:	0f be d8             	movsbl %al,%ebx
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802e3d:	e8 ef fe ff ff       	call   802d31 <get_block_size>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	53                   	push   %ebx
  802e49:	50                   	push   %eax
  802e4a:	68 67 59 80 00       	push   $0x805967
  802e4f:	e8 fa e4 ff ff       	call   80134e <cprintf>
  802e54:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e57:	8b 45 10             	mov    0x10(%ebp),%eax
  802e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e61:	74 07                	je     802e6a <print_blocks_list+0x73>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	eb 05                	jmp    802e6f <print_blocks_list+0x78>
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6f:	89 45 10             	mov    %eax,0x10(%ebp)
  802e72:	8b 45 10             	mov    0x10(%ebp),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	75 ad                	jne    802e26 <print_blocks_list+0x2f>
  802e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7d:	75 a7                	jne    802e26 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e7f:	83 ec 0c             	sub    $0xc,%esp
  802e82:	68 24 59 80 00       	push   $0x805924
  802e87:	e8 c2 e4 ff ff       	call   80134e <cprintf>
  802e8c:	83 c4 10             	add    $0x10,%esp

}
  802e8f:	90                   	nop
  802e90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e93:	c9                   	leave  
  802e94:	c3                   	ret    

00802e95 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802e95:	55                   	push   %ebp
  802e96:	89 e5                	mov    %esp,%ebp
  802e98:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	83 e0 01             	and    $0x1,%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 03                	je     802ea8 <initialize_dynamic_allocator+0x13>
  802ea5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eac:	0f 84 c7 01 00 00    	je     803079 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802eb2:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802eb9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ec9:	0f 87 ad 01 00 00    	ja     80307c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	0f 89 a5 01 00 00    	jns    80307f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802eda:	8b 55 08             	mov    0x8(%ebp),%edx
  802edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee0:	01 d0                	add    %edx,%eax
  802ee2:	83 e8 04             	sub    $0x4,%eax
  802ee5:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802ef1:	a1 44 60 80 00       	mov    0x806044,%eax
  802ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef9:	e9 87 00 00 00       	jmp    802f85 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802efe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f02:	75 14                	jne    802f18 <initialize_dynamic_allocator+0x83>
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 7f 59 80 00       	push   $0x80597f
  802f0c:	6a 79                	push   $0x79
  802f0e:	68 9d 59 80 00       	push   $0x80599d
  802f13:	e8 79 e1 ff ff       	call   801091 <_panic>
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	74 10                	je     802f31 <initialize_dynamic_allocator+0x9c>
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f29:	8b 52 04             	mov    0x4(%edx),%edx
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	eb 0b                	jmp    802f3c <initialize_dynamic_allocator+0xa7>
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	a3 48 60 80 00       	mov    %eax,0x806048
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0f                	je     802f55 <initialize_dynamic_allocator+0xc0>
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4f:	8b 12                	mov    (%edx),%edx
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	eb 0a                	jmp    802f5f <initialize_dynamic_allocator+0xca>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	a3 44 60 80 00       	mov    %eax,0x806044
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f72:	a1 50 60 80 00       	mov    0x806050,%eax
  802f77:	48                   	dec    %eax
  802f78:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802f7d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f89:	74 07                	je     802f92 <initialize_dynamic_allocator+0xfd>
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	eb 05                	jmp    802f97 <initialize_dynamic_allocator+0x102>
  802f92:	b8 00 00 00 00       	mov    $0x0,%eax
  802f97:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802f9c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	0f 85 55 ff ff ff    	jne    802efe <initialize_dynamic_allocator+0x69>
  802fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fad:	0f 85 4b ff ff ff    	jne    802efe <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802fc2:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802fc7:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802fcc:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802fd1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	83 c0 08             	add    $0x8,%eax
  802fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	83 c0 04             	add    $0x4,%eax
  802fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe9:	83 ea 08             	sub    $0x8,%edx
  802fec:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	01 d0                	add    %edx,%eax
  802ff6:	83 e8 08             	sub    $0x8,%eax
  802ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffc:	83 ea 08             	sub    $0x8,%edx
  802fff:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  803014:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803018:	75 17                	jne    803031 <initialize_dynamic_allocator+0x19c>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 b8 59 80 00       	push   $0x8059b8
  803022:	68 90 00 00 00       	push   $0x90
  803027:	68 9d 59 80 00       	push   $0x80599d
  80302c:	e8 60 e0 ff ff       	call   801091 <_panic>
  803031:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0d                	je     803052 <initialize_dynamic_allocator+0x1bd>
  803045:	a1 44 60 80 00       	mov    0x806044,%eax
  80304a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	eb 08                	jmp    80305a <initialize_dynamic_allocator+0x1c5>
  803052:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803055:	a3 48 60 80 00       	mov    %eax,0x806048
  80305a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305d:	a3 44 60 80 00       	mov    %eax,0x806044
  803062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306c:	a1 50 60 80 00       	mov    0x806050,%eax
  803071:	40                   	inc    %eax
  803072:	a3 50 60 80 00       	mov    %eax,0x806050
  803077:	eb 07                	jmp    803080 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803079:	90                   	nop
  80307a:	eb 04                	jmp    803080 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80307c:	90                   	nop
  80307d:	eb 01                	jmp    803080 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80307f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  803080:	c9                   	leave  
  803081:	c3                   	ret    

00803082 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803082:	55                   	push   %ebp
  803083:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803085:	8b 45 10             	mov    0x10(%ebp),%eax
  803088:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8d 50 fc             	lea    -0x4(%eax),%edx
  803091:	8b 45 0c             	mov    0xc(%ebp),%eax
  803094:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	83 e8 04             	sub    $0x4,%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	83 e0 fe             	and    $0xfffffffe,%eax
  8030a1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	01 c2                	add    %eax,%edx
  8030a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ac:	89 02                	mov    %eax,(%edx)
}
  8030ae:	90                   	nop
  8030af:	5d                   	pop    %ebp
  8030b0:	c3                   	ret    

008030b1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8030b1:	55                   	push   %ebp
  8030b2:	89 e5                	mov    %esp,%ebp
  8030b4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	83 e0 01             	and    $0x1,%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 03                	je     8030c4 <alloc_block_FF+0x13>
  8030c1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030c4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030c8:	77 07                	ja     8030d1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030ca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030d1:	a1 28 60 80 00       	mov    0x806028,%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	75 73                	jne    80314d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	83 c0 10             	add    $0x10,%eax
  8030e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030e3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8030ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	01 d0                	add    %edx,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8030fe:	f7 75 ec             	divl   -0x14(%ebp)
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	29 d0                	sub    %edx,%eax
  803106:	c1 e8 0c             	shr    $0xc,%eax
  803109:	83 ec 0c             	sub    $0xc,%esp
  80310c:	50                   	push   %eax
  80310d:	e8 d6 ef ff ff       	call   8020e8 <sbrk>
  803112:	83 c4 10             	add    $0x10,%esp
  803115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803118:	83 ec 0c             	sub    $0xc,%esp
  80311b:	6a 00                	push   $0x0
  80311d:	e8 c6 ef ff ff       	call   8020e8 <sbrk>
  803122:	83 c4 10             	add    $0x10,%esp
  803125:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803128:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80312b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80312e:	83 ec 08             	sub    $0x8,%esp
  803131:	50                   	push   %eax
  803132:	ff 75 e4             	pushl  -0x1c(%ebp)
  803135:	e8 5b fd ff ff       	call   802e95 <initialize_dynamic_allocator>
  80313a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80313d:	83 ec 0c             	sub    $0xc,%esp
  803140:	68 db 59 80 00       	push   $0x8059db
  803145:	e8 04 e2 ff ff       	call   80134e <cprintf>
  80314a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80314d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803151:	75 0a                	jne    80315d <alloc_block_FF+0xac>
	        return NULL;
  803153:	b8 00 00 00 00       	mov    $0x0,%eax
  803158:	e9 0e 04 00 00       	jmp    80356b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80315d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803164:	a1 44 60 80 00       	mov    0x806044,%eax
  803169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316c:	e9 f3 02 00 00       	jmp    803464 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803177:	83 ec 0c             	sub    $0xc,%esp
  80317a:	ff 75 bc             	pushl  -0x44(%ebp)
  80317d:	e8 af fb ff ff       	call   802d31 <get_block_size>
  803182:	83 c4 10             	add    $0x10,%esp
  803185:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	83 c0 08             	add    $0x8,%eax
  80318e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803191:	0f 87 c5 02 00 00    	ja     80345c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	83 c0 18             	add    $0x18,%eax
  80319d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8031a0:	0f 87 19 02 00 00    	ja     8033bf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8031a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8031ac:	83 e8 08             	sub    $0x8,%eax
  8031af:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	8d 50 08             	lea    0x8(%eax),%edx
  8031b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031bb:	01 d0                	add    %edx,%eax
  8031bd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	83 c0 08             	add    $0x8,%eax
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	6a 01                	push   $0x1
  8031cb:	50                   	push   %eax
  8031cc:	ff 75 bc             	pushl  -0x44(%ebp)
  8031cf:	e8 ae fe ff ff       	call   803082 <set_block_data>
  8031d4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	85 c0                	test   %eax,%eax
  8031df:	75 68                	jne    803249 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031e1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031e5:	75 17                	jne    8031fe <alloc_block_FF+0x14d>
  8031e7:	83 ec 04             	sub    $0x4,%esp
  8031ea:	68 b8 59 80 00       	push   $0x8059b8
  8031ef:	68 d7 00 00 00       	push   $0xd7
  8031f4:	68 9d 59 80 00       	push   $0x80599d
  8031f9:	e8 93 de ff ff       	call   801091 <_panic>
  8031fe:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803204:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803207:	89 10                	mov    %edx,(%eax)
  803209:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0d                	je     80321f <alloc_block_FF+0x16e>
  803212:	a1 44 60 80 00       	mov    0x806044,%eax
  803217:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80321a:	89 50 04             	mov    %edx,0x4(%eax)
  80321d:	eb 08                	jmp    803227 <alloc_block_FF+0x176>
  80321f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803222:	a3 48 60 80 00       	mov    %eax,0x806048
  803227:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80322a:	a3 44 60 80 00       	mov    %eax,0x806044
  80322f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	a1 50 60 80 00       	mov    0x806050,%eax
  80323e:	40                   	inc    %eax
  80323f:	a3 50 60 80 00       	mov    %eax,0x806050
  803244:	e9 dc 00 00 00       	jmp    803325 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	75 65                	jne    8032b7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803252:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803256:	75 17                	jne    80326f <alloc_block_FF+0x1be>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 ec 59 80 00       	push   $0x8059ec
  803260:	68 db 00 00 00       	push   $0xdb
  803265:	68 9d 59 80 00       	push   $0x80599d
  80326a:	e8 22 de ff ff       	call   801091 <_panic>
  80326f:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803275:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80327e:	8b 40 04             	mov    0x4(%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 0c                	je     803291 <alloc_block_FF+0x1e0>
  803285:	a1 48 60 80 00       	mov    0x806048,%eax
  80328a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80328d:	89 10                	mov    %edx,(%eax)
  80328f:	eb 08                	jmp    803299 <alloc_block_FF+0x1e8>
  803291:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803294:	a3 44 60 80 00       	mov    %eax,0x806044
  803299:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80329c:	a3 48 60 80 00       	mov    %eax,0x806048
  8032a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032aa:	a1 50 60 80 00       	mov    0x806050,%eax
  8032af:	40                   	inc    %eax
  8032b0:	a3 50 60 80 00       	mov    %eax,0x806050
  8032b5:	eb 6e                	jmp    803325 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8032b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bb:	74 06                	je     8032c3 <alloc_block_FF+0x212>
  8032bd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032c1:	75 17                	jne    8032da <alloc_block_FF+0x229>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 10 5a 80 00       	push   $0x805a10
  8032cb:	68 df 00 00 00       	push   $0xdf
  8032d0:	68 9d 59 80 00       	push   $0x80599d
  8032d5:	e8 b7 dd ff ff       	call   801091 <_panic>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 10                	mov    (%eax),%edx
  8032df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 0b                	je     8032f8 <alloc_block_FF+0x247>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032fe:	89 10                	mov    %edx,(%eax)
  803300:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 08                	jne    80331a <alloc_block_FF+0x269>
  803312:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803315:	a3 48 60 80 00       	mov    %eax,0x806048
  80331a:	a1 50 60 80 00       	mov    0x806050,%eax
  80331f:	40                   	inc    %eax
  803320:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803329:	75 17                	jne    803342 <alloc_block_FF+0x291>
  80332b:	83 ec 04             	sub    $0x4,%esp
  80332e:	68 7f 59 80 00       	push   $0x80597f
  803333:	68 e1 00 00 00       	push   $0xe1
  803338:	68 9d 59 80 00       	push   $0x80599d
  80333d:	e8 4f dd ff ff       	call   801091 <_panic>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 10                	je     80335b <alloc_block_FF+0x2aa>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803353:	8b 52 04             	mov    0x4(%edx),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 0b                	jmp    803366 <alloc_block_FF+0x2b5>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	a3 48 60 80 00       	mov    %eax,0x806048
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0f                	je     80337f <alloc_block_FF+0x2ce>
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803379:	8b 12                	mov    (%edx),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	eb 0a                	jmp    803389 <alloc_block_FF+0x2d8>
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	a3 44 60 80 00       	mov    %eax,0x806044
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 50 60 80 00       	mov    0x806050,%eax
  8033a1:	48                   	dec    %eax
  8033a2:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	6a 00                	push   $0x0
  8033ac:	ff 75 b4             	pushl  -0x4c(%ebp)
  8033af:	ff 75 b0             	pushl  -0x50(%ebp)
  8033b2:	e8 cb fc ff ff       	call   803082 <set_block_data>
  8033b7:	83 c4 10             	add    $0x10,%esp
  8033ba:	e9 95 00 00 00       	jmp    803454 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	6a 01                	push   $0x1
  8033c4:	ff 75 b8             	pushl  -0x48(%ebp)
  8033c7:	ff 75 bc             	pushl  -0x44(%ebp)
  8033ca:	e8 b3 fc ff ff       	call   803082 <set_block_data>
  8033cf:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8033d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d6:	75 17                	jne    8033ef <alloc_block_FF+0x33e>
  8033d8:	83 ec 04             	sub    $0x4,%esp
  8033db:	68 7f 59 80 00       	push   $0x80597f
  8033e0:	68 e8 00 00 00       	push   $0xe8
  8033e5:	68 9d 59 80 00       	push   $0x80599d
  8033ea:	e8 a2 dc ff ff       	call   801091 <_panic>
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 10                	je     803408 <alloc_block_FF+0x357>
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803400:	8b 52 04             	mov    0x4(%edx),%edx
  803403:	89 50 04             	mov    %edx,0x4(%eax)
  803406:	eb 0b                	jmp    803413 <alloc_block_FF+0x362>
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 40 04             	mov    0x4(%eax),%eax
  80340e:	a3 48 60 80 00       	mov    %eax,0x806048
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	74 0f                	je     80342c <alloc_block_FF+0x37b>
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803426:	8b 12                	mov    (%edx),%edx
  803428:	89 10                	mov    %edx,(%eax)
  80342a:	eb 0a                	jmp    803436 <alloc_block_FF+0x385>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	a3 44 60 80 00       	mov    %eax,0x806044
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 50 60 80 00       	mov    0x806050,%eax
  80344e:	48                   	dec    %eax
  80344f:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  803454:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803457:	e9 0f 01 00 00       	jmp    80356b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80345c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803468:	74 07                	je     803471 <alloc_block_FF+0x3c0>
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	eb 05                	jmp    803476 <alloc_block_FF+0x3c5>
  803471:	b8 00 00 00 00       	mov    $0x0,%eax
  803476:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80347b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	0f 85 e9 fc ff ff    	jne    803171 <alloc_block_FF+0xc0>
  803488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348c:	0f 85 df fc ff ff    	jne    803171 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	83 c0 08             	add    $0x8,%eax
  803498:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80349b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8034a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034a8:	01 d0                	add    %edx,%eax
  8034aa:	48                   	dec    %eax
  8034ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8034ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b6:	f7 75 d8             	divl   -0x28(%ebp)
  8034b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bc:	29 d0                	sub    %edx,%eax
  8034be:	c1 e8 0c             	shr    $0xc,%eax
  8034c1:	83 ec 0c             	sub    $0xc,%esp
  8034c4:	50                   	push   %eax
  8034c5:	e8 1e ec ff ff       	call   8020e8 <sbrk>
  8034ca:	83 c4 10             	add    $0x10,%esp
  8034cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8034d0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8034d4:	75 0a                	jne    8034e0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034db:	e9 8b 00 00 00       	jmp    80356b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034e0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8034e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ed:	01 d0                	add    %edx,%eax
  8034ef:	48                   	dec    %eax
  8034f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8034f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8034fb:	f7 75 cc             	divl   -0x34(%ebp)
  8034fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803501:	29 d0                	sub    %edx,%eax
  803503:	8d 50 fc             	lea    -0x4(%eax),%edx
  803506:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803509:	01 d0                	add    %edx,%eax
  80350b:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  803510:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803515:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80351b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803522:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803525:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803528:	01 d0                	add    %edx,%eax
  80352a:	48                   	dec    %eax
  80352b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80352e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803531:	ba 00 00 00 00       	mov    $0x0,%edx
  803536:	f7 75 c4             	divl   -0x3c(%ebp)
  803539:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80353c:	29 d0                	sub    %edx,%eax
  80353e:	83 ec 04             	sub    $0x4,%esp
  803541:	6a 01                	push   $0x1
  803543:	50                   	push   %eax
  803544:	ff 75 d0             	pushl  -0x30(%ebp)
  803547:	e8 36 fb ff ff       	call   803082 <set_block_data>
  80354c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80354f:	83 ec 0c             	sub    $0xc,%esp
  803552:	ff 75 d0             	pushl  -0x30(%ebp)
  803555:	e8 1b 0a 00 00       	call   803f75 <free_block>
  80355a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80355d:	83 ec 0c             	sub    $0xc,%esp
  803560:	ff 75 08             	pushl  0x8(%ebp)
  803563:	e8 49 fb ff ff       	call   8030b1 <alloc_block_FF>
  803568:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80356b:	c9                   	leave  
  80356c:	c3                   	ret    

0080356d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80356d:	55                   	push   %ebp
  80356e:	89 e5                	mov    %esp,%ebp
  803570:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	83 e0 01             	and    $0x1,%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 03                	je     803580 <alloc_block_BF+0x13>
  80357d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803580:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803584:	77 07                	ja     80358d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803586:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80358d:	a1 28 60 80 00       	mov    0x806028,%eax
  803592:	85 c0                	test   %eax,%eax
  803594:	75 73                	jne    803609 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	83 c0 10             	add    $0x10,%eax
  80359c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80359f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8035a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ac:	01 d0                	add    %edx,%eax
  8035ae:	48                   	dec    %eax
  8035af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ba:	f7 75 e0             	divl   -0x20(%ebp)
  8035bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c0:	29 d0                	sub    %edx,%eax
  8035c2:	c1 e8 0c             	shr    $0xc,%eax
  8035c5:	83 ec 0c             	sub    $0xc,%esp
  8035c8:	50                   	push   %eax
  8035c9:	e8 1a eb ff ff       	call   8020e8 <sbrk>
  8035ce:	83 c4 10             	add    $0x10,%esp
  8035d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8035d4:	83 ec 0c             	sub    $0xc,%esp
  8035d7:	6a 00                	push   $0x0
  8035d9:	e8 0a eb ff ff       	call   8020e8 <sbrk>
  8035de:	83 c4 10             	add    $0x10,%esp
  8035e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8035ea:	83 ec 08             	sub    $0x8,%esp
  8035ed:	50                   	push   %eax
  8035ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8035f1:	e8 9f f8 ff ff       	call   802e95 <initialize_dynamic_allocator>
  8035f6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8035f9:	83 ec 0c             	sub    $0xc,%esp
  8035fc:	68 db 59 80 00       	push   $0x8059db
  803601:	e8 48 dd ff ff       	call   80134e <cprintf>
  803606:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803610:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803617:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80361e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803625:	a1 44 60 80 00       	mov    0x806044,%eax
  80362a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362d:	e9 1d 01 00 00       	jmp    80374f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803638:	83 ec 0c             	sub    $0xc,%esp
  80363b:	ff 75 a8             	pushl  -0x58(%ebp)
  80363e:	e8 ee f6 ff ff       	call   802d31 <get_block_size>
  803643:	83 c4 10             	add    $0x10,%esp
  803646:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	83 c0 08             	add    $0x8,%eax
  80364f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803652:	0f 87 ef 00 00 00    	ja     803747 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	83 c0 18             	add    $0x18,%eax
  80365e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803661:	77 1d                	ja     803680 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803666:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803669:	0f 86 d8 00 00 00    	jbe    803747 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80366f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803672:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803675:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803678:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80367b:	e9 c7 00 00 00       	jmp    803747 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	83 c0 08             	add    $0x8,%eax
  803686:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803689:	0f 85 9d 00 00 00    	jne    80372c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	6a 01                	push   $0x1
  803694:	ff 75 a4             	pushl  -0x5c(%ebp)
  803697:	ff 75 a8             	pushl  -0x58(%ebp)
  80369a:	e8 e3 f9 ff ff       	call   803082 <set_block_data>
  80369f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8036a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a6:	75 17                	jne    8036bf <alloc_block_BF+0x152>
  8036a8:	83 ec 04             	sub    $0x4,%esp
  8036ab:	68 7f 59 80 00       	push   $0x80597f
  8036b0:	68 2c 01 00 00       	push   $0x12c
  8036b5:	68 9d 59 80 00       	push   $0x80599d
  8036ba:	e8 d2 d9 ff ff       	call   801091 <_panic>
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	74 10                	je     8036d8 <alloc_block_BF+0x16b>
  8036c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d0:	8b 52 04             	mov    0x4(%edx),%edx
  8036d3:	89 50 04             	mov    %edx,0x4(%eax)
  8036d6:	eb 0b                	jmp    8036e3 <alloc_block_BF+0x176>
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 40 04             	mov    0x4(%eax),%eax
  8036de:	a3 48 60 80 00       	mov    %eax,0x806048
  8036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e6:	8b 40 04             	mov    0x4(%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 0f                	je     8036fc <alloc_block_BF+0x18f>
  8036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f0:	8b 40 04             	mov    0x4(%eax),%eax
  8036f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f6:	8b 12                	mov    (%edx),%edx
  8036f8:	89 10                	mov    %edx,(%eax)
  8036fa:	eb 0a                	jmp    803706 <alloc_block_BF+0x199>
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	8b 00                	mov    (%eax),%eax
  803701:	a3 44 60 80 00       	mov    %eax,0x806044
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803719:	a1 50 60 80 00       	mov    0x806050,%eax
  80371e:	48                   	dec    %eax
  80371f:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803724:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803727:	e9 24 04 00 00       	jmp    803b50 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80372c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803732:	76 13                	jbe    803747 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803734:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80373b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80373e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803741:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803744:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803747:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80374c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803753:	74 07                	je     80375c <alloc_block_BF+0x1ef>
  803755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	eb 05                	jmp    803761 <alloc_block_BF+0x1f4>
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
  803761:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803766:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	0f 85 bf fe ff ff    	jne    803632 <alloc_block_BF+0xc5>
  803773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803777:	0f 85 b5 fe ff ff    	jne    803632 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80377d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803781:	0f 84 26 02 00 00    	je     8039ad <alloc_block_BF+0x440>
  803787:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80378b:	0f 85 1c 02 00 00    	jne    8039ad <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803794:	2b 45 08             	sub    0x8(%ebp),%eax
  803797:	83 e8 08             	sub    $0x8,%eax
  80379a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	8d 50 08             	lea    0x8(%eax),%edx
  8037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a6:	01 d0                	add    %edx,%eax
  8037a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	83 c0 08             	add    $0x8,%eax
  8037b1:	83 ec 04             	sub    $0x4,%esp
  8037b4:	6a 01                	push   $0x1
  8037b6:	50                   	push   %eax
  8037b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ba:	e8 c3 f8 ff ff       	call   803082 <set_block_data>
  8037bf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8037c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c5:	8b 40 04             	mov    0x4(%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	75 68                	jne    803834 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037d0:	75 17                	jne    8037e9 <alloc_block_BF+0x27c>
  8037d2:	83 ec 04             	sub    $0x4,%esp
  8037d5:	68 b8 59 80 00       	push   $0x8059b8
  8037da:	68 45 01 00 00       	push   $0x145
  8037df:	68 9d 59 80 00       	push   $0x80599d
  8037e4:	e8 a8 d8 ff ff       	call   801091 <_panic>
  8037e9:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8037ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0d                	je     80380a <alloc_block_BF+0x29d>
  8037fd:	a1 44 60 80 00       	mov    0x806044,%eax
  803802:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	eb 08                	jmp    803812 <alloc_block_BF+0x2a5>
  80380a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80380d:	a3 48 60 80 00       	mov    %eax,0x806048
  803812:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803815:	a3 44 60 80 00       	mov    %eax,0x806044
  80381a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80381d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803824:	a1 50 60 80 00       	mov    0x806050,%eax
  803829:	40                   	inc    %eax
  80382a:	a3 50 60 80 00       	mov    %eax,0x806050
  80382f:	e9 dc 00 00 00       	jmp    803910 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	75 65                	jne    8038a2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80383d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803841:	75 17                	jne    80385a <alloc_block_BF+0x2ed>
  803843:	83 ec 04             	sub    $0x4,%esp
  803846:	68 ec 59 80 00       	push   $0x8059ec
  80384b:	68 4a 01 00 00       	push   $0x14a
  803850:	68 9d 59 80 00       	push   $0x80599d
  803855:	e8 37 d8 ff ff       	call   801091 <_panic>
  80385a:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803860:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803863:	89 50 04             	mov    %edx,0x4(%eax)
  803866:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0c                	je     80387c <alloc_block_BF+0x30f>
  803870:	a1 48 60 80 00       	mov    0x806048,%eax
  803875:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803878:	89 10                	mov    %edx,(%eax)
  80387a:	eb 08                	jmp    803884 <alloc_block_BF+0x317>
  80387c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80387f:	a3 44 60 80 00       	mov    %eax,0x806044
  803884:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803887:	a3 48 60 80 00       	mov    %eax,0x806048
  80388c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80388f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803895:	a1 50 60 80 00       	mov    0x806050,%eax
  80389a:	40                   	inc    %eax
  80389b:	a3 50 60 80 00       	mov    %eax,0x806050
  8038a0:	eb 6e                	jmp    803910 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8038a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038a6:	74 06                	je     8038ae <alloc_block_BF+0x341>
  8038a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038ac:	75 17                	jne    8038c5 <alloc_block_BF+0x358>
  8038ae:	83 ec 04             	sub    $0x4,%esp
  8038b1:	68 10 5a 80 00       	push   $0x805a10
  8038b6:	68 4f 01 00 00       	push   $0x14f
  8038bb:	68 9d 59 80 00       	push   $0x80599d
  8038c0:	e8 cc d7 ff ff       	call   801091 <_panic>
  8038c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c8:	8b 10                	mov    (%eax),%edx
  8038ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038cd:	89 10                	mov    %edx,(%eax)
  8038cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	85 c0                	test   %eax,%eax
  8038d6:	74 0b                	je     8038e3 <alloc_block_BF+0x376>
  8038d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038db:	8b 00                	mov    (%eax),%eax
  8038dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038e0:	89 50 04             	mov    %edx,0x4(%eax)
  8038e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038e9:	89 10                	mov    %edx,(%eax)
  8038eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	75 08                	jne    803905 <alloc_block_BF+0x398>
  8038fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803900:	a3 48 60 80 00       	mov    %eax,0x806048
  803905:	a1 50 60 80 00       	mov    0x806050,%eax
  80390a:	40                   	inc    %eax
  80390b:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803914:	75 17                	jne    80392d <alloc_block_BF+0x3c0>
  803916:	83 ec 04             	sub    $0x4,%esp
  803919:	68 7f 59 80 00       	push   $0x80597f
  80391e:	68 51 01 00 00       	push   $0x151
  803923:	68 9d 59 80 00       	push   $0x80599d
  803928:	e8 64 d7 ff ff       	call   801091 <_panic>
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	74 10                	je     803946 <alloc_block_BF+0x3d9>
  803936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80393e:	8b 52 04             	mov    0x4(%edx),%edx
  803941:	89 50 04             	mov    %edx,0x4(%eax)
  803944:	eb 0b                	jmp    803951 <alloc_block_BF+0x3e4>
  803946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803949:	8b 40 04             	mov    0x4(%eax),%eax
  80394c:	a3 48 60 80 00       	mov    %eax,0x806048
  803951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803954:	8b 40 04             	mov    0x4(%eax),%eax
  803957:	85 c0                	test   %eax,%eax
  803959:	74 0f                	je     80396a <alloc_block_BF+0x3fd>
  80395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395e:	8b 40 04             	mov    0x4(%eax),%eax
  803961:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803964:	8b 12                	mov    (%edx),%edx
  803966:	89 10                	mov    %edx,(%eax)
  803968:	eb 0a                	jmp    803974 <alloc_block_BF+0x407>
  80396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396d:	8b 00                	mov    (%eax),%eax
  80396f:	a3 44 60 80 00       	mov    %eax,0x806044
  803974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803977:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80397d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803980:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803987:	a1 50 60 80 00       	mov    0x806050,%eax
  80398c:	48                   	dec    %eax
  80398d:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  803992:	83 ec 04             	sub    $0x4,%esp
  803995:	6a 00                	push   $0x0
  803997:	ff 75 d0             	pushl  -0x30(%ebp)
  80399a:	ff 75 cc             	pushl  -0x34(%ebp)
  80399d:	e8 e0 f6 ff ff       	call   803082 <set_block_data>
  8039a2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8039a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a8:	e9 a3 01 00 00       	jmp    803b50 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8039ad:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8039b1:	0f 85 9d 00 00 00    	jne    803a54 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	6a 01                	push   $0x1
  8039bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8039bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c2:	e8 bb f6 ff ff       	call   803082 <set_block_data>
  8039c7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8039ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039ce:	75 17                	jne    8039e7 <alloc_block_BF+0x47a>
  8039d0:	83 ec 04             	sub    $0x4,%esp
  8039d3:	68 7f 59 80 00       	push   $0x80597f
  8039d8:	68 58 01 00 00       	push   $0x158
  8039dd:	68 9d 59 80 00       	push   $0x80599d
  8039e2:	e8 aa d6 ff ff       	call   801091 <_panic>
  8039e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	74 10                	je     803a00 <alloc_block_BF+0x493>
  8039f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f8:	8b 52 04             	mov    0x4(%edx),%edx
  8039fb:	89 50 04             	mov    %edx,0x4(%eax)
  8039fe:	eb 0b                	jmp    803a0b <alloc_block_BF+0x49e>
  803a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a03:	8b 40 04             	mov    0x4(%eax),%eax
  803a06:	a3 48 60 80 00       	mov    %eax,0x806048
  803a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0e:	8b 40 04             	mov    0x4(%eax),%eax
  803a11:	85 c0                	test   %eax,%eax
  803a13:	74 0f                	je     803a24 <alloc_block_BF+0x4b7>
  803a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a18:	8b 40 04             	mov    0x4(%eax),%eax
  803a1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a1e:	8b 12                	mov    (%edx),%edx
  803a20:	89 10                	mov    %edx,(%eax)
  803a22:	eb 0a                	jmp    803a2e <alloc_block_BF+0x4c1>
  803a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	a3 44 60 80 00       	mov    %eax,0x806044
  803a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a41:	a1 50 60 80 00       	mov    0x806050,%eax
  803a46:	48                   	dec    %eax
  803a47:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4f:	e9 fc 00 00 00       	jmp    803b50 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803a54:	8b 45 08             	mov    0x8(%ebp),%eax
  803a57:	83 c0 08             	add    $0x8,%eax
  803a5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a5d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a64:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a67:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a6a:	01 d0                	add    %edx,%eax
  803a6c:	48                   	dec    %eax
  803a6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a73:	ba 00 00 00 00       	mov    $0x0,%edx
  803a78:	f7 75 c4             	divl   -0x3c(%ebp)
  803a7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a7e:	29 d0                	sub    %edx,%eax
  803a80:	c1 e8 0c             	shr    $0xc,%eax
  803a83:	83 ec 0c             	sub    $0xc,%esp
  803a86:	50                   	push   %eax
  803a87:	e8 5c e6 ff ff       	call   8020e8 <sbrk>
  803a8c:	83 c4 10             	add    $0x10,%esp
  803a8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803a92:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803a96:	75 0a                	jne    803aa2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803a98:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9d:	e9 ae 00 00 00       	jmp    803b50 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803aa2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803aa9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aaf:	01 d0                	add    %edx,%eax
  803ab1:	48                   	dec    %eax
  803ab2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803ab5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  803abd:	f7 75 b8             	divl   -0x48(%ebp)
  803ac0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ac3:	29 d0                	sub    %edx,%eax
  803ac5:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ac8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803acb:	01 d0                	add    %edx,%eax
  803acd:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  803ad2:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803ad7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803add:	83 ec 0c             	sub    $0xc,%esp
  803ae0:	68 44 5a 80 00       	push   $0x805a44
  803ae5:	e8 64 d8 ff ff       	call   80134e <cprintf>
  803aea:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803aed:	83 ec 08             	sub    $0x8,%esp
  803af0:	ff 75 bc             	pushl  -0x44(%ebp)
  803af3:	68 49 5a 80 00       	push   $0x805a49
  803af8:	e8 51 d8 ff ff       	call   80134e <cprintf>
  803afd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803b00:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803b07:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803b0d:	01 d0                	add    %edx,%eax
  803b0f:	48                   	dec    %eax
  803b10:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803b13:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b16:	ba 00 00 00 00       	mov    $0x0,%edx
  803b1b:	f7 75 b0             	divl   -0x50(%ebp)
  803b1e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b21:	29 d0                	sub    %edx,%eax
  803b23:	83 ec 04             	sub    $0x4,%esp
  803b26:	6a 01                	push   $0x1
  803b28:	50                   	push   %eax
  803b29:	ff 75 bc             	pushl  -0x44(%ebp)
  803b2c:	e8 51 f5 ff ff       	call   803082 <set_block_data>
  803b31:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803b34:	83 ec 0c             	sub    $0xc,%esp
  803b37:	ff 75 bc             	pushl  -0x44(%ebp)
  803b3a:	e8 36 04 00 00       	call   803f75 <free_block>
  803b3f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803b42:	83 ec 0c             	sub    $0xc,%esp
  803b45:	ff 75 08             	pushl  0x8(%ebp)
  803b48:	e8 20 fa ff ff       	call   80356d <alloc_block_BF>
  803b4d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803b50:	c9                   	leave  
  803b51:	c3                   	ret    

00803b52 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803b52:	55                   	push   %ebp
  803b53:	89 e5                	mov    %esp,%ebp
  803b55:	53                   	push   %ebx
  803b56:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b6b:	74 1e                	je     803b8b <merging+0x39>
  803b6d:	ff 75 08             	pushl  0x8(%ebp)
  803b70:	e8 bc f1 ff ff       	call   802d31 <get_block_size>
  803b75:	83 c4 04             	add    $0x4,%esp
  803b78:	89 c2                	mov    %eax,%edx
  803b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7d:	01 d0                	add    %edx,%eax
  803b7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803b82:	75 07                	jne    803b8b <merging+0x39>
		prev_is_free = 1;
  803b84:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803b8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b8f:	74 1e                	je     803baf <merging+0x5d>
  803b91:	ff 75 10             	pushl  0x10(%ebp)
  803b94:	e8 98 f1 ff ff       	call   802d31 <get_block_size>
  803b99:	83 c4 04             	add    $0x4,%esp
  803b9c:	89 c2                	mov    %eax,%edx
  803b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  803ba1:	01 d0                	add    %edx,%eax
  803ba3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ba6:	75 07                	jne    803baf <merging+0x5d>
		next_is_free = 1;
  803ba8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bb3:	0f 84 cc 00 00 00    	je     803c85 <merging+0x133>
  803bb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bbd:	0f 84 c2 00 00 00    	je     803c85 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803bc3:	ff 75 08             	pushl  0x8(%ebp)
  803bc6:	e8 66 f1 ff ff       	call   802d31 <get_block_size>
  803bcb:	83 c4 04             	add    $0x4,%esp
  803bce:	89 c3                	mov    %eax,%ebx
  803bd0:	ff 75 10             	pushl  0x10(%ebp)
  803bd3:	e8 59 f1 ff ff       	call   802d31 <get_block_size>
  803bd8:	83 c4 04             	add    $0x4,%esp
  803bdb:	01 c3                	add    %eax,%ebx
  803bdd:	ff 75 0c             	pushl  0xc(%ebp)
  803be0:	e8 4c f1 ff ff       	call   802d31 <get_block_size>
  803be5:	83 c4 04             	add    $0x4,%esp
  803be8:	01 d8                	add    %ebx,%eax
  803bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bed:	6a 00                	push   $0x0
  803bef:	ff 75 ec             	pushl  -0x14(%ebp)
  803bf2:	ff 75 08             	pushl  0x8(%ebp)
  803bf5:	e8 88 f4 ff ff       	call   803082 <set_block_data>
  803bfa:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803bfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c01:	75 17                	jne    803c1a <merging+0xc8>
  803c03:	83 ec 04             	sub    $0x4,%esp
  803c06:	68 7f 59 80 00       	push   $0x80597f
  803c0b:	68 7d 01 00 00       	push   $0x17d
  803c10:	68 9d 59 80 00       	push   $0x80599d
  803c15:	e8 77 d4 ff ff       	call   801091 <_panic>
  803c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c1d:	8b 00                	mov    (%eax),%eax
  803c1f:	85 c0                	test   %eax,%eax
  803c21:	74 10                	je     803c33 <merging+0xe1>
  803c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c26:	8b 00                	mov    (%eax),%eax
  803c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c2b:	8b 52 04             	mov    0x4(%edx),%edx
  803c2e:	89 50 04             	mov    %edx,0x4(%eax)
  803c31:	eb 0b                	jmp    803c3e <merging+0xec>
  803c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c36:	8b 40 04             	mov    0x4(%eax),%eax
  803c39:	a3 48 60 80 00       	mov    %eax,0x806048
  803c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c41:	8b 40 04             	mov    0x4(%eax),%eax
  803c44:	85 c0                	test   %eax,%eax
  803c46:	74 0f                	je     803c57 <merging+0x105>
  803c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4b:	8b 40 04             	mov    0x4(%eax),%eax
  803c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c51:	8b 12                	mov    (%edx),%edx
  803c53:	89 10                	mov    %edx,(%eax)
  803c55:	eb 0a                	jmp    803c61 <merging+0x10f>
  803c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c5a:	8b 00                	mov    (%eax),%eax
  803c5c:	a3 44 60 80 00       	mov    %eax,0x806044
  803c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c74:	a1 50 60 80 00       	mov    0x806050,%eax
  803c79:	48                   	dec    %eax
  803c7a:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803c7f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c80:	e9 ea 02 00 00       	jmp    803f6f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c89:	74 3b                	je     803cc6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803c8b:	83 ec 0c             	sub    $0xc,%esp
  803c8e:	ff 75 08             	pushl  0x8(%ebp)
  803c91:	e8 9b f0 ff ff       	call   802d31 <get_block_size>
  803c96:	83 c4 10             	add    $0x10,%esp
  803c99:	89 c3                	mov    %eax,%ebx
  803c9b:	83 ec 0c             	sub    $0xc,%esp
  803c9e:	ff 75 10             	pushl  0x10(%ebp)
  803ca1:	e8 8b f0 ff ff       	call   802d31 <get_block_size>
  803ca6:	83 c4 10             	add    $0x10,%esp
  803ca9:	01 d8                	add    %ebx,%eax
  803cab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803cae:	83 ec 04             	sub    $0x4,%esp
  803cb1:	6a 00                	push   $0x0
  803cb3:	ff 75 e8             	pushl  -0x18(%ebp)
  803cb6:	ff 75 08             	pushl  0x8(%ebp)
  803cb9:	e8 c4 f3 ff ff       	call   803082 <set_block_data>
  803cbe:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803cc1:	e9 a9 02 00 00       	jmp    803f6f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cca:	0f 84 2d 01 00 00    	je     803dfd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803cd0:	83 ec 0c             	sub    $0xc,%esp
  803cd3:	ff 75 10             	pushl  0x10(%ebp)
  803cd6:	e8 56 f0 ff ff       	call   802d31 <get_block_size>
  803cdb:	83 c4 10             	add    $0x10,%esp
  803cde:	89 c3                	mov    %eax,%ebx
  803ce0:	83 ec 0c             	sub    $0xc,%esp
  803ce3:	ff 75 0c             	pushl  0xc(%ebp)
  803ce6:	e8 46 f0 ff ff       	call   802d31 <get_block_size>
  803ceb:	83 c4 10             	add    $0x10,%esp
  803cee:	01 d8                	add    %ebx,%eax
  803cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803cf3:	83 ec 04             	sub    $0x4,%esp
  803cf6:	6a 00                	push   $0x0
  803cf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cfb:	ff 75 10             	pushl  0x10(%ebp)
  803cfe:	e8 7f f3 ff ff       	call   803082 <set_block_data>
  803d03:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803d06:	8b 45 10             	mov    0x10(%ebp),%eax
  803d09:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d10:	74 06                	je     803d18 <merging+0x1c6>
  803d12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d16:	75 17                	jne    803d2f <merging+0x1dd>
  803d18:	83 ec 04             	sub    $0x4,%esp
  803d1b:	68 58 5a 80 00       	push   $0x805a58
  803d20:	68 8d 01 00 00       	push   $0x18d
  803d25:	68 9d 59 80 00       	push   $0x80599d
  803d2a:	e8 62 d3 ff ff       	call   801091 <_panic>
  803d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d32:	8b 50 04             	mov    0x4(%eax),%edx
  803d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d38:	89 50 04             	mov    %edx,0x4(%eax)
  803d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d41:	89 10                	mov    %edx,(%eax)
  803d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d46:	8b 40 04             	mov    0x4(%eax),%eax
  803d49:	85 c0                	test   %eax,%eax
  803d4b:	74 0d                	je     803d5a <merging+0x208>
  803d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d50:	8b 40 04             	mov    0x4(%eax),%eax
  803d53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d56:	89 10                	mov    %edx,(%eax)
  803d58:	eb 08                	jmp    803d62 <merging+0x210>
  803d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d5d:	a3 44 60 80 00       	mov    %eax,0x806044
  803d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d68:	89 50 04             	mov    %edx,0x4(%eax)
  803d6b:	a1 50 60 80 00       	mov    0x806050,%eax
  803d70:	40                   	inc    %eax
  803d71:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d7a:	75 17                	jne    803d93 <merging+0x241>
  803d7c:	83 ec 04             	sub    $0x4,%esp
  803d7f:	68 7f 59 80 00       	push   $0x80597f
  803d84:	68 8e 01 00 00       	push   $0x18e
  803d89:	68 9d 59 80 00       	push   $0x80599d
  803d8e:	e8 fe d2 ff ff       	call   801091 <_panic>
  803d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d96:	8b 00                	mov    (%eax),%eax
  803d98:	85 c0                	test   %eax,%eax
  803d9a:	74 10                	je     803dac <merging+0x25a>
  803d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9f:	8b 00                	mov    (%eax),%eax
  803da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  803da4:	8b 52 04             	mov    0x4(%edx),%edx
  803da7:	89 50 04             	mov    %edx,0x4(%eax)
  803daa:	eb 0b                	jmp    803db7 <merging+0x265>
  803dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  803daf:	8b 40 04             	mov    0x4(%eax),%eax
  803db2:	a3 48 60 80 00       	mov    %eax,0x806048
  803db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dba:	8b 40 04             	mov    0x4(%eax),%eax
  803dbd:	85 c0                	test   %eax,%eax
  803dbf:	74 0f                	je     803dd0 <merging+0x27e>
  803dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc4:	8b 40 04             	mov    0x4(%eax),%eax
  803dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dca:	8b 12                	mov    (%edx),%edx
  803dcc:	89 10                	mov    %edx,(%eax)
  803dce:	eb 0a                	jmp    803dda <merging+0x288>
  803dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd3:	8b 00                	mov    (%eax),%eax
  803dd5:	a3 44 60 80 00       	mov    %eax,0x806044
  803dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ded:	a1 50 60 80 00       	mov    0x806050,%eax
  803df2:	48                   	dec    %eax
  803df3:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803df8:	e9 72 01 00 00       	jmp    803f6f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  803e00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803e03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e07:	74 79                	je     803e82 <merging+0x330>
  803e09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e0d:	74 73                	je     803e82 <merging+0x330>
  803e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e13:	74 06                	je     803e1b <merging+0x2c9>
  803e15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e19:	75 17                	jne    803e32 <merging+0x2e0>
  803e1b:	83 ec 04             	sub    $0x4,%esp
  803e1e:	68 10 5a 80 00       	push   $0x805a10
  803e23:	68 94 01 00 00       	push   $0x194
  803e28:	68 9d 59 80 00       	push   $0x80599d
  803e2d:	e8 5f d2 ff ff       	call   801091 <_panic>
  803e32:	8b 45 08             	mov    0x8(%ebp),%eax
  803e35:	8b 10                	mov    (%eax),%edx
  803e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3a:	89 10                	mov    %edx,(%eax)
  803e3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3f:	8b 00                	mov    (%eax),%eax
  803e41:	85 c0                	test   %eax,%eax
  803e43:	74 0b                	je     803e50 <merging+0x2fe>
  803e45:	8b 45 08             	mov    0x8(%ebp),%eax
  803e48:	8b 00                	mov    (%eax),%eax
  803e4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e4d:	89 50 04             	mov    %edx,0x4(%eax)
  803e50:	8b 45 08             	mov    0x8(%ebp),%eax
  803e53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e56:	89 10                	mov    %edx,(%eax)
  803e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803e5e:	89 50 04             	mov    %edx,0x4(%eax)
  803e61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e64:	8b 00                	mov    (%eax),%eax
  803e66:	85 c0                	test   %eax,%eax
  803e68:	75 08                	jne    803e72 <merging+0x320>
  803e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e6d:	a3 48 60 80 00       	mov    %eax,0x806048
  803e72:	a1 50 60 80 00       	mov    0x806050,%eax
  803e77:	40                   	inc    %eax
  803e78:	a3 50 60 80 00       	mov    %eax,0x806050
  803e7d:	e9 ce 00 00 00       	jmp    803f50 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e86:	74 65                	je     803eed <merging+0x39b>
  803e88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e8c:	75 17                	jne    803ea5 <merging+0x353>
  803e8e:	83 ec 04             	sub    $0x4,%esp
  803e91:	68 ec 59 80 00       	push   $0x8059ec
  803e96:	68 95 01 00 00       	push   $0x195
  803e9b:	68 9d 59 80 00       	push   $0x80599d
  803ea0:	e8 ec d1 ff ff       	call   801091 <_panic>
  803ea5:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803eab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb4:	8b 40 04             	mov    0x4(%eax),%eax
  803eb7:	85 c0                	test   %eax,%eax
  803eb9:	74 0c                	je     803ec7 <merging+0x375>
  803ebb:	a1 48 60 80 00       	mov    0x806048,%eax
  803ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ec3:	89 10                	mov    %edx,(%eax)
  803ec5:	eb 08                	jmp    803ecf <merging+0x37d>
  803ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eca:	a3 44 60 80 00       	mov    %eax,0x806044
  803ecf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed2:	a3 48 60 80 00       	mov    %eax,0x806048
  803ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ee0:	a1 50 60 80 00       	mov    0x806050,%eax
  803ee5:	40                   	inc    %eax
  803ee6:	a3 50 60 80 00       	mov    %eax,0x806050
  803eeb:	eb 63                	jmp    803f50 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803eed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ef1:	75 17                	jne    803f0a <merging+0x3b8>
  803ef3:	83 ec 04             	sub    $0x4,%esp
  803ef6:	68 b8 59 80 00       	push   $0x8059b8
  803efb:	68 98 01 00 00       	push   $0x198
  803f00:	68 9d 59 80 00       	push   $0x80599d
  803f05:	e8 87 d1 ff ff       	call   801091 <_panic>
  803f0a:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f13:	89 10                	mov    %edx,(%eax)
  803f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	85 c0                	test   %eax,%eax
  803f1c:	74 0d                	je     803f2b <merging+0x3d9>
  803f1e:	a1 44 60 80 00       	mov    0x806044,%eax
  803f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f26:	89 50 04             	mov    %edx,0x4(%eax)
  803f29:	eb 08                	jmp    803f33 <merging+0x3e1>
  803f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f2e:	a3 48 60 80 00       	mov    %eax,0x806048
  803f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f36:	a3 44 60 80 00       	mov    %eax,0x806044
  803f3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f45:	a1 50 60 80 00       	mov    0x806050,%eax
  803f4a:	40                   	inc    %eax
  803f4b:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803f50:	83 ec 0c             	sub    $0xc,%esp
  803f53:	ff 75 10             	pushl  0x10(%ebp)
  803f56:	e8 d6 ed ff ff       	call   802d31 <get_block_size>
  803f5b:	83 c4 10             	add    $0x10,%esp
  803f5e:	83 ec 04             	sub    $0x4,%esp
  803f61:	6a 00                	push   $0x0
  803f63:	50                   	push   %eax
  803f64:	ff 75 10             	pushl  0x10(%ebp)
  803f67:	e8 16 f1 ff ff       	call   803082 <set_block_data>
  803f6c:	83 c4 10             	add    $0x10,%esp
	}
}
  803f6f:	90                   	nop
  803f70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f73:	c9                   	leave  
  803f74:	c3                   	ret    

00803f75 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803f75:	55                   	push   %ebp
  803f76:	89 e5                	mov    %esp,%ebp
  803f78:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803f7b:	a1 44 60 80 00       	mov    0x806044,%eax
  803f80:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803f83:	a1 48 60 80 00       	mov    0x806048,%eax
  803f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f8b:	73 1b                	jae    803fa8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803f8d:	a1 48 60 80 00       	mov    0x806048,%eax
  803f92:	83 ec 04             	sub    $0x4,%esp
  803f95:	ff 75 08             	pushl  0x8(%ebp)
  803f98:	6a 00                	push   $0x0
  803f9a:	50                   	push   %eax
  803f9b:	e8 b2 fb ff ff       	call   803b52 <merging>
  803fa0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fa3:	e9 8b 00 00 00       	jmp    804033 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803fa8:	a1 44 60 80 00       	mov    0x806044,%eax
  803fad:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fb0:	76 18                	jbe    803fca <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803fb2:	a1 44 60 80 00       	mov    0x806044,%eax
  803fb7:	83 ec 04             	sub    $0x4,%esp
  803fba:	ff 75 08             	pushl  0x8(%ebp)
  803fbd:	50                   	push   %eax
  803fbe:	6a 00                	push   $0x0
  803fc0:	e8 8d fb ff ff       	call   803b52 <merging>
  803fc5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fc8:	eb 69                	jmp    804033 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fca:	a1 44 60 80 00       	mov    0x806044,%eax
  803fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fd2:	eb 39                	jmp    80400d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fda:	73 29                	jae    804005 <free_block+0x90>
  803fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fdf:	8b 00                	mov    (%eax),%eax
  803fe1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fe4:	76 1f                	jbe    804005 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe9:	8b 00                	mov    (%eax),%eax
  803feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803fee:	83 ec 04             	sub    $0x4,%esp
  803ff1:	ff 75 08             	pushl  0x8(%ebp)
  803ff4:	ff 75 f0             	pushl  -0x10(%ebp)
  803ff7:	ff 75 f4             	pushl  -0xc(%ebp)
  803ffa:	e8 53 fb ff ff       	call   803b52 <merging>
  803fff:	83 c4 10             	add    $0x10,%esp
			break;
  804002:	90                   	nop
		}
	}
}
  804003:	eb 2e                	jmp    804033 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804005:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80400a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80400d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804011:	74 07                	je     80401a <free_block+0xa5>
  804013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804016:	8b 00                	mov    (%eax),%eax
  804018:	eb 05                	jmp    80401f <free_block+0xaa>
  80401a:	b8 00 00 00 00       	mov    $0x0,%eax
  80401f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804024:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804029:	85 c0                	test   %eax,%eax
  80402b:	75 a7                	jne    803fd4 <free_block+0x5f>
  80402d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804031:	75 a1                	jne    803fd4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804033:	90                   	nop
  804034:	c9                   	leave  
  804035:	c3                   	ret    

00804036 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804036:	55                   	push   %ebp
  804037:	89 e5                	mov    %esp,%ebp
  804039:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80403c:	ff 75 08             	pushl  0x8(%ebp)
  80403f:	e8 ed ec ff ff       	call   802d31 <get_block_size>
  804044:	83 c4 04             	add    $0x4,%esp
  804047:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80404a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  804051:	eb 17                	jmp    80406a <copy_data+0x34>
  804053:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804056:	8b 45 0c             	mov    0xc(%ebp),%eax
  804059:	01 c2                	add    %eax,%edx
  80405b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	01 c8                	add    %ecx,%eax
  804063:	8a 00                	mov    (%eax),%al
  804065:	88 02                	mov    %al,(%edx)
  804067:	ff 45 fc             	incl   -0x4(%ebp)
  80406a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80406d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804070:	72 e1                	jb     804053 <copy_data+0x1d>
}
  804072:	90                   	nop
  804073:	c9                   	leave  
  804074:	c3                   	ret    

00804075 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804075:	55                   	push   %ebp
  804076:	89 e5                	mov    %esp,%ebp
  804078:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80407b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80407f:	75 23                	jne    8040a4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  804081:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804085:	74 13                	je     80409a <realloc_block_FF+0x25>
  804087:	83 ec 0c             	sub    $0xc,%esp
  80408a:	ff 75 0c             	pushl  0xc(%ebp)
  80408d:	e8 1f f0 ff ff       	call   8030b1 <alloc_block_FF>
  804092:	83 c4 10             	add    $0x10,%esp
  804095:	e9 f4 06 00 00       	jmp    80478e <realloc_block_FF+0x719>
		return NULL;
  80409a:	b8 00 00 00 00       	mov    $0x0,%eax
  80409f:	e9 ea 06 00 00       	jmp    80478e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8040a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040a8:	75 18                	jne    8040c2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8040aa:	83 ec 0c             	sub    $0xc,%esp
  8040ad:	ff 75 08             	pushl  0x8(%ebp)
  8040b0:	e8 c0 fe ff ff       	call   803f75 <free_block>
  8040b5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8040b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bd:	e9 cc 06 00 00       	jmp    80478e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8040c2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8040c6:	77 07                	ja     8040cf <realloc_block_FF+0x5a>
  8040c8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8040cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040d2:	83 e0 01             	and    $0x1,%eax
  8040d5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8040d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040db:	83 c0 08             	add    $0x8,%eax
  8040de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8040e1:	83 ec 0c             	sub    $0xc,%esp
  8040e4:	ff 75 08             	pushl  0x8(%ebp)
  8040e7:	e8 45 ec ff ff       	call   802d31 <get_block_size>
  8040ec:	83 c4 10             	add    $0x10,%esp
  8040ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040f5:	83 e8 08             	sub    $0x8,%eax
  8040f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8040fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fe:	83 e8 04             	sub    $0x4,%eax
  804101:	8b 00                	mov    (%eax),%eax
  804103:	83 e0 fe             	and    $0xfffffffe,%eax
  804106:	89 c2                	mov    %eax,%edx
  804108:	8b 45 08             	mov    0x8(%ebp),%eax
  80410b:	01 d0                	add    %edx,%eax
  80410d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804110:	83 ec 0c             	sub    $0xc,%esp
  804113:	ff 75 e4             	pushl  -0x1c(%ebp)
  804116:	e8 16 ec ff ff       	call   802d31 <get_block_size>
  80411b:	83 c4 10             	add    $0x10,%esp
  80411e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804121:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804124:	83 e8 08             	sub    $0x8,%eax
  804127:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80412a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804130:	75 08                	jne    80413a <realloc_block_FF+0xc5>
	{
		 return va;
  804132:	8b 45 08             	mov    0x8(%ebp),%eax
  804135:	e9 54 06 00 00       	jmp    80478e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80413a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80413d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804140:	0f 83 e5 03 00 00    	jae    80452b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804149:	2b 45 0c             	sub    0xc(%ebp),%eax
  80414c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80414f:	83 ec 0c             	sub    $0xc,%esp
  804152:	ff 75 e4             	pushl  -0x1c(%ebp)
  804155:	e8 f0 eb ff ff       	call   802d4a <is_free_block>
  80415a:	83 c4 10             	add    $0x10,%esp
  80415d:	84 c0                	test   %al,%al
  80415f:	0f 84 3b 01 00 00    	je     8042a0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804165:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804168:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80416b:	01 d0                	add    %edx,%eax
  80416d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804170:	83 ec 04             	sub    $0x4,%esp
  804173:	6a 01                	push   $0x1
  804175:	ff 75 f0             	pushl  -0x10(%ebp)
  804178:	ff 75 08             	pushl  0x8(%ebp)
  80417b:	e8 02 ef ff ff       	call   803082 <set_block_data>
  804180:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804183:	8b 45 08             	mov    0x8(%ebp),%eax
  804186:	83 e8 04             	sub    $0x4,%eax
  804189:	8b 00                	mov    (%eax),%eax
  80418b:	83 e0 fe             	and    $0xfffffffe,%eax
  80418e:	89 c2                	mov    %eax,%edx
  804190:	8b 45 08             	mov    0x8(%ebp),%eax
  804193:	01 d0                	add    %edx,%eax
  804195:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804198:	83 ec 04             	sub    $0x4,%esp
  80419b:	6a 00                	push   $0x0
  80419d:	ff 75 cc             	pushl  -0x34(%ebp)
  8041a0:	ff 75 c8             	pushl  -0x38(%ebp)
  8041a3:	e8 da ee ff ff       	call   803082 <set_block_data>
  8041a8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8041ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041af:	74 06                	je     8041b7 <realloc_block_FF+0x142>
  8041b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8041b5:	75 17                	jne    8041ce <realloc_block_FF+0x159>
  8041b7:	83 ec 04             	sub    $0x4,%esp
  8041ba:	68 10 5a 80 00       	push   $0x805a10
  8041bf:	68 f6 01 00 00       	push   $0x1f6
  8041c4:	68 9d 59 80 00       	push   $0x80599d
  8041c9:	e8 c3 ce ff ff       	call   801091 <_panic>
  8041ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d1:	8b 10                	mov    (%eax),%edx
  8041d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041d6:	89 10                	mov    %edx,(%eax)
  8041d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041db:	8b 00                	mov    (%eax),%eax
  8041dd:	85 c0                	test   %eax,%eax
  8041df:	74 0b                	je     8041ec <realloc_block_FF+0x177>
  8041e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e4:	8b 00                	mov    (%eax),%eax
  8041e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041e9:	89 50 04             	mov    %edx,0x4(%eax)
  8041ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041f2:	89 10                	mov    %edx,(%eax)
  8041f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041fa:	89 50 04             	mov    %edx,0x4(%eax)
  8041fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804200:	8b 00                	mov    (%eax),%eax
  804202:	85 c0                	test   %eax,%eax
  804204:	75 08                	jne    80420e <realloc_block_FF+0x199>
  804206:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804209:	a3 48 60 80 00       	mov    %eax,0x806048
  80420e:	a1 50 60 80 00       	mov    0x806050,%eax
  804213:	40                   	inc    %eax
  804214:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80421d:	75 17                	jne    804236 <realloc_block_FF+0x1c1>
  80421f:	83 ec 04             	sub    $0x4,%esp
  804222:	68 7f 59 80 00       	push   $0x80597f
  804227:	68 f7 01 00 00       	push   $0x1f7
  80422c:	68 9d 59 80 00       	push   $0x80599d
  804231:	e8 5b ce ff ff       	call   801091 <_panic>
  804236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804239:	8b 00                	mov    (%eax),%eax
  80423b:	85 c0                	test   %eax,%eax
  80423d:	74 10                	je     80424f <realloc_block_FF+0x1da>
  80423f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804242:	8b 00                	mov    (%eax),%eax
  804244:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804247:	8b 52 04             	mov    0x4(%edx),%edx
  80424a:	89 50 04             	mov    %edx,0x4(%eax)
  80424d:	eb 0b                	jmp    80425a <realloc_block_FF+0x1e5>
  80424f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804252:	8b 40 04             	mov    0x4(%eax),%eax
  804255:	a3 48 60 80 00       	mov    %eax,0x806048
  80425a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425d:	8b 40 04             	mov    0x4(%eax),%eax
  804260:	85 c0                	test   %eax,%eax
  804262:	74 0f                	je     804273 <realloc_block_FF+0x1fe>
  804264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804267:	8b 40 04             	mov    0x4(%eax),%eax
  80426a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80426d:	8b 12                	mov    (%edx),%edx
  80426f:	89 10                	mov    %edx,(%eax)
  804271:	eb 0a                	jmp    80427d <realloc_block_FF+0x208>
  804273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804276:	8b 00                	mov    (%eax),%eax
  804278:	a3 44 60 80 00       	mov    %eax,0x806044
  80427d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804290:	a1 50 60 80 00       	mov    0x806050,%eax
  804295:	48                   	dec    %eax
  804296:	a3 50 60 80 00       	mov    %eax,0x806050
  80429b:	e9 83 02 00 00       	jmp    804523 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8042a0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8042a4:	0f 86 69 02 00 00    	jbe    804513 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8042aa:	83 ec 04             	sub    $0x4,%esp
  8042ad:	6a 01                	push   $0x1
  8042af:	ff 75 f0             	pushl  -0x10(%ebp)
  8042b2:	ff 75 08             	pushl  0x8(%ebp)
  8042b5:	e8 c8 ed ff ff       	call   803082 <set_block_data>
  8042ba:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8042bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c0:	83 e8 04             	sub    $0x4,%eax
  8042c3:	8b 00                	mov    (%eax),%eax
  8042c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8042c8:	89 c2                	mov    %eax,%edx
  8042ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8042cd:	01 d0                	add    %edx,%eax
  8042cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8042d2:	a1 50 60 80 00       	mov    0x806050,%eax
  8042d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8042da:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8042de:	75 68                	jne    804348 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042e4:	75 17                	jne    8042fd <realloc_block_FF+0x288>
  8042e6:	83 ec 04             	sub    $0x4,%esp
  8042e9:	68 b8 59 80 00       	push   $0x8059b8
  8042ee:	68 06 02 00 00       	push   $0x206
  8042f3:	68 9d 59 80 00       	push   $0x80599d
  8042f8:	e8 94 cd ff ff       	call   801091 <_panic>
  8042fd:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804303:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804306:	89 10                	mov    %edx,(%eax)
  804308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80430b:	8b 00                	mov    (%eax),%eax
  80430d:	85 c0                	test   %eax,%eax
  80430f:	74 0d                	je     80431e <realloc_block_FF+0x2a9>
  804311:	a1 44 60 80 00       	mov    0x806044,%eax
  804316:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804319:	89 50 04             	mov    %edx,0x4(%eax)
  80431c:	eb 08                	jmp    804326 <realloc_block_FF+0x2b1>
  80431e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804321:	a3 48 60 80 00       	mov    %eax,0x806048
  804326:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804329:	a3 44 60 80 00       	mov    %eax,0x806044
  80432e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804338:	a1 50 60 80 00       	mov    0x806050,%eax
  80433d:	40                   	inc    %eax
  80433e:	a3 50 60 80 00       	mov    %eax,0x806050
  804343:	e9 b0 01 00 00       	jmp    8044f8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804348:	a1 44 60 80 00       	mov    0x806044,%eax
  80434d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804350:	76 68                	jbe    8043ba <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804352:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804356:	75 17                	jne    80436f <realloc_block_FF+0x2fa>
  804358:	83 ec 04             	sub    $0x4,%esp
  80435b:	68 b8 59 80 00       	push   $0x8059b8
  804360:	68 0b 02 00 00       	push   $0x20b
  804365:	68 9d 59 80 00       	push   $0x80599d
  80436a:	e8 22 cd ff ff       	call   801091 <_panic>
  80436f:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804375:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804378:	89 10                	mov    %edx,(%eax)
  80437a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80437d:	8b 00                	mov    (%eax),%eax
  80437f:	85 c0                	test   %eax,%eax
  804381:	74 0d                	je     804390 <realloc_block_FF+0x31b>
  804383:	a1 44 60 80 00       	mov    0x806044,%eax
  804388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80438b:	89 50 04             	mov    %edx,0x4(%eax)
  80438e:	eb 08                	jmp    804398 <realloc_block_FF+0x323>
  804390:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804393:	a3 48 60 80 00       	mov    %eax,0x806048
  804398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80439b:	a3 44 60 80 00       	mov    %eax,0x806044
  8043a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043aa:	a1 50 60 80 00       	mov    0x806050,%eax
  8043af:	40                   	inc    %eax
  8043b0:	a3 50 60 80 00       	mov    %eax,0x806050
  8043b5:	e9 3e 01 00 00       	jmp    8044f8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8043ba:	a1 44 60 80 00       	mov    0x806044,%eax
  8043bf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043c2:	73 68                	jae    80442c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8043c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043c8:	75 17                	jne    8043e1 <realloc_block_FF+0x36c>
  8043ca:	83 ec 04             	sub    $0x4,%esp
  8043cd:	68 ec 59 80 00       	push   $0x8059ec
  8043d2:	68 10 02 00 00       	push   $0x210
  8043d7:	68 9d 59 80 00       	push   $0x80599d
  8043dc:	e8 b0 cc ff ff       	call   801091 <_panic>
  8043e1:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8043e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043ea:	89 50 04             	mov    %edx,0x4(%eax)
  8043ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043f0:	8b 40 04             	mov    0x4(%eax),%eax
  8043f3:	85 c0                	test   %eax,%eax
  8043f5:	74 0c                	je     804403 <realloc_block_FF+0x38e>
  8043f7:	a1 48 60 80 00       	mov    0x806048,%eax
  8043fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043ff:	89 10                	mov    %edx,(%eax)
  804401:	eb 08                	jmp    80440b <realloc_block_FF+0x396>
  804403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804406:	a3 44 60 80 00       	mov    %eax,0x806044
  80440b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80440e:	a3 48 60 80 00       	mov    %eax,0x806048
  804413:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80441c:	a1 50 60 80 00       	mov    0x806050,%eax
  804421:	40                   	inc    %eax
  804422:	a3 50 60 80 00       	mov    %eax,0x806050
  804427:	e9 cc 00 00 00       	jmp    8044f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80442c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804433:	a1 44 60 80 00       	mov    0x806044,%eax
  804438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80443b:	e9 8a 00 00 00       	jmp    8044ca <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804443:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804446:	73 7a                	jae    8044c2 <realloc_block_FF+0x44d>
  804448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80444b:	8b 00                	mov    (%eax),%eax
  80444d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804450:	73 70                	jae    8044c2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804456:	74 06                	je     80445e <realloc_block_FF+0x3e9>
  804458:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80445c:	75 17                	jne    804475 <realloc_block_FF+0x400>
  80445e:	83 ec 04             	sub    $0x4,%esp
  804461:	68 10 5a 80 00       	push   $0x805a10
  804466:	68 1a 02 00 00       	push   $0x21a
  80446b:	68 9d 59 80 00       	push   $0x80599d
  804470:	e8 1c cc ff ff       	call   801091 <_panic>
  804475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804478:	8b 10                	mov    (%eax),%edx
  80447a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80447d:	89 10                	mov    %edx,(%eax)
  80447f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804482:	8b 00                	mov    (%eax),%eax
  804484:	85 c0                	test   %eax,%eax
  804486:	74 0b                	je     804493 <realloc_block_FF+0x41e>
  804488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80448b:	8b 00                	mov    (%eax),%eax
  80448d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804490:	89 50 04             	mov    %edx,0x4(%eax)
  804493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804496:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804499:	89 10                	mov    %edx,(%eax)
  80449b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80449e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044a1:	89 50 04             	mov    %edx,0x4(%eax)
  8044a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044a7:	8b 00                	mov    (%eax),%eax
  8044a9:	85 c0                	test   %eax,%eax
  8044ab:	75 08                	jne    8044b5 <realloc_block_FF+0x440>
  8044ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044b0:	a3 48 60 80 00       	mov    %eax,0x806048
  8044b5:	a1 50 60 80 00       	mov    0x806050,%eax
  8044ba:	40                   	inc    %eax
  8044bb:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  8044c0:	eb 36                	jmp    8044f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8044c2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8044c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044ce:	74 07                	je     8044d7 <realloc_block_FF+0x462>
  8044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044d3:	8b 00                	mov    (%eax),%eax
  8044d5:	eb 05                	jmp    8044dc <realloc_block_FF+0x467>
  8044d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8044dc:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8044e1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8044e6:	85 c0                	test   %eax,%eax
  8044e8:	0f 85 52 ff ff ff    	jne    804440 <realloc_block_FF+0x3cb>
  8044ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044f2:	0f 85 48 ff ff ff    	jne    804440 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8044f8:	83 ec 04             	sub    $0x4,%esp
  8044fb:	6a 00                	push   $0x0
  8044fd:	ff 75 d8             	pushl  -0x28(%ebp)
  804500:	ff 75 d4             	pushl  -0x2c(%ebp)
  804503:	e8 7a eb ff ff       	call   803082 <set_block_data>
  804508:	83 c4 10             	add    $0x10,%esp
				return va;
  80450b:	8b 45 08             	mov    0x8(%ebp),%eax
  80450e:	e9 7b 02 00 00       	jmp    80478e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804513:	83 ec 0c             	sub    $0xc,%esp
  804516:	68 8d 5a 80 00       	push   $0x805a8d
  80451b:	e8 2e ce ff ff       	call   80134e <cprintf>
  804520:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804523:	8b 45 08             	mov    0x8(%ebp),%eax
  804526:	e9 63 02 00 00       	jmp    80478e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80452b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80452e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804531:	0f 86 4d 02 00 00    	jbe    804784 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804537:	83 ec 0c             	sub    $0xc,%esp
  80453a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80453d:	e8 08 e8 ff ff       	call   802d4a <is_free_block>
  804542:	83 c4 10             	add    $0x10,%esp
  804545:	84 c0                	test   %al,%al
  804547:	0f 84 37 02 00 00    	je     804784 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80454d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804550:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804553:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804556:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804559:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80455c:	76 38                	jbe    804596 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80455e:	83 ec 0c             	sub    $0xc,%esp
  804561:	ff 75 08             	pushl  0x8(%ebp)
  804564:	e8 0c fa ff ff       	call   803f75 <free_block>
  804569:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80456c:	83 ec 0c             	sub    $0xc,%esp
  80456f:	ff 75 0c             	pushl  0xc(%ebp)
  804572:	e8 3a eb ff ff       	call   8030b1 <alloc_block_FF>
  804577:	83 c4 10             	add    $0x10,%esp
  80457a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80457d:	83 ec 08             	sub    $0x8,%esp
  804580:	ff 75 c0             	pushl  -0x40(%ebp)
  804583:	ff 75 08             	pushl  0x8(%ebp)
  804586:	e8 ab fa ff ff       	call   804036 <copy_data>
  80458b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80458e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804591:	e9 f8 01 00 00       	jmp    80478e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804599:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80459c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80459f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8045a3:	0f 87 a0 00 00 00    	ja     804649 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8045a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045ad:	75 17                	jne    8045c6 <realloc_block_FF+0x551>
  8045af:	83 ec 04             	sub    $0x4,%esp
  8045b2:	68 7f 59 80 00       	push   $0x80597f
  8045b7:	68 38 02 00 00       	push   $0x238
  8045bc:	68 9d 59 80 00       	push   $0x80599d
  8045c1:	e8 cb ca ff ff       	call   801091 <_panic>
  8045c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c9:	8b 00                	mov    (%eax),%eax
  8045cb:	85 c0                	test   %eax,%eax
  8045cd:	74 10                	je     8045df <realloc_block_FF+0x56a>
  8045cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d2:	8b 00                	mov    (%eax),%eax
  8045d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045d7:	8b 52 04             	mov    0x4(%edx),%edx
  8045da:	89 50 04             	mov    %edx,0x4(%eax)
  8045dd:	eb 0b                	jmp    8045ea <realloc_block_FF+0x575>
  8045df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e2:	8b 40 04             	mov    0x4(%eax),%eax
  8045e5:	a3 48 60 80 00       	mov    %eax,0x806048
  8045ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ed:	8b 40 04             	mov    0x4(%eax),%eax
  8045f0:	85 c0                	test   %eax,%eax
  8045f2:	74 0f                	je     804603 <realloc_block_FF+0x58e>
  8045f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f7:	8b 40 04             	mov    0x4(%eax),%eax
  8045fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045fd:	8b 12                	mov    (%edx),%edx
  8045ff:	89 10                	mov    %edx,(%eax)
  804601:	eb 0a                	jmp    80460d <realloc_block_FF+0x598>
  804603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804606:	8b 00                	mov    (%eax),%eax
  804608:	a3 44 60 80 00       	mov    %eax,0x806044
  80460d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804620:	a1 50 60 80 00       	mov    0x806050,%eax
  804625:	48                   	dec    %eax
  804626:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80462b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80462e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804631:	01 d0                	add    %edx,%eax
  804633:	83 ec 04             	sub    $0x4,%esp
  804636:	6a 01                	push   $0x1
  804638:	50                   	push   %eax
  804639:	ff 75 08             	pushl  0x8(%ebp)
  80463c:	e8 41 ea ff ff       	call   803082 <set_block_data>
  804641:	83 c4 10             	add    $0x10,%esp
  804644:	e9 36 01 00 00       	jmp    80477f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80464c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80464f:	01 d0                	add    %edx,%eax
  804651:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804654:	83 ec 04             	sub    $0x4,%esp
  804657:	6a 01                	push   $0x1
  804659:	ff 75 f0             	pushl  -0x10(%ebp)
  80465c:	ff 75 08             	pushl  0x8(%ebp)
  80465f:	e8 1e ea ff ff       	call   803082 <set_block_data>
  804664:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804667:	8b 45 08             	mov    0x8(%ebp),%eax
  80466a:	83 e8 04             	sub    $0x4,%eax
  80466d:	8b 00                	mov    (%eax),%eax
  80466f:	83 e0 fe             	and    $0xfffffffe,%eax
  804672:	89 c2                	mov    %eax,%edx
  804674:	8b 45 08             	mov    0x8(%ebp),%eax
  804677:	01 d0                	add    %edx,%eax
  804679:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80467c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804680:	74 06                	je     804688 <realloc_block_FF+0x613>
  804682:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804686:	75 17                	jne    80469f <realloc_block_FF+0x62a>
  804688:	83 ec 04             	sub    $0x4,%esp
  80468b:	68 10 5a 80 00       	push   $0x805a10
  804690:	68 44 02 00 00       	push   $0x244
  804695:	68 9d 59 80 00       	push   $0x80599d
  80469a:	e8 f2 c9 ff ff       	call   801091 <_panic>
  80469f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046a2:	8b 10                	mov    (%eax),%edx
  8046a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046a7:	89 10                	mov    %edx,(%eax)
  8046a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046ac:	8b 00                	mov    (%eax),%eax
  8046ae:	85 c0                	test   %eax,%eax
  8046b0:	74 0b                	je     8046bd <realloc_block_FF+0x648>
  8046b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046b5:	8b 00                	mov    (%eax),%eax
  8046b7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046ba:	89 50 04             	mov    %edx,0x4(%eax)
  8046bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046c3:	89 10                	mov    %edx,(%eax)
  8046c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046cb:	89 50 04             	mov    %edx,0x4(%eax)
  8046ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046d1:	8b 00                	mov    (%eax),%eax
  8046d3:	85 c0                	test   %eax,%eax
  8046d5:	75 08                	jne    8046df <realloc_block_FF+0x66a>
  8046d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046da:	a3 48 60 80 00       	mov    %eax,0x806048
  8046df:	a1 50 60 80 00       	mov    0x806050,%eax
  8046e4:	40                   	inc    %eax
  8046e5:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8046ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046ee:	75 17                	jne    804707 <realloc_block_FF+0x692>
  8046f0:	83 ec 04             	sub    $0x4,%esp
  8046f3:	68 7f 59 80 00       	push   $0x80597f
  8046f8:	68 45 02 00 00       	push   $0x245
  8046fd:	68 9d 59 80 00       	push   $0x80599d
  804702:	e8 8a c9 ff ff       	call   801091 <_panic>
  804707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80470a:	8b 00                	mov    (%eax),%eax
  80470c:	85 c0                	test   %eax,%eax
  80470e:	74 10                	je     804720 <realloc_block_FF+0x6ab>
  804710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804713:	8b 00                	mov    (%eax),%eax
  804715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804718:	8b 52 04             	mov    0x4(%edx),%edx
  80471b:	89 50 04             	mov    %edx,0x4(%eax)
  80471e:	eb 0b                	jmp    80472b <realloc_block_FF+0x6b6>
  804720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804723:	8b 40 04             	mov    0x4(%eax),%eax
  804726:	a3 48 60 80 00       	mov    %eax,0x806048
  80472b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80472e:	8b 40 04             	mov    0x4(%eax),%eax
  804731:	85 c0                	test   %eax,%eax
  804733:	74 0f                	je     804744 <realloc_block_FF+0x6cf>
  804735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804738:	8b 40 04             	mov    0x4(%eax),%eax
  80473b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80473e:	8b 12                	mov    (%edx),%edx
  804740:	89 10                	mov    %edx,(%eax)
  804742:	eb 0a                	jmp    80474e <realloc_block_FF+0x6d9>
  804744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804747:	8b 00                	mov    (%eax),%eax
  804749:	a3 44 60 80 00       	mov    %eax,0x806044
  80474e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804751:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80475a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804761:	a1 50 60 80 00       	mov    0x806050,%eax
  804766:	48                   	dec    %eax
  804767:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  80476c:	83 ec 04             	sub    $0x4,%esp
  80476f:	6a 00                	push   $0x0
  804771:	ff 75 bc             	pushl  -0x44(%ebp)
  804774:	ff 75 b8             	pushl  -0x48(%ebp)
  804777:	e8 06 e9 ff ff       	call   803082 <set_block_data>
  80477c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80477f:	8b 45 08             	mov    0x8(%ebp),%eax
  804782:	eb 0a                	jmp    80478e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804784:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80478b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80478e:	c9                   	leave  
  80478f:	c3                   	ret    

00804790 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804790:	55                   	push   %ebp
  804791:	89 e5                	mov    %esp,%ebp
  804793:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804796:	83 ec 04             	sub    $0x4,%esp
  804799:	68 94 5a 80 00       	push   $0x805a94
  80479e:	68 58 02 00 00       	push   $0x258
  8047a3:	68 9d 59 80 00       	push   $0x80599d
  8047a8:	e8 e4 c8 ff ff       	call   801091 <_panic>

008047ad <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8047ad:	55                   	push   %ebp
  8047ae:	89 e5                	mov    %esp,%ebp
  8047b0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8047b3:	83 ec 04             	sub    $0x4,%esp
  8047b6:	68 bc 5a 80 00       	push   $0x805abc
  8047bb:	68 61 02 00 00       	push   $0x261
  8047c0:	68 9d 59 80 00       	push   $0x80599d
  8047c5:	e8 c7 c8 ff ff       	call   801091 <_panic>
  8047ca:	66 90                	xchg   %ax,%ax

008047cc <__udivdi3>:
  8047cc:	55                   	push   %ebp
  8047cd:	57                   	push   %edi
  8047ce:	56                   	push   %esi
  8047cf:	53                   	push   %ebx
  8047d0:	83 ec 1c             	sub    $0x1c,%esp
  8047d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8047d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8047db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8047e3:	89 ca                	mov    %ecx,%edx
  8047e5:	89 f8                	mov    %edi,%eax
  8047e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8047eb:	85 f6                	test   %esi,%esi
  8047ed:	75 2d                	jne    80481c <__udivdi3+0x50>
  8047ef:	39 cf                	cmp    %ecx,%edi
  8047f1:	77 65                	ja     804858 <__udivdi3+0x8c>
  8047f3:	89 fd                	mov    %edi,%ebp
  8047f5:	85 ff                	test   %edi,%edi
  8047f7:	75 0b                	jne    804804 <__udivdi3+0x38>
  8047f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8047fe:	31 d2                	xor    %edx,%edx
  804800:	f7 f7                	div    %edi
  804802:	89 c5                	mov    %eax,%ebp
  804804:	31 d2                	xor    %edx,%edx
  804806:	89 c8                	mov    %ecx,%eax
  804808:	f7 f5                	div    %ebp
  80480a:	89 c1                	mov    %eax,%ecx
  80480c:	89 d8                	mov    %ebx,%eax
  80480e:	f7 f5                	div    %ebp
  804810:	89 cf                	mov    %ecx,%edi
  804812:	89 fa                	mov    %edi,%edx
  804814:	83 c4 1c             	add    $0x1c,%esp
  804817:	5b                   	pop    %ebx
  804818:	5e                   	pop    %esi
  804819:	5f                   	pop    %edi
  80481a:	5d                   	pop    %ebp
  80481b:	c3                   	ret    
  80481c:	39 ce                	cmp    %ecx,%esi
  80481e:	77 28                	ja     804848 <__udivdi3+0x7c>
  804820:	0f bd fe             	bsr    %esi,%edi
  804823:	83 f7 1f             	xor    $0x1f,%edi
  804826:	75 40                	jne    804868 <__udivdi3+0x9c>
  804828:	39 ce                	cmp    %ecx,%esi
  80482a:	72 0a                	jb     804836 <__udivdi3+0x6a>
  80482c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804830:	0f 87 9e 00 00 00    	ja     8048d4 <__udivdi3+0x108>
  804836:	b8 01 00 00 00       	mov    $0x1,%eax
  80483b:	89 fa                	mov    %edi,%edx
  80483d:	83 c4 1c             	add    $0x1c,%esp
  804840:	5b                   	pop    %ebx
  804841:	5e                   	pop    %esi
  804842:	5f                   	pop    %edi
  804843:	5d                   	pop    %ebp
  804844:	c3                   	ret    
  804845:	8d 76 00             	lea    0x0(%esi),%esi
  804848:	31 ff                	xor    %edi,%edi
  80484a:	31 c0                	xor    %eax,%eax
  80484c:	89 fa                	mov    %edi,%edx
  80484e:	83 c4 1c             	add    $0x1c,%esp
  804851:	5b                   	pop    %ebx
  804852:	5e                   	pop    %esi
  804853:	5f                   	pop    %edi
  804854:	5d                   	pop    %ebp
  804855:	c3                   	ret    
  804856:	66 90                	xchg   %ax,%ax
  804858:	89 d8                	mov    %ebx,%eax
  80485a:	f7 f7                	div    %edi
  80485c:	31 ff                	xor    %edi,%edi
  80485e:	89 fa                	mov    %edi,%edx
  804860:	83 c4 1c             	add    $0x1c,%esp
  804863:	5b                   	pop    %ebx
  804864:	5e                   	pop    %esi
  804865:	5f                   	pop    %edi
  804866:	5d                   	pop    %ebp
  804867:	c3                   	ret    
  804868:	bd 20 00 00 00       	mov    $0x20,%ebp
  80486d:	89 eb                	mov    %ebp,%ebx
  80486f:	29 fb                	sub    %edi,%ebx
  804871:	89 f9                	mov    %edi,%ecx
  804873:	d3 e6                	shl    %cl,%esi
  804875:	89 c5                	mov    %eax,%ebp
  804877:	88 d9                	mov    %bl,%cl
  804879:	d3 ed                	shr    %cl,%ebp
  80487b:	89 e9                	mov    %ebp,%ecx
  80487d:	09 f1                	or     %esi,%ecx
  80487f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804883:	89 f9                	mov    %edi,%ecx
  804885:	d3 e0                	shl    %cl,%eax
  804887:	89 c5                	mov    %eax,%ebp
  804889:	89 d6                	mov    %edx,%esi
  80488b:	88 d9                	mov    %bl,%cl
  80488d:	d3 ee                	shr    %cl,%esi
  80488f:	89 f9                	mov    %edi,%ecx
  804891:	d3 e2                	shl    %cl,%edx
  804893:	8b 44 24 08          	mov    0x8(%esp),%eax
  804897:	88 d9                	mov    %bl,%cl
  804899:	d3 e8                	shr    %cl,%eax
  80489b:	09 c2                	or     %eax,%edx
  80489d:	89 d0                	mov    %edx,%eax
  80489f:	89 f2                	mov    %esi,%edx
  8048a1:	f7 74 24 0c          	divl   0xc(%esp)
  8048a5:	89 d6                	mov    %edx,%esi
  8048a7:	89 c3                	mov    %eax,%ebx
  8048a9:	f7 e5                	mul    %ebp
  8048ab:	39 d6                	cmp    %edx,%esi
  8048ad:	72 19                	jb     8048c8 <__udivdi3+0xfc>
  8048af:	74 0b                	je     8048bc <__udivdi3+0xf0>
  8048b1:	89 d8                	mov    %ebx,%eax
  8048b3:	31 ff                	xor    %edi,%edi
  8048b5:	e9 58 ff ff ff       	jmp    804812 <__udivdi3+0x46>
  8048ba:	66 90                	xchg   %ax,%ax
  8048bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8048c0:	89 f9                	mov    %edi,%ecx
  8048c2:	d3 e2                	shl    %cl,%edx
  8048c4:	39 c2                	cmp    %eax,%edx
  8048c6:	73 e9                	jae    8048b1 <__udivdi3+0xe5>
  8048c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8048cb:	31 ff                	xor    %edi,%edi
  8048cd:	e9 40 ff ff ff       	jmp    804812 <__udivdi3+0x46>
  8048d2:	66 90                	xchg   %ax,%ax
  8048d4:	31 c0                	xor    %eax,%eax
  8048d6:	e9 37 ff ff ff       	jmp    804812 <__udivdi3+0x46>
  8048db:	90                   	nop

008048dc <__umoddi3>:
  8048dc:	55                   	push   %ebp
  8048dd:	57                   	push   %edi
  8048de:	56                   	push   %esi
  8048df:	53                   	push   %ebx
  8048e0:	83 ec 1c             	sub    $0x1c,%esp
  8048e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8048e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8048eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8048f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8048f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8048fb:	89 f3                	mov    %esi,%ebx
  8048fd:	89 fa                	mov    %edi,%edx
  8048ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804903:	89 34 24             	mov    %esi,(%esp)
  804906:	85 c0                	test   %eax,%eax
  804908:	75 1a                	jne    804924 <__umoddi3+0x48>
  80490a:	39 f7                	cmp    %esi,%edi
  80490c:	0f 86 a2 00 00 00    	jbe    8049b4 <__umoddi3+0xd8>
  804912:	89 c8                	mov    %ecx,%eax
  804914:	89 f2                	mov    %esi,%edx
  804916:	f7 f7                	div    %edi
  804918:	89 d0                	mov    %edx,%eax
  80491a:	31 d2                	xor    %edx,%edx
  80491c:	83 c4 1c             	add    $0x1c,%esp
  80491f:	5b                   	pop    %ebx
  804920:	5e                   	pop    %esi
  804921:	5f                   	pop    %edi
  804922:	5d                   	pop    %ebp
  804923:	c3                   	ret    
  804924:	39 f0                	cmp    %esi,%eax
  804926:	0f 87 ac 00 00 00    	ja     8049d8 <__umoddi3+0xfc>
  80492c:	0f bd e8             	bsr    %eax,%ebp
  80492f:	83 f5 1f             	xor    $0x1f,%ebp
  804932:	0f 84 ac 00 00 00    	je     8049e4 <__umoddi3+0x108>
  804938:	bf 20 00 00 00       	mov    $0x20,%edi
  80493d:	29 ef                	sub    %ebp,%edi
  80493f:	89 fe                	mov    %edi,%esi
  804941:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804945:	89 e9                	mov    %ebp,%ecx
  804947:	d3 e0                	shl    %cl,%eax
  804949:	89 d7                	mov    %edx,%edi
  80494b:	89 f1                	mov    %esi,%ecx
  80494d:	d3 ef                	shr    %cl,%edi
  80494f:	09 c7                	or     %eax,%edi
  804951:	89 e9                	mov    %ebp,%ecx
  804953:	d3 e2                	shl    %cl,%edx
  804955:	89 14 24             	mov    %edx,(%esp)
  804958:	89 d8                	mov    %ebx,%eax
  80495a:	d3 e0                	shl    %cl,%eax
  80495c:	89 c2                	mov    %eax,%edx
  80495e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804962:	d3 e0                	shl    %cl,%eax
  804964:	89 44 24 04          	mov    %eax,0x4(%esp)
  804968:	8b 44 24 08          	mov    0x8(%esp),%eax
  80496c:	89 f1                	mov    %esi,%ecx
  80496e:	d3 e8                	shr    %cl,%eax
  804970:	09 d0                	or     %edx,%eax
  804972:	d3 eb                	shr    %cl,%ebx
  804974:	89 da                	mov    %ebx,%edx
  804976:	f7 f7                	div    %edi
  804978:	89 d3                	mov    %edx,%ebx
  80497a:	f7 24 24             	mull   (%esp)
  80497d:	89 c6                	mov    %eax,%esi
  80497f:	89 d1                	mov    %edx,%ecx
  804981:	39 d3                	cmp    %edx,%ebx
  804983:	0f 82 87 00 00 00    	jb     804a10 <__umoddi3+0x134>
  804989:	0f 84 91 00 00 00    	je     804a20 <__umoddi3+0x144>
  80498f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804993:	29 f2                	sub    %esi,%edx
  804995:	19 cb                	sbb    %ecx,%ebx
  804997:	89 d8                	mov    %ebx,%eax
  804999:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80499d:	d3 e0                	shl    %cl,%eax
  80499f:	89 e9                	mov    %ebp,%ecx
  8049a1:	d3 ea                	shr    %cl,%edx
  8049a3:	09 d0                	or     %edx,%eax
  8049a5:	89 e9                	mov    %ebp,%ecx
  8049a7:	d3 eb                	shr    %cl,%ebx
  8049a9:	89 da                	mov    %ebx,%edx
  8049ab:	83 c4 1c             	add    $0x1c,%esp
  8049ae:	5b                   	pop    %ebx
  8049af:	5e                   	pop    %esi
  8049b0:	5f                   	pop    %edi
  8049b1:	5d                   	pop    %ebp
  8049b2:	c3                   	ret    
  8049b3:	90                   	nop
  8049b4:	89 fd                	mov    %edi,%ebp
  8049b6:	85 ff                	test   %edi,%edi
  8049b8:	75 0b                	jne    8049c5 <__umoddi3+0xe9>
  8049ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8049bf:	31 d2                	xor    %edx,%edx
  8049c1:	f7 f7                	div    %edi
  8049c3:	89 c5                	mov    %eax,%ebp
  8049c5:	89 f0                	mov    %esi,%eax
  8049c7:	31 d2                	xor    %edx,%edx
  8049c9:	f7 f5                	div    %ebp
  8049cb:	89 c8                	mov    %ecx,%eax
  8049cd:	f7 f5                	div    %ebp
  8049cf:	89 d0                	mov    %edx,%eax
  8049d1:	e9 44 ff ff ff       	jmp    80491a <__umoddi3+0x3e>
  8049d6:	66 90                	xchg   %ax,%ax
  8049d8:	89 c8                	mov    %ecx,%eax
  8049da:	89 f2                	mov    %esi,%edx
  8049dc:	83 c4 1c             	add    $0x1c,%esp
  8049df:	5b                   	pop    %ebx
  8049e0:	5e                   	pop    %esi
  8049e1:	5f                   	pop    %edi
  8049e2:	5d                   	pop    %ebp
  8049e3:	c3                   	ret    
  8049e4:	3b 04 24             	cmp    (%esp),%eax
  8049e7:	72 06                	jb     8049ef <__umoddi3+0x113>
  8049e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8049ed:	77 0f                	ja     8049fe <__umoddi3+0x122>
  8049ef:	89 f2                	mov    %esi,%edx
  8049f1:	29 f9                	sub    %edi,%ecx
  8049f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8049f7:	89 14 24             	mov    %edx,(%esp)
  8049fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8049fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a02:	8b 14 24             	mov    (%esp),%edx
  804a05:	83 c4 1c             	add    $0x1c,%esp
  804a08:	5b                   	pop    %ebx
  804a09:	5e                   	pop    %esi
  804a0a:	5f                   	pop    %edi
  804a0b:	5d                   	pop    %ebp
  804a0c:	c3                   	ret    
  804a0d:	8d 76 00             	lea    0x0(%esi),%esi
  804a10:	2b 04 24             	sub    (%esp),%eax
  804a13:	19 fa                	sbb    %edi,%edx
  804a15:	89 d1                	mov    %edx,%ecx
  804a17:	89 c6                	mov    %eax,%esi
  804a19:	e9 71 ff ff ff       	jmp    80498f <__umoddi3+0xb3>
  804a1e:	66 90                	xchg   %ax,%ax
  804a20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804a24:	72 ea                	jb     804a10 <__umoddi3+0x134>
  804a26:	89 d9                	mov    %ebx,%ecx
  804a28:	e9 62 ff ff ff       	jmp    80498f <__umoddi3+0xb3>
