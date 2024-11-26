
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 8b 05 00 00       	call   8005c1 <libmain>
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
  800055:	68 e0 3f 80 00       	push   $0x803fe0
  80005a:	e8 5e 09 00 00       	call   8009bd <cprintf>
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
  8000a5:	68 10 40 80 00       	push   $0x804010
  8000aa:	e8 0e 09 00 00       	call   8009bd <cprintf>
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
  8000c3:	53                   	push   %ebx
  8000c4:	81 ec a4 00 00 00    	sub    $0xa4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8000cf:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  8000d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8000da:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 49 40 80 00       	push   $0x804049
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 65 40 80 00       	push   $0x804065
  8000f3:	e8 08 06 00 00       	call   800700 <_panic>
#endif

	/*=================================================*/


	int eval = 0;
  8000f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800106:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800114:	e8 ee 1c 00 00       	call   801e07 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 9b 1c 00 00       	call   801dbc <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 7c 40 80 00       	push   $0x80407c
  80012c:	e8 8c 08 00 00       	call   8009bd <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  80013b:	c7 45 e0 04 00 00 80 	movl   $0x80000004,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800142:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800150:	e9 9e 01 00 00       	jmp    8002f3 <_main+0x233>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800155:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80015c:	e9 82 01 00 00       	jmp    8002e3 <_main+0x223>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 f1 15 00 00       	call   80176d <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 60 7c 80 00 	mov    %edx,0x807c60(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 60 66 80 00 	mov    %edx,0x806660(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001e6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	48                   	dec    %eax
  8001f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	f7 75 b0             	divl   -0x50(%ebp)
  800204:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800207:	29 d0                	sub    %edx,%eax
  800209:	89 45 a8             	mov    %eax,-0x58(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80020c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80020f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800212:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800215:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  800219:	7e 48                	jle    800263 <_main+0x1a3>
  80021b:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
  80021f:	7f 42                	jg     800263 <_main+0x1a3>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800221:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  800228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80022b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80022e:	01 d0                	add    %edx,%eax
  800230:	48                   	dec    %eax
  800231:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800234:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800237:	ba 00 00 00 00       	mov    $0x0,%edx
  80023c:	f7 75 a0             	divl   -0x60(%ebp)
  80023f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800242:	29 d0                	sub    %edx,%eax
  800244:	83 e8 04             	sub    $0x4,%eax
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  80024a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80024d:	83 e8 04             	sub    $0x4,%eax
  800250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800253:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800259:	01 d0                	add    %edx,%eax
  80025b:	83 e8 04             	sub    $0x4,%eax
  80025e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800261:	eb 0d                	jmp    800270 <_main+0x1b0>
				}
				else
				{
					curVA += allocSizes[i] ;
  800263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800266:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80026d:	01 45 e0             	add    %eax,-0x20(%ebp)
				}
				//============================================================
				if (is_correct)
  800270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800274:	74 37                	je     8002ad <_main+0x1ed>
				{
					if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800276:	6a 01                	push   $0x1
  800278:	ff 75 e8             	pushl  -0x18(%ebp)
  80027b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	e8 b2 fd ff ff       	call   800038 <check_block>
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	85 c0                	test   %eax,%eax
  80028b:	75 20                	jne    8002ad <_main+0x1ed>
					{
						if (is_correct)
  80028d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800291:	74 1a                	je     8002ad <_main+0x1ed>
						{
							is_correct = 0;
  800293:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
							cprintf("alloc_block_xx #1.%d: WRONG ALLOC\n", idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	ff 75 ec             	pushl  -0x14(%ebp)
  8002a0:	68 d8 40 80 00       	push   $0x8040d8
  8002a5:	e8 13 07 00 00       	call   8009bd <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b0:	8b 14 85 60 50 80 00 	mov    0x805060(,%eax,4),%edx
  8002b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ba:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c0:	8b 14 85 60 7c 80 00 	mov    0x807c60(,%eax,4),%edx
  8002c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ca:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d0:	8b 14 85 60 66 80 00 	mov    0x806660(,%eax,4),%edx
  8002d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002da:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8002dd:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002e0:	ff 45 d8             	incl   -0x28(%ebp)
  8002e3:	81 7d d8 c7 00 00 00 	cmpl   $0xc7,-0x28(%ebp)
  8002ea:	0f 8e 71 fe ff ff    	jle    800161 <_main+0xa1>
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  8002f0:	ff 45 dc             	incl   -0x24(%ebp)
  8002f3:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  8002f7:	0f 8e 58 fe ff ff    	jle    800155 <_main+0x95>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  8002fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800301:	74 04                	je     800307 <_main+0x247>
		{
			eval += 30;
  800303:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 fc 40 80 00       	push   $0x8040fc
  80030f:	e8 a9 06 00 00       	call   8009bd <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800317:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  80031e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800325:	eb 5b                	jmp    800382 <_main+0x2c2>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  800327:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  800331:	66 8b 00             	mov    (%eax),%ax
  800334:	98                   	cwtl   
  800335:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800338:	75 26                	jne    800360 <_main+0x2a0>
  80033a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033d:	8b 04 85 60 7c 80 00 	mov    0x807c60(,%eax,4),%eax
  800344:	66 8b 00             	mov    (%eax),%ax
  800347:	98                   	cwtl   
  800348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80034b:	75 13                	jne    800360 <_main+0x2a0>
  80034d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800350:	8b 04 85 60 66 80 00 	mov    0x806660(,%eax,4),%eax
  800357:	66 8b 00             	mov    (%eax),%ax
  80035a:	98                   	cwtl   
  80035b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80035e:	74 1f                	je     80037f <_main+0x2bf>
			{
				is_correct = 0;
  800360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800370:	68 38 41 80 00       	push   $0x804138
  800375:	e8 43 06 00 00       	call   8009bd <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
				break;
  80037d:	eb 0b                	jmp    80038a <_main+0x2ca>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  80037f:	ff 45 d4             	incl   -0x2c(%ebp)
  800382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800385:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800388:	7c 9d                	jl     800327 <_main+0x267>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  80038a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80038e:	74 04                	je     800394 <_main+0x2d4>
		{
			eval += 30;
  800390:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	/*Check page file*/
	cprintf("%~\n3: Check page file size (nothing should be allocated) [10%]\n") ;
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 88 41 80 00       	push   $0x804188
  80039c:	e8 1c 06 00 00       	call   8009bd <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 57 1a 00 00       	call   801e07 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 c8 41 80 00       	push   $0x8041c8
  8003bd:	e8 fb 05 00 00       	call   8009bd <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8003c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8003cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003d0:	74 04                	je     8003d6 <_main+0x316>
		{
			eval += 10;
  8003d2:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8003d6:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
//	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
	expectedAllocatedSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8003dd:	c7 45 94 00 10 00 00 	movl   $0x1000,-0x6c(%ebp)
  8003e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	48                   	dec    %eax
  8003ed:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f8:	f7 75 94             	divl   -0x6c(%ebp)
  8003fb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003fe:	29 d0                	sub    %edx,%eax
  800400:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800403:	8b 45 98             	mov    -0x68(%ebp),%eax
  800406:	c1 e8 0c             	shr    $0xc,%eax
  800409:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  80040c:	c7 45 88 00 00 40 00 	movl   $0x400000,-0x78(%ebp)
  800413:	8b 55 98             	mov    -0x68(%ebp),%edx
  800416:	8b 45 88             	mov    -0x78(%ebp),%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	48                   	dec    %eax
  80041c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  80041f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800422:	ba 00 00 00 00       	mov    $0x0,%edx
  800427:	f7 75 88             	divl   -0x78(%ebp)
  80042a:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80042d:	29 d0                	sub    %edx,%eax
  80042f:	c1 e8 16             	shr    $0x16,%eax
  800432:	89 45 80             	mov    %eax,-0x80(%ebp)
	uint32 expectedAllocNumOfPagesForWS = ROUNDUP(expectedAllocNumOfPages * (sizeof(struct WorkingSetElement) + sizeOfMetaData), PAGE_SIZE) / PAGE_SIZE; 				/*# pages*/
  800435:	c7 85 7c ff ff ff 00 	movl   $0x1000,-0x84(%ebp)
  80043c:	10 00 00 
  80043f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800442:	c1 e0 05             	shl    $0x5,%eax
  800445:	89 c2                	mov    %eax,%edx
  800447:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80044d:	01 d0                	add    %edx,%eax
  80044f:	48                   	dec    %eax
  800450:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800456:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80045c:	ba 00 00 00 00       	mov    $0x0,%edx
  800461:	f7 b5 7c ff ff ff    	divl   -0x84(%ebp)
  800467:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80046d:	29 d0                	sub    %edx,%eax
  80046f:	c1 e8 0c             	shr    $0xc,%eax
  800472:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	/*Check memory allocation*/
	cprintf("%~\n4: Check total allocation in RAM (for pages, tables & WS) [10%]\n") ;
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 04 42 80 00       	push   $0x804204
  800480:	e8 38 05 00 00       	call   8009bd <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800488:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32 expected = expectedAllocNumOfPages + expectedAllocNumOfTables  + expectedAllocNumOfPagesForWS;
  80048f:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800492:	8b 45 80             	mov    -0x80(%ebp),%eax
  800495:	01 c2                	add    %eax,%edx
  800497:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		uint32 actual = (freeFrames - sys_calculate_free_frames()) ;
  8004a5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004a8:	e8 0f 19 00 00       	call   801dbc <sys_calculate_free_frames>
  8004ad:	29 c3                	sub    %eax,%ebx
  8004af:	89 d8                	mov    %ebx,%eax
  8004b1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if (expected != actual)
  8004b7:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8004bd:	3b 85 6c ff ff ff    	cmp    -0x94(%ebp),%eax
  8004c3:	74 23                	je     8004e8 <_main+0x428>
		{
			cprintf("number of allocated pages in MEMORY not correct. Expected %d, Actual %d\n", expected, actual);
  8004c5:	83 ec 04             	sub    $0x4,%esp
  8004c8:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  8004ce:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8004d4:	68 48 42 80 00       	push   $0x804248
  8004d9:	e8 df 04 00 00       	call   8009bd <cprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8004e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8004e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8004ec:	74 04                	je     8004f2 <_main+0x432>
		{
			eval += 10;
  8004ee:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	cprintf("%~\n5: Check content of WS [20%]\n") ;
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	68 94 42 80 00       	push   $0x804294
  8004fa:	e8 be 04 00 00       	call   8009bd <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800509:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80050c:	c1 e0 02             	shl    $0x2,%eax
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	50                   	push   %eax
  800513:	e8 55 12 00 00       	call   80176d <malloc>
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int i = 0;
  800521:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800528:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  80052f:	eb 24                	jmp    800555 <_main+0x495>
		{
			expectedVAs[i++] = va;
  800531:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800534:	8d 50 01             	lea    0x1(%eax),%edx
  800537:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80053a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800541:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800547:	01 c2                	add    %eax,%edx
  800549:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054c:	89 02                	mov    %eax,(%edx)
	cprintf("%~\n5: Check content of WS [20%]\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  80054e:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  800555:	8b 45 98             	mov    -0x68(%ebp),%eax
  800558:	05 00 00 00 80       	add    $0x80000000,%eax
  80055d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800560:	77 cf                	ja     800531 <_main+0x471>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800562:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800565:	6a 02                	push   $0x2
  800567:	6a 00                	push   $0x0
  800569:	50                   	push   %eax
  80056a:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800570:	e8 a2 1c 00 00       	call   802217 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 b8 42 80 00       	push   $0x8042b8
  80058f:	e8 29 04 00 00       	call   8009bd <cprintf>
  800594:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  80059e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005a2:	74 04                	je     8005a8 <_main+0x4e8>
		{
			eval += 20;
  8005a4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}

	cprintf("%~\ntest malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	68 dc 42 80 00       	push   $0x8042dc
  8005b3:	e8 05 04 00 00       	call   8009bd <cprintf>
  8005b8:	83 c4 10             	add    $0x10,%esp

	return;
  8005bb:	90                   	nop
}
  8005bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005c7:	e8 b9 19 00 00       	call   801f85 <sys_getenvindex>
  8005cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8005cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	c1 e0 03             	shl    $0x3,%eax
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005e0:	01 c8                	add    %ecx,%eax
  8005e2:	01 c0                	add    %eax,%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005ed:	01 c8                	add    %ecx,%eax
  8005ef:	01 d0                	add    %edx,%eax
  8005f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005f6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800600:	8a 40 20             	mov    0x20(%eax),%al
  800603:	84 c0                	test   %al,%al
  800605:	74 0d                	je     800614 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800607:	a1 20 50 80 00       	mov    0x805020,%eax
  80060c:	83 c0 20             	add    $0x20,%eax
  80060f:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800618:	7e 0a                	jle    800624 <libmain+0x63>
		binaryname = argv[0];
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	_main(argc, argv);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	ff 75 08             	pushl  0x8(%ebp)
  80062d:	e8 8e fa ff ff       	call   8000c0 <_main>
  800632:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800635:	e8 cf 16 00 00       	call   801d09 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	68 3c 43 80 00       	push   $0x80433c
  800642:	e8 76 03 00 00       	call   8009bd <cprintf>
  800647:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80064a:	a1 20 50 80 00       	mov    0x805020,%eax
  80064f:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800655:	a1 20 50 80 00       	mov    0x805020,%eax
  80065a:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 64 43 80 00       	push   $0x804364
  80066a:	e8 4e 03 00 00       	call   8009bd <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80067d:	a1 20 50 80 00       	mov    0x805020,%eax
  800682:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800688:	a1 20 50 80 00       	mov    0x805020,%eax
  80068d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800693:	51                   	push   %ecx
  800694:	52                   	push   %edx
  800695:	50                   	push   %eax
  800696:	68 8c 43 80 00       	push   $0x80438c
  80069b:	e8 1d 03 00 00       	call   8009bd <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	50                   	push   %eax
  8006b2:	68 e4 43 80 00       	push   $0x8043e4
  8006b7:	e8 01 03 00 00       	call   8009bd <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 3c 43 80 00       	push   $0x80433c
  8006c7:	e8 f1 02 00 00       	call   8009bd <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006cf:	e8 4f 16 00 00       	call   801d23 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8006d4:	e8 19 00 00 00       	call   8006f2 <exit>
}
  8006d9:	90                   	nop
  8006da:	c9                   	leave  
  8006db:	c3                   	ret    

008006dc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	6a 00                	push   $0x0
  8006e7:	e8 65 18 00 00       	call   801f51 <sys_destroy_env>
  8006ec:	83 c4 10             	add    $0x10,%esp
}
  8006ef:	90                   	nop
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    

008006f2 <exit>:

void
exit(void)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006f8:	e8 ba 18 00 00       	call   801fb7 <sys_exit_env>
}
  8006fd:	90                   	nop
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800706:	8d 45 10             	lea    0x10(%ebp),%eax
  800709:	83 c0 04             	add    $0x4,%eax
  80070c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80070f:	a1 54 92 80 00       	mov    0x809254,%eax
  800714:	85 c0                	test   %eax,%eax
  800716:	74 16                	je     80072e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800718:	a1 54 92 80 00       	mov    0x809254,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	68 f8 43 80 00       	push   $0x8043f8
  800726:	e8 92 02 00 00       	call   8009bd <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80072e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	50                   	push   %eax
  80073a:	68 fd 43 80 00       	push   $0x8043fd
  80073f:	e8 79 02 00 00       	call   8009bd <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800747:	8b 45 10             	mov    0x10(%ebp),%eax
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 f4             	pushl  -0xc(%ebp)
  800750:	50                   	push   %eax
  800751:	e8 fc 01 00 00       	call   800952 <vcprintf>
  800756:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	6a 00                	push   $0x0
  80075e:	68 19 44 80 00       	push   $0x804419
  800763:	e8 ea 01 00 00       	call   800952 <vcprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80076b:	e8 82 ff ff ff       	call   8006f2 <exit>

	// should not return here
	while (1) ;
  800770:	eb fe                	jmp    800770 <_panic+0x70>

00800772 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800778:	a1 20 50 80 00       	mov    0x805020,%eax
  80077d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800783:	8b 45 0c             	mov    0xc(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 14                	je     80079e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 1c 44 80 00       	push   $0x80441c
  800792:	6a 26                	push   $0x26
  800794:	68 68 44 80 00       	push   $0x804468
  800799:	e8 62 ff ff ff       	call   800700 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80079e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007ac:	e9 c5 00 00 00       	jmp    800876 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	75 08                	jne    8007ce <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8007c6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007c9:	e9 a5 00 00 00       	jmp    800873 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8007ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007dc:	eb 69                	jmp    800847 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007de:	a1 20 50 80 00       	mov    0x805020,%eax
  8007e3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8007e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	01 c0                	add    %eax,%eax
  8007f0:	01 d0                	add    %edx,%eax
  8007f2:	c1 e0 03             	shl    $0x3,%eax
  8007f5:	01 c8                	add    %ecx,%eax
  8007f7:	8a 40 04             	mov    0x4(%eax),%al
  8007fa:	84 c0                	test   %al,%al
  8007fc:	75 46                	jne    800844 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800803:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800809:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080c:	89 d0                	mov    %edx,%eax
  80080e:	01 c0                	add    %eax,%eax
  800810:	01 d0                	add    %edx,%eax
  800812:	c1 e0 03             	shl    $0x3,%eax
  800815:	01 c8                	add    %ecx,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80081c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80081f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800824:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800829:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	01 c8                	add    %ecx,%eax
  800835:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800837:	39 c2                	cmp    %eax,%edx
  800839:	75 09                	jne    800844 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80083b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800842:	eb 15                	jmp    800859 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800844:	ff 45 e8             	incl   -0x18(%ebp)
  800847:	a1 20 50 80 00       	mov    0x805020,%eax
  80084c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800855:	39 c2                	cmp    %eax,%edx
  800857:	77 85                	ja     8007de <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800859:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80085d:	75 14                	jne    800873 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	68 74 44 80 00       	push   $0x804474
  800867:	6a 3a                	push   $0x3a
  800869:	68 68 44 80 00       	push   $0x804468
  80086e:	e8 8d fe ff ff       	call   800700 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800873:	ff 45 f0             	incl   -0x10(%ebp)
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087c:	0f 8c 2f ff ff ff    	jl     8007b1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800882:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800889:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800890:	eb 26                	jmp    8008b8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800892:	a1 20 50 80 00       	mov    0x805020,%eax
  800897:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80089d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a0:	89 d0                	mov    %edx,%eax
  8008a2:	01 c0                	add    %eax,%eax
  8008a4:	01 d0                	add    %edx,%eax
  8008a6:	c1 e0 03             	shl    $0x3,%eax
  8008a9:	01 c8                	add    %ecx,%eax
  8008ab:	8a 40 04             	mov    0x4(%eax),%al
  8008ae:	3c 01                	cmp    $0x1,%al
  8008b0:	75 03                	jne    8008b5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008b2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b5:	ff 45 e0             	incl   -0x20(%ebp)
  8008b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c6:	39 c2                	cmp    %eax,%edx
  8008c8:	77 c8                	ja     800892 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008d0:	74 14                	je     8008e6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8008d2:	83 ec 04             	sub    $0x4,%esp
  8008d5:	68 c8 44 80 00       	push   $0x8044c8
  8008da:	6a 44                	push   $0x44
  8008dc:	68 68 44 80 00       	push   $0x804468
  8008e1:	e8 1a fe ff ff       	call   800700 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008e6:	90                   	nop
  8008e7:	c9                   	leave  
  8008e8:	c3                   	ret    

008008e9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	89 0a                	mov    %ecx,(%edx)
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	88 d1                	mov    %dl,%cl
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
  800904:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800912:	75 2c                	jne    800940 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800914:	a0 40 50 80 00       	mov    0x805040,%al
  800919:	0f b6 c0             	movzbl %al,%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	8b 12                	mov    (%edx),%edx
  800921:	89 d1                	mov    %edx,%ecx
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
  800926:	83 c2 08             	add    $0x8,%edx
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	50                   	push   %eax
  80092d:	51                   	push   %ecx
  80092e:	52                   	push   %edx
  80092f:	e8 93 13 00 00       	call   801cc7 <sys_cputs>
  800934:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	8b 40 04             	mov    0x4(%eax),%eax
  800946:	8d 50 01             	lea    0x1(%eax),%edx
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80094f:	90                   	nop
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80095b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800962:	00 00 00 
	b.cnt = 0;
  800965:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80096c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	ff 75 08             	pushl  0x8(%ebp)
  800975:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097b:	50                   	push   %eax
  80097c:	68 e9 08 80 00       	push   $0x8008e9
  800981:	e8 11 02 00 00       	call   800b97 <vprintfmt>
  800986:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800989:	a0 40 50 80 00       	mov    0x805040,%al
  80098e:	0f b6 c0             	movzbl %al,%eax
  800991:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	50                   	push   %eax
  80099b:	52                   	push   %edx
  80099c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009a2:	83 c0 08             	add    $0x8,%eax
  8009a5:	50                   	push   %eax
  8009a6:	e8 1c 13 00 00       	call   801cc7 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009ae:	c6 05 40 50 80 00 00 	movb   $0x0,0x805040
	return b.cnt;
  8009b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009c3:	c6 05 40 50 80 00 01 	movb   $0x1,0x805040
	va_start(ap, fmt);
  8009ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	50                   	push   %eax
  8009da:	e8 73 ff ff ff       	call   800952 <vcprintf>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8009f0:	e8 14 13 00 00       	call   801d09 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8009f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 f4             	pushl  -0xc(%ebp)
  800a04:	50                   	push   %eax
  800a05:	e8 48 ff ff ff       	call   800952 <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
  800a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a10:	e8 0e 13 00 00       	call   801d23 <sys_unlock_cons>
	return cnt;
  800a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	83 ec 14             	sub    $0x14,%esp
  800a21:	8b 45 10             	mov    0x10(%ebp),%eax
  800a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a2d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a30:	ba 00 00 00 00       	mov    $0x0,%edx
  800a35:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a38:	77 55                	ja     800a8f <printnum+0x75>
  800a3a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a3d:	72 05                	jb     800a44 <printnum+0x2a>
  800a3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a42:	77 4b                	ja     800a8f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a44:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a47:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	ff 75 f4             	pushl  -0xc(%ebp)
  800a57:	ff 75 f0             	pushl  -0x10(%ebp)
  800a5a:	e8 01 33 00 00       	call   803d60 <__udivdi3>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	83 ec 04             	sub    $0x4,%esp
  800a65:	ff 75 20             	pushl  0x20(%ebp)
  800a68:	53                   	push   %ebx
  800a69:	ff 75 18             	pushl  0x18(%ebp)
  800a6c:	52                   	push   %edx
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	e8 a1 ff ff ff       	call   800a1a <printnum>
  800a79:	83 c4 20             	add    $0x20,%esp
  800a7c:	eb 1a                	jmp    800a98 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	ff 75 20             	pushl  0x20(%ebp)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a8f:	ff 4d 1c             	decl   0x1c(%ebp)
  800a92:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a96:	7f e6                	jg     800a7e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a98:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa6:	53                   	push   %ebx
  800aa7:	51                   	push   %ecx
  800aa8:	52                   	push   %edx
  800aa9:	50                   	push   %eax
  800aaa:	e8 c1 33 00 00       	call   803e70 <__umoddi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	05 34 47 80 00       	add    $0x804734,%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	0f be c0             	movsbl %al,%eax
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
}
  800acb:	90                   	nop
  800acc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ad4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad8:	7e 1c                	jle    800af6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	8d 50 08             	lea    0x8(%eax),%edx
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	89 10                	mov    %edx,(%eax)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	83 e8 08             	sub    $0x8,%eax
  800aef:	8b 50 04             	mov    0x4(%eax),%edx
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	eb 40                	jmp    800b36 <getuint+0x65>
	else if (lflag)
  800af6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afa:	74 1e                	je     800b1a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 10                	mov    %edx,(%eax)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	ba 00 00 00 00       	mov    $0x0,%edx
  800b18:	eb 1c                	jmp    800b36 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 04             	lea    0x4(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b3b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b3f:	7e 1c                	jle    800b5d <getint+0x25>
		return va_arg(*ap, long long);
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	8d 50 08             	lea    0x8(%eax),%edx
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 10                	mov    %edx,(%eax)
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	83 e8 08             	sub    $0x8,%eax
  800b56:	8b 50 04             	mov    0x4(%eax),%edx
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	eb 38                	jmp    800b95 <getint+0x5d>
	else if (lflag)
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	74 1a                	je     800b7d <getint+0x45>
		return va_arg(*ap, long);
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	8d 50 04             	lea    0x4(%eax),%edx
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 10                	mov    %edx,(%eax)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	99                   	cltd   
  800b7b:	eb 18                	jmp    800b95 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	8d 50 04             	lea    0x4(%eax),%edx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	89 10                	mov    %edx,(%eax)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	83 e8 04             	sub    $0x4,%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	99                   	cltd   
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
  800b9c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9f:	eb 17                	jmp    800bb8 <vprintfmt+0x21>
			if (ch == '\0')
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	0f 84 c1 03 00 00    	je     800f6a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	53                   	push   %ebx
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	8d 50 01             	lea    0x1(%eax),%edx
  800bbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	0f b6 d8             	movzbl %al,%ebx
  800bc6:	83 fb 25             	cmp    $0x25,%ebx
  800bc9:	75 d6                	jne    800ba1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bcb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bcf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bd6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bdd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800be4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800beb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bee:	8d 50 01             	lea    0x1(%eax),%edx
  800bf1:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	0f b6 d8             	movzbl %al,%ebx
  800bf9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bfc:	83 f8 5b             	cmp    $0x5b,%eax
  800bff:	0f 87 3d 03 00 00    	ja     800f42 <vprintfmt+0x3ab>
  800c05:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
  800c0c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c0e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c12:	eb d7                	jmp    800beb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c14:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c18:	eb d1                	jmp    800beb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c24:	89 d0                	mov    %edx,%eax
  800c26:	c1 e0 02             	shl    $0x2,%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	01 c0                	add    %eax,%eax
  800c2d:	01 d8                	add    %ebx,%eax
  800c2f:	83 e8 30             	sub    $0x30,%eax
  800c32:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c3d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c40:	7e 3e                	jle    800c80 <vprintfmt+0xe9>
  800c42:	83 fb 39             	cmp    $0x39,%ebx
  800c45:	7f 39                	jg     800c80 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c47:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c4a:	eb d5                	jmp    800c21 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4f:	83 c0 04             	add    $0x4,%eax
  800c52:	89 45 14             	mov    %eax,0x14(%ebp)
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 e8 04             	sub    $0x4,%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c60:	eb 1f                	jmp    800c81 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c66:	79 83                	jns    800beb <vprintfmt+0x54>
				width = 0;
  800c68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c6f:	e9 77 ff ff ff       	jmp    800beb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c74:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c7b:	e9 6b ff ff ff       	jmp    800beb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c80:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c85:	0f 89 60 ff ff ff    	jns    800beb <vprintfmt+0x54>
				width = precision, precision = -1;
  800c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c91:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c98:	e9 4e ff ff ff       	jmp    800beb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c9d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ca0:	e9 46 ff ff ff       	jmp    800beb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 c0 04             	add    $0x4,%eax
  800cab:	89 45 14             	mov    %eax,0x14(%ebp)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 e8 04             	sub    $0x4,%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	83 ec 08             	sub    $0x8,%esp
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			break;
  800cc5:	e9 9b 02 00 00       	jmp    800f65 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccd:	83 c0 04             	add    $0x4,%eax
  800cd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd6:	83 e8 04             	sub    $0x4,%eax
  800cd9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cdb:	85 db                	test   %ebx,%ebx
  800cdd:	79 02                	jns    800ce1 <vprintfmt+0x14a>
				err = -err;
  800cdf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ce1:	83 fb 64             	cmp    $0x64,%ebx
  800ce4:	7f 0b                	jg     800cf1 <vprintfmt+0x15a>
  800ce6:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  800ced:	85 f6                	test   %esi,%esi
  800cef:	75 19                	jne    800d0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf1:	53                   	push   %ebx
  800cf2:	68 45 47 80 00       	push   $0x804745
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 70 02 00 00       	call   800f72 <printfmt>
  800d02:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d05:	e9 5b 02 00 00       	jmp    800f65 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d0a:	56                   	push   %esi
  800d0b:	68 4e 47 80 00       	push   $0x80474e
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	ff 75 08             	pushl  0x8(%ebp)
  800d16:	e8 57 02 00 00       	call   800f72 <printfmt>
  800d1b:	83 c4 10             	add    $0x10,%esp
			break;
  800d1e:	e9 42 02 00 00       	jmp    800f65 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 c0 04             	add    $0x4,%eax
  800d29:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 30                	mov    (%eax),%esi
  800d34:	85 f6                	test   %esi,%esi
  800d36:	75 05                	jne    800d3d <vprintfmt+0x1a6>
				p = "(null)";
  800d38:	be 51 47 80 00       	mov    $0x804751,%esi
			if (width > 0 && padc != '-')
  800d3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d41:	7e 6d                	jle    800db0 <vprintfmt+0x219>
  800d43:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d47:	74 67                	je     800db0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d4c:	83 ec 08             	sub    $0x8,%esp
  800d4f:	50                   	push   %eax
  800d50:	56                   	push   %esi
  800d51:	e8 1e 03 00 00       	call   801074 <strnlen>
  800d56:	83 c4 10             	add    $0x10,%esp
  800d59:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d5c:	eb 16                	jmp    800d74 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d5e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	50                   	push   %eax
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	ff d0                	call   *%eax
  800d6e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d71:	ff 4d e4             	decl   -0x1c(%ebp)
  800d74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d78:	7f e4                	jg     800d5e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d7a:	eb 34                	jmp    800db0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d80:	74 1c                	je     800d9e <vprintfmt+0x207>
  800d82:	83 fb 1f             	cmp    $0x1f,%ebx
  800d85:	7e 05                	jle    800d8c <vprintfmt+0x1f5>
  800d87:	83 fb 7e             	cmp    $0x7e,%ebx
  800d8a:	7e 12                	jle    800d9e <vprintfmt+0x207>
					putch('?', putdat);
  800d8c:	83 ec 08             	sub    $0x8,%esp
  800d8f:	ff 75 0c             	pushl  0xc(%ebp)
  800d92:	6a 3f                	push   $0x3f
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	ff d0                	call   *%eax
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	eb 0f                	jmp    800dad <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d9e:	83 ec 08             	sub    $0x8,%esp
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	53                   	push   %ebx
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dad:	ff 4d e4             	decl   -0x1c(%ebp)
  800db0:	89 f0                	mov    %esi,%eax
  800db2:	8d 70 01             	lea    0x1(%eax),%esi
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	0f be d8             	movsbl %al,%ebx
  800dba:	85 db                	test   %ebx,%ebx
  800dbc:	74 24                	je     800de2 <vprintfmt+0x24b>
  800dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc2:	78 b8                	js     800d7c <vprintfmt+0x1e5>
  800dc4:	ff 4d e0             	decl   -0x20(%ebp)
  800dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dcb:	79 af                	jns    800d7c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dcd:	eb 13                	jmp    800de2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	6a 20                	push   $0x20
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ddf:	ff 4d e4             	decl   -0x1c(%ebp)
  800de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de6:	7f e7                	jg     800dcf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800de8:	e9 78 01 00 00       	jmp    800f65 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	ff 75 e8             	pushl  -0x18(%ebp)
  800df3:	8d 45 14             	lea    0x14(%ebp),%eax
  800df6:	50                   	push   %eax
  800df7:	e8 3c fd ff ff       	call   800b38 <getint>
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0b:	85 d2                	test   %edx,%edx
  800e0d:	79 23                	jns    800e32 <vprintfmt+0x29b>
				putch('-', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 2d                	push   $0x2d
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e25:	f7 d8                	neg    %eax
  800e27:	83 d2 00             	adc    $0x0,%edx
  800e2a:	f7 da                	neg    %edx
  800e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e39:	e9 bc 00 00 00       	jmp    800efa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e3e:	83 ec 08             	sub    $0x8,%esp
  800e41:	ff 75 e8             	pushl  -0x18(%ebp)
  800e44:	8d 45 14             	lea    0x14(%ebp),%eax
  800e47:	50                   	push   %eax
  800e48:	e8 84 fc ff ff       	call   800ad1 <getuint>
  800e4d:	83 c4 10             	add    $0x10,%esp
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e5d:	e9 98 00 00 00       	jmp    800efa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e62:	83 ec 08             	sub    $0x8,%esp
  800e65:	ff 75 0c             	pushl  0xc(%ebp)
  800e68:	6a 58                	push   $0x58
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	ff d0                	call   *%eax
  800e6f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e72:	83 ec 08             	sub    $0x8,%esp
  800e75:	ff 75 0c             	pushl  0xc(%ebp)
  800e78:	6a 58                	push   $0x58
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	ff d0                	call   *%eax
  800e7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 58                	push   $0x58
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			break;
  800e92:	e9 ce 00 00 00       	jmp    800f65 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 30                	push   $0x30
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	6a 78                	push   $0x78
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	ff d0                	call   *%eax
  800eb4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ed2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ed9:	eb 1f                	jmp    800efa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee4:	50                   	push   %eax
  800ee5:	e8 e7 fb ff ff       	call   800ad1 <getuint>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ef3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800efa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f01:	83 ec 04             	sub    $0x4,%esp
  800f04:	52                   	push   %edx
  800f05:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f08:	50                   	push   %eax
  800f09:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f0f:	ff 75 0c             	pushl  0xc(%ebp)
  800f12:	ff 75 08             	pushl  0x8(%ebp)
  800f15:	e8 00 fb ff ff       	call   800a1a <printnum>
  800f1a:	83 c4 20             	add    $0x20,%esp
			break;
  800f1d:	eb 46                	jmp    800f65 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	53                   	push   %ebx
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			break;
  800f2e:	eb 35                	jmp    800f65 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f30:	c6 05 40 50 80 00 00 	movb   $0x0,0x805040
			break;
  800f37:	eb 2c                	jmp    800f65 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f39:	c6 05 40 50 80 00 01 	movb   $0x1,0x805040
			break;
  800f40:	eb 23                	jmp    800f65 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 0c             	pushl  0xc(%ebp)
  800f48:	6a 25                	push   $0x25
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f52:	ff 4d 10             	decl   0x10(%ebp)
  800f55:	eb 03                	jmp    800f5a <vprintfmt+0x3c3>
  800f57:	ff 4d 10             	decl   0x10(%ebp)
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	48                   	dec    %eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	3c 25                	cmp    $0x25,%al
  800f62:	75 f3                	jne    800f57 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f64:	90                   	nop
		}
	}
  800f65:	e9 35 fc ff ff       	jmp    800b9f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f78:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7b:	83 c0 04             	add    $0x4,%eax
  800f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	ff 75 f4             	pushl  -0xc(%ebp)
  800f87:	50                   	push   %eax
  800f88:	ff 75 0c             	pushl  0xc(%ebp)
  800f8b:	ff 75 08             	pushl  0x8(%ebp)
  800f8e:	e8 04 fc ff ff       	call   800b97 <vprintfmt>
  800f93:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f96:	90                   	nop
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	8b 40 08             	mov    0x8(%eax),%eax
  800fa2:	8d 50 01             	lea    0x1(%eax),%edx
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	8b 10                	mov    (%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	8b 40 04             	mov    0x4(%eax),%eax
  800fb6:	39 c2                	cmp    %eax,%edx
  800fb8:	73 12                	jae    800fcc <sprintputch+0x33>
		*b->buf++ = ch;
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	8b 00                	mov    (%eax),%eax
  800fbf:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc5:	89 0a                	mov    %ecx,(%edx)
  800fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fca:	88 10                	mov    %dl,(%eax)
}
  800fcc:	90                   	nop
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff4:	74 06                	je     800ffc <vsnprintf+0x2d>
  800ff6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffa:	7f 07                	jg     801003 <vsnprintf+0x34>
		return -E_INVAL;
  800ffc:	b8 03 00 00 00       	mov    $0x3,%eax
  801001:	eb 20                	jmp    801023 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801003:	ff 75 14             	pushl  0x14(%ebp)
  801006:	ff 75 10             	pushl  0x10(%ebp)
  801009:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100c:	50                   	push   %eax
  80100d:	68 99 0f 80 00       	push   $0x800f99
  801012:	e8 80 fb ff ff       	call   800b97 <vprintfmt>
  801017:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801020:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102b:	8d 45 10             	lea    0x10(%ebp),%eax
  80102e:	83 c0 04             	add    $0x4,%eax
  801031:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	ff 75 f4             	pushl  -0xc(%ebp)
  80103a:	50                   	push   %eax
  80103b:	ff 75 0c             	pushl  0xc(%ebp)
  80103e:	ff 75 08             	pushl  0x8(%ebp)
  801041:	e8 89 ff ff ff       	call   800fcf <vsnprintf>
  801046:	83 c4 10             	add    $0x10,%esp
  801049:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801057:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80105e:	eb 06                	jmp    801066 <strlen+0x15>
		n++;
  801060:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801063:	ff 45 08             	incl   0x8(%ebp)
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	84 c0                	test   %al,%al
  80106d:	75 f1                	jne    801060 <strlen+0xf>
		n++;
	return n;
  80106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801081:	eb 09                	jmp    80108c <strnlen+0x18>
		n++;
  801083:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801086:	ff 45 08             	incl   0x8(%ebp)
  801089:	ff 4d 0c             	decl   0xc(%ebp)
  80108c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801090:	74 09                	je     80109b <strnlen+0x27>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	84 c0                	test   %al,%al
  801099:	75 e8                	jne    801083 <strnlen+0xf>
		n++;
	return n;
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80109e:	c9                   	leave  
  80109f:	c3                   	ret    

008010a0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ac:	90                   	nop
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010bf:	8a 12                	mov    (%edx),%dl
  8010c1:	88 10                	mov    %dl,(%eax)
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 e4                	jne    8010ad <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e1:	eb 1f                	jmp    801102 <strncpy+0x34>
		*dst++ = *src;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8d 50 01             	lea    0x1(%eax),%edx
  8010e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ef:	8a 12                	mov    (%edx),%dl
  8010f1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	84 c0                	test   %al,%al
  8010fa:	74 03                	je     8010ff <strncpy+0x31>
			src++;
  8010fc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	3b 45 10             	cmp    0x10(%ebp),%eax
  801108:	72 d9                	jb     8010e3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	74 30                	je     801151 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801121:	eb 16                	jmp    801139 <strlcpy+0x2a>
			*dst++ = *src++;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8d 50 01             	lea    0x1(%eax),%edx
  801129:	89 55 08             	mov    %edx,0x8(%ebp)
  80112c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801132:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801135:	8a 12                	mov    (%edx),%dl
  801137:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801139:	ff 4d 10             	decl   0x10(%ebp)
  80113c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801140:	74 09                	je     80114b <strlcpy+0x3c>
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	84 c0                	test   %al,%al
  801149:	75 d8                	jne    801123 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801157:	29 c2                	sub    %eax,%edx
  801159:	89 d0                	mov    %edx,%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801160:	eb 06                	jmp    801168 <strcmp+0xb>
		p++, q++;
  801162:	ff 45 08             	incl   0x8(%ebp)
  801165:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	84 c0                	test   %al,%al
  80116f:	74 0e                	je     80117f <strcmp+0x22>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 10                	mov    (%eax),%dl
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	38 c2                	cmp    %al,%dl
  80117d:	74 e3                	je     801162 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f b6 d0             	movzbl %al,%edx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f b6 c0             	movzbl %al,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
}
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801198:	eb 09                	jmp    8011a3 <strncmp+0xe>
		n--, p++, q++;
  80119a:	ff 4d 10             	decl   0x10(%ebp)
  80119d:	ff 45 08             	incl   0x8(%ebp)
  8011a0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a7:	74 17                	je     8011c0 <strncmp+0x2b>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	84 c0                	test   %al,%al
  8011b0:	74 0e                	je     8011c0 <strncmp+0x2b>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 10                	mov    (%eax),%dl
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	38 c2                	cmp    %al,%dl
  8011be:	74 da                	je     80119a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c4:	75 07                	jne    8011cd <strncmp+0x38>
		return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	eb 14                	jmp    8011e1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	0f b6 d0             	movzbl %al,%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	29 c2                	sub    %eax,%edx
  8011df:	89 d0                	mov    %edx,%eax
}
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    

008011e3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ef:	eb 12                	jmp    801203 <strchr+0x20>
		if (*s == c)
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f9:	75 05                	jne    801200 <strchr+0x1d>
			return (char *) s;
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	eb 11                	jmp    801211 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801200:	ff 45 08             	incl   0x8(%ebp)
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	84 c0                	test   %al,%al
  80120a:	75 e5                	jne    8011f1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 04             	sub    $0x4,%esp
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80121f:	eb 0d                	jmp    80122e <strfind+0x1b>
		if (*s == c)
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801229:	74 0e                	je     801239 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	84 c0                	test   %al,%al
  801235:	75 ea                	jne    801221 <strfind+0xe>
  801237:	eb 01                	jmp    80123a <strfind+0x27>
		if (*s == c)
			break;
  801239:	90                   	nop
	return (char *) s;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801251:	eb 0e                	jmp    801261 <memset+0x22>
		*p++ = c;
  801253:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801256:	8d 50 01             	lea    0x1(%eax),%edx
  801259:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801261:	ff 4d f8             	decl   -0x8(%ebp)
  801264:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801268:	79 e9                	jns    801253 <memset+0x14>
		*p++ = c;

	return v;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801281:	eb 16                	jmp    801299 <memcpy+0x2a>
		*d++ = *s++;
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	8d 50 01             	lea    0x1(%eax),%edx
  801289:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801292:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801295:	8a 12                	mov    (%edx),%dl
  801297:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80129f:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	75 dd                	jne    801283 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c3:	73 50                	jae    801315 <memmove+0x6a>
  8012c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cb:	01 d0                	add    %edx,%eax
  8012cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d0:	76 43                	jbe    801315 <memmove+0x6a>
		s += n;
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012de:	eb 10                	jmp    8012f0 <memmove+0x45>
			*--d = *--s;
  8012e0:	ff 4d f8             	decl   -0x8(%ebp)
  8012e3:	ff 4d fc             	decl   -0x4(%ebp)
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e9:	8a 10                	mov    (%eax),%dl
  8012eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ee:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	75 e3                	jne    8012e0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012fd:	eb 23                	jmp    801322 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	8d 50 01             	lea    0x1(%eax),%edx
  801305:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801311:	8a 12                	mov    (%edx),%dl
  801313:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131b:	89 55 10             	mov    %edx,0x10(%ebp)
  80131e:	85 c0                	test   %eax,%eax
  801320:	75 dd                	jne    8012ff <memmove+0x54>
			*d++ = *s++;

	return dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801339:	eb 2a                	jmp    801365 <memcmp+0x3e>
		if (*s1 != *s2)
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133e:	8a 10                	mov    (%eax),%dl
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	38 c2                	cmp    %al,%dl
  801347:	74 16                	je     80135f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f b6 d0             	movzbl %al,%edx
  801351:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	0f b6 c0             	movzbl %al,%eax
  801359:	29 c2                	sub    %eax,%edx
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	eb 18                	jmp    801377 <memcmp+0x50>
		s1++, s2++;
  80135f:	ff 45 fc             	incl   -0x4(%ebp)
  801362:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801365:	8b 45 10             	mov    0x10(%ebp),%eax
  801368:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136b:	89 55 10             	mov    %edx,0x10(%ebp)
  80136e:	85 c0                	test   %eax,%eax
  801370:	75 c9                	jne    80133b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80137f:	8b 55 08             	mov    0x8(%ebp),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138a:	eb 15                	jmp    8013a1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	0f b6 d0             	movzbl %al,%edx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	0f b6 c0             	movzbl %al,%eax
  80139a:	39 c2                	cmp    %eax,%edx
  80139c:	74 0d                	je     8013ab <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80139e:	ff 45 08             	incl   0x8(%ebp)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013a7:	72 e3                	jb     80138c <memfind+0x13>
  8013a9:	eb 01                	jmp    8013ac <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ab:	90                   	nop
	return (void *) s;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c5:	eb 03                	jmp    8013ca <strtol+0x19>
		s++;
  8013c7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	3c 20                	cmp    $0x20,%al
  8013d1:	74 f4                	je     8013c7 <strtol+0x16>
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	3c 09                	cmp    $0x9,%al
  8013da:	74 eb                	je     8013c7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 2b                	cmp    $0x2b,%al
  8013e3:	75 05                	jne    8013ea <strtol+0x39>
		s++;
  8013e5:	ff 45 08             	incl   0x8(%ebp)
  8013e8:	eb 13                	jmp    8013fd <strtol+0x4c>
	else if (*s == '-')
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	3c 2d                	cmp    $0x2d,%al
  8013f1:	75 0a                	jne    8013fd <strtol+0x4c>
		s++, neg = 1;
  8013f3:	ff 45 08             	incl   0x8(%ebp)
  8013f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	74 06                	je     801409 <strtol+0x58>
  801403:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801407:	75 20                	jne    801429 <strtol+0x78>
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	3c 30                	cmp    $0x30,%al
  801410:	75 17                	jne    801429 <strtol+0x78>
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	40                   	inc    %eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 78                	cmp    $0x78,%al
  80141a:	75 0d                	jne    801429 <strtol+0x78>
		s += 2, base = 16;
  80141c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801420:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801427:	eb 28                	jmp    801451 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801429:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142d:	75 15                	jne    801444 <strtol+0x93>
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 30                	cmp    $0x30,%al
  801436:	75 0c                	jne    801444 <strtol+0x93>
		s++, base = 8;
  801438:	ff 45 08             	incl   0x8(%ebp)
  80143b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801442:	eb 0d                	jmp    801451 <strtol+0xa0>
	else if (base == 0)
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	75 07                	jne    801451 <strtol+0xa0>
		base = 10;
  80144a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 2f                	cmp    $0x2f,%al
  801458:	7e 19                	jle    801473 <strtol+0xc2>
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	3c 39                	cmp    $0x39,%al
  801461:	7f 10                	jg     801473 <strtol+0xc2>
			dig = *s - '0';
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	0f be c0             	movsbl %al,%eax
  80146b:	83 e8 30             	sub    $0x30,%eax
  80146e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801471:	eb 42                	jmp    8014b5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 60                	cmp    $0x60,%al
  80147a:	7e 19                	jle    801495 <strtol+0xe4>
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	3c 7a                	cmp    $0x7a,%al
  801483:	7f 10                	jg     801495 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	0f be c0             	movsbl %al,%eax
  80148d:	83 e8 57             	sub    $0x57,%eax
  801490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801493:	eb 20                	jmp    8014b5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	3c 40                	cmp    $0x40,%al
  80149c:	7e 39                	jle    8014d7 <strtol+0x126>
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	3c 5a                	cmp    $0x5a,%al
  8014a5:	7f 30                	jg     8014d7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	0f be c0             	movsbl %al,%eax
  8014af:	83 e8 37             	sub    $0x37,%eax
  8014b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014bb:	7d 19                	jge    8014d6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014bd:	ff 45 08             	incl   0x8(%ebp)
  8014c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	01 d0                	add    %edx,%eax
  8014ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d1:	e9 7b ff ff ff       	jmp    801451 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014db:	74 08                	je     8014e5 <strtol+0x134>
		*endptr = (char *) s;
  8014dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014e9:	74 07                	je     8014f2 <strtol+0x141>
  8014eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ee:	f7 d8                	neg    %eax
  8014f0:	eb 03                	jmp    8014f5 <strtol+0x144>
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <ltostr>:

void
ltostr(long value, char *str)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801504:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150f:	79 13                	jns    801524 <ltostr+0x2d>
	{
		neg = 1;
  801511:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80151e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801521:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152c:	99                   	cltd   
  80152d:	f7 f9                	idiv   %ecx
  80152f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801535:	8d 50 01             	lea    0x1(%eax),%edx
  801538:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153b:	89 c2                	mov    %eax,%edx
  80153d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801540:	01 d0                	add    %edx,%eax
  801542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801545:	83 c2 30             	add    $0x30,%edx
  801548:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801552:	f7 e9                	imul   %ecx
  801554:	c1 fa 02             	sar    $0x2,%edx
  801557:	89 c8                	mov    %ecx,%eax
  801559:	c1 f8 1f             	sar    $0x1f,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
  801560:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801563:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801567:	75 bb                	jne    801524 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	48                   	dec    %eax
  801574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801577:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80157b:	74 3d                	je     8015ba <ltostr+0xc3>
		start = 1 ;
  80157d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801584:	eb 34                	jmp    8015ba <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 c2                	add    %eax,%edx
  80159b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	01 c8                	add    %ecx,%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 c2                	add    %eax,%edx
  8015af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8015b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c0:	7c c4                	jl     801586 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	01 d0                	add    %edx,%eax
  8015ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015cd:	90                   	nop
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	e8 73 fa ff ff       	call   801051 <strlen>
  8015de:	83 c4 04             	add    $0x4,%esp
  8015e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	e8 65 fa ff ff       	call   801051 <strlen>
  8015ec:	83 c4 04             	add    $0x4,%esp
  8015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801600:	eb 17                	jmp    801619 <strcconcat+0x49>
		final[s] = str1[s] ;
  801602:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	01 c2                	add    %eax,%edx
  80160a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	01 c8                	add    %ecx,%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801616:	ff 45 fc             	incl   -0x4(%ebp)
  801619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80161f:	7c e1                	jl     801602 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801621:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801628:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80162f:	eb 1f                	jmp    801650 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801631:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801634:	8d 50 01             	lea    0x1(%eax),%edx
  801637:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	01 c2                	add    %eax,%edx
  801641:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	01 c8                	add    %ecx,%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80164d:	ff 45 f8             	incl   -0x8(%ebp)
  801650:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801653:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801656:	7c d9                	jl     801631 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	01 d0                	add    %edx,%eax
  801660:	c6 00 00             	movb   $0x0,(%eax)
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801669:	8b 45 14             	mov    0x14(%ebp),%eax
  80166c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801672:	8b 45 14             	mov    0x14(%ebp),%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	01 d0                	add    %edx,%eax
  801683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801689:	eb 0c                	jmp    801697 <strsplit+0x31>
			*string++ = 0;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8d 50 01             	lea    0x1(%eax),%edx
  801691:	89 55 08             	mov    %edx,0x8(%ebp)
  801694:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	84 c0                	test   %al,%al
  80169e:	74 18                	je     8016b8 <strsplit+0x52>
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	0f be c0             	movsbl %al,%eax
  8016a8:	50                   	push   %eax
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	e8 32 fb ff ff       	call   8011e3 <strchr>
  8016b1:	83 c4 08             	add    $0x8,%esp
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 d3                	jne    80168b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	84 c0                	test   %al,%al
  8016bf:	74 5a                	je     80171b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c4:	8b 00                	mov    (%eax),%eax
  8016c6:	83 f8 0f             	cmp    $0xf,%eax
  8016c9:	75 07                	jne    8016d2 <strsplit+0x6c>
		{
			return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	eb 66                	jmp    801738 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d5:	8b 00                	mov    (%eax),%eax
  8016d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8016da:	8b 55 14             	mov    0x14(%ebp),%edx
  8016dd:	89 0a                	mov    %ecx,(%edx)
  8016df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	01 c2                	add    %eax,%edx
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f0:	eb 03                	jmp    8016f5 <strsplit+0x8f>
			string++;
  8016f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	84 c0                	test   %al,%al
  8016fc:	74 8b                	je     801689 <strsplit+0x23>
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f be c0             	movsbl %al,%eax
  801706:	50                   	push   %eax
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	e8 d4 fa ff ff       	call   8011e3 <strchr>
  80170f:	83 c4 08             	add    $0x8,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	74 dc                	je     8016f2 <strsplit+0x8c>
			string++;
	}
  801716:	e9 6e ff ff ff       	jmp    801689 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80171b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80171c:	8b 45 14             	mov    0x14(%ebp),%eax
  80171f:	8b 00                	mov    (%eax),%eax
  801721:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801733:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 c8 48 80 00       	push   $0x8048c8
  801748:	68 3f 01 00 00       	push   $0x13f
  80174d:	68 ea 48 80 00       	push   $0x8048ea
  801752:	e8 a9 ef ff ff       	call   800700 <_panic>

00801757 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80175d:	83 ec 0c             	sub    $0xc,%esp
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	e8 0a 0b 00 00       	call   802272 <sys_sbrk>
  801768:	83 c4 10             	add    $0x10,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801773:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801777:	75 0a                	jne    801783 <malloc+0x16>
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
  80177e:	e9 07 02 00 00       	jmp    80198a <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801783:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80178a:	8b 55 08             	mov    0x8(%ebp),%edx
  80178d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801790:	01 d0                	add    %edx,%eax
  801792:	48                   	dec    %eax
  801793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801796:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801799:	ba 00 00 00 00       	mov    $0x0,%edx
  80179e:	f7 75 dc             	divl   -0x24(%ebp)
  8017a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a4:	29 d0                	sub    %edx,%eax
  8017a6:	c1 e8 0c             	shr    $0xc,%eax
  8017a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8017ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b1:	8b 40 78             	mov    0x78(%eax),%eax
  8017b4:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8017b9:	29 c2                	sub    %eax,%edx
  8017bb:	89 d0                	mov    %edx,%eax
  8017bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8017c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c8:	c1 e8 0c             	shr    $0xc,%eax
  8017cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8017ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8017d5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8017dc:	77 42                	ja     801820 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017de:	e8 13 09 00 00       	call   8020f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 16                	je     8017fd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 53 0e 00 00       	call   802645 <alloc_block_FF>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	e9 8a 01 00 00       	jmp    801987 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8017fd:	e8 25 09 00 00       	call   802127 <sys_isUHeapPlacementStrategyBESTFIT>
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 84 7d 01 00 00    	je     801987 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 ec 12 00 00       	call   802b01 <alloc_block_BF>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	e9 67 01 00 00       	jmp    801987 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801820:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801823:	48                   	dec    %eax
  801824:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801827:	0f 86 53 01 00 00    	jbe    801980 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80182d:	a1 20 50 80 00       	mov    0x805020,%eax
  801832:	8b 40 78             	mov    0x78(%eax),%eax
  801835:	05 00 10 00 00       	add    $0x1000,%eax
  80183a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80183d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801844:	e9 de 00 00 00       	jmp    801927 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801849:	a1 20 50 80 00       	mov    0x805020,%eax
  80184e:	8b 40 78             	mov    0x78(%eax),%eax
  801851:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801854:	29 c2                	sub    %eax,%edx
  801856:	89 d0                	mov    %edx,%eax
  801858:	2d 00 10 00 00       	sub    $0x1000,%eax
  80185d:	c1 e8 0c             	shr    $0xc,%eax
  801860:	8b 04 85 60 92 88 00 	mov    0x889260(,%eax,4),%eax
  801867:	85 c0                	test   %eax,%eax
  801869:	0f 85 ab 00 00 00    	jne    80191a <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801872:	05 00 10 00 00       	add    $0x1000,%eax
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80187a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801881:	eb 47                	jmp    8018ca <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801883:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80188a:	76 0a                	jbe    801896 <malloc+0x129>
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	e9 f4 00 00 00       	jmp    80198a <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801896:	a1 20 50 80 00       	mov    0x805020,%eax
  80189b:	8b 40 78             	mov    0x78(%eax),%eax
  80189e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018a1:	29 c2                	sub    %eax,%edx
  8018a3:	89 d0                	mov    %edx,%eax
  8018a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018aa:	c1 e8 0c             	shr    $0xc,%eax
  8018ad:	8b 04 85 60 92 88 00 	mov    0x889260(,%eax,4),%eax
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	74 08                	je     8018c0 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8018b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8018be:	eb 5a                	jmp    80191a <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8018c0:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8018c7:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8018ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018cd:	48                   	dec    %eax
  8018ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018d1:	77 b0                	ja     801883 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8018d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8018da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018e1:	eb 2f                	jmp    801912 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8018e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e6:	c1 e0 0c             	shl    $0xc,%eax
  8018e9:	89 c2                	mov    %eax,%edx
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	01 c2                	add    %eax,%edx
  8018f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8018f5:	8b 40 78             	mov    0x78(%eax),%eax
  8018f8:	29 c2                	sub    %eax,%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801901:	c1 e8 0c             	shr    $0xc,%eax
  801904:	c7 04 85 60 92 88 00 	movl   $0x1,0x889260(,%eax,4)
  80190b:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80190f:	ff 45 e0             	incl   -0x20(%ebp)
  801912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801915:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801918:	72 c9                	jb     8018e3 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80191a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191e:	75 16                	jne    801936 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801920:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801927:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80192e:	0f 86 15 ff ff ff    	jbe    801849 <malloc+0xdc>
  801934:	eb 01                	jmp    801937 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801936:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801937:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80193b:	75 07                	jne    801944 <malloc+0x1d7>
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
  801942:	eb 46                	jmp    80198a <malloc+0x21d>
		ptr = (void*)i;
  801944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801947:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80194a:	a1 20 50 80 00       	mov    0x805020,%eax
  80194f:	8b 40 78             	mov    0x78(%eax),%eax
  801952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801955:	29 c2                	sub    %eax,%edx
  801957:	89 d0                	mov    %edx,%eax
  801959:	2d 00 10 00 00       	sub    $0x1000,%eax
  80195e:	c1 e8 0c             	shr    $0xc,%eax
  801961:	89 c2                	mov    %eax,%edx
  801963:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801966:	89 04 95 60 92 90 00 	mov    %eax,0x909260(,%edx,4)
		sys_allocate_user_mem(i, size);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	ff 75 f0             	pushl  -0x10(%ebp)
  801976:	e8 2e 09 00 00       	call   8022a9 <sys_allocate_user_mem>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	eb 07                	jmp    801987 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
  801985:	eb 03                	jmp    80198a <malloc+0x21d>
	}
	return ptr;
  801987:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801992:	a1 20 50 80 00       	mov    0x805020,%eax
  801997:	8b 40 78             	mov    0x78(%eax),%eax
  80199a:	05 00 10 00 00       	add    $0x1000,%eax
  80199f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8019a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8019a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8019ae:	8b 50 78             	mov    0x78(%eax),%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	39 c2                	cmp    %eax,%edx
  8019b6:	76 24                	jbe    8019dc <free+0x50>
		size = get_block_size(va);
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	e8 02 09 00 00       	call   8022c5 <get_block_size>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 35 1b 00 00       	call   803509 <free_block>
  8019d4:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8019d7:	e9 ac 00 00 00       	jmp    801a88 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019e2:	0f 82 89 00 00 00    	jb     801a71 <free+0xe5>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8019f0:	77 7f                	ja     801a71 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8019f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8019fa:	8b 40 78             	mov    0x78(%eax),%eax
  8019fd:	29 c2                	sub    %eax,%edx
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a06:	c1 e8 0c             	shr    $0xc,%eax
  801a09:	8b 04 85 60 92 90 00 	mov    0x909260(,%eax,4),%eax
  801a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a16:	c1 e0 0c             	shl    $0xc,%eax
  801a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a23:	eb 2f                	jmp    801a54 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a28:	c1 e0 0c             	shl    $0xc,%eax
  801a2b:	89 c2                	mov    %eax,%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	01 c2                	add    %eax,%edx
  801a32:	a1 20 50 80 00       	mov    0x805020,%eax
  801a37:	8b 40 78             	mov    0x78(%eax),%eax
  801a3a:	29 c2                	sub    %eax,%edx
  801a3c:	89 d0                	mov    %edx,%eax
  801a3e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a43:	c1 e8 0c             	shr    $0xc,%eax
  801a46:	c7 04 85 60 92 88 00 	movl   $0x0,0x889260(,%eax,4)
  801a4d:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801a51:	ff 45 f4             	incl   -0xc(%ebp)
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a5a:	72 c9                	jb     801a25 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	ff 75 ec             	pushl  -0x14(%ebp)
  801a65:	50                   	push   %eax
  801a66:	e8 22 08 00 00       	call   80228d <sys_free_user_mem>
  801a6b:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801a6e:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801a6f:	eb 17                	jmp    801a88 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	68 f8 48 80 00       	push   $0x8048f8
  801a79:	68 85 00 00 00       	push   $0x85
  801a7e:	68 22 49 80 00       	push   $0x804922
  801a83:	e8 78 ec ff ff       	call   800700 <_panic>
	}
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 28             	sub    $0x28,%esp
  801a90:	8b 45 10             	mov    0x10(%ebp),%eax
  801a93:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9a:	75 0a                	jne    801aa6 <smalloc+0x1c>
  801a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa1:	e9 9a 00 00 00       	jmp    801b40 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aac:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab9:	39 d0                	cmp    %edx,%eax
  801abb:	73 02                	jae    801abf <smalloc+0x35>
  801abd:	89 d0                	mov    %edx,%eax
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	50                   	push   %eax
  801ac3:	e8 a5 fc ff ff       	call   80176d <malloc>
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ad2:	75 07                	jne    801adb <smalloc+0x51>
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	eb 65                	jmp    801b40 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801adb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801adf:	ff 75 ec             	pushl  -0x14(%ebp)
  801ae2:	50                   	push   %eax
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	e8 a6 03 00 00       	call   801e94 <sys_createSharedObject>
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801af4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801af8:	74 06                	je     801b00 <smalloc+0x76>
  801afa:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801afe:	75 07                	jne    801b07 <smalloc+0x7d>
  801b00:	b8 00 00 00 00       	mov    $0x0,%eax
  801b05:	eb 39                	jmp    801b40 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	ff 75 ec             	pushl  -0x14(%ebp)
  801b0d:	68 2e 49 80 00       	push   $0x80492e
  801b12:	e8 a6 ee ff ff       	call   8009bd <cprintf>
  801b17:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801b1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b1d:	a1 20 50 80 00       	mov    0x805020,%eax
  801b22:	8b 40 78             	mov    0x78(%eax),%eax
  801b25:	29 c2                	sub    %eax,%edx
  801b27:	89 d0                	mov    %edx,%eax
  801b29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b2e:	c1 e8 0c             	shr    $0xc,%eax
  801b31:	89 c2                	mov    %eax,%edx
  801b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b36:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	 return ptr;
  801b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	e8 68 03 00 00       	call   801ebe <sys_getSizeOfSharedObject>
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801b5c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b60:	75 07                	jne    801b69 <sget+0x27>
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
  801b67:	eb 7f                	jmp    801be8 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b6f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7c:	39 d0                	cmp    %edx,%eax
  801b7e:	7d 02                	jge    801b82 <sget+0x40>
  801b80:	89 d0                	mov    %edx,%eax
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	50                   	push   %eax
  801b86:	e8 e2 fb ff ff       	call   80176d <malloc>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801b91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b95:	75 07                	jne    801b9e <sget+0x5c>
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9c:	eb 4a                	jmp    801be8 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	ff 75 e8             	pushl  -0x18(%ebp)
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	e8 2c 03 00 00       	call   801edb <sys_getSharedObject>
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801bb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb8:	a1 20 50 80 00       	mov    0x805020,%eax
  801bbd:	8b 40 78             	mov    0x78(%eax),%eax
  801bc0:	29 c2                	sub    %eax,%edx
  801bc2:	89 d0                	mov    %edx,%eax
  801bc4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bc9:	c1 e8 0c             	shr    $0xc,%eax
  801bcc:	89 c2                	mov    %eax,%edx
  801bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd1:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801bd8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801bdc:	75 07                	jne    801be5 <sget+0xa3>
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
  801be3:	eb 03                	jmp    801be8 <sget+0xa6>
	return ptr;
  801be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf3:	a1 20 50 80 00       	mov    0x805020,%eax
  801bf8:	8b 40 78             	mov    0x78(%eax),%eax
  801bfb:	29 c2                	sub    %eax,%edx
  801bfd:	89 d0                	mov    %edx,%eax
  801bff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c04:	c1 e8 0c             	shr    $0xc,%eax
  801c07:	8b 04 85 60 92 80 00 	mov    0x809260(,%eax,4),%eax
  801c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1a:	e8 db 02 00 00       	call   801efa <sys_freeSharedObject>
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 40 49 80 00       	push   $0x804940
  801c36:	68 de 00 00 00       	push   $0xde
  801c3b:	68 22 49 80 00       	push   $0x804922
  801c40:	e8 bb ea ff ff       	call   800700 <_panic>

00801c45 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	68 66 49 80 00       	push   $0x804966
  801c53:	68 ea 00 00 00       	push   $0xea
  801c58:	68 22 49 80 00       	push   $0x804922
  801c5d:	e8 9e ea ff ff       	call   800700 <_panic>

00801c62 <shrink>:

}
void shrink(uint32 newSize)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 66 49 80 00       	push   $0x804966
  801c70:	68 ef 00 00 00       	push   $0xef
  801c75:	68 22 49 80 00       	push   $0x804922
  801c7a:	e8 81 ea ff ff       	call   800700 <_panic>

00801c7f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	68 66 49 80 00       	push   $0x804966
  801c8d:	68 f4 00 00 00       	push   $0xf4
  801c92:	68 22 49 80 00       	push   $0x804922
  801c97:	e8 64 ea ff ff       	call   800700 <_panic>

00801c9c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	57                   	push   %edi
  801ca0:	56                   	push   %esi
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb7:	cd 30                	int    $0x30
  801cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    

00801cc7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cd3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	52                   	push   %edx
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	50                   	push   %eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	e8 b2 ff ff ff       	call   801c9c <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	90                   	nop
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 02                	push   $0x2
  801cff:	e8 98 ff ff ff       	call   801c9c <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 03                	push   $0x3
  801d18:	e8 7f ff ff ff       	call   801c9c <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	90                   	nop
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 04                	push   $0x4
  801d32:	e8 65 ff ff ff       	call   801c9c <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	90                   	nop
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	52                   	push   %edx
  801d4d:	50                   	push   %eax
  801d4e:	6a 08                	push   $0x8
  801d50:	e8 47 ff ff ff       	call   801c9c <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	56                   	push   %esi
  801d5e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d5f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	51                   	push   %ecx
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 09                	push   $0x9
  801d75:	e8 22 ff ff ff       	call   801c9c <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	6a 0a                	push   $0xa
  801d97:	e8 00 ff ff ff       	call   801c9c <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	ff 75 08             	pushl  0x8(%ebp)
  801db0:	6a 0b                	push   $0xb
  801db2:	e8 e5 fe ff ff       	call   801c9c <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 0c                	push   $0xc
  801dcb:	e8 cc fe ff ff       	call   801c9c <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 0d                	push   $0xd
  801de4:	e8 b3 fe ff ff       	call   801c9c <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 0e                	push   $0xe
  801dfd:	e8 9a fe ff ff       	call   801c9c <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 0f                	push   $0xf
  801e16:	e8 81 fe ff ff       	call   801c9c <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	6a 10                	push   $0x10
  801e30:	e8 67 fe ff ff       	call   801c9c <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 11                	push   $0x11
  801e49:	e8 4e fe ff ff       	call   801c9c <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 01                	push   $0x1
  801e6f:	e8 28 fe ff ff       	call   801c9c <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	90                   	nop
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 14                	push   $0x14
  801e89:	e8 0e fe ff ff       	call   801c9c <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 04             	sub    $0x4,%esp
  801e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ea0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	51                   	push   %ecx
  801ead:	52                   	push   %edx
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	50                   	push   %eax
  801eb2:	6a 15                	push   $0x15
  801eb4:	e8 e3 fd ff ff       	call   801c9c <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	52                   	push   %edx
  801ece:	50                   	push   %eax
  801ecf:	6a 16                	push   $0x16
  801ed1:	e8 c6 fd ff ff       	call   801c9c <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ede:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	51                   	push   %ecx
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 17                	push   $0x17
  801ef0:	e8 a7 fd ff ff       	call   801c9c <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	6a 18                	push   $0x18
  801f0d:	e8 8a fd ff ff       	call   801c9c <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 14             	pushl  0x14(%ebp)
  801f22:	ff 75 10             	pushl  0x10(%ebp)
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	50                   	push   %eax
  801f29:	6a 19                	push   $0x19
  801f2b:	e8 6c fd ff ff       	call   801c9c <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	50                   	push   %eax
  801f44:	6a 1a                	push   $0x1a
  801f46:	e8 51 fd ff ff       	call   801c9c <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	50                   	push   %eax
  801f60:	6a 1b                	push   $0x1b
  801f62:	e8 35 fd ff ff       	call   801c9c <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 05                	push   $0x5
  801f7b:	e8 1c fd ff ff       	call   801c9c <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 06                	push   $0x6
  801f94:	e8 03 fd ff ff       	call   801c9c <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 07                	push   $0x7
  801fad:	e8 ea fc ff ff       	call   801c9c <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 1c                	push   $0x1c
  801fc6:	e8 d1 fc ff ff       	call   801c9c <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	90                   	nop
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fda:	8d 50 04             	lea    0x4(%eax),%edx
  801fdd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 1d                	push   $0x1d
  801fea:	e8 ad fc ff ff       	call   801c9c <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return result;
  801ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ffb:	89 01                	mov    %eax,(%ecx)
  801ffd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	c9                   	leave  
  802004:	c2 04 00             	ret    $0x4

00802007 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 10             	pushl  0x10(%ebp)
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	6a 13                	push   $0x13
  802019:	e8 7e fc ff ff       	call   801c9c <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
	return ;
  802021:	90                   	nop
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_rcr2>:
uint32 sys_rcr2()
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 1e                	push   $0x1e
  802033:	e8 64 fc ff ff       	call   801c9c <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802049:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	50                   	push   %eax
  802056:	6a 1f                	push   $0x1f
  802058:	e8 3f fc ff ff       	call   801c9c <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
	return ;
  802060:	90                   	nop
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <rsttst>:
void rsttst()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 21                	push   $0x21
  802072:	e8 25 fc ff ff       	call   801c9c <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	8b 45 14             	mov    0x14(%ebp),%eax
  802086:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802089:	8b 55 18             	mov    0x18(%ebp),%edx
  80208c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802090:	52                   	push   %edx
  802091:	50                   	push   %eax
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	6a 20                	push   $0x20
  80209d:	e8 fa fb ff ff       	call   801c9c <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a5:	90                   	nop
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <chktst>:
void chktst(uint32 n)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	6a 22                	push   $0x22
  8020b8:	e8 df fb ff ff       	call   801c9c <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <inctst>:

void inctst()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 23                	push   $0x23
  8020d2:	e8 c5 fb ff ff       	call   801c9c <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <gettst>:
uint32 gettst()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 24                	push   $0x24
  8020ec:	e8 ab fb ff ff       	call   801c9c <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 25                	push   $0x25
  802108:	e8 8f fb ff ff       	call   801c9c <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
  802110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802113:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802117:	75 07                	jne    802120 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	eb 05                	jmp    802125 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 25                	push   $0x25
  802139:	e8 5e fb ff ff       	call   801c9c <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
  802141:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802144:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802148:	75 07                	jne    802151 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80214a:	b8 01 00 00 00       	mov    $0x1,%eax
  80214f:	eb 05                	jmp    802156 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 25                	push   $0x25
  80216a:	e8 2d fb ff ff       	call   801c9c <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
  802172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802175:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802179:	75 07                	jne    802182 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80217b:	b8 01 00 00 00       	mov    $0x1,%eax
  802180:	eb 05                	jmp    802187 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 25                	push   $0x25
  80219b:	e8 fc fa ff ff       	call   801c9c <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
  8021a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021aa:	75 07                	jne    8021b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b1:	eb 05                	jmp    8021b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	6a 26                	push   $0x26
  8021ca:	e8 cd fa ff ff       	call   801c9c <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d2:	90                   	nop
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	6a 00                	push   $0x0
  8021e7:	53                   	push   %ebx
  8021e8:	51                   	push   %ecx
  8021e9:	52                   	push   %edx
  8021ea:	50                   	push   %eax
  8021eb:	6a 27                	push   $0x27
  8021ed:	e8 aa fa ff ff       	call   801c9c <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	52                   	push   %edx
  80220a:	50                   	push   %eax
  80220b:	6a 28                	push   $0x28
  80220d:	e8 8a fa ff ff       	call   801c9c <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80221a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	51                   	push   %ecx
  802226:	ff 75 10             	pushl  0x10(%ebp)
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 29                	push   $0x29
  80222d:	e8 6a fa ff ff       	call   801c9c <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	ff 75 10             	pushl  0x10(%ebp)
  802241:	ff 75 0c             	pushl  0xc(%ebp)
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	6a 12                	push   $0x12
  802249:	e8 4e fa ff ff       	call   801c9c <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
	return ;
  802251:	90                   	nop
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	6a 2a                	push   $0x2a
  802267:	e8 30 fa ff ff       	call   801c9c <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
	return;
  80226f:	90                   	nop
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	50                   	push   %eax
  802281:	6a 2b                	push   $0x2b
  802283:	e8 14 fa ff ff       	call   801c9c <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	ff 75 0c             	pushl  0xc(%ebp)
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	6a 2c                	push   $0x2c
  80229e:	e8 f9 f9 ff ff       	call   801c9c <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
	return;
  8022a6:	90                   	nop
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	ff 75 0c             	pushl  0xc(%ebp)
  8022b5:	ff 75 08             	pushl  0x8(%ebp)
  8022b8:	6a 2d                	push   $0x2d
  8022ba:	e8 dd f9 ff ff       	call   801c9c <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
	return;
  8022c2:	90                   	nop
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	83 e8 04             	sub    $0x4,%eax
  8022d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8022d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	83 e8 04             	sub    $0x4,%eax
  8022ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	83 e0 01             	and    $0x1,%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	0f 94 c0             	sete   %al
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230c:	83 f8 02             	cmp    $0x2,%eax
  80230f:	74 2b                	je     80233c <alloc_block+0x40>
  802311:	83 f8 02             	cmp    $0x2,%eax
  802314:	7f 07                	jg     80231d <alloc_block+0x21>
  802316:	83 f8 01             	cmp    $0x1,%eax
  802319:	74 0e                	je     802329 <alloc_block+0x2d>
  80231b:	eb 58                	jmp    802375 <alloc_block+0x79>
  80231d:	83 f8 03             	cmp    $0x3,%eax
  802320:	74 2d                	je     80234f <alloc_block+0x53>
  802322:	83 f8 04             	cmp    $0x4,%eax
  802325:	74 3b                	je     802362 <alloc_block+0x66>
  802327:	eb 4c                	jmp    802375 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802329:	83 ec 0c             	sub    $0xc,%esp
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	e8 11 03 00 00       	call   802645 <alloc_block_FF>
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80233a:	eb 4a                	jmp    802386 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	ff 75 08             	pushl  0x8(%ebp)
  802342:	e8 fa 19 00 00       	call   803d41 <alloc_block_NF>
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80234d:	eb 37                	jmp    802386 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	ff 75 08             	pushl  0x8(%ebp)
  802355:	e8 a7 07 00 00       	call   802b01 <alloc_block_BF>
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802360:	eb 24                	jmp    802386 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802362:	83 ec 0c             	sub    $0xc,%esp
  802365:	ff 75 08             	pushl  0x8(%ebp)
  802368:	e8 b7 19 00 00       	call   803d24 <alloc_block_WF>
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802373:	eb 11                	jmp    802386 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	68 78 49 80 00       	push   $0x804978
  80237d:	e8 3b e6 ff ff       	call   8009bd <cprintf>
  802382:	83 c4 10             	add    $0x10,%esp
		break;
  802385:	90                   	nop
	}
	return va;
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	53                   	push   %ebx
  80238f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802392:	83 ec 0c             	sub    $0xc,%esp
  802395:	68 98 49 80 00       	push   $0x804998
  80239a:	e8 1e e6 ff ff       	call   8009bd <cprintf>
  80239f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8023a2:	83 ec 0c             	sub    $0xc,%esp
  8023a5:	68 c3 49 80 00       	push   $0x8049c3
  8023aa:	e8 0e e6 ff ff       	call   8009bd <cprintf>
  8023af:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b8:	eb 37                	jmp    8023f1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8023ba:	83 ec 0c             	sub    $0xc,%esp
  8023bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c0:	e8 19 ff ff ff       	call   8022de <is_free_block>
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	0f be d8             	movsbl %al,%ebx
  8023cb:	83 ec 0c             	sub    $0xc,%esp
  8023ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8023d1:	e8 ef fe ff ff       	call   8022c5 <get_block_size>
  8023d6:	83 c4 10             	add    $0x10,%esp
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	53                   	push   %ebx
  8023dd:	50                   	push   %eax
  8023de:	68 db 49 80 00       	push   $0x8049db
  8023e3:	e8 d5 e5 ff ff       	call   8009bd <cprintf>
  8023e8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8023eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	74 07                	je     8023fe <print_blocks_list+0x73>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	eb 05                	jmp    802403 <print_blocks_list+0x78>
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	89 45 10             	mov    %eax,0x10(%ebp)
  802406:	8b 45 10             	mov    0x10(%ebp),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 ad                	jne    8023ba <print_blocks_list+0x2f>
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	75 a7                	jne    8023ba <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	68 98 49 80 00       	push   $0x804998
  80241b:	e8 9d e5 ff ff       	call   8009bd <cprintf>
  802420:	83 c4 10             	add    $0x10,%esp

}
  802423:	90                   	nop
  802424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80242f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802432:	83 e0 01             	and    $0x1,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 03                	je     80243c <initialize_dynamic_allocator+0x13>
  802439:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80243c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802440:	0f 84 c7 01 00 00    	je     80260d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802446:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80244d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	8b 45 0c             	mov    0xc(%ebp),%eax
  802456:	01 d0                	add    %edx,%eax
  802458:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80245d:	0f 87 ad 01 00 00    	ja     802610 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	0f 89 a5 01 00 00    	jns    802613 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80246e:	8b 55 08             	mov    0x8(%ebp),%edx
  802471:	8b 45 0c             	mov    0xc(%ebp),%eax
  802474:	01 d0                	add    %edx,%eax
  802476:	83 e8 04             	sub    $0x4,%eax
  802479:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  80247e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802485:	a1 44 50 80 00       	mov    0x805044,%eax
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248d:	e9 87 00 00 00       	jmp    802519 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802496:	75 14                	jne    8024ac <initialize_dynamic_allocator+0x83>
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 f3 49 80 00       	push   $0x8049f3
  8024a0:	6a 79                	push   $0x79
  8024a2:	68 11 4a 80 00       	push   $0x804a11
  8024a7:	e8 54 e2 ff ff       	call   800700 <_panic>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 10                	je     8024c5 <initialize_dynamic_allocator+0x9c>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bd:	8b 52 04             	mov    0x4(%edx),%edx
  8024c0:	89 50 04             	mov    %edx,0x4(%eax)
  8024c3:	eb 0b                	jmp    8024d0 <initialize_dynamic_allocator+0xa7>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	a3 48 50 80 00       	mov    %eax,0x805048
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 0f                	je     8024e9 <initialize_dynamic_allocator+0xc0>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e3:	8b 12                	mov    (%edx),%edx
  8024e5:	89 10                	mov    %edx,(%eax)
  8024e7:	eb 0a                	jmp    8024f3 <initialize_dynamic_allocator+0xca>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802506:	a1 50 50 80 00       	mov    0x805050,%eax
  80250b:	48                   	dec    %eax
  80250c:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802511:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	74 07                	je     802526 <initialize_dynamic_allocator+0xfd>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	eb 05                	jmp    80252b <initialize_dynamic_allocator+0x102>
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802530:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	0f 85 55 ff ff ff    	jne    802492 <initialize_dynamic_allocator+0x69>
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	0f 85 4b ff ff ff    	jne    802492 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802556:	a1 4c 92 80 00       	mov    0x80924c,%eax
  80255b:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  802560:	a1 48 92 80 00       	mov    0x809248,%eax
  802565:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	83 c0 08             	add    $0x8,%eax
  802571:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	83 c0 04             	add    $0x4,%eax
  80257a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257d:	83 ea 08             	sub    $0x8,%edx
  802580:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802582:	8b 55 0c             	mov    0xc(%ebp),%edx
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	01 d0                	add    %edx,%eax
  80258a:	83 e8 08             	sub    $0x8,%eax
  80258d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802590:	83 ea 08             	sub    $0x8,%edx
  802593:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80259e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8025a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ac:	75 17                	jne    8025c5 <initialize_dynamic_allocator+0x19c>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 2c 4a 80 00       	push   $0x804a2c
  8025b6:	68 90 00 00 00       	push   $0x90
  8025bb:	68 11 4a 80 00       	push   $0x804a11
  8025c0:	e8 3b e1 ff ff       	call   800700 <_panic>
  8025c5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	89 10                	mov    %edx,(%eax)
  8025d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 0d                	je     8025e6 <initialize_dynamic_allocator+0x1bd>
  8025d9:	a1 44 50 80 00       	mov    0x805044,%eax
  8025de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e1:	89 50 04             	mov    %edx,0x4(%eax)
  8025e4:	eb 08                	jmp    8025ee <initialize_dynamic_allocator+0x1c5>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802600:	a1 50 50 80 00       	mov    0x805050,%eax
  802605:	40                   	inc    %eax
  802606:	a3 50 50 80 00       	mov    %eax,0x805050
  80260b:	eb 07                	jmp    802614 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80260d:	90                   	nop
  80260e:	eb 04                	jmp    802614 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802610:	90                   	nop
  802611:	eb 01                	jmp    802614 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802613:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802619:	8b 45 10             	mov    0x10(%ebp),%eax
  80261c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8d 50 fc             	lea    -0x4(%eax),%edx
  802625:	8b 45 0c             	mov    0xc(%ebp),%eax
  802628:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	83 e8 04             	sub    $0x4,%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	83 e0 fe             	and    $0xfffffffe,%eax
  802635:	8d 50 f8             	lea    -0x8(%eax),%edx
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	01 c2                	add    %eax,%edx
  80263d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802640:	89 02                	mov    %eax,(%edx)
}
  802642:	90                   	nop
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	83 e0 01             	and    $0x1,%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 03                	je     802658 <alloc_block_FF+0x13>
  802655:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802658:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80265c:	77 07                	ja     802665 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80265e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802665:	a1 24 50 80 00       	mov    0x805024,%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	75 73                	jne    8026e1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	83 c0 10             	add    $0x10,%eax
  802674:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802677:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80267e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	01 d0                	add    %edx,%eax
  802686:	48                   	dec    %eax
  802687:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80268a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268d:	ba 00 00 00 00       	mov    $0x0,%edx
  802692:	f7 75 ec             	divl   -0x14(%ebp)
  802695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802698:	29 d0                	sub    %edx,%eax
  80269a:	c1 e8 0c             	shr    $0xc,%eax
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	50                   	push   %eax
  8026a1:	e8 b1 f0 ff ff       	call   801757 <sbrk>
  8026a6:	83 c4 10             	add    $0x10,%esp
  8026a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	6a 00                	push   $0x0
  8026b1:	e8 a1 f0 ff ff       	call   801757 <sbrk>
  8026b6:	83 c4 10             	add    $0x10,%esp
  8026b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bf:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026c2:	83 ec 08             	sub    $0x8,%esp
  8026c5:	50                   	push   %eax
  8026c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c9:	e8 5b fd ff ff       	call   802429 <initialize_dynamic_allocator>
  8026ce:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	68 4f 4a 80 00       	push   $0x804a4f
  8026d9:	e8 df e2 ff ff       	call   8009bd <cprintf>
  8026de:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8026e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e5:	75 0a                	jne    8026f1 <alloc_block_FF+0xac>
	        return NULL;
  8026e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ec:	e9 0e 04 00 00       	jmp    802aff <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8026f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026f8:	a1 44 50 80 00       	mov    0x805044,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802700:	e9 f3 02 00 00       	jmp    8029f8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	ff 75 bc             	pushl  -0x44(%ebp)
  802711:	e8 af fb ff ff       	call   8022c5 <get_block_size>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	83 c0 08             	add    $0x8,%eax
  802722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802725:	0f 87 c5 02 00 00    	ja     8029f0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	83 c0 18             	add    $0x18,%eax
  802731:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802734:	0f 87 19 02 00 00    	ja     802953 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80273a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80273d:	2b 45 08             	sub    0x8(%ebp),%eax
  802740:	83 e8 08             	sub    $0x8,%eax
  802743:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8d 50 08             	lea    0x8(%eax),%edx
  80274c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	83 c0 08             	add    $0x8,%eax
  80275a:	83 ec 04             	sub    $0x4,%esp
  80275d:	6a 01                	push   $0x1
  80275f:	50                   	push   %eax
  802760:	ff 75 bc             	pushl  -0x44(%ebp)
  802763:	e8 ae fe ff ff       	call   802616 <set_block_data>
  802768:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	75 68                	jne    8027dd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802775:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802779:	75 17                	jne    802792 <alloc_block_FF+0x14d>
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 2c 4a 80 00       	push   $0x804a2c
  802783:	68 d7 00 00 00       	push   $0xd7
  802788:	68 11 4a 80 00       	push   $0x804a11
  80278d:	e8 6e df ff ff       	call   800700 <_panic>
  802792:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802798:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279b:	89 10                	mov    %edx,(%eax)
  80279d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 0d                	je     8027b3 <alloc_block_FF+0x16e>
  8027a6:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027ae:	89 50 04             	mov    %edx,0x4(%eax)
  8027b1:	eb 08                	jmp    8027bb <alloc_block_FF+0x176>
  8027b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b6:	a3 48 50 80 00       	mov    %eax,0x805048
  8027bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027be:	a3 44 50 80 00       	mov    %eax,0x805044
  8027c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8027d2:	40                   	inc    %eax
  8027d3:	a3 50 50 80 00       	mov    %eax,0x805050
  8027d8:	e9 dc 00 00 00       	jmp    8028b9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	75 65                	jne    80284b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027e6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027ea:	75 17                	jne    802803 <alloc_block_FF+0x1be>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 60 4a 80 00       	push   $0x804a60
  8027f4:	68 db 00 00 00       	push   $0xdb
  8027f9:	68 11 4a 80 00       	push   $0x804a11
  8027fe:	e8 fd de ff ff       	call   800700 <_panic>
  802803:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802809:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 0c                	je     802825 <alloc_block_FF+0x1e0>
  802819:	a1 48 50 80 00       	mov    0x805048,%eax
  80281e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802821:	89 10                	mov    %edx,(%eax)
  802823:	eb 08                	jmp    80282d <alloc_block_FF+0x1e8>
  802825:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802828:	a3 44 50 80 00       	mov    %eax,0x805044
  80282d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802830:	a3 48 50 80 00       	mov    %eax,0x805048
  802835:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283e:	a1 50 50 80 00       	mov    0x805050,%eax
  802843:	40                   	inc    %eax
  802844:	a3 50 50 80 00       	mov    %eax,0x805050
  802849:	eb 6e                	jmp    8028b9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	74 06                	je     802857 <alloc_block_FF+0x212>
  802851:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802855:	75 17                	jne    80286e <alloc_block_FF+0x229>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 84 4a 80 00       	push   $0x804a84
  80285f:	68 df 00 00 00       	push   $0xdf
  802864:	68 11 4a 80 00       	push   $0x804a11
  802869:	e8 92 de ff ff       	call   800700 <_panic>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 10                	mov    (%eax),%edx
  802873:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802876:	89 10                	mov    %edx,(%eax)
  802878:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 0b                	je     80288c <alloc_block_FF+0x247>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289a:	89 50 04             	mov    %edx,0x4(%eax)
  80289d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	75 08                	jne    8028ae <alloc_block_FF+0x269>
  8028a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a9:	a3 48 50 80 00       	mov    %eax,0x805048
  8028ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b3:	40                   	inc    %eax
  8028b4:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	75 17                	jne    8028d6 <alloc_block_FF+0x291>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 f3 49 80 00       	push   $0x8049f3
  8028c7:	68 e1 00 00 00       	push   $0xe1
  8028cc:	68 11 4a 80 00       	push   $0x804a11
  8028d1:	e8 2a de ff ff       	call   800700 <_panic>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 10                	je     8028ef <alloc_block_FF+0x2aa>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 0b                	jmp    8028fa <alloc_block_FF+0x2b5>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	a3 48 50 80 00       	mov    %eax,0x805048
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <alloc_block_FF+0x2ce>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290d:	8b 12                	mov    (%edx),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	eb 0a                	jmp    80291d <alloc_block_FF+0x2d8>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	a3 44 50 80 00       	mov    %eax,0x805044
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802930:	a1 50 50 80 00       	mov    0x805050,%eax
  802935:	48                   	dec    %eax
  802936:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	6a 00                	push   $0x0
  802940:	ff 75 b4             	pushl  -0x4c(%ebp)
  802943:	ff 75 b0             	pushl  -0x50(%ebp)
  802946:	e8 cb fc ff ff       	call   802616 <set_block_data>
  80294b:	83 c4 10             	add    $0x10,%esp
  80294e:	e9 95 00 00 00       	jmp    8029e8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	6a 01                	push   $0x1
  802958:	ff 75 b8             	pushl  -0x48(%ebp)
  80295b:	ff 75 bc             	pushl  -0x44(%ebp)
  80295e:	e8 b3 fc ff ff       	call   802616 <set_block_data>
  802963:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	75 17                	jne    802983 <alloc_block_FF+0x33e>
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	68 f3 49 80 00       	push   $0x8049f3
  802974:	68 e8 00 00 00       	push   $0xe8
  802979:	68 11 4a 80 00       	push   $0x804a11
  80297e:	e8 7d dd ff ff       	call   800700 <_panic>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 10                	je     80299c <alloc_block_FF+0x357>
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802994:	8b 52 04             	mov    0x4(%edx),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	eb 0b                	jmp    8029a7 <alloc_block_FF+0x362>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 04             	mov    0x4(%eax),%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	74 0f                	je     8029c0 <alloc_block_FF+0x37b>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	8b 12                	mov    (%edx),%edx
  8029bc:	89 10                	mov    %edx,(%eax)
  8029be:	eb 0a                	jmp    8029ca <alloc_block_FF+0x385>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8029e2:	48                   	dec    %eax
  8029e3:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  8029e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029eb:	e9 0f 01 00 00       	jmp    802aff <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fc:	74 07                	je     802a05 <alloc_block_FF+0x3c0>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	eb 05                	jmp    802a0a <alloc_block_FF+0x3c5>
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a0f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	0f 85 e9 fc ff ff    	jne    802705 <alloc_block_FF+0xc0>
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	0f 85 df fc ff ff    	jne    802705 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	83 c0 08             	add    $0x8,%eax
  802a2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a2f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a3c:	01 d0                	add    %edx,%eax
  802a3e:	48                   	dec    %eax
  802a3f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a45:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4a:	f7 75 d8             	divl   -0x28(%ebp)
  802a4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a50:	29 d0                	sub    %edx,%eax
  802a52:	c1 e8 0c             	shr    $0xc,%eax
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	50                   	push   %eax
  802a59:	e8 f9 ec ff ff       	call   801757 <sbrk>
  802a5e:	83 c4 10             	add    $0x10,%esp
  802a61:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802a64:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a68:	75 0a                	jne    802a74 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	e9 8b 00 00 00       	jmp    802aff <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a74:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a81:	01 d0                	add    %edx,%eax
  802a83:	48                   	dec    %eax
  802a84:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802a87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8f:	f7 75 cc             	divl   -0x34(%ebp)
  802a92:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a95:	29 d0                	sub    %edx,%eax
  802a97:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a9d:	01 d0                	add    %edx,%eax
  802a9f:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  802aa4:	a1 48 92 80 00       	mov    0x809248,%eax
  802aa9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802aaf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ab6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802abc:	01 d0                	add    %edx,%eax
  802abe:	48                   	dec    %eax
  802abf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ac2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aca:	f7 75 c4             	divl   -0x3c(%ebp)
  802acd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ad0:	29 d0                	sub    %edx,%eax
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	6a 01                	push   $0x1
  802ad7:	50                   	push   %eax
  802ad8:	ff 75 d0             	pushl  -0x30(%ebp)
  802adb:	e8 36 fb ff ff       	call   802616 <set_block_data>
  802ae0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ae3:	83 ec 0c             	sub    $0xc,%esp
  802ae6:	ff 75 d0             	pushl  -0x30(%ebp)
  802ae9:	e8 1b 0a 00 00       	call   803509 <free_block>
  802aee:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802af1:	83 ec 0c             	sub    $0xc,%esp
  802af4:	ff 75 08             	pushl  0x8(%ebp)
  802af7:	e8 49 fb ff ff       	call   802645 <alloc_block_FF>
  802afc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	83 e0 01             	and    $0x1,%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 03                	je     802b14 <alloc_block_BF+0x13>
  802b11:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b14:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b18:	77 07                	ja     802b21 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b1a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b21:	a1 24 50 80 00       	mov    0x805024,%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	75 73                	jne    802b9d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	83 c0 10             	add    $0x10,%eax
  802b30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b33:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b40:	01 d0                	add    %edx,%eax
  802b42:	48                   	dec    %eax
  802b43:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b49:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4e:	f7 75 e0             	divl   -0x20(%ebp)
  802b51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b54:	29 d0                	sub    %edx,%eax
  802b56:	c1 e8 0c             	shr    $0xc,%eax
  802b59:	83 ec 0c             	sub    $0xc,%esp
  802b5c:	50                   	push   %eax
  802b5d:	e8 f5 eb ff ff       	call   801757 <sbrk>
  802b62:	83 c4 10             	add    $0x10,%esp
  802b65:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b68:	83 ec 0c             	sub    $0xc,%esp
  802b6b:	6a 00                	push   $0x0
  802b6d:	e8 e5 eb ff ff       	call   801757 <sbrk>
  802b72:	83 c4 10             	add    $0x10,%esp
  802b75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b7b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802b7e:	83 ec 08             	sub    $0x8,%esp
  802b81:	50                   	push   %eax
  802b82:	ff 75 d8             	pushl  -0x28(%ebp)
  802b85:	e8 9f f8 ff ff       	call   802429 <initialize_dynamic_allocator>
  802b8a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b8d:	83 ec 0c             	sub    $0xc,%esp
  802b90:	68 4f 4a 80 00       	push   $0x804a4f
  802b95:	e8 23 de ff ff       	call   8009bd <cprintf>
  802b9a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802b9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ba4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802bab:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802bb2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802bb9:	a1 44 50 80 00       	mov    0x805044,%eax
  802bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc1:	e9 1d 01 00 00       	jmp    802ce3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802bcc:	83 ec 0c             	sub    $0xc,%esp
  802bcf:	ff 75 a8             	pushl  -0x58(%ebp)
  802bd2:	e8 ee f6 ff ff       	call   8022c5 <get_block_size>
  802bd7:	83 c4 10             	add    $0x10,%esp
  802bda:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	83 c0 08             	add    $0x8,%eax
  802be3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802be6:	0f 87 ef 00 00 00    	ja     802cdb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	83 c0 18             	add    $0x18,%eax
  802bf2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bf5:	77 1d                	ja     802c14 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bfd:	0f 86 d8 00 00 00    	jbe    802cdb <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c03:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c09:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c0f:	e9 c7 00 00 00       	jmp    802cdb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	83 c0 08             	add    $0x8,%eax
  802c1a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c1d:	0f 85 9d 00 00 00    	jne    802cc0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	6a 01                	push   $0x1
  802c28:	ff 75 a4             	pushl  -0x5c(%ebp)
  802c2b:	ff 75 a8             	pushl  -0x58(%ebp)
  802c2e:	e8 e3 f9 ff ff       	call   802616 <set_block_data>
  802c33:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_BF+0x152>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 f3 49 80 00       	push   $0x8049f3
  802c44:	68 2c 01 00 00       	push   $0x12c
  802c49:	68 11 4a 80 00       	push   $0x804a11
  802c4e:	e8 ad da ff ff       	call   800700 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 10                	je     802c6c <alloc_block_BF+0x16b>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	8b 52 04             	mov    0x4(%edx),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 0b                	jmp    802c77 <alloc_block_BF+0x176>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	a3 48 50 80 00       	mov    %eax,0x805048
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0f                	je     802c90 <alloc_block_BF+0x18f>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 12                	mov    (%edx),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 0a                	jmp    802c9a <alloc_block_BF+0x199>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	a3 44 50 80 00       	mov    %eax,0x805044
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 50 50 80 00       	mov    0x805050,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802cb8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cbb:	e9 24 04 00 00       	jmp    8030e4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cc6:	76 13                	jbe    802cdb <alloc_block_BF+0x1da>
					{
						internal = 1;
  802cc8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ccf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802cd5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802cdb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce7:	74 07                	je     802cf0 <alloc_block_BF+0x1ef>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	eb 05                	jmp    802cf5 <alloc_block_BF+0x1f4>
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802cfa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	0f 85 bf fe ff ff    	jne    802bc6 <alloc_block_BF+0xc5>
  802d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0b:	0f 85 b5 fe ff ff    	jne    802bc6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d15:	0f 84 26 02 00 00    	je     802f41 <alloc_block_BF+0x440>
  802d1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d1f:	0f 85 1c 02 00 00    	jne    802f41 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2b:	83 e8 08             	sub    $0x8,%eax
  802d2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8d 50 08             	lea    0x8(%eax),%edx
  802d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3a:	01 d0                	add    %edx,%eax
  802d3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	83 c0 08             	add    $0x8,%eax
  802d45:	83 ec 04             	sub    $0x4,%esp
  802d48:	6a 01                	push   $0x1
  802d4a:	50                   	push   %eax
  802d4b:	ff 75 f0             	pushl  -0x10(%ebp)
  802d4e:	e8 c3 f8 ff ff       	call   802616 <set_block_data>
  802d53:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	75 68                	jne    802dc8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d60:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d64:	75 17                	jne    802d7d <alloc_block_BF+0x27c>
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	68 2c 4a 80 00       	push   $0x804a2c
  802d6e:	68 45 01 00 00       	push   $0x145
  802d73:	68 11 4a 80 00       	push   $0x804a11
  802d78:	e8 83 d9 ff ff       	call   800700 <_panic>
  802d7d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d86:	89 10                	mov    %edx,(%eax)
  802d88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	74 0d                	je     802d9e <alloc_block_BF+0x29d>
  802d91:	a1 44 50 80 00       	mov    0x805044,%eax
  802d96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d99:	89 50 04             	mov    %edx,0x4(%eax)
  802d9c:	eb 08                	jmp    802da6 <alloc_block_BF+0x2a5>
  802d9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da1:	a3 48 50 80 00       	mov    %eax,0x805048
  802da6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da9:	a3 44 50 80 00       	mov    %eax,0x805044
  802dae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802db1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db8:	a1 50 50 80 00       	mov    0x805050,%eax
  802dbd:	40                   	inc    %eax
  802dbe:	a3 50 50 80 00       	mov    %eax,0x805050
  802dc3:	e9 dc 00 00 00       	jmp    802ea4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	75 65                	jne    802e36 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802dd1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dd5:	75 17                	jne    802dee <alloc_block_BF+0x2ed>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 60 4a 80 00       	push   $0x804a60
  802ddf:	68 4a 01 00 00       	push   $0x14a
  802de4:	68 11 4a 80 00       	push   $0x804a11
  802de9:	e8 12 d9 ff ff       	call   800700 <_panic>
  802dee:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802df4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0c                	je     802e10 <alloc_block_BF+0x30f>
  802e04:	a1 48 50 80 00       	mov    0x805048,%eax
  802e09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	eb 08                	jmp    802e18 <alloc_block_BF+0x317>
  802e10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e13:	a3 44 50 80 00       	mov    %eax,0x805044
  802e18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e1b:	a3 48 50 80 00       	mov    %eax,0x805048
  802e20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e29:	a1 50 50 80 00       	mov    0x805050,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 50 50 80 00       	mov    %eax,0x805050
  802e34:	eb 6e                	jmp    802ea4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802e36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3a:	74 06                	je     802e42 <alloc_block_BF+0x341>
  802e3c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e40:	75 17                	jne    802e59 <alloc_block_BF+0x358>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 84 4a 80 00       	push   $0x804a84
  802e4a:	68 4f 01 00 00       	push   $0x14f
  802e4f:	68 11 4a 80 00       	push   $0x804a11
  802e54:	e8 a7 d8 ff ff       	call   800700 <_panic>
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 10                	mov    (%eax),%edx
  802e5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0b                	je     802e77 <alloc_block_BF+0x376>
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e85:	89 50 04             	mov    %edx,0x4(%eax)
  802e88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	75 08                	jne    802e99 <alloc_block_BF+0x398>
  802e91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e94:	a3 48 50 80 00       	mov    %eax,0x805048
  802e99:	a1 50 50 80 00       	mov    0x805050,%eax
  802e9e:	40                   	inc    %eax
  802e9f:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea8:	75 17                	jne    802ec1 <alloc_block_BF+0x3c0>
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 f3 49 80 00       	push   $0x8049f3
  802eb2:	68 51 01 00 00       	push   $0x151
  802eb7:	68 11 4a 80 00       	push   $0x804a11
  802ebc:	e8 3f d8 ff ff       	call   800700 <_panic>
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 10                	je     802eda <alloc_block_BF+0x3d9>
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed2:	8b 52 04             	mov    0x4(%edx),%edx
  802ed5:	89 50 04             	mov    %edx,0x4(%eax)
  802ed8:	eb 0b                	jmp    802ee5 <alloc_block_BF+0x3e4>
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	a3 48 50 80 00       	mov    %eax,0x805048
  802ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee8:	8b 40 04             	mov    0x4(%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0f                	je     802efe <alloc_block_BF+0x3fd>
  802eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef8:	8b 12                	mov    (%edx),%edx
  802efa:	89 10                	mov    %edx,(%eax)
  802efc:	eb 0a                	jmp    802f08 <alloc_block_BF+0x407>
  802efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	a3 44 50 80 00       	mov    %eax,0x805044
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1b:	a1 50 50 80 00       	mov    0x805050,%eax
  802f20:	48                   	dec    %eax
  802f21:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	6a 00                	push   $0x0
  802f2b:	ff 75 d0             	pushl  -0x30(%ebp)
  802f2e:	ff 75 cc             	pushl  -0x34(%ebp)
  802f31:	e8 e0 f6 ff ff       	call   802616 <set_block_data>
  802f36:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	e9 a3 01 00 00       	jmp    8030e4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802f41:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802f45:	0f 85 9d 00 00 00    	jne    802fe8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	6a 01                	push   $0x1
  802f50:	ff 75 ec             	pushl  -0x14(%ebp)
  802f53:	ff 75 f0             	pushl  -0x10(%ebp)
  802f56:	e8 bb f6 ff ff       	call   802616 <set_block_data>
  802f5b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f62:	75 17                	jne    802f7b <alloc_block_BF+0x47a>
  802f64:	83 ec 04             	sub    $0x4,%esp
  802f67:	68 f3 49 80 00       	push   $0x8049f3
  802f6c:	68 58 01 00 00       	push   $0x158
  802f71:	68 11 4a 80 00       	push   $0x804a11
  802f76:	e8 85 d7 ff ff       	call   800700 <_panic>
  802f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	74 10                	je     802f94 <alloc_block_BF+0x493>
  802f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8c:	8b 52 04             	mov    0x4(%edx),%edx
  802f8f:	89 50 04             	mov    %edx,0x4(%eax)
  802f92:	eb 0b                	jmp    802f9f <alloc_block_BF+0x49e>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	a3 48 50 80 00       	mov    %eax,0x805048
  802f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa2:	8b 40 04             	mov    0x4(%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 0f                	je     802fb8 <alloc_block_BF+0x4b7>
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	8b 40 04             	mov    0x4(%eax),%eax
  802faf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb2:	8b 12                	mov    (%edx),%edx
  802fb4:	89 10                	mov    %edx,(%eax)
  802fb6:	eb 0a                	jmp    802fc2 <alloc_block_BF+0x4c1>
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	a3 44 50 80 00       	mov    %eax,0x805044
  802fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd5:	a1 50 50 80 00       	mov    0x805050,%eax
  802fda:	48                   	dec    %eax
  802fdb:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	e9 fc 00 00 00       	jmp    8030e4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	83 c0 08             	add    $0x8,%eax
  802fee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ff1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ff8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ffb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ffe:	01 d0                	add    %edx,%eax
  803000:	48                   	dec    %eax
  803001:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803004:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803007:	ba 00 00 00 00       	mov    $0x0,%edx
  80300c:	f7 75 c4             	divl   -0x3c(%ebp)
  80300f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803012:	29 d0                	sub    %edx,%eax
  803014:	c1 e8 0c             	shr    $0xc,%eax
  803017:	83 ec 0c             	sub    $0xc,%esp
  80301a:	50                   	push   %eax
  80301b:	e8 37 e7 ff ff       	call   801757 <sbrk>
  803020:	83 c4 10             	add    $0x10,%esp
  803023:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803026:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80302a:	75 0a                	jne    803036 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80302c:	b8 00 00 00 00       	mov    $0x0,%eax
  803031:	e9 ae 00 00 00       	jmp    8030e4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803036:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80303d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803040:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803043:	01 d0                	add    %edx,%eax
  803045:	48                   	dec    %eax
  803046:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803049:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80304c:	ba 00 00 00 00       	mov    $0x0,%edx
  803051:	f7 75 b8             	divl   -0x48(%ebp)
  803054:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803057:	29 d0                	sub    %edx,%eax
  803059:	8d 50 fc             	lea    -0x4(%eax),%edx
  80305c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80305f:	01 d0                	add    %edx,%eax
  803061:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  803066:	a1 48 92 80 00       	mov    0x809248,%eax
  80306b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803071:	83 ec 0c             	sub    $0xc,%esp
  803074:	68 b8 4a 80 00       	push   $0x804ab8
  803079:	e8 3f d9 ff ff       	call   8009bd <cprintf>
  80307e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803081:	83 ec 08             	sub    $0x8,%esp
  803084:	ff 75 bc             	pushl  -0x44(%ebp)
  803087:	68 bd 4a 80 00       	push   $0x804abd
  80308c:	e8 2c d9 ff ff       	call   8009bd <cprintf>
  803091:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803094:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80309b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80309e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	48                   	dec    %eax
  8030a4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8030a7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8030af:	f7 75 b0             	divl   -0x50(%ebp)
  8030b2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030b5:	29 d0                	sub    %edx,%eax
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	6a 01                	push   $0x1
  8030bc:	50                   	push   %eax
  8030bd:	ff 75 bc             	pushl  -0x44(%ebp)
  8030c0:	e8 51 f5 ff ff       	call   802616 <set_block_data>
  8030c5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8030c8:	83 ec 0c             	sub    $0xc,%esp
  8030cb:	ff 75 bc             	pushl  -0x44(%ebp)
  8030ce:	e8 36 04 00 00       	call   803509 <free_block>
  8030d3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8030d6:	83 ec 0c             	sub    $0xc,%esp
  8030d9:	ff 75 08             	pushl  0x8(%ebp)
  8030dc:	e8 20 fa ff ff       	call   802b01 <alloc_block_BF>
  8030e1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
  8030e9:	53                   	push   %ebx
  8030ea:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8030ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	74 1e                	je     80311f <merging+0x39>
  803101:	ff 75 08             	pushl  0x8(%ebp)
  803104:	e8 bc f1 ff ff       	call   8022c5 <get_block_size>
  803109:	83 c4 04             	add    $0x4,%esp
  80310c:	89 c2                	mov    %eax,%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	01 d0                	add    %edx,%eax
  803113:	3b 45 10             	cmp    0x10(%ebp),%eax
  803116:	75 07                	jne    80311f <merging+0x39>
		prev_is_free = 1;
  803118:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80311f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803123:	74 1e                	je     803143 <merging+0x5d>
  803125:	ff 75 10             	pushl  0x10(%ebp)
  803128:	e8 98 f1 ff ff       	call   8022c5 <get_block_size>
  80312d:	83 c4 04             	add    $0x4,%esp
  803130:	89 c2                	mov    %eax,%edx
  803132:	8b 45 10             	mov    0x10(%ebp),%eax
  803135:	01 d0                	add    %edx,%eax
  803137:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80313a:	75 07                	jne    803143 <merging+0x5d>
		next_is_free = 1;
  80313c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803147:	0f 84 cc 00 00 00    	je     803219 <merging+0x133>
  80314d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803151:	0f 84 c2 00 00 00    	je     803219 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803157:	ff 75 08             	pushl  0x8(%ebp)
  80315a:	e8 66 f1 ff ff       	call   8022c5 <get_block_size>
  80315f:	83 c4 04             	add    $0x4,%esp
  803162:	89 c3                	mov    %eax,%ebx
  803164:	ff 75 10             	pushl  0x10(%ebp)
  803167:	e8 59 f1 ff ff       	call   8022c5 <get_block_size>
  80316c:	83 c4 04             	add    $0x4,%esp
  80316f:	01 c3                	add    %eax,%ebx
  803171:	ff 75 0c             	pushl  0xc(%ebp)
  803174:	e8 4c f1 ff ff       	call   8022c5 <get_block_size>
  803179:	83 c4 04             	add    $0x4,%esp
  80317c:	01 d8                	add    %ebx,%eax
  80317e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803181:	6a 00                	push   $0x0
  803183:	ff 75 ec             	pushl  -0x14(%ebp)
  803186:	ff 75 08             	pushl  0x8(%ebp)
  803189:	e8 88 f4 ff ff       	call   802616 <set_block_data>
  80318e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803191:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803195:	75 17                	jne    8031ae <merging+0xc8>
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	68 f3 49 80 00       	push   $0x8049f3
  80319f:	68 7d 01 00 00       	push   $0x17d
  8031a4:	68 11 4a 80 00       	push   $0x804a11
  8031a9:	e8 52 d5 ff ff       	call   800700 <_panic>
  8031ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 10                	je     8031c7 <merging+0xe1>
  8031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bf:	8b 52 04             	mov    0x4(%edx),%edx
  8031c2:	89 50 04             	mov    %edx,0x4(%eax)
  8031c5:	eb 0b                	jmp    8031d2 <merging+0xec>
  8031c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ca:	8b 40 04             	mov    0x4(%eax),%eax
  8031cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8031d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 0f                	je     8031eb <merging+0x105>
  8031dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031df:	8b 40 04             	mov    0x4(%eax),%eax
  8031e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e5:	8b 12                	mov    (%edx),%edx
  8031e7:	89 10                	mov    %edx,(%eax)
  8031e9:	eb 0a                	jmp    8031f5 <merging+0x10f>
  8031eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8031f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803208:	a1 50 50 80 00       	mov    0x805050,%eax
  80320d:	48                   	dec    %eax
  80320e:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803213:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803214:	e9 ea 02 00 00       	jmp    803503 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321d:	74 3b                	je     80325a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80321f:	83 ec 0c             	sub    $0xc,%esp
  803222:	ff 75 08             	pushl  0x8(%ebp)
  803225:	e8 9b f0 ff ff       	call   8022c5 <get_block_size>
  80322a:	83 c4 10             	add    $0x10,%esp
  80322d:	89 c3                	mov    %eax,%ebx
  80322f:	83 ec 0c             	sub    $0xc,%esp
  803232:	ff 75 10             	pushl  0x10(%ebp)
  803235:	e8 8b f0 ff ff       	call   8022c5 <get_block_size>
  80323a:	83 c4 10             	add    $0x10,%esp
  80323d:	01 d8                	add    %ebx,%eax
  80323f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	6a 00                	push   $0x0
  803247:	ff 75 e8             	pushl  -0x18(%ebp)
  80324a:	ff 75 08             	pushl  0x8(%ebp)
  80324d:	e8 c4 f3 ff ff       	call   802616 <set_block_data>
  803252:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803255:	e9 a9 02 00 00       	jmp    803503 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80325a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80325e:	0f 84 2d 01 00 00    	je     803391 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803264:	83 ec 0c             	sub    $0xc,%esp
  803267:	ff 75 10             	pushl  0x10(%ebp)
  80326a:	e8 56 f0 ff ff       	call   8022c5 <get_block_size>
  80326f:	83 c4 10             	add    $0x10,%esp
  803272:	89 c3                	mov    %eax,%ebx
  803274:	83 ec 0c             	sub    $0xc,%esp
  803277:	ff 75 0c             	pushl  0xc(%ebp)
  80327a:	e8 46 f0 ff ff       	call   8022c5 <get_block_size>
  80327f:	83 c4 10             	add    $0x10,%esp
  803282:	01 d8                	add    %ebx,%eax
  803284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803287:	83 ec 04             	sub    $0x4,%esp
  80328a:	6a 00                	push   $0x0
  80328c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80328f:	ff 75 10             	pushl  0x10(%ebp)
  803292:	e8 7f f3 ff ff       	call   802616 <set_block_data>
  803297:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80329a:	8b 45 10             	mov    0x10(%ebp),%eax
  80329d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8032a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032a4:	74 06                	je     8032ac <merging+0x1c6>
  8032a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032aa:	75 17                	jne    8032c3 <merging+0x1dd>
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 cc 4a 80 00       	push   $0x804acc
  8032b4:	68 8d 01 00 00       	push   $0x18d
  8032b9:	68 11 4a 80 00       	push   $0x804a11
  8032be:	e8 3d d4 ff ff       	call   800700 <_panic>
  8032c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c6:	8b 50 04             	mov    0x4(%eax),%edx
  8032c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cc:	89 50 04             	mov    %edx,0x4(%eax)
  8032cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0d                	je     8032ee <merging+0x208>
  8032e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e4:	8b 40 04             	mov    0x4(%eax),%eax
  8032e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ea:	89 10                	mov    %edx,(%eax)
  8032ec:	eb 08                	jmp    8032f6 <merging+0x210>
  8032ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8032f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032fc:	89 50 04             	mov    %edx,0x4(%eax)
  8032ff:	a1 50 50 80 00       	mov    0x805050,%eax
  803304:	40                   	inc    %eax
  803305:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  80330a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80330e:	75 17                	jne    803327 <merging+0x241>
  803310:	83 ec 04             	sub    $0x4,%esp
  803313:	68 f3 49 80 00       	push   $0x8049f3
  803318:	68 8e 01 00 00       	push   $0x18e
  80331d:	68 11 4a 80 00       	push   $0x804a11
  803322:	e8 d9 d3 ff ff       	call   800700 <_panic>
  803327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 10                	je     803340 <merging+0x25a>
  803330:	8b 45 0c             	mov    0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	8b 55 0c             	mov    0xc(%ebp),%edx
  803338:	8b 52 04             	mov    0x4(%edx),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	eb 0b                	jmp    80334b <merging+0x265>
  803340:	8b 45 0c             	mov    0xc(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	a3 48 50 80 00       	mov    %eax,0x805048
  80334b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 0f                	je     803364 <merging+0x27e>
  803355:	8b 45 0c             	mov    0xc(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80335e:	8b 12                	mov    (%edx),%edx
  803360:	89 10                	mov    %edx,(%eax)
  803362:	eb 0a                	jmp    80336e <merging+0x288>
  803364:	8b 45 0c             	mov    0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	a3 44 50 80 00       	mov    %eax,0x805044
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 50 50 80 00       	mov    0x805050,%eax
  803386:	48                   	dec    %eax
  803387:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80338c:	e9 72 01 00 00       	jmp    803503 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803391:	8b 45 10             	mov    0x10(%ebp),%eax
  803394:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339b:	74 79                	je     803416 <merging+0x330>
  80339d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a1:	74 73                	je     803416 <merging+0x330>
  8033a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a7:	74 06                	je     8033af <merging+0x2c9>
  8033a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033ad:	75 17                	jne    8033c6 <merging+0x2e0>
  8033af:	83 ec 04             	sub    $0x4,%esp
  8033b2:	68 84 4a 80 00       	push   $0x804a84
  8033b7:	68 94 01 00 00       	push   $0x194
  8033bc:	68 11 4a 80 00       	push   $0x804a11
  8033c1:	e8 3a d3 ff ff       	call   800700 <_panic>
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	8b 10                	mov    (%eax),%edx
  8033cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ce:	89 10                	mov    %edx,(%eax)
  8033d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 0b                	je     8033e4 <merging+0x2fe>
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033e1:	89 50 04             	mov    %edx,0x4(%eax)
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	75 08                	jne    803406 <merging+0x320>
  8033fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803401:	a3 48 50 80 00       	mov    %eax,0x805048
  803406:	a1 50 50 80 00       	mov    0x805050,%eax
  80340b:	40                   	inc    %eax
  80340c:	a3 50 50 80 00       	mov    %eax,0x805050
  803411:	e9 ce 00 00 00       	jmp    8034e4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803416:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341a:	74 65                	je     803481 <merging+0x39b>
  80341c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803420:	75 17                	jne    803439 <merging+0x353>
  803422:	83 ec 04             	sub    $0x4,%esp
  803425:	68 60 4a 80 00       	push   $0x804a60
  80342a:	68 95 01 00 00       	push   $0x195
  80342f:	68 11 4a 80 00       	push   $0x804a11
  803434:	e8 c7 d2 ff ff       	call   800700 <_panic>
  803439:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80343f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803442:	89 50 04             	mov    %edx,0x4(%eax)
  803445:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 0c                	je     80345b <merging+0x375>
  80344f:	a1 48 50 80 00       	mov    0x805048,%eax
  803454:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803457:	89 10                	mov    %edx,(%eax)
  803459:	eb 08                	jmp    803463 <merging+0x37d>
  80345b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345e:	a3 44 50 80 00       	mov    %eax,0x805044
  803463:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803466:	a3 48 50 80 00       	mov    %eax,0x805048
  80346b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80346e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803474:	a1 50 50 80 00       	mov    0x805050,%eax
  803479:	40                   	inc    %eax
  80347a:	a3 50 50 80 00       	mov    %eax,0x805050
  80347f:	eb 63                	jmp    8034e4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803481:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803485:	75 17                	jne    80349e <merging+0x3b8>
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	68 2c 4a 80 00       	push   $0x804a2c
  80348f:	68 98 01 00 00       	push   $0x198
  803494:	68 11 4a 80 00       	push   $0x804a11
  803499:	e8 62 d2 ff ff       	call   800700 <_panic>
  80349e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8034a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a7:	89 10                	mov    %edx,(%eax)
  8034a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0d                	je     8034bf <merging+0x3d9>
  8034b2:	a1 44 50 80 00       	mov    0x805044,%eax
  8034b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ba:	89 50 04             	mov    %edx,0x4(%eax)
  8034bd:	eb 08                	jmp    8034c7 <merging+0x3e1>
  8034bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c2:	a3 48 50 80 00       	mov    %eax,0x805048
  8034c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8034cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8034de:	40                   	inc    %eax
  8034df:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  8034e4:	83 ec 0c             	sub    $0xc,%esp
  8034e7:	ff 75 10             	pushl  0x10(%ebp)
  8034ea:	e8 d6 ed ff ff       	call   8022c5 <get_block_size>
  8034ef:	83 c4 10             	add    $0x10,%esp
  8034f2:	83 ec 04             	sub    $0x4,%esp
  8034f5:	6a 00                	push   $0x0
  8034f7:	50                   	push   %eax
  8034f8:	ff 75 10             	pushl  0x10(%ebp)
  8034fb:	e8 16 f1 ff ff       	call   802616 <set_block_data>
  803500:	83 c4 10             	add    $0x10,%esp
	}
}
  803503:	90                   	nop
  803504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803507:	c9                   	leave  
  803508:	c3                   	ret    

00803509 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803509:	55                   	push   %ebp
  80350a:	89 e5                	mov    %esp,%ebp
  80350c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80350f:	a1 44 50 80 00       	mov    0x805044,%eax
  803514:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803517:	a1 48 50 80 00       	mov    0x805048,%eax
  80351c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80351f:	73 1b                	jae    80353c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803521:	a1 48 50 80 00       	mov    0x805048,%eax
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	ff 75 08             	pushl  0x8(%ebp)
  80352c:	6a 00                	push   $0x0
  80352e:	50                   	push   %eax
  80352f:	e8 b2 fb ff ff       	call   8030e6 <merging>
  803534:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803537:	e9 8b 00 00 00       	jmp    8035c7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80353c:	a1 44 50 80 00       	mov    0x805044,%eax
  803541:	3b 45 08             	cmp    0x8(%ebp),%eax
  803544:	76 18                	jbe    80355e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803546:	a1 44 50 80 00       	mov    0x805044,%eax
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	ff 75 08             	pushl  0x8(%ebp)
  803551:	50                   	push   %eax
  803552:	6a 00                	push   $0x0
  803554:	e8 8d fb ff ff       	call   8030e6 <merging>
  803559:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80355c:	eb 69                	jmp    8035c7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80355e:	a1 44 50 80 00       	mov    0x805044,%eax
  803563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803566:	eb 39                	jmp    8035a1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80356e:	73 29                	jae    803599 <free_block+0x90>
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 00                	mov    (%eax),%eax
  803575:	3b 45 08             	cmp    0x8(%ebp),%eax
  803578:	76 1f                	jbe    803599 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	ff 75 08             	pushl  0x8(%ebp)
  803588:	ff 75 f0             	pushl  -0x10(%ebp)
  80358b:	ff 75 f4             	pushl  -0xc(%ebp)
  80358e:	e8 53 fb ff ff       	call   8030e6 <merging>
  803593:	83 c4 10             	add    $0x10,%esp
			break;
  803596:	90                   	nop
		}
	}
}
  803597:	eb 2e                	jmp    8035c7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803599:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80359e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a5:	74 07                	je     8035ae <free_block+0xa5>
  8035a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035aa:	8b 00                	mov    (%eax),%eax
  8035ac:	eb 05                	jmp    8035b3 <free_block+0xaa>
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8035b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	75 a7                	jne    803568 <free_block+0x5f>
  8035c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c5:	75 a1                	jne    803568 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035c7:	90                   	nop
  8035c8:	c9                   	leave  
  8035c9:	c3                   	ret    

008035ca <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8035ca:	55                   	push   %ebp
  8035cb:	89 e5                	mov    %esp,%ebp
  8035cd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8035d0:	ff 75 08             	pushl  0x8(%ebp)
  8035d3:	e8 ed ec ff ff       	call   8022c5 <get_block_size>
  8035d8:	83 c4 04             	add    $0x4,%esp
  8035db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8035de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8035e5:	eb 17                	jmp    8035fe <copy_data+0x34>
  8035e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ed:	01 c2                	add    %eax,%edx
  8035ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	01 c8                	add    %ecx,%eax
  8035f7:	8a 00                	mov    (%eax),%al
  8035f9:	88 02                	mov    %al,(%edx)
  8035fb:	ff 45 fc             	incl   -0x4(%ebp)
  8035fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803601:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803604:	72 e1                	jb     8035e7 <copy_data+0x1d>
}
  803606:	90                   	nop
  803607:	c9                   	leave  
  803608:	c3                   	ret    

00803609 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803609:	55                   	push   %ebp
  80360a:	89 e5                	mov    %esp,%ebp
  80360c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80360f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803613:	75 23                	jne    803638 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803615:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803619:	74 13                	je     80362e <realloc_block_FF+0x25>
  80361b:	83 ec 0c             	sub    $0xc,%esp
  80361e:	ff 75 0c             	pushl  0xc(%ebp)
  803621:	e8 1f f0 ff ff       	call   802645 <alloc_block_FF>
  803626:	83 c4 10             	add    $0x10,%esp
  803629:	e9 f4 06 00 00       	jmp    803d22 <realloc_block_FF+0x719>
		return NULL;
  80362e:	b8 00 00 00 00       	mov    $0x0,%eax
  803633:	e9 ea 06 00 00       	jmp    803d22 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803638:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80363c:	75 18                	jne    803656 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80363e:	83 ec 0c             	sub    $0xc,%esp
  803641:	ff 75 08             	pushl  0x8(%ebp)
  803644:	e8 c0 fe ff ff       	call   803509 <free_block>
  803649:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80364c:	b8 00 00 00 00       	mov    $0x0,%eax
  803651:	e9 cc 06 00 00       	jmp    803d22 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803656:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80365a:	77 07                	ja     803663 <realloc_block_FF+0x5a>
  80365c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803663:	8b 45 0c             	mov    0xc(%ebp),%eax
  803666:	83 e0 01             	and    $0x1,%eax
  803669:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80366c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366f:	83 c0 08             	add    $0x8,%eax
  803672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803675:	83 ec 0c             	sub    $0xc,%esp
  803678:	ff 75 08             	pushl  0x8(%ebp)
  80367b:	e8 45 ec ff ff       	call   8022c5 <get_block_size>
  803680:	83 c4 10             	add    $0x10,%esp
  803683:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803689:	83 e8 08             	sub    $0x8,%eax
  80368c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	83 e8 04             	sub    $0x4,%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	83 e0 fe             	and    $0xfffffffe,%eax
  80369a:	89 c2                	mov    %eax,%edx
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	01 d0                	add    %edx,%eax
  8036a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8036a4:	83 ec 0c             	sub    $0xc,%esp
  8036a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036aa:	e8 16 ec ff ff       	call   8022c5 <get_block_size>
  8036af:	83 c4 10             	add    $0x10,%esp
  8036b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b8:	83 e8 08             	sub    $0x8,%eax
  8036bb:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036c4:	75 08                	jne    8036ce <realloc_block_FF+0xc5>
	{
		 return va;
  8036c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c9:	e9 54 06 00 00       	jmp    803d22 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8036ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036d4:	0f 83 e5 03 00 00    	jae    803abf <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8036da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8036e3:	83 ec 0c             	sub    $0xc,%esp
  8036e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036e9:	e8 f0 eb ff ff       	call   8022de <is_free_block>
  8036ee:	83 c4 10             	add    $0x10,%esp
  8036f1:	84 c0                	test   %al,%al
  8036f3:	0f 84 3b 01 00 00    	je     803834 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8036f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036ff:	01 d0                	add    %edx,%eax
  803701:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803704:	83 ec 04             	sub    $0x4,%esp
  803707:	6a 01                	push   $0x1
  803709:	ff 75 f0             	pushl  -0x10(%ebp)
  80370c:	ff 75 08             	pushl  0x8(%ebp)
  80370f:	e8 02 ef ff ff       	call   802616 <set_block_data>
  803714:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	83 e8 04             	sub    $0x4,%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	83 e0 fe             	and    $0xfffffffe,%eax
  803722:	89 c2                	mov    %eax,%edx
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	01 d0                	add    %edx,%eax
  803729:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	6a 00                	push   $0x0
  803731:	ff 75 cc             	pushl  -0x34(%ebp)
  803734:	ff 75 c8             	pushl  -0x38(%ebp)
  803737:	e8 da ee ff ff       	call   802616 <set_block_data>
  80373c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80373f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803743:	74 06                	je     80374b <realloc_block_FF+0x142>
  803745:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803749:	75 17                	jne    803762 <realloc_block_FF+0x159>
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	68 84 4a 80 00       	push   $0x804a84
  803753:	68 f6 01 00 00       	push   $0x1f6
  803758:	68 11 4a 80 00       	push   $0x804a11
  80375d:	e8 9e cf ff ff       	call   800700 <_panic>
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	8b 10                	mov    (%eax),%edx
  803767:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80376a:	89 10                	mov    %edx,(%eax)
  80376c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	74 0b                	je     803780 <realloc_block_FF+0x177>
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803783:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80378b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80378e:	89 50 04             	mov    %edx,0x4(%eax)
  803791:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	85 c0                	test   %eax,%eax
  803798:	75 08                	jne    8037a2 <realloc_block_FF+0x199>
  80379a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80379d:	a3 48 50 80 00       	mov    %eax,0x805048
  8037a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b1:	75 17                	jne    8037ca <realloc_block_FF+0x1c1>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 f3 49 80 00       	push   $0x8049f3
  8037bb:	68 f7 01 00 00       	push   $0x1f7
  8037c0:	68 11 4a 80 00       	push   $0x804a11
  8037c5:	e8 36 cf ff ff       	call   800700 <_panic>
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	74 10                	je     8037e3 <realloc_block_FF+0x1da>
  8037d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037db:	8b 52 04             	mov    0x4(%edx),%edx
  8037de:	89 50 04             	mov    %edx,0x4(%eax)
  8037e1:	eb 0b                	jmp    8037ee <realloc_block_FF+0x1e5>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 40 04             	mov    0x4(%eax),%eax
  8037e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8037ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f1:	8b 40 04             	mov    0x4(%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0f                	je     803807 <realloc_block_FF+0x1fe>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803801:	8b 12                	mov    (%edx),%edx
  803803:	89 10                	mov    %edx,(%eax)
  803805:	eb 0a                	jmp    803811 <realloc_block_FF+0x208>
  803807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	a3 44 50 80 00       	mov    %eax,0x805044
  803811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803824:	a1 50 50 80 00       	mov    0x805050,%eax
  803829:	48                   	dec    %eax
  80382a:	a3 50 50 80 00       	mov    %eax,0x805050
  80382f:	e9 83 02 00 00       	jmp    803ab7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803834:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803838:	0f 86 69 02 00 00    	jbe    803aa7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80383e:	83 ec 04             	sub    $0x4,%esp
  803841:	6a 01                	push   $0x1
  803843:	ff 75 f0             	pushl  -0x10(%ebp)
  803846:	ff 75 08             	pushl  0x8(%ebp)
  803849:	e8 c8 ed ff ff       	call   802616 <set_block_data>
  80384e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803851:	8b 45 08             	mov    0x8(%ebp),%eax
  803854:	83 e8 04             	sub    $0x4,%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	83 e0 fe             	and    $0xfffffffe,%eax
  80385c:	89 c2                	mov    %eax,%edx
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	01 d0                	add    %edx,%eax
  803863:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803866:	a1 50 50 80 00       	mov    0x805050,%eax
  80386b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80386e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803872:	75 68                	jne    8038dc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803874:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803878:	75 17                	jne    803891 <realloc_block_FF+0x288>
  80387a:	83 ec 04             	sub    $0x4,%esp
  80387d:	68 2c 4a 80 00       	push   $0x804a2c
  803882:	68 06 02 00 00       	push   $0x206
  803887:	68 11 4a 80 00       	push   $0x804a11
  80388c:	e8 6f ce ff ff       	call   800700 <_panic>
  803891:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389a:	89 10                	mov    %edx,(%eax)
  80389c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389f:	8b 00                	mov    (%eax),%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 0d                	je     8038b2 <realloc_block_FF+0x2a9>
  8038a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8038aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038ad:	89 50 04             	mov    %edx,0x4(%eax)
  8038b0:	eb 08                	jmp    8038ba <realloc_block_FF+0x2b1>
  8038b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b5:	a3 48 50 80 00       	mov    %eax,0x805048
  8038ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8038c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8038d1:	40                   	inc    %eax
  8038d2:	a3 50 50 80 00       	mov    %eax,0x805050
  8038d7:	e9 b0 01 00 00       	jmp    803a8c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8038dc:	a1 44 50 80 00       	mov    0x805044,%eax
  8038e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038e4:	76 68                	jbe    80394e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038ea:	75 17                	jne    803903 <realloc_block_FF+0x2fa>
  8038ec:	83 ec 04             	sub    $0x4,%esp
  8038ef:	68 2c 4a 80 00       	push   $0x804a2c
  8038f4:	68 0b 02 00 00       	push   $0x20b
  8038f9:	68 11 4a 80 00       	push   $0x804a11
  8038fe:	e8 fd cd ff ff       	call   800700 <_panic>
  803903:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390c:	89 10                	mov    %edx,(%eax)
  80390e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	74 0d                	je     803924 <realloc_block_FF+0x31b>
  803917:	a1 44 50 80 00       	mov    0x805044,%eax
  80391c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80391f:	89 50 04             	mov    %edx,0x4(%eax)
  803922:	eb 08                	jmp    80392c <realloc_block_FF+0x323>
  803924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803927:	a3 48 50 80 00       	mov    %eax,0x805048
  80392c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392f:	a3 44 50 80 00       	mov    %eax,0x805044
  803934:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803937:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393e:	a1 50 50 80 00       	mov    0x805050,%eax
  803943:	40                   	inc    %eax
  803944:	a3 50 50 80 00       	mov    %eax,0x805050
  803949:	e9 3e 01 00 00       	jmp    803a8c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80394e:	a1 44 50 80 00       	mov    0x805044,%eax
  803953:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803956:	73 68                	jae    8039c0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803958:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80395c:	75 17                	jne    803975 <realloc_block_FF+0x36c>
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	68 60 4a 80 00       	push   $0x804a60
  803966:	68 10 02 00 00       	push   $0x210
  80396b:	68 11 4a 80 00       	push   $0x804a11
  803970:	e8 8b cd ff ff       	call   800700 <_panic>
  803975:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80397b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397e:	89 50 04             	mov    %edx,0x4(%eax)
  803981:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 0c                	je     803997 <realloc_block_FF+0x38e>
  80398b:	a1 48 50 80 00       	mov    0x805048,%eax
  803990:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803993:	89 10                	mov    %edx,(%eax)
  803995:	eb 08                	jmp    80399f <realloc_block_FF+0x396>
  803997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399a:	a3 44 50 80 00       	mov    %eax,0x805044
  80399f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8039a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8039b5:	40                   	inc    %eax
  8039b6:	a3 50 50 80 00       	mov    %eax,0x805050
  8039bb:	e9 cc 00 00 00       	jmp    803a8c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8039c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8039c7:	a1 44 50 80 00       	mov    0x805044,%eax
  8039cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039cf:	e9 8a 00 00 00       	jmp    803a5e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039da:	73 7a                	jae    803a56 <realloc_block_FF+0x44d>
  8039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039e4:	73 70                	jae    803a56 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8039e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ea:	74 06                	je     8039f2 <realloc_block_FF+0x3e9>
  8039ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039f0:	75 17                	jne    803a09 <realloc_block_FF+0x400>
  8039f2:	83 ec 04             	sub    $0x4,%esp
  8039f5:	68 84 4a 80 00       	push   $0x804a84
  8039fa:	68 1a 02 00 00       	push   $0x21a
  8039ff:	68 11 4a 80 00       	push   $0x804a11
  803a04:	e8 f7 cc ff ff       	call   800700 <_panic>
  803a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0c:	8b 10                	mov    (%eax),%edx
  803a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a11:	89 10                	mov    %edx,(%eax)
  803a13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 0b                	je     803a27 <realloc_block_FF+0x41e>
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a24:	89 50 04             	mov    %edx,0x4(%eax)
  803a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a2d:	89 10                	mov    %edx,(%eax)
  803a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a35:	89 50 04             	mov    %edx,0x4(%eax)
  803a38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	85 c0                	test   %eax,%eax
  803a3f:	75 08                	jne    803a49 <realloc_block_FF+0x440>
  803a41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a44:	a3 48 50 80 00       	mov    %eax,0x805048
  803a49:	a1 50 50 80 00       	mov    0x805050,%eax
  803a4e:	40                   	inc    %eax
  803a4f:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  803a54:	eb 36                	jmp    803a8c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803a56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a62:	74 07                	je     803a6b <realloc_block_FF+0x462>
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	8b 00                	mov    (%eax),%eax
  803a69:	eb 05                	jmp    803a70 <realloc_block_FF+0x467>
  803a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a70:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803a75:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803a7a:	85 c0                	test   %eax,%eax
  803a7c:	0f 85 52 ff ff ff    	jne    8039d4 <realloc_block_FF+0x3cb>
  803a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a86:	0f 85 48 ff ff ff    	jne    8039d4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803a8c:	83 ec 04             	sub    $0x4,%esp
  803a8f:	6a 00                	push   $0x0
  803a91:	ff 75 d8             	pushl  -0x28(%ebp)
  803a94:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a97:	e8 7a eb ff ff       	call   802616 <set_block_data>
  803a9c:	83 c4 10             	add    $0x10,%esp
				return va;
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	e9 7b 02 00 00       	jmp    803d22 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803aa7:	83 ec 0c             	sub    $0xc,%esp
  803aaa:	68 01 4b 80 00       	push   $0x804b01
  803aaf:	e8 09 cf ff ff       	call   8009bd <cprintf>
  803ab4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	e9 63 02 00 00       	jmp    803d22 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ac5:	0f 86 4d 02 00 00    	jbe    803d18 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803acb:	83 ec 0c             	sub    $0xc,%esp
  803ace:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ad1:	e8 08 e8 ff ff       	call   8022de <is_free_block>
  803ad6:	83 c4 10             	add    $0x10,%esp
  803ad9:	84 c0                	test   %al,%al
  803adb:	0f 84 37 02 00 00    	je     803d18 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ae7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803aea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803aed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803af0:	76 38                	jbe    803b2a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803af2:	83 ec 0c             	sub    $0xc,%esp
  803af5:	ff 75 08             	pushl  0x8(%ebp)
  803af8:	e8 0c fa ff ff       	call   803509 <free_block>
  803afd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b00:	83 ec 0c             	sub    $0xc,%esp
  803b03:	ff 75 0c             	pushl  0xc(%ebp)
  803b06:	e8 3a eb ff ff       	call   802645 <alloc_block_FF>
  803b0b:	83 c4 10             	add    $0x10,%esp
  803b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b11:	83 ec 08             	sub    $0x8,%esp
  803b14:	ff 75 c0             	pushl  -0x40(%ebp)
  803b17:	ff 75 08             	pushl  0x8(%ebp)
  803b1a:	e8 ab fa ff ff       	call   8035ca <copy_data>
  803b1f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b22:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b25:	e9 f8 01 00 00       	jmp    803d22 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b2d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803b30:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803b33:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803b37:	0f 87 a0 00 00 00    	ja     803bdd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b41:	75 17                	jne    803b5a <realloc_block_FF+0x551>
  803b43:	83 ec 04             	sub    $0x4,%esp
  803b46:	68 f3 49 80 00       	push   $0x8049f3
  803b4b:	68 38 02 00 00       	push   $0x238
  803b50:	68 11 4a 80 00       	push   $0x804a11
  803b55:	e8 a6 cb ff ff       	call   800700 <_panic>
  803b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 10                	je     803b73 <realloc_block_FF+0x56a>
  803b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b66:	8b 00                	mov    (%eax),%eax
  803b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b6b:	8b 52 04             	mov    0x4(%edx),%edx
  803b6e:	89 50 04             	mov    %edx,0x4(%eax)
  803b71:	eb 0b                	jmp    803b7e <realloc_block_FF+0x575>
  803b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b76:	8b 40 04             	mov    0x4(%eax),%eax
  803b79:	a3 48 50 80 00       	mov    %eax,0x805048
  803b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b81:	8b 40 04             	mov    0x4(%eax),%eax
  803b84:	85 c0                	test   %eax,%eax
  803b86:	74 0f                	je     803b97 <realloc_block_FF+0x58e>
  803b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8b:	8b 40 04             	mov    0x4(%eax),%eax
  803b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b91:	8b 12                	mov    (%edx),%edx
  803b93:	89 10                	mov    %edx,(%eax)
  803b95:	eb 0a                	jmp    803ba1 <realloc_block_FF+0x598>
  803b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9a:	8b 00                	mov    (%eax),%eax
  803b9c:	a3 44 50 80 00       	mov    %eax,0x805044
  803ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb4:	a1 50 50 80 00       	mov    0x805050,%eax
  803bb9:	48                   	dec    %eax
  803bba:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803bbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc5:	01 d0                	add    %edx,%eax
  803bc7:	83 ec 04             	sub    $0x4,%esp
  803bca:	6a 01                	push   $0x1
  803bcc:	50                   	push   %eax
  803bcd:	ff 75 08             	pushl  0x8(%ebp)
  803bd0:	e8 41 ea ff ff       	call   802616 <set_block_data>
  803bd5:	83 c4 10             	add    $0x10,%esp
  803bd8:	e9 36 01 00 00       	jmp    803d13 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803bdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803be0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803be3:	01 d0                	add    %edx,%eax
  803be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803be8:	83 ec 04             	sub    $0x4,%esp
  803beb:	6a 01                	push   $0x1
  803bed:	ff 75 f0             	pushl  -0x10(%ebp)
  803bf0:	ff 75 08             	pushl  0x8(%ebp)
  803bf3:	e8 1e ea ff ff       	call   802616 <set_block_data>
  803bf8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfe:	83 e8 04             	sub    $0x4,%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	83 e0 fe             	and    $0xfffffffe,%eax
  803c06:	89 c2                	mov    %eax,%edx
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0b:	01 d0                	add    %edx,%eax
  803c0d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c14:	74 06                	je     803c1c <realloc_block_FF+0x613>
  803c16:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c1a:	75 17                	jne    803c33 <realloc_block_FF+0x62a>
  803c1c:	83 ec 04             	sub    $0x4,%esp
  803c1f:	68 84 4a 80 00       	push   $0x804a84
  803c24:	68 44 02 00 00       	push   $0x244
  803c29:	68 11 4a 80 00       	push   $0x804a11
  803c2e:	e8 cd ca ff ff       	call   800700 <_panic>
  803c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c36:	8b 10                	mov    (%eax),%edx
  803c38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c3b:	89 10                	mov    %edx,(%eax)
  803c3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c40:	8b 00                	mov    (%eax),%eax
  803c42:	85 c0                	test   %eax,%eax
  803c44:	74 0b                	je     803c51 <realloc_block_FF+0x648>
  803c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c4e:	89 50 04             	mov    %edx,0x4(%eax)
  803c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c54:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c57:	89 10                	mov    %edx,(%eax)
  803c59:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c5f:	89 50 04             	mov    %edx,0x4(%eax)
  803c62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c65:	8b 00                	mov    (%eax),%eax
  803c67:	85 c0                	test   %eax,%eax
  803c69:	75 08                	jne    803c73 <realloc_block_FF+0x66a>
  803c6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c6e:	a3 48 50 80 00       	mov    %eax,0x805048
  803c73:	a1 50 50 80 00       	mov    0x805050,%eax
  803c78:	40                   	inc    %eax
  803c79:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c82:	75 17                	jne    803c9b <realloc_block_FF+0x692>
  803c84:	83 ec 04             	sub    $0x4,%esp
  803c87:	68 f3 49 80 00       	push   $0x8049f3
  803c8c:	68 45 02 00 00       	push   $0x245
  803c91:	68 11 4a 80 00       	push   $0x804a11
  803c96:	e8 65 ca ff ff       	call   800700 <_panic>
  803c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	85 c0                	test   %eax,%eax
  803ca2:	74 10                	je     803cb4 <realloc_block_FF+0x6ab>
  803ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca7:	8b 00                	mov    (%eax),%eax
  803ca9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cac:	8b 52 04             	mov    0x4(%edx),%edx
  803caf:	89 50 04             	mov    %edx,0x4(%eax)
  803cb2:	eb 0b                	jmp    803cbf <realloc_block_FF+0x6b6>
  803cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb7:	8b 40 04             	mov    0x4(%eax),%eax
  803cba:	a3 48 50 80 00       	mov    %eax,0x805048
  803cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc2:	8b 40 04             	mov    0x4(%eax),%eax
  803cc5:	85 c0                	test   %eax,%eax
  803cc7:	74 0f                	je     803cd8 <realloc_block_FF+0x6cf>
  803cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccc:	8b 40 04             	mov    0x4(%eax),%eax
  803ccf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd2:	8b 12                	mov    (%edx),%edx
  803cd4:	89 10                	mov    %edx,(%eax)
  803cd6:	eb 0a                	jmp    803ce2 <realloc_block_FF+0x6d9>
  803cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	a3 44 50 80 00       	mov    %eax,0x805044
  803ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf5:	a1 50 50 80 00       	mov    0x805050,%eax
  803cfa:	48                   	dec    %eax
  803cfb:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803d00:	83 ec 04             	sub    $0x4,%esp
  803d03:	6a 00                	push   $0x0
  803d05:	ff 75 bc             	pushl  -0x44(%ebp)
  803d08:	ff 75 b8             	pushl  -0x48(%ebp)
  803d0b:	e8 06 e9 ff ff       	call   802616 <set_block_data>
  803d10:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d13:	8b 45 08             	mov    0x8(%ebp),%eax
  803d16:	eb 0a                	jmp    803d22 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d18:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d22:	c9                   	leave  
  803d23:	c3                   	ret    

00803d24 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d24:	55                   	push   %ebp
  803d25:	89 e5                	mov    %esp,%ebp
  803d27:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803d2a:	83 ec 04             	sub    $0x4,%esp
  803d2d:	68 08 4b 80 00       	push   $0x804b08
  803d32:	68 58 02 00 00       	push   $0x258
  803d37:	68 11 4a 80 00       	push   $0x804a11
  803d3c:	e8 bf c9 ff ff       	call   800700 <_panic>

00803d41 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803d41:	55                   	push   %ebp
  803d42:	89 e5                	mov    %esp,%ebp
  803d44:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803d47:	83 ec 04             	sub    $0x4,%esp
  803d4a:	68 30 4b 80 00       	push   $0x804b30
  803d4f:	68 61 02 00 00       	push   $0x261
  803d54:	68 11 4a 80 00       	push   $0x804a11
  803d59:	e8 a2 c9 ff ff       	call   800700 <_panic>
  803d5e:	66 90                	xchg   %ax,%ax

00803d60 <__udivdi3>:
  803d60:	55                   	push   %ebp
  803d61:	57                   	push   %edi
  803d62:	56                   	push   %esi
  803d63:	53                   	push   %ebx
  803d64:	83 ec 1c             	sub    $0x1c,%esp
  803d67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d77:	89 ca                	mov    %ecx,%edx
  803d79:	89 f8                	mov    %edi,%eax
  803d7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d7f:	85 f6                	test   %esi,%esi
  803d81:	75 2d                	jne    803db0 <__udivdi3+0x50>
  803d83:	39 cf                	cmp    %ecx,%edi
  803d85:	77 65                	ja     803dec <__udivdi3+0x8c>
  803d87:	89 fd                	mov    %edi,%ebp
  803d89:	85 ff                	test   %edi,%edi
  803d8b:	75 0b                	jne    803d98 <__udivdi3+0x38>
  803d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d92:	31 d2                	xor    %edx,%edx
  803d94:	f7 f7                	div    %edi
  803d96:	89 c5                	mov    %eax,%ebp
  803d98:	31 d2                	xor    %edx,%edx
  803d9a:	89 c8                	mov    %ecx,%eax
  803d9c:	f7 f5                	div    %ebp
  803d9e:	89 c1                	mov    %eax,%ecx
  803da0:	89 d8                	mov    %ebx,%eax
  803da2:	f7 f5                	div    %ebp
  803da4:	89 cf                	mov    %ecx,%edi
  803da6:	89 fa                	mov    %edi,%edx
  803da8:	83 c4 1c             	add    $0x1c,%esp
  803dab:	5b                   	pop    %ebx
  803dac:	5e                   	pop    %esi
  803dad:	5f                   	pop    %edi
  803dae:	5d                   	pop    %ebp
  803daf:	c3                   	ret    
  803db0:	39 ce                	cmp    %ecx,%esi
  803db2:	77 28                	ja     803ddc <__udivdi3+0x7c>
  803db4:	0f bd fe             	bsr    %esi,%edi
  803db7:	83 f7 1f             	xor    $0x1f,%edi
  803dba:	75 40                	jne    803dfc <__udivdi3+0x9c>
  803dbc:	39 ce                	cmp    %ecx,%esi
  803dbe:	72 0a                	jb     803dca <__udivdi3+0x6a>
  803dc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dc4:	0f 87 9e 00 00 00    	ja     803e68 <__udivdi3+0x108>
  803dca:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcf:	89 fa                	mov    %edi,%edx
  803dd1:	83 c4 1c             	add    $0x1c,%esp
  803dd4:	5b                   	pop    %ebx
  803dd5:	5e                   	pop    %esi
  803dd6:	5f                   	pop    %edi
  803dd7:	5d                   	pop    %ebp
  803dd8:	c3                   	ret    
  803dd9:	8d 76 00             	lea    0x0(%esi),%esi
  803ddc:	31 ff                	xor    %edi,%edi
  803dde:	31 c0                	xor    %eax,%eax
  803de0:	89 fa                	mov    %edi,%edx
  803de2:	83 c4 1c             	add    $0x1c,%esp
  803de5:	5b                   	pop    %ebx
  803de6:	5e                   	pop    %esi
  803de7:	5f                   	pop    %edi
  803de8:	5d                   	pop    %ebp
  803de9:	c3                   	ret    
  803dea:	66 90                	xchg   %ax,%ax
  803dec:	89 d8                	mov    %ebx,%eax
  803dee:	f7 f7                	div    %edi
  803df0:	31 ff                	xor    %edi,%edi
  803df2:	89 fa                	mov    %edi,%edx
  803df4:	83 c4 1c             	add    $0x1c,%esp
  803df7:	5b                   	pop    %ebx
  803df8:	5e                   	pop    %esi
  803df9:	5f                   	pop    %edi
  803dfa:	5d                   	pop    %ebp
  803dfb:	c3                   	ret    
  803dfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e01:	89 eb                	mov    %ebp,%ebx
  803e03:	29 fb                	sub    %edi,%ebx
  803e05:	89 f9                	mov    %edi,%ecx
  803e07:	d3 e6                	shl    %cl,%esi
  803e09:	89 c5                	mov    %eax,%ebp
  803e0b:	88 d9                	mov    %bl,%cl
  803e0d:	d3 ed                	shr    %cl,%ebp
  803e0f:	89 e9                	mov    %ebp,%ecx
  803e11:	09 f1                	or     %esi,%ecx
  803e13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e17:	89 f9                	mov    %edi,%ecx
  803e19:	d3 e0                	shl    %cl,%eax
  803e1b:	89 c5                	mov    %eax,%ebp
  803e1d:	89 d6                	mov    %edx,%esi
  803e1f:	88 d9                	mov    %bl,%cl
  803e21:	d3 ee                	shr    %cl,%esi
  803e23:	89 f9                	mov    %edi,%ecx
  803e25:	d3 e2                	shl    %cl,%edx
  803e27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e2b:	88 d9                	mov    %bl,%cl
  803e2d:	d3 e8                	shr    %cl,%eax
  803e2f:	09 c2                	or     %eax,%edx
  803e31:	89 d0                	mov    %edx,%eax
  803e33:	89 f2                	mov    %esi,%edx
  803e35:	f7 74 24 0c          	divl   0xc(%esp)
  803e39:	89 d6                	mov    %edx,%esi
  803e3b:	89 c3                	mov    %eax,%ebx
  803e3d:	f7 e5                	mul    %ebp
  803e3f:	39 d6                	cmp    %edx,%esi
  803e41:	72 19                	jb     803e5c <__udivdi3+0xfc>
  803e43:	74 0b                	je     803e50 <__udivdi3+0xf0>
  803e45:	89 d8                	mov    %ebx,%eax
  803e47:	31 ff                	xor    %edi,%edi
  803e49:	e9 58 ff ff ff       	jmp    803da6 <__udivdi3+0x46>
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e54:	89 f9                	mov    %edi,%ecx
  803e56:	d3 e2                	shl    %cl,%edx
  803e58:	39 c2                	cmp    %eax,%edx
  803e5a:	73 e9                	jae    803e45 <__udivdi3+0xe5>
  803e5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e5f:	31 ff                	xor    %edi,%edi
  803e61:	e9 40 ff ff ff       	jmp    803da6 <__udivdi3+0x46>
  803e66:	66 90                	xchg   %ax,%ax
  803e68:	31 c0                	xor    %eax,%eax
  803e6a:	e9 37 ff ff ff       	jmp    803da6 <__udivdi3+0x46>
  803e6f:	90                   	nop

00803e70 <__umoddi3>:
  803e70:	55                   	push   %ebp
  803e71:	57                   	push   %edi
  803e72:	56                   	push   %esi
  803e73:	53                   	push   %ebx
  803e74:	83 ec 1c             	sub    $0x1c,%esp
  803e77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e8f:	89 f3                	mov    %esi,%ebx
  803e91:	89 fa                	mov    %edi,%edx
  803e93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e97:	89 34 24             	mov    %esi,(%esp)
  803e9a:	85 c0                	test   %eax,%eax
  803e9c:	75 1a                	jne    803eb8 <__umoddi3+0x48>
  803e9e:	39 f7                	cmp    %esi,%edi
  803ea0:	0f 86 a2 00 00 00    	jbe    803f48 <__umoddi3+0xd8>
  803ea6:	89 c8                	mov    %ecx,%eax
  803ea8:	89 f2                	mov    %esi,%edx
  803eaa:	f7 f7                	div    %edi
  803eac:	89 d0                	mov    %edx,%eax
  803eae:	31 d2                	xor    %edx,%edx
  803eb0:	83 c4 1c             	add    $0x1c,%esp
  803eb3:	5b                   	pop    %ebx
  803eb4:	5e                   	pop    %esi
  803eb5:	5f                   	pop    %edi
  803eb6:	5d                   	pop    %ebp
  803eb7:	c3                   	ret    
  803eb8:	39 f0                	cmp    %esi,%eax
  803eba:	0f 87 ac 00 00 00    	ja     803f6c <__umoddi3+0xfc>
  803ec0:	0f bd e8             	bsr    %eax,%ebp
  803ec3:	83 f5 1f             	xor    $0x1f,%ebp
  803ec6:	0f 84 ac 00 00 00    	je     803f78 <__umoddi3+0x108>
  803ecc:	bf 20 00 00 00       	mov    $0x20,%edi
  803ed1:	29 ef                	sub    %ebp,%edi
  803ed3:	89 fe                	mov    %edi,%esi
  803ed5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ed9:	89 e9                	mov    %ebp,%ecx
  803edb:	d3 e0                	shl    %cl,%eax
  803edd:	89 d7                	mov    %edx,%edi
  803edf:	89 f1                	mov    %esi,%ecx
  803ee1:	d3 ef                	shr    %cl,%edi
  803ee3:	09 c7                	or     %eax,%edi
  803ee5:	89 e9                	mov    %ebp,%ecx
  803ee7:	d3 e2                	shl    %cl,%edx
  803ee9:	89 14 24             	mov    %edx,(%esp)
  803eec:	89 d8                	mov    %ebx,%eax
  803eee:	d3 e0                	shl    %cl,%eax
  803ef0:	89 c2                	mov    %eax,%edx
  803ef2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ef6:	d3 e0                	shl    %cl,%eax
  803ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803efc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f00:	89 f1                	mov    %esi,%ecx
  803f02:	d3 e8                	shr    %cl,%eax
  803f04:	09 d0                	or     %edx,%eax
  803f06:	d3 eb                	shr    %cl,%ebx
  803f08:	89 da                	mov    %ebx,%edx
  803f0a:	f7 f7                	div    %edi
  803f0c:	89 d3                	mov    %edx,%ebx
  803f0e:	f7 24 24             	mull   (%esp)
  803f11:	89 c6                	mov    %eax,%esi
  803f13:	89 d1                	mov    %edx,%ecx
  803f15:	39 d3                	cmp    %edx,%ebx
  803f17:	0f 82 87 00 00 00    	jb     803fa4 <__umoddi3+0x134>
  803f1d:	0f 84 91 00 00 00    	je     803fb4 <__umoddi3+0x144>
  803f23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f27:	29 f2                	sub    %esi,%edx
  803f29:	19 cb                	sbb    %ecx,%ebx
  803f2b:	89 d8                	mov    %ebx,%eax
  803f2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f31:	d3 e0                	shl    %cl,%eax
  803f33:	89 e9                	mov    %ebp,%ecx
  803f35:	d3 ea                	shr    %cl,%edx
  803f37:	09 d0                	or     %edx,%eax
  803f39:	89 e9                	mov    %ebp,%ecx
  803f3b:	d3 eb                	shr    %cl,%ebx
  803f3d:	89 da                	mov    %ebx,%edx
  803f3f:	83 c4 1c             	add    $0x1c,%esp
  803f42:	5b                   	pop    %ebx
  803f43:	5e                   	pop    %esi
  803f44:	5f                   	pop    %edi
  803f45:	5d                   	pop    %ebp
  803f46:	c3                   	ret    
  803f47:	90                   	nop
  803f48:	89 fd                	mov    %edi,%ebp
  803f4a:	85 ff                	test   %edi,%edi
  803f4c:	75 0b                	jne    803f59 <__umoddi3+0xe9>
  803f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f53:	31 d2                	xor    %edx,%edx
  803f55:	f7 f7                	div    %edi
  803f57:	89 c5                	mov    %eax,%ebp
  803f59:	89 f0                	mov    %esi,%eax
  803f5b:	31 d2                	xor    %edx,%edx
  803f5d:	f7 f5                	div    %ebp
  803f5f:	89 c8                	mov    %ecx,%eax
  803f61:	f7 f5                	div    %ebp
  803f63:	89 d0                	mov    %edx,%eax
  803f65:	e9 44 ff ff ff       	jmp    803eae <__umoddi3+0x3e>
  803f6a:	66 90                	xchg   %ax,%ax
  803f6c:	89 c8                	mov    %ecx,%eax
  803f6e:	89 f2                	mov    %esi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	3b 04 24             	cmp    (%esp),%eax
  803f7b:	72 06                	jb     803f83 <__umoddi3+0x113>
  803f7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f81:	77 0f                	ja     803f92 <__umoddi3+0x122>
  803f83:	89 f2                	mov    %esi,%edx
  803f85:	29 f9                	sub    %edi,%ecx
  803f87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f8b:	89 14 24             	mov    %edx,(%esp)
  803f8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f96:	8b 14 24             	mov    (%esp),%edx
  803f99:	83 c4 1c             	add    $0x1c,%esp
  803f9c:	5b                   	pop    %ebx
  803f9d:	5e                   	pop    %esi
  803f9e:	5f                   	pop    %edi
  803f9f:	5d                   	pop    %ebp
  803fa0:	c3                   	ret    
  803fa1:	8d 76 00             	lea    0x0(%esi),%esi
  803fa4:	2b 04 24             	sub    (%esp),%eax
  803fa7:	19 fa                	sbb    %edi,%edx
  803fa9:	89 d1                	mov    %edx,%ecx
  803fab:	89 c6                	mov    %eax,%esi
  803fad:	e9 71 ff ff ff       	jmp    803f23 <__umoddi3+0xb3>
  803fb2:	66 90                	xchg   %ax,%ax
  803fb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fb8:	72 ea                	jb     803fa4 <__umoddi3+0x134>
  803fba:	89 d9                	mov    %ebx,%ecx
  803fbc:	e9 62 ff ff ff       	jmp    803f23 <__umoddi3+0xb3>
