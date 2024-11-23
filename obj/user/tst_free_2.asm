
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
  800055:	68 40 49 80 00       	push   $0x804940
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
  8000a5:	68 70 49 80 00       	push   $0x804970
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
  8000d1:	e8 52 2a 00 00       	call   802b28 <sys_set_uheap_strategy>
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
  8000f6:	68 a9 49 80 00       	push   $0x8049a9
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 c5 49 80 00       	push   $0x8049c5
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
  800123:	e8 4d 26 00 00       	call   802775 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 fa 25 00 00       	call   80272a <sys_calculate_free_frames>
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
  80013d:	68 d8 49 80 00       	push   $0x8049d8
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
  8002ac:	68 30 4a 80 00       	push   $0x804a30
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 c5 49 80 00       	push   $0x8049c5
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
  80031b:	68 58 4a 80 00       	push   $0x804a58
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 31 29 00 00       	call   802c6a <alloc_block>
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
  80037f:	68 7c 4a 80 00       	push   $0x804a7c
  800384:	6a 7f                	push   $0x7f
  800386:	68 c5 49 80 00       	push   $0x8049c5
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 95 23 00 00       	call   80272a <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 a4 4a 80 00       	push   $0x804aa4
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
  800443:	68 ec 4a 80 00       	push   $0x804aec
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
  80049a:	68 0c 4b 80 00       	push   $0x804b0c
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
  8004ee:	68 2c 4b 80 00       	push   $0x804b2c
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
  800538:	68 5c 4b 80 00       	push   $0x804b5c
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
  800552:	68 7c 4b 80 00       	push   $0x804b7c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 b7 4b 80 00       	push   $0x804bb7
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
  8005e0:	68 cc 4b 80 00       	push   $0x804bcc
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 eb 4b 80 00       	push   $0x804beb
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
  800669:	68 04 4c 80 00       	push   $0x804c04
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
  800683:	68 24 4c 80 00       	push   $0x804c24
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 5b 4c 80 00       	push   $0x804c5b
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
  800711:	68 70 4c 80 00       	push   $0x804c70
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 8f 4c 80 00       	push   $0x804c8f
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
  800762:	e8 cc 24 00 00       	call   802c33 <get_block_size>
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
  8007b7:	68 a8 4c 80 00       	push   $0x804ca8
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
  8007d1:	68 c8 4c 80 00       	push   $0x804cc8
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
  80083d:	e8 f1 23 00 00       	call   802c33 <get_block_size>
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
  80089b:	68 05 4d 80 00       	push   $0x804d05
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
  8008b5:	68 24 4d 80 00       	push   $0x804d24
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 64 4d 80 00       	push   $0x804d64
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 89 4d 80 00       	push   $0x804d89
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
  800963:	68 a0 4d 80 00       	push   $0x804da0
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 d0 4d 80 00       	push   $0x804dd0
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
  8009fa:	68 fc 4d 80 00       	push   $0x804dfc
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 2c 4e 80 00       	push   $0x804e2c
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
  800a68:	68 6c 4e 80 00       	push   $0x804e6c
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
  800a82:	68 9c 4e 80 00       	push   $0x804e9c
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
  800b11:	68 c8 4e 80 00       	push   $0x804ec8
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
  800b2b:	68 f8 4e 80 00       	push   $0x804ef8
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 20 4f 80 00       	push   $0x804f20
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
  800bca:	68 40 4f 80 00       	push   $0x804f40
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
  800c3d:	68 70 4f 80 00       	push   $0x804f70
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
  800ca4:	e8 50 20 00 00       	call   802cf9 <print_blocks_list>
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
  800ce6:	68 88 4f 80 00       	push   $0x804f88
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 b8 4f 80 00       	push   $0x804fb8
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
  800d83:	68 f0 4f 80 00       	push   $0x804ff0
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
  800d9d:	68 20 50 80 00       	push   $0x805020
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 74 19 00 00       	call   80272a <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 64 50 80 00       	push   $0x805064
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
  800e7a:	68 d0 50 80 00       	push   $0x8050d0
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
  800efe:	e8 82 1c 00 00       	call   802b85 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 0c 51 80 00       	push   $0x80510c
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
  800f3c:	68 50 51 80 00       	push   $0x805150
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
  800f58:	e8 96 19 00 00       	call   8028f3 <sys_getenvindex>
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
  800fc6:	e8 ac 16 00 00       	call   802677 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 b8 51 80 00       	push   $0x8051b8
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
  800ff6:	68 e0 51 80 00       	push   $0x8051e0
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
  801027:	68 08 52 80 00       	push   $0x805208
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 60 52 80 00       	push   $0x805260
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 b8 51 80 00       	push   $0x8051b8
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 2c 16 00 00       	call   802691 <sys_unlock_cons>
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
  801078:	e8 42 18 00 00       	call   8028bf <sys_destroy_env>
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
  801089:	e8 97 18 00 00       	call   802925 <sys_exit_env>
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
  8010b2:	68 74 52 80 00       	push   $0x805274
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 79 52 80 00       	push   $0x805279
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
  8010ef:	68 95 52 80 00       	push   $0x805295
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
  80111e:	68 98 52 80 00       	push   $0x805298
  801123:	6a 26                	push   $0x26
  801125:	68 e4 52 80 00       	push   $0x8052e4
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
  8011f3:	68 f0 52 80 00       	push   $0x8052f0
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 e4 52 80 00       	push   $0x8052e4
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
  801266:	68 44 53 80 00       	push   $0x805344
  80126b:	6a 44                	push   $0x44
  80126d:	68 e4 52 80 00       	push   $0x8052e4
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
  8012c0:	e8 70 13 00 00       	call   802635 <sys_cputs>
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
  801337:	e8 f9 12 00 00       	call   802635 <sys_cputs>
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
  801381:	e8 f1 12 00 00       	call   802677 <sys_lock_cons>
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
  8013a1:	e8 eb 12 00 00       	call   802691 <sys_unlock_cons>
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
  8013eb:	e8 dc 32 00 00       	call   8046cc <__udivdi3>
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
  80143b:	e8 9c 33 00 00       	call   8047dc <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 b4 55 80 00       	add    $0x8055b4,%eax
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
  801596:	8b 04 85 d8 55 80 00 	mov    0x8055d8(,%eax,4),%eax
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
  801677:	8b 34 9d 20 54 80 00 	mov    0x805420(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 c5 55 80 00       	push   $0x8055c5
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
  80169c:	68 ce 55 80 00       	push   $0x8055ce
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
  8016c9:	be d1 55 80 00       	mov    $0x8055d1,%esi
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
  8020d4:	68 48 57 80 00       	push   $0x805748
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 6a 57 80 00       	push   $0x80576a
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
  8020f4:	e8 e7 0a 00 00       	call   802be0 <sys_sbrk>
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
  80216f:	e8 f0 08 00 00       	call   802a64 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 30 0e 00 00       	call   802fb3 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 02 09 00 00       	call   802a95 <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 c9 12 00 00       	call   80346f <alloc_block_BF>
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
  8021f1:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
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
  80223e:	8b 04 85 60 a2 88 00 	mov    0x88a260(,%eax,4),%eax
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
  8022f7:	89 04 95 60 a2 90 00 	mov    %eax,0x90a260(,%edx,4)
		sys_allocate_user_mem(i, size);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	ff 75 f0             	pushl  -0x10(%ebp)
  802307:	e8 0b 09 00 00       	call   802c17 <sys_allocate_user_mem>
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
  80234f:	e8 df 08 00 00       	call   802c33 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 12 1b 00 00       	call   803e77 <free_block>
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
  80239a:	8b 04 85 60 a2 90 00 	mov    0x90a260(,%eax,4),%eax
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
  8023d7:	c7 04 85 60 a2 88 00 	movl   $0x0,0x88a260(,%eax,4)
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
  8023f7:	e8 ff 07 00 00       	call   802bfb <sys_free_user_mem>
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
  802405:	68 78 57 80 00       	push   $0x805778
  80240a:	68 85 00 00 00       	push   $0x85
  80240f:	68 a2 57 80 00       	push   $0x8057a2
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
  80242b:	75 0a                	jne    802437 <smalloc+0x1c>
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	e9 9a 00 00 00       	jmp    8024d1 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	39 d0                	cmp    %edx,%eax
  80244c:	73 02                	jae    802450 <smalloc+0x35>
  80244e:	89 d0                	mov    %edx,%eax
  802450:	83 ec 0c             	sub    $0xc,%esp
  802453:	50                   	push   %eax
  802454:	e8 a5 fc ff ff       	call   8020fe <malloc>
  802459:	83 c4 10             	add    $0x10,%esp
  80245c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80245f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802463:	75 07                	jne    80246c <smalloc+0x51>
  802465:	b8 00 00 00 00       	mov    $0x0,%eax
  80246a:	eb 65                	jmp    8024d1 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80246c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802470:	ff 75 ec             	pushl  -0x14(%ebp)
  802473:	50                   	push   %eax
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	e8 83 03 00 00       	call   802802 <sys_createSharedObject>
  80247f:	83 c4 10             	add    $0x10,%esp
  802482:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802485:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802489:	74 06                	je     802491 <smalloc+0x76>
  80248b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80248f:	75 07                	jne    802498 <smalloc+0x7d>
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
  802496:	eb 39                	jmp    8024d1 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  802498:	83 ec 08             	sub    $0x8,%esp
  80249b:	ff 75 ec             	pushl  -0x14(%ebp)
  80249e:	68 ae 57 80 00       	push   $0x8057ae
  8024a3:	e8 a6 ee ff ff       	call   80134e <cprintf>
  8024a8:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8024ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8024b3:	8b 40 78             	mov    0x78(%eax),%eax
  8024b6:	29 c2                	sub    %eax,%edx
  8024b8:	89 d0                	mov    %edx,%eax
  8024ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024bf:	c1 e8 0c             	shr    $0xc,%eax
  8024c2:	89 c2                	mov    %eax,%edx
  8024c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c7:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	 return ptr;
  8024ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8024d9:	83 ec 08             	sub    $0x8,%esp
  8024dc:	ff 75 0c             	pushl  0xc(%ebp)
  8024df:	ff 75 08             	pushl  0x8(%ebp)
  8024e2:	e8 45 03 00 00       	call   80282c <sys_getSizeOfSharedObject>
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8024ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024f1:	75 07                	jne    8024fa <sget+0x27>
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f8:	eb 5c                	jmp    802556 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802500:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802507:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	39 d0                	cmp    %edx,%eax
  80250f:	7d 02                	jge    802513 <sget+0x40>
  802511:	89 d0                	mov    %edx,%eax
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	50                   	push   %eax
  802517:	e8 e2 fb ff ff       	call   8020fe <malloc>
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802526:	75 07                	jne    80252f <sget+0x5c>
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	eb 27                	jmp    802556 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	ff 75 e8             	pushl  -0x18(%ebp)
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	e8 09 03 00 00       	call   802849 <sys_getSharedObject>
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802546:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80254a:	75 07                	jne    802553 <sget+0x80>
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	eb 03                	jmp    802556 <sget+0x83>
	return ptr;
  802553:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	a1 20 60 80 00       	mov    0x806020,%eax
  802566:	8b 40 78             	mov    0x78(%eax),%eax
  802569:	29 c2                	sub    %eax,%edx
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802572:	c1 e8 0c             	shr    $0xc,%eax
  802575:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  80257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80257f:	83 ec 08             	sub    $0x8,%esp
  802582:	ff 75 08             	pushl  0x8(%ebp)
  802585:	ff 75 f4             	pushl  -0xc(%ebp)
  802588:	e8 db 02 00 00       	call   802868 <sys_freeSharedObject>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802593:	90                   	nop
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	68 c0 57 80 00       	push   $0x8057c0
  8025a4:	68 dd 00 00 00       	push   $0xdd
  8025a9:	68 a2 57 80 00       	push   $0x8057a2
  8025ae:	e8 de ea ff ff       	call   801091 <_panic>

008025b3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	68 e6 57 80 00       	push   $0x8057e6
  8025c1:	68 e9 00 00 00       	push   $0xe9
  8025c6:	68 a2 57 80 00       	push   $0x8057a2
  8025cb:	e8 c1 ea ff ff       	call   801091 <_panic>

008025d0 <shrink>:

}
void shrink(uint32 newSize)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 e6 57 80 00       	push   $0x8057e6
  8025de:	68 ee 00 00 00       	push   $0xee
  8025e3:	68 a2 57 80 00       	push   $0x8057a2
  8025e8:	e8 a4 ea ff ff       	call   801091 <_panic>

008025ed <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 e6 57 80 00       	push   $0x8057e6
  8025fb:	68 f3 00 00 00       	push   $0xf3
  802600:	68 a2 57 80 00       	push   $0x8057a2
  802605:	e8 87 ea ff ff       	call   801091 <_panic>

0080260a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	57                   	push   %edi
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 55 0c             	mov    0xc(%ebp),%edx
  802619:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80261c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80261f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802622:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802625:	cd 30                	int    $0x30
  802627:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80262d:	83 c4 10             	add    $0x10,%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    

00802635 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	8b 45 10             	mov    0x10(%ebp),%eax
  80263e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802641:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	52                   	push   %edx
  80264d:	ff 75 0c             	pushl  0xc(%ebp)
  802650:	50                   	push   %eax
  802651:	6a 00                	push   $0x0
  802653:	e8 b2 ff ff ff       	call   80260a <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	90                   	nop
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <sys_cgetc>:

int
sys_cgetc(void)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 02                	push   $0x2
  80266d:	e8 98 ff ff ff       	call   80260a <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 03                	push   $0x3
  802686:	e8 7f ff ff ff       	call   80260a <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	90                   	nop
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 04                	push   $0x4
  8026a0:	e8 65 ff ff ff       	call   80260a <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	90                   	nop
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	52                   	push   %edx
  8026bb:	50                   	push   %eax
  8026bc:	6a 08                	push   $0x8
  8026be:	e8 47 ff ff ff       	call   80260a <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	56                   	push   %esi
  8026cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8026d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	56                   	push   %esi
  8026dd:	53                   	push   %ebx
  8026de:	51                   	push   %ecx
  8026df:	52                   	push   %edx
  8026e0:	50                   	push   %eax
  8026e1:	6a 09                	push   $0x9
  8026e3:	e8 22 ff ff ff       	call   80260a <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ee:	5b                   	pop    %ebx
  8026ef:	5e                   	pop    %esi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	52                   	push   %edx
  802702:	50                   	push   %eax
  802703:	6a 0a                	push   $0xa
  802705:	e8 00 ff ff ff       	call   80260a <syscall>
  80270a:	83 c4 18             	add    $0x18,%esp
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	ff 75 0c             	pushl  0xc(%ebp)
  80271b:	ff 75 08             	pushl  0x8(%ebp)
  80271e:	6a 0b                	push   $0xb
  802720:	e8 e5 fe ff ff       	call   80260a <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 0c                	push   $0xc
  802739:	e8 cc fe ff ff       	call   80260a <syscall>
  80273e:	83 c4 18             	add    $0x18,%esp
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 0d                	push   $0xd
  802752:	e8 b3 fe ff ff       	call   80260a <syscall>
  802757:	83 c4 18             	add    $0x18,%esp
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 0e                	push   $0xe
  80276b:	e8 9a fe ff ff       	call   80260a <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 0f                	push   $0xf
  802784:	e8 81 fe ff ff       	call   80260a <syscall>
  802789:	83 c4 18             	add    $0x18,%esp
}
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	ff 75 08             	pushl  0x8(%ebp)
  80279c:	6a 10                	push   $0x10
  80279e:	e8 67 fe ff ff       	call   80260a <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 11                	push   $0x11
  8027b7:	e8 4e fe ff ff       	call   80260a <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
}
  8027bf:	90                   	nop
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	50                   	push   %eax
  8027db:	6a 01                	push   $0x1
  8027dd:	e8 28 fe ff ff       	call   80260a <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
}
  8027e5:	90                   	nop
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 14                	push   $0x14
  8027f7:	e8 0e fe ff ff       	call   80260a <syscall>
  8027fc:	83 c4 18             	add    $0x18,%esp
}
  8027ff:	90                   	nop
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	8b 45 10             	mov    0x10(%ebp),%eax
  80280b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80280e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802811:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	6a 00                	push   $0x0
  80281a:	51                   	push   %ecx
  80281b:	52                   	push   %edx
  80281c:	ff 75 0c             	pushl  0xc(%ebp)
  80281f:	50                   	push   %eax
  802820:	6a 15                	push   $0x15
  802822:	e8 e3 fd ff ff       	call   80260a <syscall>
  802827:	83 c4 18             	add    $0x18,%esp
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80282f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	52                   	push   %edx
  80283c:	50                   	push   %eax
  80283d:	6a 16                	push   $0x16
  80283f:	e8 c6 fd ff ff       	call   80260a <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
}
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80284c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80284f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	51                   	push   %ecx
  80285a:	52                   	push   %edx
  80285b:	50                   	push   %eax
  80285c:	6a 17                	push   $0x17
  80285e:	e8 a7 fd ff ff       	call   80260a <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80286b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	52                   	push   %edx
  802878:	50                   	push   %eax
  802879:	6a 18                	push   $0x18
  80287b:	e8 8a fd ff ff       	call   80260a <syscall>
  802880:	83 c4 18             	add    $0x18,%esp
}
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	6a 00                	push   $0x0
  80288d:	ff 75 14             	pushl  0x14(%ebp)
  802890:	ff 75 10             	pushl  0x10(%ebp)
  802893:	ff 75 0c             	pushl  0xc(%ebp)
  802896:	50                   	push   %eax
  802897:	6a 19                	push   $0x19
  802899:	e8 6c fd ff ff       	call   80260a <syscall>
  80289e:	83 c4 18             	add    $0x18,%esp
}
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	50                   	push   %eax
  8028b2:	6a 1a                	push   $0x1a
  8028b4:	e8 51 fd ff ff       	call   80260a <syscall>
  8028b9:	83 c4 18             	add    $0x18,%esp
}
  8028bc:	90                   	nop
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	50                   	push   %eax
  8028ce:	6a 1b                	push   $0x1b
  8028d0:	e8 35 fd ff ff       	call   80260a <syscall>
  8028d5:	83 c4 18             	add    $0x18,%esp
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 05                	push   $0x5
  8028e9:	e8 1c fd ff ff       	call   80260a <syscall>
  8028ee:	83 c4 18             	add    $0x18,%esp
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 06                	push   $0x6
  802902:	e8 03 fd ff ff       	call   80260a <syscall>
  802907:	83 c4 18             	add    $0x18,%esp
}
  80290a:	c9                   	leave  
  80290b:	c3                   	ret    

0080290c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 07                	push   $0x7
  80291b:	e8 ea fc ff ff       	call   80260a <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
}
  802923:	c9                   	leave  
  802924:	c3                   	ret    

00802925 <sys_exit_env>:


void sys_exit_env(void)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 1c                	push   $0x1c
  802934:	e8 d1 fc ff ff       	call   80260a <syscall>
  802939:	83 c4 18             	add    $0x18,%esp
}
  80293c:	90                   	nop
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802945:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802948:	8d 50 04             	lea    0x4(%eax),%edx
  80294b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	52                   	push   %edx
  802955:	50                   	push   %eax
  802956:	6a 1d                	push   $0x1d
  802958:	e8 ad fc ff ff       	call   80260a <syscall>
  80295d:	83 c4 18             	add    $0x18,%esp
	return result;
  802960:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802963:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802966:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802969:	89 01                	mov    %eax,(%ecx)
  80296b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	c9                   	leave  
  802972:	c2 04 00             	ret    $0x4

00802975 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	ff 75 10             	pushl  0x10(%ebp)
  80297f:	ff 75 0c             	pushl  0xc(%ebp)
  802982:	ff 75 08             	pushl  0x8(%ebp)
  802985:	6a 13                	push   $0x13
  802987:	e8 7e fc ff ff       	call   80260a <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
	return ;
  80298f:	90                   	nop
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <sys_rcr2>:
uint32 sys_rcr2()
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 1e                	push   $0x1e
  8029a1:	e8 64 fc ff ff       	call   80260a <syscall>
  8029a6:	83 c4 18             	add    $0x18,%esp
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    

008029ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	50                   	push   %eax
  8029c4:	6a 1f                	push   $0x1f
  8029c6:	e8 3f fc ff ff       	call   80260a <syscall>
  8029cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ce:	90                   	nop
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <rsttst>:
void rsttst()
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 21                	push   $0x21
  8029e0:	e8 25 fc ff ff       	call   80260a <syscall>
  8029e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e8:	90                   	nop
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8029f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8029fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029fe:	52                   	push   %edx
  8029ff:	50                   	push   %eax
  802a00:	ff 75 10             	pushl  0x10(%ebp)
  802a03:	ff 75 0c             	pushl  0xc(%ebp)
  802a06:	ff 75 08             	pushl  0x8(%ebp)
  802a09:	6a 20                	push   $0x20
  802a0b:	e8 fa fb ff ff       	call   80260a <syscall>
  802a10:	83 c4 18             	add    $0x18,%esp
	return ;
  802a13:	90                   	nop
}
  802a14:	c9                   	leave  
  802a15:	c3                   	ret    

00802a16 <chktst>:
void chktst(uint32 n)
{
  802a16:	55                   	push   %ebp
  802a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	ff 75 08             	pushl  0x8(%ebp)
  802a24:	6a 22                	push   $0x22
  802a26:	e8 df fb ff ff       	call   80260a <syscall>
  802a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a2e:	90                   	nop
}
  802a2f:	c9                   	leave  
  802a30:	c3                   	ret    

00802a31 <inctst>:

void inctst()
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 23                	push   $0x23
  802a40:	e8 c5 fb ff ff       	call   80260a <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
	return ;
  802a48:	90                   	nop
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <gettst>:
uint32 gettst()
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	6a 00                	push   $0x0
  802a56:	6a 00                	push   $0x0
  802a58:	6a 24                	push   $0x24
  802a5a:	e8 ab fb ff ff       	call   80260a <syscall>
  802a5f:	83 c4 18             	add    $0x18,%esp
}
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
  802a67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 25                	push   $0x25
  802a76:	e8 8f fb ff ff       	call   80260a <syscall>
  802a7b:	83 c4 18             	add    $0x18,%esp
  802a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a81:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a85:	75 07                	jne    802a8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a87:	b8 01 00 00 00       	mov    $0x1,%eax
  802a8c:	eb 05                	jmp    802a93 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 25                	push   $0x25
  802aa7:	e8 5e fb ff ff       	call   80260a <syscall>
  802aac:	83 c4 18             	add    $0x18,%esp
  802aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ab2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ab6:	75 07                	jne    802abf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ab8:	b8 01 00 00 00       	mov    $0x1,%eax
  802abd:	eb 05                	jmp    802ac4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 25                	push   $0x25
  802ad8:	e8 2d fb ff ff       	call   80260a <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
  802ae0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802ae3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802ae7:	75 07                	jne    802af0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  802aee:	eb 05                	jmp    802af5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af5:	c9                   	leave  
  802af6:	c3                   	ret    

00802af7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802af7:	55                   	push   %ebp
  802af8:	89 e5                	mov    %esp,%ebp
  802afa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	6a 25                	push   $0x25
  802b09:	e8 fc fa ff ff       	call   80260a <syscall>
  802b0e:	83 c4 18             	add    $0x18,%esp
  802b11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b14:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b18:	75 07                	jne    802b21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1f:	eb 05                	jmp    802b26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b26:	c9                   	leave  
  802b27:	c3                   	ret    

00802b28 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b28:	55                   	push   %ebp
  802b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	ff 75 08             	pushl  0x8(%ebp)
  802b36:	6a 26                	push   $0x26
  802b38:	e8 cd fa ff ff       	call   80260a <syscall>
  802b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b40:	90                   	nop
}
  802b41:	c9                   	leave  
  802b42:	c3                   	ret    

00802b43 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b43:	55                   	push   %ebp
  802b44:	89 e5                	mov    %esp,%ebp
  802b46:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	6a 00                	push   $0x0
  802b55:	53                   	push   %ebx
  802b56:	51                   	push   %ecx
  802b57:	52                   	push   %edx
  802b58:	50                   	push   %eax
  802b59:	6a 27                	push   $0x27
  802b5b:	e8 aa fa ff ff       	call   80260a <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
}
  802b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	52                   	push   %edx
  802b78:	50                   	push   %eax
  802b79:	6a 28                	push   $0x28
  802b7b:	e8 8a fa ff ff       	call   80260a <syscall>
  802b80:	83 c4 18             	add    $0x18,%esp
}
  802b83:	c9                   	leave  
  802b84:	c3                   	ret    

00802b85 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	6a 00                	push   $0x0
  802b93:	51                   	push   %ecx
  802b94:	ff 75 10             	pushl  0x10(%ebp)
  802b97:	52                   	push   %edx
  802b98:	50                   	push   %eax
  802b99:	6a 29                	push   $0x29
  802b9b:	e8 6a fa ff ff       	call   80260a <syscall>
  802ba0:	83 c4 18             	add    $0x18,%esp
}
  802ba3:	c9                   	leave  
  802ba4:	c3                   	ret    

00802ba5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ba5:	55                   	push   %ebp
  802ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	ff 75 10             	pushl  0x10(%ebp)
  802baf:	ff 75 0c             	pushl  0xc(%ebp)
  802bb2:	ff 75 08             	pushl  0x8(%ebp)
  802bb5:	6a 12                	push   $0x12
  802bb7:	e8 4e fa ff ff       	call   80260a <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  802bbf:	90                   	nop
}
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	52                   	push   %edx
  802bd2:	50                   	push   %eax
  802bd3:	6a 2a                	push   $0x2a
  802bd5:	e8 30 fa ff ff       	call   80260a <syscall>
  802bda:	83 c4 18             	add    $0x18,%esp
	return;
  802bdd:	90                   	nop
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	50                   	push   %eax
  802bef:	6a 2b                	push   $0x2b
  802bf1:	e8 14 fa ff ff       	call   80260a <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	ff 75 0c             	pushl  0xc(%ebp)
  802c07:	ff 75 08             	pushl  0x8(%ebp)
  802c0a:	6a 2c                	push   $0x2c
  802c0c:	e8 f9 f9 ff ff       	call   80260a <syscall>
  802c11:	83 c4 18             	add    $0x18,%esp
	return;
  802c14:	90                   	nop
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	ff 75 0c             	pushl  0xc(%ebp)
  802c23:	ff 75 08             	pushl  0x8(%ebp)
  802c26:	6a 2d                	push   $0x2d
  802c28:	e8 dd f9 ff ff       	call   80260a <syscall>
  802c2d:	83 c4 18             	add    $0x18,%esp
	return;
  802c30:	90                   	nop
}
  802c31:	c9                   	leave  
  802c32:	c3                   	ret    

00802c33 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802c33:	55                   	push   %ebp
  802c34:	89 e5                	mov    %esp,%ebp
  802c36:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	83 e8 04             	sub    $0x4,%eax
  802c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	83 e8 04             	sub    $0x4,%eax
  802c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	83 e0 01             	and    $0x1,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	0f 94 c0             	sete   %al
}
  802c68:	c9                   	leave  
  802c69:	c3                   	ret    

00802c6a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c6a:	55                   	push   %ebp
  802c6b:	89 e5                	mov    %esp,%ebp
  802c6d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c7a:	83 f8 02             	cmp    $0x2,%eax
  802c7d:	74 2b                	je     802caa <alloc_block+0x40>
  802c7f:	83 f8 02             	cmp    $0x2,%eax
  802c82:	7f 07                	jg     802c8b <alloc_block+0x21>
  802c84:	83 f8 01             	cmp    $0x1,%eax
  802c87:	74 0e                	je     802c97 <alloc_block+0x2d>
  802c89:	eb 58                	jmp    802ce3 <alloc_block+0x79>
  802c8b:	83 f8 03             	cmp    $0x3,%eax
  802c8e:	74 2d                	je     802cbd <alloc_block+0x53>
  802c90:	83 f8 04             	cmp    $0x4,%eax
  802c93:	74 3b                	je     802cd0 <alloc_block+0x66>
  802c95:	eb 4c                	jmp    802ce3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	e8 11 03 00 00       	call   802fb3 <alloc_block_FF>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ca8:	eb 4a                	jmp    802cf4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802caa:	83 ec 0c             	sub    $0xc,%esp
  802cad:	ff 75 08             	pushl  0x8(%ebp)
  802cb0:	e8 fa 19 00 00       	call   8046af <alloc_block_NF>
  802cb5:	83 c4 10             	add    $0x10,%esp
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cbb:	eb 37                	jmp    802cf4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	ff 75 08             	pushl  0x8(%ebp)
  802cc3:	e8 a7 07 00 00       	call   80346f <alloc_block_BF>
  802cc8:	83 c4 10             	add    $0x10,%esp
  802ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cce:	eb 24                	jmp    802cf4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802cd0:	83 ec 0c             	sub    $0xc,%esp
  802cd3:	ff 75 08             	pushl  0x8(%ebp)
  802cd6:	e8 b7 19 00 00       	call   804692 <alloc_block_WF>
  802cdb:	83 c4 10             	add    $0x10,%esp
  802cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ce1:	eb 11                	jmp    802cf4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	68 f8 57 80 00       	push   $0x8057f8
  802ceb:	e8 5e e6 ff ff       	call   80134e <cprintf>
  802cf0:	83 c4 10             	add    $0x10,%esp
		break;
  802cf3:	90                   	nop
	}
	return va;
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

00802cf9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
  802cfc:	53                   	push   %ebx
  802cfd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802d00:	83 ec 0c             	sub    $0xc,%esp
  802d03:	68 18 58 80 00       	push   $0x805818
  802d08:	e8 41 e6 ff ff       	call   80134e <cprintf>
  802d0d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802d10:	83 ec 0c             	sub    $0xc,%esp
  802d13:	68 43 58 80 00       	push   $0x805843
  802d18:	e8 31 e6 ff ff       	call   80134e <cprintf>
  802d1d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	eb 37                	jmp    802d5f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802d28:	83 ec 0c             	sub    $0xc,%esp
  802d2b:	ff 75 f4             	pushl  -0xc(%ebp)
  802d2e:	e8 19 ff ff ff       	call   802c4c <is_free_block>
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	0f be d8             	movsbl %al,%ebx
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802d3f:	e8 ef fe ff ff       	call   802c33 <get_block_size>
  802d44:	83 c4 10             	add    $0x10,%esp
  802d47:	83 ec 04             	sub    $0x4,%esp
  802d4a:	53                   	push   %ebx
  802d4b:	50                   	push   %eax
  802d4c:	68 5b 58 80 00       	push   $0x80585b
  802d51:	e8 f8 e5 ff ff       	call   80134e <cprintf>
  802d56:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d59:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d63:	74 07                	je     802d6c <print_blocks_list+0x73>
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	eb 05                	jmp    802d71 <print_blocks_list+0x78>
  802d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d71:	89 45 10             	mov    %eax,0x10(%ebp)
  802d74:	8b 45 10             	mov    0x10(%ebp),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	75 ad                	jne    802d28 <print_blocks_list+0x2f>
  802d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7f:	75 a7                	jne    802d28 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802d81:	83 ec 0c             	sub    $0xc,%esp
  802d84:	68 18 58 80 00       	push   $0x805818
  802d89:	e8 c0 e5 ff ff       	call   80134e <cprintf>
  802d8e:	83 c4 10             	add    $0x10,%esp

}
  802d91:	90                   	nop
  802d92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
  802d9a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da0:	83 e0 01             	and    $0x1,%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 03                	je     802daa <initialize_dynamic_allocator+0x13>
  802da7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802daa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dae:	0f 84 c7 01 00 00    	je     802f7b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802db4:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802dbb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802dcb:	0f 87 ad 01 00 00    	ja     802f7e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	0f 89 a5 01 00 00    	jns    802f81 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de2:	01 d0                	add    %edx,%eax
  802de4:	83 e8 04             	sub    $0x4,%eax
  802de7:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802df3:	a1 44 60 80 00       	mov    0x806044,%eax
  802df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfb:	e9 87 00 00 00       	jmp    802e87 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	75 14                	jne    802e1a <initialize_dynamic_allocator+0x83>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 73 58 80 00       	push   $0x805873
  802e0e:	6a 79                	push   $0x79
  802e10:	68 91 58 80 00       	push   $0x805891
  802e15:	e8 77 e2 ff ff       	call   801091 <_panic>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 10                	je     802e33 <initialize_dynamic_allocator+0x9c>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	8b 52 04             	mov    0x4(%edx),%edx
  802e2e:	89 50 04             	mov    %edx,0x4(%eax)
  802e31:	eb 0b                	jmp    802e3e <initialize_dynamic_allocator+0xa7>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	a3 48 60 80 00       	mov    %eax,0x806048
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0f                	je     802e57 <initialize_dynamic_allocator+0xc0>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e51:	8b 12                	mov    (%edx),%edx
  802e53:	89 10                	mov    %edx,(%eax)
  802e55:	eb 0a                	jmp    802e61 <initialize_dynamic_allocator+0xca>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	a3 44 60 80 00       	mov    %eax,0x806044
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e74:	a1 50 60 80 00       	mov    0x806050,%eax
  802e79:	48                   	dec    %eax
  802e7a:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802e7f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8b:	74 07                	je     802e94 <initialize_dynamic_allocator+0xfd>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	eb 05                	jmp    802e99 <initialize_dynamic_allocator+0x102>
  802e94:	b8 00 00 00 00       	mov    $0x0,%eax
  802e99:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802e9e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	0f 85 55 ff ff ff    	jne    802e00 <initialize_dynamic_allocator+0x69>
  802eab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaf:	0f 85 4b ff ff ff    	jne    802e00 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ec4:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802ec9:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802ece:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802ed3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	83 c0 08             	add    $0x8,%eax
  802edf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	83 c0 04             	add    $0x4,%eax
  802ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eeb:	83 ea 08             	sub    $0x8,%edx
  802eee:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	01 d0                	add    %edx,%eax
  802ef8:	83 e8 08             	sub    $0x8,%eax
  802efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efe:	83 ea 08             	sub    $0x8,%edx
  802f01:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802f16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f1a:	75 17                	jne    802f33 <initialize_dynamic_allocator+0x19c>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 ac 58 80 00       	push   $0x8058ac
  802f24:	68 90 00 00 00       	push   $0x90
  802f29:	68 91 58 80 00       	push   $0x805891
  802f2e:	e8 5e e1 ff ff       	call   801091 <_panic>
  802f33:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	89 10                	mov    %edx,(%eax)
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0d                	je     802f54 <initialize_dynamic_allocator+0x1bd>
  802f47:	a1 44 60 80 00       	mov    0x806044,%eax
  802f4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	eb 08                	jmp    802f5c <initialize_dynamic_allocator+0x1c5>
  802f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f57:	a3 48 60 80 00       	mov    %eax,0x806048
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	a3 44 60 80 00       	mov    %eax,0x806044
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6e:	a1 50 60 80 00       	mov    0x806050,%eax
  802f73:	40                   	inc    %eax
  802f74:	a3 50 60 80 00       	mov    %eax,0x806050
  802f79:	eb 07                	jmp    802f82 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f7b:	90                   	nop
  802f7c:	eb 04                	jmp    802f82 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802f7e:	90                   	nop
  802f7f:	eb 01                	jmp    802f82 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802f81:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802f82:	c9                   	leave  
  802f83:	c3                   	ret    

00802f84 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802f84:	55                   	push   %ebp
  802f85:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802f87:	8b 45 10             	mov    0x10(%ebp),%eax
  802f8a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f96:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	83 e8 04             	sub    $0x4,%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	83 e0 fe             	and    $0xfffffffe,%eax
  802fa3:	8d 50 f8             	lea    -0x8(%eax),%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	01 c2                	add    %eax,%edx
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	89 02                	mov    %eax,(%edx)
}
  802fb0:	90                   	nop
  802fb1:	5d                   	pop    %ebp
  802fb2:	c3                   	ret    

00802fb3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
  802fb6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	83 e0 01             	and    $0x1,%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 03                	je     802fc6 <alloc_block_FF+0x13>
  802fc3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fc6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fca:	77 07                	ja     802fd3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fcc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802fd3:	a1 24 60 80 00       	mov    0x806024,%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	75 73                	jne    80304f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	83 c0 10             	add    $0x10,%eax
  802fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802fe5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff2:	01 d0                	add    %edx,%eax
  802ff4:	48                   	dec    %eax
  802ff5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	ba 00 00 00 00       	mov    $0x0,%edx
  803000:	f7 75 ec             	divl   -0x14(%ebp)
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	29 d0                	sub    %edx,%eax
  803008:	c1 e8 0c             	shr    $0xc,%eax
  80300b:	83 ec 0c             	sub    $0xc,%esp
  80300e:	50                   	push   %eax
  80300f:	e8 d4 f0 ff ff       	call   8020e8 <sbrk>
  803014:	83 c4 10             	add    $0x10,%esp
  803017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80301a:	83 ec 0c             	sub    $0xc,%esp
  80301d:	6a 00                	push   $0x0
  80301f:	e8 c4 f0 ff ff       	call   8020e8 <sbrk>
  803024:	83 c4 10             	add    $0x10,%esp
  803027:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80302a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803030:	83 ec 08             	sub    $0x8,%esp
  803033:	50                   	push   %eax
  803034:	ff 75 e4             	pushl  -0x1c(%ebp)
  803037:	e8 5b fd ff ff       	call   802d97 <initialize_dynamic_allocator>
  80303c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80303f:	83 ec 0c             	sub    $0xc,%esp
  803042:	68 cf 58 80 00       	push   $0x8058cf
  803047:	e8 02 e3 ff ff       	call   80134e <cprintf>
  80304c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80304f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803053:	75 0a                	jne    80305f <alloc_block_FF+0xac>
	        return NULL;
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	e9 0e 04 00 00       	jmp    80346d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80305f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803066:	a1 44 60 80 00       	mov    0x806044,%eax
  80306b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306e:	e9 f3 02 00 00       	jmp    803366 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803079:	83 ec 0c             	sub    $0xc,%esp
  80307c:	ff 75 bc             	pushl  -0x44(%ebp)
  80307f:	e8 af fb ff ff       	call   802c33 <get_block_size>
  803084:	83 c4 10             	add    $0x10,%esp
  803087:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	83 c0 08             	add    $0x8,%eax
  803090:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803093:	0f 87 c5 02 00 00    	ja     80335e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	83 c0 18             	add    $0x18,%eax
  80309f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030a2:	0f 87 19 02 00 00    	ja     8032c1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8030a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8030ae:	83 e8 08             	sub    $0x8,%eax
  8030b1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8d 50 08             	lea    0x8(%eax),%edx
  8030ba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030bd:	01 d0                	add    %edx,%eax
  8030bf:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	83 c0 08             	add    $0x8,%eax
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	6a 01                	push   $0x1
  8030cd:	50                   	push   %eax
  8030ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8030d1:	e8 ae fe ff ff       	call   802f84 <set_block_data>
  8030d6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 04             	mov    0x4(%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	75 68                	jne    80314b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030e3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030e7:	75 17                	jne    803100 <alloc_block_FF+0x14d>
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	68 ac 58 80 00       	push   $0x8058ac
  8030f1:	68 d7 00 00 00       	push   $0xd7
  8030f6:	68 91 58 80 00       	push   $0x805891
  8030fb:	e8 91 df ff ff       	call   801091 <_panic>
  803100:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803106:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803109:	89 10                	mov    %edx,(%eax)
  80310b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 0d                	je     803121 <alloc_block_FF+0x16e>
  803114:	a1 44 60 80 00       	mov    0x806044,%eax
  803119:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 08                	jmp    803129 <alloc_block_FF+0x176>
  803121:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803124:	a3 48 60 80 00       	mov    %eax,0x806048
  803129:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80312c:	a3 44 60 80 00       	mov    %eax,0x806044
  803131:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	a1 50 60 80 00       	mov    0x806050,%eax
  803140:	40                   	inc    %eax
  803141:	a3 50 60 80 00       	mov    %eax,0x806050
  803146:	e9 dc 00 00 00       	jmp    803227 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	75 65                	jne    8031b9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803154:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803158:	75 17                	jne    803171 <alloc_block_FF+0x1be>
  80315a:	83 ec 04             	sub    $0x4,%esp
  80315d:	68 e0 58 80 00       	push   $0x8058e0
  803162:	68 db 00 00 00       	push   $0xdb
  803167:	68 91 58 80 00       	push   $0x805891
  80316c:	e8 20 df ff ff       	call   801091 <_panic>
  803171:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803177:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 0c                	je     803193 <alloc_block_FF+0x1e0>
  803187:	a1 48 60 80 00       	mov    0x806048,%eax
  80318c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	eb 08                	jmp    80319b <alloc_block_FF+0x1e8>
  803193:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803196:	a3 44 60 80 00       	mov    %eax,0x806044
  80319b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80319e:	a3 48 60 80 00       	mov    %eax,0x806048
  8031a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ac:	a1 50 60 80 00       	mov    0x806050,%eax
  8031b1:	40                   	inc    %eax
  8031b2:	a3 50 60 80 00       	mov    %eax,0x806050
  8031b7:	eb 6e                	jmp    803227 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8031b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bd:	74 06                	je     8031c5 <alloc_block_FF+0x212>
  8031bf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031c3:	75 17                	jne    8031dc <alloc_block_FF+0x229>
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	68 04 59 80 00       	push   $0x805904
  8031cd:	68 df 00 00 00       	push   $0xdf
  8031d2:	68 91 58 80 00       	push   $0x805891
  8031d7:	e8 b5 de ff ff       	call   801091 <_panic>
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 10                	mov    (%eax),%edx
  8031e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0b                	je     8031fa <alloc_block_FF+0x247>
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031f7:	89 50 04             	mov    %edx,0x4(%eax)
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803200:	89 10                	mov    %edx,(%eax)
  803202:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	75 08                	jne    80321c <alloc_block_FF+0x269>
  803214:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803217:	a3 48 60 80 00       	mov    %eax,0x806048
  80321c:	a1 50 60 80 00       	mov    0x806050,%eax
  803221:	40                   	inc    %eax
  803222:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322b:	75 17                	jne    803244 <alloc_block_FF+0x291>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 73 58 80 00       	push   $0x805873
  803235:	68 e1 00 00 00       	push   $0xe1
  80323a:	68 91 58 80 00       	push   $0x805891
  80323f:	e8 4d de ff ff       	call   801091 <_panic>
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 10                	je     80325d <alloc_block_FF+0x2aa>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803255:	8b 52 04             	mov    0x4(%edx),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 0b                	jmp    803268 <alloc_block_FF+0x2b5>
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	a3 48 60 80 00       	mov    %eax,0x806048
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0f                	je     803281 <alloc_block_FF+0x2ce>
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327b:	8b 12                	mov    (%edx),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	eb 0a                	jmp    80328b <alloc_block_FF+0x2d8>
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	a3 44 60 80 00       	mov    %eax,0x806044
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329e:	a1 50 60 80 00       	mov    0x806050,%eax
  8032a3:	48                   	dec    %eax
  8032a4:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	6a 00                	push   $0x0
  8032ae:	ff 75 b4             	pushl  -0x4c(%ebp)
  8032b1:	ff 75 b0             	pushl  -0x50(%ebp)
  8032b4:	e8 cb fc ff ff       	call   802f84 <set_block_data>
  8032b9:	83 c4 10             	add    $0x10,%esp
  8032bc:	e9 95 00 00 00       	jmp    803356 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8032c1:	83 ec 04             	sub    $0x4,%esp
  8032c4:	6a 01                	push   $0x1
  8032c6:	ff 75 b8             	pushl  -0x48(%ebp)
  8032c9:	ff 75 bc             	pushl  -0x44(%ebp)
  8032cc:	e8 b3 fc ff ff       	call   802f84 <set_block_data>
  8032d1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8032d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d8:	75 17                	jne    8032f1 <alloc_block_FF+0x33e>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 73 58 80 00       	push   $0x805873
  8032e2:	68 e8 00 00 00       	push   $0xe8
  8032e7:	68 91 58 80 00       	push   $0x805891
  8032ec:	e8 a0 dd ff ff       	call   801091 <_panic>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 10                	je     80330a <alloc_block_FF+0x357>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803302:	8b 52 04             	mov    0x4(%edx),%edx
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	eb 0b                	jmp    803315 <alloc_block_FF+0x362>
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 40 04             	mov    0x4(%eax),%eax
  803310:	a3 48 60 80 00       	mov    %eax,0x806048
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 04             	mov    0x4(%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	74 0f                	je     80332e <alloc_block_FF+0x37b>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 40 04             	mov    0x4(%eax),%eax
  803325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803328:	8b 12                	mov    (%edx),%edx
  80332a:	89 10                	mov    %edx,(%eax)
  80332c:	eb 0a                	jmp    803338 <alloc_block_FF+0x385>
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
	            }
	            return va;
  803356:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803359:	e9 0f 01 00 00       	jmp    80346d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80335e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336a:	74 07                	je     803373 <alloc_block_FF+0x3c0>
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	eb 05                	jmp    803378 <alloc_block_FF+0x3c5>
  803373:	b8 00 00 00 00       	mov    $0x0,%eax
  803378:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80337d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803382:	85 c0                	test   %eax,%eax
  803384:	0f 85 e9 fc ff ff    	jne    803073 <alloc_block_FF+0xc0>
  80338a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338e:	0f 85 df fc ff ff    	jne    803073 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	83 c0 08             	add    $0x8,%eax
  80339a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80339d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8033a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033aa:	01 d0                	add    %edx,%eax
  8033ac:	48                   	dec    %eax
  8033ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8033b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8033b8:	f7 75 d8             	divl   -0x28(%ebp)
  8033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033be:	29 d0                	sub    %edx,%eax
  8033c0:	c1 e8 0c             	shr    $0xc,%eax
  8033c3:	83 ec 0c             	sub    $0xc,%esp
  8033c6:	50                   	push   %eax
  8033c7:	e8 1c ed ff ff       	call   8020e8 <sbrk>
  8033cc:	83 c4 10             	add    $0x10,%esp
  8033cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8033d2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8033d6:	75 0a                	jne    8033e2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8033d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dd:	e9 8b 00 00 00       	jmp    80346d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033e2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8033e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	48                   	dec    %eax
  8033f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8033f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033fd:	f7 75 cc             	divl   -0x34(%ebp)
  803400:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803403:	29 d0                	sub    %edx,%eax
  803405:	8d 50 fc             	lea    -0x4(%eax),%edx
  803408:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80340b:	01 d0                	add    %edx,%eax
  80340d:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  803412:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803417:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80341d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803424:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803427:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80342a:	01 d0                	add    %edx,%eax
  80342c:	48                   	dec    %eax
  80342d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803430:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803433:	ba 00 00 00 00       	mov    $0x0,%edx
  803438:	f7 75 c4             	divl   -0x3c(%ebp)
  80343b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80343e:	29 d0                	sub    %edx,%eax
  803440:	83 ec 04             	sub    $0x4,%esp
  803443:	6a 01                	push   $0x1
  803445:	50                   	push   %eax
  803446:	ff 75 d0             	pushl  -0x30(%ebp)
  803449:	e8 36 fb ff ff       	call   802f84 <set_block_data>
  80344e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 d0             	pushl  -0x30(%ebp)
  803457:	e8 1b 0a 00 00       	call   803e77 <free_block>
  80345c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80345f:	83 ec 0c             	sub    $0xc,%esp
  803462:	ff 75 08             	pushl  0x8(%ebp)
  803465:	e8 49 fb ff ff       	call   802fb3 <alloc_block_FF>
  80346a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80346d:	c9                   	leave  
  80346e:	c3                   	ret    

0080346f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80346f:	55                   	push   %ebp
  803470:	89 e5                	mov    %esp,%ebp
  803472:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	83 e0 01             	and    $0x1,%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 03                	je     803482 <alloc_block_BF+0x13>
  80347f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803482:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803486:	77 07                	ja     80348f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803488:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80348f:	a1 24 60 80 00       	mov    0x806024,%eax
  803494:	85 c0                	test   %eax,%eax
  803496:	75 73                	jne    80350b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	83 c0 10             	add    $0x10,%eax
  80349e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034a1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8034a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ae:	01 d0                	add    %edx,%eax
  8034b0:	48                   	dec    %eax
  8034b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8034bc:	f7 75 e0             	divl   -0x20(%ebp)
  8034bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c2:	29 d0                	sub    %edx,%eax
  8034c4:	c1 e8 0c             	shr    $0xc,%eax
  8034c7:	83 ec 0c             	sub    $0xc,%esp
  8034ca:	50                   	push   %eax
  8034cb:	e8 18 ec ff ff       	call   8020e8 <sbrk>
  8034d0:	83 c4 10             	add    $0x10,%esp
  8034d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034d6:	83 ec 0c             	sub    $0xc,%esp
  8034d9:	6a 00                	push   $0x0
  8034db:	e8 08 ec ff ff       	call   8020e8 <sbrk>
  8034e0:	83 c4 10             	add    $0x10,%esp
  8034e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8034e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8034ec:	83 ec 08             	sub    $0x8,%esp
  8034ef:	50                   	push   %eax
  8034f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8034f3:	e8 9f f8 ff ff       	call   802d97 <initialize_dynamic_allocator>
  8034f8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8034fb:	83 ec 0c             	sub    $0xc,%esp
  8034fe:	68 cf 58 80 00       	push   $0x8058cf
  803503:	e8 46 de ff ff       	call   80134e <cprintf>
  803508:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80350b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803512:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803519:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803520:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803527:	a1 44 60 80 00       	mov    0x806044,%eax
  80352c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352f:	e9 1d 01 00 00       	jmp    803651 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80353a:	83 ec 0c             	sub    $0xc,%esp
  80353d:	ff 75 a8             	pushl  -0x58(%ebp)
  803540:	e8 ee f6 ff ff       	call   802c33 <get_block_size>
  803545:	83 c4 10             	add    $0x10,%esp
  803548:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	83 c0 08             	add    $0x8,%eax
  803551:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803554:	0f 87 ef 00 00 00    	ja     803649 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	83 c0 18             	add    $0x18,%eax
  803560:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803563:	77 1d                	ja     803582 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803568:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80356b:	0f 86 d8 00 00 00    	jbe    803649 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803571:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803574:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803577:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80357a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80357d:	e9 c7 00 00 00       	jmp    803649 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	83 c0 08             	add    $0x8,%eax
  803588:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80358b:	0f 85 9d 00 00 00    	jne    80362e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	6a 01                	push   $0x1
  803596:	ff 75 a4             	pushl  -0x5c(%ebp)
  803599:	ff 75 a8             	pushl  -0x58(%ebp)
  80359c:	e8 e3 f9 ff ff       	call   802f84 <set_block_data>
  8035a1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a8:	75 17                	jne    8035c1 <alloc_block_BF+0x152>
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	68 73 58 80 00       	push   $0x805873
  8035b2:	68 2c 01 00 00       	push   $0x12c
  8035b7:	68 91 58 80 00       	push   $0x805891
  8035bc:	e8 d0 da ff ff       	call   801091 <_panic>
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	74 10                	je     8035da <alloc_block_BF+0x16b>
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d2:	8b 52 04             	mov    0x4(%edx),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	eb 0b                	jmp    8035e5 <alloc_block_BF+0x176>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	a3 48 60 80 00       	mov    %eax,0x806048
  8035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e8:	8b 40 04             	mov    0x4(%eax),%eax
  8035eb:	85 c0                	test   %eax,%eax
  8035ed:	74 0f                	je     8035fe <alloc_block_BF+0x18f>
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f8:	8b 12                	mov    (%edx),%edx
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	eb 0a                	jmp    803608 <alloc_block_BF+0x199>
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	a3 44 60 80 00       	mov    %eax,0x806044
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361b:	a1 50 60 80 00       	mov    0x806050,%eax
  803620:	48                   	dec    %eax
  803621:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803626:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803629:	e9 24 04 00 00       	jmp    803a52 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80362e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803631:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803634:	76 13                	jbe    803649 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803636:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80363d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803640:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803643:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803646:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803649:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80364e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803655:	74 07                	je     80365e <alloc_block_BF+0x1ef>
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 00                	mov    (%eax),%eax
  80365c:	eb 05                	jmp    803663 <alloc_block_BF+0x1f4>
  80365e:	b8 00 00 00 00       	mov    $0x0,%eax
  803663:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803668:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	0f 85 bf fe ff ff    	jne    803534 <alloc_block_BF+0xc5>
  803675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803679:	0f 85 b5 fe ff ff    	jne    803534 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80367f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803683:	0f 84 26 02 00 00    	je     8038af <alloc_block_BF+0x440>
  803689:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80368d:	0f 85 1c 02 00 00    	jne    8038af <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803696:	2b 45 08             	sub    0x8(%ebp),%eax
  803699:	83 e8 08             	sub    $0x8,%eax
  80369c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80369f:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a2:	8d 50 08             	lea    0x8(%eax),%edx
  8036a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a8:	01 d0                	add    %edx,%eax
  8036aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	83 c0 08             	add    $0x8,%eax
  8036b3:	83 ec 04             	sub    $0x4,%esp
  8036b6:	6a 01                	push   $0x1
  8036b8:	50                   	push   %eax
  8036b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8036bc:	e8 c3 f8 ff ff       	call   802f84 <set_block_data>
  8036c1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8036c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	75 68                	jne    803736 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036d2:	75 17                	jne    8036eb <alloc_block_BF+0x27c>
  8036d4:	83 ec 04             	sub    $0x4,%esp
  8036d7:	68 ac 58 80 00       	push   $0x8058ac
  8036dc:	68 45 01 00 00       	push   $0x145
  8036e1:	68 91 58 80 00       	push   $0x805891
  8036e6:	e8 a6 d9 ff ff       	call   801091 <_panic>
  8036eb:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8036f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f4:	89 10                	mov    %edx,(%eax)
  8036f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 0d                	je     80370c <alloc_block_BF+0x29d>
  8036ff:	a1 44 60 80 00       	mov    0x806044,%eax
  803704:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803707:	89 50 04             	mov    %edx,0x4(%eax)
  80370a:	eb 08                	jmp    803714 <alloc_block_BF+0x2a5>
  80370c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80370f:	a3 48 60 80 00       	mov    %eax,0x806048
  803714:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803717:	a3 44 60 80 00       	mov    %eax,0x806044
  80371c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80371f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803726:	a1 50 60 80 00       	mov    0x806050,%eax
  80372b:	40                   	inc    %eax
  80372c:	a3 50 60 80 00       	mov    %eax,0x806050
  803731:	e9 dc 00 00 00       	jmp    803812 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	8b 00                	mov    (%eax),%eax
  80373b:	85 c0                	test   %eax,%eax
  80373d:	75 65                	jne    8037a4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80373f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803743:	75 17                	jne    80375c <alloc_block_BF+0x2ed>
  803745:	83 ec 04             	sub    $0x4,%esp
  803748:	68 e0 58 80 00       	push   $0x8058e0
  80374d:	68 4a 01 00 00       	push   $0x14a
  803752:	68 91 58 80 00       	push   $0x805891
  803757:	e8 35 d9 ff ff       	call   801091 <_panic>
  80375c:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803762:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803765:	89 50 04             	mov    %edx,0x4(%eax)
  803768:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	85 c0                	test   %eax,%eax
  803770:	74 0c                	je     80377e <alloc_block_BF+0x30f>
  803772:	a1 48 60 80 00       	mov    0x806048,%eax
  803777:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80377a:	89 10                	mov    %edx,(%eax)
  80377c:	eb 08                	jmp    803786 <alloc_block_BF+0x317>
  80377e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803781:	a3 44 60 80 00       	mov    %eax,0x806044
  803786:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803789:	a3 48 60 80 00       	mov    %eax,0x806048
  80378e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803797:	a1 50 60 80 00       	mov    0x806050,%eax
  80379c:	40                   	inc    %eax
  80379d:	a3 50 60 80 00       	mov    %eax,0x806050
  8037a2:	eb 6e                	jmp    803812 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8037a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037a8:	74 06                	je     8037b0 <alloc_block_BF+0x341>
  8037aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037ae:	75 17                	jne    8037c7 <alloc_block_BF+0x358>
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	68 04 59 80 00       	push   $0x805904
  8037b8:	68 4f 01 00 00       	push   $0x14f
  8037bd:	68 91 58 80 00       	push   $0x805891
  8037c2:	e8 ca d8 ff ff       	call   801091 <_panic>
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	8b 10                	mov    (%eax),%edx
  8037cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037cf:	89 10                	mov    %edx,(%eax)
  8037d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037d4:	8b 00                	mov    (%eax),%eax
  8037d6:	85 c0                	test   %eax,%eax
  8037d8:	74 0b                	je     8037e5 <alloc_block_BF+0x376>
  8037da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037e2:	89 50 04             	mov    %edx,0x4(%eax)
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037eb:	89 10                	mov    %edx,(%eax)
  8037ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f9:	8b 00                	mov    (%eax),%eax
  8037fb:	85 c0                	test   %eax,%eax
  8037fd:	75 08                	jne    803807 <alloc_block_BF+0x398>
  8037ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803802:	a3 48 60 80 00       	mov    %eax,0x806048
  803807:	a1 50 60 80 00       	mov    0x806050,%eax
  80380c:	40                   	inc    %eax
  80380d:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803812:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803816:	75 17                	jne    80382f <alloc_block_BF+0x3c0>
  803818:	83 ec 04             	sub    $0x4,%esp
  80381b:	68 73 58 80 00       	push   $0x805873
  803820:	68 51 01 00 00       	push   $0x151
  803825:	68 91 58 80 00       	push   $0x805891
  80382a:	e8 62 d8 ff ff       	call   801091 <_panic>
  80382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	74 10                	je     803848 <alloc_block_BF+0x3d9>
  803838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803840:	8b 52 04             	mov    0x4(%edx),%edx
  803843:	89 50 04             	mov    %edx,0x4(%eax)
  803846:	eb 0b                	jmp    803853 <alloc_block_BF+0x3e4>
  803848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	a3 48 60 80 00       	mov    %eax,0x806048
  803853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803856:	8b 40 04             	mov    0x4(%eax),%eax
  803859:	85 c0                	test   %eax,%eax
  80385b:	74 0f                	je     80386c <alloc_block_BF+0x3fd>
  80385d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803860:	8b 40 04             	mov    0x4(%eax),%eax
  803863:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803866:	8b 12                	mov    (%edx),%edx
  803868:	89 10                	mov    %edx,(%eax)
  80386a:	eb 0a                	jmp    803876 <alloc_block_BF+0x407>
  80386c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386f:	8b 00                	mov    (%eax),%eax
  803871:	a3 44 60 80 00       	mov    %eax,0x806044
  803876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803882:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803889:	a1 50 60 80 00       	mov    0x806050,%eax
  80388e:	48                   	dec    %eax
  80388f:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  803894:	83 ec 04             	sub    $0x4,%esp
  803897:	6a 00                	push   $0x0
  803899:	ff 75 d0             	pushl  -0x30(%ebp)
  80389c:	ff 75 cc             	pushl  -0x34(%ebp)
  80389f:	e8 e0 f6 ff ff       	call   802f84 <set_block_data>
  8038a4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8038a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038aa:	e9 a3 01 00 00       	jmp    803a52 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8038af:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8038b3:	0f 85 9d 00 00 00    	jne    803956 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	6a 01                	push   $0x1
  8038be:	ff 75 ec             	pushl  -0x14(%ebp)
  8038c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8038c4:	e8 bb f6 ff ff       	call   802f84 <set_block_data>
  8038c9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8038cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038d0:	75 17                	jne    8038e9 <alloc_block_BF+0x47a>
  8038d2:	83 ec 04             	sub    $0x4,%esp
  8038d5:	68 73 58 80 00       	push   $0x805873
  8038da:	68 58 01 00 00       	push   $0x158
  8038df:	68 91 58 80 00       	push   $0x805891
  8038e4:	e8 a8 d7 ff ff       	call   801091 <_panic>
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	74 10                	je     803902 <alloc_block_BF+0x493>
  8038f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fa:	8b 52 04             	mov    0x4(%edx),%edx
  8038fd:	89 50 04             	mov    %edx,0x4(%eax)
  803900:	eb 0b                	jmp    80390d <alloc_block_BF+0x49e>
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	8b 40 04             	mov    0x4(%eax),%eax
  803908:	a3 48 60 80 00       	mov    %eax,0x806048
  80390d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803910:	8b 40 04             	mov    0x4(%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	74 0f                	je     803926 <alloc_block_BF+0x4b7>
  803917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391a:	8b 40 04             	mov    0x4(%eax),%eax
  80391d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803920:	8b 12                	mov    (%edx),%edx
  803922:	89 10                	mov    %edx,(%eax)
  803924:	eb 0a                	jmp    803930 <alloc_block_BF+0x4c1>
  803926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	a3 44 60 80 00       	mov    %eax,0x806044
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803943:	a1 50 60 80 00       	mov    0x806050,%eax
  803948:	48                   	dec    %eax
  803949:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  80394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803951:	e9 fc 00 00 00       	jmp    803a52 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	83 c0 08             	add    $0x8,%eax
  80395c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80395f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803966:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803969:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80396c:	01 d0                	add    %edx,%eax
  80396e:	48                   	dec    %eax
  80396f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803972:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803975:	ba 00 00 00 00       	mov    $0x0,%edx
  80397a:	f7 75 c4             	divl   -0x3c(%ebp)
  80397d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803980:	29 d0                	sub    %edx,%eax
  803982:	c1 e8 0c             	shr    $0xc,%eax
  803985:	83 ec 0c             	sub    $0xc,%esp
  803988:	50                   	push   %eax
  803989:	e8 5a e7 ff ff       	call   8020e8 <sbrk>
  80398e:	83 c4 10             	add    $0x10,%esp
  803991:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803994:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803998:	75 0a                	jne    8039a4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80399a:	b8 00 00 00 00       	mov    $0x0,%eax
  80399f:	e9 ae 00 00 00       	jmp    803a52 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8039a4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8039ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b1:	01 d0                	add    %edx,%eax
  8039b3:	48                   	dec    %eax
  8039b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8039b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8039bf:	f7 75 b8             	divl   -0x48(%ebp)
  8039c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039c5:	29 d0                	sub    %edx,%eax
  8039c7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8039ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8039cd:	01 d0                	add    %edx,%eax
  8039cf:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8039d4:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8039d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8039df:	83 ec 0c             	sub    $0xc,%esp
  8039e2:	68 38 59 80 00       	push   $0x805938
  8039e7:	e8 62 d9 ff ff       	call   80134e <cprintf>
  8039ec:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8039ef:	83 ec 08             	sub    $0x8,%esp
  8039f2:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f5:	68 3d 59 80 00       	push   $0x80593d
  8039fa:	e8 4f d9 ff ff       	call   80134e <cprintf>
  8039ff:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803a02:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803a09:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a0f:	01 d0                	add    %edx,%eax
  803a11:	48                   	dec    %eax
  803a12:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a15:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a18:	ba 00 00 00 00       	mov    $0x0,%edx
  803a1d:	f7 75 b0             	divl   -0x50(%ebp)
  803a20:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a23:	29 d0                	sub    %edx,%eax
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	6a 01                	push   $0x1
  803a2a:	50                   	push   %eax
  803a2b:	ff 75 bc             	pushl  -0x44(%ebp)
  803a2e:	e8 51 f5 ff ff       	call   802f84 <set_block_data>
  803a33:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803a36:	83 ec 0c             	sub    $0xc,%esp
  803a39:	ff 75 bc             	pushl  -0x44(%ebp)
  803a3c:	e8 36 04 00 00       	call   803e77 <free_block>
  803a41:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803a44:	83 ec 0c             	sub    $0xc,%esp
  803a47:	ff 75 08             	pushl  0x8(%ebp)
  803a4a:	e8 20 fa ff ff       	call   80346f <alloc_block_BF>
  803a4f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a52:	c9                   	leave  
  803a53:	c3                   	ret    

00803a54 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a54:	55                   	push   %ebp
  803a55:	89 e5                	mov    %esp,%ebp
  803a57:	53                   	push   %ebx
  803a58:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6d:	74 1e                	je     803a8d <merging+0x39>
  803a6f:	ff 75 08             	pushl  0x8(%ebp)
  803a72:	e8 bc f1 ff ff       	call   802c33 <get_block_size>
  803a77:	83 c4 04             	add    $0x4,%esp
  803a7a:	89 c2                	mov    %eax,%edx
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	01 d0                	add    %edx,%eax
  803a81:	3b 45 10             	cmp    0x10(%ebp),%eax
  803a84:	75 07                	jne    803a8d <merging+0x39>
		prev_is_free = 1;
  803a86:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803a8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a91:	74 1e                	je     803ab1 <merging+0x5d>
  803a93:	ff 75 10             	pushl  0x10(%ebp)
  803a96:	e8 98 f1 ff ff       	call   802c33 <get_block_size>
  803a9b:	83 c4 04             	add    $0x4,%esp
  803a9e:	89 c2                	mov    %eax,%edx
  803aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  803aa3:	01 d0                	add    %edx,%eax
  803aa5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803aa8:	75 07                	jne    803ab1 <merging+0x5d>
		next_is_free = 1;
  803aaa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab5:	0f 84 cc 00 00 00    	je     803b87 <merging+0x133>
  803abb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803abf:	0f 84 c2 00 00 00    	je     803b87 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803ac5:	ff 75 08             	pushl  0x8(%ebp)
  803ac8:	e8 66 f1 ff ff       	call   802c33 <get_block_size>
  803acd:	83 c4 04             	add    $0x4,%esp
  803ad0:	89 c3                	mov    %eax,%ebx
  803ad2:	ff 75 10             	pushl  0x10(%ebp)
  803ad5:	e8 59 f1 ff ff       	call   802c33 <get_block_size>
  803ada:	83 c4 04             	add    $0x4,%esp
  803add:	01 c3                	add    %eax,%ebx
  803adf:	ff 75 0c             	pushl  0xc(%ebp)
  803ae2:	e8 4c f1 ff ff       	call   802c33 <get_block_size>
  803ae7:	83 c4 04             	add    $0x4,%esp
  803aea:	01 d8                	add    %ebx,%eax
  803aec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803aef:	6a 00                	push   $0x0
  803af1:	ff 75 ec             	pushl  -0x14(%ebp)
  803af4:	ff 75 08             	pushl  0x8(%ebp)
  803af7:	e8 88 f4 ff ff       	call   802f84 <set_block_data>
  803afc:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b03:	75 17                	jne    803b1c <merging+0xc8>
  803b05:	83 ec 04             	sub    $0x4,%esp
  803b08:	68 73 58 80 00       	push   $0x805873
  803b0d:	68 7d 01 00 00       	push   $0x17d
  803b12:	68 91 58 80 00       	push   $0x805891
  803b17:	e8 75 d5 ff ff       	call   801091 <_panic>
  803b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 10                	je     803b35 <merging+0xe1>
  803b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b2d:	8b 52 04             	mov    0x4(%edx),%edx
  803b30:	89 50 04             	mov    %edx,0x4(%eax)
  803b33:	eb 0b                	jmp    803b40 <merging+0xec>
  803b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b38:	8b 40 04             	mov    0x4(%eax),%eax
  803b3b:	a3 48 60 80 00       	mov    %eax,0x806048
  803b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b43:	8b 40 04             	mov    0x4(%eax),%eax
  803b46:	85 c0                	test   %eax,%eax
  803b48:	74 0f                	je     803b59 <merging+0x105>
  803b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4d:	8b 40 04             	mov    0x4(%eax),%eax
  803b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b53:	8b 12                	mov    (%edx),%edx
  803b55:	89 10                	mov    %edx,(%eax)
  803b57:	eb 0a                	jmp    803b63 <merging+0x10f>
  803b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5c:	8b 00                	mov    (%eax),%eax
  803b5e:	a3 44 60 80 00       	mov    %eax,0x806044
  803b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b76:	a1 50 60 80 00       	mov    0x806050,%eax
  803b7b:	48                   	dec    %eax
  803b7c:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803b81:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b82:	e9 ea 02 00 00       	jmp    803e71 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b8b:	74 3b                	je     803bc8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803b8d:	83 ec 0c             	sub    $0xc,%esp
  803b90:	ff 75 08             	pushl  0x8(%ebp)
  803b93:	e8 9b f0 ff ff       	call   802c33 <get_block_size>
  803b98:	83 c4 10             	add    $0x10,%esp
  803b9b:	89 c3                	mov    %eax,%ebx
  803b9d:	83 ec 0c             	sub    $0xc,%esp
  803ba0:	ff 75 10             	pushl  0x10(%ebp)
  803ba3:	e8 8b f0 ff ff       	call   802c33 <get_block_size>
  803ba8:	83 c4 10             	add    $0x10,%esp
  803bab:	01 d8                	add    %ebx,%eax
  803bad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bb0:	83 ec 04             	sub    $0x4,%esp
  803bb3:	6a 00                	push   $0x0
  803bb5:	ff 75 e8             	pushl  -0x18(%ebp)
  803bb8:	ff 75 08             	pushl  0x8(%ebp)
  803bbb:	e8 c4 f3 ff ff       	call   802f84 <set_block_data>
  803bc0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bc3:	e9 a9 02 00 00       	jmp    803e71 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803bc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bcc:	0f 84 2d 01 00 00    	je     803cff <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803bd2:	83 ec 0c             	sub    $0xc,%esp
  803bd5:	ff 75 10             	pushl  0x10(%ebp)
  803bd8:	e8 56 f0 ff ff       	call   802c33 <get_block_size>
  803bdd:	83 c4 10             	add    $0x10,%esp
  803be0:	89 c3                	mov    %eax,%ebx
  803be2:	83 ec 0c             	sub    $0xc,%esp
  803be5:	ff 75 0c             	pushl  0xc(%ebp)
  803be8:	e8 46 f0 ff ff       	call   802c33 <get_block_size>
  803bed:	83 c4 10             	add    $0x10,%esp
  803bf0:	01 d8                	add    %ebx,%eax
  803bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803bf5:	83 ec 04             	sub    $0x4,%esp
  803bf8:	6a 00                	push   $0x0
  803bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bfd:	ff 75 10             	pushl  0x10(%ebp)
  803c00:	e8 7f f3 ff ff       	call   802f84 <set_block_data>
  803c05:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803c08:	8b 45 10             	mov    0x10(%ebp),%eax
  803c0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c12:	74 06                	je     803c1a <merging+0x1c6>
  803c14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c18:	75 17                	jne    803c31 <merging+0x1dd>
  803c1a:	83 ec 04             	sub    $0x4,%esp
  803c1d:	68 4c 59 80 00       	push   $0x80594c
  803c22:	68 8d 01 00 00       	push   $0x18d
  803c27:	68 91 58 80 00       	push   $0x805891
  803c2c:	e8 60 d4 ff ff       	call   801091 <_panic>
  803c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c34:	8b 50 04             	mov    0x4(%eax),%edx
  803c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3a:	89 50 04             	mov    %edx,0x4(%eax)
  803c3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c43:	89 10                	mov    %edx,(%eax)
  803c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c48:	8b 40 04             	mov    0x4(%eax),%eax
  803c4b:	85 c0                	test   %eax,%eax
  803c4d:	74 0d                	je     803c5c <merging+0x208>
  803c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c52:	8b 40 04             	mov    0x4(%eax),%eax
  803c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c58:	89 10                	mov    %edx,(%eax)
  803c5a:	eb 08                	jmp    803c64 <merging+0x210>
  803c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c5f:	a3 44 60 80 00       	mov    %eax,0x806044
  803c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c6a:	89 50 04             	mov    %edx,0x4(%eax)
  803c6d:	a1 50 60 80 00       	mov    0x806050,%eax
  803c72:	40                   	inc    %eax
  803c73:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c7c:	75 17                	jne    803c95 <merging+0x241>
  803c7e:	83 ec 04             	sub    $0x4,%esp
  803c81:	68 73 58 80 00       	push   $0x805873
  803c86:	68 8e 01 00 00       	push   $0x18e
  803c8b:	68 91 58 80 00       	push   $0x805891
  803c90:	e8 fc d3 ff ff       	call   801091 <_panic>
  803c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c98:	8b 00                	mov    (%eax),%eax
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	74 10                	je     803cae <merging+0x25a>
  803c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ca1:	8b 00                	mov    (%eax),%eax
  803ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ca6:	8b 52 04             	mov    0x4(%edx),%edx
  803ca9:	89 50 04             	mov    %edx,0x4(%eax)
  803cac:	eb 0b                	jmp    803cb9 <merging+0x265>
  803cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb1:	8b 40 04             	mov    0x4(%eax),%eax
  803cb4:	a3 48 60 80 00       	mov    %eax,0x806048
  803cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbc:	8b 40 04             	mov    0x4(%eax),%eax
  803cbf:	85 c0                	test   %eax,%eax
  803cc1:	74 0f                	je     803cd2 <merging+0x27e>
  803cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc6:	8b 40 04             	mov    0x4(%eax),%eax
  803cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ccc:	8b 12                	mov    (%edx),%edx
  803cce:	89 10                	mov    %edx,(%eax)
  803cd0:	eb 0a                	jmp    803cdc <merging+0x288>
  803cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd5:	8b 00                	mov    (%eax),%eax
  803cd7:	a3 44 60 80 00       	mov    %eax,0x806044
  803cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cef:	a1 50 60 80 00       	mov    0x806050,%eax
  803cf4:	48                   	dec    %eax
  803cf5:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803cfa:	e9 72 01 00 00       	jmp    803e71 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803cff:	8b 45 10             	mov    0x10(%ebp),%eax
  803d02:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d09:	74 79                	je     803d84 <merging+0x330>
  803d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d0f:	74 73                	je     803d84 <merging+0x330>
  803d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d15:	74 06                	je     803d1d <merging+0x2c9>
  803d17:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d1b:	75 17                	jne    803d34 <merging+0x2e0>
  803d1d:	83 ec 04             	sub    $0x4,%esp
  803d20:	68 04 59 80 00       	push   $0x805904
  803d25:	68 94 01 00 00       	push   $0x194
  803d2a:	68 91 58 80 00       	push   $0x805891
  803d2f:	e8 5d d3 ff ff       	call   801091 <_panic>
  803d34:	8b 45 08             	mov    0x8(%ebp),%eax
  803d37:	8b 10                	mov    (%eax),%edx
  803d39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d3c:	89 10                	mov    %edx,(%eax)
  803d3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d41:	8b 00                	mov    (%eax),%eax
  803d43:	85 c0                	test   %eax,%eax
  803d45:	74 0b                	je     803d52 <merging+0x2fe>
  803d47:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4a:	8b 00                	mov    (%eax),%eax
  803d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d4f:	89 50 04             	mov    %edx,0x4(%eax)
  803d52:	8b 45 08             	mov    0x8(%ebp),%eax
  803d55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d58:	89 10                	mov    %edx,(%eax)
  803d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803d60:	89 50 04             	mov    %edx,0x4(%eax)
  803d63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d66:	8b 00                	mov    (%eax),%eax
  803d68:	85 c0                	test   %eax,%eax
  803d6a:	75 08                	jne    803d74 <merging+0x320>
  803d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d6f:	a3 48 60 80 00       	mov    %eax,0x806048
  803d74:	a1 50 60 80 00       	mov    0x806050,%eax
  803d79:	40                   	inc    %eax
  803d7a:	a3 50 60 80 00       	mov    %eax,0x806050
  803d7f:	e9 ce 00 00 00       	jmp    803e52 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d88:	74 65                	je     803def <merging+0x39b>
  803d8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d8e:	75 17                	jne    803da7 <merging+0x353>
  803d90:	83 ec 04             	sub    $0x4,%esp
  803d93:	68 e0 58 80 00       	push   $0x8058e0
  803d98:	68 95 01 00 00       	push   $0x195
  803d9d:	68 91 58 80 00       	push   $0x805891
  803da2:	e8 ea d2 ff ff       	call   801091 <_panic>
  803da7:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db0:	89 50 04             	mov    %edx,0x4(%eax)
  803db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db6:	8b 40 04             	mov    0x4(%eax),%eax
  803db9:	85 c0                	test   %eax,%eax
  803dbb:	74 0c                	je     803dc9 <merging+0x375>
  803dbd:	a1 48 60 80 00       	mov    0x806048,%eax
  803dc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dc5:	89 10                	mov    %edx,(%eax)
  803dc7:	eb 08                	jmp    803dd1 <merging+0x37d>
  803dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dcc:	a3 44 60 80 00       	mov    %eax,0x806044
  803dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd4:	a3 48 60 80 00       	mov    %eax,0x806048
  803dd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ddc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de2:	a1 50 60 80 00       	mov    0x806050,%eax
  803de7:	40                   	inc    %eax
  803de8:	a3 50 60 80 00       	mov    %eax,0x806050
  803ded:	eb 63                	jmp    803e52 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803def:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803df3:	75 17                	jne    803e0c <merging+0x3b8>
  803df5:	83 ec 04             	sub    $0x4,%esp
  803df8:	68 ac 58 80 00       	push   $0x8058ac
  803dfd:	68 98 01 00 00       	push   $0x198
  803e02:	68 91 58 80 00       	push   $0x805891
  803e07:	e8 85 d2 ff ff       	call   801091 <_panic>
  803e0c:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e15:	89 10                	mov    %edx,(%eax)
  803e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1a:	8b 00                	mov    (%eax),%eax
  803e1c:	85 c0                	test   %eax,%eax
  803e1e:	74 0d                	je     803e2d <merging+0x3d9>
  803e20:	a1 44 60 80 00       	mov    0x806044,%eax
  803e25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e28:	89 50 04             	mov    %edx,0x4(%eax)
  803e2b:	eb 08                	jmp    803e35 <merging+0x3e1>
  803e2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e30:	a3 48 60 80 00       	mov    %eax,0x806048
  803e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e38:	a3 44 60 80 00       	mov    %eax,0x806044
  803e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e47:	a1 50 60 80 00       	mov    0x806050,%eax
  803e4c:	40                   	inc    %eax
  803e4d:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803e52:	83 ec 0c             	sub    $0xc,%esp
  803e55:	ff 75 10             	pushl  0x10(%ebp)
  803e58:	e8 d6 ed ff ff       	call   802c33 <get_block_size>
  803e5d:	83 c4 10             	add    $0x10,%esp
  803e60:	83 ec 04             	sub    $0x4,%esp
  803e63:	6a 00                	push   $0x0
  803e65:	50                   	push   %eax
  803e66:	ff 75 10             	pushl  0x10(%ebp)
  803e69:	e8 16 f1 ff ff       	call   802f84 <set_block_data>
  803e6e:	83 c4 10             	add    $0x10,%esp
	}
}
  803e71:	90                   	nop
  803e72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e75:	c9                   	leave  
  803e76:	c3                   	ret    

00803e77 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e77:	55                   	push   %ebp
  803e78:	89 e5                	mov    %esp,%ebp
  803e7a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803e7d:	a1 44 60 80 00       	mov    0x806044,%eax
  803e82:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803e85:	a1 48 60 80 00       	mov    0x806048,%eax
  803e8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e8d:	73 1b                	jae    803eaa <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803e8f:	a1 48 60 80 00       	mov    0x806048,%eax
  803e94:	83 ec 04             	sub    $0x4,%esp
  803e97:	ff 75 08             	pushl  0x8(%ebp)
  803e9a:	6a 00                	push   $0x0
  803e9c:	50                   	push   %eax
  803e9d:	e8 b2 fb ff ff       	call   803a54 <merging>
  803ea2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ea5:	e9 8b 00 00 00       	jmp    803f35 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803eaa:	a1 44 60 80 00       	mov    0x806044,%eax
  803eaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eb2:	76 18                	jbe    803ecc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803eb4:	a1 44 60 80 00       	mov    0x806044,%eax
  803eb9:	83 ec 04             	sub    $0x4,%esp
  803ebc:	ff 75 08             	pushl  0x8(%ebp)
  803ebf:	50                   	push   %eax
  803ec0:	6a 00                	push   $0x0
  803ec2:	e8 8d fb ff ff       	call   803a54 <merging>
  803ec7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803eca:	eb 69                	jmp    803f35 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ecc:	a1 44 60 80 00       	mov    0x806044,%eax
  803ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ed4:	eb 39                	jmp    803f0f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803edc:	73 29                	jae    803f07 <free_block+0x90>
  803ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee1:	8b 00                	mov    (%eax),%eax
  803ee3:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ee6:	76 1f                	jbe    803f07 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eeb:	8b 00                	mov    (%eax),%eax
  803eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ef0:	83 ec 04             	sub    $0x4,%esp
  803ef3:	ff 75 08             	pushl  0x8(%ebp)
  803ef6:	ff 75 f0             	pushl  -0x10(%ebp)
  803ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  803efc:	e8 53 fb ff ff       	call   803a54 <merging>
  803f01:	83 c4 10             	add    $0x10,%esp
			break;
  803f04:	90                   	nop
		}
	}
}
  803f05:	eb 2e                	jmp    803f35 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f07:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f13:	74 07                	je     803f1c <free_block+0xa5>
  803f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	eb 05                	jmp    803f21 <free_block+0xaa>
  803f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f21:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f26:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f2b:	85 c0                	test   %eax,%eax
  803f2d:	75 a7                	jne    803ed6 <free_block+0x5f>
  803f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f33:	75 a1                	jne    803ed6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f35:	90                   	nop
  803f36:	c9                   	leave  
  803f37:	c3                   	ret    

00803f38 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803f38:	55                   	push   %ebp
  803f39:	89 e5                	mov    %esp,%ebp
  803f3b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803f3e:	ff 75 08             	pushl  0x8(%ebp)
  803f41:	e8 ed ec ff ff       	call   802c33 <get_block_size>
  803f46:	83 c4 04             	add    $0x4,%esp
  803f49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f53:	eb 17                	jmp    803f6c <copy_data+0x34>
  803f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f5b:	01 c2                	add    %eax,%edx
  803f5d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f60:	8b 45 08             	mov    0x8(%ebp),%eax
  803f63:	01 c8                	add    %ecx,%eax
  803f65:	8a 00                	mov    (%eax),%al
  803f67:	88 02                	mov    %al,(%edx)
  803f69:	ff 45 fc             	incl   -0x4(%ebp)
  803f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f72:	72 e1                	jb     803f55 <copy_data+0x1d>
}
  803f74:	90                   	nop
  803f75:	c9                   	leave  
  803f76:	c3                   	ret    

00803f77 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f77:	55                   	push   %ebp
  803f78:	89 e5                	mov    %esp,%ebp
  803f7a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f81:	75 23                	jne    803fa6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803f83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f87:	74 13                	je     803f9c <realloc_block_FF+0x25>
  803f89:	83 ec 0c             	sub    $0xc,%esp
  803f8c:	ff 75 0c             	pushl  0xc(%ebp)
  803f8f:	e8 1f f0 ff ff       	call   802fb3 <alloc_block_FF>
  803f94:	83 c4 10             	add    $0x10,%esp
  803f97:	e9 f4 06 00 00       	jmp    804690 <realloc_block_FF+0x719>
		return NULL;
  803f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa1:	e9 ea 06 00 00       	jmp    804690 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803fa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803faa:	75 18                	jne    803fc4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803fac:	83 ec 0c             	sub    $0xc,%esp
  803faf:	ff 75 08             	pushl  0x8(%ebp)
  803fb2:	e8 c0 fe ff ff       	call   803e77 <free_block>
  803fb7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803fba:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbf:	e9 cc 06 00 00       	jmp    804690 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803fc4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803fc8:	77 07                	ja     803fd1 <realloc_block_FF+0x5a>
  803fca:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd4:	83 e0 01             	and    $0x1,%eax
  803fd7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fdd:	83 c0 08             	add    $0x8,%eax
  803fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803fe3:	83 ec 0c             	sub    $0xc,%esp
  803fe6:	ff 75 08             	pushl  0x8(%ebp)
  803fe9:	e8 45 ec ff ff       	call   802c33 <get_block_size>
  803fee:	83 c4 10             	add    $0x10,%esp
  803ff1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ff7:	83 e8 08             	sub    $0x8,%eax
  803ffa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  804000:	83 e8 04             	sub    $0x4,%eax
  804003:	8b 00                	mov    (%eax),%eax
  804005:	83 e0 fe             	and    $0xfffffffe,%eax
  804008:	89 c2                	mov    %eax,%edx
  80400a:	8b 45 08             	mov    0x8(%ebp),%eax
  80400d:	01 d0                	add    %edx,%eax
  80400f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804012:	83 ec 0c             	sub    $0xc,%esp
  804015:	ff 75 e4             	pushl  -0x1c(%ebp)
  804018:	e8 16 ec ff ff       	call   802c33 <get_block_size>
  80401d:	83 c4 10             	add    $0x10,%esp
  804020:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804026:	83 e8 08             	sub    $0x8,%eax
  804029:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80402c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804032:	75 08                	jne    80403c <realloc_block_FF+0xc5>
	{
		 return va;
  804034:	8b 45 08             	mov    0x8(%ebp),%eax
  804037:	e9 54 06 00 00       	jmp    804690 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80403c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80403f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804042:	0f 83 e5 03 00 00    	jae    80442d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80404b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80404e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804051:	83 ec 0c             	sub    $0xc,%esp
  804054:	ff 75 e4             	pushl  -0x1c(%ebp)
  804057:	e8 f0 eb ff ff       	call   802c4c <is_free_block>
  80405c:	83 c4 10             	add    $0x10,%esp
  80405f:	84 c0                	test   %al,%al
  804061:	0f 84 3b 01 00 00    	je     8041a2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804067:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80406a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80406d:	01 d0                	add    %edx,%eax
  80406f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804072:	83 ec 04             	sub    $0x4,%esp
  804075:	6a 01                	push   $0x1
  804077:	ff 75 f0             	pushl  -0x10(%ebp)
  80407a:	ff 75 08             	pushl  0x8(%ebp)
  80407d:	e8 02 ef ff ff       	call   802f84 <set_block_data>
  804082:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804085:	8b 45 08             	mov    0x8(%ebp),%eax
  804088:	83 e8 04             	sub    $0x4,%eax
  80408b:	8b 00                	mov    (%eax),%eax
  80408d:	83 e0 fe             	and    $0xfffffffe,%eax
  804090:	89 c2                	mov    %eax,%edx
  804092:	8b 45 08             	mov    0x8(%ebp),%eax
  804095:	01 d0                	add    %edx,%eax
  804097:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80409a:	83 ec 04             	sub    $0x4,%esp
  80409d:	6a 00                	push   $0x0
  80409f:	ff 75 cc             	pushl  -0x34(%ebp)
  8040a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8040a5:	e8 da ee ff ff       	call   802f84 <set_block_data>
  8040aa:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040b1:	74 06                	je     8040b9 <realloc_block_FF+0x142>
  8040b3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8040b7:	75 17                	jne    8040d0 <realloc_block_FF+0x159>
  8040b9:	83 ec 04             	sub    $0x4,%esp
  8040bc:	68 04 59 80 00       	push   $0x805904
  8040c1:	68 f6 01 00 00       	push   $0x1f6
  8040c6:	68 91 58 80 00       	push   $0x805891
  8040cb:	e8 c1 cf ff ff       	call   801091 <_panic>
  8040d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d3:	8b 10                	mov    (%eax),%edx
  8040d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040d8:	89 10                	mov    %edx,(%eax)
  8040da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040dd:	8b 00                	mov    (%eax),%eax
  8040df:	85 c0                	test   %eax,%eax
  8040e1:	74 0b                	je     8040ee <realloc_block_FF+0x177>
  8040e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e6:	8b 00                	mov    (%eax),%eax
  8040e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040eb:	89 50 04             	mov    %edx,0x4(%eax)
  8040ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040f4:	89 10                	mov    %edx,(%eax)
  8040f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040fc:	89 50 04             	mov    %edx,0x4(%eax)
  8040ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804102:	8b 00                	mov    (%eax),%eax
  804104:	85 c0                	test   %eax,%eax
  804106:	75 08                	jne    804110 <realloc_block_FF+0x199>
  804108:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80410b:	a3 48 60 80 00       	mov    %eax,0x806048
  804110:	a1 50 60 80 00       	mov    0x806050,%eax
  804115:	40                   	inc    %eax
  804116:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80411b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80411f:	75 17                	jne    804138 <realloc_block_FF+0x1c1>
  804121:	83 ec 04             	sub    $0x4,%esp
  804124:	68 73 58 80 00       	push   $0x805873
  804129:	68 f7 01 00 00       	push   $0x1f7
  80412e:	68 91 58 80 00       	push   $0x805891
  804133:	e8 59 cf ff ff       	call   801091 <_panic>
  804138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413b:	8b 00                	mov    (%eax),%eax
  80413d:	85 c0                	test   %eax,%eax
  80413f:	74 10                	je     804151 <realloc_block_FF+0x1da>
  804141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804144:	8b 00                	mov    (%eax),%eax
  804146:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804149:	8b 52 04             	mov    0x4(%edx),%edx
  80414c:	89 50 04             	mov    %edx,0x4(%eax)
  80414f:	eb 0b                	jmp    80415c <realloc_block_FF+0x1e5>
  804151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804154:	8b 40 04             	mov    0x4(%eax),%eax
  804157:	a3 48 60 80 00       	mov    %eax,0x806048
  80415c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415f:	8b 40 04             	mov    0x4(%eax),%eax
  804162:	85 c0                	test   %eax,%eax
  804164:	74 0f                	je     804175 <realloc_block_FF+0x1fe>
  804166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804169:	8b 40 04             	mov    0x4(%eax),%eax
  80416c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80416f:	8b 12                	mov    (%edx),%edx
  804171:	89 10                	mov    %edx,(%eax)
  804173:	eb 0a                	jmp    80417f <realloc_block_FF+0x208>
  804175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804178:	8b 00                	mov    (%eax),%eax
  80417a:	a3 44 60 80 00       	mov    %eax,0x806044
  80417f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804192:	a1 50 60 80 00       	mov    0x806050,%eax
  804197:	48                   	dec    %eax
  804198:	a3 50 60 80 00       	mov    %eax,0x806050
  80419d:	e9 83 02 00 00       	jmp    804425 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8041a2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8041a6:	0f 86 69 02 00 00    	jbe    804415 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8041ac:	83 ec 04             	sub    $0x4,%esp
  8041af:	6a 01                	push   $0x1
  8041b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8041b4:	ff 75 08             	pushl  0x8(%ebp)
  8041b7:	e8 c8 ed ff ff       	call   802f84 <set_block_data>
  8041bc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c2:	83 e8 04             	sub    $0x4,%eax
  8041c5:	8b 00                	mov    (%eax),%eax
  8041c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8041ca:	89 c2                	mov    %eax,%edx
  8041cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8041cf:	01 d0                	add    %edx,%eax
  8041d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8041d4:	a1 50 60 80 00       	mov    0x806050,%eax
  8041d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8041dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8041e0:	75 68                	jne    80424a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041e6:	75 17                	jne    8041ff <realloc_block_FF+0x288>
  8041e8:	83 ec 04             	sub    $0x4,%esp
  8041eb:	68 ac 58 80 00       	push   $0x8058ac
  8041f0:	68 06 02 00 00       	push   $0x206
  8041f5:	68 91 58 80 00       	push   $0x805891
  8041fa:	e8 92 ce ff ff       	call   801091 <_panic>
  8041ff:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804205:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804208:	89 10                	mov    %edx,(%eax)
  80420a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80420d:	8b 00                	mov    (%eax),%eax
  80420f:	85 c0                	test   %eax,%eax
  804211:	74 0d                	je     804220 <realloc_block_FF+0x2a9>
  804213:	a1 44 60 80 00       	mov    0x806044,%eax
  804218:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80421b:	89 50 04             	mov    %edx,0x4(%eax)
  80421e:	eb 08                	jmp    804228 <realloc_block_FF+0x2b1>
  804220:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804223:	a3 48 60 80 00       	mov    %eax,0x806048
  804228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80422b:	a3 44 60 80 00       	mov    %eax,0x806044
  804230:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804233:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80423a:	a1 50 60 80 00       	mov    0x806050,%eax
  80423f:	40                   	inc    %eax
  804240:	a3 50 60 80 00       	mov    %eax,0x806050
  804245:	e9 b0 01 00 00       	jmp    8043fa <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80424a:	a1 44 60 80 00       	mov    0x806044,%eax
  80424f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804252:	76 68                	jbe    8042bc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804254:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804258:	75 17                	jne    804271 <realloc_block_FF+0x2fa>
  80425a:	83 ec 04             	sub    $0x4,%esp
  80425d:	68 ac 58 80 00       	push   $0x8058ac
  804262:	68 0b 02 00 00       	push   $0x20b
  804267:	68 91 58 80 00       	push   $0x805891
  80426c:	e8 20 ce ff ff       	call   801091 <_panic>
  804271:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804277:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80427a:	89 10                	mov    %edx,(%eax)
  80427c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80427f:	8b 00                	mov    (%eax),%eax
  804281:	85 c0                	test   %eax,%eax
  804283:	74 0d                	je     804292 <realloc_block_FF+0x31b>
  804285:	a1 44 60 80 00       	mov    0x806044,%eax
  80428a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80428d:	89 50 04             	mov    %edx,0x4(%eax)
  804290:	eb 08                	jmp    80429a <realloc_block_FF+0x323>
  804292:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804295:	a3 48 60 80 00       	mov    %eax,0x806048
  80429a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80429d:	a3 44 60 80 00       	mov    %eax,0x806044
  8042a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ac:	a1 50 60 80 00       	mov    0x806050,%eax
  8042b1:	40                   	inc    %eax
  8042b2:	a3 50 60 80 00       	mov    %eax,0x806050
  8042b7:	e9 3e 01 00 00       	jmp    8043fa <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8042bc:	a1 44 60 80 00       	mov    0x806044,%eax
  8042c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042c4:	73 68                	jae    80432e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042ca:	75 17                	jne    8042e3 <realloc_block_FF+0x36c>
  8042cc:	83 ec 04             	sub    $0x4,%esp
  8042cf:	68 e0 58 80 00       	push   $0x8058e0
  8042d4:	68 10 02 00 00       	push   $0x210
  8042d9:	68 91 58 80 00       	push   $0x805891
  8042de:	e8 ae cd ff ff       	call   801091 <_panic>
  8042e3:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8042e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ec:	89 50 04             	mov    %edx,0x4(%eax)
  8042ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f2:	8b 40 04             	mov    0x4(%eax),%eax
  8042f5:	85 c0                	test   %eax,%eax
  8042f7:	74 0c                	je     804305 <realloc_block_FF+0x38e>
  8042f9:	a1 48 60 80 00       	mov    0x806048,%eax
  8042fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804301:	89 10                	mov    %edx,(%eax)
  804303:	eb 08                	jmp    80430d <realloc_block_FF+0x396>
  804305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804308:	a3 44 60 80 00       	mov    %eax,0x806044
  80430d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804310:	a3 48 60 80 00       	mov    %eax,0x806048
  804315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804318:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80431e:	a1 50 60 80 00       	mov    0x806050,%eax
  804323:	40                   	inc    %eax
  804324:	a3 50 60 80 00       	mov    %eax,0x806050
  804329:	e9 cc 00 00 00       	jmp    8043fa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80432e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804335:	a1 44 60 80 00       	mov    0x806044,%eax
  80433a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80433d:	e9 8a 00 00 00       	jmp    8043cc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804345:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804348:	73 7a                	jae    8043c4 <realloc_block_FF+0x44d>
  80434a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80434d:	8b 00                	mov    (%eax),%eax
  80434f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804352:	73 70                	jae    8043c4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804358:	74 06                	je     804360 <realloc_block_FF+0x3e9>
  80435a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80435e:	75 17                	jne    804377 <realloc_block_FF+0x400>
  804360:	83 ec 04             	sub    $0x4,%esp
  804363:	68 04 59 80 00       	push   $0x805904
  804368:	68 1a 02 00 00       	push   $0x21a
  80436d:	68 91 58 80 00       	push   $0x805891
  804372:	e8 1a cd ff ff       	call   801091 <_panic>
  804377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437a:	8b 10                	mov    (%eax),%edx
  80437c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80437f:	89 10                	mov    %edx,(%eax)
  804381:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804384:	8b 00                	mov    (%eax),%eax
  804386:	85 c0                	test   %eax,%eax
  804388:	74 0b                	je     804395 <realloc_block_FF+0x41e>
  80438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80438d:	8b 00                	mov    (%eax),%eax
  80438f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804392:	89 50 04             	mov    %edx,0x4(%eax)
  804395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804398:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80439b:	89 10                	mov    %edx,(%eax)
  80439d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043a3:	89 50 04             	mov    %edx,0x4(%eax)
  8043a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a9:	8b 00                	mov    (%eax),%eax
  8043ab:	85 c0                	test   %eax,%eax
  8043ad:	75 08                	jne    8043b7 <realloc_block_FF+0x440>
  8043af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043b2:	a3 48 60 80 00       	mov    %eax,0x806048
  8043b7:	a1 50 60 80 00       	mov    0x806050,%eax
  8043bc:	40                   	inc    %eax
  8043bd:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  8043c2:	eb 36                	jmp    8043fa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8043c4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043d0:	74 07                	je     8043d9 <realloc_block_FF+0x462>
  8043d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d5:	8b 00                	mov    (%eax),%eax
  8043d7:	eb 05                	jmp    8043de <realloc_block_FF+0x467>
  8043d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043de:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8043e3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043e8:	85 c0                	test   %eax,%eax
  8043ea:	0f 85 52 ff ff ff    	jne    804342 <realloc_block_FF+0x3cb>
  8043f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043f4:	0f 85 48 ff ff ff    	jne    804342 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8043fa:	83 ec 04             	sub    $0x4,%esp
  8043fd:	6a 00                	push   $0x0
  8043ff:	ff 75 d8             	pushl  -0x28(%ebp)
  804402:	ff 75 d4             	pushl  -0x2c(%ebp)
  804405:	e8 7a eb ff ff       	call   802f84 <set_block_data>
  80440a:	83 c4 10             	add    $0x10,%esp
				return va;
  80440d:	8b 45 08             	mov    0x8(%ebp),%eax
  804410:	e9 7b 02 00 00       	jmp    804690 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804415:	83 ec 0c             	sub    $0xc,%esp
  804418:	68 81 59 80 00       	push   $0x805981
  80441d:	e8 2c cf ff ff       	call   80134e <cprintf>
  804422:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804425:	8b 45 08             	mov    0x8(%ebp),%eax
  804428:	e9 63 02 00 00       	jmp    804690 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80442d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804430:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804433:	0f 86 4d 02 00 00    	jbe    804686 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804439:	83 ec 0c             	sub    $0xc,%esp
  80443c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80443f:	e8 08 e8 ff ff       	call   802c4c <is_free_block>
  804444:	83 c4 10             	add    $0x10,%esp
  804447:	84 c0                	test   %al,%al
  804449:	0f 84 37 02 00 00    	je     804686 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80444f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804452:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804455:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804458:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80445b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80445e:	76 38                	jbe    804498 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804460:	83 ec 0c             	sub    $0xc,%esp
  804463:	ff 75 08             	pushl  0x8(%ebp)
  804466:	e8 0c fa ff ff       	call   803e77 <free_block>
  80446b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80446e:	83 ec 0c             	sub    $0xc,%esp
  804471:	ff 75 0c             	pushl  0xc(%ebp)
  804474:	e8 3a eb ff ff       	call   802fb3 <alloc_block_FF>
  804479:	83 c4 10             	add    $0x10,%esp
  80447c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80447f:	83 ec 08             	sub    $0x8,%esp
  804482:	ff 75 c0             	pushl  -0x40(%ebp)
  804485:	ff 75 08             	pushl  0x8(%ebp)
  804488:	e8 ab fa ff ff       	call   803f38 <copy_data>
  80448d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804490:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804493:	e9 f8 01 00 00       	jmp    804690 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80449b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80449e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8044a1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8044a5:	0f 87 a0 00 00 00    	ja     80454b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8044ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044af:	75 17                	jne    8044c8 <realloc_block_FF+0x551>
  8044b1:	83 ec 04             	sub    $0x4,%esp
  8044b4:	68 73 58 80 00       	push   $0x805873
  8044b9:	68 38 02 00 00       	push   $0x238
  8044be:	68 91 58 80 00       	push   $0x805891
  8044c3:	e8 c9 cb ff ff       	call   801091 <_panic>
  8044c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044cb:	8b 00                	mov    (%eax),%eax
  8044cd:	85 c0                	test   %eax,%eax
  8044cf:	74 10                	je     8044e1 <realloc_block_FF+0x56a>
  8044d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d4:	8b 00                	mov    (%eax),%eax
  8044d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044d9:	8b 52 04             	mov    0x4(%edx),%edx
  8044dc:	89 50 04             	mov    %edx,0x4(%eax)
  8044df:	eb 0b                	jmp    8044ec <realloc_block_FF+0x575>
  8044e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e4:	8b 40 04             	mov    0x4(%eax),%eax
  8044e7:	a3 48 60 80 00       	mov    %eax,0x806048
  8044ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ef:	8b 40 04             	mov    0x4(%eax),%eax
  8044f2:	85 c0                	test   %eax,%eax
  8044f4:	74 0f                	je     804505 <realloc_block_FF+0x58e>
  8044f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f9:	8b 40 04             	mov    0x4(%eax),%eax
  8044fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044ff:	8b 12                	mov    (%edx),%edx
  804501:	89 10                	mov    %edx,(%eax)
  804503:	eb 0a                	jmp    80450f <realloc_block_FF+0x598>
  804505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804508:	8b 00                	mov    (%eax),%eax
  80450a:	a3 44 60 80 00       	mov    %eax,0x806044
  80450f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80451b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804522:	a1 50 60 80 00       	mov    0x806050,%eax
  804527:	48                   	dec    %eax
  804528:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80452d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804533:	01 d0                	add    %edx,%eax
  804535:	83 ec 04             	sub    $0x4,%esp
  804538:	6a 01                	push   $0x1
  80453a:	50                   	push   %eax
  80453b:	ff 75 08             	pushl  0x8(%ebp)
  80453e:	e8 41 ea ff ff       	call   802f84 <set_block_data>
  804543:	83 c4 10             	add    $0x10,%esp
  804546:	e9 36 01 00 00       	jmp    804681 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80454b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80454e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804551:	01 d0                	add    %edx,%eax
  804553:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804556:	83 ec 04             	sub    $0x4,%esp
  804559:	6a 01                	push   $0x1
  80455b:	ff 75 f0             	pushl  -0x10(%ebp)
  80455e:	ff 75 08             	pushl  0x8(%ebp)
  804561:	e8 1e ea ff ff       	call   802f84 <set_block_data>
  804566:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804569:	8b 45 08             	mov    0x8(%ebp),%eax
  80456c:	83 e8 04             	sub    $0x4,%eax
  80456f:	8b 00                	mov    (%eax),%eax
  804571:	83 e0 fe             	and    $0xfffffffe,%eax
  804574:	89 c2                	mov    %eax,%edx
  804576:	8b 45 08             	mov    0x8(%ebp),%eax
  804579:	01 d0                	add    %edx,%eax
  80457b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80457e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804582:	74 06                	je     80458a <realloc_block_FF+0x613>
  804584:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804588:	75 17                	jne    8045a1 <realloc_block_FF+0x62a>
  80458a:	83 ec 04             	sub    $0x4,%esp
  80458d:	68 04 59 80 00       	push   $0x805904
  804592:	68 44 02 00 00       	push   $0x244
  804597:	68 91 58 80 00       	push   $0x805891
  80459c:	e8 f0 ca ff ff       	call   801091 <_panic>
  8045a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045a4:	8b 10                	mov    (%eax),%edx
  8045a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045a9:	89 10                	mov    %edx,(%eax)
  8045ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045ae:	8b 00                	mov    (%eax),%eax
  8045b0:	85 c0                	test   %eax,%eax
  8045b2:	74 0b                	je     8045bf <realloc_block_FF+0x648>
  8045b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b7:	8b 00                	mov    (%eax),%eax
  8045b9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045bc:	89 50 04             	mov    %edx,0x4(%eax)
  8045bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045c5:	89 10                	mov    %edx,(%eax)
  8045c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045cd:	89 50 04             	mov    %edx,0x4(%eax)
  8045d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045d3:	8b 00                	mov    (%eax),%eax
  8045d5:	85 c0                	test   %eax,%eax
  8045d7:	75 08                	jne    8045e1 <realloc_block_FF+0x66a>
  8045d9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045dc:	a3 48 60 80 00       	mov    %eax,0x806048
  8045e1:	a1 50 60 80 00       	mov    0x806050,%eax
  8045e6:	40                   	inc    %eax
  8045e7:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045f0:	75 17                	jne    804609 <realloc_block_FF+0x692>
  8045f2:	83 ec 04             	sub    $0x4,%esp
  8045f5:	68 73 58 80 00       	push   $0x805873
  8045fa:	68 45 02 00 00       	push   $0x245
  8045ff:	68 91 58 80 00       	push   $0x805891
  804604:	e8 88 ca ff ff       	call   801091 <_panic>
  804609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80460c:	8b 00                	mov    (%eax),%eax
  80460e:	85 c0                	test   %eax,%eax
  804610:	74 10                	je     804622 <realloc_block_FF+0x6ab>
  804612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804615:	8b 00                	mov    (%eax),%eax
  804617:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80461a:	8b 52 04             	mov    0x4(%edx),%edx
  80461d:	89 50 04             	mov    %edx,0x4(%eax)
  804620:	eb 0b                	jmp    80462d <realloc_block_FF+0x6b6>
  804622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804625:	8b 40 04             	mov    0x4(%eax),%eax
  804628:	a3 48 60 80 00       	mov    %eax,0x806048
  80462d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804630:	8b 40 04             	mov    0x4(%eax),%eax
  804633:	85 c0                	test   %eax,%eax
  804635:	74 0f                	je     804646 <realloc_block_FF+0x6cf>
  804637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80463a:	8b 40 04             	mov    0x4(%eax),%eax
  80463d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804640:	8b 12                	mov    (%edx),%edx
  804642:	89 10                	mov    %edx,(%eax)
  804644:	eb 0a                	jmp    804650 <realloc_block_FF+0x6d9>
  804646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804649:	8b 00                	mov    (%eax),%eax
  80464b:	a3 44 60 80 00       	mov    %eax,0x806044
  804650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804653:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80465c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804663:	a1 50 60 80 00       	mov    0x806050,%eax
  804668:	48                   	dec    %eax
  804669:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  80466e:	83 ec 04             	sub    $0x4,%esp
  804671:	6a 00                	push   $0x0
  804673:	ff 75 bc             	pushl  -0x44(%ebp)
  804676:	ff 75 b8             	pushl  -0x48(%ebp)
  804679:	e8 06 e9 ff ff       	call   802f84 <set_block_data>
  80467e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804681:	8b 45 08             	mov    0x8(%ebp),%eax
  804684:	eb 0a                	jmp    804690 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804686:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80468d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804690:	c9                   	leave  
  804691:	c3                   	ret    

00804692 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804692:	55                   	push   %ebp
  804693:	89 e5                	mov    %esp,%ebp
  804695:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804698:	83 ec 04             	sub    $0x4,%esp
  80469b:	68 88 59 80 00       	push   $0x805988
  8046a0:	68 58 02 00 00       	push   $0x258
  8046a5:	68 91 58 80 00       	push   $0x805891
  8046aa:	e8 e2 c9 ff ff       	call   801091 <_panic>

008046af <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8046af:	55                   	push   %ebp
  8046b0:	89 e5                	mov    %esp,%ebp
  8046b2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8046b5:	83 ec 04             	sub    $0x4,%esp
  8046b8:	68 b0 59 80 00       	push   $0x8059b0
  8046bd:	68 61 02 00 00       	push   $0x261
  8046c2:	68 91 58 80 00       	push   $0x805891
  8046c7:	e8 c5 c9 ff ff       	call   801091 <_panic>

008046cc <__udivdi3>:
  8046cc:	55                   	push   %ebp
  8046cd:	57                   	push   %edi
  8046ce:	56                   	push   %esi
  8046cf:	53                   	push   %ebx
  8046d0:	83 ec 1c             	sub    $0x1c,%esp
  8046d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8046e3:	89 ca                	mov    %ecx,%edx
  8046e5:	89 f8                	mov    %edi,%eax
  8046e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046eb:	85 f6                	test   %esi,%esi
  8046ed:	75 2d                	jne    80471c <__udivdi3+0x50>
  8046ef:	39 cf                	cmp    %ecx,%edi
  8046f1:	77 65                	ja     804758 <__udivdi3+0x8c>
  8046f3:	89 fd                	mov    %edi,%ebp
  8046f5:	85 ff                	test   %edi,%edi
  8046f7:	75 0b                	jne    804704 <__udivdi3+0x38>
  8046f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8046fe:	31 d2                	xor    %edx,%edx
  804700:	f7 f7                	div    %edi
  804702:	89 c5                	mov    %eax,%ebp
  804704:	31 d2                	xor    %edx,%edx
  804706:	89 c8                	mov    %ecx,%eax
  804708:	f7 f5                	div    %ebp
  80470a:	89 c1                	mov    %eax,%ecx
  80470c:	89 d8                	mov    %ebx,%eax
  80470e:	f7 f5                	div    %ebp
  804710:	89 cf                	mov    %ecx,%edi
  804712:	89 fa                	mov    %edi,%edx
  804714:	83 c4 1c             	add    $0x1c,%esp
  804717:	5b                   	pop    %ebx
  804718:	5e                   	pop    %esi
  804719:	5f                   	pop    %edi
  80471a:	5d                   	pop    %ebp
  80471b:	c3                   	ret    
  80471c:	39 ce                	cmp    %ecx,%esi
  80471e:	77 28                	ja     804748 <__udivdi3+0x7c>
  804720:	0f bd fe             	bsr    %esi,%edi
  804723:	83 f7 1f             	xor    $0x1f,%edi
  804726:	75 40                	jne    804768 <__udivdi3+0x9c>
  804728:	39 ce                	cmp    %ecx,%esi
  80472a:	72 0a                	jb     804736 <__udivdi3+0x6a>
  80472c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804730:	0f 87 9e 00 00 00    	ja     8047d4 <__udivdi3+0x108>
  804736:	b8 01 00 00 00       	mov    $0x1,%eax
  80473b:	89 fa                	mov    %edi,%edx
  80473d:	83 c4 1c             	add    $0x1c,%esp
  804740:	5b                   	pop    %ebx
  804741:	5e                   	pop    %esi
  804742:	5f                   	pop    %edi
  804743:	5d                   	pop    %ebp
  804744:	c3                   	ret    
  804745:	8d 76 00             	lea    0x0(%esi),%esi
  804748:	31 ff                	xor    %edi,%edi
  80474a:	31 c0                	xor    %eax,%eax
  80474c:	89 fa                	mov    %edi,%edx
  80474e:	83 c4 1c             	add    $0x1c,%esp
  804751:	5b                   	pop    %ebx
  804752:	5e                   	pop    %esi
  804753:	5f                   	pop    %edi
  804754:	5d                   	pop    %ebp
  804755:	c3                   	ret    
  804756:	66 90                	xchg   %ax,%ax
  804758:	89 d8                	mov    %ebx,%eax
  80475a:	f7 f7                	div    %edi
  80475c:	31 ff                	xor    %edi,%edi
  80475e:	89 fa                	mov    %edi,%edx
  804760:	83 c4 1c             	add    $0x1c,%esp
  804763:	5b                   	pop    %ebx
  804764:	5e                   	pop    %esi
  804765:	5f                   	pop    %edi
  804766:	5d                   	pop    %ebp
  804767:	c3                   	ret    
  804768:	bd 20 00 00 00       	mov    $0x20,%ebp
  80476d:	89 eb                	mov    %ebp,%ebx
  80476f:	29 fb                	sub    %edi,%ebx
  804771:	89 f9                	mov    %edi,%ecx
  804773:	d3 e6                	shl    %cl,%esi
  804775:	89 c5                	mov    %eax,%ebp
  804777:	88 d9                	mov    %bl,%cl
  804779:	d3 ed                	shr    %cl,%ebp
  80477b:	89 e9                	mov    %ebp,%ecx
  80477d:	09 f1                	or     %esi,%ecx
  80477f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804783:	89 f9                	mov    %edi,%ecx
  804785:	d3 e0                	shl    %cl,%eax
  804787:	89 c5                	mov    %eax,%ebp
  804789:	89 d6                	mov    %edx,%esi
  80478b:	88 d9                	mov    %bl,%cl
  80478d:	d3 ee                	shr    %cl,%esi
  80478f:	89 f9                	mov    %edi,%ecx
  804791:	d3 e2                	shl    %cl,%edx
  804793:	8b 44 24 08          	mov    0x8(%esp),%eax
  804797:	88 d9                	mov    %bl,%cl
  804799:	d3 e8                	shr    %cl,%eax
  80479b:	09 c2                	or     %eax,%edx
  80479d:	89 d0                	mov    %edx,%eax
  80479f:	89 f2                	mov    %esi,%edx
  8047a1:	f7 74 24 0c          	divl   0xc(%esp)
  8047a5:	89 d6                	mov    %edx,%esi
  8047a7:	89 c3                	mov    %eax,%ebx
  8047a9:	f7 e5                	mul    %ebp
  8047ab:	39 d6                	cmp    %edx,%esi
  8047ad:	72 19                	jb     8047c8 <__udivdi3+0xfc>
  8047af:	74 0b                	je     8047bc <__udivdi3+0xf0>
  8047b1:	89 d8                	mov    %ebx,%eax
  8047b3:	31 ff                	xor    %edi,%edi
  8047b5:	e9 58 ff ff ff       	jmp    804712 <__udivdi3+0x46>
  8047ba:	66 90                	xchg   %ax,%ax
  8047bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047c0:	89 f9                	mov    %edi,%ecx
  8047c2:	d3 e2                	shl    %cl,%edx
  8047c4:	39 c2                	cmp    %eax,%edx
  8047c6:	73 e9                	jae    8047b1 <__udivdi3+0xe5>
  8047c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047cb:	31 ff                	xor    %edi,%edi
  8047cd:	e9 40 ff ff ff       	jmp    804712 <__udivdi3+0x46>
  8047d2:	66 90                	xchg   %ax,%ax
  8047d4:	31 c0                	xor    %eax,%eax
  8047d6:	e9 37 ff ff ff       	jmp    804712 <__udivdi3+0x46>
  8047db:	90                   	nop

008047dc <__umoddi3>:
  8047dc:	55                   	push   %ebp
  8047dd:	57                   	push   %edi
  8047de:	56                   	push   %esi
  8047df:	53                   	push   %ebx
  8047e0:	83 ec 1c             	sub    $0x1c,%esp
  8047e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8047e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047fb:	89 f3                	mov    %esi,%ebx
  8047fd:	89 fa                	mov    %edi,%edx
  8047ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804803:	89 34 24             	mov    %esi,(%esp)
  804806:	85 c0                	test   %eax,%eax
  804808:	75 1a                	jne    804824 <__umoddi3+0x48>
  80480a:	39 f7                	cmp    %esi,%edi
  80480c:	0f 86 a2 00 00 00    	jbe    8048b4 <__umoddi3+0xd8>
  804812:	89 c8                	mov    %ecx,%eax
  804814:	89 f2                	mov    %esi,%edx
  804816:	f7 f7                	div    %edi
  804818:	89 d0                	mov    %edx,%eax
  80481a:	31 d2                	xor    %edx,%edx
  80481c:	83 c4 1c             	add    $0x1c,%esp
  80481f:	5b                   	pop    %ebx
  804820:	5e                   	pop    %esi
  804821:	5f                   	pop    %edi
  804822:	5d                   	pop    %ebp
  804823:	c3                   	ret    
  804824:	39 f0                	cmp    %esi,%eax
  804826:	0f 87 ac 00 00 00    	ja     8048d8 <__umoddi3+0xfc>
  80482c:	0f bd e8             	bsr    %eax,%ebp
  80482f:	83 f5 1f             	xor    $0x1f,%ebp
  804832:	0f 84 ac 00 00 00    	je     8048e4 <__umoddi3+0x108>
  804838:	bf 20 00 00 00       	mov    $0x20,%edi
  80483d:	29 ef                	sub    %ebp,%edi
  80483f:	89 fe                	mov    %edi,%esi
  804841:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804845:	89 e9                	mov    %ebp,%ecx
  804847:	d3 e0                	shl    %cl,%eax
  804849:	89 d7                	mov    %edx,%edi
  80484b:	89 f1                	mov    %esi,%ecx
  80484d:	d3 ef                	shr    %cl,%edi
  80484f:	09 c7                	or     %eax,%edi
  804851:	89 e9                	mov    %ebp,%ecx
  804853:	d3 e2                	shl    %cl,%edx
  804855:	89 14 24             	mov    %edx,(%esp)
  804858:	89 d8                	mov    %ebx,%eax
  80485a:	d3 e0                	shl    %cl,%eax
  80485c:	89 c2                	mov    %eax,%edx
  80485e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804862:	d3 e0                	shl    %cl,%eax
  804864:	89 44 24 04          	mov    %eax,0x4(%esp)
  804868:	8b 44 24 08          	mov    0x8(%esp),%eax
  80486c:	89 f1                	mov    %esi,%ecx
  80486e:	d3 e8                	shr    %cl,%eax
  804870:	09 d0                	or     %edx,%eax
  804872:	d3 eb                	shr    %cl,%ebx
  804874:	89 da                	mov    %ebx,%edx
  804876:	f7 f7                	div    %edi
  804878:	89 d3                	mov    %edx,%ebx
  80487a:	f7 24 24             	mull   (%esp)
  80487d:	89 c6                	mov    %eax,%esi
  80487f:	89 d1                	mov    %edx,%ecx
  804881:	39 d3                	cmp    %edx,%ebx
  804883:	0f 82 87 00 00 00    	jb     804910 <__umoddi3+0x134>
  804889:	0f 84 91 00 00 00    	je     804920 <__umoddi3+0x144>
  80488f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804893:	29 f2                	sub    %esi,%edx
  804895:	19 cb                	sbb    %ecx,%ebx
  804897:	89 d8                	mov    %ebx,%eax
  804899:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80489d:	d3 e0                	shl    %cl,%eax
  80489f:	89 e9                	mov    %ebp,%ecx
  8048a1:	d3 ea                	shr    %cl,%edx
  8048a3:	09 d0                	or     %edx,%eax
  8048a5:	89 e9                	mov    %ebp,%ecx
  8048a7:	d3 eb                	shr    %cl,%ebx
  8048a9:	89 da                	mov    %ebx,%edx
  8048ab:	83 c4 1c             	add    $0x1c,%esp
  8048ae:	5b                   	pop    %ebx
  8048af:	5e                   	pop    %esi
  8048b0:	5f                   	pop    %edi
  8048b1:	5d                   	pop    %ebp
  8048b2:	c3                   	ret    
  8048b3:	90                   	nop
  8048b4:	89 fd                	mov    %edi,%ebp
  8048b6:	85 ff                	test   %edi,%edi
  8048b8:	75 0b                	jne    8048c5 <__umoddi3+0xe9>
  8048ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8048bf:	31 d2                	xor    %edx,%edx
  8048c1:	f7 f7                	div    %edi
  8048c3:	89 c5                	mov    %eax,%ebp
  8048c5:	89 f0                	mov    %esi,%eax
  8048c7:	31 d2                	xor    %edx,%edx
  8048c9:	f7 f5                	div    %ebp
  8048cb:	89 c8                	mov    %ecx,%eax
  8048cd:	f7 f5                	div    %ebp
  8048cf:	89 d0                	mov    %edx,%eax
  8048d1:	e9 44 ff ff ff       	jmp    80481a <__umoddi3+0x3e>
  8048d6:	66 90                	xchg   %ax,%ax
  8048d8:	89 c8                	mov    %ecx,%eax
  8048da:	89 f2                	mov    %esi,%edx
  8048dc:	83 c4 1c             	add    $0x1c,%esp
  8048df:	5b                   	pop    %ebx
  8048e0:	5e                   	pop    %esi
  8048e1:	5f                   	pop    %edi
  8048e2:	5d                   	pop    %ebp
  8048e3:	c3                   	ret    
  8048e4:	3b 04 24             	cmp    (%esp),%eax
  8048e7:	72 06                	jb     8048ef <__umoddi3+0x113>
  8048e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048ed:	77 0f                	ja     8048fe <__umoddi3+0x122>
  8048ef:	89 f2                	mov    %esi,%edx
  8048f1:	29 f9                	sub    %edi,%ecx
  8048f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048f7:	89 14 24             	mov    %edx,(%esp)
  8048fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  804902:	8b 14 24             	mov    (%esp),%edx
  804905:	83 c4 1c             	add    $0x1c,%esp
  804908:	5b                   	pop    %ebx
  804909:	5e                   	pop    %esi
  80490a:	5f                   	pop    %edi
  80490b:	5d                   	pop    %ebp
  80490c:	c3                   	ret    
  80490d:	8d 76 00             	lea    0x0(%esi),%esi
  804910:	2b 04 24             	sub    (%esp),%eax
  804913:	19 fa                	sbb    %edi,%edx
  804915:	89 d1                	mov    %edx,%ecx
  804917:	89 c6                	mov    %eax,%esi
  804919:	e9 71 ff ff ff       	jmp    80488f <__umoddi3+0xb3>
  80491e:	66 90                	xchg   %ax,%ax
  804920:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804924:	72 ea                	jb     804910 <__umoddi3+0x134>
  804926:	89 d9                	mov    %ebx,%ecx
  804928:	e9 62 ff ff ff       	jmp    80488f <__umoddi3+0xb3>
