
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
  800055:	68 e0 48 80 00       	push   $0x8048e0
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
  8000a5:	68 10 49 80 00       	push   $0x804910
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
  8000d1:	e8 f8 29 00 00       	call   802ace <sys_set_uheap_strategy>
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
  8000f6:	68 49 49 80 00       	push   $0x804949
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 65 49 80 00       	push   $0x804965
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
  800123:	e8 f3 25 00 00       	call   80271b <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 a0 25 00 00       	call   8026d0 <sys_calculate_free_frames>
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
  80013d:	68 78 49 80 00       	push   $0x804978
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
  8002ac:	68 d0 49 80 00       	push   $0x8049d0
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 65 49 80 00       	push   $0x804965
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
  80031b:	68 f8 49 80 00       	push   $0x8049f8
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 d7 28 00 00       	call   802c10 <alloc_block>
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
  80037f:	68 1c 4a 80 00       	push   $0x804a1c
  800384:	6a 7f                	push   $0x7f
  800386:	68 65 49 80 00       	push   $0x804965
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 3b 23 00 00       	call   8026d0 <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 44 4a 80 00       	push   $0x804a44
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
  800443:	68 8c 4a 80 00       	push   $0x804a8c
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
  80049a:	68 ac 4a 80 00       	push   $0x804aac
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
  8004ee:	68 cc 4a 80 00       	push   $0x804acc
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
  800538:	68 fc 4a 80 00       	push   $0x804afc
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
  800552:	68 1c 4b 80 00       	push   $0x804b1c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 57 4b 80 00       	push   $0x804b57
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
  8005e0:	68 6c 4b 80 00       	push   $0x804b6c
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 8b 4b 80 00       	push   $0x804b8b
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
  800669:	68 a4 4b 80 00       	push   $0x804ba4
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
  800683:	68 c4 4b 80 00       	push   $0x804bc4
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 fb 4b 80 00       	push   $0x804bfb
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
  800711:	68 10 4c 80 00       	push   $0x804c10
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 2f 4c 80 00       	push   $0x804c2f
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
  800762:	e8 72 24 00 00       	call   802bd9 <get_block_size>
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
  8007b7:	68 48 4c 80 00       	push   $0x804c48
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
  8007d1:	68 68 4c 80 00       	push   $0x804c68
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
  80083d:	e8 97 23 00 00       	call   802bd9 <get_block_size>
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
  80089b:	68 a5 4c 80 00       	push   $0x804ca5
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
  8008b5:	68 c4 4c 80 00       	push   $0x804cc4
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 04 4d 80 00       	push   $0x804d04
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 29 4d 80 00       	push   $0x804d29
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
  800963:	68 40 4d 80 00       	push   $0x804d40
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 70 4d 80 00       	push   $0x804d70
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
  8009fa:	68 9c 4d 80 00       	push   $0x804d9c
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 cc 4d 80 00       	push   $0x804dcc
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
  800a68:	68 0c 4e 80 00       	push   $0x804e0c
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
  800a82:	68 3c 4e 80 00       	push   $0x804e3c
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
  800b11:	68 68 4e 80 00       	push   $0x804e68
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
  800b2b:	68 98 4e 80 00       	push   $0x804e98
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 c0 4e 80 00       	push   $0x804ec0
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
  800bca:	68 e0 4e 80 00       	push   $0x804ee0
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
  800c3d:	68 10 4f 80 00       	push   $0x804f10
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
  800ca4:	e8 f6 1f 00 00       	call   802c9f <print_blocks_list>
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
  800ce6:	68 28 4f 80 00       	push   $0x804f28
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 58 4f 80 00       	push   $0x804f58
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
  800d83:	68 90 4f 80 00       	push   $0x804f90
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
  800d9d:	68 c0 4f 80 00       	push   $0x804fc0
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 1a 19 00 00       	call   8026d0 <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 04 50 80 00       	push   $0x805004
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
  800e7a:	68 70 50 80 00       	push   $0x805070
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
  800efe:	e8 28 1c 00 00       	call   802b2b <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 ac 50 80 00       	push   $0x8050ac
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
  800f3c:	68 f0 50 80 00       	push   $0x8050f0
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
  800f58:	e8 3c 19 00 00       	call   802899 <sys_getenvindex>
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
  800fc6:	e8 52 16 00 00       	call   80261d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 58 51 80 00       	push   $0x805158
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
  800ff6:	68 80 51 80 00       	push   $0x805180
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
  801027:	68 a8 51 80 00       	push   $0x8051a8
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 00 52 80 00       	push   $0x805200
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 58 51 80 00       	push   $0x805158
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 d2 15 00 00       	call   802637 <sys_unlock_cons>
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
  801078:	e8 e8 17 00 00       	call   802865 <sys_destroy_env>
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
  801089:	e8 3d 18 00 00       	call   8028cb <sys_exit_env>
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
  8010b2:	68 14 52 80 00       	push   $0x805214
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 19 52 80 00       	push   $0x805219
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
  8010ef:	68 35 52 80 00       	push   $0x805235
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
  80111e:	68 38 52 80 00       	push   $0x805238
  801123:	6a 26                	push   $0x26
  801125:	68 84 52 80 00       	push   $0x805284
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
  8011f3:	68 90 52 80 00       	push   $0x805290
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 84 52 80 00       	push   $0x805284
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
  801266:	68 e4 52 80 00       	push   $0x8052e4
  80126b:	6a 44                	push   $0x44
  80126d:	68 84 52 80 00       	push   $0x805284
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
  8012c0:	e8 16 13 00 00       	call   8025db <sys_cputs>
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
  801337:	e8 9f 12 00 00       	call   8025db <sys_cputs>
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
  801381:	e8 97 12 00 00       	call   80261d <sys_lock_cons>
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
  8013a1:	e8 91 12 00 00       	call   802637 <sys_unlock_cons>
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
  8013eb:	e8 84 32 00 00       	call   804674 <__udivdi3>
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
  80143b:	e8 44 33 00 00       	call   804784 <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 54 55 80 00       	add    $0x805554,%eax
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
  801596:	8b 04 85 78 55 80 00 	mov    0x805578(,%eax,4),%eax
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
  801677:	8b 34 9d c0 53 80 00 	mov    0x8053c0(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 65 55 80 00       	push   $0x805565
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
  80169c:	68 6e 55 80 00       	push   $0x80556e
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
  8016c9:	be 71 55 80 00       	mov    $0x805571,%esi
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
  8020d4:	68 e8 56 80 00       	push   $0x8056e8
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 0a 57 80 00       	push   $0x80570a
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
  8020f4:	e8 8d 0a 00 00       	call   802b86 <sys_sbrk>
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
  80216f:	e8 96 08 00 00       	call   802a0a <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 d6 0d 00 00       	call   802f59 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 a8 08 00 00       	call   802a3b <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 6f 12 00 00       	call   803415 <alloc_block_BF>
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
  802307:	e8 b1 08 00 00       	call   802bbd <sys_allocate_user_mem>
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
  80234f:	e8 85 08 00 00       	call   802bd9 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 b8 1a 00 00       	call   803e1d <free_block>
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
  8023f7:	e8 a5 07 00 00       	call   802ba1 <sys_free_user_mem>
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
  802405:	68 18 57 80 00       	push   $0x805718
  80240a:	68 84 00 00 00       	push   $0x84
  80240f:	68 42 57 80 00       	push   $0x805742
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
  802432:	eb 64                	jmp    802498 <smalloc+0x7d>
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
  802467:	eb 2f                	jmp    802498 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802469:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80246d:	ff 75 ec             	pushl  -0x14(%ebp)
  802470:	50                   	push   %eax
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	e8 2c 03 00 00       	call   8027a8 <sys_createSharedObject>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802482:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802486:	74 06                	je     80248e <smalloc+0x73>
  802488:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80248c:	75 07                	jne    802495 <smalloc+0x7a>
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	eb 03                	jmp    802498 <smalloc+0x7d>
	 return ptr;
  802495:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8024a0:	83 ec 08             	sub    $0x8,%esp
  8024a3:	ff 75 0c             	pushl  0xc(%ebp)
  8024a6:	ff 75 08             	pushl  0x8(%ebp)
  8024a9:	e8 24 03 00 00       	call   8027d2 <sys_getSizeOfSharedObject>
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8024b4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024b8:	75 07                	jne    8024c1 <sget+0x27>
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	eb 5c                	jmp    80251d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024c7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	39 d0                	cmp    %edx,%eax
  8024d6:	7d 02                	jge    8024da <sget+0x40>
  8024d8:	89 d0                	mov    %edx,%eax
  8024da:	83 ec 0c             	sub    $0xc,%esp
  8024dd:	50                   	push   %eax
  8024de:	e8 1b fc ff ff       	call   8020fe <malloc>
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8024e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024ed:	75 07                	jne    8024f6 <sget+0x5c>
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	eb 27                	jmp    80251d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8024f6:	83 ec 04             	sub    $0x4,%esp
  8024f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8024fc:	ff 75 0c             	pushl  0xc(%ebp)
  8024ff:	ff 75 08             	pushl  0x8(%ebp)
  802502:	e8 e8 02 00 00       	call   8027ef <sys_getSharedObject>
  802507:	83 c4 10             	add    $0x10,%esp
  80250a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80250d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802511:	75 07                	jne    80251a <sget+0x80>
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	eb 03                	jmp    80251d <sget+0x83>
	return ptr;
  80251a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	68 50 57 80 00       	push   $0x805750
  80252d:	68 c1 00 00 00       	push   $0xc1
  802532:	68 42 57 80 00       	push   $0x805742
  802537:	e8 55 eb ff ff       	call   801091 <_panic>

0080253c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 74 57 80 00       	push   $0x805774
  80254a:	68 d8 00 00 00       	push   $0xd8
  80254f:	68 42 57 80 00       	push   $0x805742
  802554:	e8 38 eb ff ff       	call   801091 <_panic>

00802559 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 9a 57 80 00       	push   $0x80579a
  802567:	68 e4 00 00 00       	push   $0xe4
  80256c:	68 42 57 80 00       	push   $0x805742
  802571:	e8 1b eb ff ff       	call   801091 <_panic>

00802576 <shrink>:

}
void shrink(uint32 newSize)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80257c:	83 ec 04             	sub    $0x4,%esp
  80257f:	68 9a 57 80 00       	push   $0x80579a
  802584:	68 e9 00 00 00       	push   $0xe9
  802589:	68 42 57 80 00       	push   $0x805742
  80258e:	e8 fe ea ff ff       	call   801091 <_panic>

00802593 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	68 9a 57 80 00       	push   $0x80579a
  8025a1:	68 ee 00 00 00       	push   $0xee
  8025a6:	68 42 57 80 00       	push   $0x805742
  8025ab:	e8 e1 ea ff ff       	call   801091 <_panic>

008025b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	57                   	push   %edi
  8025b4:	56                   	push   %esi
  8025b5:	53                   	push   %ebx
  8025b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025cb:	cd 30                	int    $0x30
  8025cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8025d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	5b                   	pop    %ebx
  8025d7:	5e                   	pop    %esi
  8025d8:	5f                   	pop    %edi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    

008025db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 04             	sub    $0x4,%esp
  8025e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8025e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	52                   	push   %edx
  8025f3:	ff 75 0c             	pushl  0xc(%ebp)
  8025f6:	50                   	push   %eax
  8025f7:	6a 00                	push   $0x0
  8025f9:	e8 b2 ff ff ff       	call   8025b0 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
}
  802601:	90                   	nop
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <sys_cgetc>:

int
sys_cgetc(void)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 02                	push   $0x2
  802613:	e8 98 ff ff ff       	call   8025b0 <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 03                	push   $0x3
  80262c:	e8 7f ff ff ff       	call   8025b0 <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
}
  802634:	90                   	nop
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 04                	push   $0x4
  802646:	e8 65 ff ff ff       	call   8025b0 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
}
  80264e:	90                   	nop
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802654:	8b 55 0c             	mov    0xc(%ebp),%edx
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	52                   	push   %edx
  802661:	50                   	push   %eax
  802662:	6a 08                	push   $0x8
  802664:	e8 47 ff ff ff       	call   8025b0 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	56                   	push   %esi
  802672:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802673:	8b 75 18             	mov    0x18(%ebp),%esi
  802676:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802679:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80267c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
  802684:	51                   	push   %ecx
  802685:	52                   	push   %edx
  802686:	50                   	push   %eax
  802687:	6a 09                	push   $0x9
  802689:	e8 22 ff ff ff       	call   8025b0 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802694:	5b                   	pop    %ebx
  802695:	5e                   	pop    %esi
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    

00802698 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80269b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	52                   	push   %edx
  8026a8:	50                   	push   %eax
  8026a9:	6a 0a                	push   $0xa
  8026ab:	e8 00 ff ff ff       	call   8025b0 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	ff 75 0c             	pushl  0xc(%ebp)
  8026c1:	ff 75 08             	pushl  0x8(%ebp)
  8026c4:	6a 0b                	push   $0xb
  8026c6:	e8 e5 fe ff ff       	call   8025b0 <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 0c                	push   $0xc
  8026df:	e8 cc fe ff ff       	call   8025b0 <syscall>
  8026e4:	83 c4 18             	add    $0x18,%esp
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 0d                	push   $0xd
  8026f8:	e8 b3 fe ff ff       	call   8025b0 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 0e                	push   $0xe
  802711:	e8 9a fe ff ff       	call   8025b0 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 0f                	push   $0xf
  80272a:	e8 81 fe ff ff       	call   8025b0 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	ff 75 08             	pushl  0x8(%ebp)
  802742:	6a 10                	push   $0x10
  802744:	e8 67 fe ff ff       	call   8025b0 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 11                	push   $0x11
  80275d:	e8 4e fe ff ff       	call   8025b0 <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
}
  802765:	90                   	nop
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_cputc>:

void
sys_cputc(const char c)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802774:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	50                   	push   %eax
  802781:	6a 01                	push   $0x1
  802783:	e8 28 fe ff ff       	call   8025b0 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	90                   	nop
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 14                	push   $0x14
  80279d:	e8 0e fe ff ff       	call   8025b0 <syscall>
  8027a2:	83 c4 18             	add    $0x18,%esp
}
  8027a5:	90                   	nop
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	6a 00                	push   $0x0
  8027c0:	51                   	push   %ecx
  8027c1:	52                   	push   %edx
  8027c2:	ff 75 0c             	pushl  0xc(%ebp)
  8027c5:	50                   	push   %eax
  8027c6:	6a 15                	push   $0x15
  8027c8:	e8 e3 fd ff ff       	call   8025b0 <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	52                   	push   %edx
  8027e2:	50                   	push   %eax
  8027e3:	6a 16                	push   $0x16
  8027e5:	e8 c6 fd ff ff       	call   8025b0 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	51                   	push   %ecx
  802800:	52                   	push   %edx
  802801:	50                   	push   %eax
  802802:	6a 17                	push   $0x17
  802804:	e8 a7 fd ff ff       	call   8025b0 <syscall>
  802809:	83 c4 18             	add    $0x18,%esp
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802811:	8b 55 0c             	mov    0xc(%ebp),%edx
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	52                   	push   %edx
  80281e:	50                   	push   %eax
  80281f:	6a 18                	push   $0x18
  802821:	e8 8a fd ff ff       	call   8025b0 <syscall>
  802826:	83 c4 18             	add    $0x18,%esp
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	6a 00                	push   $0x0
  802833:	ff 75 14             	pushl  0x14(%ebp)
  802836:	ff 75 10             	pushl  0x10(%ebp)
  802839:	ff 75 0c             	pushl  0xc(%ebp)
  80283c:	50                   	push   %eax
  80283d:	6a 19                	push   $0x19
  80283f:	e8 6c fd ff ff       	call   8025b0 <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
}
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	50                   	push   %eax
  802858:	6a 1a                	push   $0x1a
  80285a:	e8 51 fd ff ff       	call   8025b0 <syscall>
  80285f:	83 c4 18             	add    $0x18,%esp
}
  802862:	90                   	nop
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	50                   	push   %eax
  802874:	6a 1b                	push   $0x1b
  802876:	e8 35 fd ff ff       	call   8025b0 <syscall>
  80287b:	83 c4 18             	add    $0x18,%esp
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 05                	push   $0x5
  80288f:	e8 1c fd ff ff       	call   8025b0 <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 06                	push   $0x6
  8028a8:	e8 03 fd ff ff       	call   8025b0 <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

008028b2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 07                	push   $0x7
  8028c1:	e8 ea fc ff ff       	call   8025b0 <syscall>
  8028c6:	83 c4 18             	add    $0x18,%esp
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_exit_env>:


void sys_exit_env(void)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 1c                	push   $0x1c
  8028da:	e8 d1 fc ff ff       	call   8025b0 <syscall>
  8028df:	83 c4 18             	add    $0x18,%esp
}
  8028e2:	90                   	nop
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ee:	8d 50 04             	lea    0x4(%eax),%edx
  8028f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	52                   	push   %edx
  8028fb:	50                   	push   %eax
  8028fc:	6a 1d                	push   $0x1d
  8028fe:	e8 ad fc ff ff       	call   8025b0 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
	return result;
  802906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802909:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80290c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80290f:	89 01                	mov    %eax,(%ecx)
  802911:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	c9                   	leave  
  802918:	c2 04 00             	ret    $0x4

0080291b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	ff 75 10             	pushl  0x10(%ebp)
  802925:	ff 75 0c             	pushl  0xc(%ebp)
  802928:	ff 75 08             	pushl  0x8(%ebp)
  80292b:	6a 13                	push   $0x13
  80292d:	e8 7e fc ff ff       	call   8025b0 <syscall>
  802932:	83 c4 18             	add    $0x18,%esp
	return ;
  802935:	90                   	nop
}
  802936:	c9                   	leave  
  802937:	c3                   	ret    

00802938 <sys_rcr2>:
uint32 sys_rcr2()
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 1e                	push   $0x1e
  802947:	e8 64 fc ff ff       	call   8025b0 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    

00802951 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80295d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	50                   	push   %eax
  80296a:	6a 1f                	push   $0x1f
  80296c:	e8 3f fc ff ff       	call   8025b0 <syscall>
  802971:	83 c4 18             	add    $0x18,%esp
	return ;
  802974:	90                   	nop
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <rsttst>:
void rsttst()
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 21                	push   $0x21
  802986:	e8 25 fc ff ff       	call   8025b0 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
	return ;
  80298e:	90                   	nop
}
  80298f:	c9                   	leave  
  802990:	c3                   	ret    

00802991 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802991:	55                   	push   %ebp
  802992:	89 e5                	mov    %esp,%ebp
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	8b 45 14             	mov    0x14(%ebp),%eax
  80299a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80299d:	8b 55 18             	mov    0x18(%ebp),%edx
  8029a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029a4:	52                   	push   %edx
  8029a5:	50                   	push   %eax
  8029a6:	ff 75 10             	pushl  0x10(%ebp)
  8029a9:	ff 75 0c             	pushl  0xc(%ebp)
  8029ac:	ff 75 08             	pushl  0x8(%ebp)
  8029af:	6a 20                	push   $0x20
  8029b1:	e8 fa fb ff ff       	call   8025b0 <syscall>
  8029b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b9:	90                   	nop
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <chktst>:
void chktst(uint32 n)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	ff 75 08             	pushl  0x8(%ebp)
  8029ca:	6a 22                	push   $0x22
  8029cc:	e8 df fb ff ff       	call   8025b0 <syscall>
  8029d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d4:	90                   	nop
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <inctst>:

void inctst()
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 23                	push   $0x23
  8029e6:	e8 c5 fb ff ff       	call   8025b0 <syscall>
  8029eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ee:	90                   	nop
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <gettst>:
uint32 gettst()
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 24                	push   $0x24
  802a00:	e8 ab fb ff ff       	call   8025b0 <syscall>
  802a05:	83 c4 18             	add    $0x18,%esp
}
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 25                	push   $0x25
  802a1c:	e8 8f fb ff ff       	call   8025b0 <syscall>
  802a21:	83 c4 18             	add    $0x18,%esp
  802a24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a27:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a2b:	75 07                	jne    802a34 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a32:	eb 05                	jmp    802a39 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a39:	c9                   	leave  
  802a3a:	c3                   	ret    

00802a3b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
  802a3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 25                	push   $0x25
  802a4d:	e8 5e fb ff ff       	call   8025b0 <syscall>
  802a52:	83 c4 18             	add    $0x18,%esp
  802a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a58:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a5c:	75 07                	jne    802a65 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	eb 05                	jmp    802a6a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 25                	push   $0x25
  802a7e:	e8 2d fb ff ff       	call   8025b0 <syscall>
  802a83:	83 c4 18             	add    $0x18,%esp
  802a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a89:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a8d:	75 07                	jne    802a96 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a8f:	b8 01 00 00 00       	mov    $0x1,%eax
  802a94:	eb 05                	jmp    802a9b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
  802aa0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 25                	push   $0x25
  802aaf:	e8 fc fa ff ff       	call   8025b0 <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
  802ab7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802aba:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802abe:	75 07                	jne    802ac7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ac0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac5:	eb 05                	jmp    802acc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acc:	c9                   	leave  
  802acd:	c3                   	ret    

00802ace <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ace:	55                   	push   %ebp
  802acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	ff 75 08             	pushl  0x8(%ebp)
  802adc:	6a 26                	push   $0x26
  802ade:	e8 cd fa ff ff       	call   8025b0 <syscall>
  802ae3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae6:	90                   	nop
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
  802aec:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	6a 00                	push   $0x0
  802afb:	53                   	push   %ebx
  802afc:	51                   	push   %ecx
  802afd:	52                   	push   %edx
  802afe:	50                   	push   %eax
  802aff:	6a 27                	push   $0x27
  802b01:	e8 aa fa ff ff       	call   8025b0 <syscall>
  802b06:	83 c4 18             	add    $0x18,%esp
}
  802b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0c:	c9                   	leave  
  802b0d:	c3                   	ret    

00802b0e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0e:	55                   	push   %ebp
  802b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	52                   	push   %edx
  802b1e:	50                   	push   %eax
  802b1f:	6a 28                	push   $0x28
  802b21:	e8 8a fa ff ff       	call   8025b0 <syscall>
  802b26:	83 c4 18             	add    $0x18,%esp
}
  802b29:	c9                   	leave  
  802b2a:	c3                   	ret    

00802b2b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b2b:	55                   	push   %ebp
  802b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	6a 00                	push   $0x0
  802b39:	51                   	push   %ecx
  802b3a:	ff 75 10             	pushl  0x10(%ebp)
  802b3d:	52                   	push   %edx
  802b3e:	50                   	push   %eax
  802b3f:	6a 29                	push   $0x29
  802b41:	e8 6a fa ff ff       	call   8025b0 <syscall>
  802b46:	83 c4 18             	add    $0x18,%esp
}
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

00802b4b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	ff 75 10             	pushl  0x10(%ebp)
  802b55:	ff 75 0c             	pushl  0xc(%ebp)
  802b58:	ff 75 08             	pushl  0x8(%ebp)
  802b5b:	6a 12                	push   $0x12
  802b5d:	e8 4e fa ff ff       	call   8025b0 <syscall>
  802b62:	83 c4 18             	add    $0x18,%esp
	return ;
  802b65:	90                   	nop
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	52                   	push   %edx
  802b78:	50                   	push   %eax
  802b79:	6a 2a                	push   $0x2a
  802b7b:	e8 30 fa ff ff       	call   8025b0 <syscall>
  802b80:	83 c4 18             	add    $0x18,%esp
	return;
  802b83:	90                   	nop
}
  802b84:	c9                   	leave  
  802b85:	c3                   	ret    

00802b86 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802b86:	55                   	push   %ebp
  802b87:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	50                   	push   %eax
  802b95:	6a 2b                	push   $0x2b
  802b97:	e8 14 fa ff ff       	call   8025b0 <syscall>
  802b9c:	83 c4 18             	add    $0x18,%esp
}
  802b9f:	c9                   	leave  
  802ba0:	c3                   	ret    

00802ba1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ba1:	55                   	push   %ebp
  802ba2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	ff 75 0c             	pushl  0xc(%ebp)
  802bad:	ff 75 08             	pushl  0x8(%ebp)
  802bb0:	6a 2c                	push   $0x2c
  802bb2:	e8 f9 f9 ff ff       	call   8025b0 <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
	return;
  802bba:	90                   	nop
}
  802bbb:	c9                   	leave  
  802bbc:	c3                   	ret    

00802bbd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bbd:	55                   	push   %ebp
  802bbe:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	ff 75 0c             	pushl  0xc(%ebp)
  802bc9:	ff 75 08             	pushl  0x8(%ebp)
  802bcc:	6a 2d                	push   $0x2d
  802bce:	e8 dd f9 ff ff       	call   8025b0 <syscall>
  802bd3:	83 c4 18             	add    $0x18,%esp
	return;
  802bd6:	90                   	nop
}
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
  802bdc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	83 e8 04             	sub    $0x4,%eax
  802be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802bf0:	c9                   	leave  
  802bf1:	c3                   	ret    

00802bf2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
  802bf5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	83 e8 04             	sub    $0x4,%eax
  802bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	83 e0 01             	and    $0x1,%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	0f 94 c0             	sete   %al
}
  802c0e:	c9                   	leave  
  802c0f:	c3                   	ret    

00802c10 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c10:	55                   	push   %ebp
  802c11:	89 e5                	mov    %esp,%ebp
  802c13:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c20:	83 f8 02             	cmp    $0x2,%eax
  802c23:	74 2b                	je     802c50 <alloc_block+0x40>
  802c25:	83 f8 02             	cmp    $0x2,%eax
  802c28:	7f 07                	jg     802c31 <alloc_block+0x21>
  802c2a:	83 f8 01             	cmp    $0x1,%eax
  802c2d:	74 0e                	je     802c3d <alloc_block+0x2d>
  802c2f:	eb 58                	jmp    802c89 <alloc_block+0x79>
  802c31:	83 f8 03             	cmp    $0x3,%eax
  802c34:	74 2d                	je     802c63 <alloc_block+0x53>
  802c36:	83 f8 04             	cmp    $0x4,%eax
  802c39:	74 3b                	je     802c76 <alloc_block+0x66>
  802c3b:	eb 4c                	jmp    802c89 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	ff 75 08             	pushl  0x8(%ebp)
  802c43:	e8 11 03 00 00       	call   802f59 <alloc_block_FF>
  802c48:	83 c4 10             	add    $0x10,%esp
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c4e:	eb 4a                	jmp    802c9a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802c50:	83 ec 0c             	sub    $0xc,%esp
  802c53:	ff 75 08             	pushl  0x8(%ebp)
  802c56:	e8 fa 19 00 00       	call   804655 <alloc_block_NF>
  802c5b:	83 c4 10             	add    $0x10,%esp
  802c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c61:	eb 37                	jmp    802c9a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802c63:	83 ec 0c             	sub    $0xc,%esp
  802c66:	ff 75 08             	pushl  0x8(%ebp)
  802c69:	e8 a7 07 00 00       	call   803415 <alloc_block_BF>
  802c6e:	83 c4 10             	add    $0x10,%esp
  802c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c74:	eb 24                	jmp    802c9a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	ff 75 08             	pushl  0x8(%ebp)
  802c7c:	e8 b7 19 00 00       	call   804638 <alloc_block_WF>
  802c81:	83 c4 10             	add    $0x10,%esp
  802c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c87:	eb 11                	jmp    802c9a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802c89:	83 ec 0c             	sub    $0xc,%esp
  802c8c:	68 ac 57 80 00       	push   $0x8057ac
  802c91:	e8 b8 e6 ff ff       	call   80134e <cprintf>
  802c96:	83 c4 10             	add    $0x10,%esp
		break;
  802c99:	90                   	nop
	}
	return va;
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802c9d:	c9                   	leave  
  802c9e:	c3                   	ret    

00802c9f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
  802ca2:	53                   	push   %ebx
  802ca3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ca6:	83 ec 0c             	sub    $0xc,%esp
  802ca9:	68 cc 57 80 00       	push   $0x8057cc
  802cae:	e8 9b e6 ff ff       	call   80134e <cprintf>
  802cb3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802cb6:	83 ec 0c             	sub    $0xc,%esp
  802cb9:	68 f7 57 80 00       	push   $0x8057f7
  802cbe:	e8 8b e6 ff ff       	call   80134e <cprintf>
  802cc3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccc:	eb 37                	jmp    802d05 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802cce:	83 ec 0c             	sub    $0xc,%esp
  802cd1:	ff 75 f4             	pushl  -0xc(%ebp)
  802cd4:	e8 19 ff ff ff       	call   802bf2 <is_free_block>
  802cd9:	83 c4 10             	add    $0x10,%esp
  802cdc:	0f be d8             	movsbl %al,%ebx
  802cdf:	83 ec 0c             	sub    $0xc,%esp
  802ce2:	ff 75 f4             	pushl  -0xc(%ebp)
  802ce5:	e8 ef fe ff ff       	call   802bd9 <get_block_size>
  802cea:	83 c4 10             	add    $0x10,%esp
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	53                   	push   %ebx
  802cf1:	50                   	push   %eax
  802cf2:	68 0f 58 80 00       	push   $0x80580f
  802cf7:	e8 52 e6 ff ff       	call   80134e <cprintf>
  802cfc:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802cff:	8b 45 10             	mov    0x10(%ebp),%eax
  802d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d09:	74 07                	je     802d12 <print_blocks_list+0x73>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	eb 05                	jmp    802d17 <print_blocks_list+0x78>
  802d12:	b8 00 00 00 00       	mov    $0x0,%eax
  802d17:	89 45 10             	mov    %eax,0x10(%ebp)
  802d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	75 ad                	jne    802cce <print_blocks_list+0x2f>
  802d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d25:	75 a7                	jne    802cce <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802d27:	83 ec 0c             	sub    $0xc,%esp
  802d2a:	68 cc 57 80 00       	push   $0x8057cc
  802d2f:	e8 1a e6 ff ff       	call   80134e <cprintf>
  802d34:	83 c4 10             	add    $0x10,%esp

}
  802d37:	90                   	nop
  802d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d3b:	c9                   	leave  
  802d3c:	c3                   	ret    

00802d3d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802d3d:	55                   	push   %ebp
  802d3e:	89 e5                	mov    %esp,%ebp
  802d40:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d46:	83 e0 01             	and    $0x1,%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 03                	je     802d50 <initialize_dynamic_allocator+0x13>
  802d4d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d54:	0f 84 c7 01 00 00    	je     802f21 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802d5a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802d61:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802d64:	8b 55 08             	mov    0x8(%ebp),%edx
  802d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6a:	01 d0                	add    %edx,%eax
  802d6c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802d71:	0f 87 ad 01 00 00    	ja     802f24 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	0f 89 a5 01 00 00    	jns    802f27 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802d82:	8b 55 08             	mov    0x8(%ebp),%edx
  802d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d88:	01 d0                	add    %edx,%eax
  802d8a:	83 e8 04             	sub    $0x4,%eax
  802d8d:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802d99:	a1 44 60 80 00       	mov    0x806044,%eax
  802d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da1:	e9 87 00 00 00       	jmp    802e2d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daa:	75 14                	jne    802dc0 <initialize_dynamic_allocator+0x83>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 27 58 80 00       	push   $0x805827
  802db4:	6a 79                	push   $0x79
  802db6:	68 45 58 80 00       	push   $0x805845
  802dbb:	e8 d1 e2 ff ff       	call   801091 <_panic>
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 10                	je     802dd9 <initialize_dynamic_allocator+0x9c>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	8b 52 04             	mov    0x4(%edx),%edx
  802dd4:	89 50 04             	mov    %edx,0x4(%eax)
  802dd7:	eb 0b                	jmp    802de4 <initialize_dynamic_allocator+0xa7>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	a3 48 60 80 00       	mov    %eax,0x806048
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 0f                	je     802dfd <initialize_dynamic_allocator+0xc0>
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df7:	8b 12                	mov    (%edx),%edx
  802df9:	89 10                	mov    %edx,(%eax)
  802dfb:	eb 0a                	jmp    802e07 <initialize_dynamic_allocator+0xca>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	a3 44 60 80 00       	mov    %eax,0x806044
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1a:	a1 50 60 80 00       	mov    0x806050,%eax
  802e1f:	48                   	dec    %eax
  802e20:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802e25:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e31:	74 07                	je     802e3a <initialize_dynamic_allocator+0xfd>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	eb 05                	jmp    802e3f <initialize_dynamic_allocator+0x102>
  802e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802e44:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	0f 85 55 ff ff ff    	jne    802da6 <initialize_dynamic_allocator+0x69>
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	0f 85 4b ff ff ff    	jne    802da6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802e6a:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802e6f:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802e74:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802e79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	83 c0 08             	add    $0x8,%eax
  802e85:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	83 c0 04             	add    $0x4,%eax
  802e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e91:	83 ea 08             	sub    $0x8,%edx
  802e94:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	01 d0                	add    %edx,%eax
  802e9e:	83 e8 08             	sub    $0x8,%eax
  802ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea4:	83 ea 08             	sub    $0x8,%edx
  802ea7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802ebc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ec0:	75 17                	jne    802ed9 <initialize_dynamic_allocator+0x19c>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 60 58 80 00       	push   $0x805860
  802eca:	68 90 00 00 00       	push   $0x90
  802ecf:	68 45 58 80 00       	push   $0x805845
  802ed4:	e8 b8 e1 ff ff       	call   801091 <_panic>
  802ed9:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	89 10                	mov    %edx,(%eax)
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 0d                	je     802efa <initialize_dynamic_allocator+0x1bd>
  802eed:	a1 44 60 80 00       	mov    0x806044,%eax
  802ef2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 08                	jmp    802f02 <initialize_dynamic_allocator+0x1c5>
  802efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efd:	a3 48 60 80 00       	mov    %eax,0x806048
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	a3 44 60 80 00       	mov    %eax,0x806044
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f14:	a1 50 60 80 00       	mov    0x806050,%eax
  802f19:	40                   	inc    %eax
  802f1a:	a3 50 60 80 00       	mov    %eax,0x806050
  802f1f:	eb 07                	jmp    802f28 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f21:	90                   	nop
  802f22:	eb 04                	jmp    802f28 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802f24:	90                   	nop
  802f25:	eb 01                	jmp    802f28 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802f27:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802f28:	c9                   	leave  
  802f29:	c3                   	ret    

00802f2a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f30:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	83 e8 04             	sub    $0x4,%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	83 e0 fe             	and    $0xfffffffe,%eax
  802f49:	8d 50 f8             	lea    -0x8(%eax),%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	01 c2                	add    %eax,%edx
  802f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f54:	89 02                	mov    %eax,(%edx)
}
  802f56:	90                   	nop
  802f57:	5d                   	pop    %ebp
  802f58:	c3                   	ret    

00802f59 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802f59:	55                   	push   %ebp
  802f5a:	89 e5                	mov    %esp,%ebp
  802f5c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	83 e0 01             	and    $0x1,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 03                	je     802f6c <alloc_block_FF+0x13>
  802f69:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f6c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f70:	77 07                	ja     802f79 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f72:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f79:	a1 24 60 80 00       	mov    0x806024,%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	75 73                	jne    802ff5 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	83 c0 10             	add    $0x10,%eax
  802f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f8b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802f92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	01 d0                	add    %edx,%eax
  802f9a:	48                   	dec    %eax
  802f9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa1:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa6:	f7 75 ec             	divl   -0x14(%ebp)
  802fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fac:	29 d0                	sub    %edx,%eax
  802fae:	c1 e8 0c             	shr    $0xc,%eax
  802fb1:	83 ec 0c             	sub    $0xc,%esp
  802fb4:	50                   	push   %eax
  802fb5:	e8 2e f1 ff ff       	call   8020e8 <sbrk>
  802fba:	83 c4 10             	add    $0x10,%esp
  802fbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fc0:	83 ec 0c             	sub    $0xc,%esp
  802fc3:	6a 00                	push   $0x0
  802fc5:	e8 1e f1 ff ff       	call   8020e8 <sbrk>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802fd6:	83 ec 08             	sub    $0x8,%esp
  802fd9:	50                   	push   %eax
  802fda:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fdd:	e8 5b fd ff ff       	call   802d3d <initialize_dynamic_allocator>
  802fe2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fe5:	83 ec 0c             	sub    $0xc,%esp
  802fe8:	68 83 58 80 00       	push   $0x805883
  802fed:	e8 5c e3 ff ff       	call   80134e <cprintf>
  802ff2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ff5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff9:	75 0a                	jne    803005 <alloc_block_FF+0xac>
	        return NULL;
  802ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  803000:	e9 0e 04 00 00       	jmp    803413 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803005:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80300c:	a1 44 60 80 00       	mov    0x806044,%eax
  803011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803014:	e9 f3 02 00 00       	jmp    80330c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80301f:	83 ec 0c             	sub    $0xc,%esp
  803022:	ff 75 bc             	pushl  -0x44(%ebp)
  803025:	e8 af fb ff ff       	call   802bd9 <get_block_size>
  80302a:	83 c4 10             	add    $0x10,%esp
  80302d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	83 c0 08             	add    $0x8,%eax
  803036:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803039:	0f 87 c5 02 00 00    	ja     803304 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	83 c0 18             	add    $0x18,%eax
  803045:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803048:	0f 87 19 02 00 00    	ja     803267 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80304e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803051:	2b 45 08             	sub    0x8(%ebp),%eax
  803054:	83 e8 08             	sub    $0x8,%eax
  803057:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8d 50 08             	lea    0x8(%eax),%edx
  803060:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803063:	01 d0                	add    %edx,%eax
  803065:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	83 c0 08             	add    $0x8,%eax
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	6a 01                	push   $0x1
  803073:	50                   	push   %eax
  803074:	ff 75 bc             	pushl  -0x44(%ebp)
  803077:	e8 ae fe ff ff       	call   802f2a <set_block_data>
  80307c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 40 04             	mov    0x4(%eax),%eax
  803085:	85 c0                	test   %eax,%eax
  803087:	75 68                	jne    8030f1 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803089:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80308d:	75 17                	jne    8030a6 <alloc_block_FF+0x14d>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 60 58 80 00       	push   $0x805860
  803097:	68 d7 00 00 00       	push   $0xd7
  80309c:	68 45 58 80 00       	push   $0x805845
  8030a1:	e8 eb df ff ff       	call   801091 <_panic>
  8030a6:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8030ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <alloc_block_FF+0x16e>
  8030ba:	a1 44 60 80 00       	mov    0x806044,%eax
  8030bf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <alloc_block_FF+0x176>
  8030c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030ca:	a3 48 60 80 00       	mov    %eax,0x806048
  8030cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030d2:	a3 44 60 80 00       	mov    %eax,0x806044
  8030d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 50 60 80 00       	mov    0x806050,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 50 60 80 00       	mov    %eax,0x806050
  8030ec:	e9 dc 00 00 00       	jmp    8031cd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	75 65                	jne    80315f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030fa:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030fe:	75 17                	jne    803117 <alloc_block_FF+0x1be>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 94 58 80 00       	push   $0x805894
  803108:	68 db 00 00 00       	push   $0xdb
  80310d:	68 45 58 80 00       	push   $0x805845
  803112:	e8 7a df ff ff       	call   801091 <_panic>
  803117:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80311d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 0c                	je     803139 <alloc_block_FF+0x1e0>
  80312d:	a1 48 60 80 00       	mov    0x806048,%eax
  803132:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	eb 08                	jmp    803141 <alloc_block_FF+0x1e8>
  803139:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80313c:	a3 44 60 80 00       	mov    %eax,0x806044
  803141:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803144:	a3 48 60 80 00       	mov    %eax,0x806048
  803149:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803152:	a1 50 60 80 00       	mov    0x806050,%eax
  803157:	40                   	inc    %eax
  803158:	a3 50 60 80 00       	mov    %eax,0x806050
  80315d:	eb 6e                	jmp    8031cd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80315f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803163:	74 06                	je     80316b <alloc_block_FF+0x212>
  803165:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803169:	75 17                	jne    803182 <alloc_block_FF+0x229>
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	68 b8 58 80 00       	push   $0x8058b8
  803173:	68 df 00 00 00       	push   $0xdf
  803178:	68 45 58 80 00       	push   $0x805845
  80317d:	e8 0f df ff ff       	call   801091 <_panic>
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	8b 10                	mov    (%eax),%edx
  803187:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80318a:	89 10                	mov    %edx,(%eax)
  80318c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0b                	je     8031a0 <alloc_block_FF+0x247>
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ae:	89 50 04             	mov    %edx,0x4(%eax)
  8031b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	75 08                	jne    8031c2 <alloc_block_FF+0x269>
  8031ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031bd:	a3 48 60 80 00       	mov    %eax,0x806048
  8031c2:	a1 50 60 80 00       	mov    0x806050,%eax
  8031c7:	40                   	inc    %eax
  8031c8:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8031cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d1:	75 17                	jne    8031ea <alloc_block_FF+0x291>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 27 58 80 00       	push   $0x805827
  8031db:	68 e1 00 00 00       	push   $0xe1
  8031e0:	68 45 58 80 00       	push   $0x805845
  8031e5:	e8 a7 de ff ff       	call   801091 <_panic>
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 10                	je     803203 <alloc_block_FF+0x2aa>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fb:	8b 52 04             	mov    0x4(%edx),%edx
  8031fe:	89 50 04             	mov    %edx,0x4(%eax)
  803201:	eb 0b                	jmp    80320e <alloc_block_FF+0x2b5>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	a3 48 60 80 00       	mov    %eax,0x806048
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 40 04             	mov    0x4(%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 0f                	je     803227 <alloc_block_FF+0x2ce>
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 40 04             	mov    0x4(%eax),%eax
  80321e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803221:	8b 12                	mov    (%edx),%edx
  803223:	89 10                	mov    %edx,(%eax)
  803225:	eb 0a                	jmp    803231 <alloc_block_FF+0x2d8>
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 00                	mov    (%eax),%eax
  80322c:	a3 44 60 80 00       	mov    %eax,0x806044
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803244:	a1 50 60 80 00       	mov    0x806050,%eax
  803249:	48                   	dec    %eax
  80324a:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	6a 00                	push   $0x0
  803254:	ff 75 b4             	pushl  -0x4c(%ebp)
  803257:	ff 75 b0             	pushl  -0x50(%ebp)
  80325a:	e8 cb fc ff ff       	call   802f2a <set_block_data>
  80325f:	83 c4 10             	add    $0x10,%esp
  803262:	e9 95 00 00 00       	jmp    8032fc <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803267:	83 ec 04             	sub    $0x4,%esp
  80326a:	6a 01                	push   $0x1
  80326c:	ff 75 b8             	pushl  -0x48(%ebp)
  80326f:	ff 75 bc             	pushl  -0x44(%ebp)
  803272:	e8 b3 fc ff ff       	call   802f2a <set_block_data>
  803277:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80327a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327e:	75 17                	jne    803297 <alloc_block_FF+0x33e>
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	68 27 58 80 00       	push   $0x805827
  803288:	68 e8 00 00 00       	push   $0xe8
  80328d:	68 45 58 80 00       	push   $0x805845
  803292:	e8 fa dd ff ff       	call   801091 <_panic>
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	85 c0                	test   %eax,%eax
  80329e:	74 10                	je     8032b0 <alloc_block_FF+0x357>
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a8:	8b 52 04             	mov    0x4(%edx),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	eb 0b                	jmp    8032bb <alloc_block_FF+0x362>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	a3 48 60 80 00       	mov    %eax,0x806048
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 0f                	je     8032d4 <alloc_block_FF+0x37b>
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 40 04             	mov    0x4(%eax),%eax
  8032cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ce:	8b 12                	mov    (%edx),%edx
  8032d0:	89 10                	mov    %edx,(%eax)
  8032d2:	eb 0a                	jmp    8032de <alloc_block_FF+0x385>
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	a3 44 60 80 00       	mov    %eax,0x806044
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f1:	a1 50 60 80 00       	mov    0x806050,%eax
  8032f6:	48                   	dec    %eax
  8032f7:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  8032fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032ff:	e9 0f 01 00 00       	jmp    803413 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803304:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803310:	74 07                	je     803319 <alloc_block_FF+0x3c0>
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	eb 05                	jmp    80331e <alloc_block_FF+0x3c5>
  803319:	b8 00 00 00 00       	mov    $0x0,%eax
  80331e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803323:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	0f 85 e9 fc ff ff    	jne    803019 <alloc_block_FF+0xc0>
  803330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803334:	0f 85 df fc ff ff    	jne    803019 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	83 c0 08             	add    $0x8,%eax
  803340:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803343:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80334a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80334d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803350:	01 d0                	add    %edx,%eax
  803352:	48                   	dec    %eax
  803353:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803359:	ba 00 00 00 00       	mov    $0x0,%edx
  80335e:	f7 75 d8             	divl   -0x28(%ebp)
  803361:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803364:	29 d0                	sub    %edx,%eax
  803366:	c1 e8 0c             	shr    $0xc,%eax
  803369:	83 ec 0c             	sub    $0xc,%esp
  80336c:	50                   	push   %eax
  80336d:	e8 76 ed ff ff       	call   8020e8 <sbrk>
  803372:	83 c4 10             	add    $0x10,%esp
  803375:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803378:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80337c:	75 0a                	jne    803388 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	e9 8b 00 00 00       	jmp    803413 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803388:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80338f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803392:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803395:	01 d0                	add    %edx,%eax
  803397:	48                   	dec    %eax
  803398:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80339b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80339e:	ba 00 00 00 00       	mov    $0x0,%edx
  8033a3:	f7 75 cc             	divl   -0x34(%ebp)
  8033a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a9:	29 d0                	sub    %edx,%eax
  8033ab:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033b1:	01 d0                	add    %edx,%eax
  8033b3:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  8033b8:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8033bd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033c3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033d0:	01 d0                	add    %edx,%eax
  8033d2:	48                   	dec    %eax
  8033d3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8033de:	f7 75 c4             	divl   -0x3c(%ebp)
  8033e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033e4:	29 d0                	sub    %edx,%eax
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	6a 01                	push   $0x1
  8033eb:	50                   	push   %eax
  8033ec:	ff 75 d0             	pushl  -0x30(%ebp)
  8033ef:	e8 36 fb ff ff       	call   802f2a <set_block_data>
  8033f4:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8033f7:	83 ec 0c             	sub    $0xc,%esp
  8033fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8033fd:	e8 1b 0a 00 00       	call   803e1d <free_block>
  803402:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803405:	83 ec 0c             	sub    $0xc,%esp
  803408:	ff 75 08             	pushl  0x8(%ebp)
  80340b:	e8 49 fb ff ff       	call   802f59 <alloc_block_FF>
  803410:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803413:	c9                   	leave  
  803414:	c3                   	ret    

00803415 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803415:	55                   	push   %ebp
  803416:	89 e5                	mov    %esp,%ebp
  803418:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	83 e0 01             	and    $0x1,%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 03                	je     803428 <alloc_block_BF+0x13>
  803425:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803428:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80342c:	77 07                	ja     803435 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80342e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803435:	a1 24 60 80 00       	mov    0x806024,%eax
  80343a:	85 c0                	test   %eax,%eax
  80343c:	75 73                	jne    8034b1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	83 c0 10             	add    $0x10,%eax
  803444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803447:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80344e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803451:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803454:	01 d0                	add    %edx,%eax
  803456:	48                   	dec    %eax
  803457:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80345a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345d:	ba 00 00 00 00       	mov    $0x0,%edx
  803462:	f7 75 e0             	divl   -0x20(%ebp)
  803465:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803468:	29 d0                	sub    %edx,%eax
  80346a:	c1 e8 0c             	shr    $0xc,%eax
  80346d:	83 ec 0c             	sub    $0xc,%esp
  803470:	50                   	push   %eax
  803471:	e8 72 ec ff ff       	call   8020e8 <sbrk>
  803476:	83 c4 10             	add    $0x10,%esp
  803479:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	6a 00                	push   $0x0
  803481:	e8 62 ec ff ff       	call   8020e8 <sbrk>
  803486:	83 c4 10             	add    $0x10,%esp
  803489:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80348c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803492:	83 ec 08             	sub    $0x8,%esp
  803495:	50                   	push   %eax
  803496:	ff 75 d8             	pushl  -0x28(%ebp)
  803499:	e8 9f f8 ff ff       	call   802d3d <initialize_dynamic_allocator>
  80349e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8034a1:	83 ec 0c             	sub    $0xc,%esp
  8034a4:	68 83 58 80 00       	push   $0x805883
  8034a9:	e8 a0 de ff ff       	call   80134e <cprintf>
  8034ae:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8034b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8034b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8034bf:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8034c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8034cd:	a1 44 60 80 00       	mov    0x806044,%eax
  8034d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d5:	e9 1d 01 00 00       	jmp    8035f7 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dd:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8034e0:	83 ec 0c             	sub    $0xc,%esp
  8034e3:	ff 75 a8             	pushl  -0x58(%ebp)
  8034e6:	e8 ee f6 ff ff       	call   802bd9 <get_block_size>
  8034eb:	83 c4 10             	add    $0x10,%esp
  8034ee:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	83 c0 08             	add    $0x8,%eax
  8034f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034fa:	0f 87 ef 00 00 00    	ja     8035ef <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	83 c0 18             	add    $0x18,%eax
  803506:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803509:	77 1d                	ja     803528 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80350b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803511:	0f 86 d8 00 00 00    	jbe    8035ef <alloc_block_BF+0x1da>
				{
					best_va = va;
  803517:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80351d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803520:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803523:	e9 c7 00 00 00       	jmp    8035ef <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	83 c0 08             	add    $0x8,%eax
  80352e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803531:	0f 85 9d 00 00 00    	jne    8035d4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	6a 01                	push   $0x1
  80353c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80353f:	ff 75 a8             	pushl  -0x58(%ebp)
  803542:	e8 e3 f9 ff ff       	call   802f2a <set_block_data>
  803547:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80354a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354e:	75 17                	jne    803567 <alloc_block_BF+0x152>
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	68 27 58 80 00       	push   $0x805827
  803558:	68 2c 01 00 00       	push   $0x12c
  80355d:	68 45 58 80 00       	push   $0x805845
  803562:	e8 2a db ff ff       	call   801091 <_panic>
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	85 c0                	test   %eax,%eax
  80356e:	74 10                	je     803580 <alloc_block_BF+0x16b>
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 00                	mov    (%eax),%eax
  803575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803578:	8b 52 04             	mov    0x4(%edx),%edx
  80357b:	89 50 04             	mov    %edx,0x4(%eax)
  80357e:	eb 0b                	jmp    80358b <alloc_block_BF+0x176>
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	a3 48 60 80 00       	mov    %eax,0x806048
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	85 c0                	test   %eax,%eax
  803593:	74 0f                	je     8035a4 <alloc_block_BF+0x18f>
  803595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803598:	8b 40 04             	mov    0x4(%eax),%eax
  80359b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80359e:	8b 12                	mov    (%edx),%edx
  8035a0:	89 10                	mov    %edx,(%eax)
  8035a2:	eb 0a                	jmp    8035ae <alloc_block_BF+0x199>
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	a3 44 60 80 00       	mov    %eax,0x806044
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c1:	a1 50 60 80 00       	mov    0x806050,%eax
  8035c6:	48                   	dec    %eax
  8035c7:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  8035cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8035cf:	e9 24 04 00 00       	jmp    8039f8 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8035d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8035da:	76 13                	jbe    8035ef <alloc_block_BF+0x1da>
					{
						internal = 1;
  8035dc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8035e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8035e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8035e9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8035ec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8035ef:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8035f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035fb:	74 07                	je     803604 <alloc_block_BF+0x1ef>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	eb 05                	jmp    803609 <alloc_block_BF+0x1f4>
  803604:	b8 00 00 00 00       	mov    $0x0,%eax
  803609:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80360e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	0f 85 bf fe ff ff    	jne    8034da <alloc_block_BF+0xc5>
  80361b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361f:	0f 85 b5 fe ff ff    	jne    8034da <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803629:	0f 84 26 02 00 00    	je     803855 <alloc_block_BF+0x440>
  80362f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803633:	0f 85 1c 02 00 00    	jne    803855 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363c:	2b 45 08             	sub    0x8(%ebp),%eax
  80363f:	83 e8 08             	sub    $0x8,%eax
  803642:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8d 50 08             	lea    0x8(%eax),%edx
  80364b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364e:	01 d0                	add    %edx,%eax
  803650:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	83 c0 08             	add    $0x8,%eax
  803659:	83 ec 04             	sub    $0x4,%esp
  80365c:	6a 01                	push   $0x1
  80365e:	50                   	push   %eax
  80365f:	ff 75 f0             	pushl  -0x10(%ebp)
  803662:	e8 c3 f8 ff ff       	call   802f2a <set_block_data>
  803667:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80366a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	75 68                	jne    8036dc <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803674:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803678:	75 17                	jne    803691 <alloc_block_BF+0x27c>
  80367a:	83 ec 04             	sub    $0x4,%esp
  80367d:	68 60 58 80 00       	push   $0x805860
  803682:	68 45 01 00 00       	push   $0x145
  803687:	68 45 58 80 00       	push   $0x805845
  80368c:	e8 00 da ff ff       	call   801091 <_panic>
  803691:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803697:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80369a:	89 10                	mov    %edx,(%eax)
  80369c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80369f:	8b 00                	mov    (%eax),%eax
  8036a1:	85 c0                	test   %eax,%eax
  8036a3:	74 0d                	je     8036b2 <alloc_block_BF+0x29d>
  8036a5:	a1 44 60 80 00       	mov    0x806044,%eax
  8036aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036ad:	89 50 04             	mov    %edx,0x4(%eax)
  8036b0:	eb 08                	jmp    8036ba <alloc_block_BF+0x2a5>
  8036b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036b5:	a3 48 60 80 00       	mov    %eax,0x806048
  8036ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036bd:	a3 44 60 80 00       	mov    %eax,0x806044
  8036c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cc:	a1 50 60 80 00       	mov    0x806050,%eax
  8036d1:	40                   	inc    %eax
  8036d2:	a3 50 60 80 00       	mov    %eax,0x806050
  8036d7:	e9 dc 00 00 00       	jmp    8037b8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	75 65                	jne    80374a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036e9:	75 17                	jne    803702 <alloc_block_BF+0x2ed>
  8036eb:	83 ec 04             	sub    $0x4,%esp
  8036ee:	68 94 58 80 00       	push   $0x805894
  8036f3:	68 4a 01 00 00       	push   $0x14a
  8036f8:	68 45 58 80 00       	push   $0x805845
  8036fd:	e8 8f d9 ff ff       	call   801091 <_panic>
  803702:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803708:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80370b:	89 50 04             	mov    %edx,0x4(%eax)
  80370e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	74 0c                	je     803724 <alloc_block_BF+0x30f>
  803718:	a1 48 60 80 00       	mov    0x806048,%eax
  80371d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803720:	89 10                	mov    %edx,(%eax)
  803722:	eb 08                	jmp    80372c <alloc_block_BF+0x317>
  803724:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803727:	a3 44 60 80 00       	mov    %eax,0x806044
  80372c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80372f:	a3 48 60 80 00       	mov    %eax,0x806048
  803734:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373d:	a1 50 60 80 00       	mov    0x806050,%eax
  803742:	40                   	inc    %eax
  803743:	a3 50 60 80 00       	mov    %eax,0x806050
  803748:	eb 6e                	jmp    8037b8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80374a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80374e:	74 06                	je     803756 <alloc_block_BF+0x341>
  803750:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803754:	75 17                	jne    80376d <alloc_block_BF+0x358>
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	68 b8 58 80 00       	push   $0x8058b8
  80375e:	68 4f 01 00 00       	push   $0x14f
  803763:	68 45 58 80 00       	push   $0x805845
  803768:	e8 24 d9 ff ff       	call   801091 <_panic>
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	8b 10                	mov    (%eax),%edx
  803772:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803775:	89 10                	mov    %edx,(%eax)
  803777:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	85 c0                	test   %eax,%eax
  80377e:	74 0b                	je     80378b <alloc_block_BF+0x376>
  803780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803788:	89 50 04             	mov    %edx,0x4(%eax)
  80378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803791:	89 10                	mov    %edx,(%eax)
  803793:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	75 08                	jne    8037ad <alloc_block_BF+0x398>
  8037a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a8:	a3 48 60 80 00       	mov    %eax,0x806048
  8037ad:	a1 50 60 80 00       	mov    0x806050,%eax
  8037b2:	40                   	inc    %eax
  8037b3:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8037b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037bc:	75 17                	jne    8037d5 <alloc_block_BF+0x3c0>
  8037be:	83 ec 04             	sub    $0x4,%esp
  8037c1:	68 27 58 80 00       	push   $0x805827
  8037c6:	68 51 01 00 00       	push   $0x151
  8037cb:	68 45 58 80 00       	push   $0x805845
  8037d0:	e8 bc d8 ff ff       	call   801091 <_panic>
  8037d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 10                	je     8037ee <alloc_block_BF+0x3d9>
  8037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e6:	8b 52 04             	mov    0x4(%edx),%edx
  8037e9:	89 50 04             	mov    %edx,0x4(%eax)
  8037ec:	eb 0b                	jmp    8037f9 <alloc_block_BF+0x3e4>
  8037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f1:	8b 40 04             	mov    0x4(%eax),%eax
  8037f4:	a3 48 60 80 00       	mov    %eax,0x806048
  8037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fc:	8b 40 04             	mov    0x4(%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 0f                	je     803812 <alloc_block_BF+0x3fd>
  803803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803806:	8b 40 04             	mov    0x4(%eax),%eax
  803809:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80380c:	8b 12                	mov    (%edx),%edx
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	eb 0a                	jmp    80381c <alloc_block_BF+0x407>
  803812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	a3 44 60 80 00       	mov    %eax,0x806044
  80381c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803828:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382f:	a1 50 60 80 00       	mov    0x806050,%eax
  803834:	48                   	dec    %eax
  803835:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  80383a:	83 ec 04             	sub    $0x4,%esp
  80383d:	6a 00                	push   $0x0
  80383f:	ff 75 d0             	pushl  -0x30(%ebp)
  803842:	ff 75 cc             	pushl  -0x34(%ebp)
  803845:	e8 e0 f6 ff ff       	call   802f2a <set_block_data>
  80384a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80384d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803850:	e9 a3 01 00 00       	jmp    8039f8 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803855:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803859:	0f 85 9d 00 00 00    	jne    8038fc <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80385f:	83 ec 04             	sub    $0x4,%esp
  803862:	6a 01                	push   $0x1
  803864:	ff 75 ec             	pushl  -0x14(%ebp)
  803867:	ff 75 f0             	pushl  -0x10(%ebp)
  80386a:	e8 bb f6 ff ff       	call   802f2a <set_block_data>
  80386f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803876:	75 17                	jne    80388f <alloc_block_BF+0x47a>
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	68 27 58 80 00       	push   $0x805827
  803880:	68 58 01 00 00       	push   $0x158
  803885:	68 45 58 80 00       	push   $0x805845
  80388a:	e8 02 d8 ff ff       	call   801091 <_panic>
  80388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	85 c0                	test   %eax,%eax
  803896:	74 10                	je     8038a8 <alloc_block_BF+0x493>
  803898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a0:	8b 52 04             	mov    0x4(%edx),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%eax)
  8038a6:	eb 0b                	jmp    8038b3 <alloc_block_BF+0x49e>
  8038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ab:	8b 40 04             	mov    0x4(%eax),%eax
  8038ae:	a3 48 60 80 00       	mov    %eax,0x806048
  8038b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b6:	8b 40 04             	mov    0x4(%eax),%eax
  8038b9:	85 c0                	test   %eax,%eax
  8038bb:	74 0f                	je     8038cc <alloc_block_BF+0x4b7>
  8038bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c0:	8b 40 04             	mov    0x4(%eax),%eax
  8038c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038c6:	8b 12                	mov    (%edx),%edx
  8038c8:	89 10                	mov    %edx,(%eax)
  8038ca:	eb 0a                	jmp    8038d6 <alloc_block_BF+0x4c1>
  8038cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	a3 44 60 80 00       	mov    %eax,0x806044
  8038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e9:	a1 50 60 80 00       	mov    0x806050,%eax
  8038ee:	48                   	dec    %eax
  8038ef:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  8038f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f7:	e9 fc 00 00 00       	jmp    8039f8 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	83 c0 08             	add    $0x8,%eax
  803902:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803905:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80390c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80390f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803912:	01 d0                	add    %edx,%eax
  803914:	48                   	dec    %eax
  803915:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803918:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80391b:	ba 00 00 00 00       	mov    $0x0,%edx
  803920:	f7 75 c4             	divl   -0x3c(%ebp)
  803923:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803926:	29 d0                	sub    %edx,%eax
  803928:	c1 e8 0c             	shr    $0xc,%eax
  80392b:	83 ec 0c             	sub    $0xc,%esp
  80392e:	50                   	push   %eax
  80392f:	e8 b4 e7 ff ff       	call   8020e8 <sbrk>
  803934:	83 c4 10             	add    $0x10,%esp
  803937:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80393a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80393e:	75 0a                	jne    80394a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803940:	b8 00 00 00 00       	mov    $0x0,%eax
  803945:	e9 ae 00 00 00       	jmp    8039f8 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80394a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803951:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803954:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803957:	01 d0                	add    %edx,%eax
  803959:	48                   	dec    %eax
  80395a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80395d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803960:	ba 00 00 00 00       	mov    $0x0,%edx
  803965:	f7 75 b8             	divl   -0x48(%ebp)
  803968:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80396b:	29 d0                	sub    %edx,%eax
  80396d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803970:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803973:	01 d0                	add    %edx,%eax
  803975:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  80397a:	a1 48 a2 80 00       	mov    0x80a248,%eax
  80397f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803985:	83 ec 0c             	sub    $0xc,%esp
  803988:	68 ec 58 80 00       	push   $0x8058ec
  80398d:	e8 bc d9 ff ff       	call   80134e <cprintf>
  803992:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803995:	83 ec 08             	sub    $0x8,%esp
  803998:	ff 75 bc             	pushl  -0x44(%ebp)
  80399b:	68 f1 58 80 00       	push   $0x8058f1
  8039a0:	e8 a9 d9 ff ff       	call   80134e <cprintf>
  8039a5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8039a8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8039af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039b5:	01 d0                	add    %edx,%eax
  8039b7:	48                   	dec    %eax
  8039b8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8039bb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8039be:	ba 00 00 00 00       	mov    $0x0,%edx
  8039c3:	f7 75 b0             	divl   -0x50(%ebp)
  8039c6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8039c9:	29 d0                	sub    %edx,%eax
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	6a 01                	push   $0x1
  8039d0:	50                   	push   %eax
  8039d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8039d4:	e8 51 f5 ff ff       	call   802f2a <set_block_data>
  8039d9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8039dc:	83 ec 0c             	sub    $0xc,%esp
  8039df:	ff 75 bc             	pushl  -0x44(%ebp)
  8039e2:	e8 36 04 00 00       	call   803e1d <free_block>
  8039e7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8039ea:	83 ec 0c             	sub    $0xc,%esp
  8039ed:	ff 75 08             	pushl  0x8(%ebp)
  8039f0:	e8 20 fa ff ff       	call   803415 <alloc_block_BF>
  8039f5:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
  8039fd:	53                   	push   %ebx
  8039fe:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a13:	74 1e                	je     803a33 <merging+0x39>
  803a15:	ff 75 08             	pushl  0x8(%ebp)
  803a18:	e8 bc f1 ff ff       	call   802bd9 <get_block_size>
  803a1d:	83 c4 04             	add    $0x4,%esp
  803a20:	89 c2                	mov    %eax,%edx
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	01 d0                	add    %edx,%eax
  803a27:	3b 45 10             	cmp    0x10(%ebp),%eax
  803a2a:	75 07                	jne    803a33 <merging+0x39>
		prev_is_free = 1;
  803a2c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803a33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a37:	74 1e                	je     803a57 <merging+0x5d>
  803a39:	ff 75 10             	pushl  0x10(%ebp)
  803a3c:	e8 98 f1 ff ff       	call   802bd9 <get_block_size>
  803a41:	83 c4 04             	add    $0x4,%esp
  803a44:	89 c2                	mov    %eax,%edx
  803a46:	8b 45 10             	mov    0x10(%ebp),%eax
  803a49:	01 d0                	add    %edx,%eax
  803a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a4e:	75 07                	jne    803a57 <merging+0x5d>
		next_is_free = 1;
  803a50:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5b:	0f 84 cc 00 00 00    	je     803b2d <merging+0x133>
  803a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a65:	0f 84 c2 00 00 00    	je     803b2d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803a6b:	ff 75 08             	pushl  0x8(%ebp)
  803a6e:	e8 66 f1 ff ff       	call   802bd9 <get_block_size>
  803a73:	83 c4 04             	add    $0x4,%esp
  803a76:	89 c3                	mov    %eax,%ebx
  803a78:	ff 75 10             	pushl  0x10(%ebp)
  803a7b:	e8 59 f1 ff ff       	call   802bd9 <get_block_size>
  803a80:	83 c4 04             	add    $0x4,%esp
  803a83:	01 c3                	add    %eax,%ebx
  803a85:	ff 75 0c             	pushl  0xc(%ebp)
  803a88:	e8 4c f1 ff ff       	call   802bd9 <get_block_size>
  803a8d:	83 c4 04             	add    $0x4,%esp
  803a90:	01 d8                	add    %ebx,%eax
  803a92:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803a95:	6a 00                	push   $0x0
  803a97:	ff 75 ec             	pushl  -0x14(%ebp)
  803a9a:	ff 75 08             	pushl  0x8(%ebp)
  803a9d:	e8 88 f4 ff ff       	call   802f2a <set_block_data>
  803aa2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803aa5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803aa9:	75 17                	jne    803ac2 <merging+0xc8>
  803aab:	83 ec 04             	sub    $0x4,%esp
  803aae:	68 27 58 80 00       	push   $0x805827
  803ab3:	68 7d 01 00 00       	push   $0x17d
  803ab8:	68 45 58 80 00       	push   $0x805845
  803abd:	e8 cf d5 ff ff       	call   801091 <_panic>
  803ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac5:	8b 00                	mov    (%eax),%eax
  803ac7:	85 c0                	test   %eax,%eax
  803ac9:	74 10                	je     803adb <merging+0xe1>
  803acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ad3:	8b 52 04             	mov    0x4(%edx),%edx
  803ad6:	89 50 04             	mov    %edx,0x4(%eax)
  803ad9:	eb 0b                	jmp    803ae6 <merging+0xec>
  803adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ade:	8b 40 04             	mov    0x4(%eax),%eax
  803ae1:	a3 48 60 80 00       	mov    %eax,0x806048
  803ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae9:	8b 40 04             	mov    0x4(%eax),%eax
  803aec:	85 c0                	test   %eax,%eax
  803aee:	74 0f                	je     803aff <merging+0x105>
  803af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af3:	8b 40 04             	mov    0x4(%eax),%eax
  803af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803af9:	8b 12                	mov    (%edx),%edx
  803afb:	89 10                	mov    %edx,(%eax)
  803afd:	eb 0a                	jmp    803b09 <merging+0x10f>
  803aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	a3 44 60 80 00       	mov    %eax,0x806044
  803b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1c:	a1 50 60 80 00       	mov    0x806050,%eax
  803b21:	48                   	dec    %eax
  803b22:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803b27:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b28:	e9 ea 02 00 00       	jmp    803e17 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b31:	74 3b                	je     803b6e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803b33:	83 ec 0c             	sub    $0xc,%esp
  803b36:	ff 75 08             	pushl  0x8(%ebp)
  803b39:	e8 9b f0 ff ff       	call   802bd9 <get_block_size>
  803b3e:	83 c4 10             	add    $0x10,%esp
  803b41:	89 c3                	mov    %eax,%ebx
  803b43:	83 ec 0c             	sub    $0xc,%esp
  803b46:	ff 75 10             	pushl  0x10(%ebp)
  803b49:	e8 8b f0 ff ff       	call   802bd9 <get_block_size>
  803b4e:	83 c4 10             	add    $0x10,%esp
  803b51:	01 d8                	add    %ebx,%eax
  803b53:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b56:	83 ec 04             	sub    $0x4,%esp
  803b59:	6a 00                	push   $0x0
  803b5b:	ff 75 e8             	pushl  -0x18(%ebp)
  803b5e:	ff 75 08             	pushl  0x8(%ebp)
  803b61:	e8 c4 f3 ff ff       	call   802f2a <set_block_data>
  803b66:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b69:	e9 a9 02 00 00       	jmp    803e17 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803b6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b72:	0f 84 2d 01 00 00    	je     803ca5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803b78:	83 ec 0c             	sub    $0xc,%esp
  803b7b:	ff 75 10             	pushl  0x10(%ebp)
  803b7e:	e8 56 f0 ff ff       	call   802bd9 <get_block_size>
  803b83:	83 c4 10             	add    $0x10,%esp
  803b86:	89 c3                	mov    %eax,%ebx
  803b88:	83 ec 0c             	sub    $0xc,%esp
  803b8b:	ff 75 0c             	pushl  0xc(%ebp)
  803b8e:	e8 46 f0 ff ff       	call   802bd9 <get_block_size>
  803b93:	83 c4 10             	add    $0x10,%esp
  803b96:	01 d8                	add    %ebx,%eax
  803b98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803b9b:	83 ec 04             	sub    $0x4,%esp
  803b9e:	6a 00                	push   $0x0
  803ba0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ba3:	ff 75 10             	pushl  0x10(%ebp)
  803ba6:	e8 7f f3 ff ff       	call   802f2a <set_block_data>
  803bab:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803bae:	8b 45 10             	mov    0x10(%ebp),%eax
  803bb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803bb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bb8:	74 06                	je     803bc0 <merging+0x1c6>
  803bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bbe:	75 17                	jne    803bd7 <merging+0x1dd>
  803bc0:	83 ec 04             	sub    $0x4,%esp
  803bc3:	68 00 59 80 00       	push   $0x805900
  803bc8:	68 8d 01 00 00       	push   $0x18d
  803bcd:	68 45 58 80 00       	push   $0x805845
  803bd2:	e8 ba d4 ff ff       	call   801091 <_panic>
  803bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bda:	8b 50 04             	mov    0x4(%eax),%edx
  803bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be0:	89 50 04             	mov    %edx,0x4(%eax)
  803be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803be9:	89 10                	mov    %edx,(%eax)
  803beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bee:	8b 40 04             	mov    0x4(%eax),%eax
  803bf1:	85 c0                	test   %eax,%eax
  803bf3:	74 0d                	je     803c02 <merging+0x208>
  803bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf8:	8b 40 04             	mov    0x4(%eax),%eax
  803bfb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bfe:	89 10                	mov    %edx,(%eax)
  803c00:	eb 08                	jmp    803c0a <merging+0x210>
  803c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c05:	a3 44 60 80 00       	mov    %eax,0x806044
  803c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c10:	89 50 04             	mov    %edx,0x4(%eax)
  803c13:	a1 50 60 80 00       	mov    0x806050,%eax
  803c18:	40                   	inc    %eax
  803c19:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803c1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c22:	75 17                	jne    803c3b <merging+0x241>
  803c24:	83 ec 04             	sub    $0x4,%esp
  803c27:	68 27 58 80 00       	push   $0x805827
  803c2c:	68 8e 01 00 00       	push   $0x18e
  803c31:	68 45 58 80 00       	push   $0x805845
  803c36:	e8 56 d4 ff ff       	call   801091 <_panic>
  803c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c3e:	8b 00                	mov    (%eax),%eax
  803c40:	85 c0                	test   %eax,%eax
  803c42:	74 10                	je     803c54 <merging+0x25a>
  803c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c4c:	8b 52 04             	mov    0x4(%edx),%edx
  803c4f:	89 50 04             	mov    %edx,0x4(%eax)
  803c52:	eb 0b                	jmp    803c5f <merging+0x265>
  803c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c57:	8b 40 04             	mov    0x4(%eax),%eax
  803c5a:	a3 48 60 80 00       	mov    %eax,0x806048
  803c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c62:	8b 40 04             	mov    0x4(%eax),%eax
  803c65:	85 c0                	test   %eax,%eax
  803c67:	74 0f                	je     803c78 <merging+0x27e>
  803c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6c:	8b 40 04             	mov    0x4(%eax),%eax
  803c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c72:	8b 12                	mov    (%edx),%edx
  803c74:	89 10                	mov    %edx,(%eax)
  803c76:	eb 0a                	jmp    803c82 <merging+0x288>
  803c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c7b:	8b 00                	mov    (%eax),%eax
  803c7d:	a3 44 60 80 00       	mov    %eax,0x806044
  803c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c95:	a1 50 60 80 00       	mov    0x806050,%eax
  803c9a:	48                   	dec    %eax
  803c9b:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ca0:	e9 72 01 00 00       	jmp    803e17 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  803ca8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803cab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803caf:	74 79                	je     803d2a <merging+0x330>
  803cb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cb5:	74 73                	je     803d2a <merging+0x330>
  803cb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cbb:	74 06                	je     803cc3 <merging+0x2c9>
  803cbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cc1:	75 17                	jne    803cda <merging+0x2e0>
  803cc3:	83 ec 04             	sub    $0x4,%esp
  803cc6:	68 b8 58 80 00       	push   $0x8058b8
  803ccb:	68 94 01 00 00       	push   $0x194
  803cd0:	68 45 58 80 00       	push   $0x805845
  803cd5:	e8 b7 d3 ff ff       	call   801091 <_panic>
  803cda:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdd:	8b 10                	mov    (%eax),%edx
  803cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ce2:	89 10                	mov    %edx,(%eax)
  803ce4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ce7:	8b 00                	mov    (%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 0b                	je     803cf8 <merging+0x2fe>
  803ced:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf0:	8b 00                	mov    (%eax),%eax
  803cf2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cf5:	89 50 04             	mov    %edx,0x4(%eax)
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cfe:	89 10                	mov    %edx,(%eax)
  803d00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d03:	8b 55 08             	mov    0x8(%ebp),%edx
  803d06:	89 50 04             	mov    %edx,0x4(%eax)
  803d09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d0c:	8b 00                	mov    (%eax),%eax
  803d0e:	85 c0                	test   %eax,%eax
  803d10:	75 08                	jne    803d1a <merging+0x320>
  803d12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d15:	a3 48 60 80 00       	mov    %eax,0x806048
  803d1a:	a1 50 60 80 00       	mov    0x806050,%eax
  803d1f:	40                   	inc    %eax
  803d20:	a3 50 60 80 00       	mov    %eax,0x806050
  803d25:	e9 ce 00 00 00       	jmp    803df8 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803d2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d2e:	74 65                	je     803d95 <merging+0x39b>
  803d30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d34:	75 17                	jne    803d4d <merging+0x353>
  803d36:	83 ec 04             	sub    $0x4,%esp
  803d39:	68 94 58 80 00       	push   $0x805894
  803d3e:	68 95 01 00 00       	push   $0x195
  803d43:	68 45 58 80 00       	push   $0x805845
  803d48:	e8 44 d3 ff ff       	call   801091 <_panic>
  803d4d:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803d53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d56:	89 50 04             	mov    %edx,0x4(%eax)
  803d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5c:	8b 40 04             	mov    0x4(%eax),%eax
  803d5f:	85 c0                	test   %eax,%eax
  803d61:	74 0c                	je     803d6f <merging+0x375>
  803d63:	a1 48 60 80 00       	mov    0x806048,%eax
  803d68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d6b:	89 10                	mov    %edx,(%eax)
  803d6d:	eb 08                	jmp    803d77 <merging+0x37d>
  803d6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d72:	a3 44 60 80 00       	mov    %eax,0x806044
  803d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d7a:	a3 48 60 80 00       	mov    %eax,0x806048
  803d7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d88:	a1 50 60 80 00       	mov    0x806050,%eax
  803d8d:	40                   	inc    %eax
  803d8e:	a3 50 60 80 00       	mov    %eax,0x806050
  803d93:	eb 63                	jmp    803df8 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803d95:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d99:	75 17                	jne    803db2 <merging+0x3b8>
  803d9b:	83 ec 04             	sub    $0x4,%esp
  803d9e:	68 60 58 80 00       	push   $0x805860
  803da3:	68 98 01 00 00       	push   $0x198
  803da8:	68 45 58 80 00       	push   $0x805845
  803dad:	e8 df d2 ff ff       	call   801091 <_panic>
  803db2:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dbb:	89 10                	mov    %edx,(%eax)
  803dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc0:	8b 00                	mov    (%eax),%eax
  803dc2:	85 c0                	test   %eax,%eax
  803dc4:	74 0d                	je     803dd3 <merging+0x3d9>
  803dc6:	a1 44 60 80 00       	mov    0x806044,%eax
  803dcb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dce:	89 50 04             	mov    %edx,0x4(%eax)
  803dd1:	eb 08                	jmp    803ddb <merging+0x3e1>
  803dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd6:	a3 48 60 80 00       	mov    %eax,0x806048
  803ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dde:	a3 44 60 80 00       	mov    %eax,0x806044
  803de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ded:	a1 50 60 80 00       	mov    0x806050,%eax
  803df2:	40                   	inc    %eax
  803df3:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803df8:	83 ec 0c             	sub    $0xc,%esp
  803dfb:	ff 75 10             	pushl  0x10(%ebp)
  803dfe:	e8 d6 ed ff ff       	call   802bd9 <get_block_size>
  803e03:	83 c4 10             	add    $0x10,%esp
  803e06:	83 ec 04             	sub    $0x4,%esp
  803e09:	6a 00                	push   $0x0
  803e0b:	50                   	push   %eax
  803e0c:	ff 75 10             	pushl  0x10(%ebp)
  803e0f:	e8 16 f1 ff ff       	call   802f2a <set_block_data>
  803e14:	83 c4 10             	add    $0x10,%esp
	}
}
  803e17:	90                   	nop
  803e18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e1b:	c9                   	leave  
  803e1c:	c3                   	ret    

00803e1d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e1d:	55                   	push   %ebp
  803e1e:	89 e5                	mov    %esp,%ebp
  803e20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803e23:	a1 44 60 80 00       	mov    0x806044,%eax
  803e28:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803e2b:	a1 48 60 80 00       	mov    0x806048,%eax
  803e30:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e33:	73 1b                	jae    803e50 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803e35:	a1 48 60 80 00       	mov    0x806048,%eax
  803e3a:	83 ec 04             	sub    $0x4,%esp
  803e3d:	ff 75 08             	pushl  0x8(%ebp)
  803e40:	6a 00                	push   $0x0
  803e42:	50                   	push   %eax
  803e43:	e8 b2 fb ff ff       	call   8039fa <merging>
  803e48:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e4b:	e9 8b 00 00 00       	jmp    803edb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803e50:	a1 44 60 80 00       	mov    0x806044,%eax
  803e55:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e58:	76 18                	jbe    803e72 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803e5a:	a1 44 60 80 00       	mov    0x806044,%eax
  803e5f:	83 ec 04             	sub    $0x4,%esp
  803e62:	ff 75 08             	pushl  0x8(%ebp)
  803e65:	50                   	push   %eax
  803e66:	6a 00                	push   $0x0
  803e68:	e8 8d fb ff ff       	call   8039fa <merging>
  803e6d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e70:	eb 69                	jmp    803edb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803e72:	a1 44 60 80 00       	mov    0x806044,%eax
  803e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e7a:	eb 39                	jmp    803eb5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e82:	73 29                	jae    803ead <free_block+0x90>
  803e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e87:	8b 00                	mov    (%eax),%eax
  803e89:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e8c:	76 1f                	jbe    803ead <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e91:	8b 00                	mov    (%eax),%eax
  803e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803e96:	83 ec 04             	sub    $0x4,%esp
  803e99:	ff 75 08             	pushl  0x8(%ebp)
  803e9c:	ff 75 f0             	pushl  -0x10(%ebp)
  803e9f:	ff 75 f4             	pushl  -0xc(%ebp)
  803ea2:	e8 53 fb ff ff       	call   8039fa <merging>
  803ea7:	83 c4 10             	add    $0x10,%esp
			break;
  803eaa:	90                   	nop
		}
	}
}
  803eab:	eb 2e                	jmp    803edb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ead:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803eb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eb9:	74 07                	je     803ec2 <free_block+0xa5>
  803ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebe:	8b 00                	mov    (%eax),%eax
  803ec0:	eb 05                	jmp    803ec7 <free_block+0xaa>
  803ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec7:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803ecc:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803ed1:	85 c0                	test   %eax,%eax
  803ed3:	75 a7                	jne    803e7c <free_block+0x5f>
  803ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ed9:	75 a1                	jne    803e7c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803edb:	90                   	nop
  803edc:	c9                   	leave  
  803edd:	c3                   	ret    

00803ede <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803ede:	55                   	push   %ebp
  803edf:	89 e5                	mov    %esp,%ebp
  803ee1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803ee4:	ff 75 08             	pushl  0x8(%ebp)
  803ee7:	e8 ed ec ff ff       	call   802bd9 <get_block_size>
  803eec:	83 c4 04             	add    $0x4,%esp
  803eef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803ef2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803ef9:	eb 17                	jmp    803f12 <copy_data+0x34>
  803efb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f01:	01 c2                	add    %eax,%edx
  803f03:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f06:	8b 45 08             	mov    0x8(%ebp),%eax
  803f09:	01 c8                	add    %ecx,%eax
  803f0b:	8a 00                	mov    (%eax),%al
  803f0d:	88 02                	mov    %al,(%edx)
  803f0f:	ff 45 fc             	incl   -0x4(%ebp)
  803f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f18:	72 e1                	jb     803efb <copy_data+0x1d>
}
  803f1a:	90                   	nop
  803f1b:	c9                   	leave  
  803f1c:	c3                   	ret    

00803f1d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f1d:	55                   	push   %ebp
  803f1e:	89 e5                	mov    %esp,%ebp
  803f20:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803f23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f27:	75 23                	jne    803f4c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803f29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f2d:	74 13                	je     803f42 <realloc_block_FF+0x25>
  803f2f:	83 ec 0c             	sub    $0xc,%esp
  803f32:	ff 75 0c             	pushl  0xc(%ebp)
  803f35:	e8 1f f0 ff ff       	call   802f59 <alloc_block_FF>
  803f3a:	83 c4 10             	add    $0x10,%esp
  803f3d:	e9 f4 06 00 00       	jmp    804636 <realloc_block_FF+0x719>
		return NULL;
  803f42:	b8 00 00 00 00       	mov    $0x0,%eax
  803f47:	e9 ea 06 00 00       	jmp    804636 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803f4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f50:	75 18                	jne    803f6a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803f52:	83 ec 0c             	sub    $0xc,%esp
  803f55:	ff 75 08             	pushl  0x8(%ebp)
  803f58:	e8 c0 fe ff ff       	call   803e1d <free_block>
  803f5d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803f60:	b8 00 00 00 00       	mov    $0x0,%eax
  803f65:	e9 cc 06 00 00       	jmp    804636 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803f6a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803f6e:	77 07                	ja     803f77 <realloc_block_FF+0x5a>
  803f70:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7a:	83 e0 01             	and    $0x1,%eax
  803f7d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f83:	83 c0 08             	add    $0x8,%eax
  803f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803f89:	83 ec 0c             	sub    $0xc,%esp
  803f8c:	ff 75 08             	pushl  0x8(%ebp)
  803f8f:	e8 45 ec ff ff       	call   802bd9 <get_block_size>
  803f94:	83 c4 10             	add    $0x10,%esp
  803f97:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f9d:	83 e8 08             	sub    $0x8,%eax
  803fa0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa6:	83 e8 04             	sub    $0x4,%eax
  803fa9:	8b 00                	mov    (%eax),%eax
  803fab:	83 e0 fe             	and    $0xfffffffe,%eax
  803fae:	89 c2                	mov    %eax,%edx
  803fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb3:	01 d0                	add    %edx,%eax
  803fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803fb8:	83 ec 0c             	sub    $0xc,%esp
  803fbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fbe:	e8 16 ec ff ff       	call   802bd9 <get_block_size>
  803fc3:	83 c4 10             	add    $0x10,%esp
  803fc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fcc:	83 e8 08             	sub    $0x8,%eax
  803fcf:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fd8:	75 08                	jne    803fe2 <realloc_block_FF+0xc5>
	{
		 return va;
  803fda:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdd:	e9 54 06 00 00       	jmp    804636 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fe8:	0f 83 e5 03 00 00    	jae    8043d3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff1:	2b 45 0c             	sub    0xc(%ebp),%eax
  803ff4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ff7:	83 ec 0c             	sub    $0xc,%esp
  803ffa:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ffd:	e8 f0 eb ff ff       	call   802bf2 <is_free_block>
  804002:	83 c4 10             	add    $0x10,%esp
  804005:	84 c0                	test   %al,%al
  804007:	0f 84 3b 01 00 00    	je     804148 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80400d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804010:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804013:	01 d0                	add    %edx,%eax
  804015:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804018:	83 ec 04             	sub    $0x4,%esp
  80401b:	6a 01                	push   $0x1
  80401d:	ff 75 f0             	pushl  -0x10(%ebp)
  804020:	ff 75 08             	pushl  0x8(%ebp)
  804023:	e8 02 ef ff ff       	call   802f2a <set_block_data>
  804028:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80402b:	8b 45 08             	mov    0x8(%ebp),%eax
  80402e:	83 e8 04             	sub    $0x4,%eax
  804031:	8b 00                	mov    (%eax),%eax
  804033:	83 e0 fe             	and    $0xfffffffe,%eax
  804036:	89 c2                	mov    %eax,%edx
  804038:	8b 45 08             	mov    0x8(%ebp),%eax
  80403b:	01 d0                	add    %edx,%eax
  80403d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804040:	83 ec 04             	sub    $0x4,%esp
  804043:	6a 00                	push   $0x0
  804045:	ff 75 cc             	pushl  -0x34(%ebp)
  804048:	ff 75 c8             	pushl  -0x38(%ebp)
  80404b:	e8 da ee ff ff       	call   802f2a <set_block_data>
  804050:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804053:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804057:	74 06                	je     80405f <realloc_block_FF+0x142>
  804059:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80405d:	75 17                	jne    804076 <realloc_block_FF+0x159>
  80405f:	83 ec 04             	sub    $0x4,%esp
  804062:	68 b8 58 80 00       	push   $0x8058b8
  804067:	68 f6 01 00 00       	push   $0x1f6
  80406c:	68 45 58 80 00       	push   $0x805845
  804071:	e8 1b d0 ff ff       	call   801091 <_panic>
  804076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804079:	8b 10                	mov    (%eax),%edx
  80407b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80407e:	89 10                	mov    %edx,(%eax)
  804080:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804083:	8b 00                	mov    (%eax),%eax
  804085:	85 c0                	test   %eax,%eax
  804087:	74 0b                	je     804094 <realloc_block_FF+0x177>
  804089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408c:	8b 00                	mov    (%eax),%eax
  80408e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804091:	89 50 04             	mov    %edx,0x4(%eax)
  804094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804097:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80409a:	89 10                	mov    %edx,(%eax)
  80409c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80409f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040a2:	89 50 04             	mov    %edx,0x4(%eax)
  8040a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040a8:	8b 00                	mov    (%eax),%eax
  8040aa:	85 c0                	test   %eax,%eax
  8040ac:	75 08                	jne    8040b6 <realloc_block_FF+0x199>
  8040ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040b1:	a3 48 60 80 00       	mov    %eax,0x806048
  8040b6:	a1 50 60 80 00       	mov    0x806050,%eax
  8040bb:	40                   	inc    %eax
  8040bc:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040c5:	75 17                	jne    8040de <realloc_block_FF+0x1c1>
  8040c7:	83 ec 04             	sub    $0x4,%esp
  8040ca:	68 27 58 80 00       	push   $0x805827
  8040cf:	68 f7 01 00 00       	push   $0x1f7
  8040d4:	68 45 58 80 00       	push   $0x805845
  8040d9:	e8 b3 cf ff ff       	call   801091 <_panic>
  8040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e1:	8b 00                	mov    (%eax),%eax
  8040e3:	85 c0                	test   %eax,%eax
  8040e5:	74 10                	je     8040f7 <realloc_block_FF+0x1da>
  8040e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ea:	8b 00                	mov    (%eax),%eax
  8040ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ef:	8b 52 04             	mov    0x4(%edx),%edx
  8040f2:	89 50 04             	mov    %edx,0x4(%eax)
  8040f5:	eb 0b                	jmp    804102 <realloc_block_FF+0x1e5>
  8040f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040fa:	8b 40 04             	mov    0x4(%eax),%eax
  8040fd:	a3 48 60 80 00       	mov    %eax,0x806048
  804102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804105:	8b 40 04             	mov    0x4(%eax),%eax
  804108:	85 c0                	test   %eax,%eax
  80410a:	74 0f                	je     80411b <realloc_block_FF+0x1fe>
  80410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410f:	8b 40 04             	mov    0x4(%eax),%eax
  804112:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804115:	8b 12                	mov    (%edx),%edx
  804117:	89 10                	mov    %edx,(%eax)
  804119:	eb 0a                	jmp    804125 <realloc_block_FF+0x208>
  80411b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411e:	8b 00                	mov    (%eax),%eax
  804120:	a3 44 60 80 00       	mov    %eax,0x806044
  804125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80412e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804131:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804138:	a1 50 60 80 00       	mov    0x806050,%eax
  80413d:	48                   	dec    %eax
  80413e:	a3 50 60 80 00       	mov    %eax,0x806050
  804143:	e9 83 02 00 00       	jmp    8043cb <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804148:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80414c:	0f 86 69 02 00 00    	jbe    8043bb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804152:	83 ec 04             	sub    $0x4,%esp
  804155:	6a 01                	push   $0x1
  804157:	ff 75 f0             	pushl  -0x10(%ebp)
  80415a:	ff 75 08             	pushl  0x8(%ebp)
  80415d:	e8 c8 ed ff ff       	call   802f2a <set_block_data>
  804162:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804165:	8b 45 08             	mov    0x8(%ebp),%eax
  804168:	83 e8 04             	sub    $0x4,%eax
  80416b:	8b 00                	mov    (%eax),%eax
  80416d:	83 e0 fe             	and    $0xfffffffe,%eax
  804170:	89 c2                	mov    %eax,%edx
  804172:	8b 45 08             	mov    0x8(%ebp),%eax
  804175:	01 d0                	add    %edx,%eax
  804177:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80417a:	a1 50 60 80 00       	mov    0x806050,%eax
  80417f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804182:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804186:	75 68                	jne    8041f0 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804188:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80418c:	75 17                	jne    8041a5 <realloc_block_FF+0x288>
  80418e:	83 ec 04             	sub    $0x4,%esp
  804191:	68 60 58 80 00       	push   $0x805860
  804196:	68 06 02 00 00       	push   $0x206
  80419b:	68 45 58 80 00       	push   $0x805845
  8041a0:	e8 ec ce ff ff       	call   801091 <_panic>
  8041a5:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8041ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041ae:	89 10                	mov    %edx,(%eax)
  8041b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041b3:	8b 00                	mov    (%eax),%eax
  8041b5:	85 c0                	test   %eax,%eax
  8041b7:	74 0d                	je     8041c6 <realloc_block_FF+0x2a9>
  8041b9:	a1 44 60 80 00       	mov    0x806044,%eax
  8041be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041c1:	89 50 04             	mov    %edx,0x4(%eax)
  8041c4:	eb 08                	jmp    8041ce <realloc_block_FF+0x2b1>
  8041c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c9:	a3 48 60 80 00       	mov    %eax,0x806048
  8041ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041d1:	a3 44 60 80 00       	mov    %eax,0x806044
  8041d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e0:	a1 50 60 80 00       	mov    0x806050,%eax
  8041e5:	40                   	inc    %eax
  8041e6:	a3 50 60 80 00       	mov    %eax,0x806050
  8041eb:	e9 b0 01 00 00       	jmp    8043a0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8041f0:	a1 44 60 80 00       	mov    0x806044,%eax
  8041f5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041f8:	76 68                	jbe    804262 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041fa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041fe:	75 17                	jne    804217 <realloc_block_FF+0x2fa>
  804200:	83 ec 04             	sub    $0x4,%esp
  804203:	68 60 58 80 00       	push   $0x805860
  804208:	68 0b 02 00 00       	push   $0x20b
  80420d:	68 45 58 80 00       	push   $0x805845
  804212:	e8 7a ce ff ff       	call   801091 <_panic>
  804217:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80421d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804220:	89 10                	mov    %edx,(%eax)
  804222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804225:	8b 00                	mov    (%eax),%eax
  804227:	85 c0                	test   %eax,%eax
  804229:	74 0d                	je     804238 <realloc_block_FF+0x31b>
  80422b:	a1 44 60 80 00       	mov    0x806044,%eax
  804230:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804233:	89 50 04             	mov    %edx,0x4(%eax)
  804236:	eb 08                	jmp    804240 <realloc_block_FF+0x323>
  804238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80423b:	a3 48 60 80 00       	mov    %eax,0x806048
  804240:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804243:	a3 44 60 80 00       	mov    %eax,0x806044
  804248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80424b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804252:	a1 50 60 80 00       	mov    0x806050,%eax
  804257:	40                   	inc    %eax
  804258:	a3 50 60 80 00       	mov    %eax,0x806050
  80425d:	e9 3e 01 00 00       	jmp    8043a0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804262:	a1 44 60 80 00       	mov    0x806044,%eax
  804267:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80426a:	73 68                	jae    8042d4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80426c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804270:	75 17                	jne    804289 <realloc_block_FF+0x36c>
  804272:	83 ec 04             	sub    $0x4,%esp
  804275:	68 94 58 80 00       	push   $0x805894
  80427a:	68 10 02 00 00       	push   $0x210
  80427f:	68 45 58 80 00       	push   $0x805845
  804284:	e8 08 ce ff ff       	call   801091 <_panic>
  804289:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80428f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804292:	89 50 04             	mov    %edx,0x4(%eax)
  804295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804298:	8b 40 04             	mov    0x4(%eax),%eax
  80429b:	85 c0                	test   %eax,%eax
  80429d:	74 0c                	je     8042ab <realloc_block_FF+0x38e>
  80429f:	a1 48 60 80 00       	mov    0x806048,%eax
  8042a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042a7:	89 10                	mov    %edx,(%eax)
  8042a9:	eb 08                	jmp    8042b3 <realloc_block_FF+0x396>
  8042ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ae:	a3 44 60 80 00       	mov    %eax,0x806044
  8042b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b6:	a3 48 60 80 00       	mov    %eax,0x806048
  8042bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042c4:	a1 50 60 80 00       	mov    0x806050,%eax
  8042c9:	40                   	inc    %eax
  8042ca:	a3 50 60 80 00       	mov    %eax,0x806050
  8042cf:	e9 cc 00 00 00       	jmp    8043a0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8042d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8042db:	a1 44 60 80 00       	mov    0x806044,%eax
  8042e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042e3:	e9 8a 00 00 00       	jmp    804372 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8042e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042eb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042ee:	73 7a                	jae    80436a <realloc_block_FF+0x44d>
  8042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f3:	8b 00                	mov    (%eax),%eax
  8042f5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042f8:	73 70                	jae    80436a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8042fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042fe:	74 06                	je     804306 <realloc_block_FF+0x3e9>
  804300:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804304:	75 17                	jne    80431d <realloc_block_FF+0x400>
  804306:	83 ec 04             	sub    $0x4,%esp
  804309:	68 b8 58 80 00       	push   $0x8058b8
  80430e:	68 1a 02 00 00       	push   $0x21a
  804313:	68 45 58 80 00       	push   $0x805845
  804318:	e8 74 cd ff ff       	call   801091 <_panic>
  80431d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804320:	8b 10                	mov    (%eax),%edx
  804322:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804325:	89 10                	mov    %edx,(%eax)
  804327:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80432a:	8b 00                	mov    (%eax),%eax
  80432c:	85 c0                	test   %eax,%eax
  80432e:	74 0b                	je     80433b <realloc_block_FF+0x41e>
  804330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804333:	8b 00                	mov    (%eax),%eax
  804335:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804338:	89 50 04             	mov    %edx,0x4(%eax)
  80433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804341:	89 10                	mov    %edx,(%eax)
  804343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804349:	89 50 04             	mov    %edx,0x4(%eax)
  80434c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80434f:	8b 00                	mov    (%eax),%eax
  804351:	85 c0                	test   %eax,%eax
  804353:	75 08                	jne    80435d <realloc_block_FF+0x440>
  804355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804358:	a3 48 60 80 00       	mov    %eax,0x806048
  80435d:	a1 50 60 80 00       	mov    0x806050,%eax
  804362:	40                   	inc    %eax
  804363:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  804368:	eb 36                	jmp    8043a0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80436a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80436f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804376:	74 07                	je     80437f <realloc_block_FF+0x462>
  804378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437b:	8b 00                	mov    (%eax),%eax
  80437d:	eb 05                	jmp    804384 <realloc_block_FF+0x467>
  80437f:	b8 00 00 00 00       	mov    $0x0,%eax
  804384:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804389:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80438e:	85 c0                	test   %eax,%eax
  804390:	0f 85 52 ff ff ff    	jne    8042e8 <realloc_block_FF+0x3cb>
  804396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80439a:	0f 85 48 ff ff ff    	jne    8042e8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8043a0:	83 ec 04             	sub    $0x4,%esp
  8043a3:	6a 00                	push   $0x0
  8043a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8043a8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8043ab:	e8 7a eb ff ff       	call   802f2a <set_block_data>
  8043b0:	83 c4 10             	add    $0x10,%esp
				return va;
  8043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b6:	e9 7b 02 00 00       	jmp    804636 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8043bb:	83 ec 0c             	sub    $0xc,%esp
  8043be:	68 35 59 80 00       	push   $0x805935
  8043c3:	e8 86 cf ff ff       	call   80134e <cprintf>
  8043c8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8043cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ce:	e9 63 02 00 00       	jmp    804636 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8043d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043d6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8043d9:	0f 86 4d 02 00 00    	jbe    80462c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8043df:	83 ec 0c             	sub    $0xc,%esp
  8043e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8043e5:	e8 08 e8 ff ff       	call   802bf2 <is_free_block>
  8043ea:	83 c4 10             	add    $0x10,%esp
  8043ed:	84 c0                	test   %al,%al
  8043ef:	0f 84 37 02 00 00    	je     80462c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8043f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043f8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8043fb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8043fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804401:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804404:	76 38                	jbe    80443e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804406:	83 ec 0c             	sub    $0xc,%esp
  804409:	ff 75 08             	pushl  0x8(%ebp)
  80440c:	e8 0c fa ff ff       	call   803e1d <free_block>
  804411:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804414:	83 ec 0c             	sub    $0xc,%esp
  804417:	ff 75 0c             	pushl  0xc(%ebp)
  80441a:	e8 3a eb ff ff       	call   802f59 <alloc_block_FF>
  80441f:	83 c4 10             	add    $0x10,%esp
  804422:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804425:	83 ec 08             	sub    $0x8,%esp
  804428:	ff 75 c0             	pushl  -0x40(%ebp)
  80442b:	ff 75 08             	pushl  0x8(%ebp)
  80442e:	e8 ab fa ff ff       	call   803ede <copy_data>
  804433:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804436:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804439:	e9 f8 01 00 00       	jmp    804636 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80443e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804441:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804444:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804447:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80444b:	0f 87 a0 00 00 00    	ja     8044f1 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804451:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804455:	75 17                	jne    80446e <realloc_block_FF+0x551>
  804457:	83 ec 04             	sub    $0x4,%esp
  80445a:	68 27 58 80 00       	push   $0x805827
  80445f:	68 38 02 00 00       	push   $0x238
  804464:	68 45 58 80 00       	push   $0x805845
  804469:	e8 23 cc ff ff       	call   801091 <_panic>
  80446e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804471:	8b 00                	mov    (%eax),%eax
  804473:	85 c0                	test   %eax,%eax
  804475:	74 10                	je     804487 <realloc_block_FF+0x56a>
  804477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80447a:	8b 00                	mov    (%eax),%eax
  80447c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80447f:	8b 52 04             	mov    0x4(%edx),%edx
  804482:	89 50 04             	mov    %edx,0x4(%eax)
  804485:	eb 0b                	jmp    804492 <realloc_block_FF+0x575>
  804487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80448a:	8b 40 04             	mov    0x4(%eax),%eax
  80448d:	a3 48 60 80 00       	mov    %eax,0x806048
  804492:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804495:	8b 40 04             	mov    0x4(%eax),%eax
  804498:	85 c0                	test   %eax,%eax
  80449a:	74 0f                	je     8044ab <realloc_block_FF+0x58e>
  80449c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80449f:	8b 40 04             	mov    0x4(%eax),%eax
  8044a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044a5:	8b 12                	mov    (%edx),%edx
  8044a7:	89 10                	mov    %edx,(%eax)
  8044a9:	eb 0a                	jmp    8044b5 <realloc_block_FF+0x598>
  8044ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ae:	8b 00                	mov    (%eax),%eax
  8044b0:	a3 44 60 80 00       	mov    %eax,0x806044
  8044b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044c8:	a1 50 60 80 00       	mov    0x806050,%eax
  8044cd:	48                   	dec    %eax
  8044ce:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8044d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8044d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044d9:	01 d0                	add    %edx,%eax
  8044db:	83 ec 04             	sub    $0x4,%esp
  8044de:	6a 01                	push   $0x1
  8044e0:	50                   	push   %eax
  8044e1:	ff 75 08             	pushl  0x8(%ebp)
  8044e4:	e8 41 ea ff ff       	call   802f2a <set_block_data>
  8044e9:	83 c4 10             	add    $0x10,%esp
  8044ec:	e9 36 01 00 00       	jmp    804627 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8044f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8044f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8044f7:	01 d0                	add    %edx,%eax
  8044f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8044fc:	83 ec 04             	sub    $0x4,%esp
  8044ff:	6a 01                	push   $0x1
  804501:	ff 75 f0             	pushl  -0x10(%ebp)
  804504:	ff 75 08             	pushl  0x8(%ebp)
  804507:	e8 1e ea ff ff       	call   802f2a <set_block_data>
  80450c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80450f:	8b 45 08             	mov    0x8(%ebp),%eax
  804512:	83 e8 04             	sub    $0x4,%eax
  804515:	8b 00                	mov    (%eax),%eax
  804517:	83 e0 fe             	and    $0xfffffffe,%eax
  80451a:	89 c2                	mov    %eax,%edx
  80451c:	8b 45 08             	mov    0x8(%ebp),%eax
  80451f:	01 d0                	add    %edx,%eax
  804521:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804524:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804528:	74 06                	je     804530 <realloc_block_FF+0x613>
  80452a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80452e:	75 17                	jne    804547 <realloc_block_FF+0x62a>
  804530:	83 ec 04             	sub    $0x4,%esp
  804533:	68 b8 58 80 00       	push   $0x8058b8
  804538:	68 44 02 00 00       	push   $0x244
  80453d:	68 45 58 80 00       	push   $0x805845
  804542:	e8 4a cb ff ff       	call   801091 <_panic>
  804547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80454a:	8b 10                	mov    (%eax),%edx
  80454c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80454f:	89 10                	mov    %edx,(%eax)
  804551:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804554:	8b 00                	mov    (%eax),%eax
  804556:	85 c0                	test   %eax,%eax
  804558:	74 0b                	je     804565 <realloc_block_FF+0x648>
  80455a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80455d:	8b 00                	mov    (%eax),%eax
  80455f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804562:	89 50 04             	mov    %edx,0x4(%eax)
  804565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804568:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80456b:	89 10                	mov    %edx,(%eax)
  80456d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804573:	89 50 04             	mov    %edx,0x4(%eax)
  804576:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804579:	8b 00                	mov    (%eax),%eax
  80457b:	85 c0                	test   %eax,%eax
  80457d:	75 08                	jne    804587 <realloc_block_FF+0x66a>
  80457f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804582:	a3 48 60 80 00       	mov    %eax,0x806048
  804587:	a1 50 60 80 00       	mov    0x806050,%eax
  80458c:	40                   	inc    %eax
  80458d:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804592:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804596:	75 17                	jne    8045af <realloc_block_FF+0x692>
  804598:	83 ec 04             	sub    $0x4,%esp
  80459b:	68 27 58 80 00       	push   $0x805827
  8045a0:	68 45 02 00 00       	push   $0x245
  8045a5:	68 45 58 80 00       	push   $0x805845
  8045aa:	e8 e2 ca ff ff       	call   801091 <_panic>
  8045af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b2:	8b 00                	mov    (%eax),%eax
  8045b4:	85 c0                	test   %eax,%eax
  8045b6:	74 10                	je     8045c8 <realloc_block_FF+0x6ab>
  8045b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045bb:	8b 00                	mov    (%eax),%eax
  8045bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045c0:	8b 52 04             	mov    0x4(%edx),%edx
  8045c3:	89 50 04             	mov    %edx,0x4(%eax)
  8045c6:	eb 0b                	jmp    8045d3 <realloc_block_FF+0x6b6>
  8045c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045cb:	8b 40 04             	mov    0x4(%eax),%eax
  8045ce:	a3 48 60 80 00       	mov    %eax,0x806048
  8045d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d6:	8b 40 04             	mov    0x4(%eax),%eax
  8045d9:	85 c0                	test   %eax,%eax
  8045db:	74 0f                	je     8045ec <realloc_block_FF+0x6cf>
  8045dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e0:	8b 40 04             	mov    0x4(%eax),%eax
  8045e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045e6:	8b 12                	mov    (%edx),%edx
  8045e8:	89 10                	mov    %edx,(%eax)
  8045ea:	eb 0a                	jmp    8045f6 <realloc_block_FF+0x6d9>
  8045ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ef:	8b 00                	mov    (%eax),%eax
  8045f1:	a3 44 60 80 00       	mov    %eax,0x806044
  8045f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804609:	a1 50 60 80 00       	mov    0x806050,%eax
  80460e:	48                   	dec    %eax
  80460f:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804614:	83 ec 04             	sub    $0x4,%esp
  804617:	6a 00                	push   $0x0
  804619:	ff 75 bc             	pushl  -0x44(%ebp)
  80461c:	ff 75 b8             	pushl  -0x48(%ebp)
  80461f:	e8 06 e9 ff ff       	call   802f2a <set_block_data>
  804624:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804627:	8b 45 08             	mov    0x8(%ebp),%eax
  80462a:	eb 0a                	jmp    804636 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80462c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804633:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804636:	c9                   	leave  
  804637:	c3                   	ret    

00804638 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804638:	55                   	push   %ebp
  804639:	89 e5                	mov    %esp,%ebp
  80463b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80463e:	83 ec 04             	sub    $0x4,%esp
  804641:	68 3c 59 80 00       	push   $0x80593c
  804646:	68 58 02 00 00       	push   $0x258
  80464b:	68 45 58 80 00       	push   $0x805845
  804650:	e8 3c ca ff ff       	call   801091 <_panic>

00804655 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804655:	55                   	push   %ebp
  804656:	89 e5                	mov    %esp,%ebp
  804658:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80465b:	83 ec 04             	sub    $0x4,%esp
  80465e:	68 64 59 80 00       	push   $0x805964
  804663:	68 61 02 00 00       	push   $0x261
  804668:	68 45 58 80 00       	push   $0x805845
  80466d:	e8 1f ca ff ff       	call   801091 <_panic>
  804672:	66 90                	xchg   %ax,%ax

00804674 <__udivdi3>:
  804674:	55                   	push   %ebp
  804675:	57                   	push   %edi
  804676:	56                   	push   %esi
  804677:	53                   	push   %ebx
  804678:	83 ec 1c             	sub    $0x1c,%esp
  80467b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80467f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804687:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80468b:	89 ca                	mov    %ecx,%edx
  80468d:	89 f8                	mov    %edi,%eax
  80468f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804693:	85 f6                	test   %esi,%esi
  804695:	75 2d                	jne    8046c4 <__udivdi3+0x50>
  804697:	39 cf                	cmp    %ecx,%edi
  804699:	77 65                	ja     804700 <__udivdi3+0x8c>
  80469b:	89 fd                	mov    %edi,%ebp
  80469d:	85 ff                	test   %edi,%edi
  80469f:	75 0b                	jne    8046ac <__udivdi3+0x38>
  8046a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8046a6:	31 d2                	xor    %edx,%edx
  8046a8:	f7 f7                	div    %edi
  8046aa:	89 c5                	mov    %eax,%ebp
  8046ac:	31 d2                	xor    %edx,%edx
  8046ae:	89 c8                	mov    %ecx,%eax
  8046b0:	f7 f5                	div    %ebp
  8046b2:	89 c1                	mov    %eax,%ecx
  8046b4:	89 d8                	mov    %ebx,%eax
  8046b6:	f7 f5                	div    %ebp
  8046b8:	89 cf                	mov    %ecx,%edi
  8046ba:	89 fa                	mov    %edi,%edx
  8046bc:	83 c4 1c             	add    $0x1c,%esp
  8046bf:	5b                   	pop    %ebx
  8046c0:	5e                   	pop    %esi
  8046c1:	5f                   	pop    %edi
  8046c2:	5d                   	pop    %ebp
  8046c3:	c3                   	ret    
  8046c4:	39 ce                	cmp    %ecx,%esi
  8046c6:	77 28                	ja     8046f0 <__udivdi3+0x7c>
  8046c8:	0f bd fe             	bsr    %esi,%edi
  8046cb:	83 f7 1f             	xor    $0x1f,%edi
  8046ce:	75 40                	jne    804710 <__udivdi3+0x9c>
  8046d0:	39 ce                	cmp    %ecx,%esi
  8046d2:	72 0a                	jb     8046de <__udivdi3+0x6a>
  8046d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8046d8:	0f 87 9e 00 00 00    	ja     80477c <__udivdi3+0x108>
  8046de:	b8 01 00 00 00       	mov    $0x1,%eax
  8046e3:	89 fa                	mov    %edi,%edx
  8046e5:	83 c4 1c             	add    $0x1c,%esp
  8046e8:	5b                   	pop    %ebx
  8046e9:	5e                   	pop    %esi
  8046ea:	5f                   	pop    %edi
  8046eb:	5d                   	pop    %ebp
  8046ec:	c3                   	ret    
  8046ed:	8d 76 00             	lea    0x0(%esi),%esi
  8046f0:	31 ff                	xor    %edi,%edi
  8046f2:	31 c0                	xor    %eax,%eax
  8046f4:	89 fa                	mov    %edi,%edx
  8046f6:	83 c4 1c             	add    $0x1c,%esp
  8046f9:	5b                   	pop    %ebx
  8046fa:	5e                   	pop    %esi
  8046fb:	5f                   	pop    %edi
  8046fc:	5d                   	pop    %ebp
  8046fd:	c3                   	ret    
  8046fe:	66 90                	xchg   %ax,%ax
  804700:	89 d8                	mov    %ebx,%eax
  804702:	f7 f7                	div    %edi
  804704:	31 ff                	xor    %edi,%edi
  804706:	89 fa                	mov    %edi,%edx
  804708:	83 c4 1c             	add    $0x1c,%esp
  80470b:	5b                   	pop    %ebx
  80470c:	5e                   	pop    %esi
  80470d:	5f                   	pop    %edi
  80470e:	5d                   	pop    %ebp
  80470f:	c3                   	ret    
  804710:	bd 20 00 00 00       	mov    $0x20,%ebp
  804715:	89 eb                	mov    %ebp,%ebx
  804717:	29 fb                	sub    %edi,%ebx
  804719:	89 f9                	mov    %edi,%ecx
  80471b:	d3 e6                	shl    %cl,%esi
  80471d:	89 c5                	mov    %eax,%ebp
  80471f:	88 d9                	mov    %bl,%cl
  804721:	d3 ed                	shr    %cl,%ebp
  804723:	89 e9                	mov    %ebp,%ecx
  804725:	09 f1                	or     %esi,%ecx
  804727:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80472b:	89 f9                	mov    %edi,%ecx
  80472d:	d3 e0                	shl    %cl,%eax
  80472f:	89 c5                	mov    %eax,%ebp
  804731:	89 d6                	mov    %edx,%esi
  804733:	88 d9                	mov    %bl,%cl
  804735:	d3 ee                	shr    %cl,%esi
  804737:	89 f9                	mov    %edi,%ecx
  804739:	d3 e2                	shl    %cl,%edx
  80473b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80473f:	88 d9                	mov    %bl,%cl
  804741:	d3 e8                	shr    %cl,%eax
  804743:	09 c2                	or     %eax,%edx
  804745:	89 d0                	mov    %edx,%eax
  804747:	89 f2                	mov    %esi,%edx
  804749:	f7 74 24 0c          	divl   0xc(%esp)
  80474d:	89 d6                	mov    %edx,%esi
  80474f:	89 c3                	mov    %eax,%ebx
  804751:	f7 e5                	mul    %ebp
  804753:	39 d6                	cmp    %edx,%esi
  804755:	72 19                	jb     804770 <__udivdi3+0xfc>
  804757:	74 0b                	je     804764 <__udivdi3+0xf0>
  804759:	89 d8                	mov    %ebx,%eax
  80475b:	31 ff                	xor    %edi,%edi
  80475d:	e9 58 ff ff ff       	jmp    8046ba <__udivdi3+0x46>
  804762:	66 90                	xchg   %ax,%ax
  804764:	8b 54 24 08          	mov    0x8(%esp),%edx
  804768:	89 f9                	mov    %edi,%ecx
  80476a:	d3 e2                	shl    %cl,%edx
  80476c:	39 c2                	cmp    %eax,%edx
  80476e:	73 e9                	jae    804759 <__udivdi3+0xe5>
  804770:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804773:	31 ff                	xor    %edi,%edi
  804775:	e9 40 ff ff ff       	jmp    8046ba <__udivdi3+0x46>
  80477a:	66 90                	xchg   %ax,%ax
  80477c:	31 c0                	xor    %eax,%eax
  80477e:	e9 37 ff ff ff       	jmp    8046ba <__udivdi3+0x46>
  804783:	90                   	nop

00804784 <__umoddi3>:
  804784:	55                   	push   %ebp
  804785:	57                   	push   %edi
  804786:	56                   	push   %esi
  804787:	53                   	push   %ebx
  804788:	83 ec 1c             	sub    $0x1c,%esp
  80478b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80478f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804793:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804797:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80479b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80479f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047a3:	89 f3                	mov    %esi,%ebx
  8047a5:	89 fa                	mov    %edi,%edx
  8047a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047ab:	89 34 24             	mov    %esi,(%esp)
  8047ae:	85 c0                	test   %eax,%eax
  8047b0:	75 1a                	jne    8047cc <__umoddi3+0x48>
  8047b2:	39 f7                	cmp    %esi,%edi
  8047b4:	0f 86 a2 00 00 00    	jbe    80485c <__umoddi3+0xd8>
  8047ba:	89 c8                	mov    %ecx,%eax
  8047bc:	89 f2                	mov    %esi,%edx
  8047be:	f7 f7                	div    %edi
  8047c0:	89 d0                	mov    %edx,%eax
  8047c2:	31 d2                	xor    %edx,%edx
  8047c4:	83 c4 1c             	add    $0x1c,%esp
  8047c7:	5b                   	pop    %ebx
  8047c8:	5e                   	pop    %esi
  8047c9:	5f                   	pop    %edi
  8047ca:	5d                   	pop    %ebp
  8047cb:	c3                   	ret    
  8047cc:	39 f0                	cmp    %esi,%eax
  8047ce:	0f 87 ac 00 00 00    	ja     804880 <__umoddi3+0xfc>
  8047d4:	0f bd e8             	bsr    %eax,%ebp
  8047d7:	83 f5 1f             	xor    $0x1f,%ebp
  8047da:	0f 84 ac 00 00 00    	je     80488c <__umoddi3+0x108>
  8047e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8047e5:	29 ef                	sub    %ebp,%edi
  8047e7:	89 fe                	mov    %edi,%esi
  8047e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047ed:	89 e9                	mov    %ebp,%ecx
  8047ef:	d3 e0                	shl    %cl,%eax
  8047f1:	89 d7                	mov    %edx,%edi
  8047f3:	89 f1                	mov    %esi,%ecx
  8047f5:	d3 ef                	shr    %cl,%edi
  8047f7:	09 c7                	or     %eax,%edi
  8047f9:	89 e9                	mov    %ebp,%ecx
  8047fb:	d3 e2                	shl    %cl,%edx
  8047fd:	89 14 24             	mov    %edx,(%esp)
  804800:	89 d8                	mov    %ebx,%eax
  804802:	d3 e0                	shl    %cl,%eax
  804804:	89 c2                	mov    %eax,%edx
  804806:	8b 44 24 08          	mov    0x8(%esp),%eax
  80480a:	d3 e0                	shl    %cl,%eax
  80480c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804810:	8b 44 24 08          	mov    0x8(%esp),%eax
  804814:	89 f1                	mov    %esi,%ecx
  804816:	d3 e8                	shr    %cl,%eax
  804818:	09 d0                	or     %edx,%eax
  80481a:	d3 eb                	shr    %cl,%ebx
  80481c:	89 da                	mov    %ebx,%edx
  80481e:	f7 f7                	div    %edi
  804820:	89 d3                	mov    %edx,%ebx
  804822:	f7 24 24             	mull   (%esp)
  804825:	89 c6                	mov    %eax,%esi
  804827:	89 d1                	mov    %edx,%ecx
  804829:	39 d3                	cmp    %edx,%ebx
  80482b:	0f 82 87 00 00 00    	jb     8048b8 <__umoddi3+0x134>
  804831:	0f 84 91 00 00 00    	je     8048c8 <__umoddi3+0x144>
  804837:	8b 54 24 04          	mov    0x4(%esp),%edx
  80483b:	29 f2                	sub    %esi,%edx
  80483d:	19 cb                	sbb    %ecx,%ebx
  80483f:	89 d8                	mov    %ebx,%eax
  804841:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804845:	d3 e0                	shl    %cl,%eax
  804847:	89 e9                	mov    %ebp,%ecx
  804849:	d3 ea                	shr    %cl,%edx
  80484b:	09 d0                	or     %edx,%eax
  80484d:	89 e9                	mov    %ebp,%ecx
  80484f:	d3 eb                	shr    %cl,%ebx
  804851:	89 da                	mov    %ebx,%edx
  804853:	83 c4 1c             	add    $0x1c,%esp
  804856:	5b                   	pop    %ebx
  804857:	5e                   	pop    %esi
  804858:	5f                   	pop    %edi
  804859:	5d                   	pop    %ebp
  80485a:	c3                   	ret    
  80485b:	90                   	nop
  80485c:	89 fd                	mov    %edi,%ebp
  80485e:	85 ff                	test   %edi,%edi
  804860:	75 0b                	jne    80486d <__umoddi3+0xe9>
  804862:	b8 01 00 00 00       	mov    $0x1,%eax
  804867:	31 d2                	xor    %edx,%edx
  804869:	f7 f7                	div    %edi
  80486b:	89 c5                	mov    %eax,%ebp
  80486d:	89 f0                	mov    %esi,%eax
  80486f:	31 d2                	xor    %edx,%edx
  804871:	f7 f5                	div    %ebp
  804873:	89 c8                	mov    %ecx,%eax
  804875:	f7 f5                	div    %ebp
  804877:	89 d0                	mov    %edx,%eax
  804879:	e9 44 ff ff ff       	jmp    8047c2 <__umoddi3+0x3e>
  80487e:	66 90                	xchg   %ax,%ax
  804880:	89 c8                	mov    %ecx,%eax
  804882:	89 f2                	mov    %esi,%edx
  804884:	83 c4 1c             	add    $0x1c,%esp
  804887:	5b                   	pop    %ebx
  804888:	5e                   	pop    %esi
  804889:	5f                   	pop    %edi
  80488a:	5d                   	pop    %ebp
  80488b:	c3                   	ret    
  80488c:	3b 04 24             	cmp    (%esp),%eax
  80488f:	72 06                	jb     804897 <__umoddi3+0x113>
  804891:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804895:	77 0f                	ja     8048a6 <__umoddi3+0x122>
  804897:	89 f2                	mov    %esi,%edx
  804899:	29 f9                	sub    %edi,%ecx
  80489b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80489f:	89 14 24             	mov    %edx,(%esp)
  8048a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048aa:	8b 14 24             	mov    (%esp),%edx
  8048ad:	83 c4 1c             	add    $0x1c,%esp
  8048b0:	5b                   	pop    %ebx
  8048b1:	5e                   	pop    %esi
  8048b2:	5f                   	pop    %edi
  8048b3:	5d                   	pop    %ebp
  8048b4:	c3                   	ret    
  8048b5:	8d 76 00             	lea    0x0(%esi),%esi
  8048b8:	2b 04 24             	sub    (%esp),%eax
  8048bb:	19 fa                	sbb    %edi,%edx
  8048bd:	89 d1                	mov    %edx,%ecx
  8048bf:	89 c6                	mov    %eax,%esi
  8048c1:	e9 71 ff ff ff       	jmp    804837 <__umoddi3+0xb3>
  8048c6:	66 90                	xchg   %ax,%ax
  8048c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8048cc:	72 ea                	jb     8048b8 <__umoddi3+0x134>
  8048ce:	89 d9                	mov    %ebx,%ecx
  8048d0:	e9 62 ff ff ff       	jmp    804837 <__umoddi3+0xb3>
