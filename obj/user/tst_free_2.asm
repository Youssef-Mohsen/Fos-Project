
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
  800055:	68 c0 49 80 00       	push   $0x8049c0
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
  8000a5:	68 f0 49 80 00       	push   $0x8049f0
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
  8000f6:	68 29 4a 80 00       	push   $0x804a29
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 45 4a 80 00       	push   $0x804a45
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
  80013d:	68 58 4a 80 00       	push   $0x804a58
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
  8002ac:	68 b0 4a 80 00       	push   $0x804ab0
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 45 4a 80 00       	push   $0x804a45
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
  80031b:	68 d8 4a 80 00       	push   $0x804ad8
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 de 29 00 00       	call   802d17 <alloc_block>
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
  80037f:	68 fc 4a 80 00       	push   $0x804afc
  800384:	6a 7f                	push   $0x7f
  800386:	68 45 4a 80 00       	push   $0x804a45
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
  80039b:	68 24 4b 80 00       	push   $0x804b24
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
  800443:	68 6c 4b 80 00       	push   $0x804b6c
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
  80049a:	68 8c 4b 80 00       	push   $0x804b8c
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
  8004ee:	68 ac 4b 80 00       	push   $0x804bac
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
  800538:	68 dc 4b 80 00       	push   $0x804bdc
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
  800552:	68 fc 4b 80 00       	push   $0x804bfc
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 37 4c 80 00       	push   $0x804c37
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
  8005e0:	68 4c 4c 80 00       	push   $0x804c4c
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 6b 4c 80 00       	push   $0x804c6b
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
  800669:	68 84 4c 80 00       	push   $0x804c84
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
  800683:	68 a4 4c 80 00       	push   $0x804ca4
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 db 4c 80 00       	push   $0x804cdb
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
  800711:	68 f0 4c 80 00       	push   $0x804cf0
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 0f 4d 80 00       	push   $0x804d0f
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
  800762:	e8 79 25 00 00       	call   802ce0 <get_block_size>
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
  8007b7:	68 28 4d 80 00       	push   $0x804d28
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
  8007d1:	68 48 4d 80 00       	push   $0x804d48
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
  80083d:	e8 9e 24 00 00       	call   802ce0 <get_block_size>
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
  80089b:	68 85 4d 80 00       	push   $0x804d85
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
  8008b5:	68 a4 4d 80 00       	push   $0x804da4
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 e4 4d 80 00       	push   $0x804de4
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 09 4e 80 00       	push   $0x804e09
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
  800963:	68 20 4e 80 00       	push   $0x804e20
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 50 4e 80 00       	push   $0x804e50
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
  8009fa:	68 7c 4e 80 00       	push   $0x804e7c
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 ac 4e 80 00       	push   $0x804eac
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
  800a68:	68 ec 4e 80 00       	push   $0x804eec
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
  800a82:	68 1c 4f 80 00       	push   $0x804f1c
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
  800b11:	68 48 4f 80 00       	push   $0x804f48
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
  800b2b:	68 78 4f 80 00       	push   $0x804f78
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 a0 4f 80 00       	push   $0x804fa0
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
  800bca:	68 c0 4f 80 00       	push   $0x804fc0
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
  800c3d:	68 f0 4f 80 00       	push   $0x804ff0
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
  800ca4:	e8 fd 20 00 00       	call   802da6 <print_blocks_list>
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
  800ce6:	68 08 50 80 00       	push   $0x805008
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 38 50 80 00       	push   $0x805038
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
  800d83:	68 70 50 80 00       	push   $0x805070
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
  800d9d:	68 a0 50 80 00       	push   $0x8050a0
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
  800dc2:	68 e4 50 80 00       	push   $0x8050e4
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
  800e7a:	68 50 51 80 00       	push   $0x805150
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
  800f18:	68 8c 51 80 00       	push   $0x80518c
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
  800f3c:	68 d0 51 80 00       	push   $0x8051d0
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
  800fce:	68 38 52 80 00       	push   $0x805238
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
  800ff6:	68 60 52 80 00       	push   $0x805260
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
  801027:	68 88 52 80 00       	push   $0x805288
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 e0 52 80 00       	push   $0x8052e0
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 38 52 80 00       	push   $0x805238
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
  8010b2:	68 f4 52 80 00       	push   $0x8052f4
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 f9 52 80 00       	push   $0x8052f9
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
  8010ef:	68 15 53 80 00       	push   $0x805315
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
  80111e:	68 18 53 80 00       	push   $0x805318
  801123:	6a 26                	push   $0x26
  801125:	68 64 53 80 00       	push   $0x805364
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
  8011f3:	68 70 53 80 00       	push   $0x805370
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 64 53 80 00       	push   $0x805364
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
  801266:	68 c4 53 80 00       	push   $0x8053c4
  80126b:	6a 44                	push   $0x44
  80126d:	68 64 53 80 00       	push   $0x805364
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
  8013eb:	e8 58 33 00 00       	call   804748 <__udivdi3>
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
  80143b:	e8 18 34 00 00       	call   804858 <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 34 56 80 00       	add    $0x805634,%eax
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
  801596:	8b 04 85 58 56 80 00 	mov    0x805658(,%eax,4),%eax
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
  801677:	8b 34 9d a0 54 80 00 	mov    0x8054a0(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 45 56 80 00       	push   $0x805645
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
  80169c:	68 4e 56 80 00       	push   $0x80564e
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
  8016c9:	be 51 56 80 00       	mov    $0x805651,%esi
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
  8020d4:	68 c8 57 80 00       	push   $0x8057c8
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 ea 57 80 00       	push   $0x8057ea
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
  80217e:	e8 dd 0e 00 00       	call   803060 <alloc_block_FF>
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
  8021a1:	e8 76 13 00 00       	call   80351c <alloc_block_BF>
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
  80234f:	e8 8c 09 00 00       	call   802ce0 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 9c 1b 00 00       	call   803f01 <free_block>
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
  802405:	68 f8 57 80 00       	push   $0x8057f8
  80240a:	68 87 00 00 00       	push   $0x87
  80240f:	68 22 58 80 00       	push   $0x805822
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
  8025b0:	68 30 58 80 00       	push   $0x805830
  8025b5:	68 e4 00 00 00       	push   $0xe4
  8025ba:	68 22 58 80 00       	push   $0x805822
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
  8025cd:	68 56 58 80 00       	push   $0x805856
  8025d2:	68 f0 00 00 00       	push   $0xf0
  8025d7:	68 22 58 80 00       	push   $0x805822
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
  8025ea:	68 56 58 80 00       	push   $0x805856
  8025ef:	68 f5 00 00 00       	push   $0xf5
  8025f4:	68 22 58 80 00       	push   $0x805822
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
  802607:	68 56 58 80 00       	push   $0x805856
  80260c:	68 fa 00 00 00       	push   $0xfa
  802611:	68 22 58 80 00       	push   $0x805822
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

00802c44 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802c4a:	6a 00                	push   $0x0
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 2e                	push   $0x2e
  802c56:	e8 c0 f9 ff ff       	call   80261b <syscall>
  802c5b:	83 c4 18             	add    $0x18,%esp
  802c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	6a 00                	push   $0x0
  802c72:	6a 00                	push   $0x0
  802c74:	50                   	push   %eax
  802c75:	6a 2f                	push   $0x2f
  802c77:	e8 9f f9 ff ff       	call   80261b <syscall>
  802c7c:	83 c4 18             	add    $0x18,%esp
	return;
  802c7f:	90                   	nop
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	52                   	push   %edx
  802c92:	50                   	push   %eax
  802c93:	6a 30                	push   $0x30
  802c95:	e8 81 f9 ff ff       	call   80261b <syscall>
  802c9a:	83 c4 18             	add    $0x18,%esp
	return;
  802c9d:	90                   	nop
}
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
  802ca3:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	50                   	push   %eax
  802cb2:	6a 31                	push   $0x31
  802cb4:	e8 62 f9 ff ff       	call   80261b <syscall>
  802cb9:	83 c4 18             	add    $0x18,%esp
  802cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802cc2:	c9                   	leave  
  802cc3:	c3                   	ret    

00802cc4 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802cc4:	55                   	push   %ebp
  802cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	50                   	push   %eax
  802cd3:	6a 32                	push   $0x32
  802cd5:	e8 41 f9 ff ff       	call   80261b <syscall>
  802cda:	83 c4 18             	add    $0x18,%esp
	return;
  802cdd:	90                   	nop
}
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	83 e8 04             	sub    $0x4,%eax
  802cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

00802cf9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
  802cfc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	83 e8 04             	sub    $0x4,%eax
  802d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	83 e0 01             	and    $0x1,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	0f 94 c0             	sete   %al
}
  802d15:	c9                   	leave  
  802d16:	c3                   	ret    

00802d17 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d17:	55                   	push   %ebp
  802d18:	89 e5                	mov    %esp,%ebp
  802d1a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d27:	83 f8 02             	cmp    $0x2,%eax
  802d2a:	74 2b                	je     802d57 <alloc_block+0x40>
  802d2c:	83 f8 02             	cmp    $0x2,%eax
  802d2f:	7f 07                	jg     802d38 <alloc_block+0x21>
  802d31:	83 f8 01             	cmp    $0x1,%eax
  802d34:	74 0e                	je     802d44 <alloc_block+0x2d>
  802d36:	eb 58                	jmp    802d90 <alloc_block+0x79>
  802d38:	83 f8 03             	cmp    $0x3,%eax
  802d3b:	74 2d                	je     802d6a <alloc_block+0x53>
  802d3d:	83 f8 04             	cmp    $0x4,%eax
  802d40:	74 3b                	je     802d7d <alloc_block+0x66>
  802d42:	eb 4c                	jmp    802d90 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 08             	pushl  0x8(%ebp)
  802d4a:	e8 11 03 00 00       	call   803060 <alloc_block_FF>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d55:	eb 4a                	jmp    802da1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802d57:	83 ec 0c             	sub    $0xc,%esp
  802d5a:	ff 75 08             	pushl  0x8(%ebp)
  802d5d:	e8 c7 19 00 00       	call   804729 <alloc_block_NF>
  802d62:	83 c4 10             	add    $0x10,%esp
  802d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d68:	eb 37                	jmp    802da1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802d6a:	83 ec 0c             	sub    $0xc,%esp
  802d6d:	ff 75 08             	pushl  0x8(%ebp)
  802d70:	e8 a7 07 00 00       	call   80351c <alloc_block_BF>
  802d75:	83 c4 10             	add    $0x10,%esp
  802d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d7b:	eb 24                	jmp    802da1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802d7d:	83 ec 0c             	sub    $0xc,%esp
  802d80:	ff 75 08             	pushl  0x8(%ebp)
  802d83:	e8 84 19 00 00       	call   80470c <alloc_block_WF>
  802d88:	83 c4 10             	add    $0x10,%esp
  802d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d8e:	eb 11                	jmp    802da1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802d90:	83 ec 0c             	sub    $0xc,%esp
  802d93:	68 68 58 80 00       	push   $0x805868
  802d98:	e8 b1 e5 ff ff       	call   80134e <cprintf>
  802d9d:	83 c4 10             	add    $0x10,%esp
		break;
  802da0:	90                   	nop
	}
	return va;
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	53                   	push   %ebx
  802daa:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802dad:	83 ec 0c             	sub    $0xc,%esp
  802db0:	68 88 58 80 00       	push   $0x805888
  802db5:	e8 94 e5 ff ff       	call   80134e <cprintf>
  802dba:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802dbd:	83 ec 0c             	sub    $0xc,%esp
  802dc0:	68 b3 58 80 00       	push   $0x8058b3
  802dc5:	e8 84 e5 ff ff       	call   80134e <cprintf>
  802dca:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd3:	eb 37                	jmp    802e0c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802dd5:	83 ec 0c             	sub    $0xc,%esp
  802dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  802ddb:	e8 19 ff ff ff       	call   802cf9 <is_free_block>
  802de0:	83 c4 10             	add    $0x10,%esp
  802de3:	0f be d8             	movsbl %al,%ebx
  802de6:	83 ec 0c             	sub    $0xc,%esp
  802de9:	ff 75 f4             	pushl  -0xc(%ebp)
  802dec:	e8 ef fe ff ff       	call   802ce0 <get_block_size>
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	53                   	push   %ebx
  802df8:	50                   	push   %eax
  802df9:	68 cb 58 80 00       	push   $0x8058cb
  802dfe:	e8 4b e5 ff ff       	call   80134e <cprintf>
  802e03:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e06:	8b 45 10             	mov    0x10(%ebp),%eax
  802e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e10:	74 07                	je     802e19 <print_blocks_list+0x73>
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	eb 05                	jmp    802e1e <print_blocks_list+0x78>
  802e19:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1e:	89 45 10             	mov    %eax,0x10(%ebp)
  802e21:	8b 45 10             	mov    0x10(%ebp),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	75 ad                	jne    802dd5 <print_blocks_list+0x2f>
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	75 a7                	jne    802dd5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e2e:	83 ec 0c             	sub    $0xc,%esp
  802e31:	68 88 58 80 00       	push   $0x805888
  802e36:	e8 13 e5 ff ff       	call   80134e <cprintf>
  802e3b:	83 c4 10             	add    $0x10,%esp

}
  802e3e:	90                   	nop
  802e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e42:	c9                   	leave  
  802e43:	c3                   	ret    

00802e44 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
  802e47:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4d:	83 e0 01             	and    $0x1,%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 03                	je     802e57 <initialize_dynamic_allocator+0x13>
  802e54:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802e57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e5b:	0f 84 c7 01 00 00    	je     803028 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802e61:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802e68:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	01 d0                	add    %edx,%eax
  802e73:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802e78:	0f 87 ad 01 00 00    	ja     80302b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	0f 89 a5 01 00 00    	jns    80302e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802e89:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	01 d0                	add    %edx,%eax
  802e91:	83 e8 04             	sub    $0x4,%eax
  802e94:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802ea0:	a1 44 60 80 00       	mov    0x806044,%eax
  802ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea8:	e9 87 00 00 00       	jmp    802f34 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	75 14                	jne    802ec7 <initialize_dynamic_allocator+0x83>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 e3 58 80 00       	push   $0x8058e3
  802ebb:	6a 79                	push   $0x79
  802ebd:	68 01 59 80 00       	push   $0x805901
  802ec2:	e8 ca e1 ff ff       	call   801091 <_panic>
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 10                	je     802ee0 <initialize_dynamic_allocator+0x9c>
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed8:	8b 52 04             	mov    0x4(%edx),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	eb 0b                	jmp    802eeb <initialize_dynamic_allocator+0xa7>
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	a3 48 60 80 00       	mov    %eax,0x806048
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 40 04             	mov    0x4(%eax),%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	74 0f                	je     802f04 <initialize_dynamic_allocator+0xc0>
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efe:	8b 12                	mov    (%edx),%edx
  802f00:	89 10                	mov    %edx,(%eax)
  802f02:	eb 0a                	jmp    802f0e <initialize_dynamic_allocator+0xca>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	a3 44 60 80 00       	mov    %eax,0x806044
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f21:	a1 50 60 80 00       	mov    0x806050,%eax
  802f26:	48                   	dec    %eax
  802f27:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802f2c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f38:	74 07                	je     802f41 <initialize_dynamic_allocator+0xfd>
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	eb 05                	jmp    802f46 <initialize_dynamic_allocator+0x102>
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax
  802f46:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802f4b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	0f 85 55 ff ff ff    	jne    802ead <initialize_dynamic_allocator+0x69>
  802f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5c:	0f 85 4b ff ff ff    	jne    802ead <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802f71:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802f76:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802f7b:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802f80:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	83 c0 08             	add    $0x8,%eax
  802f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	83 c0 04             	add    $0x4,%eax
  802f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f98:	83 ea 08             	sub    $0x8,%edx
  802f9b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	83 e8 08             	sub    $0x8,%eax
  802fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fab:	83 ea 08             	sub    $0x8,%edx
  802fae:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802fb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802fc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc7:	75 17                	jne    802fe0 <initialize_dynamic_allocator+0x19c>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 1c 59 80 00       	push   $0x80591c
  802fd1:	68 90 00 00 00       	push   $0x90
  802fd6:	68 01 59 80 00       	push   $0x805901
  802fdb:	e8 b1 e0 ff ff       	call   801091 <_panic>
  802fe0:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0d                	je     803001 <initialize_dynamic_allocator+0x1bd>
  802ff4:	a1 44 60 80 00       	mov    0x806044,%eax
  802ff9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 08                	jmp    803009 <initialize_dynamic_allocator+0x1c5>
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	a3 48 60 80 00       	mov    %eax,0x806048
  803009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300c:	a3 44 60 80 00       	mov    %eax,0x806044
  803011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301b:	a1 50 60 80 00       	mov    0x806050,%eax
  803020:	40                   	inc    %eax
  803021:	a3 50 60 80 00       	mov    %eax,0x806050
  803026:	eb 07                	jmp    80302f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803028:	90                   	nop
  803029:	eb 04                	jmp    80302f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80302b:	90                   	nop
  80302c:	eb 01                	jmp    80302f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80302e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80302f:	c9                   	leave  
  803030:	c3                   	ret    

00803031 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803031:	55                   	push   %ebp
  803032:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803034:	8b 45 10             	mov    0x10(%ebp),%eax
  803037:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803040:	8b 45 0c             	mov    0xc(%ebp),%eax
  803043:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	83 e8 04             	sub    $0x4,%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	83 e0 fe             	and    $0xfffffffe,%eax
  803050:	8d 50 f8             	lea    -0x8(%eax),%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	01 c2                	add    %eax,%edx
  803058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305b:	89 02                	mov    %eax,(%edx)
}
  80305d:	90                   	nop
  80305e:	5d                   	pop    %ebp
  80305f:	c3                   	ret    

00803060 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
  803063:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	83 e0 01             	and    $0x1,%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 03                	je     803073 <alloc_block_FF+0x13>
  803070:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803073:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803077:	77 07                	ja     803080 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803079:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803080:	a1 24 60 80 00       	mov    0x806024,%eax
  803085:	85 c0                	test   %eax,%eax
  803087:	75 73                	jne    8030fc <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	83 c0 10             	add    $0x10,%eax
  80308f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803092:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803099:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309f:	01 d0                	add    %edx,%eax
  8030a1:	48                   	dec    %eax
  8030a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8030ad:	f7 75 ec             	divl   -0x14(%ebp)
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	29 d0                	sub    %edx,%eax
  8030b5:	c1 e8 0c             	shr    $0xc,%eax
  8030b8:	83 ec 0c             	sub    $0xc,%esp
  8030bb:	50                   	push   %eax
  8030bc:	e8 27 f0 ff ff       	call   8020e8 <sbrk>
  8030c1:	83 c4 10             	add    $0x10,%esp
  8030c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8030c7:	83 ec 0c             	sub    $0xc,%esp
  8030ca:	6a 00                	push   $0x0
  8030cc:	e8 17 f0 ff ff       	call   8020e8 <sbrk>
  8030d1:	83 c4 10             	add    $0x10,%esp
  8030d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8030d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030da:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8030dd:	83 ec 08             	sub    $0x8,%esp
  8030e0:	50                   	push   %eax
  8030e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030e4:	e8 5b fd ff ff       	call   802e44 <initialize_dynamic_allocator>
  8030e9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030ec:	83 ec 0c             	sub    $0xc,%esp
  8030ef:	68 3f 59 80 00       	push   $0x80593f
  8030f4:	e8 55 e2 ff ff       	call   80134e <cprintf>
  8030f9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8030fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803100:	75 0a                	jne    80310c <alloc_block_FF+0xac>
	        return NULL;
  803102:	b8 00 00 00 00       	mov    $0x0,%eax
  803107:	e9 0e 04 00 00       	jmp    80351a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80310c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803113:	a1 44 60 80 00       	mov    0x806044,%eax
  803118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311b:	e9 f3 02 00 00       	jmp    803413 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803126:	83 ec 0c             	sub    $0xc,%esp
  803129:	ff 75 bc             	pushl  -0x44(%ebp)
  80312c:	e8 af fb ff ff       	call   802ce0 <get_block_size>
  803131:	83 c4 10             	add    $0x10,%esp
  803134:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	83 c0 08             	add    $0x8,%eax
  80313d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803140:	0f 87 c5 02 00 00    	ja     80340b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	83 c0 18             	add    $0x18,%eax
  80314c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80314f:	0f 87 19 02 00 00    	ja     80336e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803155:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803158:	2b 45 08             	sub    0x8(%ebp),%eax
  80315b:	83 e8 08             	sub    $0x8,%eax
  80315e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	8d 50 08             	lea    0x8(%eax),%edx
  803167:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80316a:	01 d0                	add    %edx,%eax
  80316c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	83 c0 08             	add    $0x8,%eax
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	6a 01                	push   $0x1
  80317a:	50                   	push   %eax
  80317b:	ff 75 bc             	pushl  -0x44(%ebp)
  80317e:	e8 ae fe ff ff       	call   803031 <set_block_data>
  803183:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	75 68                	jne    8031f8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803190:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803194:	75 17                	jne    8031ad <alloc_block_FF+0x14d>
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	68 1c 59 80 00       	push   $0x80591c
  80319e:	68 d7 00 00 00       	push   $0xd7
  8031a3:	68 01 59 80 00       	push   $0x805901
  8031a8:	e8 e4 de ff ff       	call   801091 <_panic>
  8031ad:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8031b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 0d                	je     8031ce <alloc_block_FF+0x16e>
  8031c1:	a1 44 60 80 00       	mov    0x806044,%eax
  8031c6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031c9:	89 50 04             	mov    %edx,0x4(%eax)
  8031cc:	eb 08                	jmp    8031d6 <alloc_block_FF+0x176>
  8031ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d1:	a3 48 60 80 00       	mov    %eax,0x806048
  8031d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d9:	a3 44 60 80 00       	mov    %eax,0x806044
  8031de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e8:	a1 50 60 80 00       	mov    0x806050,%eax
  8031ed:	40                   	inc    %eax
  8031ee:	a3 50 60 80 00       	mov    %eax,0x806050
  8031f3:	e9 dc 00 00 00       	jmp    8032d4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	75 65                	jne    803266 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803201:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803205:	75 17                	jne    80321e <alloc_block_FF+0x1be>
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	68 50 59 80 00       	push   $0x805950
  80320f:	68 db 00 00 00       	push   $0xdb
  803214:	68 01 59 80 00       	push   $0x805901
  803219:	e8 73 de ff ff       	call   801091 <_panic>
  80321e:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803224:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80322d:	8b 40 04             	mov    0x4(%eax),%eax
  803230:	85 c0                	test   %eax,%eax
  803232:	74 0c                	je     803240 <alloc_block_FF+0x1e0>
  803234:	a1 48 60 80 00       	mov    0x806048,%eax
  803239:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	eb 08                	jmp    803248 <alloc_block_FF+0x1e8>
  803240:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803243:	a3 44 60 80 00       	mov    %eax,0x806044
  803248:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80324b:	a3 48 60 80 00       	mov    %eax,0x806048
  803250:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803259:	a1 50 60 80 00       	mov    0x806050,%eax
  80325e:	40                   	inc    %eax
  80325f:	a3 50 60 80 00       	mov    %eax,0x806050
  803264:	eb 6e                	jmp    8032d4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326a:	74 06                	je     803272 <alloc_block_FF+0x212>
  80326c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803270:	75 17                	jne    803289 <alloc_block_FF+0x229>
  803272:	83 ec 04             	sub    $0x4,%esp
  803275:	68 74 59 80 00       	push   $0x805974
  80327a:	68 df 00 00 00       	push   $0xdf
  80327f:	68 01 59 80 00       	push   $0x805901
  803284:	e8 08 de ff ff       	call   801091 <_panic>
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	8b 10                	mov    (%eax),%edx
  80328e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803291:	89 10                	mov    %edx,(%eax)
  803293:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	85 c0                	test   %eax,%eax
  80329a:	74 0b                	je     8032a7 <alloc_block_FF+0x247>
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032a4:	89 50 04             	mov    %edx,0x4(%eax)
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	75 08                	jne    8032c9 <alloc_block_FF+0x269>
  8032c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032c4:	a3 48 60 80 00       	mov    %eax,0x806048
  8032c9:	a1 50 60 80 00       	mov    0x806050,%eax
  8032ce:	40                   	inc    %eax
  8032cf:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8032d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d8:	75 17                	jne    8032f1 <alloc_block_FF+0x291>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 e3 58 80 00       	push   $0x8058e3
  8032e2:	68 e1 00 00 00       	push   $0xe1
  8032e7:	68 01 59 80 00       	push   $0x805901
  8032ec:	e8 a0 dd ff ff       	call   801091 <_panic>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 10                	je     80330a <alloc_block_FF+0x2aa>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803302:	8b 52 04             	mov    0x4(%edx),%edx
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	eb 0b                	jmp    803315 <alloc_block_FF+0x2b5>
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 40 04             	mov    0x4(%eax),%eax
  803310:	a3 48 60 80 00       	mov    %eax,0x806048
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 04             	mov    0x4(%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	74 0f                	je     80332e <alloc_block_FF+0x2ce>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 40 04             	mov    0x4(%eax),%eax
  803325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803328:	8b 12                	mov    (%edx),%edx
  80332a:	89 10                	mov    %edx,(%eax)
  80332c:	eb 0a                	jmp    803338 <alloc_block_FF+0x2d8>
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	a3 44 60 80 00       	mov    %eax,0x806044
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334b:	a1 50 60 80 00       	mov    0x806050,%eax
  803350:	48                   	dec    %eax
  803351:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  803356:	83 ec 04             	sub    $0x4,%esp
  803359:	6a 00                	push   $0x0
  80335b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80335e:	ff 75 b0             	pushl  -0x50(%ebp)
  803361:	e8 cb fc ff ff       	call   803031 <set_block_data>
  803366:	83 c4 10             	add    $0x10,%esp
  803369:	e9 95 00 00 00       	jmp    803403 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80336e:	83 ec 04             	sub    $0x4,%esp
  803371:	6a 01                	push   $0x1
  803373:	ff 75 b8             	pushl  -0x48(%ebp)
  803376:	ff 75 bc             	pushl  -0x44(%ebp)
  803379:	e8 b3 fc ff ff       	call   803031 <set_block_data>
  80337e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803385:	75 17                	jne    80339e <alloc_block_FF+0x33e>
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	68 e3 58 80 00       	push   $0x8058e3
  80338f:	68 e8 00 00 00       	push   $0xe8
  803394:	68 01 59 80 00       	push   $0x805901
  803399:	e8 f3 dc ff ff       	call   801091 <_panic>
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	74 10                	je     8033b7 <alloc_block_FF+0x357>
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033af:	8b 52 04             	mov    0x4(%edx),%edx
  8033b2:	89 50 04             	mov    %edx,0x4(%eax)
  8033b5:	eb 0b                	jmp    8033c2 <alloc_block_FF+0x362>
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	8b 40 04             	mov    0x4(%eax),%eax
  8033bd:	a3 48 60 80 00       	mov    %eax,0x806048
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 0f                	je     8033db <alloc_block_FF+0x37b>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 40 04             	mov    0x4(%eax),%eax
  8033d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d5:	8b 12                	mov    (%edx),%edx
  8033d7:	89 10                	mov    %edx,(%eax)
  8033d9:	eb 0a                	jmp    8033e5 <alloc_block_FF+0x385>
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	a3 44 60 80 00       	mov    %eax,0x806044
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f8:	a1 50 60 80 00       	mov    0x806050,%eax
  8033fd:	48                   	dec    %eax
  8033fe:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  803403:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803406:	e9 0f 01 00 00       	jmp    80351a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80340b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803410:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803417:	74 07                	je     803420 <alloc_block_FF+0x3c0>
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	eb 05                	jmp    803425 <alloc_block_FF+0x3c5>
  803420:	b8 00 00 00 00       	mov    $0x0,%eax
  803425:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80342a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	0f 85 e9 fc ff ff    	jne    803120 <alloc_block_FF+0xc0>
  803437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343b:	0f 85 df fc ff ff    	jne    803120 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	83 c0 08             	add    $0x8,%eax
  803447:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80344a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803451:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803457:	01 d0                	add    %edx,%eax
  803459:	48                   	dec    %eax
  80345a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80345d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803460:	ba 00 00 00 00       	mov    $0x0,%edx
  803465:	f7 75 d8             	divl   -0x28(%ebp)
  803468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346b:	29 d0                	sub    %edx,%eax
  80346d:	c1 e8 0c             	shr    $0xc,%eax
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	50                   	push   %eax
  803474:	e8 6f ec ff ff       	call   8020e8 <sbrk>
  803479:	83 c4 10             	add    $0x10,%esp
  80347c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80347f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803483:	75 0a                	jne    80348f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803485:	b8 00 00 00 00       	mov    $0x0,%eax
  80348a:	e9 8b 00 00 00       	jmp    80351a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80348f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803496:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803499:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	48                   	dec    %eax
  80349f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8034a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034aa:	f7 75 cc             	divl   -0x34(%ebp)
  8034ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034b0:	29 d0                	sub    %edx,%eax
  8034b2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034b8:	01 d0                	add    %edx,%eax
  8034ba:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  8034bf:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034ca:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8034d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034d7:	01 d0                	add    %edx,%eax
  8034d9:	48                   	dec    %eax
  8034da:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8034dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e5:	f7 75 c4             	divl   -0x3c(%ebp)
  8034e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034eb:	29 d0                	sub    %edx,%eax
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	6a 01                	push   $0x1
  8034f2:	50                   	push   %eax
  8034f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8034f6:	e8 36 fb ff ff       	call   803031 <set_block_data>
  8034fb:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8034fe:	83 ec 0c             	sub    $0xc,%esp
  803501:	ff 75 d0             	pushl  -0x30(%ebp)
  803504:	e8 f8 09 00 00       	call   803f01 <free_block>
  803509:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	ff 75 08             	pushl  0x8(%ebp)
  803512:	e8 49 fb ff ff       	call   803060 <alloc_block_FF>
  803517:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80351a:	c9                   	leave  
  80351b:	c3                   	ret    

0080351c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	83 e0 01             	and    $0x1,%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 03                	je     80352f <alloc_block_BF+0x13>
  80352c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80352f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803533:	77 07                	ja     80353c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803535:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80353c:	a1 24 60 80 00       	mov    0x806024,%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	75 73                	jne    8035b8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	83 c0 10             	add    $0x10,%eax
  80354b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80354e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355b:	01 d0                	add    %edx,%eax
  80355d:	48                   	dec    %eax
  80355e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803561:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803564:	ba 00 00 00 00       	mov    $0x0,%edx
  803569:	f7 75 e0             	divl   -0x20(%ebp)
  80356c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80356f:	29 d0                	sub    %edx,%eax
  803571:	c1 e8 0c             	shr    $0xc,%eax
  803574:	83 ec 0c             	sub    $0xc,%esp
  803577:	50                   	push   %eax
  803578:	e8 6b eb ff ff       	call   8020e8 <sbrk>
  80357d:	83 c4 10             	add    $0x10,%esp
  803580:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803583:	83 ec 0c             	sub    $0xc,%esp
  803586:	6a 00                	push   $0x0
  803588:	e8 5b eb ff ff       	call   8020e8 <sbrk>
  80358d:	83 c4 10             	add    $0x10,%esp
  803590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803596:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803599:	83 ec 08             	sub    $0x8,%esp
  80359c:	50                   	push   %eax
  80359d:	ff 75 d8             	pushl  -0x28(%ebp)
  8035a0:	e8 9f f8 ff ff       	call   802e44 <initialize_dynamic_allocator>
  8035a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8035a8:	83 ec 0c             	sub    $0xc,%esp
  8035ab:	68 3f 59 80 00       	push   $0x80593f
  8035b0:	e8 99 dd ff ff       	call   80134e <cprintf>
  8035b5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8035b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8035bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8035c6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8035cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8035d4:	a1 44 60 80 00       	mov    0x806044,%eax
  8035d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035dc:	e9 1d 01 00 00       	jmp    8036fe <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8035e7:	83 ec 0c             	sub    $0xc,%esp
  8035ea:	ff 75 a8             	pushl  -0x58(%ebp)
  8035ed:	e8 ee f6 ff ff       	call   802ce0 <get_block_size>
  8035f2:	83 c4 10             	add    $0x10,%esp
  8035f5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	83 c0 08             	add    $0x8,%eax
  8035fe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803601:	0f 87 ef 00 00 00    	ja     8036f6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	83 c0 18             	add    $0x18,%eax
  80360d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803610:	77 1d                	ja     80362f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803615:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803618:	0f 86 d8 00 00 00    	jbe    8036f6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80361e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803621:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803624:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803627:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80362a:	e9 c7 00 00 00       	jmp    8036f6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80362f:	8b 45 08             	mov    0x8(%ebp),%eax
  803632:	83 c0 08             	add    $0x8,%eax
  803635:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803638:	0f 85 9d 00 00 00    	jne    8036db <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80363e:	83 ec 04             	sub    $0x4,%esp
  803641:	6a 01                	push   $0x1
  803643:	ff 75 a4             	pushl  -0x5c(%ebp)
  803646:	ff 75 a8             	pushl  -0x58(%ebp)
  803649:	e8 e3 f9 ff ff       	call   803031 <set_block_data>
  80364e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803655:	75 17                	jne    80366e <alloc_block_BF+0x152>
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	68 e3 58 80 00       	push   $0x8058e3
  80365f:	68 2c 01 00 00       	push   $0x12c
  803664:	68 01 59 80 00       	push   $0x805901
  803669:	e8 23 da ff ff       	call   801091 <_panic>
  80366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 10                	je     803687 <alloc_block_BF+0x16b>
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80367f:	8b 52 04             	mov    0x4(%edx),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	eb 0b                	jmp    803692 <alloc_block_BF+0x176>
  803687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	a3 48 60 80 00       	mov    %eax,0x806048
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0f                	je     8036ab <alloc_block_BF+0x18f>
  80369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369f:	8b 40 04             	mov    0x4(%eax),%eax
  8036a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a5:	8b 12                	mov    (%edx),%edx
  8036a7:	89 10                	mov    %edx,(%eax)
  8036a9:	eb 0a                	jmp    8036b5 <alloc_block_BF+0x199>
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	a3 44 60 80 00       	mov    %eax,0x806044
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c8:	a1 50 60 80 00       	mov    0x806050,%eax
  8036cd:	48                   	dec    %eax
  8036ce:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  8036d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8036d6:	e9 01 04 00 00       	jmp    803adc <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8036db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036de:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8036e1:	76 13                	jbe    8036f6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8036e3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8036ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8036ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8036f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8036f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8036f6:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8036fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803702:	74 07                	je     80370b <alloc_block_BF+0x1ef>
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	eb 05                	jmp    803710 <alloc_block_BF+0x1f4>
  80370b:	b8 00 00 00 00       	mov    $0x0,%eax
  803710:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803715:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	0f 85 bf fe ff ff    	jne    8035e1 <alloc_block_BF+0xc5>
  803722:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803726:	0f 85 b5 fe ff ff    	jne    8035e1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80372c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803730:	0f 84 26 02 00 00    	je     80395c <alloc_block_BF+0x440>
  803736:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80373a:	0f 85 1c 02 00 00    	jne    80395c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803743:	2b 45 08             	sub    0x8(%ebp),%eax
  803746:	83 e8 08             	sub    $0x8,%eax
  803749:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	8d 50 08             	lea    0x8(%eax),%edx
  803752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803755:	01 d0                	add    %edx,%eax
  803757:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	83 c0 08             	add    $0x8,%eax
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	6a 01                	push   $0x1
  803765:	50                   	push   %eax
  803766:	ff 75 f0             	pushl  -0x10(%ebp)
  803769:	e8 c3 f8 ff ff       	call   803031 <set_block_data>
  80376e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	75 68                	jne    8037e3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80377b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80377f:	75 17                	jne    803798 <alloc_block_BF+0x27c>
  803781:	83 ec 04             	sub    $0x4,%esp
  803784:	68 1c 59 80 00       	push   $0x80591c
  803789:	68 45 01 00 00       	push   $0x145
  80378e:	68 01 59 80 00       	push   $0x805901
  803793:	e8 f9 d8 ff ff       	call   801091 <_panic>
  803798:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80379e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a1:	89 10                	mov    %edx,(%eax)
  8037a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a6:	8b 00                	mov    (%eax),%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	74 0d                	je     8037b9 <alloc_block_BF+0x29d>
  8037ac:	a1 44 60 80 00       	mov    0x806044,%eax
  8037b1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037b4:	89 50 04             	mov    %edx,0x4(%eax)
  8037b7:	eb 08                	jmp    8037c1 <alloc_block_BF+0x2a5>
  8037b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037bc:	a3 48 60 80 00       	mov    %eax,0x806048
  8037c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037c4:	a3 44 60 80 00       	mov    %eax,0x806044
  8037c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d3:	a1 50 60 80 00       	mov    0x806050,%eax
  8037d8:	40                   	inc    %eax
  8037d9:	a3 50 60 80 00       	mov    %eax,0x806050
  8037de:	e9 dc 00 00 00       	jmp    8038bf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8037e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	75 65                	jne    803851 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037f0:	75 17                	jne    803809 <alloc_block_BF+0x2ed>
  8037f2:	83 ec 04             	sub    $0x4,%esp
  8037f5:	68 50 59 80 00       	push   $0x805950
  8037fa:	68 4a 01 00 00       	push   $0x14a
  8037ff:	68 01 59 80 00       	push   $0x805901
  803804:	e8 88 d8 ff ff       	call   801091 <_panic>
  803809:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80380f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803812:	89 50 04             	mov    %edx,0x4(%eax)
  803815:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803818:	8b 40 04             	mov    0x4(%eax),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	74 0c                	je     80382b <alloc_block_BF+0x30f>
  80381f:	a1 48 60 80 00       	mov    0x806048,%eax
  803824:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803827:	89 10                	mov    %edx,(%eax)
  803829:	eb 08                	jmp    803833 <alloc_block_BF+0x317>
  80382b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80382e:	a3 44 60 80 00       	mov    %eax,0x806044
  803833:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803836:	a3 48 60 80 00       	mov    %eax,0x806048
  80383b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80383e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803844:	a1 50 60 80 00       	mov    0x806050,%eax
  803849:	40                   	inc    %eax
  80384a:	a3 50 60 80 00       	mov    %eax,0x806050
  80384f:	eb 6e                	jmp    8038bf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803851:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803855:	74 06                	je     80385d <alloc_block_BF+0x341>
  803857:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80385b:	75 17                	jne    803874 <alloc_block_BF+0x358>
  80385d:	83 ec 04             	sub    $0x4,%esp
  803860:	68 74 59 80 00       	push   $0x805974
  803865:	68 4f 01 00 00       	push   $0x14f
  80386a:	68 01 59 80 00       	push   $0x805901
  80386f:	e8 1d d8 ff ff       	call   801091 <_panic>
  803874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803877:	8b 10                	mov    (%eax),%edx
  803879:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80387c:	89 10                	mov    %edx,(%eax)
  80387e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	85 c0                	test   %eax,%eax
  803885:	74 0b                	je     803892 <alloc_block_BF+0x376>
  803887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80388f:	89 50 04             	mov    %edx,0x4(%eax)
  803892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803895:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803898:	89 10                	mov    %edx,(%eax)
  80389a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80389d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a0:	89 50 04             	mov    %edx,0x4(%eax)
  8038a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	75 08                	jne    8038b4 <alloc_block_BF+0x398>
  8038ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038af:	a3 48 60 80 00       	mov    %eax,0x806048
  8038b4:	a1 50 60 80 00       	mov    0x806050,%eax
  8038b9:	40                   	inc    %eax
  8038ba:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8038bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c3:	75 17                	jne    8038dc <alloc_block_BF+0x3c0>
  8038c5:	83 ec 04             	sub    $0x4,%esp
  8038c8:	68 e3 58 80 00       	push   $0x8058e3
  8038cd:	68 51 01 00 00       	push   $0x151
  8038d2:	68 01 59 80 00       	push   $0x805901
  8038d7:	e8 b5 d7 ff ff       	call   801091 <_panic>
  8038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	85 c0                	test   %eax,%eax
  8038e3:	74 10                	je     8038f5 <alloc_block_BF+0x3d9>
  8038e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ed:	8b 52 04             	mov    0x4(%edx),%edx
  8038f0:	89 50 04             	mov    %edx,0x4(%eax)
  8038f3:	eb 0b                	jmp    803900 <alloc_block_BF+0x3e4>
  8038f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f8:	8b 40 04             	mov    0x4(%eax),%eax
  8038fb:	a3 48 60 80 00       	mov    %eax,0x806048
  803900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803903:	8b 40 04             	mov    0x4(%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 0f                	je     803919 <alloc_block_BF+0x3fd>
  80390a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390d:	8b 40 04             	mov    0x4(%eax),%eax
  803910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803913:	8b 12                	mov    (%edx),%edx
  803915:	89 10                	mov    %edx,(%eax)
  803917:	eb 0a                	jmp    803923 <alloc_block_BF+0x407>
  803919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	a3 44 60 80 00       	mov    %eax,0x806044
  803923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803926:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803936:	a1 50 60 80 00       	mov    0x806050,%eax
  80393b:	48                   	dec    %eax
  80393c:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  803941:	83 ec 04             	sub    $0x4,%esp
  803944:	6a 00                	push   $0x0
  803946:	ff 75 d0             	pushl  -0x30(%ebp)
  803949:	ff 75 cc             	pushl  -0x34(%ebp)
  80394c:	e8 e0 f6 ff ff       	call   803031 <set_block_data>
  803951:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803957:	e9 80 01 00 00       	jmp    803adc <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80395c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803960:	0f 85 9d 00 00 00    	jne    803a03 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803966:	83 ec 04             	sub    $0x4,%esp
  803969:	6a 01                	push   $0x1
  80396b:	ff 75 ec             	pushl  -0x14(%ebp)
  80396e:	ff 75 f0             	pushl  -0x10(%ebp)
  803971:	e8 bb f6 ff ff       	call   803031 <set_block_data>
  803976:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803979:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80397d:	75 17                	jne    803996 <alloc_block_BF+0x47a>
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	68 e3 58 80 00       	push   $0x8058e3
  803987:	68 58 01 00 00       	push   $0x158
  80398c:	68 01 59 80 00       	push   $0x805901
  803991:	e8 fb d6 ff ff       	call   801091 <_panic>
  803996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 10                	je     8039af <alloc_block_BF+0x493>
  80399f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039a7:	8b 52 04             	mov    0x4(%edx),%edx
  8039aa:	89 50 04             	mov    %edx,0x4(%eax)
  8039ad:	eb 0b                	jmp    8039ba <alloc_block_BF+0x49e>
  8039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	a3 48 60 80 00       	mov    %eax,0x806048
  8039ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bd:	8b 40 04             	mov    0x4(%eax),%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	74 0f                	je     8039d3 <alloc_block_BF+0x4b7>
  8039c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039cd:	8b 12                	mov    (%edx),%edx
  8039cf:	89 10                	mov    %edx,(%eax)
  8039d1:	eb 0a                	jmp    8039dd <alloc_block_BF+0x4c1>
  8039d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	a3 44 60 80 00       	mov    %eax,0x806044
  8039dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f0:	a1 50 60 80 00       	mov    0x806050,%eax
  8039f5:	48                   	dec    %eax
  8039f6:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  8039fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fe:	e9 d9 00 00 00       	jmp    803adc <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803a03:	8b 45 08             	mov    0x8(%ebp),%eax
  803a06:	83 c0 08             	add    $0x8,%eax
  803a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a0c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a13:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a19:	01 d0                	add    %edx,%eax
  803a1b:	48                   	dec    %eax
  803a1c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a22:	ba 00 00 00 00       	mov    $0x0,%edx
  803a27:	f7 75 c4             	divl   -0x3c(%ebp)
  803a2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a2d:	29 d0                	sub    %edx,%eax
  803a2f:	c1 e8 0c             	shr    $0xc,%eax
  803a32:	83 ec 0c             	sub    $0xc,%esp
  803a35:	50                   	push   %eax
  803a36:	e8 ad e6 ff ff       	call   8020e8 <sbrk>
  803a3b:	83 c4 10             	add    $0x10,%esp
  803a3e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803a41:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803a45:	75 0a                	jne    803a51 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803a47:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4c:	e9 8b 00 00 00       	jmp    803adc <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803a51:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803a58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5e:	01 d0                	add    %edx,%eax
  803a60:	48                   	dec    %eax
  803a61:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803a64:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803a67:	ba 00 00 00 00       	mov    $0x0,%edx
  803a6c:	f7 75 b8             	divl   -0x48(%ebp)
  803a6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803a72:	29 d0                	sub    %edx,%eax
  803a74:	8d 50 fc             	lea    -0x4(%eax),%edx
  803a77:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a7a:	01 d0                	add    %edx,%eax
  803a7c:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  803a81:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803a86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803a8c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803a93:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a96:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a99:	01 d0                	add    %edx,%eax
  803a9b:	48                   	dec    %eax
  803a9c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a9f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa7:	f7 75 b0             	divl   -0x50(%ebp)
  803aaa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803aad:	29 d0                	sub    %edx,%eax
  803aaf:	83 ec 04             	sub    $0x4,%esp
  803ab2:	6a 01                	push   $0x1
  803ab4:	50                   	push   %eax
  803ab5:	ff 75 bc             	pushl  -0x44(%ebp)
  803ab8:	e8 74 f5 ff ff       	call   803031 <set_block_data>
  803abd:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803ac0:	83 ec 0c             	sub    $0xc,%esp
  803ac3:	ff 75 bc             	pushl  -0x44(%ebp)
  803ac6:	e8 36 04 00 00       	call   803f01 <free_block>
  803acb:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803ace:	83 ec 0c             	sub    $0xc,%esp
  803ad1:	ff 75 08             	pushl  0x8(%ebp)
  803ad4:	e8 43 fa ff ff       	call   80351c <alloc_block_BF>
  803ad9:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803adc:	c9                   	leave  
  803add:	c3                   	ret    

00803ade <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803ade:	55                   	push   %ebp
  803adf:	89 e5                	mov    %esp,%ebp
  803ae1:	53                   	push   %ebx
  803ae2:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803ae5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803aec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803af3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803af7:	74 1e                	je     803b17 <merging+0x39>
  803af9:	ff 75 08             	pushl  0x8(%ebp)
  803afc:	e8 df f1 ff ff       	call   802ce0 <get_block_size>
  803b01:	83 c4 04             	add    $0x4,%esp
  803b04:	89 c2                	mov    %eax,%edx
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	01 d0                	add    %edx,%eax
  803b0b:	3b 45 10             	cmp    0x10(%ebp),%eax
  803b0e:	75 07                	jne    803b17 <merging+0x39>
		prev_is_free = 1;
  803b10:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b1b:	74 1e                	je     803b3b <merging+0x5d>
  803b1d:	ff 75 10             	pushl  0x10(%ebp)
  803b20:	e8 bb f1 ff ff       	call   802ce0 <get_block_size>
  803b25:	83 c4 04             	add    $0x4,%esp
  803b28:	89 c2                	mov    %eax,%edx
  803b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  803b2d:	01 d0                	add    %edx,%eax
  803b2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b32:	75 07                	jne    803b3b <merging+0x5d>
		next_is_free = 1;
  803b34:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b3f:	0f 84 cc 00 00 00    	je     803c11 <merging+0x133>
  803b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b49:	0f 84 c2 00 00 00    	je     803c11 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803b4f:	ff 75 08             	pushl  0x8(%ebp)
  803b52:	e8 89 f1 ff ff       	call   802ce0 <get_block_size>
  803b57:	83 c4 04             	add    $0x4,%esp
  803b5a:	89 c3                	mov    %eax,%ebx
  803b5c:	ff 75 10             	pushl  0x10(%ebp)
  803b5f:	e8 7c f1 ff ff       	call   802ce0 <get_block_size>
  803b64:	83 c4 04             	add    $0x4,%esp
  803b67:	01 c3                	add    %eax,%ebx
  803b69:	ff 75 0c             	pushl  0xc(%ebp)
  803b6c:	e8 6f f1 ff ff       	call   802ce0 <get_block_size>
  803b71:	83 c4 04             	add    $0x4,%esp
  803b74:	01 d8                	add    %ebx,%eax
  803b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b79:	6a 00                	push   $0x0
  803b7b:	ff 75 ec             	pushl  -0x14(%ebp)
  803b7e:	ff 75 08             	pushl  0x8(%ebp)
  803b81:	e8 ab f4 ff ff       	call   803031 <set_block_data>
  803b86:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803b89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b8d:	75 17                	jne    803ba6 <merging+0xc8>
  803b8f:	83 ec 04             	sub    $0x4,%esp
  803b92:	68 e3 58 80 00       	push   $0x8058e3
  803b97:	68 7d 01 00 00       	push   $0x17d
  803b9c:	68 01 59 80 00       	push   $0x805901
  803ba1:	e8 eb d4 ff ff       	call   801091 <_panic>
  803ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba9:	8b 00                	mov    (%eax),%eax
  803bab:	85 c0                	test   %eax,%eax
  803bad:	74 10                	je     803bbf <merging+0xe1>
  803baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb2:	8b 00                	mov    (%eax),%eax
  803bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bb7:	8b 52 04             	mov    0x4(%edx),%edx
  803bba:	89 50 04             	mov    %edx,0x4(%eax)
  803bbd:	eb 0b                	jmp    803bca <merging+0xec>
  803bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc2:	8b 40 04             	mov    0x4(%eax),%eax
  803bc5:	a3 48 60 80 00       	mov    %eax,0x806048
  803bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bcd:	8b 40 04             	mov    0x4(%eax),%eax
  803bd0:	85 c0                	test   %eax,%eax
  803bd2:	74 0f                	je     803be3 <merging+0x105>
  803bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd7:	8b 40 04             	mov    0x4(%eax),%eax
  803bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bdd:	8b 12                	mov    (%edx),%edx
  803bdf:	89 10                	mov    %edx,(%eax)
  803be1:	eb 0a                	jmp    803bed <merging+0x10f>
  803be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	a3 44 60 80 00       	mov    %eax,0x806044
  803bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c00:	a1 50 60 80 00       	mov    0x806050,%eax
  803c05:	48                   	dec    %eax
  803c06:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803c0b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c0c:	e9 ea 02 00 00       	jmp    803efb <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c15:	74 3b                	je     803c52 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803c17:	83 ec 0c             	sub    $0xc,%esp
  803c1a:	ff 75 08             	pushl  0x8(%ebp)
  803c1d:	e8 be f0 ff ff       	call   802ce0 <get_block_size>
  803c22:	83 c4 10             	add    $0x10,%esp
  803c25:	89 c3                	mov    %eax,%ebx
  803c27:	83 ec 0c             	sub    $0xc,%esp
  803c2a:	ff 75 10             	pushl  0x10(%ebp)
  803c2d:	e8 ae f0 ff ff       	call   802ce0 <get_block_size>
  803c32:	83 c4 10             	add    $0x10,%esp
  803c35:	01 d8                	add    %ebx,%eax
  803c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803c3a:	83 ec 04             	sub    $0x4,%esp
  803c3d:	6a 00                	push   $0x0
  803c3f:	ff 75 e8             	pushl  -0x18(%ebp)
  803c42:	ff 75 08             	pushl  0x8(%ebp)
  803c45:	e8 e7 f3 ff ff       	call   803031 <set_block_data>
  803c4a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c4d:	e9 a9 02 00 00       	jmp    803efb <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c56:	0f 84 2d 01 00 00    	je     803d89 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803c5c:	83 ec 0c             	sub    $0xc,%esp
  803c5f:	ff 75 10             	pushl  0x10(%ebp)
  803c62:	e8 79 f0 ff ff       	call   802ce0 <get_block_size>
  803c67:	83 c4 10             	add    $0x10,%esp
  803c6a:	89 c3                	mov    %eax,%ebx
  803c6c:	83 ec 0c             	sub    $0xc,%esp
  803c6f:	ff 75 0c             	pushl  0xc(%ebp)
  803c72:	e8 69 f0 ff ff       	call   802ce0 <get_block_size>
  803c77:	83 c4 10             	add    $0x10,%esp
  803c7a:	01 d8                	add    %ebx,%eax
  803c7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	6a 00                	push   $0x0
  803c84:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c87:	ff 75 10             	pushl  0x10(%ebp)
  803c8a:	e8 a2 f3 ff ff       	call   803031 <set_block_data>
  803c8f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803c92:	8b 45 10             	mov    0x10(%ebp),%eax
  803c95:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c9c:	74 06                	je     803ca4 <merging+0x1c6>
  803c9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ca2:	75 17                	jne    803cbb <merging+0x1dd>
  803ca4:	83 ec 04             	sub    $0x4,%esp
  803ca7:	68 a8 59 80 00       	push   $0x8059a8
  803cac:	68 8d 01 00 00       	push   $0x18d
  803cb1:	68 01 59 80 00       	push   $0x805901
  803cb6:	e8 d6 d3 ff ff       	call   801091 <_panic>
  803cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbe:	8b 50 04             	mov    0x4(%eax),%edx
  803cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc4:	89 50 04             	mov    %edx,0x4(%eax)
  803cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ccd:	89 10                	mov    %edx,(%eax)
  803ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd2:	8b 40 04             	mov    0x4(%eax),%eax
  803cd5:	85 c0                	test   %eax,%eax
  803cd7:	74 0d                	je     803ce6 <merging+0x208>
  803cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdc:	8b 40 04             	mov    0x4(%eax),%eax
  803cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ce2:	89 10                	mov    %edx,(%eax)
  803ce4:	eb 08                	jmp    803cee <merging+0x210>
  803ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce9:	a3 44 60 80 00       	mov    %eax,0x806044
  803cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf4:	89 50 04             	mov    %edx,0x4(%eax)
  803cf7:	a1 50 60 80 00       	mov    0x806050,%eax
  803cfc:	40                   	inc    %eax
  803cfd:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803d02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d06:	75 17                	jne    803d1f <merging+0x241>
  803d08:	83 ec 04             	sub    $0x4,%esp
  803d0b:	68 e3 58 80 00       	push   $0x8058e3
  803d10:	68 8e 01 00 00       	push   $0x18e
  803d15:	68 01 59 80 00       	push   $0x805901
  803d1a:	e8 72 d3 ff ff       	call   801091 <_panic>
  803d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d22:	8b 00                	mov    (%eax),%eax
  803d24:	85 c0                	test   %eax,%eax
  803d26:	74 10                	je     803d38 <merging+0x25a>
  803d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2b:	8b 00                	mov    (%eax),%eax
  803d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d30:	8b 52 04             	mov    0x4(%edx),%edx
  803d33:	89 50 04             	mov    %edx,0x4(%eax)
  803d36:	eb 0b                	jmp    803d43 <merging+0x265>
  803d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3b:	8b 40 04             	mov    0x4(%eax),%eax
  803d3e:	a3 48 60 80 00       	mov    %eax,0x806048
  803d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d46:	8b 40 04             	mov    0x4(%eax),%eax
  803d49:	85 c0                	test   %eax,%eax
  803d4b:	74 0f                	je     803d5c <merging+0x27e>
  803d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d50:	8b 40 04             	mov    0x4(%eax),%eax
  803d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d56:	8b 12                	mov    (%edx),%edx
  803d58:	89 10                	mov    %edx,(%eax)
  803d5a:	eb 0a                	jmp    803d66 <merging+0x288>
  803d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5f:	8b 00                	mov    (%eax),%eax
  803d61:	a3 44 60 80 00       	mov    %eax,0x806044
  803d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d79:	a1 50 60 80 00       	mov    0x806050,%eax
  803d7e:	48                   	dec    %eax
  803d7f:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d84:	e9 72 01 00 00       	jmp    803efb <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803d89:	8b 45 10             	mov    0x10(%ebp),%eax
  803d8c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d93:	74 79                	je     803e0e <merging+0x330>
  803d95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d99:	74 73                	je     803e0e <merging+0x330>
  803d9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d9f:	74 06                	je     803da7 <merging+0x2c9>
  803da1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803da5:	75 17                	jne    803dbe <merging+0x2e0>
  803da7:	83 ec 04             	sub    $0x4,%esp
  803daa:	68 74 59 80 00       	push   $0x805974
  803daf:	68 94 01 00 00       	push   $0x194
  803db4:	68 01 59 80 00       	push   $0x805901
  803db9:	e8 d3 d2 ff ff       	call   801091 <_panic>
  803dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc1:	8b 10                	mov    (%eax),%edx
  803dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc6:	89 10                	mov    %edx,(%eax)
  803dc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dcb:	8b 00                	mov    (%eax),%eax
  803dcd:	85 c0                	test   %eax,%eax
  803dcf:	74 0b                	je     803ddc <merging+0x2fe>
  803dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd4:	8b 00                	mov    (%eax),%eax
  803dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dd9:	89 50 04             	mov    %edx,0x4(%eax)
  803ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ddf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803de2:	89 10                	mov    %edx,(%eax)
  803de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de7:	8b 55 08             	mov    0x8(%ebp),%edx
  803dea:	89 50 04             	mov    %edx,0x4(%eax)
  803ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df0:	8b 00                	mov    (%eax),%eax
  803df2:	85 c0                	test   %eax,%eax
  803df4:	75 08                	jne    803dfe <merging+0x320>
  803df6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df9:	a3 48 60 80 00       	mov    %eax,0x806048
  803dfe:	a1 50 60 80 00       	mov    0x806050,%eax
  803e03:	40                   	inc    %eax
  803e04:	a3 50 60 80 00       	mov    %eax,0x806050
  803e09:	e9 ce 00 00 00       	jmp    803edc <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803e0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e12:	74 65                	je     803e79 <merging+0x39b>
  803e14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e18:	75 17                	jne    803e31 <merging+0x353>
  803e1a:	83 ec 04             	sub    $0x4,%esp
  803e1d:	68 50 59 80 00       	push   $0x805950
  803e22:	68 95 01 00 00       	push   $0x195
  803e27:	68 01 59 80 00       	push   $0x805901
  803e2c:	e8 60 d2 ff ff       	call   801091 <_panic>
  803e31:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3a:	89 50 04             	mov    %edx,0x4(%eax)
  803e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e40:	8b 40 04             	mov    0x4(%eax),%eax
  803e43:	85 c0                	test   %eax,%eax
  803e45:	74 0c                	je     803e53 <merging+0x375>
  803e47:	a1 48 60 80 00       	mov    0x806048,%eax
  803e4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e4f:	89 10                	mov    %edx,(%eax)
  803e51:	eb 08                	jmp    803e5b <merging+0x37d>
  803e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e56:	a3 44 60 80 00       	mov    %eax,0x806044
  803e5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5e:	a3 48 60 80 00       	mov    %eax,0x806048
  803e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e6c:	a1 50 60 80 00       	mov    0x806050,%eax
  803e71:	40                   	inc    %eax
  803e72:	a3 50 60 80 00       	mov    %eax,0x806050
  803e77:	eb 63                	jmp    803edc <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803e79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e7d:	75 17                	jne    803e96 <merging+0x3b8>
  803e7f:	83 ec 04             	sub    $0x4,%esp
  803e82:	68 1c 59 80 00       	push   $0x80591c
  803e87:	68 98 01 00 00       	push   $0x198
  803e8c:	68 01 59 80 00       	push   $0x805901
  803e91:	e8 fb d1 ff ff       	call   801091 <_panic>
  803e96:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803e9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e9f:	89 10                	mov    %edx,(%eax)
  803ea1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea4:	8b 00                	mov    (%eax),%eax
  803ea6:	85 c0                	test   %eax,%eax
  803ea8:	74 0d                	je     803eb7 <merging+0x3d9>
  803eaa:	a1 44 60 80 00       	mov    0x806044,%eax
  803eaf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eb2:	89 50 04             	mov    %edx,0x4(%eax)
  803eb5:	eb 08                	jmp    803ebf <merging+0x3e1>
  803eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eba:	a3 48 60 80 00       	mov    %eax,0x806048
  803ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec2:	a3 44 60 80 00       	mov    %eax,0x806044
  803ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ed1:	a1 50 60 80 00       	mov    0x806050,%eax
  803ed6:	40                   	inc    %eax
  803ed7:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803edc:	83 ec 0c             	sub    $0xc,%esp
  803edf:	ff 75 10             	pushl  0x10(%ebp)
  803ee2:	e8 f9 ed ff ff       	call   802ce0 <get_block_size>
  803ee7:	83 c4 10             	add    $0x10,%esp
  803eea:	83 ec 04             	sub    $0x4,%esp
  803eed:	6a 00                	push   $0x0
  803eef:	50                   	push   %eax
  803ef0:	ff 75 10             	pushl  0x10(%ebp)
  803ef3:	e8 39 f1 ff ff       	call   803031 <set_block_data>
  803ef8:	83 c4 10             	add    $0x10,%esp
	}
}
  803efb:	90                   	nop
  803efc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803eff:	c9                   	leave  
  803f00:	c3                   	ret    

00803f01 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803f01:	55                   	push   %ebp
  803f02:	89 e5                	mov    %esp,%ebp
  803f04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803f07:	a1 44 60 80 00       	mov    0x806044,%eax
  803f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803f0f:	a1 48 60 80 00       	mov    0x806048,%eax
  803f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f17:	73 1b                	jae    803f34 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803f19:	a1 48 60 80 00       	mov    0x806048,%eax
  803f1e:	83 ec 04             	sub    $0x4,%esp
  803f21:	ff 75 08             	pushl  0x8(%ebp)
  803f24:	6a 00                	push   $0x0
  803f26:	50                   	push   %eax
  803f27:	e8 b2 fb ff ff       	call   803ade <merging>
  803f2c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f2f:	e9 8b 00 00 00       	jmp    803fbf <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803f34:	a1 44 60 80 00       	mov    0x806044,%eax
  803f39:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f3c:	76 18                	jbe    803f56 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803f3e:	a1 44 60 80 00       	mov    0x806044,%eax
  803f43:	83 ec 04             	sub    $0x4,%esp
  803f46:	ff 75 08             	pushl  0x8(%ebp)
  803f49:	50                   	push   %eax
  803f4a:	6a 00                	push   $0x0
  803f4c:	e8 8d fb ff ff       	call   803ade <merging>
  803f51:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f54:	eb 69                	jmp    803fbf <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f56:	a1 44 60 80 00       	mov    0x806044,%eax
  803f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f5e:	eb 39                	jmp    803f99 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f63:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f66:	73 29                	jae    803f91 <free_block+0x90>
  803f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6b:	8b 00                	mov    (%eax),%eax
  803f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f70:	76 1f                	jbe    803f91 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f75:	8b 00                	mov    (%eax),%eax
  803f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803f7a:	83 ec 04             	sub    $0x4,%esp
  803f7d:	ff 75 08             	pushl  0x8(%ebp)
  803f80:	ff 75 f0             	pushl  -0x10(%ebp)
  803f83:	ff 75 f4             	pushl  -0xc(%ebp)
  803f86:	e8 53 fb ff ff       	call   803ade <merging>
  803f8b:	83 c4 10             	add    $0x10,%esp
			break;
  803f8e:	90                   	nop
		}
	}
}
  803f8f:	eb 2e                	jmp    803fbf <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f91:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f9d:	74 07                	je     803fa6 <free_block+0xa5>
  803f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa2:	8b 00                	mov    (%eax),%eax
  803fa4:	eb 05                	jmp    803fab <free_block+0xaa>
  803fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  803fab:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803fb0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803fb5:	85 c0                	test   %eax,%eax
  803fb7:	75 a7                	jne    803f60 <free_block+0x5f>
  803fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fbd:	75 a1                	jne    803f60 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fbf:	90                   	nop
  803fc0:	c9                   	leave  
  803fc1:	c3                   	ret    

00803fc2 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803fc2:	55                   	push   %ebp
  803fc3:	89 e5                	mov    %esp,%ebp
  803fc5:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803fc8:	ff 75 08             	pushl  0x8(%ebp)
  803fcb:	e8 10 ed ff ff       	call   802ce0 <get_block_size>
  803fd0:	83 c4 04             	add    $0x4,%esp
  803fd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803fdd:	eb 17                	jmp    803ff6 <copy_data+0x34>
  803fdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe5:	01 c2                	add    %eax,%edx
  803fe7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803fea:	8b 45 08             	mov    0x8(%ebp),%eax
  803fed:	01 c8                	add    %ecx,%eax
  803fef:	8a 00                	mov    (%eax),%al
  803ff1:	88 02                	mov    %al,(%edx)
  803ff3:	ff 45 fc             	incl   -0x4(%ebp)
  803ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ff9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803ffc:	72 e1                	jb     803fdf <copy_data+0x1d>
}
  803ffe:	90                   	nop
  803fff:	c9                   	leave  
  804000:	c3                   	ret    

00804001 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804001:	55                   	push   %ebp
  804002:	89 e5                	mov    %esp,%ebp
  804004:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80400b:	75 23                	jne    804030 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80400d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804011:	74 13                	je     804026 <realloc_block_FF+0x25>
  804013:	83 ec 0c             	sub    $0xc,%esp
  804016:	ff 75 0c             	pushl  0xc(%ebp)
  804019:	e8 42 f0 ff ff       	call   803060 <alloc_block_FF>
  80401e:	83 c4 10             	add    $0x10,%esp
  804021:	e9 e4 06 00 00       	jmp    80470a <realloc_block_FF+0x709>
		return NULL;
  804026:	b8 00 00 00 00       	mov    $0x0,%eax
  80402b:	e9 da 06 00 00       	jmp    80470a <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  804030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804034:	75 18                	jne    80404e <realloc_block_FF+0x4d>
	{
		free_block(va);
  804036:	83 ec 0c             	sub    $0xc,%esp
  804039:	ff 75 08             	pushl  0x8(%ebp)
  80403c:	e8 c0 fe ff ff       	call   803f01 <free_block>
  804041:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804044:	b8 00 00 00 00       	mov    $0x0,%eax
  804049:	e9 bc 06 00 00       	jmp    80470a <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80404e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804052:	77 07                	ja     80405b <realloc_block_FF+0x5a>
  804054:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80405b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80405e:	83 e0 01             	and    $0x1,%eax
  804061:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  804064:	8b 45 0c             	mov    0xc(%ebp),%eax
  804067:	83 c0 08             	add    $0x8,%eax
  80406a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80406d:	83 ec 0c             	sub    $0xc,%esp
  804070:	ff 75 08             	pushl  0x8(%ebp)
  804073:	e8 68 ec ff ff       	call   802ce0 <get_block_size>
  804078:	83 c4 10             	add    $0x10,%esp
  80407b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80407e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804081:	83 e8 08             	sub    $0x8,%eax
  804084:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804087:	8b 45 08             	mov    0x8(%ebp),%eax
  80408a:	83 e8 04             	sub    $0x4,%eax
  80408d:	8b 00                	mov    (%eax),%eax
  80408f:	83 e0 fe             	and    $0xfffffffe,%eax
  804092:	89 c2                	mov    %eax,%edx
  804094:	8b 45 08             	mov    0x8(%ebp),%eax
  804097:	01 d0                	add    %edx,%eax
  804099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80409c:	83 ec 0c             	sub    $0xc,%esp
  80409f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040a2:	e8 39 ec ff ff       	call   802ce0 <get_block_size>
  8040a7:	83 c4 10             	add    $0x10,%esp
  8040aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040b0:	83 e8 08             	sub    $0x8,%eax
  8040b3:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8040b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040bc:	75 08                	jne    8040c6 <realloc_block_FF+0xc5>
	{
		 return va;
  8040be:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c1:	e9 44 06 00 00       	jmp    80470a <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8040c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040cc:	0f 83 d5 03 00 00    	jae    8044a7 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8040d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040d5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8040d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8040db:	83 ec 0c             	sub    $0xc,%esp
  8040de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040e1:	e8 13 ec ff ff       	call   802cf9 <is_free_block>
  8040e6:	83 c4 10             	add    $0x10,%esp
  8040e9:	84 c0                	test   %al,%al
  8040eb:	0f 84 3b 01 00 00    	je     80422c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8040f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040f7:	01 d0                	add    %edx,%eax
  8040f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8040fc:	83 ec 04             	sub    $0x4,%esp
  8040ff:	6a 01                	push   $0x1
  804101:	ff 75 f0             	pushl  -0x10(%ebp)
  804104:	ff 75 08             	pushl  0x8(%ebp)
  804107:	e8 25 ef ff ff       	call   803031 <set_block_data>
  80410c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80410f:	8b 45 08             	mov    0x8(%ebp),%eax
  804112:	83 e8 04             	sub    $0x4,%eax
  804115:	8b 00                	mov    (%eax),%eax
  804117:	83 e0 fe             	and    $0xfffffffe,%eax
  80411a:	89 c2                	mov    %eax,%edx
  80411c:	8b 45 08             	mov    0x8(%ebp),%eax
  80411f:	01 d0                	add    %edx,%eax
  804121:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804124:	83 ec 04             	sub    $0x4,%esp
  804127:	6a 00                	push   $0x0
  804129:	ff 75 cc             	pushl  -0x34(%ebp)
  80412c:	ff 75 c8             	pushl  -0x38(%ebp)
  80412f:	e8 fd ee ff ff       	call   803031 <set_block_data>
  804134:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804137:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80413b:	74 06                	je     804143 <realloc_block_FF+0x142>
  80413d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804141:	75 17                	jne    80415a <realloc_block_FF+0x159>
  804143:	83 ec 04             	sub    $0x4,%esp
  804146:	68 74 59 80 00       	push   $0x805974
  80414b:	68 f6 01 00 00       	push   $0x1f6
  804150:	68 01 59 80 00       	push   $0x805901
  804155:	e8 37 cf ff ff       	call   801091 <_panic>
  80415a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415d:	8b 10                	mov    (%eax),%edx
  80415f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804162:	89 10                	mov    %edx,(%eax)
  804164:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804167:	8b 00                	mov    (%eax),%eax
  804169:	85 c0                	test   %eax,%eax
  80416b:	74 0b                	je     804178 <realloc_block_FF+0x177>
  80416d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804170:	8b 00                	mov    (%eax),%eax
  804172:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804175:	89 50 04             	mov    %edx,0x4(%eax)
  804178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80417e:	89 10                	mov    %edx,(%eax)
  804180:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804183:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804186:	89 50 04             	mov    %edx,0x4(%eax)
  804189:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80418c:	8b 00                	mov    (%eax),%eax
  80418e:	85 c0                	test   %eax,%eax
  804190:	75 08                	jne    80419a <realloc_block_FF+0x199>
  804192:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804195:	a3 48 60 80 00       	mov    %eax,0x806048
  80419a:	a1 50 60 80 00       	mov    0x806050,%eax
  80419f:	40                   	inc    %eax
  8041a0:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041a9:	75 17                	jne    8041c2 <realloc_block_FF+0x1c1>
  8041ab:	83 ec 04             	sub    $0x4,%esp
  8041ae:	68 e3 58 80 00       	push   $0x8058e3
  8041b3:	68 f7 01 00 00       	push   $0x1f7
  8041b8:	68 01 59 80 00       	push   $0x805901
  8041bd:	e8 cf ce ff ff       	call   801091 <_panic>
  8041c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c5:	8b 00                	mov    (%eax),%eax
  8041c7:	85 c0                	test   %eax,%eax
  8041c9:	74 10                	je     8041db <realloc_block_FF+0x1da>
  8041cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ce:	8b 00                	mov    (%eax),%eax
  8041d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041d3:	8b 52 04             	mov    0x4(%edx),%edx
  8041d6:	89 50 04             	mov    %edx,0x4(%eax)
  8041d9:	eb 0b                	jmp    8041e6 <realloc_block_FF+0x1e5>
  8041db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041de:	8b 40 04             	mov    0x4(%eax),%eax
  8041e1:	a3 48 60 80 00       	mov    %eax,0x806048
  8041e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e9:	8b 40 04             	mov    0x4(%eax),%eax
  8041ec:	85 c0                	test   %eax,%eax
  8041ee:	74 0f                	je     8041ff <realloc_block_FF+0x1fe>
  8041f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f3:	8b 40 04             	mov    0x4(%eax),%eax
  8041f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041f9:	8b 12                	mov    (%edx),%edx
  8041fb:	89 10                	mov    %edx,(%eax)
  8041fd:	eb 0a                	jmp    804209 <realloc_block_FF+0x208>
  8041ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804202:	8b 00                	mov    (%eax),%eax
  804204:	a3 44 60 80 00       	mov    %eax,0x806044
  804209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80420c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80421c:	a1 50 60 80 00       	mov    0x806050,%eax
  804221:	48                   	dec    %eax
  804222:	a3 50 60 80 00       	mov    %eax,0x806050
  804227:	e9 73 02 00 00       	jmp    80449f <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80422c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804230:	0f 86 69 02 00 00    	jbe    80449f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804236:	83 ec 04             	sub    $0x4,%esp
  804239:	6a 01                	push   $0x1
  80423b:	ff 75 f0             	pushl  -0x10(%ebp)
  80423e:	ff 75 08             	pushl  0x8(%ebp)
  804241:	e8 eb ed ff ff       	call   803031 <set_block_data>
  804246:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804249:	8b 45 08             	mov    0x8(%ebp),%eax
  80424c:	83 e8 04             	sub    $0x4,%eax
  80424f:	8b 00                	mov    (%eax),%eax
  804251:	83 e0 fe             	and    $0xfffffffe,%eax
  804254:	89 c2                	mov    %eax,%edx
  804256:	8b 45 08             	mov    0x8(%ebp),%eax
  804259:	01 d0                	add    %edx,%eax
  80425b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80425e:	a1 50 60 80 00       	mov    0x806050,%eax
  804263:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804266:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80426a:	75 68                	jne    8042d4 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80426c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804270:	75 17                	jne    804289 <realloc_block_FF+0x288>
  804272:	83 ec 04             	sub    $0x4,%esp
  804275:	68 1c 59 80 00       	push   $0x80591c
  80427a:	68 06 02 00 00       	push   $0x206
  80427f:	68 01 59 80 00       	push   $0x805901
  804284:	e8 08 ce ff ff       	call   801091 <_panic>
  804289:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80428f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804292:	89 10                	mov    %edx,(%eax)
  804294:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804297:	8b 00                	mov    (%eax),%eax
  804299:	85 c0                	test   %eax,%eax
  80429b:	74 0d                	je     8042aa <realloc_block_FF+0x2a9>
  80429d:	a1 44 60 80 00       	mov    0x806044,%eax
  8042a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042a5:	89 50 04             	mov    %edx,0x4(%eax)
  8042a8:	eb 08                	jmp    8042b2 <realloc_block_FF+0x2b1>
  8042aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ad:	a3 48 60 80 00       	mov    %eax,0x806048
  8042b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b5:	a3 44 60 80 00       	mov    %eax,0x806044
  8042ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042c4:	a1 50 60 80 00       	mov    0x806050,%eax
  8042c9:	40                   	inc    %eax
  8042ca:	a3 50 60 80 00       	mov    %eax,0x806050
  8042cf:	e9 b0 01 00 00       	jmp    804484 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8042d4:	a1 44 60 80 00       	mov    0x806044,%eax
  8042d9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042dc:	76 68                	jbe    804346 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042e2:	75 17                	jne    8042fb <realloc_block_FF+0x2fa>
  8042e4:	83 ec 04             	sub    $0x4,%esp
  8042e7:	68 1c 59 80 00       	push   $0x80591c
  8042ec:	68 0b 02 00 00       	push   $0x20b
  8042f1:	68 01 59 80 00       	push   $0x805901
  8042f6:	e8 96 cd ff ff       	call   801091 <_panic>
  8042fb:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804301:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804304:	89 10                	mov    %edx,(%eax)
  804306:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804309:	8b 00                	mov    (%eax),%eax
  80430b:	85 c0                	test   %eax,%eax
  80430d:	74 0d                	je     80431c <realloc_block_FF+0x31b>
  80430f:	a1 44 60 80 00       	mov    0x806044,%eax
  804314:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804317:	89 50 04             	mov    %edx,0x4(%eax)
  80431a:	eb 08                	jmp    804324 <realloc_block_FF+0x323>
  80431c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80431f:	a3 48 60 80 00       	mov    %eax,0x806048
  804324:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804327:	a3 44 60 80 00       	mov    %eax,0x806044
  80432c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80432f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804336:	a1 50 60 80 00       	mov    0x806050,%eax
  80433b:	40                   	inc    %eax
  80433c:	a3 50 60 80 00       	mov    %eax,0x806050
  804341:	e9 3e 01 00 00       	jmp    804484 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804346:	a1 44 60 80 00       	mov    0x806044,%eax
  80434b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80434e:	73 68                	jae    8043b8 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804350:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804354:	75 17                	jne    80436d <realloc_block_FF+0x36c>
  804356:	83 ec 04             	sub    $0x4,%esp
  804359:	68 50 59 80 00       	push   $0x805950
  80435e:	68 10 02 00 00       	push   $0x210
  804363:	68 01 59 80 00       	push   $0x805901
  804368:	e8 24 cd ff ff       	call   801091 <_panic>
  80436d:	8b 15 48 60 80 00    	mov    0x806048,%edx
  804373:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804376:	89 50 04             	mov    %edx,0x4(%eax)
  804379:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80437c:	8b 40 04             	mov    0x4(%eax),%eax
  80437f:	85 c0                	test   %eax,%eax
  804381:	74 0c                	je     80438f <realloc_block_FF+0x38e>
  804383:	a1 48 60 80 00       	mov    0x806048,%eax
  804388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80438b:	89 10                	mov    %edx,(%eax)
  80438d:	eb 08                	jmp    804397 <realloc_block_FF+0x396>
  80438f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804392:	a3 44 60 80 00       	mov    %eax,0x806044
  804397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80439a:	a3 48 60 80 00       	mov    %eax,0x806048
  80439f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043a8:	a1 50 60 80 00       	mov    0x806050,%eax
  8043ad:	40                   	inc    %eax
  8043ae:	a3 50 60 80 00       	mov    %eax,0x806050
  8043b3:	e9 cc 00 00 00       	jmp    804484 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8043b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8043bf:	a1 44 60 80 00       	mov    0x806044,%eax
  8043c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043c7:	e9 8a 00 00 00       	jmp    804456 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043d2:	73 7a                	jae    80444e <realloc_block_FF+0x44d>
  8043d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d7:	8b 00                	mov    (%eax),%eax
  8043d9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043dc:	73 70                	jae    80444e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8043de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043e2:	74 06                	je     8043ea <realloc_block_FF+0x3e9>
  8043e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043e8:	75 17                	jne    804401 <realloc_block_FF+0x400>
  8043ea:	83 ec 04             	sub    $0x4,%esp
  8043ed:	68 74 59 80 00       	push   $0x805974
  8043f2:	68 1a 02 00 00       	push   $0x21a
  8043f7:	68 01 59 80 00       	push   $0x805901
  8043fc:	e8 90 cc ff ff       	call   801091 <_panic>
  804401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804404:	8b 10                	mov    (%eax),%edx
  804406:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804409:	89 10                	mov    %edx,(%eax)
  80440b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80440e:	8b 00                	mov    (%eax),%eax
  804410:	85 c0                	test   %eax,%eax
  804412:	74 0b                	je     80441f <realloc_block_FF+0x41e>
  804414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804417:	8b 00                	mov    (%eax),%eax
  804419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80441c:	89 50 04             	mov    %edx,0x4(%eax)
  80441f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804422:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804425:	89 10                	mov    %edx,(%eax)
  804427:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80442a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80442d:	89 50 04             	mov    %edx,0x4(%eax)
  804430:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804433:	8b 00                	mov    (%eax),%eax
  804435:	85 c0                	test   %eax,%eax
  804437:	75 08                	jne    804441 <realloc_block_FF+0x440>
  804439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80443c:	a3 48 60 80 00       	mov    %eax,0x806048
  804441:	a1 50 60 80 00       	mov    0x806050,%eax
  804446:	40                   	inc    %eax
  804447:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  80444c:	eb 36                	jmp    804484 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80444e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80445a:	74 07                	je     804463 <realloc_block_FF+0x462>
  80445c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80445f:	8b 00                	mov    (%eax),%eax
  804461:	eb 05                	jmp    804468 <realloc_block_FF+0x467>
  804463:	b8 00 00 00 00       	mov    $0x0,%eax
  804468:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80446d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804472:	85 c0                	test   %eax,%eax
  804474:	0f 85 52 ff ff ff    	jne    8043cc <realloc_block_FF+0x3cb>
  80447a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80447e:	0f 85 48 ff ff ff    	jne    8043cc <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804484:	83 ec 04             	sub    $0x4,%esp
  804487:	6a 00                	push   $0x0
  804489:	ff 75 d8             	pushl  -0x28(%ebp)
  80448c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80448f:	e8 9d eb ff ff       	call   803031 <set_block_data>
  804494:	83 c4 10             	add    $0x10,%esp
				return va;
  804497:	8b 45 08             	mov    0x8(%ebp),%eax
  80449a:	e9 6b 02 00 00       	jmp    80470a <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80449f:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a2:	e9 63 02 00 00       	jmp    80470a <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8044a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044aa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8044ad:	0f 86 4d 02 00 00    	jbe    804700 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8044b3:	83 ec 0c             	sub    $0xc,%esp
  8044b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8044b9:	e8 3b e8 ff ff       	call   802cf9 <is_free_block>
  8044be:	83 c4 10             	add    $0x10,%esp
  8044c1:	84 c0                	test   %al,%al
  8044c3:	0f 84 37 02 00 00    	je     804700 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8044c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044cc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8044cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8044d2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8044d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8044d8:	76 38                	jbe    804512 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8044da:	83 ec 0c             	sub    $0xc,%esp
  8044dd:	ff 75 0c             	pushl  0xc(%ebp)
  8044e0:	e8 7b eb ff ff       	call   803060 <alloc_block_FF>
  8044e5:	83 c4 10             	add    $0x10,%esp
  8044e8:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8044eb:	83 ec 08             	sub    $0x8,%esp
  8044ee:	ff 75 c0             	pushl  -0x40(%ebp)
  8044f1:	ff 75 08             	pushl  0x8(%ebp)
  8044f4:	e8 c9 fa ff ff       	call   803fc2 <copy_data>
  8044f9:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8044fc:	83 ec 0c             	sub    $0xc,%esp
  8044ff:	ff 75 08             	pushl  0x8(%ebp)
  804502:	e8 fa f9 ff ff       	call   803f01 <free_block>
  804507:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80450a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80450d:	e9 f8 01 00 00       	jmp    80470a <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804515:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804518:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80451b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80451f:	0f 87 a0 00 00 00    	ja     8045c5 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804529:	75 17                	jne    804542 <realloc_block_FF+0x541>
  80452b:	83 ec 04             	sub    $0x4,%esp
  80452e:	68 e3 58 80 00       	push   $0x8058e3
  804533:	68 38 02 00 00       	push   $0x238
  804538:	68 01 59 80 00       	push   $0x805901
  80453d:	e8 4f cb ff ff       	call   801091 <_panic>
  804542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804545:	8b 00                	mov    (%eax),%eax
  804547:	85 c0                	test   %eax,%eax
  804549:	74 10                	je     80455b <realloc_block_FF+0x55a>
  80454b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80454e:	8b 00                	mov    (%eax),%eax
  804550:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804553:	8b 52 04             	mov    0x4(%edx),%edx
  804556:	89 50 04             	mov    %edx,0x4(%eax)
  804559:	eb 0b                	jmp    804566 <realloc_block_FF+0x565>
  80455b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80455e:	8b 40 04             	mov    0x4(%eax),%eax
  804561:	a3 48 60 80 00       	mov    %eax,0x806048
  804566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804569:	8b 40 04             	mov    0x4(%eax),%eax
  80456c:	85 c0                	test   %eax,%eax
  80456e:	74 0f                	je     80457f <realloc_block_FF+0x57e>
  804570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804573:	8b 40 04             	mov    0x4(%eax),%eax
  804576:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804579:	8b 12                	mov    (%edx),%edx
  80457b:	89 10                	mov    %edx,(%eax)
  80457d:	eb 0a                	jmp    804589 <realloc_block_FF+0x588>
  80457f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804582:	8b 00                	mov    (%eax),%eax
  804584:	a3 44 60 80 00       	mov    %eax,0x806044
  804589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80458c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80459c:	a1 50 60 80 00       	mov    0x806050,%eax
  8045a1:	48                   	dec    %eax
  8045a2:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8045a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045ad:	01 d0                	add    %edx,%eax
  8045af:	83 ec 04             	sub    $0x4,%esp
  8045b2:	6a 01                	push   $0x1
  8045b4:	50                   	push   %eax
  8045b5:	ff 75 08             	pushl  0x8(%ebp)
  8045b8:	e8 74 ea ff ff       	call   803031 <set_block_data>
  8045bd:	83 c4 10             	add    $0x10,%esp
  8045c0:	e9 36 01 00 00       	jmp    8046fb <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8045c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8045cb:	01 d0                	add    %edx,%eax
  8045cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8045d0:	83 ec 04             	sub    $0x4,%esp
  8045d3:	6a 01                	push   $0x1
  8045d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8045d8:	ff 75 08             	pushl  0x8(%ebp)
  8045db:	e8 51 ea ff ff       	call   803031 <set_block_data>
  8045e0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8045e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e6:	83 e8 04             	sub    $0x4,%eax
  8045e9:	8b 00                	mov    (%eax),%eax
  8045eb:	83 e0 fe             	and    $0xfffffffe,%eax
  8045ee:	89 c2                	mov    %eax,%edx
  8045f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045f3:	01 d0                	add    %edx,%eax
  8045f5:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8045f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045fc:	74 06                	je     804604 <realloc_block_FF+0x603>
  8045fe:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804602:	75 17                	jne    80461b <realloc_block_FF+0x61a>
  804604:	83 ec 04             	sub    $0x4,%esp
  804607:	68 74 59 80 00       	push   $0x805974
  80460c:	68 44 02 00 00       	push   $0x244
  804611:	68 01 59 80 00       	push   $0x805901
  804616:	e8 76 ca ff ff       	call   801091 <_panic>
  80461b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80461e:	8b 10                	mov    (%eax),%edx
  804620:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804623:	89 10                	mov    %edx,(%eax)
  804625:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804628:	8b 00                	mov    (%eax),%eax
  80462a:	85 c0                	test   %eax,%eax
  80462c:	74 0b                	je     804639 <realloc_block_FF+0x638>
  80462e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804631:	8b 00                	mov    (%eax),%eax
  804633:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804636:	89 50 04             	mov    %edx,0x4(%eax)
  804639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80463c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80463f:	89 10                	mov    %edx,(%eax)
  804641:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804647:	89 50 04             	mov    %edx,0x4(%eax)
  80464a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80464d:	8b 00                	mov    (%eax),%eax
  80464f:	85 c0                	test   %eax,%eax
  804651:	75 08                	jne    80465b <realloc_block_FF+0x65a>
  804653:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804656:	a3 48 60 80 00       	mov    %eax,0x806048
  80465b:	a1 50 60 80 00       	mov    0x806050,%eax
  804660:	40                   	inc    %eax
  804661:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80466a:	75 17                	jne    804683 <realloc_block_FF+0x682>
  80466c:	83 ec 04             	sub    $0x4,%esp
  80466f:	68 e3 58 80 00       	push   $0x8058e3
  804674:	68 45 02 00 00       	push   $0x245
  804679:	68 01 59 80 00       	push   $0x805901
  80467e:	e8 0e ca ff ff       	call   801091 <_panic>
  804683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804686:	8b 00                	mov    (%eax),%eax
  804688:	85 c0                	test   %eax,%eax
  80468a:	74 10                	je     80469c <realloc_block_FF+0x69b>
  80468c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80468f:	8b 00                	mov    (%eax),%eax
  804691:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804694:	8b 52 04             	mov    0x4(%edx),%edx
  804697:	89 50 04             	mov    %edx,0x4(%eax)
  80469a:	eb 0b                	jmp    8046a7 <realloc_block_FF+0x6a6>
  80469c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80469f:	8b 40 04             	mov    0x4(%eax),%eax
  8046a2:	a3 48 60 80 00       	mov    %eax,0x806048
  8046a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046aa:	8b 40 04             	mov    0x4(%eax),%eax
  8046ad:	85 c0                	test   %eax,%eax
  8046af:	74 0f                	je     8046c0 <realloc_block_FF+0x6bf>
  8046b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046b4:	8b 40 04             	mov    0x4(%eax),%eax
  8046b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046ba:	8b 12                	mov    (%edx),%edx
  8046bc:	89 10                	mov    %edx,(%eax)
  8046be:	eb 0a                	jmp    8046ca <realloc_block_FF+0x6c9>
  8046c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046c3:	8b 00                	mov    (%eax),%eax
  8046c5:	a3 44 60 80 00       	mov    %eax,0x806044
  8046ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046dd:	a1 50 60 80 00       	mov    0x806050,%eax
  8046e2:	48                   	dec    %eax
  8046e3:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  8046e8:	83 ec 04             	sub    $0x4,%esp
  8046eb:	6a 00                	push   $0x0
  8046ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8046f0:	ff 75 b8             	pushl  -0x48(%ebp)
  8046f3:	e8 39 e9 ff ff       	call   803031 <set_block_data>
  8046f8:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8046fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fe:	eb 0a                	jmp    80470a <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804700:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804707:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80470a:	c9                   	leave  
  80470b:	c3                   	ret    

0080470c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80470c:	55                   	push   %ebp
  80470d:	89 e5                	mov    %esp,%ebp
  80470f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804712:	83 ec 04             	sub    $0x4,%esp
  804715:	68 e0 59 80 00       	push   $0x8059e0
  80471a:	68 58 02 00 00       	push   $0x258
  80471f:	68 01 59 80 00       	push   $0x805901
  804724:	e8 68 c9 ff ff       	call   801091 <_panic>

00804729 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804729:	55                   	push   %ebp
  80472a:	89 e5                	mov    %esp,%ebp
  80472c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80472f:	83 ec 04             	sub    $0x4,%esp
  804732:	68 08 5a 80 00       	push   $0x805a08
  804737:	68 61 02 00 00       	push   $0x261
  80473c:	68 01 59 80 00       	push   $0x805901
  804741:	e8 4b c9 ff ff       	call   801091 <_panic>
  804746:	66 90                	xchg   %ax,%ax

00804748 <__udivdi3>:
  804748:	55                   	push   %ebp
  804749:	57                   	push   %edi
  80474a:	56                   	push   %esi
  80474b:	53                   	push   %ebx
  80474c:	83 ec 1c             	sub    $0x1c,%esp
  80474f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804753:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80475b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80475f:	89 ca                	mov    %ecx,%edx
  804761:	89 f8                	mov    %edi,%eax
  804763:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804767:	85 f6                	test   %esi,%esi
  804769:	75 2d                	jne    804798 <__udivdi3+0x50>
  80476b:	39 cf                	cmp    %ecx,%edi
  80476d:	77 65                	ja     8047d4 <__udivdi3+0x8c>
  80476f:	89 fd                	mov    %edi,%ebp
  804771:	85 ff                	test   %edi,%edi
  804773:	75 0b                	jne    804780 <__udivdi3+0x38>
  804775:	b8 01 00 00 00       	mov    $0x1,%eax
  80477a:	31 d2                	xor    %edx,%edx
  80477c:	f7 f7                	div    %edi
  80477e:	89 c5                	mov    %eax,%ebp
  804780:	31 d2                	xor    %edx,%edx
  804782:	89 c8                	mov    %ecx,%eax
  804784:	f7 f5                	div    %ebp
  804786:	89 c1                	mov    %eax,%ecx
  804788:	89 d8                	mov    %ebx,%eax
  80478a:	f7 f5                	div    %ebp
  80478c:	89 cf                	mov    %ecx,%edi
  80478e:	89 fa                	mov    %edi,%edx
  804790:	83 c4 1c             	add    $0x1c,%esp
  804793:	5b                   	pop    %ebx
  804794:	5e                   	pop    %esi
  804795:	5f                   	pop    %edi
  804796:	5d                   	pop    %ebp
  804797:	c3                   	ret    
  804798:	39 ce                	cmp    %ecx,%esi
  80479a:	77 28                	ja     8047c4 <__udivdi3+0x7c>
  80479c:	0f bd fe             	bsr    %esi,%edi
  80479f:	83 f7 1f             	xor    $0x1f,%edi
  8047a2:	75 40                	jne    8047e4 <__udivdi3+0x9c>
  8047a4:	39 ce                	cmp    %ecx,%esi
  8047a6:	72 0a                	jb     8047b2 <__udivdi3+0x6a>
  8047a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8047ac:	0f 87 9e 00 00 00    	ja     804850 <__udivdi3+0x108>
  8047b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8047b7:	89 fa                	mov    %edi,%edx
  8047b9:	83 c4 1c             	add    $0x1c,%esp
  8047bc:	5b                   	pop    %ebx
  8047bd:	5e                   	pop    %esi
  8047be:	5f                   	pop    %edi
  8047bf:	5d                   	pop    %ebp
  8047c0:	c3                   	ret    
  8047c1:	8d 76 00             	lea    0x0(%esi),%esi
  8047c4:	31 ff                	xor    %edi,%edi
  8047c6:	31 c0                	xor    %eax,%eax
  8047c8:	89 fa                	mov    %edi,%edx
  8047ca:	83 c4 1c             	add    $0x1c,%esp
  8047cd:	5b                   	pop    %ebx
  8047ce:	5e                   	pop    %esi
  8047cf:	5f                   	pop    %edi
  8047d0:	5d                   	pop    %ebp
  8047d1:	c3                   	ret    
  8047d2:	66 90                	xchg   %ax,%ax
  8047d4:	89 d8                	mov    %ebx,%eax
  8047d6:	f7 f7                	div    %edi
  8047d8:	31 ff                	xor    %edi,%edi
  8047da:	89 fa                	mov    %edi,%edx
  8047dc:	83 c4 1c             	add    $0x1c,%esp
  8047df:	5b                   	pop    %ebx
  8047e0:	5e                   	pop    %esi
  8047e1:	5f                   	pop    %edi
  8047e2:	5d                   	pop    %ebp
  8047e3:	c3                   	ret    
  8047e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047e9:	89 eb                	mov    %ebp,%ebx
  8047eb:	29 fb                	sub    %edi,%ebx
  8047ed:	89 f9                	mov    %edi,%ecx
  8047ef:	d3 e6                	shl    %cl,%esi
  8047f1:	89 c5                	mov    %eax,%ebp
  8047f3:	88 d9                	mov    %bl,%cl
  8047f5:	d3 ed                	shr    %cl,%ebp
  8047f7:	89 e9                	mov    %ebp,%ecx
  8047f9:	09 f1                	or     %esi,%ecx
  8047fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047ff:	89 f9                	mov    %edi,%ecx
  804801:	d3 e0                	shl    %cl,%eax
  804803:	89 c5                	mov    %eax,%ebp
  804805:	89 d6                	mov    %edx,%esi
  804807:	88 d9                	mov    %bl,%cl
  804809:	d3 ee                	shr    %cl,%esi
  80480b:	89 f9                	mov    %edi,%ecx
  80480d:	d3 e2                	shl    %cl,%edx
  80480f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804813:	88 d9                	mov    %bl,%cl
  804815:	d3 e8                	shr    %cl,%eax
  804817:	09 c2                	or     %eax,%edx
  804819:	89 d0                	mov    %edx,%eax
  80481b:	89 f2                	mov    %esi,%edx
  80481d:	f7 74 24 0c          	divl   0xc(%esp)
  804821:	89 d6                	mov    %edx,%esi
  804823:	89 c3                	mov    %eax,%ebx
  804825:	f7 e5                	mul    %ebp
  804827:	39 d6                	cmp    %edx,%esi
  804829:	72 19                	jb     804844 <__udivdi3+0xfc>
  80482b:	74 0b                	je     804838 <__udivdi3+0xf0>
  80482d:	89 d8                	mov    %ebx,%eax
  80482f:	31 ff                	xor    %edi,%edi
  804831:	e9 58 ff ff ff       	jmp    80478e <__udivdi3+0x46>
  804836:	66 90                	xchg   %ax,%ax
  804838:	8b 54 24 08          	mov    0x8(%esp),%edx
  80483c:	89 f9                	mov    %edi,%ecx
  80483e:	d3 e2                	shl    %cl,%edx
  804840:	39 c2                	cmp    %eax,%edx
  804842:	73 e9                	jae    80482d <__udivdi3+0xe5>
  804844:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804847:	31 ff                	xor    %edi,%edi
  804849:	e9 40 ff ff ff       	jmp    80478e <__udivdi3+0x46>
  80484e:	66 90                	xchg   %ax,%ax
  804850:	31 c0                	xor    %eax,%eax
  804852:	e9 37 ff ff ff       	jmp    80478e <__udivdi3+0x46>
  804857:	90                   	nop

00804858 <__umoddi3>:
  804858:	55                   	push   %ebp
  804859:	57                   	push   %edi
  80485a:	56                   	push   %esi
  80485b:	53                   	push   %ebx
  80485c:	83 ec 1c             	sub    $0x1c,%esp
  80485f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804863:	8b 74 24 34          	mov    0x34(%esp),%esi
  804867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80486b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80486f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804873:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804877:	89 f3                	mov    %esi,%ebx
  804879:	89 fa                	mov    %edi,%edx
  80487b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80487f:	89 34 24             	mov    %esi,(%esp)
  804882:	85 c0                	test   %eax,%eax
  804884:	75 1a                	jne    8048a0 <__umoddi3+0x48>
  804886:	39 f7                	cmp    %esi,%edi
  804888:	0f 86 a2 00 00 00    	jbe    804930 <__umoddi3+0xd8>
  80488e:	89 c8                	mov    %ecx,%eax
  804890:	89 f2                	mov    %esi,%edx
  804892:	f7 f7                	div    %edi
  804894:	89 d0                	mov    %edx,%eax
  804896:	31 d2                	xor    %edx,%edx
  804898:	83 c4 1c             	add    $0x1c,%esp
  80489b:	5b                   	pop    %ebx
  80489c:	5e                   	pop    %esi
  80489d:	5f                   	pop    %edi
  80489e:	5d                   	pop    %ebp
  80489f:	c3                   	ret    
  8048a0:	39 f0                	cmp    %esi,%eax
  8048a2:	0f 87 ac 00 00 00    	ja     804954 <__umoddi3+0xfc>
  8048a8:	0f bd e8             	bsr    %eax,%ebp
  8048ab:	83 f5 1f             	xor    $0x1f,%ebp
  8048ae:	0f 84 ac 00 00 00    	je     804960 <__umoddi3+0x108>
  8048b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8048b9:	29 ef                	sub    %ebp,%edi
  8048bb:	89 fe                	mov    %edi,%esi
  8048bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8048c1:	89 e9                	mov    %ebp,%ecx
  8048c3:	d3 e0                	shl    %cl,%eax
  8048c5:	89 d7                	mov    %edx,%edi
  8048c7:	89 f1                	mov    %esi,%ecx
  8048c9:	d3 ef                	shr    %cl,%edi
  8048cb:	09 c7                	or     %eax,%edi
  8048cd:	89 e9                	mov    %ebp,%ecx
  8048cf:	d3 e2                	shl    %cl,%edx
  8048d1:	89 14 24             	mov    %edx,(%esp)
  8048d4:	89 d8                	mov    %ebx,%eax
  8048d6:	d3 e0                	shl    %cl,%eax
  8048d8:	89 c2                	mov    %eax,%edx
  8048da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048de:	d3 e0                	shl    %cl,%eax
  8048e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048e8:	89 f1                	mov    %esi,%ecx
  8048ea:	d3 e8                	shr    %cl,%eax
  8048ec:	09 d0                	or     %edx,%eax
  8048ee:	d3 eb                	shr    %cl,%ebx
  8048f0:	89 da                	mov    %ebx,%edx
  8048f2:	f7 f7                	div    %edi
  8048f4:	89 d3                	mov    %edx,%ebx
  8048f6:	f7 24 24             	mull   (%esp)
  8048f9:	89 c6                	mov    %eax,%esi
  8048fb:	89 d1                	mov    %edx,%ecx
  8048fd:	39 d3                	cmp    %edx,%ebx
  8048ff:	0f 82 87 00 00 00    	jb     80498c <__umoddi3+0x134>
  804905:	0f 84 91 00 00 00    	je     80499c <__umoddi3+0x144>
  80490b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80490f:	29 f2                	sub    %esi,%edx
  804911:	19 cb                	sbb    %ecx,%ebx
  804913:	89 d8                	mov    %ebx,%eax
  804915:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804919:	d3 e0                	shl    %cl,%eax
  80491b:	89 e9                	mov    %ebp,%ecx
  80491d:	d3 ea                	shr    %cl,%edx
  80491f:	09 d0                	or     %edx,%eax
  804921:	89 e9                	mov    %ebp,%ecx
  804923:	d3 eb                	shr    %cl,%ebx
  804925:	89 da                	mov    %ebx,%edx
  804927:	83 c4 1c             	add    $0x1c,%esp
  80492a:	5b                   	pop    %ebx
  80492b:	5e                   	pop    %esi
  80492c:	5f                   	pop    %edi
  80492d:	5d                   	pop    %ebp
  80492e:	c3                   	ret    
  80492f:	90                   	nop
  804930:	89 fd                	mov    %edi,%ebp
  804932:	85 ff                	test   %edi,%edi
  804934:	75 0b                	jne    804941 <__umoddi3+0xe9>
  804936:	b8 01 00 00 00       	mov    $0x1,%eax
  80493b:	31 d2                	xor    %edx,%edx
  80493d:	f7 f7                	div    %edi
  80493f:	89 c5                	mov    %eax,%ebp
  804941:	89 f0                	mov    %esi,%eax
  804943:	31 d2                	xor    %edx,%edx
  804945:	f7 f5                	div    %ebp
  804947:	89 c8                	mov    %ecx,%eax
  804949:	f7 f5                	div    %ebp
  80494b:	89 d0                	mov    %edx,%eax
  80494d:	e9 44 ff ff ff       	jmp    804896 <__umoddi3+0x3e>
  804952:	66 90                	xchg   %ax,%ax
  804954:	89 c8                	mov    %ecx,%eax
  804956:	89 f2                	mov    %esi,%edx
  804958:	83 c4 1c             	add    $0x1c,%esp
  80495b:	5b                   	pop    %ebx
  80495c:	5e                   	pop    %esi
  80495d:	5f                   	pop    %edi
  80495e:	5d                   	pop    %ebp
  80495f:	c3                   	ret    
  804960:	3b 04 24             	cmp    (%esp),%eax
  804963:	72 06                	jb     80496b <__umoddi3+0x113>
  804965:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804969:	77 0f                	ja     80497a <__umoddi3+0x122>
  80496b:	89 f2                	mov    %esi,%edx
  80496d:	29 f9                	sub    %edi,%ecx
  80496f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804973:	89 14 24             	mov    %edx,(%esp)
  804976:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80497a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80497e:	8b 14 24             	mov    (%esp),%edx
  804981:	83 c4 1c             	add    $0x1c,%esp
  804984:	5b                   	pop    %ebx
  804985:	5e                   	pop    %esi
  804986:	5f                   	pop    %edi
  804987:	5d                   	pop    %ebp
  804988:	c3                   	ret    
  804989:	8d 76 00             	lea    0x0(%esi),%esi
  80498c:	2b 04 24             	sub    (%esp),%eax
  80498f:	19 fa                	sbb    %edi,%edx
  804991:	89 d1                	mov    %edx,%ecx
  804993:	89 c6                	mov    %eax,%esi
  804995:	e9 71 ff ff ff       	jmp    80490b <__umoddi3+0xb3>
  80499a:	66 90                	xchg   %ax,%ax
  80499c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8049a0:	72 ea                	jb     80498c <__umoddi3+0x134>
  8049a2:	89 d9                	mov    %ebx,%ecx
  8049a4:	e9 62 ff ff ff       	jmp    80490b <__umoddi3+0xb3>
