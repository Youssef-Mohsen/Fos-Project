
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
  800055:	68 80 48 80 00       	push   $0x804880
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
  8000a5:	68 b0 48 80 00       	push   $0x8048b0
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
  8000d1:	e8 a0 29 00 00       	call   802a76 <sys_set_uheap_strategy>
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
  8000f6:	68 e9 48 80 00       	push   $0x8048e9
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 05 49 80 00       	push   $0x804905
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
  800123:	e8 9b 25 00 00       	call   8026c3 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 48 25 00 00       	call   802678 <sys_calculate_free_frames>
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
  80013d:	68 18 49 80 00       	push   $0x804918
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
  8002ac:	68 70 49 80 00       	push   $0x804970
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 05 49 80 00       	push   $0x804905
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
  80031b:	68 98 49 80 00       	push   $0x804998
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 7f 28 00 00       	call   802bb8 <alloc_block>
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
  80037f:	68 bc 49 80 00       	push   $0x8049bc
  800384:	6a 7f                	push   $0x7f
  800386:	68 05 49 80 00       	push   $0x804905
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 e3 22 00 00       	call   802678 <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 e4 49 80 00       	push   $0x8049e4
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
  800443:	68 2c 4a 80 00       	push   $0x804a2c
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
  80049a:	68 4c 4a 80 00       	push   $0x804a4c
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
  8004ee:	68 6c 4a 80 00       	push   $0x804a6c
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
  800538:	68 9c 4a 80 00       	push   $0x804a9c
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
  800552:	68 bc 4a 80 00       	push   $0x804abc
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 f7 4a 80 00       	push   $0x804af7
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
  8005e0:	68 0c 4b 80 00       	push   $0x804b0c
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 2b 4b 80 00       	push   $0x804b2b
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
  800669:	68 44 4b 80 00       	push   $0x804b44
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
  800683:	68 64 4b 80 00       	push   $0x804b64
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 9b 4b 80 00       	push   $0x804b9b
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
  800711:	68 b0 4b 80 00       	push   $0x804bb0
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 cf 4b 80 00       	push   $0x804bcf
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
  800762:	e8 1a 24 00 00       	call   802b81 <get_block_size>
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
  8007b7:	68 e8 4b 80 00       	push   $0x804be8
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
  8007d1:	68 08 4c 80 00       	push   $0x804c08
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
  80083d:	e8 3f 23 00 00       	call   802b81 <get_block_size>
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
  80089b:	68 45 4c 80 00       	push   $0x804c45
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
  8008b5:	68 64 4c 80 00       	push   $0x804c64
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 a4 4c 80 00       	push   $0x804ca4
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 c9 4c 80 00       	push   $0x804cc9
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
  800963:	68 e0 4c 80 00       	push   $0x804ce0
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 10 4d 80 00       	push   $0x804d10
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
  8009fa:	68 3c 4d 80 00       	push   $0x804d3c
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 6c 4d 80 00       	push   $0x804d6c
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
  800a68:	68 ac 4d 80 00       	push   $0x804dac
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
  800a82:	68 dc 4d 80 00       	push   $0x804ddc
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
  800b11:	68 08 4e 80 00       	push   $0x804e08
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
  800b2b:	68 38 4e 80 00       	push   $0x804e38
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 60 4e 80 00       	push   $0x804e60
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
  800bca:	68 80 4e 80 00       	push   $0x804e80
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
  800c3d:	68 b0 4e 80 00       	push   $0x804eb0
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
  800ca4:	e8 9e 1f 00 00       	call   802c47 <print_blocks_list>
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
  800ce6:	68 c8 4e 80 00       	push   $0x804ec8
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 f8 4e 80 00       	push   $0x804ef8
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
  800d83:	68 30 4f 80 00       	push   $0x804f30
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
  800d9d:	68 60 4f 80 00       	push   $0x804f60
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 c2 18 00 00       	call   802678 <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 a4 4f 80 00       	push   $0x804fa4
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
  800e7a:	68 10 50 80 00       	push   $0x805010
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
  800efe:	e8 d0 1b 00 00       	call   802ad3 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 4c 50 80 00       	push   $0x80504c
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
  800f3c:	68 90 50 80 00       	push   $0x805090
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
  800f58:	e8 e4 18 00 00       	call   802841 <sys_getenvindex>
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
  800fc6:	e8 fa 15 00 00       	call   8025c5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 f8 50 80 00       	push   $0x8050f8
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
  800ff6:	68 20 51 80 00       	push   $0x805120
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
  801027:	68 48 51 80 00       	push   $0x805148
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 a0 51 80 00       	push   $0x8051a0
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 f8 50 80 00       	push   $0x8050f8
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 7a 15 00 00       	call   8025df <sys_unlock_cons>
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
  801078:	e8 90 17 00 00       	call   80280d <sys_destroy_env>
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
  801089:	e8 e5 17 00 00       	call   802873 <sys_exit_env>
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
  8010b2:	68 b4 51 80 00       	push   $0x8051b4
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 b9 51 80 00       	push   $0x8051b9
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
  8010ef:	68 d5 51 80 00       	push   $0x8051d5
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
  80111e:	68 d8 51 80 00       	push   $0x8051d8
  801123:	6a 26                	push   $0x26
  801125:	68 24 52 80 00       	push   $0x805224
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
  8011f3:	68 30 52 80 00       	push   $0x805230
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 24 52 80 00       	push   $0x805224
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
  801266:	68 84 52 80 00       	push   $0x805284
  80126b:	6a 44                	push   $0x44
  80126d:	68 24 52 80 00       	push   $0x805224
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
  8012c0:	e8 be 12 00 00       	call   802583 <sys_cputs>
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
  801337:	e8 47 12 00 00       	call   802583 <sys_cputs>
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
  801381:	e8 3f 12 00 00       	call   8025c5 <sys_lock_cons>
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
  8013a1:	e8 39 12 00 00       	call   8025df <sys_unlock_cons>
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
  8013eb:	e8 2c 32 00 00       	call   80461c <__udivdi3>
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
  80143b:	e8 ec 32 00 00       	call   80472c <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 f4 54 80 00       	add    $0x8054f4,%eax
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
  801596:	8b 04 85 18 55 80 00 	mov    0x805518(,%eax,4),%eax
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
  801677:	8b 34 9d 60 53 80 00 	mov    0x805360(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 05 55 80 00       	push   $0x805505
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
  80169c:	68 0e 55 80 00       	push   $0x80550e
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
  8016c9:	be 11 55 80 00       	mov    $0x805511,%esi
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
  8020d4:	68 88 56 80 00       	push   $0x805688
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 aa 56 80 00       	push   $0x8056aa
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
  8020f4:	e8 35 0a 00 00       	call   802b2e <sys_sbrk>
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
  80216f:	e8 3e 08 00 00       	call   8029b2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 7e 0d 00 00       	call   802f01 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 50 08 00 00       	call   8029e3 <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 17 12 00 00       	call   8033bd <alloc_block_BF>
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
  802307:	e8 59 08 00 00       	call   802b65 <sys_allocate_user_mem>
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
  80234f:	e8 2d 08 00 00       	call   802b81 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 60 1a 00 00       	call   803dc5 <free_block>
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
  8023f7:	e8 4d 07 00 00       	call   802b49 <sys_free_user_mem>
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
  802405:	68 b8 56 80 00       	push   $0x8056b8
  80240a:	68 84 00 00 00       	push   $0x84
  80240f:	68 e2 56 80 00       	push   $0x8056e2
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
  802477:	e8 d4 02 00 00       	call   802750 <sys_createSharedObject>
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
  802498:	68 ee 56 80 00       	push   $0x8056ee
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
  8024ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 f4 56 80 00       	push   $0x8056f4
  8024b8:	68 a4 00 00 00       	push   $0xa4
  8024bd:	68 e2 56 80 00       	push   $0x8056e2
  8024c2:	e8 ca eb ff ff       	call   801091 <_panic>

008024c7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8024cd:	83 ec 04             	sub    $0x4,%esp
  8024d0:	68 18 57 80 00       	push   $0x805718
  8024d5:	68 bc 00 00 00       	push   $0xbc
  8024da:	68 e2 56 80 00       	push   $0x8056e2
  8024df:	e8 ad eb ff ff       	call   801091 <_panic>

008024e4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 3c 57 80 00       	push   $0x80573c
  8024f2:	68 d3 00 00 00       	push   $0xd3
  8024f7:	68 e2 56 80 00       	push   $0x8056e2
  8024fc:	e8 90 eb ff ff       	call   801091 <_panic>

00802501 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	68 62 57 80 00       	push   $0x805762
  80250f:	68 df 00 00 00       	push   $0xdf
  802514:	68 e2 56 80 00       	push   $0x8056e2
  802519:	e8 73 eb ff ff       	call   801091 <_panic>

0080251e <shrink>:

}
void shrink(uint32 newSize)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 62 57 80 00       	push   $0x805762
  80252c:	68 e4 00 00 00       	push   $0xe4
  802531:	68 e2 56 80 00       	push   $0x8056e2
  802536:	e8 56 eb ff ff       	call   801091 <_panic>

0080253b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	68 62 57 80 00       	push   $0x805762
  802549:	68 e9 00 00 00       	push   $0xe9
  80254e:	68 e2 56 80 00       	push   $0x8056e2
  802553:	e8 39 eb ff ff       	call   801091 <_panic>

00802558 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	57                   	push   %edi
  80255c:	56                   	push   %esi
  80255d:	53                   	push   %ebx
  80255e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	8b 55 0c             	mov    0xc(%ebp),%edx
  802567:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80256a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80256d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802570:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802573:	cd 30                	int    $0x30
  802575:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802578:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    

00802583 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	8b 45 10             	mov    0x10(%ebp),%eax
  80258c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80258f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	52                   	push   %edx
  80259b:	ff 75 0c             	pushl  0xc(%ebp)
  80259e:	50                   	push   %eax
  80259f:	6a 00                	push   $0x0
  8025a1:	e8 b2 ff ff ff       	call   802558 <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	90                   	nop
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 02                	push   $0x2
  8025bb:	e8 98 ff ff ff       	call   802558 <syscall>
  8025c0:	83 c4 18             	add    $0x18,%esp
}
  8025c3:	c9                   	leave  
  8025c4:	c3                   	ret    

008025c5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 03                	push   $0x3
  8025d4:	e8 7f ff ff ff       	call   802558 <syscall>
  8025d9:	83 c4 18             	add    $0x18,%esp
}
  8025dc:	90                   	nop
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 04                	push   $0x4
  8025ee:	e8 65 ff ff ff       	call   802558 <syscall>
  8025f3:	83 c4 18             	add    $0x18,%esp
}
  8025f6:	90                   	nop
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	52                   	push   %edx
  802609:	50                   	push   %eax
  80260a:	6a 08                	push   $0x8
  80260c:	e8 47 ff ff ff       	call   802558 <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	56                   	push   %esi
  80261a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80261b:	8b 75 18             	mov    0x18(%ebp),%esi
  80261e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802624:	8b 55 0c             	mov    0xc(%ebp),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	56                   	push   %esi
  80262b:	53                   	push   %ebx
  80262c:	51                   	push   %ecx
  80262d:	52                   	push   %edx
  80262e:	50                   	push   %eax
  80262f:	6a 09                	push   $0x9
  802631:	e8 22 ff ff ff       	call   802558 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    

00802640 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802643:	8b 55 0c             	mov    0xc(%ebp),%edx
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	52                   	push   %edx
  802650:	50                   	push   %eax
  802651:	6a 0a                	push   $0xa
  802653:	e8 00 ff ff ff       	call   802558 <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	ff 75 0c             	pushl  0xc(%ebp)
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	6a 0b                	push   $0xb
  80266e:	e8 e5 fe ff ff       	call   802558 <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 0c                	push   $0xc
  802687:	e8 cc fe ff ff       	call   802558 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 0d                	push   $0xd
  8026a0:	e8 b3 fe ff ff       	call   802558 <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 0e                	push   $0xe
  8026b9:	e8 9a fe ff ff       	call   802558 <syscall>
  8026be:	83 c4 18             	add    $0x18,%esp
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 0f                	push   $0xf
  8026d2:	e8 81 fe ff ff       	call   802558 <syscall>
  8026d7:	83 c4 18             	add    $0x18,%esp
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	6a 10                	push   $0x10
  8026ec:	e8 67 fe ff ff       	call   802558 <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 11                	push   $0x11
  802705:	e8 4e fe ff ff       	call   802558 <syscall>
  80270a:	83 c4 18             	add    $0x18,%esp
}
  80270d:	90                   	nop
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_cputc>:

void
sys_cputc(const char c)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80271c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	50                   	push   %eax
  802729:	6a 01                	push   $0x1
  80272b:	e8 28 fe ff ff       	call   802558 <syscall>
  802730:	83 c4 18             	add    $0x18,%esp
}
  802733:	90                   	nop
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 14                	push   $0x14
  802745:	e8 0e fe ff ff       	call   802558 <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
}
  80274d:	90                   	nop
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	8b 45 10             	mov    0x10(%ebp),%eax
  802759:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80275c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80275f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	6a 00                	push   $0x0
  802768:	51                   	push   %ecx
  802769:	52                   	push   %edx
  80276a:	ff 75 0c             	pushl  0xc(%ebp)
  80276d:	50                   	push   %eax
  80276e:	6a 15                	push   $0x15
  802770:	e8 e3 fd ff ff       	call   802558 <syscall>
  802775:	83 c4 18             	add    $0x18,%esp
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80277d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	52                   	push   %edx
  80278a:	50                   	push   %eax
  80278b:	6a 16                	push   $0x16
  80278d:	e8 c6 fd ff ff       	call   802558 <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80279a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80279d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	51                   	push   %ecx
  8027a8:	52                   	push   %edx
  8027a9:	50                   	push   %eax
  8027aa:	6a 17                	push   $0x17
  8027ac:	e8 a7 fd ff ff       	call   802558 <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	52                   	push   %edx
  8027c6:	50                   	push   %eax
  8027c7:	6a 18                	push   $0x18
  8027c9:	e8 8a fd ff ff       	call   802558 <syscall>
  8027ce:	83 c4 18             	add    $0x18,%esp
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	6a 00                	push   $0x0
  8027db:	ff 75 14             	pushl  0x14(%ebp)
  8027de:	ff 75 10             	pushl  0x10(%ebp)
  8027e1:	ff 75 0c             	pushl  0xc(%ebp)
  8027e4:	50                   	push   %eax
  8027e5:	6a 19                	push   $0x19
  8027e7:	e8 6c fd ff ff       	call   802558 <syscall>
  8027ec:	83 c4 18             	add    $0x18,%esp
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	50                   	push   %eax
  802800:	6a 1a                	push   $0x1a
  802802:	e8 51 fd ff ff       	call   802558 <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	90                   	nop
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	50                   	push   %eax
  80281c:	6a 1b                	push   $0x1b
  80281e:	e8 35 fd ff ff       	call   802558 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 05                	push   $0x5
  802837:	e8 1c fd ff ff       	call   802558 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 06                	push   $0x6
  802850:	e8 03 fd ff ff       	call   802558 <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 07                	push   $0x7
  802869:	e8 ea fc ff ff       	call   802558 <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <sys_exit_env>:


void sys_exit_env(void)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 1c                	push   $0x1c
  802882:	e8 d1 fc ff ff       	call   802558 <syscall>
  802887:	83 c4 18             	add    $0x18,%esp
}
  80288a:	90                   	nop
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802893:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802896:	8d 50 04             	lea    0x4(%eax),%edx
  802899:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	52                   	push   %edx
  8028a3:	50                   	push   %eax
  8028a4:	6a 1d                	push   $0x1d
  8028a6:	e8 ad fc ff ff       	call   802558 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8028ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028b7:	89 01                	mov    %eax,(%ecx)
  8028b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	c9                   	leave  
  8028c0:	c2 04 00             	ret    $0x4

008028c3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	ff 75 10             	pushl  0x10(%ebp)
  8028cd:	ff 75 0c             	pushl  0xc(%ebp)
  8028d0:	ff 75 08             	pushl  0x8(%ebp)
  8028d3:	6a 13                	push   $0x13
  8028d5:	e8 7e fc ff ff       	call   802558 <syscall>
  8028da:	83 c4 18             	add    $0x18,%esp
	return ;
  8028dd:	90                   	nop
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 1e                	push   $0x1e
  8028ef:	e8 64 fc ff ff       	call   802558 <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802905:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	50                   	push   %eax
  802912:	6a 1f                	push   $0x1f
  802914:	e8 3f fc ff ff       	call   802558 <syscall>
  802919:	83 c4 18             	add    $0x18,%esp
	return ;
  80291c:	90                   	nop
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <rsttst>:
void rsttst()
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 21                	push   $0x21
  80292e:	e8 25 fc ff ff       	call   802558 <syscall>
  802933:	83 c4 18             	add    $0x18,%esp
	return ;
  802936:	90                   	nop
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	8b 45 14             	mov    0x14(%ebp),%eax
  802942:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802945:	8b 55 18             	mov    0x18(%ebp),%edx
  802948:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80294c:	52                   	push   %edx
  80294d:	50                   	push   %eax
  80294e:	ff 75 10             	pushl  0x10(%ebp)
  802951:	ff 75 0c             	pushl  0xc(%ebp)
  802954:	ff 75 08             	pushl  0x8(%ebp)
  802957:	6a 20                	push   $0x20
  802959:	e8 fa fb ff ff       	call   802558 <syscall>
  80295e:	83 c4 18             	add    $0x18,%esp
	return ;
  802961:	90                   	nop
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <chktst>:
void chktst(uint32 n)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	ff 75 08             	pushl  0x8(%ebp)
  802972:	6a 22                	push   $0x22
  802974:	e8 df fb ff ff       	call   802558 <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
	return ;
  80297c:	90                   	nop
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <inctst>:

void inctst()
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	6a 00                	push   $0x0
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 23                	push   $0x23
  80298e:	e8 c5 fb ff ff       	call   802558 <syscall>
  802993:	83 c4 18             	add    $0x18,%esp
	return ;
  802996:	90                   	nop
}
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <gettst>:
uint32 gettst()
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 24                	push   $0x24
  8029a8:	e8 ab fb ff ff       	call   802558 <syscall>
  8029ad:	83 c4 18             	add    $0x18,%esp
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 25                	push   $0x25
  8029c4:	e8 8f fb ff ff       	call   802558 <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
  8029cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8029cf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8029d3:	75 07                	jne    8029dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8029d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029da:	eb 05                	jmp    8029e1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e1:	c9                   	leave  
  8029e2:	c3                   	ret    

008029e3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
  8029e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 25                	push   $0x25
  8029f5:	e8 5e fb ff ff       	call   802558 <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
  8029fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a00:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a04:	75 07                	jne    802a0d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a06:	b8 01 00 00 00       	mov    $0x1,%eax
  802a0b:	eb 05                	jmp    802a12 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 25                	push   $0x25
  802a26:	e8 2d fb ff ff       	call   802558 <syscall>
  802a2b:	83 c4 18             	add    $0x18,%esp
  802a2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a31:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a35:	75 07                	jne    802a3e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a37:	b8 01 00 00 00       	mov    $0x1,%eax
  802a3c:	eb 05                	jmp    802a43 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 25                	push   $0x25
  802a57:	e8 fc fa ff ff       	call   802558 <syscall>
  802a5c:	83 c4 18             	add    $0x18,%esp
  802a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a62:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a66:	75 07                	jne    802a6f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a68:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6d:	eb 05                	jmp    802a74 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a74:	c9                   	leave  
  802a75:	c3                   	ret    

00802a76 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	ff 75 08             	pushl  0x8(%ebp)
  802a84:	6a 26                	push   $0x26
  802a86:	e8 cd fa ff ff       	call   802558 <syscall>
  802a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a8e:	90                   	nop
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	6a 00                	push   $0x0
  802aa3:	53                   	push   %ebx
  802aa4:	51                   	push   %ecx
  802aa5:	52                   	push   %edx
  802aa6:	50                   	push   %eax
  802aa7:	6a 27                	push   $0x27
  802aa9:	e8 aa fa ff ff       	call   802558 <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
}
  802ab1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 00                	push   $0x0
  802ac5:	52                   	push   %edx
  802ac6:	50                   	push   %eax
  802ac7:	6a 28                	push   $0x28
  802ac9:	e8 8a fa ff ff       	call   802558 <syscall>
  802ace:	83 c4 18             	add    $0x18,%esp
}
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ad6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	6a 00                	push   $0x0
  802ae1:	51                   	push   %ecx
  802ae2:	ff 75 10             	pushl  0x10(%ebp)
  802ae5:	52                   	push   %edx
  802ae6:	50                   	push   %eax
  802ae7:	6a 29                	push   $0x29
  802ae9:	e8 6a fa ff ff       	call   802558 <syscall>
  802aee:	83 c4 18             	add    $0x18,%esp
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	ff 75 10             	pushl  0x10(%ebp)
  802afd:	ff 75 0c             	pushl  0xc(%ebp)
  802b00:	ff 75 08             	pushl  0x8(%ebp)
  802b03:	6a 12                	push   $0x12
  802b05:	e8 4e fa ff ff       	call   802558 <syscall>
  802b0a:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0d:	90                   	nop
}
  802b0e:	c9                   	leave  
  802b0f:	c3                   	ret    

00802b10 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	52                   	push   %edx
  802b20:	50                   	push   %eax
  802b21:	6a 2a                	push   $0x2a
  802b23:	e8 30 fa ff ff       	call   802558 <syscall>
  802b28:	83 c4 18             	add    $0x18,%esp
	return;
  802b2b:	90                   	nop
}
  802b2c:	c9                   	leave  
  802b2d:	c3                   	ret    

00802b2e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802b2e:	55                   	push   %ebp
  802b2f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	50                   	push   %eax
  802b3d:	6a 2b                	push   $0x2b
  802b3f:	e8 14 fa ff ff       	call   802558 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	ff 75 0c             	pushl  0xc(%ebp)
  802b55:	ff 75 08             	pushl  0x8(%ebp)
  802b58:	6a 2c                	push   $0x2c
  802b5a:	e8 f9 f9 ff ff       	call   802558 <syscall>
  802b5f:	83 c4 18             	add    $0x18,%esp
	return;
  802b62:	90                   	nop
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    

00802b65 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	ff 75 0c             	pushl  0xc(%ebp)
  802b71:	ff 75 08             	pushl  0x8(%ebp)
  802b74:	6a 2d                	push   $0x2d
  802b76:	e8 dd f9 ff ff       	call   802558 <syscall>
  802b7b:	83 c4 18             	add    $0x18,%esp
	return;
  802b7e:	90                   	nop
}
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	83 e8 04             	sub    $0x4,%eax
  802b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802b98:	c9                   	leave  
  802b99:	c3                   	ret    

00802b9a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
  802b9d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	83 e8 04             	sub    $0x4,%eax
  802ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	83 e0 01             	and    $0x1,%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	0f 94 c0             	sete   %al
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
  802bbb:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc8:	83 f8 02             	cmp    $0x2,%eax
  802bcb:	74 2b                	je     802bf8 <alloc_block+0x40>
  802bcd:	83 f8 02             	cmp    $0x2,%eax
  802bd0:	7f 07                	jg     802bd9 <alloc_block+0x21>
  802bd2:	83 f8 01             	cmp    $0x1,%eax
  802bd5:	74 0e                	je     802be5 <alloc_block+0x2d>
  802bd7:	eb 58                	jmp    802c31 <alloc_block+0x79>
  802bd9:	83 f8 03             	cmp    $0x3,%eax
  802bdc:	74 2d                	je     802c0b <alloc_block+0x53>
  802bde:	83 f8 04             	cmp    $0x4,%eax
  802be1:	74 3b                	je     802c1e <alloc_block+0x66>
  802be3:	eb 4c                	jmp    802c31 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802be5:	83 ec 0c             	sub    $0xc,%esp
  802be8:	ff 75 08             	pushl  0x8(%ebp)
  802beb:	e8 11 03 00 00       	call   802f01 <alloc_block_FF>
  802bf0:	83 c4 10             	add    $0x10,%esp
  802bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802bf6:	eb 4a                	jmp    802c42 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	ff 75 08             	pushl  0x8(%ebp)
  802bfe:	e8 fa 19 00 00       	call   8045fd <alloc_block_NF>
  802c03:	83 c4 10             	add    $0x10,%esp
  802c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c09:	eb 37                	jmp    802c42 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802c0b:	83 ec 0c             	sub    $0xc,%esp
  802c0e:	ff 75 08             	pushl  0x8(%ebp)
  802c11:	e8 a7 07 00 00       	call   8033bd <alloc_block_BF>
  802c16:	83 c4 10             	add    $0x10,%esp
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c1c:	eb 24                	jmp    802c42 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802c1e:	83 ec 0c             	sub    $0xc,%esp
  802c21:	ff 75 08             	pushl  0x8(%ebp)
  802c24:	e8 b7 19 00 00       	call   8045e0 <alloc_block_WF>
  802c29:	83 c4 10             	add    $0x10,%esp
  802c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c2f:	eb 11                	jmp    802c42 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802c31:	83 ec 0c             	sub    $0xc,%esp
  802c34:	68 74 57 80 00       	push   $0x805774
  802c39:	e8 10 e7 ff ff       	call   80134e <cprintf>
  802c3e:	83 c4 10             	add    $0x10,%esp
		break;
  802c41:	90                   	nop
	}
	return va;
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802c45:	c9                   	leave  
  802c46:	c3                   	ret    

00802c47 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802c47:	55                   	push   %ebp
  802c48:	89 e5                	mov    %esp,%ebp
  802c4a:	53                   	push   %ebx
  802c4b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802c4e:	83 ec 0c             	sub    $0xc,%esp
  802c51:	68 94 57 80 00       	push   $0x805794
  802c56:	e8 f3 e6 ff ff       	call   80134e <cprintf>
  802c5b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802c5e:	83 ec 0c             	sub    $0xc,%esp
  802c61:	68 bf 57 80 00       	push   $0x8057bf
  802c66:	e8 e3 e6 ff ff       	call   80134e <cprintf>
  802c6b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c74:	eb 37                	jmp    802cad <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	ff 75 f4             	pushl  -0xc(%ebp)
  802c7c:	e8 19 ff ff ff       	call   802b9a <is_free_block>
  802c81:	83 c4 10             	add    $0x10,%esp
  802c84:	0f be d8             	movsbl %al,%ebx
  802c87:	83 ec 0c             	sub    $0xc,%esp
  802c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  802c8d:	e8 ef fe ff ff       	call   802b81 <get_block_size>
  802c92:	83 c4 10             	add    $0x10,%esp
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	53                   	push   %ebx
  802c99:	50                   	push   %eax
  802c9a:	68 d7 57 80 00       	push   $0x8057d7
  802c9f:	e8 aa e6 ff ff       	call   80134e <cprintf>
  802ca4:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  802caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb1:	74 07                	je     802cba <print_blocks_list+0x73>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	eb 05                	jmp    802cbf <print_blocks_list+0x78>
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbf:	89 45 10             	mov    %eax,0x10(%ebp)
  802cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 ad                	jne    802c76 <print_blocks_list+0x2f>
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	75 a7                	jne    802c76 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802ccf:	83 ec 0c             	sub    $0xc,%esp
  802cd2:	68 94 57 80 00       	push   $0x805794
  802cd7:	e8 72 e6 ff ff       	call   80134e <cprintf>
  802cdc:	83 c4 10             	add    $0x10,%esp

}
  802cdf:	90                   	nop
  802ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ce3:	c9                   	leave  
  802ce4:	c3                   	ret    

00802ce5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cee:	83 e0 01             	and    $0x1,%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 03                	je     802cf8 <initialize_dynamic_allocator+0x13>
  802cf5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cfc:	0f 84 c7 01 00 00    	je     802ec9 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802d02:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802d09:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d12:	01 d0                	add    %edx,%eax
  802d14:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802d19:	0f 87 ad 01 00 00    	ja     802ecc <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	0f 89 a5 01 00 00    	jns    802ecf <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	83 e8 04             	sub    $0x4,%eax
  802d35:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802d41:	a1 44 60 80 00       	mov    0x806044,%eax
  802d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d49:	e9 87 00 00 00       	jmp    802dd5 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d52:	75 14                	jne    802d68 <initialize_dynamic_allocator+0x83>
  802d54:	83 ec 04             	sub    $0x4,%esp
  802d57:	68 ef 57 80 00       	push   $0x8057ef
  802d5c:	6a 79                	push   $0x79
  802d5e:	68 0d 58 80 00       	push   $0x80580d
  802d63:	e8 29 e3 ff ff       	call   801091 <_panic>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 10                	je     802d81 <initialize_dynamic_allocator+0x9c>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 52 04             	mov    0x4(%edx),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 0b                	jmp    802d8c <initialize_dynamic_allocator+0xa7>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	a3 48 60 80 00       	mov    %eax,0x806048
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 0f                	je     802da5 <initialize_dynamic_allocator+0xc0>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9f:	8b 12                	mov    (%edx),%edx
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	eb 0a                	jmp    802daf <initialize_dynamic_allocator+0xca>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	a3 44 60 80 00       	mov    %eax,0x806044
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc2:	a1 50 60 80 00       	mov    0x806050,%eax
  802dc7:	48                   	dec    %eax
  802dc8:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802dcd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd9:	74 07                	je     802de2 <initialize_dynamic_allocator+0xfd>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	eb 05                	jmp    802de7 <initialize_dynamic_allocator+0x102>
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802dec:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	0f 85 55 ff ff ff    	jne    802d4e <initialize_dynamic_allocator+0x69>
  802df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfd:	0f 85 4b ff ff ff    	jne    802d4e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802e12:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802e17:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802e1c:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802e21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	83 c0 08             	add    $0x8,%eax
  802e2d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	83 c0 04             	add    $0x4,%eax
  802e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e39:	83 ea 08             	sub    $0x8,%edx
  802e3c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	01 d0                	add    %edx,%eax
  802e46:	83 e8 08             	sub    $0x8,%eax
  802e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e4c:	83 ea 08             	sub    $0x8,%edx
  802e4f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802e64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e68:	75 17                	jne    802e81 <initialize_dynamic_allocator+0x19c>
  802e6a:	83 ec 04             	sub    $0x4,%esp
  802e6d:	68 28 58 80 00       	push   $0x805828
  802e72:	68 90 00 00 00       	push   $0x90
  802e77:	68 0d 58 80 00       	push   $0x80580d
  802e7c:	e8 10 e2 ff ff       	call   801091 <_panic>
  802e81:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0d                	je     802ea2 <initialize_dynamic_allocator+0x1bd>
  802e95:	a1 44 60 80 00       	mov    0x806044,%eax
  802e9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 08                	jmp    802eaa <initialize_dynamic_allocator+0x1c5>
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	a3 48 60 80 00       	mov    %eax,0x806048
  802eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ead:	a3 44 60 80 00       	mov    %eax,0x806044
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 50 60 80 00       	mov    0x806050,%eax
  802ec1:	40                   	inc    %eax
  802ec2:	a3 50 60 80 00       	mov    %eax,0x806050
  802ec7:	eb 07                	jmp    802ed0 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802ec9:	90                   	nop
  802eca:	eb 04                	jmp    802ed0 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802ecc:	90                   	nop
  802ecd:	eb 01                	jmp    802ed0 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802ecf:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed8:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	83 e8 04             	sub    $0x4,%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	83 e0 fe             	and    $0xfffffffe,%eax
  802ef1:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	01 c2                	add    %eax,%edx
  802ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efc:	89 02                	mov    %eax,(%edx)
}
  802efe:	90                   	nop
  802eff:	5d                   	pop    %ebp
  802f00:	c3                   	ret    

00802f01 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802f01:	55                   	push   %ebp
  802f02:	89 e5                	mov    %esp,%ebp
  802f04:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	83 e0 01             	and    $0x1,%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 03                	je     802f14 <alloc_block_FF+0x13>
  802f11:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f14:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f18:	77 07                	ja     802f21 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f1a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f21:	a1 24 60 80 00       	mov    0x806024,%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	75 73                	jne    802f9d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	83 c0 10             	add    $0x10,%eax
  802f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f33:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802f3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	01 d0                	add    %edx,%eax
  802f42:	48                   	dec    %eax
  802f43:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f49:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4e:	f7 75 ec             	divl   -0x14(%ebp)
  802f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f54:	29 d0                	sub    %edx,%eax
  802f56:	c1 e8 0c             	shr    $0xc,%eax
  802f59:	83 ec 0c             	sub    $0xc,%esp
  802f5c:	50                   	push   %eax
  802f5d:	e8 86 f1 ff ff       	call   8020e8 <sbrk>
  802f62:	83 c4 10             	add    $0x10,%esp
  802f65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f68:	83 ec 0c             	sub    $0xc,%esp
  802f6b:	6a 00                	push   $0x0
  802f6d:	e8 76 f1 ff ff       	call   8020e8 <sbrk>
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f7e:	83 ec 08             	sub    $0x8,%esp
  802f81:	50                   	push   %eax
  802f82:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f85:	e8 5b fd ff ff       	call   802ce5 <initialize_dynamic_allocator>
  802f8a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f8d:	83 ec 0c             	sub    $0xc,%esp
  802f90:	68 4b 58 80 00       	push   $0x80584b
  802f95:	e8 b4 e3 ff ff       	call   80134e <cprintf>
  802f9a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802f9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa1:	75 0a                	jne    802fad <alloc_block_FF+0xac>
	        return NULL;
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa8:	e9 0e 04 00 00       	jmp    8033bb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802fb4:	a1 44 60 80 00       	mov    0x806044,%eax
  802fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbc:	e9 f3 02 00 00       	jmp    8032b4 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	ff 75 bc             	pushl  -0x44(%ebp)
  802fcd:	e8 af fb ff ff       	call   802b81 <get_block_size>
  802fd2:	83 c4 10             	add    $0x10,%esp
  802fd5:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	83 c0 08             	add    $0x8,%eax
  802fde:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802fe1:	0f 87 c5 02 00 00    	ja     8032ac <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	83 c0 18             	add    $0x18,%eax
  802fed:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ff0:	0f 87 19 02 00 00    	ja     80320f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ff6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ff9:	2b 45 08             	sub    0x8(%ebp),%eax
  802ffc:	83 e8 08             	sub    $0x8,%eax
  802fff:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8d 50 08             	lea    0x8(%eax),%edx
  803008:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80300b:	01 d0                	add    %edx,%eax
  80300d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	83 c0 08             	add    $0x8,%eax
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	6a 01                	push   $0x1
  80301b:	50                   	push   %eax
  80301c:	ff 75 bc             	pushl  -0x44(%ebp)
  80301f:	e8 ae fe ff ff       	call   802ed2 <set_block_data>
  803024:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 40 04             	mov    0x4(%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	75 68                	jne    803099 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803031:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803035:	75 17                	jne    80304e <alloc_block_FF+0x14d>
  803037:	83 ec 04             	sub    $0x4,%esp
  80303a:	68 28 58 80 00       	push   $0x805828
  80303f:	68 d7 00 00 00       	push   $0xd7
  803044:	68 0d 58 80 00       	push   $0x80580d
  803049:	e8 43 e0 ff ff       	call   801091 <_panic>
  80304e:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803054:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803057:	89 10                	mov    %edx,(%eax)
  803059:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0d                	je     80306f <alloc_block_FF+0x16e>
  803062:	a1 44 60 80 00       	mov    0x806044,%eax
  803067:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 08                	jmp    803077 <alloc_block_FF+0x176>
  80306f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803072:	a3 48 60 80 00       	mov    %eax,0x806048
  803077:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80307a:	a3 44 60 80 00       	mov    %eax,0x806044
  80307f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803089:	a1 50 60 80 00       	mov    0x806050,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 50 60 80 00       	mov    %eax,0x806050
  803094:	e9 dc 00 00 00       	jmp    803175 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	75 65                	jne    803107 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030a2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8030a6:	75 17                	jne    8030bf <alloc_block_FF+0x1be>
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	68 5c 58 80 00       	push   $0x80585c
  8030b0:	68 db 00 00 00       	push   $0xdb
  8030b5:	68 0d 58 80 00       	push   $0x80580d
  8030ba:	e8 d2 df ff ff       	call   801091 <_panic>
  8030bf:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8030c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030c8:	89 50 04             	mov    %edx,0x4(%eax)
  8030cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030ce:	8b 40 04             	mov    0x4(%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 0c                	je     8030e1 <alloc_block_FF+0x1e0>
  8030d5:	a1 48 60 80 00       	mov    0x806048,%eax
  8030da:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8030dd:	89 10                	mov    %edx,(%eax)
  8030df:	eb 08                	jmp    8030e9 <alloc_block_FF+0x1e8>
  8030e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030e4:	a3 44 60 80 00       	mov    %eax,0x806044
  8030e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030ec:	a3 48 60 80 00       	mov    %eax,0x806048
  8030f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fa:	a1 50 60 80 00       	mov    0x806050,%eax
  8030ff:	40                   	inc    %eax
  803100:	a3 50 60 80 00       	mov    %eax,0x806050
  803105:	eb 6e                	jmp    803175 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310b:	74 06                	je     803113 <alloc_block_FF+0x212>
  80310d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803111:	75 17                	jne    80312a <alloc_block_FF+0x229>
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	68 80 58 80 00       	push   $0x805880
  80311b:	68 df 00 00 00       	push   $0xdf
  803120:	68 0d 58 80 00       	push   $0x80580d
  803125:	e8 67 df ff ff       	call   801091 <_panic>
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	8b 10                	mov    (%eax),%edx
  80312f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803132:	89 10                	mov    %edx,(%eax)
  803134:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0b                	je     803148 <alloc_block_FF+0x247>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80314e:	89 10                	mov    %edx,(%eax)
  803150:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	75 08                	jne    80316a <alloc_block_FF+0x269>
  803162:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803165:	a3 48 60 80 00       	mov    %eax,0x806048
  80316a:	a1 50 60 80 00       	mov    0x806050,%eax
  80316f:	40                   	inc    %eax
  803170:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803179:	75 17                	jne    803192 <alloc_block_FF+0x291>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 ef 57 80 00       	push   $0x8057ef
  803183:	68 e1 00 00 00       	push   $0xe1
  803188:	68 0d 58 80 00       	push   $0x80580d
  80318d:	e8 ff de ff ff       	call   801091 <_panic>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 10                	je     8031ab <alloc_block_FF+0x2aa>
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a3:	8b 52 04             	mov    0x4(%edx),%edx
  8031a6:	89 50 04             	mov    %edx,0x4(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <alloc_block_FF+0x2b5>
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	a3 48 60 80 00       	mov    %eax,0x806048
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 0f                	je     8031cf <alloc_block_FF+0x2ce>
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 04             	mov    0x4(%eax),%eax
  8031c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c9:	8b 12                	mov    (%edx),%edx
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	eb 0a                	jmp    8031d9 <alloc_block_FF+0x2d8>
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	a3 44 60 80 00       	mov    %eax,0x806044
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ec:	a1 50 60 80 00       	mov    0x806050,%eax
  8031f1:	48                   	dec    %eax
  8031f2:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	6a 00                	push   $0x0
  8031fc:	ff 75 b4             	pushl  -0x4c(%ebp)
  8031ff:	ff 75 b0             	pushl  -0x50(%ebp)
  803202:	e8 cb fc ff ff       	call   802ed2 <set_block_data>
  803207:	83 c4 10             	add    $0x10,%esp
  80320a:	e9 95 00 00 00       	jmp    8032a4 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80320f:	83 ec 04             	sub    $0x4,%esp
  803212:	6a 01                	push   $0x1
  803214:	ff 75 b8             	pushl  -0x48(%ebp)
  803217:	ff 75 bc             	pushl  -0x44(%ebp)
  80321a:	e8 b3 fc ff ff       	call   802ed2 <set_block_data>
  80321f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803226:	75 17                	jne    80323f <alloc_block_FF+0x33e>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 ef 57 80 00       	push   $0x8057ef
  803230:	68 e8 00 00 00       	push   $0xe8
  803235:	68 0d 58 80 00       	push   $0x80580d
  80323a:	e8 52 de ff ff       	call   801091 <_panic>
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 10                	je     803258 <alloc_block_FF+0x357>
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803250:	8b 52 04             	mov    0x4(%edx),%edx
  803253:	89 50 04             	mov    %edx,0x4(%eax)
  803256:	eb 0b                	jmp    803263 <alloc_block_FF+0x362>
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	a3 48 60 80 00       	mov    %eax,0x806048
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0f                	je     80327c <alloc_block_FF+0x37b>
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803276:	8b 12                	mov    (%edx),%edx
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	eb 0a                	jmp    803286 <alloc_block_FF+0x385>
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	a3 44 60 80 00       	mov    %eax,0x806044
  803286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 50 60 80 00       	mov    0x806050,%eax
  80329e:	48                   	dec    %eax
  80329f:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  8032a4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032a7:	e9 0f 01 00 00       	jmp    8033bb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8032ac:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b8:	74 07                	je     8032c1 <alloc_block_FF+0x3c0>
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 00                	mov    (%eax),%eax
  8032bf:	eb 05                	jmp    8032c6 <alloc_block_FF+0x3c5>
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8032cb:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	0f 85 e9 fc ff ff    	jne    802fc1 <alloc_block_FF+0xc0>
  8032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dc:	0f 85 df fc ff ff    	jne    802fc1 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	83 c0 08             	add    $0x8,%eax
  8032e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032eb:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8032f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032f8:	01 d0                	add    %edx,%eax
  8032fa:	48                   	dec    %eax
  8032fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8032fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803301:	ba 00 00 00 00       	mov    $0x0,%edx
  803306:	f7 75 d8             	divl   -0x28(%ebp)
  803309:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330c:	29 d0                	sub    %edx,%eax
  80330e:	c1 e8 0c             	shr    $0xc,%eax
  803311:	83 ec 0c             	sub    $0xc,%esp
  803314:	50                   	push   %eax
  803315:	e8 ce ed ff ff       	call   8020e8 <sbrk>
  80331a:	83 c4 10             	add    $0x10,%esp
  80331d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803320:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803324:	75 0a                	jne    803330 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803326:	b8 00 00 00 00       	mov    $0x0,%eax
  80332b:	e9 8b 00 00 00       	jmp    8033bb <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803330:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803337:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80333a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333d:	01 d0                	add    %edx,%eax
  80333f:	48                   	dec    %eax
  803340:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803343:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803346:	ba 00 00 00 00       	mov    $0x0,%edx
  80334b:	f7 75 cc             	divl   -0x34(%ebp)
  80334e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803351:	29 d0                	sub    %edx,%eax
  803353:	8d 50 fc             	lea    -0x4(%eax),%edx
  803356:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803359:	01 d0                	add    %edx,%eax
  80335b:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  803360:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803365:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80336b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803372:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803375:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803378:	01 d0                	add    %edx,%eax
  80337a:	48                   	dec    %eax
  80337b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80337e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803381:	ba 00 00 00 00       	mov    $0x0,%edx
  803386:	f7 75 c4             	divl   -0x3c(%ebp)
  803389:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80338c:	29 d0                	sub    %edx,%eax
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	6a 01                	push   $0x1
  803393:	50                   	push   %eax
  803394:	ff 75 d0             	pushl  -0x30(%ebp)
  803397:	e8 36 fb ff ff       	call   802ed2 <set_block_data>
  80339c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	ff 75 d0             	pushl  -0x30(%ebp)
  8033a5:	e8 1b 0a 00 00       	call   803dc5 <free_block>
  8033aa:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	ff 75 08             	pushl  0x8(%ebp)
  8033b3:	e8 49 fb ff ff       	call   802f01 <alloc_block_FF>
  8033b8:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8033bb:	c9                   	leave  
  8033bc:	c3                   	ret    

008033bd <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8033bd:	55                   	push   %ebp
  8033be:	89 e5                	mov    %esp,%ebp
  8033c0:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	83 e0 01             	and    $0x1,%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 03                	je     8033d0 <alloc_block_BF+0x13>
  8033cd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8033d0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8033d4:	77 07                	ja     8033dd <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8033d6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8033dd:	a1 24 60 80 00       	mov    0x806024,%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	75 73                	jne    803459 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	83 c0 10             	add    $0x10,%eax
  8033ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8033ef:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8033f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033fc:	01 d0                	add    %edx,%eax
  8033fe:	48                   	dec    %eax
  8033ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803405:	ba 00 00 00 00       	mov    $0x0,%edx
  80340a:	f7 75 e0             	divl   -0x20(%ebp)
  80340d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803410:	29 d0                	sub    %edx,%eax
  803412:	c1 e8 0c             	shr    $0xc,%eax
  803415:	83 ec 0c             	sub    $0xc,%esp
  803418:	50                   	push   %eax
  803419:	e8 ca ec ff ff       	call   8020e8 <sbrk>
  80341e:	83 c4 10             	add    $0x10,%esp
  803421:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803424:	83 ec 0c             	sub    $0xc,%esp
  803427:	6a 00                	push   $0x0
  803429:	e8 ba ec ff ff       	call   8020e8 <sbrk>
  80342e:	83 c4 10             	add    $0x10,%esp
  803431:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803434:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803437:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80343a:	83 ec 08             	sub    $0x8,%esp
  80343d:	50                   	push   %eax
  80343e:	ff 75 d8             	pushl  -0x28(%ebp)
  803441:	e8 9f f8 ff ff       	call   802ce5 <initialize_dynamic_allocator>
  803446:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803449:	83 ec 0c             	sub    $0xc,%esp
  80344c:	68 4b 58 80 00       	push   $0x80584b
  803451:	e8 f8 de ff ff       	call   80134e <cprintf>
  803456:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803467:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80346e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803475:	a1 44 60 80 00       	mov    0x806044,%eax
  80347a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347d:	e9 1d 01 00 00       	jmp    80359f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803488:	83 ec 0c             	sub    $0xc,%esp
  80348b:	ff 75 a8             	pushl  -0x58(%ebp)
  80348e:	e8 ee f6 ff ff       	call   802b81 <get_block_size>
  803493:	83 c4 10             	add    $0x10,%esp
  803496:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	83 c0 08             	add    $0x8,%eax
  80349f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034a2:	0f 87 ef 00 00 00    	ja     803597 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	83 c0 18             	add    $0x18,%eax
  8034ae:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034b1:	77 1d                	ja     8034d0 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034b9:	0f 86 d8 00 00 00    	jbe    803597 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8034bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8034c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8034c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8034c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8034cb:	e9 c7 00 00 00       	jmp    803597 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	83 c0 08             	add    $0x8,%eax
  8034d6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8034d9:	0f 85 9d 00 00 00    	jne    80357c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	6a 01                	push   $0x1
  8034e4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8034e7:	ff 75 a8             	pushl  -0x58(%ebp)
  8034ea:	e8 e3 f9 ff ff       	call   802ed2 <set_block_data>
  8034ef:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8034f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f6:	75 17                	jne    80350f <alloc_block_BF+0x152>
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	68 ef 57 80 00       	push   $0x8057ef
  803500:	68 2c 01 00 00       	push   $0x12c
  803505:	68 0d 58 80 00       	push   $0x80580d
  80350a:	e8 82 db ff ff       	call   801091 <_panic>
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 10                	je     803528 <alloc_block_BF+0x16b>
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	8b 00                	mov    (%eax),%eax
  80351d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803520:	8b 52 04             	mov    0x4(%edx),%edx
  803523:	89 50 04             	mov    %edx,0x4(%eax)
  803526:	eb 0b                	jmp    803533 <alloc_block_BF+0x176>
  803528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352b:	8b 40 04             	mov    0x4(%eax),%eax
  80352e:	a3 48 60 80 00       	mov    %eax,0x806048
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0f                	je     80354c <alloc_block_BF+0x18f>
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 40 04             	mov    0x4(%eax),%eax
  803543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803546:	8b 12                	mov    (%edx),%edx
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	eb 0a                	jmp    803556 <alloc_block_BF+0x199>
  80354c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	a3 44 60 80 00       	mov    %eax,0x806044
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803569:	a1 50 60 80 00       	mov    0x806050,%eax
  80356e:	48                   	dec    %eax
  80356f:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803574:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803577:	e9 24 04 00 00       	jmp    8039a0 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803582:	76 13                	jbe    803597 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803584:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80358b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80358e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803591:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803594:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803597:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80359c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a3:	74 07                	je     8035ac <alloc_block_BF+0x1ef>
  8035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	eb 05                	jmp    8035b1 <alloc_block_BF+0x1f4>
  8035ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b1:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8035b6:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	0f 85 bf fe ff ff    	jne    803482 <alloc_block_BF+0xc5>
  8035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c7:	0f 85 b5 fe ff ff    	jne    803482 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8035cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035d1:	0f 84 26 02 00 00    	je     8037fd <alloc_block_BF+0x440>
  8035d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035db:	0f 85 1c 02 00 00    	jne    8037fd <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8035e7:	83 e8 08             	sub    $0x8,%eax
  8035ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8d 50 08             	lea    0x8(%eax),%edx
  8035f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f6:	01 d0                	add    %edx,%eax
  8035f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	83 c0 08             	add    $0x8,%eax
  803601:	83 ec 04             	sub    $0x4,%esp
  803604:	6a 01                	push   $0x1
  803606:	50                   	push   %eax
  803607:	ff 75 f0             	pushl  -0x10(%ebp)
  80360a:	e8 c3 f8 ff ff       	call   802ed2 <set_block_data>
  80360f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	75 68                	jne    803684 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80361c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803620:	75 17                	jne    803639 <alloc_block_BF+0x27c>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 28 58 80 00       	push   $0x805828
  80362a:	68 45 01 00 00       	push   $0x145
  80362f:	68 0d 58 80 00       	push   $0x80580d
  803634:	e8 58 da ff ff       	call   801091 <_panic>
  803639:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80363f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803642:	89 10                	mov    %edx,(%eax)
  803644:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	85 c0                	test   %eax,%eax
  80364b:	74 0d                	je     80365a <alloc_block_BF+0x29d>
  80364d:	a1 44 60 80 00       	mov    0x806044,%eax
  803652:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803655:	89 50 04             	mov    %edx,0x4(%eax)
  803658:	eb 08                	jmp    803662 <alloc_block_BF+0x2a5>
  80365a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80365d:	a3 48 60 80 00       	mov    %eax,0x806048
  803662:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803665:	a3 44 60 80 00       	mov    %eax,0x806044
  80366a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80366d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803674:	a1 50 60 80 00       	mov    0x806050,%eax
  803679:	40                   	inc    %eax
  80367a:	a3 50 60 80 00       	mov    %eax,0x806050
  80367f:	e9 dc 00 00 00       	jmp    803760 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	75 65                	jne    8036f2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80368d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803691:	75 17                	jne    8036aa <alloc_block_BF+0x2ed>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 5c 58 80 00       	push   $0x80585c
  80369b:	68 4a 01 00 00       	push   $0x14a
  8036a0:	68 0d 58 80 00       	push   $0x80580d
  8036a5:	e8 e7 d9 ff ff       	call   801091 <_panic>
  8036aa:	8b 15 48 60 80 00    	mov    0x806048,%edx
  8036b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036b3:	89 50 04             	mov    %edx,0x4(%eax)
  8036b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036b9:	8b 40 04             	mov    0x4(%eax),%eax
  8036bc:	85 c0                	test   %eax,%eax
  8036be:	74 0c                	je     8036cc <alloc_block_BF+0x30f>
  8036c0:	a1 48 60 80 00       	mov    0x806048,%eax
  8036c5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036c8:	89 10                	mov    %edx,(%eax)
  8036ca:	eb 08                	jmp    8036d4 <alloc_block_BF+0x317>
  8036cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036cf:	a3 44 60 80 00       	mov    %eax,0x806044
  8036d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036d7:	a3 48 60 80 00       	mov    %eax,0x806048
  8036dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e5:	a1 50 60 80 00       	mov    0x806050,%eax
  8036ea:	40                   	inc    %eax
  8036eb:	a3 50 60 80 00       	mov    %eax,0x806050
  8036f0:	eb 6e                	jmp    803760 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8036f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036f6:	74 06                	je     8036fe <alloc_block_BF+0x341>
  8036f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036fc:	75 17                	jne    803715 <alloc_block_BF+0x358>
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 80 58 80 00       	push   $0x805880
  803706:	68 4f 01 00 00       	push   $0x14f
  80370b:	68 0d 58 80 00       	push   $0x80580d
  803710:	e8 7c d9 ff ff       	call   801091 <_panic>
  803715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803718:	8b 10                	mov    (%eax),%edx
  80371a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80371d:	89 10                	mov    %edx,(%eax)
  80371f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	85 c0                	test   %eax,%eax
  803726:	74 0b                	je     803733 <alloc_block_BF+0x376>
  803728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372b:	8b 00                	mov    (%eax),%eax
  80372d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803730:	89 50 04             	mov    %edx,0x4(%eax)
  803733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803736:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803739:	89 10                	mov    %edx,(%eax)
  80373b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80373e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803741:	89 50 04             	mov    %edx,0x4(%eax)
  803744:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	85 c0                	test   %eax,%eax
  80374b:	75 08                	jne    803755 <alloc_block_BF+0x398>
  80374d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803750:	a3 48 60 80 00       	mov    %eax,0x806048
  803755:	a1 50 60 80 00       	mov    0x806050,%eax
  80375a:	40                   	inc    %eax
  80375b:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803764:	75 17                	jne    80377d <alloc_block_BF+0x3c0>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 ef 57 80 00       	push   $0x8057ef
  80376e:	68 51 01 00 00       	push   $0x151
  803773:	68 0d 58 80 00       	push   $0x80580d
  803778:	e8 14 d9 ff ff       	call   801091 <_panic>
  80377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 10                	je     803796 <alloc_block_BF+0x3d9>
  803786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80378e:	8b 52 04             	mov    0x4(%edx),%edx
  803791:	89 50 04             	mov    %edx,0x4(%eax)
  803794:	eb 0b                	jmp    8037a1 <alloc_block_BF+0x3e4>
  803796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803799:	8b 40 04             	mov    0x4(%eax),%eax
  80379c:	a3 48 60 80 00       	mov    %eax,0x806048
  8037a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a4:	8b 40 04             	mov    0x4(%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	74 0f                	je     8037ba <alloc_block_BF+0x3fd>
  8037ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ae:	8b 40 04             	mov    0x4(%eax),%eax
  8037b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b4:	8b 12                	mov    (%edx),%edx
  8037b6:	89 10                	mov    %edx,(%eax)
  8037b8:	eb 0a                	jmp    8037c4 <alloc_block_BF+0x407>
  8037ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	a3 44 60 80 00       	mov    %eax,0x806044
  8037c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d7:	a1 50 60 80 00       	mov    0x806050,%eax
  8037dc:	48                   	dec    %eax
  8037dd:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  8037e2:	83 ec 04             	sub    $0x4,%esp
  8037e5:	6a 00                	push   $0x0
  8037e7:	ff 75 d0             	pushl  -0x30(%ebp)
  8037ea:	ff 75 cc             	pushl  -0x34(%ebp)
  8037ed:	e8 e0 f6 ff ff       	call   802ed2 <set_block_data>
  8037f2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8037f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f8:	e9 a3 01 00 00       	jmp    8039a0 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8037fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803801:	0f 85 9d 00 00 00    	jne    8038a4 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	6a 01                	push   $0x1
  80380c:	ff 75 ec             	pushl  -0x14(%ebp)
  80380f:	ff 75 f0             	pushl  -0x10(%ebp)
  803812:	e8 bb f6 ff ff       	call   802ed2 <set_block_data>
  803817:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80381a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80381e:	75 17                	jne    803837 <alloc_block_BF+0x47a>
  803820:	83 ec 04             	sub    $0x4,%esp
  803823:	68 ef 57 80 00       	push   $0x8057ef
  803828:	68 58 01 00 00       	push   $0x158
  80382d:	68 0d 58 80 00       	push   $0x80580d
  803832:	e8 5a d8 ff ff       	call   801091 <_panic>
  803837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	74 10                	je     803850 <alloc_block_BF+0x493>
  803840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803848:	8b 52 04             	mov    0x4(%edx),%edx
  80384b:	89 50 04             	mov    %edx,0x4(%eax)
  80384e:	eb 0b                	jmp    80385b <alloc_block_BF+0x49e>
  803850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	a3 48 60 80 00       	mov    %eax,0x806048
  80385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	74 0f                	je     803874 <alloc_block_BF+0x4b7>
  803865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803868:	8b 40 04             	mov    0x4(%eax),%eax
  80386b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80386e:	8b 12                	mov    (%edx),%edx
  803870:	89 10                	mov    %edx,(%eax)
  803872:	eb 0a                	jmp    80387e <alloc_block_BF+0x4c1>
  803874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803877:	8b 00                	mov    (%eax),%eax
  803879:	a3 44 60 80 00       	mov    %eax,0x806044
  80387e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803891:	a1 50 60 80 00       	mov    0x806050,%eax
  803896:	48                   	dec    %eax
  803897:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  80389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389f:	e9 fc 00 00 00       	jmp    8039a0 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a7:	83 c0 08             	add    $0x8,%eax
  8038aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8038ad:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8038b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ba:	01 d0                	add    %edx,%eax
  8038bc:	48                   	dec    %eax
  8038bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8038c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8038c8:	f7 75 c4             	divl   -0x3c(%ebp)
  8038cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038ce:	29 d0                	sub    %edx,%eax
  8038d0:	c1 e8 0c             	shr    $0xc,%eax
  8038d3:	83 ec 0c             	sub    $0xc,%esp
  8038d6:	50                   	push   %eax
  8038d7:	e8 0c e8 ff ff       	call   8020e8 <sbrk>
  8038dc:	83 c4 10             	add    $0x10,%esp
  8038df:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8038e2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8038e6:	75 0a                	jne    8038f2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8038e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ed:	e9 ae 00 00 00       	jmp    8039a0 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8038f2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8038f9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ff:	01 d0                	add    %edx,%eax
  803901:	48                   	dec    %eax
  803902:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803905:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803908:	ba 00 00 00 00       	mov    $0x0,%edx
  80390d:	f7 75 b8             	divl   -0x48(%ebp)
  803910:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803913:	29 d0                	sub    %edx,%eax
  803915:	8d 50 fc             	lea    -0x4(%eax),%edx
  803918:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80391b:	01 d0                	add    %edx,%eax
  80391d:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  803922:	a1 48 a2 80 00       	mov    0x80a248,%eax
  803927:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80392d:	83 ec 0c             	sub    $0xc,%esp
  803930:	68 b4 58 80 00       	push   $0x8058b4
  803935:	e8 14 da ff ff       	call   80134e <cprintf>
  80393a:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80393d:	83 ec 08             	sub    $0x8,%esp
  803940:	ff 75 bc             	pushl  -0x44(%ebp)
  803943:	68 b9 58 80 00       	push   $0x8058b9
  803948:	e8 01 da ff ff       	call   80134e <cprintf>
  80394d:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803950:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803957:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80395a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80395d:	01 d0                	add    %edx,%eax
  80395f:	48                   	dec    %eax
  803960:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803963:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803966:	ba 00 00 00 00       	mov    $0x0,%edx
  80396b:	f7 75 b0             	divl   -0x50(%ebp)
  80396e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803971:	29 d0                	sub    %edx,%eax
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	6a 01                	push   $0x1
  803978:	50                   	push   %eax
  803979:	ff 75 bc             	pushl  -0x44(%ebp)
  80397c:	e8 51 f5 ff ff       	call   802ed2 <set_block_data>
  803981:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	ff 75 bc             	pushl  -0x44(%ebp)
  80398a:	e8 36 04 00 00       	call   803dc5 <free_block>
  80398f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803992:	83 ec 0c             	sub    $0xc,%esp
  803995:	ff 75 08             	pushl  0x8(%ebp)
  803998:	e8 20 fa ff ff       	call   8033bd <alloc_block_BF>
  80399d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8039a0:	c9                   	leave  
  8039a1:	c3                   	ret    

008039a2 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8039a2:	55                   	push   %ebp
  8039a3:	89 e5                	mov    %esp,%ebp
  8039a5:	53                   	push   %ebx
  8039a6:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8039a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8039b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039bb:	74 1e                	je     8039db <merging+0x39>
  8039bd:	ff 75 08             	pushl  0x8(%ebp)
  8039c0:	e8 bc f1 ff ff       	call   802b81 <get_block_size>
  8039c5:	83 c4 04             	add    $0x4,%esp
  8039c8:	89 c2                	mov    %eax,%edx
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	01 d0                	add    %edx,%eax
  8039cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8039d2:	75 07                	jne    8039db <merging+0x39>
		prev_is_free = 1;
  8039d4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8039db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039df:	74 1e                	je     8039ff <merging+0x5d>
  8039e1:	ff 75 10             	pushl  0x10(%ebp)
  8039e4:	e8 98 f1 ff ff       	call   802b81 <get_block_size>
  8039e9:	83 c4 04             	add    $0x4,%esp
  8039ec:	89 c2                	mov    %eax,%edx
  8039ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8039f1:	01 d0                	add    %edx,%eax
  8039f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039f6:	75 07                	jne    8039ff <merging+0x5d>
		next_is_free = 1;
  8039f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8039ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a03:	0f 84 cc 00 00 00    	je     803ad5 <merging+0x133>
  803a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a0d:	0f 84 c2 00 00 00    	je     803ad5 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803a13:	ff 75 08             	pushl  0x8(%ebp)
  803a16:	e8 66 f1 ff ff       	call   802b81 <get_block_size>
  803a1b:	83 c4 04             	add    $0x4,%esp
  803a1e:	89 c3                	mov    %eax,%ebx
  803a20:	ff 75 10             	pushl  0x10(%ebp)
  803a23:	e8 59 f1 ff ff       	call   802b81 <get_block_size>
  803a28:	83 c4 04             	add    $0x4,%esp
  803a2b:	01 c3                	add    %eax,%ebx
  803a2d:	ff 75 0c             	pushl  0xc(%ebp)
  803a30:	e8 4c f1 ff ff       	call   802b81 <get_block_size>
  803a35:	83 c4 04             	add    $0x4,%esp
  803a38:	01 d8                	add    %ebx,%eax
  803a3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803a3d:	6a 00                	push   $0x0
  803a3f:	ff 75 ec             	pushl  -0x14(%ebp)
  803a42:	ff 75 08             	pushl  0x8(%ebp)
  803a45:	e8 88 f4 ff ff       	call   802ed2 <set_block_data>
  803a4a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803a4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a51:	75 17                	jne    803a6a <merging+0xc8>
  803a53:	83 ec 04             	sub    $0x4,%esp
  803a56:	68 ef 57 80 00       	push   $0x8057ef
  803a5b:	68 7d 01 00 00       	push   $0x17d
  803a60:	68 0d 58 80 00       	push   $0x80580d
  803a65:	e8 27 d6 ff ff       	call   801091 <_panic>
  803a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6d:	8b 00                	mov    (%eax),%eax
  803a6f:	85 c0                	test   %eax,%eax
  803a71:	74 10                	je     803a83 <merging+0xe1>
  803a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a7b:	8b 52 04             	mov    0x4(%edx),%edx
  803a7e:	89 50 04             	mov    %edx,0x4(%eax)
  803a81:	eb 0b                	jmp    803a8e <merging+0xec>
  803a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	a3 48 60 80 00       	mov    %eax,0x806048
  803a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a91:	8b 40 04             	mov    0x4(%eax),%eax
  803a94:	85 c0                	test   %eax,%eax
  803a96:	74 0f                	je     803aa7 <merging+0x105>
  803a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a9b:	8b 40 04             	mov    0x4(%eax),%eax
  803a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aa1:	8b 12                	mov    (%edx),%edx
  803aa3:	89 10                	mov    %edx,(%eax)
  803aa5:	eb 0a                	jmp    803ab1 <merging+0x10f>
  803aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	a3 44 60 80 00       	mov    %eax,0x806044
  803ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac4:	a1 50 60 80 00       	mov    0x806050,%eax
  803ac9:	48                   	dec    %eax
  803aca:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803acf:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ad0:	e9 ea 02 00 00       	jmp    803dbf <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803ad5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad9:	74 3b                	je     803b16 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803adb:	83 ec 0c             	sub    $0xc,%esp
  803ade:	ff 75 08             	pushl  0x8(%ebp)
  803ae1:	e8 9b f0 ff ff       	call   802b81 <get_block_size>
  803ae6:	83 c4 10             	add    $0x10,%esp
  803ae9:	89 c3                	mov    %eax,%ebx
  803aeb:	83 ec 0c             	sub    $0xc,%esp
  803aee:	ff 75 10             	pushl  0x10(%ebp)
  803af1:	e8 8b f0 ff ff       	call   802b81 <get_block_size>
  803af6:	83 c4 10             	add    $0x10,%esp
  803af9:	01 d8                	add    %ebx,%eax
  803afb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803afe:	83 ec 04             	sub    $0x4,%esp
  803b01:	6a 00                	push   $0x0
  803b03:	ff 75 e8             	pushl  -0x18(%ebp)
  803b06:	ff 75 08             	pushl  0x8(%ebp)
  803b09:	e8 c4 f3 ff ff       	call   802ed2 <set_block_data>
  803b0e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803b11:	e9 a9 02 00 00       	jmp    803dbf <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b1a:	0f 84 2d 01 00 00    	je     803c4d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803b20:	83 ec 0c             	sub    $0xc,%esp
  803b23:	ff 75 10             	pushl  0x10(%ebp)
  803b26:	e8 56 f0 ff ff       	call   802b81 <get_block_size>
  803b2b:	83 c4 10             	add    $0x10,%esp
  803b2e:	89 c3                	mov    %eax,%ebx
  803b30:	83 ec 0c             	sub    $0xc,%esp
  803b33:	ff 75 0c             	pushl  0xc(%ebp)
  803b36:	e8 46 f0 ff ff       	call   802b81 <get_block_size>
  803b3b:	83 c4 10             	add    $0x10,%esp
  803b3e:	01 d8                	add    %ebx,%eax
  803b40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803b43:	83 ec 04             	sub    $0x4,%esp
  803b46:	6a 00                	push   $0x0
  803b48:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b4b:	ff 75 10             	pushl  0x10(%ebp)
  803b4e:	e8 7f f3 ff ff       	call   802ed2 <set_block_data>
  803b53:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803b56:	8b 45 10             	mov    0x10(%ebp),%eax
  803b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b60:	74 06                	je     803b68 <merging+0x1c6>
  803b62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b66:	75 17                	jne    803b7f <merging+0x1dd>
  803b68:	83 ec 04             	sub    $0x4,%esp
  803b6b:	68 c8 58 80 00       	push   $0x8058c8
  803b70:	68 8d 01 00 00       	push   $0x18d
  803b75:	68 0d 58 80 00       	push   $0x80580d
  803b7a:	e8 12 d5 ff ff       	call   801091 <_panic>
  803b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b82:	8b 50 04             	mov    0x4(%eax),%edx
  803b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b88:	89 50 04             	mov    %edx,0x4(%eax)
  803b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b91:	89 10                	mov    %edx,(%eax)
  803b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b96:	8b 40 04             	mov    0x4(%eax),%eax
  803b99:	85 c0                	test   %eax,%eax
  803b9b:	74 0d                	je     803baa <merging+0x208>
  803b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba0:	8b 40 04             	mov    0x4(%eax),%eax
  803ba3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ba6:	89 10                	mov    %edx,(%eax)
  803ba8:	eb 08                	jmp    803bb2 <merging+0x210>
  803baa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bad:	a3 44 60 80 00       	mov    %eax,0x806044
  803bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bb8:	89 50 04             	mov    %edx,0x4(%eax)
  803bbb:	a1 50 60 80 00       	mov    0x806050,%eax
  803bc0:	40                   	inc    %eax
  803bc1:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803bc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bca:	75 17                	jne    803be3 <merging+0x241>
  803bcc:	83 ec 04             	sub    $0x4,%esp
  803bcf:	68 ef 57 80 00       	push   $0x8057ef
  803bd4:	68 8e 01 00 00       	push   $0x18e
  803bd9:	68 0d 58 80 00       	push   $0x80580d
  803bde:	e8 ae d4 ff ff       	call   801091 <_panic>
  803be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 10                	je     803bfc <merging+0x25a>
  803bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bf4:	8b 52 04             	mov    0x4(%edx),%edx
  803bf7:	89 50 04             	mov    %edx,0x4(%eax)
  803bfa:	eb 0b                	jmp    803c07 <merging+0x265>
  803bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bff:	8b 40 04             	mov    0x4(%eax),%eax
  803c02:	a3 48 60 80 00       	mov    %eax,0x806048
  803c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c0a:	8b 40 04             	mov    0x4(%eax),%eax
  803c0d:	85 c0                	test   %eax,%eax
  803c0f:	74 0f                	je     803c20 <merging+0x27e>
  803c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c14:	8b 40 04             	mov    0x4(%eax),%eax
  803c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c1a:	8b 12                	mov    (%edx),%edx
  803c1c:	89 10                	mov    %edx,(%eax)
  803c1e:	eb 0a                	jmp    803c2a <merging+0x288>
  803c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c23:	8b 00                	mov    (%eax),%eax
  803c25:	a3 44 60 80 00       	mov    %eax,0x806044
  803c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3d:	a1 50 60 80 00       	mov    0x806050,%eax
  803c42:	48                   	dec    %eax
  803c43:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c48:	e9 72 01 00 00       	jmp    803dbf <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  803c50:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c57:	74 79                	je     803cd2 <merging+0x330>
  803c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c5d:	74 73                	je     803cd2 <merging+0x330>
  803c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c63:	74 06                	je     803c6b <merging+0x2c9>
  803c65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c69:	75 17                	jne    803c82 <merging+0x2e0>
  803c6b:	83 ec 04             	sub    $0x4,%esp
  803c6e:	68 80 58 80 00       	push   $0x805880
  803c73:	68 94 01 00 00       	push   $0x194
  803c78:	68 0d 58 80 00       	push   $0x80580d
  803c7d:	e8 0f d4 ff ff       	call   801091 <_panic>
  803c82:	8b 45 08             	mov    0x8(%ebp),%eax
  803c85:	8b 10                	mov    (%eax),%edx
  803c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8a:	89 10                	mov    %edx,(%eax)
  803c8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	85 c0                	test   %eax,%eax
  803c93:	74 0b                	je     803ca0 <merging+0x2fe>
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	8b 00                	mov    (%eax),%eax
  803c9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ca6:	89 10                	mov    %edx,(%eax)
  803ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cab:	8b 55 08             	mov    0x8(%ebp),%edx
  803cae:	89 50 04             	mov    %edx,0x4(%eax)
  803cb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb4:	8b 00                	mov    (%eax),%eax
  803cb6:	85 c0                	test   %eax,%eax
  803cb8:	75 08                	jne    803cc2 <merging+0x320>
  803cba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cbd:	a3 48 60 80 00       	mov    %eax,0x806048
  803cc2:	a1 50 60 80 00       	mov    0x806050,%eax
  803cc7:	40                   	inc    %eax
  803cc8:	a3 50 60 80 00       	mov    %eax,0x806050
  803ccd:	e9 ce 00 00 00       	jmp    803da0 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cd6:	74 65                	je     803d3d <merging+0x39b>
  803cd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cdc:	75 17                	jne    803cf5 <merging+0x353>
  803cde:	83 ec 04             	sub    $0x4,%esp
  803ce1:	68 5c 58 80 00       	push   $0x80585c
  803ce6:	68 95 01 00 00       	push   $0x195
  803ceb:	68 0d 58 80 00       	push   $0x80580d
  803cf0:	e8 9c d3 ff ff       	call   801091 <_panic>
  803cf5:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803cfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cfe:	89 50 04             	mov    %edx,0x4(%eax)
  803d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d04:	8b 40 04             	mov    0x4(%eax),%eax
  803d07:	85 c0                	test   %eax,%eax
  803d09:	74 0c                	je     803d17 <merging+0x375>
  803d0b:	a1 48 60 80 00       	mov    0x806048,%eax
  803d10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d13:	89 10                	mov    %edx,(%eax)
  803d15:	eb 08                	jmp    803d1f <merging+0x37d>
  803d17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1a:	a3 44 60 80 00       	mov    %eax,0x806044
  803d1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d22:	a3 48 60 80 00       	mov    %eax,0x806048
  803d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d30:	a1 50 60 80 00       	mov    0x806050,%eax
  803d35:	40                   	inc    %eax
  803d36:	a3 50 60 80 00       	mov    %eax,0x806050
  803d3b:	eb 63                	jmp    803da0 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803d3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d41:	75 17                	jne    803d5a <merging+0x3b8>
  803d43:	83 ec 04             	sub    $0x4,%esp
  803d46:	68 28 58 80 00       	push   $0x805828
  803d4b:	68 98 01 00 00       	push   $0x198
  803d50:	68 0d 58 80 00       	push   $0x80580d
  803d55:	e8 37 d3 ff ff       	call   801091 <_panic>
  803d5a:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803d60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d63:	89 10                	mov    %edx,(%eax)
  803d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	85 c0                	test   %eax,%eax
  803d6c:	74 0d                	je     803d7b <merging+0x3d9>
  803d6e:	a1 44 60 80 00       	mov    0x806044,%eax
  803d73:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d76:	89 50 04             	mov    %edx,0x4(%eax)
  803d79:	eb 08                	jmp    803d83 <merging+0x3e1>
  803d7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d7e:	a3 48 60 80 00       	mov    %eax,0x806048
  803d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d86:	a3 44 60 80 00       	mov    %eax,0x806044
  803d8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d95:	a1 50 60 80 00       	mov    0x806050,%eax
  803d9a:	40                   	inc    %eax
  803d9b:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803da0:	83 ec 0c             	sub    $0xc,%esp
  803da3:	ff 75 10             	pushl  0x10(%ebp)
  803da6:	e8 d6 ed ff ff       	call   802b81 <get_block_size>
  803dab:	83 c4 10             	add    $0x10,%esp
  803dae:	83 ec 04             	sub    $0x4,%esp
  803db1:	6a 00                	push   $0x0
  803db3:	50                   	push   %eax
  803db4:	ff 75 10             	pushl  0x10(%ebp)
  803db7:	e8 16 f1 ff ff       	call   802ed2 <set_block_data>
  803dbc:	83 c4 10             	add    $0x10,%esp
	}
}
  803dbf:	90                   	nop
  803dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803dc3:	c9                   	leave  
  803dc4:	c3                   	ret    

00803dc5 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803dc5:	55                   	push   %ebp
  803dc6:	89 e5                	mov    %esp,%ebp
  803dc8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803dcb:	a1 44 60 80 00       	mov    0x806044,%eax
  803dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803dd3:	a1 48 60 80 00       	mov    0x806048,%eax
  803dd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ddb:	73 1b                	jae    803df8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803ddd:	a1 48 60 80 00       	mov    0x806048,%eax
  803de2:	83 ec 04             	sub    $0x4,%esp
  803de5:	ff 75 08             	pushl  0x8(%ebp)
  803de8:	6a 00                	push   $0x0
  803dea:	50                   	push   %eax
  803deb:	e8 b2 fb ff ff       	call   8039a2 <merging>
  803df0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803df3:	e9 8b 00 00 00       	jmp    803e83 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803df8:	a1 44 60 80 00       	mov    0x806044,%eax
  803dfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e00:	76 18                	jbe    803e1a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803e02:	a1 44 60 80 00       	mov    0x806044,%eax
  803e07:	83 ec 04             	sub    $0x4,%esp
  803e0a:	ff 75 08             	pushl  0x8(%ebp)
  803e0d:	50                   	push   %eax
  803e0e:	6a 00                	push   $0x0
  803e10:	e8 8d fb ff ff       	call   8039a2 <merging>
  803e15:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e18:	eb 69                	jmp    803e83 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803e1a:	a1 44 60 80 00       	mov    0x806044,%eax
  803e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e22:	eb 39                	jmp    803e5d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e27:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e2a:	73 29                	jae    803e55 <free_block+0x90>
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	8b 00                	mov    (%eax),%eax
  803e31:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e34:	76 1f                	jbe    803e55 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e39:	8b 00                	mov    (%eax),%eax
  803e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803e3e:	83 ec 04             	sub    $0x4,%esp
  803e41:	ff 75 08             	pushl  0x8(%ebp)
  803e44:	ff 75 f0             	pushl  -0x10(%ebp)
  803e47:	ff 75 f4             	pushl  -0xc(%ebp)
  803e4a:	e8 53 fb ff ff       	call   8039a2 <merging>
  803e4f:	83 c4 10             	add    $0x10,%esp
			break;
  803e52:	90                   	nop
		}
	}
}
  803e53:	eb 2e                	jmp    803e83 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803e55:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e61:	74 07                	je     803e6a <free_block+0xa5>
  803e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e66:	8b 00                	mov    (%eax),%eax
  803e68:	eb 05                	jmp    803e6f <free_block+0xaa>
  803e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e74:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803e79:	85 c0                	test   %eax,%eax
  803e7b:	75 a7                	jne    803e24 <free_block+0x5f>
  803e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e81:	75 a1                	jne    803e24 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803e83:	90                   	nop
  803e84:	c9                   	leave  
  803e85:	c3                   	ret    

00803e86 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803e86:	55                   	push   %ebp
  803e87:	89 e5                	mov    %esp,%ebp
  803e89:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803e8c:	ff 75 08             	pushl  0x8(%ebp)
  803e8f:	e8 ed ec ff ff       	call   802b81 <get_block_size>
  803e94:	83 c4 04             	add    $0x4,%esp
  803e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803e9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803ea1:	eb 17                	jmp    803eba <copy_data+0x34>
  803ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ea9:	01 c2                	add    %eax,%edx
  803eab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803eae:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb1:	01 c8                	add    %ecx,%eax
  803eb3:	8a 00                	mov    (%eax),%al
  803eb5:	88 02                	mov    %al,(%edx)
  803eb7:	ff 45 fc             	incl   -0x4(%ebp)
  803eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ebd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803ec0:	72 e1                	jb     803ea3 <copy_data+0x1d>
}
  803ec2:	90                   	nop
  803ec3:	c9                   	leave  
  803ec4:	c3                   	ret    

00803ec5 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803ec5:	55                   	push   %ebp
  803ec6:	89 e5                	mov    %esp,%ebp
  803ec8:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803ecb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ecf:	75 23                	jne    803ef4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ed1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ed5:	74 13                	je     803eea <realloc_block_FF+0x25>
  803ed7:	83 ec 0c             	sub    $0xc,%esp
  803eda:	ff 75 0c             	pushl  0xc(%ebp)
  803edd:	e8 1f f0 ff ff       	call   802f01 <alloc_block_FF>
  803ee2:	83 c4 10             	add    $0x10,%esp
  803ee5:	e9 f4 06 00 00       	jmp    8045de <realloc_block_FF+0x719>
		return NULL;
  803eea:	b8 00 00 00 00       	mov    $0x0,%eax
  803eef:	e9 ea 06 00 00       	jmp    8045de <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803ef4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ef8:	75 18                	jne    803f12 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803efa:	83 ec 0c             	sub    $0xc,%esp
  803efd:	ff 75 08             	pushl  0x8(%ebp)
  803f00:	e8 c0 fe ff ff       	call   803dc5 <free_block>
  803f05:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803f08:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0d:	e9 cc 06 00 00       	jmp    8045de <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803f12:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803f16:	77 07                	ja     803f1f <realloc_block_FF+0x5a>
  803f18:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f22:	83 e0 01             	and    $0x1,%eax
  803f25:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f2b:	83 c0 08             	add    $0x8,%eax
  803f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803f31:	83 ec 0c             	sub    $0xc,%esp
  803f34:	ff 75 08             	pushl  0x8(%ebp)
  803f37:	e8 45 ec ff ff       	call   802b81 <get_block_size>
  803f3c:	83 c4 10             	add    $0x10,%esp
  803f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f45:	83 e8 08             	sub    $0x8,%eax
  803f48:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4e:	83 e8 04             	sub    $0x4,%eax
  803f51:	8b 00                	mov    (%eax),%eax
  803f53:	83 e0 fe             	and    $0xfffffffe,%eax
  803f56:	89 c2                	mov    %eax,%edx
  803f58:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5b:	01 d0                	add    %edx,%eax
  803f5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803f60:	83 ec 0c             	sub    $0xc,%esp
  803f63:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f66:	e8 16 ec ff ff       	call   802b81 <get_block_size>
  803f6b:	83 c4 10             	add    $0x10,%esp
  803f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f74:	83 e8 08             	sub    $0x8,%eax
  803f77:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f80:	75 08                	jne    803f8a <realloc_block_FF+0xc5>
	{
		 return va;
  803f82:	8b 45 08             	mov    0x8(%ebp),%eax
  803f85:	e9 54 06 00 00       	jmp    8045de <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f8d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f90:	0f 83 e5 03 00 00    	jae    80437b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f99:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803f9f:	83 ec 0c             	sub    $0xc,%esp
  803fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fa5:	e8 f0 eb ff ff       	call   802b9a <is_free_block>
  803faa:	83 c4 10             	add    $0x10,%esp
  803fad:	84 c0                	test   %al,%al
  803faf:	0f 84 3b 01 00 00    	je     8040f0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803fb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fbb:	01 d0                	add    %edx,%eax
  803fbd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803fc0:	83 ec 04             	sub    $0x4,%esp
  803fc3:	6a 01                	push   $0x1
  803fc5:	ff 75 f0             	pushl  -0x10(%ebp)
  803fc8:	ff 75 08             	pushl  0x8(%ebp)
  803fcb:	e8 02 ef ff ff       	call   802ed2 <set_block_data>
  803fd0:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd6:	83 e8 04             	sub    $0x4,%eax
  803fd9:	8b 00                	mov    (%eax),%eax
  803fdb:	83 e0 fe             	and    $0xfffffffe,%eax
  803fde:	89 c2                	mov    %eax,%edx
  803fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe3:	01 d0                	add    %edx,%eax
  803fe5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803fe8:	83 ec 04             	sub    $0x4,%esp
  803feb:	6a 00                	push   $0x0
  803fed:	ff 75 cc             	pushl  -0x34(%ebp)
  803ff0:	ff 75 c8             	pushl  -0x38(%ebp)
  803ff3:	e8 da ee ff ff       	call   802ed2 <set_block_data>
  803ff8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ffb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fff:	74 06                	je     804007 <realloc_block_FF+0x142>
  804001:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804005:	75 17                	jne    80401e <realloc_block_FF+0x159>
  804007:	83 ec 04             	sub    $0x4,%esp
  80400a:	68 80 58 80 00       	push   $0x805880
  80400f:	68 f6 01 00 00       	push   $0x1f6
  804014:	68 0d 58 80 00       	push   $0x80580d
  804019:	e8 73 d0 ff ff       	call   801091 <_panic>
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	8b 10                	mov    (%eax),%edx
  804023:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804026:	89 10                	mov    %edx,(%eax)
  804028:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80402b:	8b 00                	mov    (%eax),%eax
  80402d:	85 c0                	test   %eax,%eax
  80402f:	74 0b                	je     80403c <realloc_block_FF+0x177>
  804031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804034:	8b 00                	mov    (%eax),%eax
  804036:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804039:	89 50 04             	mov    %edx,0x4(%eax)
  80403c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804042:	89 10                	mov    %edx,(%eax)
  804044:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804047:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404a:	89 50 04             	mov    %edx,0x4(%eax)
  80404d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804050:	8b 00                	mov    (%eax),%eax
  804052:	85 c0                	test   %eax,%eax
  804054:	75 08                	jne    80405e <realloc_block_FF+0x199>
  804056:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804059:	a3 48 60 80 00       	mov    %eax,0x806048
  80405e:	a1 50 60 80 00       	mov    0x806050,%eax
  804063:	40                   	inc    %eax
  804064:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80406d:	75 17                	jne    804086 <realloc_block_FF+0x1c1>
  80406f:	83 ec 04             	sub    $0x4,%esp
  804072:	68 ef 57 80 00       	push   $0x8057ef
  804077:	68 f7 01 00 00       	push   $0x1f7
  80407c:	68 0d 58 80 00       	push   $0x80580d
  804081:	e8 0b d0 ff ff       	call   801091 <_panic>
  804086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804089:	8b 00                	mov    (%eax),%eax
  80408b:	85 c0                	test   %eax,%eax
  80408d:	74 10                	je     80409f <realloc_block_FF+0x1da>
  80408f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804092:	8b 00                	mov    (%eax),%eax
  804094:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804097:	8b 52 04             	mov    0x4(%edx),%edx
  80409a:	89 50 04             	mov    %edx,0x4(%eax)
  80409d:	eb 0b                	jmp    8040aa <realloc_block_FF+0x1e5>
  80409f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a2:	8b 40 04             	mov    0x4(%eax),%eax
  8040a5:	a3 48 60 80 00       	mov    %eax,0x806048
  8040aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ad:	8b 40 04             	mov    0x4(%eax),%eax
  8040b0:	85 c0                	test   %eax,%eax
  8040b2:	74 0f                	je     8040c3 <realloc_block_FF+0x1fe>
  8040b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b7:	8b 40 04             	mov    0x4(%eax),%eax
  8040ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040bd:	8b 12                	mov    (%edx),%edx
  8040bf:	89 10                	mov    %edx,(%eax)
  8040c1:	eb 0a                	jmp    8040cd <realloc_block_FF+0x208>
  8040c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c6:	8b 00                	mov    (%eax),%eax
  8040c8:	a3 44 60 80 00       	mov    %eax,0x806044
  8040cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e0:	a1 50 60 80 00       	mov    0x806050,%eax
  8040e5:	48                   	dec    %eax
  8040e6:	a3 50 60 80 00       	mov    %eax,0x806050
  8040eb:	e9 83 02 00 00       	jmp    804373 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8040f0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8040f4:	0f 86 69 02 00 00    	jbe    804363 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8040fa:	83 ec 04             	sub    $0x4,%esp
  8040fd:	6a 01                	push   $0x1
  8040ff:	ff 75 f0             	pushl  -0x10(%ebp)
  804102:	ff 75 08             	pushl  0x8(%ebp)
  804105:	e8 c8 ed ff ff       	call   802ed2 <set_block_data>
  80410a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80410d:	8b 45 08             	mov    0x8(%ebp),%eax
  804110:	83 e8 04             	sub    $0x4,%eax
  804113:	8b 00                	mov    (%eax),%eax
  804115:	83 e0 fe             	and    $0xfffffffe,%eax
  804118:	89 c2                	mov    %eax,%edx
  80411a:	8b 45 08             	mov    0x8(%ebp),%eax
  80411d:	01 d0                	add    %edx,%eax
  80411f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804122:	a1 50 60 80 00       	mov    0x806050,%eax
  804127:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80412a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80412e:	75 68                	jne    804198 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804130:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804134:	75 17                	jne    80414d <realloc_block_FF+0x288>
  804136:	83 ec 04             	sub    $0x4,%esp
  804139:	68 28 58 80 00       	push   $0x805828
  80413e:	68 06 02 00 00       	push   $0x206
  804143:	68 0d 58 80 00       	push   $0x80580d
  804148:	e8 44 cf ff ff       	call   801091 <_panic>
  80414d:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804153:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804156:	89 10                	mov    %edx,(%eax)
  804158:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80415b:	8b 00                	mov    (%eax),%eax
  80415d:	85 c0                	test   %eax,%eax
  80415f:	74 0d                	je     80416e <realloc_block_FF+0x2a9>
  804161:	a1 44 60 80 00       	mov    0x806044,%eax
  804166:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804169:	89 50 04             	mov    %edx,0x4(%eax)
  80416c:	eb 08                	jmp    804176 <realloc_block_FF+0x2b1>
  80416e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804171:	a3 48 60 80 00       	mov    %eax,0x806048
  804176:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804179:	a3 44 60 80 00       	mov    %eax,0x806044
  80417e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804188:	a1 50 60 80 00       	mov    0x806050,%eax
  80418d:	40                   	inc    %eax
  80418e:	a3 50 60 80 00       	mov    %eax,0x806050
  804193:	e9 b0 01 00 00       	jmp    804348 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804198:	a1 44 60 80 00       	mov    0x806044,%eax
  80419d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041a0:	76 68                	jbe    80420a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8041a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041a6:	75 17                	jne    8041bf <realloc_block_FF+0x2fa>
  8041a8:	83 ec 04             	sub    $0x4,%esp
  8041ab:	68 28 58 80 00       	push   $0x805828
  8041b0:	68 0b 02 00 00       	push   $0x20b
  8041b5:	68 0d 58 80 00       	push   $0x80580d
  8041ba:	e8 d2 ce ff ff       	call   801091 <_panic>
  8041bf:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8041c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c8:	89 10                	mov    %edx,(%eax)
  8041ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041cd:	8b 00                	mov    (%eax),%eax
  8041cf:	85 c0                	test   %eax,%eax
  8041d1:	74 0d                	je     8041e0 <realloc_block_FF+0x31b>
  8041d3:	a1 44 60 80 00       	mov    0x806044,%eax
  8041d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041db:	89 50 04             	mov    %edx,0x4(%eax)
  8041de:	eb 08                	jmp    8041e8 <realloc_block_FF+0x323>
  8041e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e3:	a3 48 60 80 00       	mov    %eax,0x806048
  8041e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041eb:	a3 44 60 80 00       	mov    %eax,0x806044
  8041f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041fa:	a1 50 60 80 00       	mov    0x806050,%eax
  8041ff:	40                   	inc    %eax
  804200:	a3 50 60 80 00       	mov    %eax,0x806050
  804205:	e9 3e 01 00 00       	jmp    804348 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80420a:	a1 44 60 80 00       	mov    0x806044,%eax
  80420f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804212:	73 68                	jae    80427c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804214:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804218:	75 17                	jne    804231 <realloc_block_FF+0x36c>
  80421a:	83 ec 04             	sub    $0x4,%esp
  80421d:	68 5c 58 80 00       	push   $0x80585c
  804222:	68 10 02 00 00       	push   $0x210
  804227:	68 0d 58 80 00       	push   $0x80580d
  80422c:	e8 60 ce ff ff       	call   801091 <_panic>
  804231:	8b 15 48 60 80 00    	mov    0x806048,%edx
  804237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80423a:	89 50 04             	mov    %edx,0x4(%eax)
  80423d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804240:	8b 40 04             	mov    0x4(%eax),%eax
  804243:	85 c0                	test   %eax,%eax
  804245:	74 0c                	je     804253 <realloc_block_FF+0x38e>
  804247:	a1 48 60 80 00       	mov    0x806048,%eax
  80424c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80424f:	89 10                	mov    %edx,(%eax)
  804251:	eb 08                	jmp    80425b <realloc_block_FF+0x396>
  804253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804256:	a3 44 60 80 00       	mov    %eax,0x806044
  80425b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80425e:	a3 48 60 80 00       	mov    %eax,0x806048
  804263:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80426c:	a1 50 60 80 00       	mov    0x806050,%eax
  804271:	40                   	inc    %eax
  804272:	a3 50 60 80 00       	mov    %eax,0x806050
  804277:	e9 cc 00 00 00       	jmp    804348 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80427c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804283:	a1 44 60 80 00       	mov    0x806044,%eax
  804288:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80428b:	e9 8a 00 00 00       	jmp    80431a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804293:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804296:	73 7a                	jae    804312 <realloc_block_FF+0x44d>
  804298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429b:	8b 00                	mov    (%eax),%eax
  80429d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042a0:	73 70                	jae    804312 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8042a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042a6:	74 06                	je     8042ae <realloc_block_FF+0x3e9>
  8042a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042ac:	75 17                	jne    8042c5 <realloc_block_FF+0x400>
  8042ae:	83 ec 04             	sub    $0x4,%esp
  8042b1:	68 80 58 80 00       	push   $0x805880
  8042b6:	68 1a 02 00 00       	push   $0x21a
  8042bb:	68 0d 58 80 00       	push   $0x80580d
  8042c0:	e8 cc cd ff ff       	call   801091 <_panic>
  8042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c8:	8b 10                	mov    (%eax),%edx
  8042ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042cd:	89 10                	mov    %edx,(%eax)
  8042cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042d2:	8b 00                	mov    (%eax),%eax
  8042d4:	85 c0                	test   %eax,%eax
  8042d6:	74 0b                	je     8042e3 <realloc_block_FF+0x41e>
  8042d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042db:	8b 00                	mov    (%eax),%eax
  8042dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042e0:	89 50 04             	mov    %edx,0x4(%eax)
  8042e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042e9:	89 10                	mov    %edx,(%eax)
  8042eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042f1:	89 50 04             	mov    %edx,0x4(%eax)
  8042f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f7:	8b 00                	mov    (%eax),%eax
  8042f9:	85 c0                	test   %eax,%eax
  8042fb:	75 08                	jne    804305 <realloc_block_FF+0x440>
  8042fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804300:	a3 48 60 80 00       	mov    %eax,0x806048
  804305:	a1 50 60 80 00       	mov    0x806050,%eax
  80430a:	40                   	inc    %eax
  80430b:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  804310:	eb 36                	jmp    804348 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804312:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80431a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80431e:	74 07                	je     804327 <realloc_block_FF+0x462>
  804320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804323:	8b 00                	mov    (%eax),%eax
  804325:	eb 05                	jmp    80432c <realloc_block_FF+0x467>
  804327:	b8 00 00 00 00       	mov    $0x0,%eax
  80432c:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804331:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804336:	85 c0                	test   %eax,%eax
  804338:	0f 85 52 ff ff ff    	jne    804290 <realloc_block_FF+0x3cb>
  80433e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804342:	0f 85 48 ff ff ff    	jne    804290 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804348:	83 ec 04             	sub    $0x4,%esp
  80434b:	6a 00                	push   $0x0
  80434d:	ff 75 d8             	pushl  -0x28(%ebp)
  804350:	ff 75 d4             	pushl  -0x2c(%ebp)
  804353:	e8 7a eb ff ff       	call   802ed2 <set_block_data>
  804358:	83 c4 10             	add    $0x10,%esp
				return va;
  80435b:	8b 45 08             	mov    0x8(%ebp),%eax
  80435e:	e9 7b 02 00 00       	jmp    8045de <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804363:	83 ec 0c             	sub    $0xc,%esp
  804366:	68 fd 58 80 00       	push   $0x8058fd
  80436b:	e8 de cf ff ff       	call   80134e <cprintf>
  804370:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804373:	8b 45 08             	mov    0x8(%ebp),%eax
  804376:	e9 63 02 00 00       	jmp    8045de <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80437b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80437e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804381:	0f 86 4d 02 00 00    	jbe    8045d4 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804387:	83 ec 0c             	sub    $0xc,%esp
  80438a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80438d:	e8 08 e8 ff ff       	call   802b9a <is_free_block>
  804392:	83 c4 10             	add    $0x10,%esp
  804395:	84 c0                	test   %al,%al
  804397:	0f 84 37 02 00 00    	je     8045d4 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80439d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043a0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8043a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8043a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8043a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8043ac:	76 38                	jbe    8043e6 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8043ae:	83 ec 0c             	sub    $0xc,%esp
  8043b1:	ff 75 08             	pushl  0x8(%ebp)
  8043b4:	e8 0c fa ff ff       	call   803dc5 <free_block>
  8043b9:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8043bc:	83 ec 0c             	sub    $0xc,%esp
  8043bf:	ff 75 0c             	pushl  0xc(%ebp)
  8043c2:	e8 3a eb ff ff       	call   802f01 <alloc_block_FF>
  8043c7:	83 c4 10             	add    $0x10,%esp
  8043ca:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8043cd:	83 ec 08             	sub    $0x8,%esp
  8043d0:	ff 75 c0             	pushl  -0x40(%ebp)
  8043d3:	ff 75 08             	pushl  0x8(%ebp)
  8043d6:	e8 ab fa ff ff       	call   803e86 <copy_data>
  8043db:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8043de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8043e1:	e9 f8 01 00 00       	jmp    8045de <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8043e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043e9:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8043ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8043ef:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8043f3:	0f 87 a0 00 00 00    	ja     804499 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8043f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8043fd:	75 17                	jne    804416 <realloc_block_FF+0x551>
  8043ff:	83 ec 04             	sub    $0x4,%esp
  804402:	68 ef 57 80 00       	push   $0x8057ef
  804407:	68 38 02 00 00       	push   $0x238
  80440c:	68 0d 58 80 00       	push   $0x80580d
  804411:	e8 7b cc ff ff       	call   801091 <_panic>
  804416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804419:	8b 00                	mov    (%eax),%eax
  80441b:	85 c0                	test   %eax,%eax
  80441d:	74 10                	je     80442f <realloc_block_FF+0x56a>
  80441f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804422:	8b 00                	mov    (%eax),%eax
  804424:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804427:	8b 52 04             	mov    0x4(%edx),%edx
  80442a:	89 50 04             	mov    %edx,0x4(%eax)
  80442d:	eb 0b                	jmp    80443a <realloc_block_FF+0x575>
  80442f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804432:	8b 40 04             	mov    0x4(%eax),%eax
  804435:	a3 48 60 80 00       	mov    %eax,0x806048
  80443a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80443d:	8b 40 04             	mov    0x4(%eax),%eax
  804440:	85 c0                	test   %eax,%eax
  804442:	74 0f                	je     804453 <realloc_block_FF+0x58e>
  804444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804447:	8b 40 04             	mov    0x4(%eax),%eax
  80444a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80444d:	8b 12                	mov    (%edx),%edx
  80444f:	89 10                	mov    %edx,(%eax)
  804451:	eb 0a                	jmp    80445d <realloc_block_FF+0x598>
  804453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804456:	8b 00                	mov    (%eax),%eax
  804458:	a3 44 60 80 00       	mov    %eax,0x806044
  80445d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804469:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804470:	a1 50 60 80 00       	mov    0x806050,%eax
  804475:	48                   	dec    %eax
  804476:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80447b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80447e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804481:	01 d0                	add    %edx,%eax
  804483:	83 ec 04             	sub    $0x4,%esp
  804486:	6a 01                	push   $0x1
  804488:	50                   	push   %eax
  804489:	ff 75 08             	pushl  0x8(%ebp)
  80448c:	e8 41 ea ff ff       	call   802ed2 <set_block_data>
  804491:	83 c4 10             	add    $0x10,%esp
  804494:	e9 36 01 00 00       	jmp    8045cf <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804499:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80449c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80449f:	01 d0                	add    %edx,%eax
  8044a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8044a4:	83 ec 04             	sub    $0x4,%esp
  8044a7:	6a 01                	push   $0x1
  8044a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8044ac:	ff 75 08             	pushl  0x8(%ebp)
  8044af:	e8 1e ea ff ff       	call   802ed2 <set_block_data>
  8044b4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8044b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ba:	83 e8 04             	sub    $0x4,%eax
  8044bd:	8b 00                	mov    (%eax),%eax
  8044bf:	83 e0 fe             	and    $0xfffffffe,%eax
  8044c2:	89 c2                	mov    %eax,%edx
  8044c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c7:	01 d0                	add    %edx,%eax
  8044c9:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8044cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044d0:	74 06                	je     8044d8 <realloc_block_FF+0x613>
  8044d2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8044d6:	75 17                	jne    8044ef <realloc_block_FF+0x62a>
  8044d8:	83 ec 04             	sub    $0x4,%esp
  8044db:	68 80 58 80 00       	push   $0x805880
  8044e0:	68 44 02 00 00       	push   $0x244
  8044e5:	68 0d 58 80 00       	push   $0x80580d
  8044ea:	e8 a2 cb ff ff       	call   801091 <_panic>
  8044ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f2:	8b 10                	mov    (%eax),%edx
  8044f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044f7:	89 10                	mov    %edx,(%eax)
  8044f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8044fc:	8b 00                	mov    (%eax),%eax
  8044fe:	85 c0                	test   %eax,%eax
  804500:	74 0b                	je     80450d <realloc_block_FF+0x648>
  804502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804505:	8b 00                	mov    (%eax),%eax
  804507:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80450a:	89 50 04             	mov    %edx,0x4(%eax)
  80450d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804510:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804513:	89 10                	mov    %edx,(%eax)
  804515:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804518:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80451b:	89 50 04             	mov    %edx,0x4(%eax)
  80451e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804521:	8b 00                	mov    (%eax),%eax
  804523:	85 c0                	test   %eax,%eax
  804525:	75 08                	jne    80452f <realloc_block_FF+0x66a>
  804527:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80452a:	a3 48 60 80 00       	mov    %eax,0x806048
  80452f:	a1 50 60 80 00       	mov    0x806050,%eax
  804534:	40                   	inc    %eax
  804535:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80453a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80453e:	75 17                	jne    804557 <realloc_block_FF+0x692>
  804540:	83 ec 04             	sub    $0x4,%esp
  804543:	68 ef 57 80 00       	push   $0x8057ef
  804548:	68 45 02 00 00       	push   $0x245
  80454d:	68 0d 58 80 00       	push   $0x80580d
  804552:	e8 3a cb ff ff       	call   801091 <_panic>
  804557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80455a:	8b 00                	mov    (%eax),%eax
  80455c:	85 c0                	test   %eax,%eax
  80455e:	74 10                	je     804570 <realloc_block_FF+0x6ab>
  804560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804563:	8b 00                	mov    (%eax),%eax
  804565:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804568:	8b 52 04             	mov    0x4(%edx),%edx
  80456b:	89 50 04             	mov    %edx,0x4(%eax)
  80456e:	eb 0b                	jmp    80457b <realloc_block_FF+0x6b6>
  804570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804573:	8b 40 04             	mov    0x4(%eax),%eax
  804576:	a3 48 60 80 00       	mov    %eax,0x806048
  80457b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80457e:	8b 40 04             	mov    0x4(%eax),%eax
  804581:	85 c0                	test   %eax,%eax
  804583:	74 0f                	je     804594 <realloc_block_FF+0x6cf>
  804585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804588:	8b 40 04             	mov    0x4(%eax),%eax
  80458b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80458e:	8b 12                	mov    (%edx),%edx
  804590:	89 10                	mov    %edx,(%eax)
  804592:	eb 0a                	jmp    80459e <realloc_block_FF+0x6d9>
  804594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804597:	8b 00                	mov    (%eax),%eax
  804599:	a3 44 60 80 00       	mov    %eax,0x806044
  80459e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045b1:	a1 50 60 80 00       	mov    0x806050,%eax
  8045b6:	48                   	dec    %eax
  8045b7:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  8045bc:	83 ec 04             	sub    $0x4,%esp
  8045bf:	6a 00                	push   $0x0
  8045c1:	ff 75 bc             	pushl  -0x44(%ebp)
  8045c4:	ff 75 b8             	pushl  -0x48(%ebp)
  8045c7:	e8 06 e9 ff ff       	call   802ed2 <set_block_data>
  8045cc:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8045cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d2:	eb 0a                	jmp    8045de <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8045d4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8045db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8045de:	c9                   	leave  
  8045df:	c3                   	ret    

008045e0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8045e0:	55                   	push   %ebp
  8045e1:	89 e5                	mov    %esp,%ebp
  8045e3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8045e6:	83 ec 04             	sub    $0x4,%esp
  8045e9:	68 04 59 80 00       	push   $0x805904
  8045ee:	68 58 02 00 00       	push   $0x258
  8045f3:	68 0d 58 80 00       	push   $0x80580d
  8045f8:	e8 94 ca ff ff       	call   801091 <_panic>

008045fd <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8045fd:	55                   	push   %ebp
  8045fe:	89 e5                	mov    %esp,%ebp
  804600:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804603:	83 ec 04             	sub    $0x4,%esp
  804606:	68 2c 59 80 00       	push   $0x80592c
  80460b:	68 61 02 00 00       	push   $0x261
  804610:	68 0d 58 80 00       	push   $0x80580d
  804615:	e8 77 ca ff ff       	call   801091 <_panic>
  80461a:	66 90                	xchg   %ax,%ax

0080461c <__udivdi3>:
  80461c:	55                   	push   %ebp
  80461d:	57                   	push   %edi
  80461e:	56                   	push   %esi
  80461f:	53                   	push   %ebx
  804620:	83 ec 1c             	sub    $0x1c,%esp
  804623:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804627:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80462b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80462f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804633:	89 ca                	mov    %ecx,%edx
  804635:	89 f8                	mov    %edi,%eax
  804637:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80463b:	85 f6                	test   %esi,%esi
  80463d:	75 2d                	jne    80466c <__udivdi3+0x50>
  80463f:	39 cf                	cmp    %ecx,%edi
  804641:	77 65                	ja     8046a8 <__udivdi3+0x8c>
  804643:	89 fd                	mov    %edi,%ebp
  804645:	85 ff                	test   %edi,%edi
  804647:	75 0b                	jne    804654 <__udivdi3+0x38>
  804649:	b8 01 00 00 00       	mov    $0x1,%eax
  80464e:	31 d2                	xor    %edx,%edx
  804650:	f7 f7                	div    %edi
  804652:	89 c5                	mov    %eax,%ebp
  804654:	31 d2                	xor    %edx,%edx
  804656:	89 c8                	mov    %ecx,%eax
  804658:	f7 f5                	div    %ebp
  80465a:	89 c1                	mov    %eax,%ecx
  80465c:	89 d8                	mov    %ebx,%eax
  80465e:	f7 f5                	div    %ebp
  804660:	89 cf                	mov    %ecx,%edi
  804662:	89 fa                	mov    %edi,%edx
  804664:	83 c4 1c             	add    $0x1c,%esp
  804667:	5b                   	pop    %ebx
  804668:	5e                   	pop    %esi
  804669:	5f                   	pop    %edi
  80466a:	5d                   	pop    %ebp
  80466b:	c3                   	ret    
  80466c:	39 ce                	cmp    %ecx,%esi
  80466e:	77 28                	ja     804698 <__udivdi3+0x7c>
  804670:	0f bd fe             	bsr    %esi,%edi
  804673:	83 f7 1f             	xor    $0x1f,%edi
  804676:	75 40                	jne    8046b8 <__udivdi3+0x9c>
  804678:	39 ce                	cmp    %ecx,%esi
  80467a:	72 0a                	jb     804686 <__udivdi3+0x6a>
  80467c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804680:	0f 87 9e 00 00 00    	ja     804724 <__udivdi3+0x108>
  804686:	b8 01 00 00 00       	mov    $0x1,%eax
  80468b:	89 fa                	mov    %edi,%edx
  80468d:	83 c4 1c             	add    $0x1c,%esp
  804690:	5b                   	pop    %ebx
  804691:	5e                   	pop    %esi
  804692:	5f                   	pop    %edi
  804693:	5d                   	pop    %ebp
  804694:	c3                   	ret    
  804695:	8d 76 00             	lea    0x0(%esi),%esi
  804698:	31 ff                	xor    %edi,%edi
  80469a:	31 c0                	xor    %eax,%eax
  80469c:	89 fa                	mov    %edi,%edx
  80469e:	83 c4 1c             	add    $0x1c,%esp
  8046a1:	5b                   	pop    %ebx
  8046a2:	5e                   	pop    %esi
  8046a3:	5f                   	pop    %edi
  8046a4:	5d                   	pop    %ebp
  8046a5:	c3                   	ret    
  8046a6:	66 90                	xchg   %ax,%ax
  8046a8:	89 d8                	mov    %ebx,%eax
  8046aa:	f7 f7                	div    %edi
  8046ac:	31 ff                	xor    %edi,%edi
  8046ae:	89 fa                	mov    %edi,%edx
  8046b0:	83 c4 1c             	add    $0x1c,%esp
  8046b3:	5b                   	pop    %ebx
  8046b4:	5e                   	pop    %esi
  8046b5:	5f                   	pop    %edi
  8046b6:	5d                   	pop    %ebp
  8046b7:	c3                   	ret    
  8046b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046bd:	89 eb                	mov    %ebp,%ebx
  8046bf:	29 fb                	sub    %edi,%ebx
  8046c1:	89 f9                	mov    %edi,%ecx
  8046c3:	d3 e6                	shl    %cl,%esi
  8046c5:	89 c5                	mov    %eax,%ebp
  8046c7:	88 d9                	mov    %bl,%cl
  8046c9:	d3 ed                	shr    %cl,%ebp
  8046cb:	89 e9                	mov    %ebp,%ecx
  8046cd:	09 f1                	or     %esi,%ecx
  8046cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046d3:	89 f9                	mov    %edi,%ecx
  8046d5:	d3 e0                	shl    %cl,%eax
  8046d7:	89 c5                	mov    %eax,%ebp
  8046d9:	89 d6                	mov    %edx,%esi
  8046db:	88 d9                	mov    %bl,%cl
  8046dd:	d3 ee                	shr    %cl,%esi
  8046df:	89 f9                	mov    %edi,%ecx
  8046e1:	d3 e2                	shl    %cl,%edx
  8046e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046e7:	88 d9                	mov    %bl,%cl
  8046e9:	d3 e8                	shr    %cl,%eax
  8046eb:	09 c2                	or     %eax,%edx
  8046ed:	89 d0                	mov    %edx,%eax
  8046ef:	89 f2                	mov    %esi,%edx
  8046f1:	f7 74 24 0c          	divl   0xc(%esp)
  8046f5:	89 d6                	mov    %edx,%esi
  8046f7:	89 c3                	mov    %eax,%ebx
  8046f9:	f7 e5                	mul    %ebp
  8046fb:	39 d6                	cmp    %edx,%esi
  8046fd:	72 19                	jb     804718 <__udivdi3+0xfc>
  8046ff:	74 0b                	je     80470c <__udivdi3+0xf0>
  804701:	89 d8                	mov    %ebx,%eax
  804703:	31 ff                	xor    %edi,%edi
  804705:	e9 58 ff ff ff       	jmp    804662 <__udivdi3+0x46>
  80470a:	66 90                	xchg   %ax,%ax
  80470c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804710:	89 f9                	mov    %edi,%ecx
  804712:	d3 e2                	shl    %cl,%edx
  804714:	39 c2                	cmp    %eax,%edx
  804716:	73 e9                	jae    804701 <__udivdi3+0xe5>
  804718:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80471b:	31 ff                	xor    %edi,%edi
  80471d:	e9 40 ff ff ff       	jmp    804662 <__udivdi3+0x46>
  804722:	66 90                	xchg   %ax,%ax
  804724:	31 c0                	xor    %eax,%eax
  804726:	e9 37 ff ff ff       	jmp    804662 <__udivdi3+0x46>
  80472b:	90                   	nop

0080472c <__umoddi3>:
  80472c:	55                   	push   %ebp
  80472d:	57                   	push   %edi
  80472e:	56                   	push   %esi
  80472f:	53                   	push   %ebx
  804730:	83 ec 1c             	sub    $0x1c,%esp
  804733:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804737:	8b 74 24 34          	mov    0x34(%esp),%esi
  80473b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80473f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804743:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804747:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80474b:	89 f3                	mov    %esi,%ebx
  80474d:	89 fa                	mov    %edi,%edx
  80474f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804753:	89 34 24             	mov    %esi,(%esp)
  804756:	85 c0                	test   %eax,%eax
  804758:	75 1a                	jne    804774 <__umoddi3+0x48>
  80475a:	39 f7                	cmp    %esi,%edi
  80475c:	0f 86 a2 00 00 00    	jbe    804804 <__umoddi3+0xd8>
  804762:	89 c8                	mov    %ecx,%eax
  804764:	89 f2                	mov    %esi,%edx
  804766:	f7 f7                	div    %edi
  804768:	89 d0                	mov    %edx,%eax
  80476a:	31 d2                	xor    %edx,%edx
  80476c:	83 c4 1c             	add    $0x1c,%esp
  80476f:	5b                   	pop    %ebx
  804770:	5e                   	pop    %esi
  804771:	5f                   	pop    %edi
  804772:	5d                   	pop    %ebp
  804773:	c3                   	ret    
  804774:	39 f0                	cmp    %esi,%eax
  804776:	0f 87 ac 00 00 00    	ja     804828 <__umoddi3+0xfc>
  80477c:	0f bd e8             	bsr    %eax,%ebp
  80477f:	83 f5 1f             	xor    $0x1f,%ebp
  804782:	0f 84 ac 00 00 00    	je     804834 <__umoddi3+0x108>
  804788:	bf 20 00 00 00       	mov    $0x20,%edi
  80478d:	29 ef                	sub    %ebp,%edi
  80478f:	89 fe                	mov    %edi,%esi
  804791:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804795:	89 e9                	mov    %ebp,%ecx
  804797:	d3 e0                	shl    %cl,%eax
  804799:	89 d7                	mov    %edx,%edi
  80479b:	89 f1                	mov    %esi,%ecx
  80479d:	d3 ef                	shr    %cl,%edi
  80479f:	09 c7                	or     %eax,%edi
  8047a1:	89 e9                	mov    %ebp,%ecx
  8047a3:	d3 e2                	shl    %cl,%edx
  8047a5:	89 14 24             	mov    %edx,(%esp)
  8047a8:	89 d8                	mov    %ebx,%eax
  8047aa:	d3 e0                	shl    %cl,%eax
  8047ac:	89 c2                	mov    %eax,%edx
  8047ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047b2:	d3 e0                	shl    %cl,%eax
  8047b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047bc:	89 f1                	mov    %esi,%ecx
  8047be:	d3 e8                	shr    %cl,%eax
  8047c0:	09 d0                	or     %edx,%eax
  8047c2:	d3 eb                	shr    %cl,%ebx
  8047c4:	89 da                	mov    %ebx,%edx
  8047c6:	f7 f7                	div    %edi
  8047c8:	89 d3                	mov    %edx,%ebx
  8047ca:	f7 24 24             	mull   (%esp)
  8047cd:	89 c6                	mov    %eax,%esi
  8047cf:	89 d1                	mov    %edx,%ecx
  8047d1:	39 d3                	cmp    %edx,%ebx
  8047d3:	0f 82 87 00 00 00    	jb     804860 <__umoddi3+0x134>
  8047d9:	0f 84 91 00 00 00    	je     804870 <__umoddi3+0x144>
  8047df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047e3:	29 f2                	sub    %esi,%edx
  8047e5:	19 cb                	sbb    %ecx,%ebx
  8047e7:	89 d8                	mov    %ebx,%eax
  8047e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047ed:	d3 e0                	shl    %cl,%eax
  8047ef:	89 e9                	mov    %ebp,%ecx
  8047f1:	d3 ea                	shr    %cl,%edx
  8047f3:	09 d0                	or     %edx,%eax
  8047f5:	89 e9                	mov    %ebp,%ecx
  8047f7:	d3 eb                	shr    %cl,%ebx
  8047f9:	89 da                	mov    %ebx,%edx
  8047fb:	83 c4 1c             	add    $0x1c,%esp
  8047fe:	5b                   	pop    %ebx
  8047ff:	5e                   	pop    %esi
  804800:	5f                   	pop    %edi
  804801:	5d                   	pop    %ebp
  804802:	c3                   	ret    
  804803:	90                   	nop
  804804:	89 fd                	mov    %edi,%ebp
  804806:	85 ff                	test   %edi,%edi
  804808:	75 0b                	jne    804815 <__umoddi3+0xe9>
  80480a:	b8 01 00 00 00       	mov    $0x1,%eax
  80480f:	31 d2                	xor    %edx,%edx
  804811:	f7 f7                	div    %edi
  804813:	89 c5                	mov    %eax,%ebp
  804815:	89 f0                	mov    %esi,%eax
  804817:	31 d2                	xor    %edx,%edx
  804819:	f7 f5                	div    %ebp
  80481b:	89 c8                	mov    %ecx,%eax
  80481d:	f7 f5                	div    %ebp
  80481f:	89 d0                	mov    %edx,%eax
  804821:	e9 44 ff ff ff       	jmp    80476a <__umoddi3+0x3e>
  804826:	66 90                	xchg   %ax,%ax
  804828:	89 c8                	mov    %ecx,%eax
  80482a:	89 f2                	mov    %esi,%edx
  80482c:	83 c4 1c             	add    $0x1c,%esp
  80482f:	5b                   	pop    %ebx
  804830:	5e                   	pop    %esi
  804831:	5f                   	pop    %edi
  804832:	5d                   	pop    %ebp
  804833:	c3                   	ret    
  804834:	3b 04 24             	cmp    (%esp),%eax
  804837:	72 06                	jb     80483f <__umoddi3+0x113>
  804839:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80483d:	77 0f                	ja     80484e <__umoddi3+0x122>
  80483f:	89 f2                	mov    %esi,%edx
  804841:	29 f9                	sub    %edi,%ecx
  804843:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804847:	89 14 24             	mov    %edx,(%esp)
  80484a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80484e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804852:	8b 14 24             	mov    (%esp),%edx
  804855:	83 c4 1c             	add    $0x1c,%esp
  804858:	5b                   	pop    %ebx
  804859:	5e                   	pop    %esi
  80485a:	5f                   	pop    %edi
  80485b:	5d                   	pop    %ebp
  80485c:	c3                   	ret    
  80485d:	8d 76 00             	lea    0x0(%esi),%esi
  804860:	2b 04 24             	sub    (%esp),%eax
  804863:	19 fa                	sbb    %edi,%edx
  804865:	89 d1                	mov    %edx,%ecx
  804867:	89 c6                	mov    %eax,%esi
  804869:	e9 71 ff ff ff       	jmp    8047df <__umoddi3+0xb3>
  80486e:	66 90                	xchg   %ax,%ax
  804870:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804874:	72 ea                	jb     804860 <__umoddi3+0x134>
  804876:	89 d9                	mov    %ebx,%ecx
  804878:	e9 62 ff ff ff       	jmp    8047df <__umoddi3+0xb3>
