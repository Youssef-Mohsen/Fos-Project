
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
  800055:	68 60 49 80 00       	push   $0x804960
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
  8000a5:	68 90 49 80 00       	push   $0x804990
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
  8000d1:	e8 75 2a 00 00       	call   802b4b <sys_set_uheap_strategy>
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
  8000f6:	68 c9 49 80 00       	push   $0x8049c9
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 e5 49 80 00       	push   $0x8049e5
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
  800123:	e8 70 26 00 00       	call   802798 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 1d 26 00 00       	call   80274d <sys_calculate_free_frames>
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
  80013d:	68 f8 49 80 00       	push   $0x8049f8
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
  8002ac:	68 50 4a 80 00       	push   $0x804a50
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 e5 49 80 00       	push   $0x8049e5
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
  80031b:	68 78 4a 80 00       	push   $0x804a78
  800320:	e8 29 10 00 00       	call   80134e <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 54 29 00 00       	call   802c8d <alloc_block>
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
  80037f:	68 9c 4a 80 00       	push   $0x804a9c
  800384:	6a 7f                	push   $0x7f
  800386:	68 e5 49 80 00       	push   $0x8049e5
  80038b:	e8 01 0d 00 00       	call   801091 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 b8 23 00 00       	call   80274d <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 c4 4a 80 00       	push   $0x804ac4
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
  800443:	68 0c 4b 80 00       	push   $0x804b0c
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
  80049a:	68 2c 4b 80 00       	push   $0x804b2c
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
  8004ee:	68 4c 4b 80 00       	push   $0x804b4c
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
  800538:	68 7c 4b 80 00       	push   $0x804b7c
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
  800552:	68 9c 4b 80 00       	push   $0x804b9c
  800557:	e8 f2 0d 00 00       	call   80134e <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 d7 4b 80 00       	push   $0x804bd7
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
  8005e0:	68 ec 4b 80 00       	push   $0x804bec
  8005e5:	e8 64 0d 00 00       	call   80134e <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 0b 4c 80 00       	push   $0x804c0b
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
  800669:	68 24 4c 80 00       	push   $0x804c24
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
  800683:	68 44 4c 80 00       	push   $0x804c44
  800688:	e8 c1 0c 00 00       	call   80134e <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 7b 4c 80 00       	push   $0x804c7b
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
  800711:	68 90 4c 80 00       	push   $0x804c90
  800716:	e8 33 0c 00 00       	call   80134e <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 af 4c 80 00       	push   $0x804caf
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
  800762:	e8 ef 24 00 00       	call   802c56 <get_block_size>
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
  8007b7:	68 c8 4c 80 00       	push   $0x804cc8
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
  8007d1:	68 e8 4c 80 00       	push   $0x804ce8
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
  80083d:	e8 14 24 00 00       	call   802c56 <get_block_size>
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
  80089b:	68 25 4d 80 00       	push   $0x804d25
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
  8008b5:	68 44 4d 80 00       	push   $0x804d44
  8008ba:	e8 8f 0a 00 00       	call   80134e <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 84 4d 80 00       	push   $0x804d84
  8008ca:	e8 7f 0a 00 00       	call   80134e <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 a9 4d 80 00       	push   $0x804da9
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
  800963:	68 c0 4d 80 00       	push   $0x804dc0
  800968:	e8 e1 09 00 00       	call   80134e <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 f0 4d 80 00       	push   $0x804df0
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
  8009fa:	68 1c 4e 80 00       	push   $0x804e1c
  8009ff:	e8 4a 09 00 00       	call   80134e <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 4c 4e 80 00       	push   $0x804e4c
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
  800a68:	68 8c 4e 80 00       	push   $0x804e8c
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
  800a82:	68 bc 4e 80 00       	push   $0x804ebc
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
  800b11:	68 e8 4e 80 00       	push   $0x804ee8
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
  800b2b:	68 18 4f 80 00       	push   $0x804f18
  800b30:	e8 19 08 00 00       	call   80134e <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 40 4f 80 00       	push   $0x804f40
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
  800bca:	68 60 4f 80 00       	push   $0x804f60
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
  800c3d:	68 90 4f 80 00       	push   $0x804f90
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
  800ca4:	e8 73 20 00 00       	call   802d1c <print_blocks_list>
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
  800ce6:	68 a8 4f 80 00       	push   $0x804fa8
  800ceb:	e8 5e 06 00 00       	call   80134e <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 d8 4f 80 00       	push   $0x804fd8
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
  800d83:	68 10 50 80 00       	push   $0x805010
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
  800d9d:	68 40 50 80 00       	push   $0x805040
  800da2:	e8 a7 05 00 00       	call   80134e <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 97 19 00 00       	call   80274d <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 84 50 80 00       	push   $0x805084
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
  800e7a:	68 f0 50 80 00       	push   $0x8050f0
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
  800efe:	e8 a5 1c 00 00       	call   802ba8 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 2c 51 80 00       	push   $0x80512c
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
  800f3c:	68 70 51 80 00       	push   $0x805170
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
  800f58:	e8 b9 19 00 00       	call   802916 <sys_getenvindex>
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
  800fc6:	e8 cf 16 00 00       	call   80269a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	68 d8 51 80 00       	push   $0x8051d8
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
  800ff6:	68 00 52 80 00       	push   $0x805200
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
  801027:	68 28 52 80 00       	push   $0x805228
  80102c:	e8 1d 03 00 00       	call   80134e <cprintf>
  801031:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801034:	a1 20 60 80 00       	mov    0x806020,%eax
  801039:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	50                   	push   %eax
  801043:	68 80 52 80 00       	push   $0x805280
  801048:	e8 01 03 00 00       	call   80134e <cprintf>
  80104d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	68 d8 51 80 00       	push   $0x8051d8
  801058:	e8 f1 02 00 00       	call   80134e <cprintf>
  80105d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801060:	e8 4f 16 00 00       	call   8026b4 <sys_unlock_cons>
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
  801078:	e8 65 18 00 00       	call   8028e2 <sys_destroy_env>
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
  801089:	e8 ba 18 00 00       	call   802948 <sys_exit_env>
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
  8010b2:	68 94 52 80 00       	push   $0x805294
  8010b7:	e8 92 02 00 00       	call   80134e <cprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010bf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	68 99 52 80 00       	push   $0x805299
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
  8010ef:	68 b5 52 80 00       	push   $0x8052b5
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
  80111e:	68 b8 52 80 00       	push   $0x8052b8
  801123:	6a 26                	push   $0x26
  801125:	68 04 53 80 00       	push   $0x805304
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
  8011f3:	68 10 53 80 00       	push   $0x805310
  8011f8:	6a 3a                	push   $0x3a
  8011fa:	68 04 53 80 00       	push   $0x805304
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
  801266:	68 64 53 80 00       	push   $0x805364
  80126b:	6a 44                	push   $0x44
  80126d:	68 04 53 80 00       	push   $0x805304
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
  8012c0:	e8 93 13 00 00       	call   802658 <sys_cputs>
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
  801337:	e8 1c 13 00 00       	call   802658 <sys_cputs>
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
  801381:	e8 14 13 00 00       	call   80269a <sys_lock_cons>
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
  8013a1:	e8 0e 13 00 00       	call   8026b4 <sys_unlock_cons>
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
  8013eb:	e8 00 33 00 00       	call   8046f0 <__udivdi3>
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
  80143b:	e8 c0 33 00 00       	call   804800 <__umoddi3>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	05 d4 55 80 00       	add    $0x8055d4,%eax
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
  801596:	8b 04 85 f8 55 80 00 	mov    0x8055f8(,%eax,4),%eax
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
  801677:	8b 34 9d 40 54 80 00 	mov    0x805440(,%ebx,4),%esi
  80167e:	85 f6                	test   %esi,%esi
  801680:	75 19                	jne    80169b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801682:	53                   	push   %ebx
  801683:	68 e5 55 80 00       	push   $0x8055e5
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
  80169c:	68 ee 55 80 00       	push   $0x8055ee
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
  8016c9:	be f1 55 80 00       	mov    $0x8055f1,%esi
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
  8020d4:	68 68 57 80 00       	push   $0x805768
  8020d9:	68 3f 01 00 00       	push   $0x13f
  8020de:	68 8a 57 80 00       	push   $0x80578a
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
  8020f4:	e8 0a 0b 00 00       	call   802c03 <sys_sbrk>
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
  80216f:	e8 13 09 00 00       	call   802a87 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802174:	85 c0                	test   %eax,%eax
  802176:	74 16                	je     80218e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 53 0e 00 00       	call   802fd6 <alloc_block_FF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	e9 8a 01 00 00       	jmp    802318 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80218e:	e8 25 09 00 00       	call   802ab8 <sys_isUHeapPlacementStrategyBESTFIT>
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 7d 01 00 00    	je     802318 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 ec 12 00 00       	call   803492 <alloc_block_BF>
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
  802307:	e8 2e 09 00 00       	call   802c3a <sys_allocate_user_mem>
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
  80234f:	e8 02 09 00 00       	call   802c56 <get_block_size>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	e8 35 1b 00 00       	call   803e9a <free_block>
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
  8023f7:	e8 22 08 00 00       	call   802c1e <sys_free_user_mem>
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
  802405:	68 98 57 80 00       	push   $0x805798
  80240a:	68 85 00 00 00       	push   $0x85
  80240f:	68 c2 57 80 00       	push   $0x8057c2
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
  80247a:	e8 a6 03 00 00       	call   802825 <sys_createSharedObject>
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
  80249e:	68 ce 57 80 00       	push   $0x8057ce
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
  8024e2:	e8 68 03 00 00       	call   80284f <sys_getSizeOfSharedObject>
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8024ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024f1:	75 07                	jne    8024fa <sget+0x27>
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f8:	eb 7f                	jmp    802579 <sget+0xa6>
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
  80252d:	eb 4a                	jmp    802579 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	ff 75 e8             	pushl  -0x18(%ebp)
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	e8 2c 03 00 00       	call   80286c <sys_getSharedObject>
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802546:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802549:	a1 20 60 80 00       	mov    0x806020,%eax
  80254e:	8b 40 78             	mov    0x78(%eax),%eax
  802551:	29 c2                	sub    %eax,%edx
  802553:	89 d0                	mov    %edx,%eax
  802555:	2d 00 10 00 00       	sub    $0x1000,%eax
  80255a:	c1 e8 0c             	shr    $0xc,%eax
  80255d:	89 c2                	mov    %eax,%edx
  80255f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802562:	89 04 95 60 a2 80 00 	mov    %eax,0x80a260(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802569:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80256d:	75 07                	jne    802576 <sget+0xa3>
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	eb 03                	jmp    802579 <sget+0xa6>
	return ptr;
  802576:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802581:	8b 55 08             	mov    0x8(%ebp),%edx
  802584:	a1 20 60 80 00       	mov    0x806020,%eax
  802589:	8b 40 78             	mov    0x78(%eax),%eax
  80258c:	29 c2                	sub    %eax,%edx
  80258e:	89 d0                	mov    %edx,%eax
  802590:	2d 00 10 00 00       	sub    $0x1000,%eax
  802595:	c1 e8 0c             	shr    $0xc,%eax
  802598:	8b 04 85 60 a2 80 00 	mov    0x80a260(,%eax,4),%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8025a2:	83 ec 08             	sub    $0x8,%esp
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ab:	e8 db 02 00 00       	call   80288b <sys_freeSharedObject>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8025b6:	90                   	nop
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	68 e0 57 80 00       	push   $0x8057e0
  8025c7:	68 de 00 00 00       	push   $0xde
  8025cc:	68 c2 57 80 00       	push   $0x8057c2
  8025d1:	e8 bb ea ff ff       	call   801091 <_panic>

008025d6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	68 06 58 80 00       	push   $0x805806
  8025e4:	68 ea 00 00 00       	push   $0xea
  8025e9:	68 c2 57 80 00       	push   $0x8057c2
  8025ee:	e8 9e ea ff ff       	call   801091 <_panic>

008025f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 06 58 80 00       	push   $0x805806
  802601:	68 ef 00 00 00       	push   $0xef
  802606:	68 c2 57 80 00       	push   $0x8057c2
  80260b:	e8 81 ea ff ff       	call   801091 <_panic>

00802610 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 06 58 80 00       	push   $0x805806
  80261e:	68 f4 00 00 00       	push   $0xf4
  802623:	68 c2 57 80 00       	push   $0x8057c2
  802628:	e8 64 ea ff ff       	call   801091 <_panic>

0080262d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	57                   	push   %edi
  802631:	56                   	push   %esi
  802632:	53                   	push   %ebx
  802633:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80263f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802642:	8b 7d 18             	mov    0x18(%ebp),%edi
  802645:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802648:	cd 30                	int    $0x30
  80264a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	5b                   	pop    %ebx
  802654:	5e                   	pop    %esi
  802655:	5f                   	pop    %edi
  802656:	5d                   	pop    %ebp
  802657:	c3                   	ret    

00802658 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	8b 45 10             	mov    0x10(%ebp),%eax
  802661:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802664:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	52                   	push   %edx
  802670:	ff 75 0c             	pushl  0xc(%ebp)
  802673:	50                   	push   %eax
  802674:	6a 00                	push   $0x0
  802676:	e8 b2 ff ff ff       	call   80262d <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
}
  80267e:	90                   	nop
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <sys_cgetc>:

int
sys_cgetc(void)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 02                	push   $0x2
  802690:	e8 98 ff ff ff       	call   80262d <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 03                	push   $0x3
  8026a9:	e8 7f ff ff ff       	call   80262d <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
}
  8026b1:	90                   	nop
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 04                	push   $0x4
  8026c3:	e8 65 ff ff ff       	call   80262d <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
}
  8026cb:	90                   	nop
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	52                   	push   %edx
  8026de:	50                   	push   %eax
  8026df:	6a 08                	push   $0x8
  8026e1:	e8 47 ff ff ff       	call   80262d <syscall>
  8026e6:	83 c4 18             	add    $0x18,%esp
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	56                   	push   %esi
  8026ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8026f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	56                   	push   %esi
  802700:	53                   	push   %ebx
  802701:	51                   	push   %ecx
  802702:	52                   	push   %edx
  802703:	50                   	push   %eax
  802704:	6a 09                	push   $0x9
  802706:	e8 22 ff ff ff       	call   80262d <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    

00802715 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	52                   	push   %edx
  802725:	50                   	push   %eax
  802726:	6a 0a                	push   $0xa
  802728:	e8 00 ff ff ff       	call   80262d <syscall>
  80272d:	83 c4 18             	add    $0x18,%esp
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	ff 75 0c             	pushl  0xc(%ebp)
  80273e:	ff 75 08             	pushl  0x8(%ebp)
  802741:	6a 0b                	push   $0xb
  802743:	e8 e5 fe ff ff       	call   80262d <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 0c                	push   $0xc
  80275c:	e8 cc fe ff ff       	call   80262d <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 0d                	push   $0xd
  802775:	e8 b3 fe ff ff       	call   80262d <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 0e                	push   $0xe
  80278e:	e8 9a fe ff ff       	call   80262d <syscall>
  802793:	83 c4 18             	add    $0x18,%esp
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 0f                	push   $0xf
  8027a7:	e8 81 fe ff ff       	call   80262d <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	ff 75 08             	pushl  0x8(%ebp)
  8027bf:	6a 10                	push   $0x10
  8027c1:	e8 67 fe ff ff       	call   80262d <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 11                	push   $0x11
  8027da:	e8 4e fe ff ff       	call   80262d <syscall>
  8027df:	83 c4 18             	add    $0x18,%esp
}
  8027e2:	90                   	nop
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	50                   	push   %eax
  8027fe:	6a 01                	push   $0x1
  802800:	e8 28 fe ff ff       	call   80262d <syscall>
  802805:	83 c4 18             	add    $0x18,%esp
}
  802808:	90                   	nop
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 14                	push   $0x14
  80281a:	e8 0e fe ff ff       	call   80262d <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
}
  802822:	90                   	nop
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	8b 45 10             	mov    0x10(%ebp),%eax
  80282e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802831:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802834:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	6a 00                	push   $0x0
  80283d:	51                   	push   %ecx
  80283e:	52                   	push   %edx
  80283f:	ff 75 0c             	pushl  0xc(%ebp)
  802842:	50                   	push   %eax
  802843:	6a 15                	push   $0x15
  802845:	e8 e3 fd ff ff       	call   80262d <syscall>
  80284a:	83 c4 18             	add    $0x18,%esp
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802852:	8b 55 0c             	mov    0xc(%ebp),%edx
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	52                   	push   %edx
  80285f:	50                   	push   %eax
  802860:	6a 16                	push   $0x16
  802862:	e8 c6 fd ff ff       	call   80262d <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80286f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802872:	8b 55 0c             	mov    0xc(%ebp),%edx
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	51                   	push   %ecx
  80287d:	52                   	push   %edx
  80287e:	50                   	push   %eax
  80287f:	6a 17                	push   $0x17
  802881:	e8 a7 fd ff ff       	call   80262d <syscall>
  802886:	83 c4 18             	add    $0x18,%esp
}
  802889:	c9                   	leave  
  80288a:	c3                   	ret    

0080288b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80288e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	52                   	push   %edx
  80289b:	50                   	push   %eax
  80289c:	6a 18                	push   $0x18
  80289e:	e8 8a fd ff ff       	call   80262d <syscall>
  8028a3:	83 c4 18             	add    $0x18,%esp
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	6a 00                	push   $0x0
  8028b0:	ff 75 14             	pushl  0x14(%ebp)
  8028b3:	ff 75 10             	pushl  0x10(%ebp)
  8028b6:	ff 75 0c             	pushl  0xc(%ebp)
  8028b9:	50                   	push   %eax
  8028ba:	6a 19                	push   $0x19
  8028bc:	e8 6c fd ff ff       	call   80262d <syscall>
  8028c1:	83 c4 18             	add    $0x18,%esp
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	50                   	push   %eax
  8028d5:	6a 1a                	push   $0x1a
  8028d7:	e8 51 fd ff ff       	call   80262d <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
}
  8028df:	90                   	nop
  8028e0:	c9                   	leave  
  8028e1:	c3                   	ret    

008028e2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028e2:	55                   	push   %ebp
  8028e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	50                   	push   %eax
  8028f1:	6a 1b                	push   $0x1b
  8028f3:	e8 35 fd ff ff       	call   80262d <syscall>
  8028f8:	83 c4 18             	add    $0x18,%esp
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 05                	push   $0x5
  80290c:	e8 1c fd ff ff       	call   80262d <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 06                	push   $0x6
  802925:	e8 03 fd ff ff       	call   80262d <syscall>
  80292a:	83 c4 18             	add    $0x18,%esp
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 07                	push   $0x7
  80293e:	e8 ea fc ff ff       	call   80262d <syscall>
  802943:	83 c4 18             	add    $0x18,%esp
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <sys_exit_env>:


void sys_exit_env(void)
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 1c                	push   $0x1c
  802957:	e8 d1 fc ff ff       	call   80262d <syscall>
  80295c:	83 c4 18             	add    $0x18,%esp
}
  80295f:	90                   	nop
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802968:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80296b:	8d 50 04             	lea    0x4(%eax),%edx
  80296e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	52                   	push   %edx
  802978:	50                   	push   %eax
  802979:	6a 1d                	push   $0x1d
  80297b:	e8 ad fc ff ff       	call   80262d <syscall>
  802980:	83 c4 18             	add    $0x18,%esp
	return result;
  802983:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802986:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802989:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80298c:	89 01                	mov    %eax,(%ecx)
  80298e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	c9                   	leave  
  802995:	c2 04 00             	ret    $0x4

00802998 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	ff 75 10             	pushl  0x10(%ebp)
  8029a2:	ff 75 0c             	pushl  0xc(%ebp)
  8029a5:	ff 75 08             	pushl  0x8(%ebp)
  8029a8:	6a 13                	push   $0x13
  8029aa:	e8 7e fc ff ff       	call   80262d <syscall>
  8029af:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b2:	90                   	nop
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 1e                	push   $0x1e
  8029c4:	e8 64 fc ff ff       	call   80262d <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	83 ec 04             	sub    $0x4,%esp
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 00                	push   $0x0
  8029e6:	50                   	push   %eax
  8029e7:	6a 1f                	push   $0x1f
  8029e9:	e8 3f fc ff ff       	call   80262d <syscall>
  8029ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8029f1:	90                   	nop
}
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <rsttst>:
void rsttst()
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 21                	push   $0x21
  802a03:	e8 25 fc ff ff       	call   80262d <syscall>
  802a08:	83 c4 18             	add    $0x18,%esp
	return ;
  802a0b:	90                   	nop
}
  802a0c:	c9                   	leave  
  802a0d:	c3                   	ret    

00802a0e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a0e:	55                   	push   %ebp
  802a0f:	89 e5                	mov    %esp,%ebp
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	8b 45 14             	mov    0x14(%ebp),%eax
  802a17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a1a:	8b 55 18             	mov    0x18(%ebp),%edx
  802a1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a21:	52                   	push   %edx
  802a22:	50                   	push   %eax
  802a23:	ff 75 10             	pushl  0x10(%ebp)
  802a26:	ff 75 0c             	pushl  0xc(%ebp)
  802a29:	ff 75 08             	pushl  0x8(%ebp)
  802a2c:	6a 20                	push   $0x20
  802a2e:	e8 fa fb ff ff       	call   80262d <syscall>
  802a33:	83 c4 18             	add    $0x18,%esp
	return ;
  802a36:	90                   	nop
}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <chktst>:
void chktst(uint32 n)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	ff 75 08             	pushl  0x8(%ebp)
  802a47:	6a 22                	push   $0x22
  802a49:	e8 df fb ff ff       	call   80262d <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a51:	90                   	nop
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <inctst>:

void inctst()
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 23                	push   $0x23
  802a63:	e8 c5 fb ff ff       	call   80262d <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
	return ;
  802a6b:	90                   	nop
}
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <gettst>:
uint32 gettst()
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 24                	push   $0x24
  802a7d:	e8 ab fb ff ff       	call   80262d <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 25                	push   $0x25
  802a99:	e8 8f fb ff ff       	call   80262d <syscall>
  802a9e:	83 c4 18             	add    $0x18,%esp
  802aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802aa4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802aa8:	75 07                	jne    802ab1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  802aaf:	eb 05                	jmp    802ab6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 25                	push   $0x25
  802aca:	e8 5e fb ff ff       	call   80262d <syscall>
  802acf:	83 c4 18             	add    $0x18,%esp
  802ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ad5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ad9:	75 07                	jne    802ae2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802adb:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae0:	eb 05                	jmp    802ae7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
  802aec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 25                	push   $0x25
  802afb:	e8 2d fb ff ff       	call   80262d <syscall>
  802b00:	83 c4 18             	add    $0x18,%esp
  802b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b06:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b0a:	75 07                	jne    802b13 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b0c:	b8 01 00 00 00       	mov    $0x1,%eax
  802b11:	eb 05                	jmp    802b18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 25                	push   $0x25
  802b2c:	e8 fc fa ff ff       	call   80262d <syscall>
  802b31:	83 c4 18             	add    $0x18,%esp
  802b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b37:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b3b:	75 07                	jne    802b44 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b42:	eb 05                	jmp    802b49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

00802b4b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	ff 75 08             	pushl  0x8(%ebp)
  802b59:	6a 26                	push   $0x26
  802b5b:	e8 cd fa ff ff       	call   80262d <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
	return ;
  802b63:	90                   	nop
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	6a 00                	push   $0x0
  802b78:	53                   	push   %ebx
  802b79:	51                   	push   %ecx
  802b7a:	52                   	push   %edx
  802b7b:	50                   	push   %eax
  802b7c:	6a 27                	push   $0x27
  802b7e:	e8 aa fa ff ff       	call   80262d <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
}
  802b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b89:	c9                   	leave  
  802b8a:	c3                   	ret    

00802b8b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b8b:	55                   	push   %ebp
  802b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	52                   	push   %edx
  802b9b:	50                   	push   %eax
  802b9c:	6a 28                	push   $0x28
  802b9e:	e8 8a fa ff ff       	call   80262d <syscall>
  802ba3:	83 c4 18             	add    $0x18,%esp
}
  802ba6:	c9                   	leave  
  802ba7:	c3                   	ret    

00802ba8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ba8:	55                   	push   %ebp
  802ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802bab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	6a 00                	push   $0x0
  802bb6:	51                   	push   %ecx
  802bb7:	ff 75 10             	pushl  0x10(%ebp)
  802bba:	52                   	push   %edx
  802bbb:	50                   	push   %eax
  802bbc:	6a 29                	push   $0x29
  802bbe:	e8 6a fa ff ff       	call   80262d <syscall>
  802bc3:	83 c4 18             	add    $0x18,%esp
}
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    

00802bc8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bc8:	55                   	push   %ebp
  802bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	ff 75 10             	pushl  0x10(%ebp)
  802bd2:	ff 75 0c             	pushl  0xc(%ebp)
  802bd5:	ff 75 08             	pushl  0x8(%ebp)
  802bd8:	6a 12                	push   $0x12
  802bda:	e8 4e fa ff ff       	call   80262d <syscall>
  802bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  802be2:	90                   	nop
}
  802be3:	c9                   	leave  
  802be4:	c3                   	ret    

00802be5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802be5:	55                   	push   %ebp
  802be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	52                   	push   %edx
  802bf5:	50                   	push   %eax
  802bf6:	6a 2a                	push   $0x2a
  802bf8:	e8 30 fa ff ff       	call   80262d <syscall>
  802bfd:	83 c4 18             	add    $0x18,%esp
	return;
  802c00:	90                   	nop
}
  802c01:	c9                   	leave  
  802c02:	c3                   	ret    

00802c03 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802c03:	55                   	push   %ebp
  802c04:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 00                	push   $0x0
  802c11:	50                   	push   %eax
  802c12:	6a 2b                	push   $0x2b
  802c14:	e8 14 fa ff ff       	call   80262d <syscall>
  802c19:	83 c4 18             	add    $0x18,%esp
}
  802c1c:	c9                   	leave  
  802c1d:	c3                   	ret    

00802c1e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	ff 75 0c             	pushl  0xc(%ebp)
  802c2a:	ff 75 08             	pushl  0x8(%ebp)
  802c2d:	6a 2c                	push   $0x2c
  802c2f:	e8 f9 f9 ff ff       	call   80262d <syscall>
  802c34:	83 c4 18             	add    $0x18,%esp
	return;
  802c37:	90                   	nop
}
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	ff 75 0c             	pushl  0xc(%ebp)
  802c46:	ff 75 08             	pushl  0x8(%ebp)
  802c49:	6a 2d                	push   $0x2d
  802c4b:	e8 dd f9 ff ff       	call   80262d <syscall>
  802c50:	83 c4 18             	add    $0x18,%esp
	return;
  802c53:	90                   	nop
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	83 e8 04             	sub    $0x4,%eax
  802c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	83 e8 04             	sub    $0x4,%eax
  802c7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	83 e0 01             	and    $0x1,%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	0f 94 c0             	sete   %al
}
  802c8b:	c9                   	leave  
  802c8c:	c3                   	ret    

00802c8d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
  802c90:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9d:	83 f8 02             	cmp    $0x2,%eax
  802ca0:	74 2b                	je     802ccd <alloc_block+0x40>
  802ca2:	83 f8 02             	cmp    $0x2,%eax
  802ca5:	7f 07                	jg     802cae <alloc_block+0x21>
  802ca7:	83 f8 01             	cmp    $0x1,%eax
  802caa:	74 0e                	je     802cba <alloc_block+0x2d>
  802cac:	eb 58                	jmp    802d06 <alloc_block+0x79>
  802cae:	83 f8 03             	cmp    $0x3,%eax
  802cb1:	74 2d                	je     802ce0 <alloc_block+0x53>
  802cb3:	83 f8 04             	cmp    $0x4,%eax
  802cb6:	74 3b                	je     802cf3 <alloc_block+0x66>
  802cb8:	eb 4c                	jmp    802d06 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802cba:	83 ec 0c             	sub    $0xc,%esp
  802cbd:	ff 75 08             	pushl  0x8(%ebp)
  802cc0:	e8 11 03 00 00       	call   802fd6 <alloc_block_FF>
  802cc5:	83 c4 10             	add    $0x10,%esp
  802cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ccb:	eb 4a                	jmp    802d17 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	ff 75 08             	pushl  0x8(%ebp)
  802cd3:	e8 fa 19 00 00       	call   8046d2 <alloc_block_NF>
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cde:	eb 37                	jmp    802d17 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802ce0:	83 ec 0c             	sub    $0xc,%esp
  802ce3:	ff 75 08             	pushl  0x8(%ebp)
  802ce6:	e8 a7 07 00 00       	call   803492 <alloc_block_BF>
  802ceb:	83 c4 10             	add    $0x10,%esp
  802cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cf1:	eb 24                	jmp    802d17 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802cf3:	83 ec 0c             	sub    $0xc,%esp
  802cf6:	ff 75 08             	pushl  0x8(%ebp)
  802cf9:	e8 b7 19 00 00       	call   8046b5 <alloc_block_WF>
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d04:	eb 11                	jmp    802d17 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	68 18 58 80 00       	push   $0x805818
  802d0e:	e8 3b e6 ff ff       	call   80134e <cprintf>
  802d13:	83 c4 10             	add    $0x10,%esp
		break;
  802d16:	90                   	nop
	}
	return va;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802d1a:	c9                   	leave  
  802d1b:	c3                   	ret    

00802d1c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802d1c:	55                   	push   %ebp
  802d1d:	89 e5                	mov    %esp,%ebp
  802d1f:	53                   	push   %ebx
  802d20:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	68 38 58 80 00       	push   $0x805838
  802d2b:	e8 1e e6 ff ff       	call   80134e <cprintf>
  802d30:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802d33:	83 ec 0c             	sub    $0xc,%esp
  802d36:	68 63 58 80 00       	push   $0x805863
  802d3b:	e8 0e e6 ff ff       	call   80134e <cprintf>
  802d40:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d49:	eb 37                	jmp    802d82 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802d4b:	83 ec 0c             	sub    $0xc,%esp
  802d4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d51:	e8 19 ff ff ff       	call   802c6f <is_free_block>
  802d56:	83 c4 10             	add    $0x10,%esp
  802d59:	0f be d8             	movsbl %al,%ebx
  802d5c:	83 ec 0c             	sub    $0xc,%esp
  802d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802d62:	e8 ef fe ff ff       	call   802c56 <get_block_size>
  802d67:	83 c4 10             	add    $0x10,%esp
  802d6a:	83 ec 04             	sub    $0x4,%esp
  802d6d:	53                   	push   %ebx
  802d6e:	50                   	push   %eax
  802d6f:	68 7b 58 80 00       	push   $0x80587b
  802d74:	e8 d5 e5 ff ff       	call   80134e <cprintf>
  802d79:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d86:	74 07                	je     802d8f <print_blocks_list+0x73>
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	eb 05                	jmp    802d94 <print_blocks_list+0x78>
  802d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d94:	89 45 10             	mov    %eax,0x10(%ebp)
  802d97:	8b 45 10             	mov    0x10(%ebp),%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	75 ad                	jne    802d4b <print_blocks_list+0x2f>
  802d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da2:	75 a7                	jne    802d4b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	68 38 58 80 00       	push   $0x805838
  802dac:	e8 9d e5 ff ff       	call   80134e <cprintf>
  802db1:	83 c4 10             	add    $0x10,%esp

}
  802db4:	90                   	nop
  802db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc3:	83 e0 01             	and    $0x1,%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	74 03                	je     802dcd <initialize_dynamic_allocator+0x13>
  802dca:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd1:	0f 84 c7 01 00 00    	je     802f9e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802dd7:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802dde:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802de1:	8b 55 08             	mov    0x8(%ebp),%edx
  802de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de7:	01 d0                	add    %edx,%eax
  802de9:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802dee:	0f 87 ad 01 00 00    	ja     802fa1 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	0f 89 a5 01 00 00    	jns    802fa4 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802dff:	8b 55 08             	mov    0x8(%ebp),%edx
  802e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e05:	01 d0                	add    %edx,%eax
  802e07:	83 e8 04             	sub    $0x4,%eax
  802e0a:	a3 4c a2 80 00       	mov    %eax,0x80a24c
     struct BlockElement * element = NULL;
  802e0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802e16:	a1 44 60 80 00       	mov    0x806044,%eax
  802e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1e:	e9 87 00 00 00       	jmp    802eaa <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802e23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e27:	75 14                	jne    802e3d <initialize_dynamic_allocator+0x83>
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	68 93 58 80 00       	push   $0x805893
  802e31:	6a 79                	push   $0x79
  802e33:	68 b1 58 80 00       	push   $0x8058b1
  802e38:	e8 54 e2 ff ff       	call   801091 <_panic>
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 10                	je     802e56 <initialize_dynamic_allocator+0x9c>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4e:	8b 52 04             	mov    0x4(%edx),%edx
  802e51:	89 50 04             	mov    %edx,0x4(%eax)
  802e54:	eb 0b                	jmp    802e61 <initialize_dynamic_allocator+0xa7>
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	a3 48 60 80 00       	mov    %eax,0x806048
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0f                	je     802e7a <initialize_dynamic_allocator+0xc0>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e74:	8b 12                	mov    (%edx),%edx
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	eb 0a                	jmp    802e84 <initialize_dynamic_allocator+0xca>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	a3 44 60 80 00       	mov    %eax,0x806044
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e97:	a1 50 60 80 00       	mov    0x806050,%eax
  802e9c:	48                   	dec    %eax
  802e9d:	a3 50 60 80 00       	mov    %eax,0x806050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802ea2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eae:	74 07                	je     802eb7 <initialize_dynamic_allocator+0xfd>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	eb 05                	jmp    802ebc <initialize_dynamic_allocator+0x102>
  802eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebc:	a3 4c 60 80 00       	mov    %eax,0x80604c
  802ec1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	0f 85 55 ff ff ff    	jne    802e23 <initialize_dynamic_allocator+0x69>
  802ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed2:	0f 85 4b ff ff ff    	jne    802e23 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ee7:	a1 4c a2 80 00       	mov    0x80a24c,%eax
  802eec:	a3 48 a2 80 00       	mov    %eax,0x80a248
    end_block->info = 1;
  802ef1:	a1 48 a2 80 00       	mov    0x80a248,%eax
  802ef6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	83 c0 08             	add    $0x8,%eax
  802f02:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	83 c0 04             	add    $0x4,%eax
  802f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0e:	83 ea 08             	sub    $0x8,%edx
  802f11:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	01 d0                	add    %edx,%eax
  802f1b:	83 e8 08             	sub    $0x8,%eax
  802f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f21:	83 ea 08             	sub    $0x8,%edx
  802f24:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802f39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f3d:	75 17                	jne    802f56 <initialize_dynamic_allocator+0x19c>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 cc 58 80 00       	push   $0x8058cc
  802f47:	68 90 00 00 00       	push   $0x90
  802f4c:	68 b1 58 80 00       	push   $0x8058b1
  802f51:	e8 3b e1 ff ff       	call   801091 <_panic>
  802f56:	8b 15 44 60 80 00    	mov    0x806044,%edx
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0d                	je     802f77 <initialize_dynamic_allocator+0x1bd>
  802f6a:	a1 44 60 80 00       	mov    0x806044,%eax
  802f6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	eb 08                	jmp    802f7f <initialize_dynamic_allocator+0x1c5>
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	a3 48 60 80 00       	mov    %eax,0x806048
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	a3 44 60 80 00       	mov    %eax,0x806044
  802f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 50 60 80 00       	mov    0x806050,%eax
  802f96:	40                   	inc    %eax
  802f97:	a3 50 60 80 00       	mov    %eax,0x806050
  802f9c:	eb 07                	jmp    802fa5 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802f9e:	90                   	nop
  802f9f:	eb 04                	jmp    802fa5 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802fa1:	90                   	nop
  802fa2:	eb 01                	jmp    802fa5 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802fa4:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802fa5:	c9                   	leave  
  802fa6:	c3                   	ret    

00802fa7 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802fa7:	55                   	push   %ebp
  802fa8:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802faa:	8b 45 10             	mov    0x10(%ebp),%eax
  802fad:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb9:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	83 e8 04             	sub    $0x4,%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	83 e0 fe             	and    $0xfffffffe,%eax
  802fc6:	8d 50 f8             	lea    -0x8(%eax),%edx
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	01 c2                	add    %eax,%edx
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	89 02                	mov    %eax,(%edx)
}
  802fd3:	90                   	nop
  802fd4:	5d                   	pop    %ebp
  802fd5:	c3                   	ret    

00802fd6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	83 e0 01             	and    $0x1,%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 03                	je     802fe9 <alloc_block_FF+0x13>
  802fe6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fe9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fed:	77 07                	ja     802ff6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fef:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ff6:	a1 24 60 80 00       	mov    0x806024,%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	75 73                	jne    803072 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	83 c0 10             	add    $0x10,%eax
  803005:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803008:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80300f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803015:	01 d0                	add    %edx,%eax
  803017:	48                   	dec    %eax
  803018:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80301b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301e:	ba 00 00 00 00       	mov    $0x0,%edx
  803023:	f7 75 ec             	divl   -0x14(%ebp)
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	29 d0                	sub    %edx,%eax
  80302b:	c1 e8 0c             	shr    $0xc,%eax
  80302e:	83 ec 0c             	sub    $0xc,%esp
  803031:	50                   	push   %eax
  803032:	e8 b1 f0 ff ff       	call   8020e8 <sbrk>
  803037:	83 c4 10             	add    $0x10,%esp
  80303a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	6a 00                	push   $0x0
  803042:	e8 a1 f0 ff ff       	call   8020e8 <sbrk>
  803047:	83 c4 10             	add    $0x10,%esp
  80304a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80304d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803050:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803053:	83 ec 08             	sub    $0x8,%esp
  803056:	50                   	push   %eax
  803057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305a:	e8 5b fd ff ff       	call   802dba <initialize_dynamic_allocator>
  80305f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803062:	83 ec 0c             	sub    $0xc,%esp
  803065:	68 ef 58 80 00       	push   $0x8058ef
  80306a:	e8 df e2 ff ff       	call   80134e <cprintf>
  80306f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803076:	75 0a                	jne    803082 <alloc_block_FF+0xac>
	        return NULL;
  803078:	b8 00 00 00 00       	mov    $0x0,%eax
  80307d:	e9 0e 04 00 00       	jmp    803490 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803082:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803089:	a1 44 60 80 00       	mov    0x806044,%eax
  80308e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803091:	e9 f3 02 00 00       	jmp    803389 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80309c:	83 ec 0c             	sub    $0xc,%esp
  80309f:	ff 75 bc             	pushl  -0x44(%ebp)
  8030a2:	e8 af fb ff ff       	call   802c56 <get_block_size>
  8030a7:	83 c4 10             	add    $0x10,%esp
  8030aa:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	83 c0 08             	add    $0x8,%eax
  8030b3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030b6:	0f 87 c5 02 00 00    	ja     803381 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	83 c0 18             	add    $0x18,%eax
  8030c2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030c5:	0f 87 19 02 00 00    	ja     8032e4 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8030cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d1:	83 e8 08             	sub    $0x8,%eax
  8030d4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8d 50 08             	lea    0x8(%eax),%edx
  8030dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030e0:	01 d0                	add    %edx,%eax
  8030e2:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	83 c0 08             	add    $0x8,%eax
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	6a 01                	push   $0x1
  8030f0:	50                   	push   %eax
  8030f1:	ff 75 bc             	pushl  -0x44(%ebp)
  8030f4:	e8 ae fe ff ff       	call   802fa7 <set_block_data>
  8030f9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	75 68                	jne    80316e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803106:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80310a:	75 17                	jne    803123 <alloc_block_FF+0x14d>
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	68 cc 58 80 00       	push   $0x8058cc
  803114:	68 d7 00 00 00       	push   $0xd7
  803119:	68 b1 58 80 00       	push   $0x8058b1
  80311e:	e8 6e df ff ff       	call   801091 <_panic>
  803123:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803129:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 0d                	je     803144 <alloc_block_FF+0x16e>
  803137:	a1 44 60 80 00       	mov    0x806044,%eax
  80313c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	eb 08                	jmp    80314c <alloc_block_FF+0x176>
  803144:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803147:	a3 48 60 80 00       	mov    %eax,0x806048
  80314c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80314f:	a3 44 60 80 00       	mov    %eax,0x806044
  803154:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315e:	a1 50 60 80 00       	mov    0x806050,%eax
  803163:	40                   	inc    %eax
  803164:	a3 50 60 80 00       	mov    %eax,0x806050
  803169:	e9 dc 00 00 00       	jmp    80324a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	75 65                	jne    8031dc <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803177:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80317b:	75 17                	jne    803194 <alloc_block_FF+0x1be>
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	68 00 59 80 00       	push   $0x805900
  803185:	68 db 00 00 00       	push   $0xdb
  80318a:	68 b1 58 80 00       	push   $0x8058b1
  80318f:	e8 fd de ff ff       	call   801091 <_panic>
  803194:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80319a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0c                	je     8031b6 <alloc_block_FF+0x1e0>
  8031aa:	a1 48 60 80 00       	mov    0x806048,%eax
  8031af:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	eb 08                	jmp    8031be <alloc_block_FF+0x1e8>
  8031b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b9:	a3 44 60 80 00       	mov    %eax,0x806044
  8031be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031c1:	a3 48 60 80 00       	mov    %eax,0x806048
  8031c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cf:	a1 50 60 80 00       	mov    0x806050,%eax
  8031d4:	40                   	inc    %eax
  8031d5:	a3 50 60 80 00       	mov    %eax,0x806050
  8031da:	eb 6e                	jmp    80324a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8031dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e0:	74 06                	je     8031e8 <alloc_block_FF+0x212>
  8031e2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031e6:	75 17                	jne    8031ff <alloc_block_FF+0x229>
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	68 24 59 80 00       	push   $0x805924
  8031f0:	68 df 00 00 00       	push   $0xdf
  8031f5:	68 b1 58 80 00       	push   $0x8058b1
  8031fa:	e8 92 de ff ff       	call   801091 <_panic>
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 10                	mov    (%eax),%edx
  803204:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803207:	89 10                	mov    %edx,(%eax)
  803209:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0b                	je     80321d <alloc_block_FF+0x247>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80321a:	89 50 04             	mov    %edx,0x4(%eax)
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803223:	89 10                	mov    %edx,(%eax)
  803225:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	75 08                	jne    80323f <alloc_block_FF+0x269>
  803237:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80323a:	a3 48 60 80 00       	mov    %eax,0x806048
  80323f:	a1 50 60 80 00       	mov    0x806050,%eax
  803244:	40                   	inc    %eax
  803245:	a3 50 60 80 00       	mov    %eax,0x806050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80324a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324e:	75 17                	jne    803267 <alloc_block_FF+0x291>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 93 58 80 00       	push   $0x805893
  803258:	68 e1 00 00 00       	push   $0xe1
  80325d:	68 b1 58 80 00       	push   $0x8058b1
  803262:	e8 2a de ff ff       	call   801091 <_panic>
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 10                	je     803280 <alloc_block_FF+0x2aa>
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803278:	8b 52 04             	mov    0x4(%edx),%edx
  80327b:	89 50 04             	mov    %edx,0x4(%eax)
  80327e:	eb 0b                	jmp    80328b <alloc_block_FF+0x2b5>
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	a3 48 60 80 00       	mov    %eax,0x806048
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	8b 40 04             	mov    0x4(%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 0f                	je     8032a4 <alloc_block_FF+0x2ce>
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 40 04             	mov    0x4(%eax),%eax
  80329b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329e:	8b 12                	mov    (%edx),%edx
  8032a0:	89 10                	mov    %edx,(%eax)
  8032a2:	eb 0a                	jmp    8032ae <alloc_block_FF+0x2d8>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	a3 44 60 80 00       	mov    %eax,0x806044
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c1:	a1 50 60 80 00       	mov    0x806050,%eax
  8032c6:	48                   	dec    %eax
  8032c7:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(new_block_va, remaining_size, 0);
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	6a 00                	push   $0x0
  8032d1:	ff 75 b4             	pushl  -0x4c(%ebp)
  8032d4:	ff 75 b0             	pushl  -0x50(%ebp)
  8032d7:	e8 cb fc ff ff       	call   802fa7 <set_block_data>
  8032dc:	83 c4 10             	add    $0x10,%esp
  8032df:	e9 95 00 00 00       	jmp    803379 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8032e4:	83 ec 04             	sub    $0x4,%esp
  8032e7:	6a 01                	push   $0x1
  8032e9:	ff 75 b8             	pushl  -0x48(%ebp)
  8032ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8032ef:	e8 b3 fc ff ff       	call   802fa7 <set_block_data>
  8032f4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8032f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fb:	75 17                	jne    803314 <alloc_block_FF+0x33e>
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 93 58 80 00       	push   $0x805893
  803305:	68 e8 00 00 00       	push   $0xe8
  80330a:	68 b1 58 80 00       	push   $0x8058b1
  80330f:	e8 7d dd ff ff       	call   801091 <_panic>
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	74 10                	je     80332d <alloc_block_FF+0x357>
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803325:	8b 52 04             	mov    0x4(%edx),%edx
  803328:	89 50 04             	mov    %edx,0x4(%eax)
  80332b:	eb 0b                	jmp    803338 <alloc_block_FF+0x362>
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	a3 48 60 80 00       	mov    %eax,0x806048
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 40 04             	mov    0x4(%eax),%eax
  80333e:	85 c0                	test   %eax,%eax
  803340:	74 0f                	je     803351 <alloc_block_FF+0x37b>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 40 04             	mov    0x4(%eax),%eax
  803348:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334b:	8b 12                	mov    (%edx),%edx
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	eb 0a                	jmp    80335b <alloc_block_FF+0x385>
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	a3 44 60 80 00       	mov    %eax,0x806044
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336e:	a1 50 60 80 00       	mov    0x806050,%eax
  803373:	48                   	dec    %eax
  803374:	a3 50 60 80 00       	mov    %eax,0x806050
	            }
	            return va;
  803379:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80337c:	e9 0f 01 00 00       	jmp    803490 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803381:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338d:	74 07                	je     803396 <alloc_block_FF+0x3c0>
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	eb 05                	jmp    80339b <alloc_block_FF+0x3c5>
  803396:	b8 00 00 00 00       	mov    $0x0,%eax
  80339b:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8033a0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	0f 85 e9 fc ff ff    	jne    803096 <alloc_block_FF+0xc0>
  8033ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b1:	0f 85 df fc ff ff    	jne    803096 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	83 c0 08             	add    $0x8,%eax
  8033bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033c0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8033c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	48                   	dec    %eax
  8033d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8033d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8033db:	f7 75 d8             	divl   -0x28(%ebp)
  8033de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e1:	29 d0                	sub    %edx,%eax
  8033e3:	c1 e8 0c             	shr    $0xc,%eax
  8033e6:	83 ec 0c             	sub    $0xc,%esp
  8033e9:	50                   	push   %eax
  8033ea:	e8 f9 ec ff ff       	call   8020e8 <sbrk>
  8033ef:	83 c4 10             	add    $0x10,%esp
  8033f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8033f5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8033f9:	75 0a                	jne    803405 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8033fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803400:	e9 8b 00 00 00       	jmp    803490 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803405:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80340c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80340f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	48                   	dec    %eax
  803415:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803418:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341b:	ba 00 00 00 00       	mov    $0x0,%edx
  803420:	f7 75 cc             	divl   -0x34(%ebp)
  803423:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803426:	29 d0                	sub    %edx,%eax
  803428:	8d 50 fc             	lea    -0x4(%eax),%edx
  80342b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80342e:	01 d0                	add    %edx,%eax
  803430:	a3 48 a2 80 00       	mov    %eax,0x80a248
			end_block->info = 1;
  803435:	a1 48 a2 80 00       	mov    0x80a248,%eax
  80343a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803440:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803447:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80344a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80344d:	01 d0                	add    %edx,%eax
  80344f:	48                   	dec    %eax
  803450:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803453:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803456:	ba 00 00 00 00       	mov    $0x0,%edx
  80345b:	f7 75 c4             	divl   -0x3c(%ebp)
  80345e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803461:	29 d0                	sub    %edx,%eax
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	6a 01                	push   $0x1
  803468:	50                   	push   %eax
  803469:	ff 75 d0             	pushl  -0x30(%ebp)
  80346c:	e8 36 fb ff ff       	call   802fa7 <set_block_data>
  803471:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803474:	83 ec 0c             	sub    $0xc,%esp
  803477:	ff 75 d0             	pushl  -0x30(%ebp)
  80347a:	e8 1b 0a 00 00       	call   803e9a <free_block>
  80347f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803482:	83 ec 0c             	sub    $0xc,%esp
  803485:	ff 75 08             	pushl  0x8(%ebp)
  803488:	e8 49 fb ff ff       	call   802fd6 <alloc_block_FF>
  80348d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803490:	c9                   	leave  
  803491:	c3                   	ret    

00803492 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
  803495:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	83 e0 01             	and    $0x1,%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 03                	je     8034a5 <alloc_block_BF+0x13>
  8034a2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8034a5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8034a9:	77 07                	ja     8034b2 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8034ab:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8034b2:	a1 24 60 80 00       	mov    0x806024,%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	75 73                	jne    80352e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	83 c0 10             	add    $0x10,%eax
  8034c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034c4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8034cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d1:	01 d0                	add    %edx,%eax
  8034d3:	48                   	dec    %eax
  8034d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034da:	ba 00 00 00 00       	mov    $0x0,%edx
  8034df:	f7 75 e0             	divl   -0x20(%ebp)
  8034e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e5:	29 d0                	sub    %edx,%eax
  8034e7:	c1 e8 0c             	shr    $0xc,%eax
  8034ea:	83 ec 0c             	sub    $0xc,%esp
  8034ed:	50                   	push   %eax
  8034ee:	e8 f5 eb ff ff       	call   8020e8 <sbrk>
  8034f3:	83 c4 10             	add    $0x10,%esp
  8034f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	6a 00                	push   $0x0
  8034fe:	e8 e5 eb ff ff       	call   8020e8 <sbrk>
  803503:	83 c4 10             	add    $0x10,%esp
  803506:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80350f:	83 ec 08             	sub    $0x8,%esp
  803512:	50                   	push   %eax
  803513:	ff 75 d8             	pushl  -0x28(%ebp)
  803516:	e8 9f f8 ff ff       	call   802dba <initialize_dynamic_allocator>
  80351b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80351e:	83 ec 0c             	sub    $0xc,%esp
  803521:	68 ef 58 80 00       	push   $0x8058ef
  803526:	e8 23 de ff ff       	call   80134e <cprintf>
  80352b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80352e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80353c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803543:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80354a:	a1 44 60 80 00       	mov    0x806044,%eax
  80354f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803552:	e9 1d 01 00 00       	jmp    803674 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80355d:	83 ec 0c             	sub    $0xc,%esp
  803560:	ff 75 a8             	pushl  -0x58(%ebp)
  803563:	e8 ee f6 ff ff       	call   802c56 <get_block_size>
  803568:	83 c4 10             	add    $0x10,%esp
  80356b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	83 c0 08             	add    $0x8,%eax
  803574:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803577:	0f 87 ef 00 00 00    	ja     80366c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	83 c0 18             	add    $0x18,%eax
  803583:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803586:	77 1d                	ja     8035a5 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80358e:	0f 86 d8 00 00 00    	jbe    80366c <alloc_block_BF+0x1da>
				{
					best_va = va;
  803594:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803597:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80359a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80359d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8035a0:	e9 c7 00 00 00       	jmp    80366c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	83 c0 08             	add    $0x8,%eax
  8035ab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8035ae:	0f 85 9d 00 00 00    	jne    803651 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8035b4:	83 ec 04             	sub    $0x4,%esp
  8035b7:	6a 01                	push   $0x1
  8035b9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8035bc:	ff 75 a8             	pushl  -0x58(%ebp)
  8035bf:	e8 e3 f9 ff ff       	call   802fa7 <set_block_data>
  8035c4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8035c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cb:	75 17                	jne    8035e4 <alloc_block_BF+0x152>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 93 58 80 00       	push   $0x805893
  8035d5:	68 2c 01 00 00       	push   $0x12c
  8035da:	68 b1 58 80 00       	push   $0x8058b1
  8035df:	e8 ad da ff ff       	call   801091 <_panic>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 10                	je     8035fd <alloc_block_BF+0x16b>
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f5:	8b 52 04             	mov    0x4(%edx),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	eb 0b                	jmp    803608 <alloc_block_BF+0x176>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	a3 48 60 80 00       	mov    %eax,0x806048
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0f                	je     803621 <alloc_block_BF+0x18f>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361b:	8b 12                	mov    (%edx),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	eb 0a                	jmp    80362b <alloc_block_BF+0x199>
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	a3 44 60 80 00       	mov    %eax,0x806044
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363e:	a1 50 60 80 00       	mov    0x806050,%eax
  803643:	48                   	dec    %eax
  803644:	a3 50 60 80 00       	mov    %eax,0x806050
					return va;
  803649:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80364c:	e9 24 04 00 00       	jmp    803a75 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803654:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803657:	76 13                	jbe    80366c <alloc_block_BF+0x1da>
					{
						internal = 1;
  803659:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803660:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803663:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803666:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803669:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80366c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803678:	74 07                	je     803681 <alloc_block_BF+0x1ef>
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 00                	mov    (%eax),%eax
  80367f:	eb 05                	jmp    803686 <alloc_block_BF+0x1f4>
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
  803686:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80368b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	0f 85 bf fe ff ff    	jne    803557 <alloc_block_BF+0xc5>
  803698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369c:	0f 85 b5 fe ff ff    	jne    803557 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8036a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a6:	0f 84 26 02 00 00    	je     8038d2 <alloc_block_BF+0x440>
  8036ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036b0:	0f 85 1c 02 00 00    	jne    8038d2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8036b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8036bc:	83 e8 08             	sub    $0x8,%eax
  8036bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	8d 50 08             	lea    0x8(%eax),%edx
  8036c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cb:	01 d0                	add    %edx,%eax
  8036cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	83 c0 08             	add    $0x8,%eax
  8036d6:	83 ec 04             	sub    $0x4,%esp
  8036d9:	6a 01                	push   $0x1
  8036db:	50                   	push   %eax
  8036dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8036df:	e8 c3 f8 ff ff       	call   802fa7 <set_block_data>
  8036e4:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	75 68                	jne    803759 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036f5:	75 17                	jne    80370e <alloc_block_BF+0x27c>
  8036f7:	83 ec 04             	sub    $0x4,%esp
  8036fa:	68 cc 58 80 00       	push   $0x8058cc
  8036ff:	68 45 01 00 00       	push   $0x145
  803704:	68 b1 58 80 00       	push   $0x8058b1
  803709:	e8 83 d9 ff ff       	call   801091 <_panic>
  80370e:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803714:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803717:	89 10                	mov    %edx,(%eax)
  803719:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	85 c0                	test   %eax,%eax
  803720:	74 0d                	je     80372f <alloc_block_BF+0x29d>
  803722:	a1 44 60 80 00       	mov    0x806044,%eax
  803727:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80372a:	89 50 04             	mov    %edx,0x4(%eax)
  80372d:	eb 08                	jmp    803737 <alloc_block_BF+0x2a5>
  80372f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803732:	a3 48 60 80 00       	mov    %eax,0x806048
  803737:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80373a:	a3 44 60 80 00       	mov    %eax,0x806044
  80373f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803749:	a1 50 60 80 00       	mov    0x806050,%eax
  80374e:	40                   	inc    %eax
  80374f:	a3 50 60 80 00       	mov    %eax,0x806050
  803754:	e9 dc 00 00 00       	jmp    803835 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	85 c0                	test   %eax,%eax
  803760:	75 65                	jne    8037c7 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803762:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803766:	75 17                	jne    80377f <alloc_block_BF+0x2ed>
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	68 00 59 80 00       	push   $0x805900
  803770:	68 4a 01 00 00       	push   $0x14a
  803775:	68 b1 58 80 00       	push   $0x8058b1
  80377a:	e8 12 d9 ff ff       	call   801091 <_panic>
  80377f:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803785:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803788:	89 50 04             	mov    %edx,0x4(%eax)
  80378b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	74 0c                	je     8037a1 <alloc_block_BF+0x30f>
  803795:	a1 48 60 80 00       	mov    0x806048,%eax
  80379a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80379d:	89 10                	mov    %edx,(%eax)
  80379f:	eb 08                	jmp    8037a9 <alloc_block_BF+0x317>
  8037a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a4:	a3 44 60 80 00       	mov    %eax,0x806044
  8037a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ac:	a3 48 60 80 00       	mov    %eax,0x806048
  8037b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ba:	a1 50 60 80 00       	mov    0x806050,%eax
  8037bf:	40                   	inc    %eax
  8037c0:	a3 50 60 80 00       	mov    %eax,0x806050
  8037c5:	eb 6e                	jmp    803835 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8037c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cb:	74 06                	je     8037d3 <alloc_block_BF+0x341>
  8037cd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037d1:	75 17                	jne    8037ea <alloc_block_BF+0x358>
  8037d3:	83 ec 04             	sub    $0x4,%esp
  8037d6:	68 24 59 80 00       	push   $0x805924
  8037db:	68 4f 01 00 00       	push   $0x14f
  8037e0:	68 b1 58 80 00       	push   $0x8058b1
  8037e5:	e8 a7 d8 ff ff       	call   801091 <_panic>
  8037ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ed:	8b 10                	mov    (%eax),%edx
  8037ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0b                	je     803808 <alloc_block_BF+0x376>
  8037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	75 08                	jne    80382a <alloc_block_BF+0x398>
  803822:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803825:	a3 48 60 80 00       	mov    %eax,0x806048
  80382a:	a1 50 60 80 00       	mov    0x806050,%eax
  80382f:	40                   	inc    %eax
  803830:	a3 50 60 80 00       	mov    %eax,0x806050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803839:	75 17                	jne    803852 <alloc_block_BF+0x3c0>
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 93 58 80 00       	push   $0x805893
  803843:	68 51 01 00 00       	push   $0x151
  803848:	68 b1 58 80 00       	push   $0x8058b1
  80384d:	e8 3f d8 ff ff       	call   801091 <_panic>
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 10                	je     80386b <alloc_block_BF+0x3d9>
  80385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803863:	8b 52 04             	mov    0x4(%edx),%edx
  803866:	89 50 04             	mov    %edx,0x4(%eax)
  803869:	eb 0b                	jmp    803876 <alloc_block_BF+0x3e4>
  80386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	a3 48 60 80 00       	mov    %eax,0x806048
  803876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0f                	je     80388f <alloc_block_BF+0x3fd>
  803880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803889:	8b 12                	mov    (%edx),%edx
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	eb 0a                	jmp    803899 <alloc_block_BF+0x407>
  80388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	a3 44 60 80 00       	mov    %eax,0x806044
  803899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ac:	a1 50 60 80 00       	mov    0x806050,%eax
  8038b1:	48                   	dec    %eax
  8038b2:	a3 50 60 80 00       	mov    %eax,0x806050
			set_block_data(new_block_va, remaining_size, 0);
  8038b7:	83 ec 04             	sub    $0x4,%esp
  8038ba:	6a 00                	push   $0x0
  8038bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8038bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8038c2:	e8 e0 f6 ff ff       	call   802fa7 <set_block_data>
  8038c7:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8038ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cd:	e9 a3 01 00 00       	jmp    803a75 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8038d2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8038d6:	0f 85 9d 00 00 00    	jne    803979 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8038dc:	83 ec 04             	sub    $0x4,%esp
  8038df:	6a 01                	push   $0x1
  8038e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8038e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8038e7:	e8 bb f6 ff ff       	call   802fa7 <set_block_data>
  8038ec:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8038ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038f3:	75 17                	jne    80390c <alloc_block_BF+0x47a>
  8038f5:	83 ec 04             	sub    $0x4,%esp
  8038f8:	68 93 58 80 00       	push   $0x805893
  8038fd:	68 58 01 00 00       	push   $0x158
  803902:	68 b1 58 80 00       	push   $0x8058b1
  803907:	e8 85 d7 ff ff       	call   801091 <_panic>
  80390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390f:	8b 00                	mov    (%eax),%eax
  803911:	85 c0                	test   %eax,%eax
  803913:	74 10                	je     803925 <alloc_block_BF+0x493>
  803915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80391d:	8b 52 04             	mov    0x4(%edx),%edx
  803920:	89 50 04             	mov    %edx,0x4(%eax)
  803923:	eb 0b                	jmp    803930 <alloc_block_BF+0x49e>
  803925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803928:	8b 40 04             	mov    0x4(%eax),%eax
  80392b:	a3 48 60 80 00       	mov    %eax,0x806048
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	8b 40 04             	mov    0x4(%eax),%eax
  803936:	85 c0                	test   %eax,%eax
  803938:	74 0f                	je     803949 <alloc_block_BF+0x4b7>
  80393a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393d:	8b 40 04             	mov    0x4(%eax),%eax
  803940:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803943:	8b 12                	mov    (%edx),%edx
  803945:	89 10                	mov    %edx,(%eax)
  803947:	eb 0a                	jmp    803953 <alloc_block_BF+0x4c1>
  803949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	a3 44 60 80 00       	mov    %eax,0x806044
  803953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803956:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803966:	a1 50 60 80 00       	mov    0x806050,%eax
  80396b:	48                   	dec    %eax
  80396c:	a3 50 60 80 00       	mov    %eax,0x806050
		return best_va;
  803971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803974:	e9 fc 00 00 00       	jmp    803a75 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	83 c0 08             	add    $0x8,%eax
  80397f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803982:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803989:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80398c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80398f:	01 d0                	add    %edx,%eax
  803991:	48                   	dec    %eax
  803992:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803995:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803998:	ba 00 00 00 00       	mov    $0x0,%edx
  80399d:	f7 75 c4             	divl   -0x3c(%ebp)
  8039a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8039a3:	29 d0                	sub    %edx,%eax
  8039a5:	c1 e8 0c             	shr    $0xc,%eax
  8039a8:	83 ec 0c             	sub    $0xc,%esp
  8039ab:	50                   	push   %eax
  8039ac:	e8 37 e7 ff ff       	call   8020e8 <sbrk>
  8039b1:	83 c4 10             	add    $0x10,%esp
  8039b4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8039b7:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8039bb:	75 0a                	jne    8039c7 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8039bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c2:	e9 ae 00 00 00       	jmp    803a75 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8039c7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8039ce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d4:	01 d0                	add    %edx,%eax
  8039d6:	48                   	dec    %eax
  8039d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8039da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8039e2:	f7 75 b8             	divl   -0x48(%ebp)
  8039e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039e8:	29 d0                	sub    %edx,%eax
  8039ea:	8d 50 fc             	lea    -0x4(%eax),%edx
  8039ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8039f0:	01 d0                	add    %edx,%eax
  8039f2:	a3 48 a2 80 00       	mov    %eax,0x80a248
				end_block->info = 1;
  8039f7:	a1 48 a2 80 00       	mov    0x80a248,%eax
  8039fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803a02:	83 ec 0c             	sub    $0xc,%esp
  803a05:	68 58 59 80 00       	push   $0x805958
  803a0a:	e8 3f d9 ff ff       	call   80134e <cprintf>
  803a0f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803a12:	83 ec 08             	sub    $0x8,%esp
  803a15:	ff 75 bc             	pushl  -0x44(%ebp)
  803a18:	68 5d 59 80 00       	push   $0x80595d
  803a1d:	e8 2c d9 ff ff       	call   80134e <cprintf>
  803a22:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803a25:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803a2c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a32:	01 d0                	add    %edx,%eax
  803a34:	48                   	dec    %eax
  803a35:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a38:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  803a40:	f7 75 b0             	divl   -0x50(%ebp)
  803a43:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a46:	29 d0                	sub    %edx,%eax
  803a48:	83 ec 04             	sub    $0x4,%esp
  803a4b:	6a 01                	push   $0x1
  803a4d:	50                   	push   %eax
  803a4e:	ff 75 bc             	pushl  -0x44(%ebp)
  803a51:	e8 51 f5 ff ff       	call   802fa7 <set_block_data>
  803a56:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803a59:	83 ec 0c             	sub    $0xc,%esp
  803a5c:	ff 75 bc             	pushl  -0x44(%ebp)
  803a5f:	e8 36 04 00 00       	call   803e9a <free_block>
  803a64:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803a67:	83 ec 0c             	sub    $0xc,%esp
  803a6a:	ff 75 08             	pushl  0x8(%ebp)
  803a6d:	e8 20 fa ff ff       	call   803492 <alloc_block_BF>
  803a72:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a75:	c9                   	leave  
  803a76:	c3                   	ret    

00803a77 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a77:	55                   	push   %ebp
  803a78:	89 e5                	mov    %esp,%ebp
  803a7a:	53                   	push   %ebx
  803a7b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a90:	74 1e                	je     803ab0 <merging+0x39>
  803a92:	ff 75 08             	pushl  0x8(%ebp)
  803a95:	e8 bc f1 ff ff       	call   802c56 <get_block_size>
  803a9a:	83 c4 04             	add    $0x4,%esp
  803a9d:	89 c2                	mov    %eax,%edx
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	01 d0                	add    %edx,%eax
  803aa4:	3b 45 10             	cmp    0x10(%ebp),%eax
  803aa7:	75 07                	jne    803ab0 <merging+0x39>
		prev_is_free = 1;
  803aa9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803ab0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ab4:	74 1e                	je     803ad4 <merging+0x5d>
  803ab6:	ff 75 10             	pushl  0x10(%ebp)
  803ab9:	e8 98 f1 ff ff       	call   802c56 <get_block_size>
  803abe:	83 c4 04             	add    $0x4,%esp
  803ac1:	89 c2                	mov    %eax,%edx
  803ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ac6:	01 d0                	add    %edx,%eax
  803ac8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803acb:	75 07                	jne    803ad4 <merging+0x5d>
		next_is_free = 1;
  803acd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad8:	0f 84 cc 00 00 00    	je     803baa <merging+0x133>
  803ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ae2:	0f 84 c2 00 00 00    	je     803baa <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803ae8:	ff 75 08             	pushl  0x8(%ebp)
  803aeb:	e8 66 f1 ff ff       	call   802c56 <get_block_size>
  803af0:	83 c4 04             	add    $0x4,%esp
  803af3:	89 c3                	mov    %eax,%ebx
  803af5:	ff 75 10             	pushl  0x10(%ebp)
  803af8:	e8 59 f1 ff ff       	call   802c56 <get_block_size>
  803afd:	83 c4 04             	add    $0x4,%esp
  803b00:	01 c3                	add    %eax,%ebx
  803b02:	ff 75 0c             	pushl  0xc(%ebp)
  803b05:	e8 4c f1 ff ff       	call   802c56 <get_block_size>
  803b0a:	83 c4 04             	add    $0x4,%esp
  803b0d:	01 d8                	add    %ebx,%eax
  803b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b12:	6a 00                	push   $0x0
  803b14:	ff 75 ec             	pushl  -0x14(%ebp)
  803b17:	ff 75 08             	pushl  0x8(%ebp)
  803b1a:	e8 88 f4 ff ff       	call   802fa7 <set_block_data>
  803b1f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803b22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b26:	75 17                	jne    803b3f <merging+0xc8>
  803b28:	83 ec 04             	sub    $0x4,%esp
  803b2b:	68 93 58 80 00       	push   $0x805893
  803b30:	68 7d 01 00 00       	push   $0x17d
  803b35:	68 b1 58 80 00       	push   $0x8058b1
  803b3a:	e8 52 d5 ff ff       	call   801091 <_panic>
  803b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	85 c0                	test   %eax,%eax
  803b46:	74 10                	je     803b58 <merging+0xe1>
  803b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4b:	8b 00                	mov    (%eax),%eax
  803b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b50:	8b 52 04             	mov    0x4(%edx),%edx
  803b53:	89 50 04             	mov    %edx,0x4(%eax)
  803b56:	eb 0b                	jmp    803b63 <merging+0xec>
  803b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5b:	8b 40 04             	mov    0x4(%eax),%eax
  803b5e:	a3 48 60 80 00       	mov    %eax,0x806048
  803b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b66:	8b 40 04             	mov    0x4(%eax),%eax
  803b69:	85 c0                	test   %eax,%eax
  803b6b:	74 0f                	je     803b7c <merging+0x105>
  803b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b70:	8b 40 04             	mov    0x4(%eax),%eax
  803b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b76:	8b 12                	mov    (%edx),%edx
  803b78:	89 10                	mov    %edx,(%eax)
  803b7a:	eb 0a                	jmp    803b86 <merging+0x10f>
  803b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7f:	8b 00                	mov    (%eax),%eax
  803b81:	a3 44 60 80 00       	mov    %eax,0x806044
  803b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b99:	a1 50 60 80 00       	mov    0x806050,%eax
  803b9e:	48                   	dec    %eax
  803b9f:	a3 50 60 80 00       	mov    %eax,0x806050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803ba4:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ba5:	e9 ea 02 00 00       	jmp    803e94 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bae:	74 3b                	je     803beb <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803bb0:	83 ec 0c             	sub    $0xc,%esp
  803bb3:	ff 75 08             	pushl  0x8(%ebp)
  803bb6:	e8 9b f0 ff ff       	call   802c56 <get_block_size>
  803bbb:	83 c4 10             	add    $0x10,%esp
  803bbe:	89 c3                	mov    %eax,%ebx
  803bc0:	83 ec 0c             	sub    $0xc,%esp
  803bc3:	ff 75 10             	pushl  0x10(%ebp)
  803bc6:	e8 8b f0 ff ff       	call   802c56 <get_block_size>
  803bcb:	83 c4 10             	add    $0x10,%esp
  803bce:	01 d8                	add    %ebx,%eax
  803bd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bd3:	83 ec 04             	sub    $0x4,%esp
  803bd6:	6a 00                	push   $0x0
  803bd8:	ff 75 e8             	pushl  -0x18(%ebp)
  803bdb:	ff 75 08             	pushl  0x8(%ebp)
  803bde:	e8 c4 f3 ff ff       	call   802fa7 <set_block_data>
  803be3:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803be6:	e9 a9 02 00 00       	jmp    803e94 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803beb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bef:	0f 84 2d 01 00 00    	je     803d22 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803bf5:	83 ec 0c             	sub    $0xc,%esp
  803bf8:	ff 75 10             	pushl  0x10(%ebp)
  803bfb:	e8 56 f0 ff ff       	call   802c56 <get_block_size>
  803c00:	83 c4 10             	add    $0x10,%esp
  803c03:	89 c3                	mov    %eax,%ebx
  803c05:	83 ec 0c             	sub    $0xc,%esp
  803c08:	ff 75 0c             	pushl  0xc(%ebp)
  803c0b:	e8 46 f0 ff ff       	call   802c56 <get_block_size>
  803c10:	83 c4 10             	add    $0x10,%esp
  803c13:	01 d8                	add    %ebx,%eax
  803c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	6a 00                	push   $0x0
  803c1d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c20:	ff 75 10             	pushl  0x10(%ebp)
  803c23:	e8 7f f3 ff ff       	call   802fa7 <set_block_data>
  803c28:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  803c2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c35:	74 06                	je     803c3d <merging+0x1c6>
  803c37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c3b:	75 17                	jne    803c54 <merging+0x1dd>
  803c3d:	83 ec 04             	sub    $0x4,%esp
  803c40:	68 6c 59 80 00       	push   $0x80596c
  803c45:	68 8d 01 00 00       	push   $0x18d
  803c4a:	68 b1 58 80 00       	push   $0x8058b1
  803c4f:	e8 3d d4 ff ff       	call   801091 <_panic>
  803c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c57:	8b 50 04             	mov    0x4(%eax),%edx
  803c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c5d:	89 50 04             	mov    %edx,0x4(%eax)
  803c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c66:	89 10                	mov    %edx,(%eax)
  803c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6b:	8b 40 04             	mov    0x4(%eax),%eax
  803c6e:	85 c0                	test   %eax,%eax
  803c70:	74 0d                	je     803c7f <merging+0x208>
  803c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c75:	8b 40 04             	mov    0x4(%eax),%eax
  803c78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c7b:	89 10                	mov    %edx,(%eax)
  803c7d:	eb 08                	jmp    803c87 <merging+0x210>
  803c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c82:	a3 44 60 80 00       	mov    %eax,0x806044
  803c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c8d:	89 50 04             	mov    %edx,0x4(%eax)
  803c90:	a1 50 60 80 00       	mov    0x806050,%eax
  803c95:	40                   	inc    %eax
  803c96:	a3 50 60 80 00       	mov    %eax,0x806050
		LIST_REMOVE(&freeBlocksList, next_block);
  803c9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c9f:	75 17                	jne    803cb8 <merging+0x241>
  803ca1:	83 ec 04             	sub    $0x4,%esp
  803ca4:	68 93 58 80 00       	push   $0x805893
  803ca9:	68 8e 01 00 00       	push   $0x18e
  803cae:	68 b1 58 80 00       	push   $0x8058b1
  803cb3:	e8 d9 d3 ff ff       	call   801091 <_panic>
  803cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbb:	8b 00                	mov    (%eax),%eax
  803cbd:	85 c0                	test   %eax,%eax
  803cbf:	74 10                	je     803cd1 <merging+0x25a>
  803cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc4:	8b 00                	mov    (%eax),%eax
  803cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cc9:	8b 52 04             	mov    0x4(%edx),%edx
  803ccc:	89 50 04             	mov    %edx,0x4(%eax)
  803ccf:	eb 0b                	jmp    803cdc <merging+0x265>
  803cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd4:	8b 40 04             	mov    0x4(%eax),%eax
  803cd7:	a3 48 60 80 00       	mov    %eax,0x806048
  803cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdf:	8b 40 04             	mov    0x4(%eax),%eax
  803ce2:	85 c0                	test   %eax,%eax
  803ce4:	74 0f                	je     803cf5 <merging+0x27e>
  803ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce9:	8b 40 04             	mov    0x4(%eax),%eax
  803cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cef:	8b 12                	mov    (%edx),%edx
  803cf1:	89 10                	mov    %edx,(%eax)
  803cf3:	eb 0a                	jmp    803cff <merging+0x288>
  803cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf8:	8b 00                	mov    (%eax),%eax
  803cfa:	a3 44 60 80 00       	mov    %eax,0x806044
  803cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d12:	a1 50 60 80 00       	mov    0x806050,%eax
  803d17:	48                   	dec    %eax
  803d18:	a3 50 60 80 00       	mov    %eax,0x806050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d1d:	e9 72 01 00 00       	jmp    803e94 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803d22:	8b 45 10             	mov    0x10(%ebp),%eax
  803d25:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803d28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d2c:	74 79                	je     803da7 <merging+0x330>
  803d2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d32:	74 73                	je     803da7 <merging+0x330>
  803d34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d38:	74 06                	je     803d40 <merging+0x2c9>
  803d3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d3e:	75 17                	jne    803d57 <merging+0x2e0>
  803d40:	83 ec 04             	sub    $0x4,%esp
  803d43:	68 24 59 80 00       	push   $0x805924
  803d48:	68 94 01 00 00       	push   $0x194
  803d4d:	68 b1 58 80 00       	push   $0x8058b1
  803d52:	e8 3a d3 ff ff       	call   801091 <_panic>
  803d57:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5a:	8b 10                	mov    (%eax),%edx
  803d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5f:	89 10                	mov    %edx,(%eax)
  803d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d64:	8b 00                	mov    (%eax),%eax
  803d66:	85 c0                	test   %eax,%eax
  803d68:	74 0b                	je     803d75 <merging+0x2fe>
  803d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6d:	8b 00                	mov    (%eax),%eax
  803d6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d72:	89 50 04             	mov    %edx,0x4(%eax)
  803d75:	8b 45 08             	mov    0x8(%ebp),%eax
  803d78:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d7b:	89 10                	mov    %edx,(%eax)
  803d7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d80:	8b 55 08             	mov    0x8(%ebp),%edx
  803d83:	89 50 04             	mov    %edx,0x4(%eax)
  803d86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d89:	8b 00                	mov    (%eax),%eax
  803d8b:	85 c0                	test   %eax,%eax
  803d8d:	75 08                	jne    803d97 <merging+0x320>
  803d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d92:	a3 48 60 80 00       	mov    %eax,0x806048
  803d97:	a1 50 60 80 00       	mov    0x806050,%eax
  803d9c:	40                   	inc    %eax
  803d9d:	a3 50 60 80 00       	mov    %eax,0x806050
  803da2:	e9 ce 00 00 00       	jmp    803e75 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dab:	74 65                	je     803e12 <merging+0x39b>
  803dad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803db1:	75 17                	jne    803dca <merging+0x353>
  803db3:	83 ec 04             	sub    $0x4,%esp
  803db6:	68 00 59 80 00       	push   $0x805900
  803dbb:	68 95 01 00 00       	push   $0x195
  803dc0:	68 b1 58 80 00       	push   $0x8058b1
  803dc5:	e8 c7 d2 ff ff       	call   801091 <_panic>
  803dca:	8b 15 48 60 80 00    	mov    0x806048,%edx
  803dd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd3:	89 50 04             	mov    %edx,0x4(%eax)
  803dd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd9:	8b 40 04             	mov    0x4(%eax),%eax
  803ddc:	85 c0                	test   %eax,%eax
  803dde:	74 0c                	je     803dec <merging+0x375>
  803de0:	a1 48 60 80 00       	mov    0x806048,%eax
  803de5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803de8:	89 10                	mov    %edx,(%eax)
  803dea:	eb 08                	jmp    803df4 <merging+0x37d>
  803dec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803def:	a3 44 60 80 00       	mov    %eax,0x806044
  803df4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df7:	a3 48 60 80 00       	mov    %eax,0x806048
  803dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e05:	a1 50 60 80 00       	mov    0x806050,%eax
  803e0a:	40                   	inc    %eax
  803e0b:	a3 50 60 80 00       	mov    %eax,0x806050
  803e10:	eb 63                	jmp    803e75 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803e12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e16:	75 17                	jne    803e2f <merging+0x3b8>
  803e18:	83 ec 04             	sub    $0x4,%esp
  803e1b:	68 cc 58 80 00       	push   $0x8058cc
  803e20:	68 98 01 00 00       	push   $0x198
  803e25:	68 b1 58 80 00       	push   $0x8058b1
  803e2a:	e8 62 d2 ff ff       	call   801091 <_panic>
  803e2f:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e38:	89 10                	mov    %edx,(%eax)
  803e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3d:	8b 00                	mov    (%eax),%eax
  803e3f:	85 c0                	test   %eax,%eax
  803e41:	74 0d                	je     803e50 <merging+0x3d9>
  803e43:	a1 44 60 80 00       	mov    0x806044,%eax
  803e48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e4b:	89 50 04             	mov    %edx,0x4(%eax)
  803e4e:	eb 08                	jmp    803e58 <merging+0x3e1>
  803e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e53:	a3 48 60 80 00       	mov    %eax,0x806048
  803e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5b:	a3 44 60 80 00       	mov    %eax,0x806044
  803e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6a:	a1 50 60 80 00       	mov    0x806050,%eax
  803e6f:	40                   	inc    %eax
  803e70:	a3 50 60 80 00       	mov    %eax,0x806050
		}
		set_block_data(va, get_block_size(va), 0);
  803e75:	83 ec 0c             	sub    $0xc,%esp
  803e78:	ff 75 10             	pushl  0x10(%ebp)
  803e7b:	e8 d6 ed ff ff       	call   802c56 <get_block_size>
  803e80:	83 c4 10             	add    $0x10,%esp
  803e83:	83 ec 04             	sub    $0x4,%esp
  803e86:	6a 00                	push   $0x0
  803e88:	50                   	push   %eax
  803e89:	ff 75 10             	pushl  0x10(%ebp)
  803e8c:	e8 16 f1 ff ff       	call   802fa7 <set_block_data>
  803e91:	83 c4 10             	add    $0x10,%esp
	}
}
  803e94:	90                   	nop
  803e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e98:	c9                   	leave  
  803e99:	c3                   	ret    

00803e9a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803e9a:	55                   	push   %ebp
  803e9b:	89 e5                	mov    %esp,%ebp
  803e9d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803ea0:	a1 44 60 80 00       	mov    0x806044,%eax
  803ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803ea8:	a1 48 60 80 00       	mov    0x806048,%eax
  803ead:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eb0:	73 1b                	jae    803ecd <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803eb2:	a1 48 60 80 00       	mov    0x806048,%eax
  803eb7:	83 ec 04             	sub    $0x4,%esp
  803eba:	ff 75 08             	pushl  0x8(%ebp)
  803ebd:	6a 00                	push   $0x0
  803ebf:	50                   	push   %eax
  803ec0:	e8 b2 fb ff ff       	call   803a77 <merging>
  803ec5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ec8:	e9 8b 00 00 00       	jmp    803f58 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803ecd:	a1 44 60 80 00       	mov    0x806044,%eax
  803ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ed5:	76 18                	jbe    803eef <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ed7:	a1 44 60 80 00       	mov    0x806044,%eax
  803edc:	83 ec 04             	sub    $0x4,%esp
  803edf:	ff 75 08             	pushl  0x8(%ebp)
  803ee2:	50                   	push   %eax
  803ee3:	6a 00                	push   $0x0
  803ee5:	e8 8d fb ff ff       	call   803a77 <merging>
  803eea:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803eed:	eb 69                	jmp    803f58 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803eef:	a1 44 60 80 00       	mov    0x806044,%eax
  803ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ef7:	eb 39                	jmp    803f32 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efc:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eff:	73 29                	jae    803f2a <free_block+0x90>
  803f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f04:	8b 00                	mov    (%eax),%eax
  803f06:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f09:	76 1f                	jbe    803f2a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0e:	8b 00                	mov    (%eax),%eax
  803f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803f13:	83 ec 04             	sub    $0x4,%esp
  803f16:	ff 75 08             	pushl  0x8(%ebp)
  803f19:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  803f1f:	e8 53 fb ff ff       	call   803a77 <merging>
  803f24:	83 c4 10             	add    $0x10,%esp
			break;
  803f27:	90                   	nop
		}
	}
}
  803f28:	eb 2e                	jmp    803f58 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f2a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f36:	74 07                	je     803f3f <free_block+0xa5>
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	eb 05                	jmp    803f44 <free_block+0xaa>
  803f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f44:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f49:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f4e:	85 c0                	test   %eax,%eax
  803f50:	75 a7                	jne    803ef9 <free_block+0x5f>
  803f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f56:	75 a1                	jne    803ef9 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f58:	90                   	nop
  803f59:	c9                   	leave  
  803f5a:	c3                   	ret    

00803f5b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803f5b:	55                   	push   %ebp
  803f5c:	89 e5                	mov    %esp,%ebp
  803f5e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803f61:	ff 75 08             	pushl  0x8(%ebp)
  803f64:	e8 ed ec ff ff       	call   802c56 <get_block_size>
  803f69:	83 c4 04             	add    $0x4,%esp
  803f6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f76:	eb 17                	jmp    803f8f <copy_data+0x34>
  803f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7e:	01 c2                	add    %eax,%edx
  803f80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f83:	8b 45 08             	mov    0x8(%ebp),%eax
  803f86:	01 c8                	add    %ecx,%eax
  803f88:	8a 00                	mov    (%eax),%al
  803f8a:	88 02                	mov    %al,(%edx)
  803f8c:	ff 45 fc             	incl   -0x4(%ebp)
  803f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f95:	72 e1                	jb     803f78 <copy_data+0x1d>
}
  803f97:	90                   	nop
  803f98:	c9                   	leave  
  803f99:	c3                   	ret    

00803f9a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803f9a:	55                   	push   %ebp
  803f9b:	89 e5                	mov    %esp,%ebp
  803f9d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803fa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fa4:	75 23                	jne    803fc9 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803fa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803faa:	74 13                	je     803fbf <realloc_block_FF+0x25>
  803fac:	83 ec 0c             	sub    $0xc,%esp
  803faf:	ff 75 0c             	pushl  0xc(%ebp)
  803fb2:	e8 1f f0 ff ff       	call   802fd6 <alloc_block_FF>
  803fb7:	83 c4 10             	add    $0x10,%esp
  803fba:	e9 f4 06 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
		return NULL;
  803fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803fc4:	e9 ea 06 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fcd:	75 18                	jne    803fe7 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803fcf:	83 ec 0c             	sub    $0xc,%esp
  803fd2:	ff 75 08             	pushl  0x8(%ebp)
  803fd5:	e8 c0 fe ff ff       	call   803e9a <free_block>
  803fda:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe2:	e9 cc 06 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803fe7:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803feb:	77 07                	ja     803ff4 <realloc_block_FF+0x5a>
  803fed:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff7:	83 e0 01             	and    $0x1,%eax
  803ffa:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  804000:	83 c0 08             	add    $0x8,%eax
  804003:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804006:	83 ec 0c             	sub    $0xc,%esp
  804009:	ff 75 08             	pushl  0x8(%ebp)
  80400c:	e8 45 ec ff ff       	call   802c56 <get_block_size>
  804011:	83 c4 10             	add    $0x10,%esp
  804014:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80401a:	83 e8 08             	sub    $0x8,%eax
  80401d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804020:	8b 45 08             	mov    0x8(%ebp),%eax
  804023:	83 e8 04             	sub    $0x4,%eax
  804026:	8b 00                	mov    (%eax),%eax
  804028:	83 e0 fe             	and    $0xfffffffe,%eax
  80402b:	89 c2                	mov    %eax,%edx
  80402d:	8b 45 08             	mov    0x8(%ebp),%eax
  804030:	01 d0                	add    %edx,%eax
  804032:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804035:	83 ec 0c             	sub    $0xc,%esp
  804038:	ff 75 e4             	pushl  -0x1c(%ebp)
  80403b:	e8 16 ec ff ff       	call   802c56 <get_block_size>
  804040:	83 c4 10             	add    $0x10,%esp
  804043:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804046:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804049:	83 e8 08             	sub    $0x8,%eax
  80404c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80404f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804052:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804055:	75 08                	jne    80405f <realloc_block_FF+0xc5>
	{
		 return va;
  804057:	8b 45 08             	mov    0x8(%ebp),%eax
  80405a:	e9 54 06 00 00       	jmp    8046b3 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80405f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804062:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804065:	0f 83 e5 03 00 00    	jae    804450 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80406b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80406e:	2b 45 0c             	sub    0xc(%ebp),%eax
  804071:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804074:	83 ec 0c             	sub    $0xc,%esp
  804077:	ff 75 e4             	pushl  -0x1c(%ebp)
  80407a:	e8 f0 eb ff ff       	call   802c6f <is_free_block>
  80407f:	83 c4 10             	add    $0x10,%esp
  804082:	84 c0                	test   %al,%al
  804084:	0f 84 3b 01 00 00    	je     8041c5 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80408a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80408d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804090:	01 d0                	add    %edx,%eax
  804092:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804095:	83 ec 04             	sub    $0x4,%esp
  804098:	6a 01                	push   $0x1
  80409a:	ff 75 f0             	pushl  -0x10(%ebp)
  80409d:	ff 75 08             	pushl  0x8(%ebp)
  8040a0:	e8 02 ef ff ff       	call   802fa7 <set_block_data>
  8040a5:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8040a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ab:	83 e8 04             	sub    $0x4,%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8040b3:	89 c2                	mov    %eax,%edx
  8040b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b8:	01 d0                	add    %edx,%eax
  8040ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8040bd:	83 ec 04             	sub    $0x4,%esp
  8040c0:	6a 00                	push   $0x0
  8040c2:	ff 75 cc             	pushl  -0x34(%ebp)
  8040c5:	ff 75 c8             	pushl  -0x38(%ebp)
  8040c8:	e8 da ee ff ff       	call   802fa7 <set_block_data>
  8040cd:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040d4:	74 06                	je     8040dc <realloc_block_FF+0x142>
  8040d6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8040da:	75 17                	jne    8040f3 <realloc_block_FF+0x159>
  8040dc:	83 ec 04             	sub    $0x4,%esp
  8040df:	68 24 59 80 00       	push   $0x805924
  8040e4:	68 f6 01 00 00       	push   $0x1f6
  8040e9:	68 b1 58 80 00       	push   $0x8058b1
  8040ee:	e8 9e cf ff ff       	call   801091 <_panic>
  8040f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f6:	8b 10                	mov    (%eax),%edx
  8040f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040fb:	89 10                	mov    %edx,(%eax)
  8040fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804100:	8b 00                	mov    (%eax),%eax
  804102:	85 c0                	test   %eax,%eax
  804104:	74 0b                	je     804111 <realloc_block_FF+0x177>
  804106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804109:	8b 00                	mov    (%eax),%eax
  80410b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80410e:	89 50 04             	mov    %edx,0x4(%eax)
  804111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804114:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804117:	89 10                	mov    %edx,(%eax)
  804119:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80411c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80411f:	89 50 04             	mov    %edx,0x4(%eax)
  804122:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804125:	8b 00                	mov    (%eax),%eax
  804127:	85 c0                	test   %eax,%eax
  804129:	75 08                	jne    804133 <realloc_block_FF+0x199>
  80412b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80412e:	a3 48 60 80 00       	mov    %eax,0x806048
  804133:	a1 50 60 80 00       	mov    0x806050,%eax
  804138:	40                   	inc    %eax
  804139:	a3 50 60 80 00       	mov    %eax,0x806050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80413e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804142:	75 17                	jne    80415b <realloc_block_FF+0x1c1>
  804144:	83 ec 04             	sub    $0x4,%esp
  804147:	68 93 58 80 00       	push   $0x805893
  80414c:	68 f7 01 00 00       	push   $0x1f7
  804151:	68 b1 58 80 00       	push   $0x8058b1
  804156:	e8 36 cf ff ff       	call   801091 <_panic>
  80415b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415e:	8b 00                	mov    (%eax),%eax
  804160:	85 c0                	test   %eax,%eax
  804162:	74 10                	je     804174 <realloc_block_FF+0x1da>
  804164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804167:	8b 00                	mov    (%eax),%eax
  804169:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80416c:	8b 52 04             	mov    0x4(%edx),%edx
  80416f:	89 50 04             	mov    %edx,0x4(%eax)
  804172:	eb 0b                	jmp    80417f <realloc_block_FF+0x1e5>
  804174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804177:	8b 40 04             	mov    0x4(%eax),%eax
  80417a:	a3 48 60 80 00       	mov    %eax,0x806048
  80417f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804182:	8b 40 04             	mov    0x4(%eax),%eax
  804185:	85 c0                	test   %eax,%eax
  804187:	74 0f                	je     804198 <realloc_block_FF+0x1fe>
  804189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418c:	8b 40 04             	mov    0x4(%eax),%eax
  80418f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804192:	8b 12                	mov    (%edx),%edx
  804194:	89 10                	mov    %edx,(%eax)
  804196:	eb 0a                	jmp    8041a2 <realloc_block_FF+0x208>
  804198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419b:	8b 00                	mov    (%eax),%eax
  80419d:	a3 44 60 80 00       	mov    %eax,0x806044
  8041a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b5:	a1 50 60 80 00       	mov    0x806050,%eax
  8041ba:	48                   	dec    %eax
  8041bb:	a3 50 60 80 00       	mov    %eax,0x806050
  8041c0:	e9 83 02 00 00       	jmp    804448 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8041c5:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8041c9:	0f 86 69 02 00 00    	jbe    804438 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8041cf:	83 ec 04             	sub    $0x4,%esp
  8041d2:	6a 01                	push   $0x1
  8041d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8041d7:	ff 75 08             	pushl  0x8(%ebp)
  8041da:	e8 c8 ed ff ff       	call   802fa7 <set_block_data>
  8041df:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e5:	83 e8 04             	sub    $0x4,%eax
  8041e8:	8b 00                	mov    (%eax),%eax
  8041ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8041ed:	89 c2                	mov    %eax,%edx
  8041ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f2:	01 d0                	add    %edx,%eax
  8041f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8041f7:	a1 50 60 80 00       	mov    0x806050,%eax
  8041fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8041ff:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804203:	75 68                	jne    80426d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804205:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804209:	75 17                	jne    804222 <realloc_block_FF+0x288>
  80420b:	83 ec 04             	sub    $0x4,%esp
  80420e:	68 cc 58 80 00       	push   $0x8058cc
  804213:	68 06 02 00 00       	push   $0x206
  804218:	68 b1 58 80 00       	push   $0x8058b1
  80421d:	e8 6f ce ff ff       	call   801091 <_panic>
  804222:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80422b:	89 10                	mov    %edx,(%eax)
  80422d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804230:	8b 00                	mov    (%eax),%eax
  804232:	85 c0                	test   %eax,%eax
  804234:	74 0d                	je     804243 <realloc_block_FF+0x2a9>
  804236:	a1 44 60 80 00       	mov    0x806044,%eax
  80423b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80423e:	89 50 04             	mov    %edx,0x4(%eax)
  804241:	eb 08                	jmp    80424b <realloc_block_FF+0x2b1>
  804243:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804246:	a3 48 60 80 00       	mov    %eax,0x806048
  80424b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80424e:	a3 44 60 80 00       	mov    %eax,0x806044
  804253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804256:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80425d:	a1 50 60 80 00       	mov    0x806050,%eax
  804262:	40                   	inc    %eax
  804263:	a3 50 60 80 00       	mov    %eax,0x806050
  804268:	e9 b0 01 00 00       	jmp    80441d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80426d:	a1 44 60 80 00       	mov    0x806044,%eax
  804272:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804275:	76 68                	jbe    8042df <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804277:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80427b:	75 17                	jne    804294 <realloc_block_FF+0x2fa>
  80427d:	83 ec 04             	sub    $0x4,%esp
  804280:	68 cc 58 80 00       	push   $0x8058cc
  804285:	68 0b 02 00 00       	push   $0x20b
  80428a:	68 b1 58 80 00       	push   $0x8058b1
  80428f:	e8 fd cd ff ff       	call   801091 <_panic>
  804294:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80429a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80429d:	89 10                	mov    %edx,(%eax)
  80429f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042a2:	8b 00                	mov    (%eax),%eax
  8042a4:	85 c0                	test   %eax,%eax
  8042a6:	74 0d                	je     8042b5 <realloc_block_FF+0x31b>
  8042a8:	a1 44 60 80 00       	mov    0x806044,%eax
  8042ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042b0:	89 50 04             	mov    %edx,0x4(%eax)
  8042b3:	eb 08                	jmp    8042bd <realloc_block_FF+0x323>
  8042b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b8:	a3 48 60 80 00       	mov    %eax,0x806048
  8042bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042c0:	a3 44 60 80 00       	mov    %eax,0x806044
  8042c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042cf:	a1 50 60 80 00       	mov    0x806050,%eax
  8042d4:	40                   	inc    %eax
  8042d5:	a3 50 60 80 00       	mov    %eax,0x806050
  8042da:	e9 3e 01 00 00       	jmp    80441d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8042df:	a1 44 60 80 00       	mov    0x806044,%eax
  8042e4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042e7:	73 68                	jae    804351 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042ed:	75 17                	jne    804306 <realloc_block_FF+0x36c>
  8042ef:	83 ec 04             	sub    $0x4,%esp
  8042f2:	68 00 59 80 00       	push   $0x805900
  8042f7:	68 10 02 00 00       	push   $0x210
  8042fc:	68 b1 58 80 00       	push   $0x8058b1
  804301:	e8 8b cd ff ff       	call   801091 <_panic>
  804306:	8b 15 48 60 80 00    	mov    0x806048,%edx
  80430c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80430f:	89 50 04             	mov    %edx,0x4(%eax)
  804312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804315:	8b 40 04             	mov    0x4(%eax),%eax
  804318:	85 c0                	test   %eax,%eax
  80431a:	74 0c                	je     804328 <realloc_block_FF+0x38e>
  80431c:	a1 48 60 80 00       	mov    0x806048,%eax
  804321:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804324:	89 10                	mov    %edx,(%eax)
  804326:	eb 08                	jmp    804330 <realloc_block_FF+0x396>
  804328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80432b:	a3 44 60 80 00       	mov    %eax,0x806044
  804330:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804333:	a3 48 60 80 00       	mov    %eax,0x806048
  804338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80433b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804341:	a1 50 60 80 00       	mov    0x806050,%eax
  804346:	40                   	inc    %eax
  804347:	a3 50 60 80 00       	mov    %eax,0x806050
  80434c:	e9 cc 00 00 00       	jmp    80441d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804358:	a1 44 60 80 00       	mov    0x806044,%eax
  80435d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804360:	e9 8a 00 00 00       	jmp    8043ef <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804368:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80436b:	73 7a                	jae    8043e7 <realloc_block_FF+0x44d>
  80436d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804370:	8b 00                	mov    (%eax),%eax
  804372:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804375:	73 70                	jae    8043e7 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80437b:	74 06                	je     804383 <realloc_block_FF+0x3e9>
  80437d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804381:	75 17                	jne    80439a <realloc_block_FF+0x400>
  804383:	83 ec 04             	sub    $0x4,%esp
  804386:	68 24 59 80 00       	push   $0x805924
  80438b:	68 1a 02 00 00       	push   $0x21a
  804390:	68 b1 58 80 00       	push   $0x8058b1
  804395:	e8 f7 cc ff ff       	call   801091 <_panic>
  80439a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80439d:	8b 10                	mov    (%eax),%edx
  80439f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a2:	89 10                	mov    %edx,(%eax)
  8043a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a7:	8b 00                	mov    (%eax),%eax
  8043a9:	85 c0                	test   %eax,%eax
  8043ab:	74 0b                	je     8043b8 <realloc_block_FF+0x41e>
  8043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b0:	8b 00                	mov    (%eax),%eax
  8043b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043b5:	89 50 04             	mov    %edx,0x4(%eax)
  8043b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043be:	89 10                	mov    %edx,(%eax)
  8043c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043c6:	89 50 04             	mov    %edx,0x4(%eax)
  8043c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043cc:	8b 00                	mov    (%eax),%eax
  8043ce:	85 c0                	test   %eax,%eax
  8043d0:	75 08                	jne    8043da <realloc_block_FF+0x440>
  8043d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043d5:	a3 48 60 80 00       	mov    %eax,0x806048
  8043da:	a1 50 60 80 00       	mov    0x806050,%eax
  8043df:	40                   	inc    %eax
  8043e0:	a3 50 60 80 00       	mov    %eax,0x806050
							break;
  8043e5:	eb 36                	jmp    80441d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8043e7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043f3:	74 07                	je     8043fc <realloc_block_FF+0x462>
  8043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043f8:	8b 00                	mov    (%eax),%eax
  8043fa:	eb 05                	jmp    804401 <realloc_block_FF+0x467>
  8043fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804401:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804406:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80440b:	85 c0                	test   %eax,%eax
  80440d:	0f 85 52 ff ff ff    	jne    804365 <realloc_block_FF+0x3cb>
  804413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804417:	0f 85 48 ff ff ff    	jne    804365 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80441d:	83 ec 04             	sub    $0x4,%esp
  804420:	6a 00                	push   $0x0
  804422:	ff 75 d8             	pushl  -0x28(%ebp)
  804425:	ff 75 d4             	pushl  -0x2c(%ebp)
  804428:	e8 7a eb ff ff       	call   802fa7 <set_block_data>
  80442d:	83 c4 10             	add    $0x10,%esp
				return va;
  804430:	8b 45 08             	mov    0x8(%ebp),%eax
  804433:	e9 7b 02 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804438:	83 ec 0c             	sub    $0xc,%esp
  80443b:	68 a1 59 80 00       	push   $0x8059a1
  804440:	e8 09 cf ff ff       	call   80134e <cprintf>
  804445:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804448:	8b 45 08             	mov    0x8(%ebp),%eax
  80444b:	e9 63 02 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804450:	8b 45 0c             	mov    0xc(%ebp),%eax
  804453:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804456:	0f 86 4d 02 00 00    	jbe    8046a9 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80445c:	83 ec 0c             	sub    $0xc,%esp
  80445f:	ff 75 e4             	pushl  -0x1c(%ebp)
  804462:	e8 08 e8 ff ff       	call   802c6f <is_free_block>
  804467:	83 c4 10             	add    $0x10,%esp
  80446a:	84 c0                	test   %al,%al
  80446c:	0f 84 37 02 00 00    	je     8046a9 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804472:	8b 45 0c             	mov    0xc(%ebp),%eax
  804475:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804478:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80447b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80447e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804481:	76 38                	jbe    8044bb <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804483:	83 ec 0c             	sub    $0xc,%esp
  804486:	ff 75 08             	pushl  0x8(%ebp)
  804489:	e8 0c fa ff ff       	call   803e9a <free_block>
  80448e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804491:	83 ec 0c             	sub    $0xc,%esp
  804494:	ff 75 0c             	pushl  0xc(%ebp)
  804497:	e8 3a eb ff ff       	call   802fd6 <alloc_block_FF>
  80449c:	83 c4 10             	add    $0x10,%esp
  80449f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8044a2:	83 ec 08             	sub    $0x8,%esp
  8044a5:	ff 75 c0             	pushl  -0x40(%ebp)
  8044a8:	ff 75 08             	pushl  0x8(%ebp)
  8044ab:	e8 ab fa ff ff       	call   803f5b <copy_data>
  8044b0:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8044b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8044b6:	e9 f8 01 00 00       	jmp    8046b3 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8044bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044be:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8044c1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8044c4:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8044c8:	0f 87 a0 00 00 00    	ja     80456e <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8044ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044d2:	75 17                	jne    8044eb <realloc_block_FF+0x551>
  8044d4:	83 ec 04             	sub    $0x4,%esp
  8044d7:	68 93 58 80 00       	push   $0x805893
  8044dc:	68 38 02 00 00       	push   $0x238
  8044e1:	68 b1 58 80 00       	push   $0x8058b1
  8044e6:	e8 a6 cb ff ff       	call   801091 <_panic>
  8044eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044ee:	8b 00                	mov    (%eax),%eax
  8044f0:	85 c0                	test   %eax,%eax
  8044f2:	74 10                	je     804504 <realloc_block_FF+0x56a>
  8044f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044f7:	8b 00                	mov    (%eax),%eax
  8044f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044fc:	8b 52 04             	mov    0x4(%edx),%edx
  8044ff:	89 50 04             	mov    %edx,0x4(%eax)
  804502:	eb 0b                	jmp    80450f <realloc_block_FF+0x575>
  804504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804507:	8b 40 04             	mov    0x4(%eax),%eax
  80450a:	a3 48 60 80 00       	mov    %eax,0x806048
  80450f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804512:	8b 40 04             	mov    0x4(%eax),%eax
  804515:	85 c0                	test   %eax,%eax
  804517:	74 0f                	je     804528 <realloc_block_FF+0x58e>
  804519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80451c:	8b 40 04             	mov    0x4(%eax),%eax
  80451f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804522:	8b 12                	mov    (%edx),%edx
  804524:	89 10                	mov    %edx,(%eax)
  804526:	eb 0a                	jmp    804532 <realloc_block_FF+0x598>
  804528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80452b:	8b 00                	mov    (%eax),%eax
  80452d:	a3 44 60 80 00       	mov    %eax,0x806044
  804532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80453b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80453e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804545:	a1 50 60 80 00       	mov    0x806050,%eax
  80454a:	48                   	dec    %eax
  80454b:	a3 50 60 80 00       	mov    %eax,0x806050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804550:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804556:	01 d0                	add    %edx,%eax
  804558:	83 ec 04             	sub    $0x4,%esp
  80455b:	6a 01                	push   $0x1
  80455d:	50                   	push   %eax
  80455e:	ff 75 08             	pushl  0x8(%ebp)
  804561:	e8 41 ea ff ff       	call   802fa7 <set_block_data>
  804566:	83 c4 10             	add    $0x10,%esp
  804569:	e9 36 01 00 00       	jmp    8046a4 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80456e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804571:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804574:	01 d0                	add    %edx,%eax
  804576:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804579:	83 ec 04             	sub    $0x4,%esp
  80457c:	6a 01                	push   $0x1
  80457e:	ff 75 f0             	pushl  -0x10(%ebp)
  804581:	ff 75 08             	pushl  0x8(%ebp)
  804584:	e8 1e ea ff ff       	call   802fa7 <set_block_data>
  804589:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80458c:	8b 45 08             	mov    0x8(%ebp),%eax
  80458f:	83 e8 04             	sub    $0x4,%eax
  804592:	8b 00                	mov    (%eax),%eax
  804594:	83 e0 fe             	and    $0xfffffffe,%eax
  804597:	89 c2                	mov    %eax,%edx
  804599:	8b 45 08             	mov    0x8(%ebp),%eax
  80459c:	01 d0                	add    %edx,%eax
  80459e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8045a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045a5:	74 06                	je     8045ad <realloc_block_FF+0x613>
  8045a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8045ab:	75 17                	jne    8045c4 <realloc_block_FF+0x62a>
  8045ad:	83 ec 04             	sub    $0x4,%esp
  8045b0:	68 24 59 80 00       	push   $0x805924
  8045b5:	68 44 02 00 00       	push   $0x244
  8045ba:	68 b1 58 80 00       	push   $0x8058b1
  8045bf:	e8 cd ca ff ff       	call   801091 <_panic>
  8045c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c7:	8b 10                	mov    (%eax),%edx
  8045c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045cc:	89 10                	mov    %edx,(%eax)
  8045ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045d1:	8b 00                	mov    (%eax),%eax
  8045d3:	85 c0                	test   %eax,%eax
  8045d5:	74 0b                	je     8045e2 <realloc_block_FF+0x648>
  8045d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045da:	8b 00                	mov    (%eax),%eax
  8045dc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045df:	89 50 04             	mov    %edx,0x4(%eax)
  8045e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045e8:	89 10                	mov    %edx,(%eax)
  8045ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045f0:	89 50 04             	mov    %edx,0x4(%eax)
  8045f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045f6:	8b 00                	mov    (%eax),%eax
  8045f8:	85 c0                	test   %eax,%eax
  8045fa:	75 08                	jne    804604 <realloc_block_FF+0x66a>
  8045fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045ff:	a3 48 60 80 00       	mov    %eax,0x806048
  804604:	a1 50 60 80 00       	mov    0x806050,%eax
  804609:	40                   	inc    %eax
  80460a:	a3 50 60 80 00       	mov    %eax,0x806050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80460f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804613:	75 17                	jne    80462c <realloc_block_FF+0x692>
  804615:	83 ec 04             	sub    $0x4,%esp
  804618:	68 93 58 80 00       	push   $0x805893
  80461d:	68 45 02 00 00       	push   $0x245
  804622:	68 b1 58 80 00       	push   $0x8058b1
  804627:	e8 65 ca ff ff       	call   801091 <_panic>
  80462c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80462f:	8b 00                	mov    (%eax),%eax
  804631:	85 c0                	test   %eax,%eax
  804633:	74 10                	je     804645 <realloc_block_FF+0x6ab>
  804635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804638:	8b 00                	mov    (%eax),%eax
  80463a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80463d:	8b 52 04             	mov    0x4(%edx),%edx
  804640:	89 50 04             	mov    %edx,0x4(%eax)
  804643:	eb 0b                	jmp    804650 <realloc_block_FF+0x6b6>
  804645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804648:	8b 40 04             	mov    0x4(%eax),%eax
  80464b:	a3 48 60 80 00       	mov    %eax,0x806048
  804650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804653:	8b 40 04             	mov    0x4(%eax),%eax
  804656:	85 c0                	test   %eax,%eax
  804658:	74 0f                	je     804669 <realloc_block_FF+0x6cf>
  80465a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80465d:	8b 40 04             	mov    0x4(%eax),%eax
  804660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804663:	8b 12                	mov    (%edx),%edx
  804665:	89 10                	mov    %edx,(%eax)
  804667:	eb 0a                	jmp    804673 <realloc_block_FF+0x6d9>
  804669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80466c:	8b 00                	mov    (%eax),%eax
  80466e:	a3 44 60 80 00       	mov    %eax,0x806044
  804673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80467c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80467f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804686:	a1 50 60 80 00       	mov    0x806050,%eax
  80468b:	48                   	dec    %eax
  80468c:	a3 50 60 80 00       	mov    %eax,0x806050
				set_block_data(next_new_va, remaining_size, 0);
  804691:	83 ec 04             	sub    $0x4,%esp
  804694:	6a 00                	push   $0x0
  804696:	ff 75 bc             	pushl  -0x44(%ebp)
  804699:	ff 75 b8             	pushl  -0x48(%ebp)
  80469c:	e8 06 e9 ff ff       	call   802fa7 <set_block_data>
  8046a1:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8046a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a7:	eb 0a                	jmp    8046b3 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8046a9:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8046b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8046b3:	c9                   	leave  
  8046b4:	c3                   	ret    

008046b5 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8046b5:	55                   	push   %ebp
  8046b6:	89 e5                	mov    %esp,%ebp
  8046b8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8046bb:	83 ec 04             	sub    $0x4,%esp
  8046be:	68 a8 59 80 00       	push   $0x8059a8
  8046c3:	68 58 02 00 00       	push   $0x258
  8046c8:	68 b1 58 80 00       	push   $0x8058b1
  8046cd:	e8 bf c9 ff ff       	call   801091 <_panic>

008046d2 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8046d2:	55                   	push   %ebp
  8046d3:	89 e5                	mov    %esp,%ebp
  8046d5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8046d8:	83 ec 04             	sub    $0x4,%esp
  8046db:	68 d0 59 80 00       	push   $0x8059d0
  8046e0:	68 61 02 00 00       	push   $0x261
  8046e5:	68 b1 58 80 00       	push   $0x8058b1
  8046ea:	e8 a2 c9 ff ff       	call   801091 <_panic>
  8046ef:	90                   	nop

008046f0 <__udivdi3>:
  8046f0:	55                   	push   %ebp
  8046f1:	57                   	push   %edi
  8046f2:	56                   	push   %esi
  8046f3:	53                   	push   %ebx
  8046f4:	83 ec 1c             	sub    $0x1c,%esp
  8046f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804703:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804707:	89 ca                	mov    %ecx,%edx
  804709:	89 f8                	mov    %edi,%eax
  80470b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80470f:	85 f6                	test   %esi,%esi
  804711:	75 2d                	jne    804740 <__udivdi3+0x50>
  804713:	39 cf                	cmp    %ecx,%edi
  804715:	77 65                	ja     80477c <__udivdi3+0x8c>
  804717:	89 fd                	mov    %edi,%ebp
  804719:	85 ff                	test   %edi,%edi
  80471b:	75 0b                	jne    804728 <__udivdi3+0x38>
  80471d:	b8 01 00 00 00       	mov    $0x1,%eax
  804722:	31 d2                	xor    %edx,%edx
  804724:	f7 f7                	div    %edi
  804726:	89 c5                	mov    %eax,%ebp
  804728:	31 d2                	xor    %edx,%edx
  80472a:	89 c8                	mov    %ecx,%eax
  80472c:	f7 f5                	div    %ebp
  80472e:	89 c1                	mov    %eax,%ecx
  804730:	89 d8                	mov    %ebx,%eax
  804732:	f7 f5                	div    %ebp
  804734:	89 cf                	mov    %ecx,%edi
  804736:	89 fa                	mov    %edi,%edx
  804738:	83 c4 1c             	add    $0x1c,%esp
  80473b:	5b                   	pop    %ebx
  80473c:	5e                   	pop    %esi
  80473d:	5f                   	pop    %edi
  80473e:	5d                   	pop    %ebp
  80473f:	c3                   	ret    
  804740:	39 ce                	cmp    %ecx,%esi
  804742:	77 28                	ja     80476c <__udivdi3+0x7c>
  804744:	0f bd fe             	bsr    %esi,%edi
  804747:	83 f7 1f             	xor    $0x1f,%edi
  80474a:	75 40                	jne    80478c <__udivdi3+0x9c>
  80474c:	39 ce                	cmp    %ecx,%esi
  80474e:	72 0a                	jb     80475a <__udivdi3+0x6a>
  804750:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804754:	0f 87 9e 00 00 00    	ja     8047f8 <__udivdi3+0x108>
  80475a:	b8 01 00 00 00       	mov    $0x1,%eax
  80475f:	89 fa                	mov    %edi,%edx
  804761:	83 c4 1c             	add    $0x1c,%esp
  804764:	5b                   	pop    %ebx
  804765:	5e                   	pop    %esi
  804766:	5f                   	pop    %edi
  804767:	5d                   	pop    %ebp
  804768:	c3                   	ret    
  804769:	8d 76 00             	lea    0x0(%esi),%esi
  80476c:	31 ff                	xor    %edi,%edi
  80476e:	31 c0                	xor    %eax,%eax
  804770:	89 fa                	mov    %edi,%edx
  804772:	83 c4 1c             	add    $0x1c,%esp
  804775:	5b                   	pop    %ebx
  804776:	5e                   	pop    %esi
  804777:	5f                   	pop    %edi
  804778:	5d                   	pop    %ebp
  804779:	c3                   	ret    
  80477a:	66 90                	xchg   %ax,%ax
  80477c:	89 d8                	mov    %ebx,%eax
  80477e:	f7 f7                	div    %edi
  804780:	31 ff                	xor    %edi,%edi
  804782:	89 fa                	mov    %edi,%edx
  804784:	83 c4 1c             	add    $0x1c,%esp
  804787:	5b                   	pop    %ebx
  804788:	5e                   	pop    %esi
  804789:	5f                   	pop    %edi
  80478a:	5d                   	pop    %ebp
  80478b:	c3                   	ret    
  80478c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804791:	89 eb                	mov    %ebp,%ebx
  804793:	29 fb                	sub    %edi,%ebx
  804795:	89 f9                	mov    %edi,%ecx
  804797:	d3 e6                	shl    %cl,%esi
  804799:	89 c5                	mov    %eax,%ebp
  80479b:	88 d9                	mov    %bl,%cl
  80479d:	d3 ed                	shr    %cl,%ebp
  80479f:	89 e9                	mov    %ebp,%ecx
  8047a1:	09 f1                	or     %esi,%ecx
  8047a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047a7:	89 f9                	mov    %edi,%ecx
  8047a9:	d3 e0                	shl    %cl,%eax
  8047ab:	89 c5                	mov    %eax,%ebp
  8047ad:	89 d6                	mov    %edx,%esi
  8047af:	88 d9                	mov    %bl,%cl
  8047b1:	d3 ee                	shr    %cl,%esi
  8047b3:	89 f9                	mov    %edi,%ecx
  8047b5:	d3 e2                	shl    %cl,%edx
  8047b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047bb:	88 d9                	mov    %bl,%cl
  8047bd:	d3 e8                	shr    %cl,%eax
  8047bf:	09 c2                	or     %eax,%edx
  8047c1:	89 d0                	mov    %edx,%eax
  8047c3:	89 f2                	mov    %esi,%edx
  8047c5:	f7 74 24 0c          	divl   0xc(%esp)
  8047c9:	89 d6                	mov    %edx,%esi
  8047cb:	89 c3                	mov    %eax,%ebx
  8047cd:	f7 e5                	mul    %ebp
  8047cf:	39 d6                	cmp    %edx,%esi
  8047d1:	72 19                	jb     8047ec <__udivdi3+0xfc>
  8047d3:	74 0b                	je     8047e0 <__udivdi3+0xf0>
  8047d5:	89 d8                	mov    %ebx,%eax
  8047d7:	31 ff                	xor    %edi,%edi
  8047d9:	e9 58 ff ff ff       	jmp    804736 <__udivdi3+0x46>
  8047de:	66 90                	xchg   %ax,%ax
  8047e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047e4:	89 f9                	mov    %edi,%ecx
  8047e6:	d3 e2                	shl    %cl,%edx
  8047e8:	39 c2                	cmp    %eax,%edx
  8047ea:	73 e9                	jae    8047d5 <__udivdi3+0xe5>
  8047ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047ef:	31 ff                	xor    %edi,%edi
  8047f1:	e9 40 ff ff ff       	jmp    804736 <__udivdi3+0x46>
  8047f6:	66 90                	xchg   %ax,%ax
  8047f8:	31 c0                	xor    %eax,%eax
  8047fa:	e9 37 ff ff ff       	jmp    804736 <__udivdi3+0x46>
  8047ff:	90                   	nop

00804800 <__umoddi3>:
  804800:	55                   	push   %ebp
  804801:	57                   	push   %edi
  804802:	56                   	push   %esi
  804803:	53                   	push   %ebx
  804804:	83 ec 1c             	sub    $0x1c,%esp
  804807:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80480b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80480f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804813:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804817:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80481b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80481f:	89 f3                	mov    %esi,%ebx
  804821:	89 fa                	mov    %edi,%edx
  804823:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804827:	89 34 24             	mov    %esi,(%esp)
  80482a:	85 c0                	test   %eax,%eax
  80482c:	75 1a                	jne    804848 <__umoddi3+0x48>
  80482e:	39 f7                	cmp    %esi,%edi
  804830:	0f 86 a2 00 00 00    	jbe    8048d8 <__umoddi3+0xd8>
  804836:	89 c8                	mov    %ecx,%eax
  804838:	89 f2                	mov    %esi,%edx
  80483a:	f7 f7                	div    %edi
  80483c:	89 d0                	mov    %edx,%eax
  80483e:	31 d2                	xor    %edx,%edx
  804840:	83 c4 1c             	add    $0x1c,%esp
  804843:	5b                   	pop    %ebx
  804844:	5e                   	pop    %esi
  804845:	5f                   	pop    %edi
  804846:	5d                   	pop    %ebp
  804847:	c3                   	ret    
  804848:	39 f0                	cmp    %esi,%eax
  80484a:	0f 87 ac 00 00 00    	ja     8048fc <__umoddi3+0xfc>
  804850:	0f bd e8             	bsr    %eax,%ebp
  804853:	83 f5 1f             	xor    $0x1f,%ebp
  804856:	0f 84 ac 00 00 00    	je     804908 <__umoddi3+0x108>
  80485c:	bf 20 00 00 00       	mov    $0x20,%edi
  804861:	29 ef                	sub    %ebp,%edi
  804863:	89 fe                	mov    %edi,%esi
  804865:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804869:	89 e9                	mov    %ebp,%ecx
  80486b:	d3 e0                	shl    %cl,%eax
  80486d:	89 d7                	mov    %edx,%edi
  80486f:	89 f1                	mov    %esi,%ecx
  804871:	d3 ef                	shr    %cl,%edi
  804873:	09 c7                	or     %eax,%edi
  804875:	89 e9                	mov    %ebp,%ecx
  804877:	d3 e2                	shl    %cl,%edx
  804879:	89 14 24             	mov    %edx,(%esp)
  80487c:	89 d8                	mov    %ebx,%eax
  80487e:	d3 e0                	shl    %cl,%eax
  804880:	89 c2                	mov    %eax,%edx
  804882:	8b 44 24 08          	mov    0x8(%esp),%eax
  804886:	d3 e0                	shl    %cl,%eax
  804888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80488c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804890:	89 f1                	mov    %esi,%ecx
  804892:	d3 e8                	shr    %cl,%eax
  804894:	09 d0                	or     %edx,%eax
  804896:	d3 eb                	shr    %cl,%ebx
  804898:	89 da                	mov    %ebx,%edx
  80489a:	f7 f7                	div    %edi
  80489c:	89 d3                	mov    %edx,%ebx
  80489e:	f7 24 24             	mull   (%esp)
  8048a1:	89 c6                	mov    %eax,%esi
  8048a3:	89 d1                	mov    %edx,%ecx
  8048a5:	39 d3                	cmp    %edx,%ebx
  8048a7:	0f 82 87 00 00 00    	jb     804934 <__umoddi3+0x134>
  8048ad:	0f 84 91 00 00 00    	je     804944 <__umoddi3+0x144>
  8048b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048b7:	29 f2                	sub    %esi,%edx
  8048b9:	19 cb                	sbb    %ecx,%ebx
  8048bb:	89 d8                	mov    %ebx,%eax
  8048bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048c1:	d3 e0                	shl    %cl,%eax
  8048c3:	89 e9                	mov    %ebp,%ecx
  8048c5:	d3 ea                	shr    %cl,%edx
  8048c7:	09 d0                	or     %edx,%eax
  8048c9:	89 e9                	mov    %ebp,%ecx
  8048cb:	d3 eb                	shr    %cl,%ebx
  8048cd:	89 da                	mov    %ebx,%edx
  8048cf:	83 c4 1c             	add    $0x1c,%esp
  8048d2:	5b                   	pop    %ebx
  8048d3:	5e                   	pop    %esi
  8048d4:	5f                   	pop    %edi
  8048d5:	5d                   	pop    %ebp
  8048d6:	c3                   	ret    
  8048d7:	90                   	nop
  8048d8:	89 fd                	mov    %edi,%ebp
  8048da:	85 ff                	test   %edi,%edi
  8048dc:	75 0b                	jne    8048e9 <__umoddi3+0xe9>
  8048de:	b8 01 00 00 00       	mov    $0x1,%eax
  8048e3:	31 d2                	xor    %edx,%edx
  8048e5:	f7 f7                	div    %edi
  8048e7:	89 c5                	mov    %eax,%ebp
  8048e9:	89 f0                	mov    %esi,%eax
  8048eb:	31 d2                	xor    %edx,%edx
  8048ed:	f7 f5                	div    %ebp
  8048ef:	89 c8                	mov    %ecx,%eax
  8048f1:	f7 f5                	div    %ebp
  8048f3:	89 d0                	mov    %edx,%eax
  8048f5:	e9 44 ff ff ff       	jmp    80483e <__umoddi3+0x3e>
  8048fa:	66 90                	xchg   %ax,%ax
  8048fc:	89 c8                	mov    %ecx,%eax
  8048fe:	89 f2                	mov    %esi,%edx
  804900:	83 c4 1c             	add    $0x1c,%esp
  804903:	5b                   	pop    %ebx
  804904:	5e                   	pop    %esi
  804905:	5f                   	pop    %edi
  804906:	5d                   	pop    %ebp
  804907:	c3                   	ret    
  804908:	3b 04 24             	cmp    (%esp),%eax
  80490b:	72 06                	jb     804913 <__umoddi3+0x113>
  80490d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804911:	77 0f                	ja     804922 <__umoddi3+0x122>
  804913:	89 f2                	mov    %esi,%edx
  804915:	29 f9                	sub    %edi,%ecx
  804917:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80491b:	89 14 24             	mov    %edx,(%esp)
  80491e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804922:	8b 44 24 04          	mov    0x4(%esp),%eax
  804926:	8b 14 24             	mov    (%esp),%edx
  804929:	83 c4 1c             	add    $0x1c,%esp
  80492c:	5b                   	pop    %ebx
  80492d:	5e                   	pop    %esi
  80492e:	5f                   	pop    %edi
  80492f:	5d                   	pop    %ebp
  804930:	c3                   	ret    
  804931:	8d 76 00             	lea    0x0(%esi),%esi
  804934:	2b 04 24             	sub    (%esp),%eax
  804937:	19 fa                	sbb    %edi,%edx
  804939:	89 d1                	mov    %edx,%ecx
  80493b:	89 c6                	mov    %eax,%esi
  80493d:	e9 71 ff ff ff       	jmp    8048b3 <__umoddi3+0xb3>
  804942:	66 90                	xchg   %ax,%ax
  804944:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804948:	72 ea                	jb     804934 <__umoddi3+0x134>
  80494a:	89 d9                	mov    %ebx,%ecx
  80494c:	e9 62 ff ff ff       	jmp    8048b3 <__umoddi3+0xb3>
