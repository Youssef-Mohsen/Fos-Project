
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
  800055:	68 60 3f 80 00       	push   $0x803f60
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
  8000a5:	68 90 3f 80 00       	push   $0x803f90
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
  8000e7:	68 c9 3f 80 00       	push   $0x803fc9
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 e5 3f 80 00       	push   $0x803fe5
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
  800114:	e8 71 1c 00 00       	call   801d8a <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 1e 1c 00 00       	call   801d3f <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 fc 3f 80 00       	push   $0x803ffc
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
  8002a0:	68 58 40 80 00       	push   $0x804058
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
  80030a:	68 7c 40 80 00       	push   $0x80407c
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
  800370:	68 b8 40 80 00       	push   $0x8040b8
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
  800397:	68 08 41 80 00       	push   $0x804108
  80039c:	e8 1c 06 00 00       	call   8009bd <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 da 19 00 00       	call   801d8a <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 48 41 80 00       	push   $0x804148
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
  80047b:	68 84 41 80 00       	push   $0x804184
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
  8004a8:	e8 92 18 00 00       	call   801d3f <sys_calculate_free_frames>
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
  8004d4:	68 c8 41 80 00       	push   $0x8041c8
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
  8004f5:	68 14 42 80 00       	push   $0x804214
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
  800570:	e8 25 1c 00 00       	call   80219a <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 38 42 80 00       	push   $0x804238
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
  8005ae:	68 5c 42 80 00       	push   $0x80425c
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
  8005c7:	e8 3c 19 00 00       	call   801f08 <sys_getenvindex>
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
  800635:	e8 52 16 00 00       	call   801c8c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	68 bc 42 80 00       	push   $0x8042bc
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
  800665:	68 e4 42 80 00       	push   $0x8042e4
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
  800696:	68 0c 43 80 00       	push   $0x80430c
  80069b:	e8 1d 03 00 00       	call   8009bd <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	50                   	push   %eax
  8006b2:	68 64 43 80 00       	push   $0x804364
  8006b7:	e8 01 03 00 00       	call   8009bd <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 bc 42 80 00       	push   $0x8042bc
  8006c7:	e8 f1 02 00 00       	call   8009bd <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006cf:	e8 d2 15 00 00       	call   801ca6 <sys_unlock_cons>
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
  8006e7:	e8 e8 17 00 00       	call   801ed4 <sys_destroy_env>
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
  8006f8:	e8 3d 18 00 00       	call   801f3a <sys_exit_env>
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
  800721:	68 78 43 80 00       	push   $0x804378
  800726:	e8 92 02 00 00       	call   8009bd <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80072e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	50                   	push   %eax
  80073a:	68 7d 43 80 00       	push   $0x80437d
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
  80075e:	68 99 43 80 00       	push   $0x804399
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
  80078d:	68 9c 43 80 00       	push   $0x80439c
  800792:	6a 26                	push   $0x26
  800794:	68 e8 43 80 00       	push   $0x8043e8
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
  800862:	68 f4 43 80 00       	push   $0x8043f4
  800867:	6a 3a                	push   $0x3a
  800869:	68 e8 43 80 00       	push   $0x8043e8
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
  8008d5:	68 48 44 80 00       	push   $0x804448
  8008da:	6a 44                	push   $0x44
  8008dc:	68 e8 43 80 00       	push   $0x8043e8
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
  80092f:	e8 16 13 00 00       	call   801c4a <sys_cputs>
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
  8009a6:	e8 9f 12 00 00       	call   801c4a <sys_cputs>
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
  8009f0:	e8 97 12 00 00       	call   801c8c <sys_lock_cons>
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
  800a10:	e8 91 12 00 00       	call   801ca6 <sys_unlock_cons>
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
  800a5a:	e8 85 32 00 00       	call   803ce4 <__udivdi3>
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
  800aaa:	e8 45 33 00 00       	call   803df4 <__umoddi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	05 b4 46 80 00       	add    $0x8046b4,%eax
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
  800c05:	8b 04 85 d8 46 80 00 	mov    0x8046d8(,%eax,4),%eax
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
  800ce6:	8b 34 9d 20 45 80 00 	mov    0x804520(,%ebx,4),%esi
  800ced:	85 f6                	test   %esi,%esi
  800cef:	75 19                	jne    800d0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf1:	53                   	push   %ebx
  800cf2:	68 c5 46 80 00       	push   $0x8046c5
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
  800d0b:	68 ce 46 80 00       	push   $0x8046ce
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
  800d38:	be d1 46 80 00       	mov    $0x8046d1,%esi
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
  801743:	68 48 48 80 00       	push   $0x804848
  801748:	68 3f 01 00 00       	push   $0x13f
  80174d:	68 6a 48 80 00       	push   $0x80486a
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
  801763:	e8 8d 0a 00 00       	call   8021f5 <sys_sbrk>
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
  8017de:	e8 96 08 00 00       	call   802079 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 16                	je     8017fd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 d6 0d 00 00       	call   8025c8 <alloc_block_FF>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	e9 8a 01 00 00       	jmp    801987 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8017fd:	e8 a8 08 00 00       	call   8020aa <sys_isUHeapPlacementStrategyBESTFIT>
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 84 7d 01 00 00    	je     801987 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 6f 12 00 00       	call   802a84 <alloc_block_BF>
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
  801860:	8b 04 85 60 92 80 00 	mov    0x809260(,%eax,4),%eax
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
  8018ad:	8b 04 85 60 92 80 00 	mov    0x809260(,%eax,4),%eax
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
  801904:	c7 04 85 60 92 80 00 	movl   $0x1,0x809260(,%eax,4)
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
  801966:	89 04 95 60 92 88 00 	mov    %eax,0x889260(,%edx,4)
		sys_allocate_user_mem(i, size);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	ff 75 f0             	pushl  -0x10(%ebp)
  801976:	e8 b1 08 00 00       	call   80222c <sys_allocate_user_mem>
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
  8019be:	e8 85 08 00 00       	call   802248 <get_block_size>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 b8 1a 00 00       	call   80348c <free_block>
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
  801a09:	8b 04 85 60 92 88 00 	mov    0x889260(,%eax,4),%eax
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
  801a46:	c7 04 85 60 92 80 00 	movl   $0x0,0x809260(,%eax,4)
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
  801a66:	e8 a5 07 00 00       	call   802210 <sys_free_user_mem>
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
  801a74:	68 78 48 80 00       	push   $0x804878
  801a79:	68 84 00 00 00       	push   $0x84
  801a7e:	68 a2 48 80 00       	push   $0x8048a2
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
  801a9a:	75 07                	jne    801aa3 <smalloc+0x19>
  801a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa1:	eb 64                	jmp    801b07 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab6:	39 d0                	cmp    %edx,%eax
  801ab8:	73 02                	jae    801abc <smalloc+0x32>
  801aba:	89 d0                	mov    %edx,%eax
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	50                   	push   %eax
  801ac0:	e8 a8 fc ff ff       	call   80176d <malloc>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801acb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801acf:	75 07                	jne    801ad8 <smalloc+0x4e>
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad6:	eb 2f                	jmp    801b07 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801ad8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801adc:	ff 75 ec             	pushl  -0x14(%ebp)
  801adf:	50                   	push   %eax
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	e8 2c 03 00 00       	call   801e17 <sys_createSharedObject>
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801af1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801af5:	74 06                	je     801afd <smalloc+0x73>
  801af7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801afb:	75 07                	jne    801b04 <smalloc+0x7a>
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	eb 03                	jmp    801b07 <smalloc+0x7d>
	 return ptr;
  801b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	e8 24 03 00 00       	call   801e41 <sys_getSizeOfSharedObject>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801b23:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b27:	75 07                	jne    801b30 <sget+0x27>
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2e:	eb 5c                	jmp    801b8c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b36:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	39 d0                	cmp    %edx,%eax
  801b45:	7d 02                	jge    801b49 <sget+0x40>
  801b47:	89 d0                	mov    %edx,%eax
  801b49:	83 ec 0c             	sub    $0xc,%esp
  801b4c:	50                   	push   %eax
  801b4d:	e8 1b fc ff ff       	call   80176d <malloc>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801b58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b5c:	75 07                	jne    801b65 <sget+0x5c>
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	eb 27                	jmp    801b8c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	ff 75 e8             	pushl  -0x18(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	e8 e8 02 00 00       	call   801e5e <sys_getSharedObject>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801b7c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801b80:	75 07                	jne    801b89 <sget+0x80>
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
  801b87:	eb 03                	jmp    801b8c <sget+0x83>
	return ptr;
  801b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	68 b0 48 80 00       	push   $0x8048b0
  801b9c:	68 c1 00 00 00       	push   $0xc1
  801ba1:	68 a2 48 80 00       	push   $0x8048a2
  801ba6:	e8 55 eb ff ff       	call   800700 <_panic>

00801bab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	68 d4 48 80 00       	push   $0x8048d4
  801bb9:	68 d8 00 00 00       	push   $0xd8
  801bbe:	68 a2 48 80 00       	push   $0x8048a2
  801bc3:	e8 38 eb ff ff       	call   800700 <_panic>

00801bc8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	68 fa 48 80 00       	push   $0x8048fa
  801bd6:	68 e4 00 00 00       	push   $0xe4
  801bdb:	68 a2 48 80 00       	push   $0x8048a2
  801be0:	e8 1b eb ff ff       	call   800700 <_panic>

00801be5 <shrink>:

}
void shrink(uint32 newSize)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 fa 48 80 00       	push   $0x8048fa
  801bf3:	68 e9 00 00 00       	push   $0xe9
  801bf8:	68 a2 48 80 00       	push   $0x8048a2
  801bfd:	e8 fe ea ff ff       	call   800700 <_panic>

00801c02 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	68 fa 48 80 00       	push   $0x8048fa
  801c10:	68 ee 00 00 00       	push   $0xee
  801c15:	68 a2 48 80 00       	push   $0x8048a2
  801c1a:	e8 e1 ea ff ff       	call   800700 <_panic>

00801c1f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	57                   	push   %edi
  801c23:	56                   	push   %esi
  801c24:	53                   	push   %ebx
  801c25:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c34:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c37:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c3a:	cd 30                	int    $0x30
  801c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5f                   	pop    %edi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	8b 45 10             	mov    0x10(%ebp),%eax
  801c53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	52                   	push   %edx
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	6a 00                	push   $0x0
  801c68:	e8 b2 ff ff ff       	call   801c1f <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 02                	push   $0x2
  801c82:	e8 98 ff ff ff       	call   801c1f <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 03                	push   $0x3
  801c9b:	e8 7f ff ff ff       	call   801c1f <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	90                   	nop
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 04                	push   $0x4
  801cb5:	e8 65 ff ff ff       	call   801c1f <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 08                	push   $0x8
  801cd3:	e8 47 ff ff ff       	call   801c1f <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	56                   	push   %esi
  801ce1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ce2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ce5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	56                   	push   %esi
  801cf2:	53                   	push   %ebx
  801cf3:	51                   	push   %ecx
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 09                	push   $0x9
  801cf8:	e8 22 ff ff ff       	call   801c1f <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    

00801d07 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 0a                	push   $0xa
  801d1a:	e8 00 ff ff ff       	call   801c1f <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	6a 0b                	push   $0xb
  801d35:	e8 e5 fe ff ff       	call   801c1f <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 0c                	push   $0xc
  801d4e:	e8 cc fe ff ff       	call   801c1f <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 0d                	push   $0xd
  801d67:	e8 b3 fe ff ff       	call   801c1f <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 0e                	push   $0xe
  801d80:	e8 9a fe ff ff       	call   801c1f <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 0f                	push   $0xf
  801d99:	e8 81 fe ff ff       	call   801c1f <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 10                	push   $0x10
  801db3:	e8 67 fe ff ff       	call   801c1f <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 11                	push   $0x11
  801dcc:	e8 4e fe ff ff       	call   801c1f <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	90                   	nop
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801de3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	50                   	push   %eax
  801df0:	6a 01                	push   $0x1
  801df2:	e8 28 fe ff ff       	call   801c1f <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	90                   	nop
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 14                	push   $0x14
  801e0c:	e8 0e fe ff ff       	call   801c1f <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e20:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	51                   	push   %ecx
  801e30:	52                   	push   %edx
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	50                   	push   %eax
  801e35:	6a 15                	push   $0x15
  801e37:	e8 e3 fd ff ff       	call   801c1f <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	52                   	push   %edx
  801e51:	50                   	push   %eax
  801e52:	6a 16                	push   $0x16
  801e54:	e8 c6 fd ff ff       	call   801c1f <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	51                   	push   %ecx
  801e6f:	52                   	push   %edx
  801e70:	50                   	push   %eax
  801e71:	6a 17                	push   $0x17
  801e73:	e8 a7 fd ff ff       	call   801c1f <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	52                   	push   %edx
  801e8d:	50                   	push   %eax
  801e8e:	6a 18                	push   $0x18
  801e90:	e8 8a fd ff ff       	call   801c1f <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 14             	pushl  0x14(%ebp)
  801ea5:	ff 75 10             	pushl  0x10(%ebp)
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	50                   	push   %eax
  801eac:	6a 19                	push   $0x19
  801eae:	e8 6c fd ff ff       	call   801c1f <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	50                   	push   %eax
  801ec7:	6a 1a                	push   $0x1a
  801ec9:	e8 51 fd ff ff       	call   801c1f <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
}
  801ed1:	90                   	nop
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	50                   	push   %eax
  801ee3:	6a 1b                	push   $0x1b
  801ee5:	e8 35 fd ff ff       	call   801c1f <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 05                	push   $0x5
  801efe:	e8 1c fd ff ff       	call   801c1f <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 06                	push   $0x6
  801f17:	e8 03 fd ff ff       	call   801c1f <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 07                	push   $0x7
  801f30:	e8 ea fc ff ff       	call   801c1f <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_exit_env>:


void sys_exit_env(void)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 1c                	push   $0x1c
  801f49:	e8 d1 fc ff ff       	call   801c1f <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	90                   	nop
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f5d:	8d 50 04             	lea    0x4(%eax),%edx
  801f60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 1d                	push   $0x1d
  801f6d:	e8 ad fc ff ff       	call   801c1f <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
	return result;
  801f75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f7e:	89 01                	mov    %eax,(%ecx)
  801f80:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	c9                   	leave  
  801f87:	c2 04 00             	ret    $0x4

00801f8a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	ff 75 10             	pushl  0x10(%ebp)
  801f94:	ff 75 0c             	pushl  0xc(%ebp)
  801f97:	ff 75 08             	pushl  0x8(%ebp)
  801f9a:	6a 13                	push   $0x13
  801f9c:	e8 7e fc ff ff       	call   801c1f <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa4:	90                   	nop
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 1e                	push   $0x1e
  801fb6:	e8 64 fc ff ff       	call   801c1f <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fcc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	50                   	push   %eax
  801fd9:	6a 1f                	push   $0x1f
  801fdb:	e8 3f fc ff ff       	call   801c1f <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe3:	90                   	nop
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <rsttst>:
void rsttst()
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 21                	push   $0x21
  801ff5:	e8 25 fc ff ff       	call   801c1f <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffd:	90                   	nop
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	8b 45 14             	mov    0x14(%ebp),%eax
  802009:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80200c:	8b 55 18             	mov    0x18(%ebp),%edx
  80200f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802013:	52                   	push   %edx
  802014:	50                   	push   %eax
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	ff 75 08             	pushl  0x8(%ebp)
  80201e:	6a 20                	push   $0x20
  802020:	e8 fa fb ff ff       	call   801c1f <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
	return ;
  802028:	90                   	nop
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <chktst>:
void chktst(uint32 n)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	ff 75 08             	pushl  0x8(%ebp)
  802039:	6a 22                	push   $0x22
  80203b:	e8 df fb ff ff       	call   801c1f <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
	return ;
  802043:	90                   	nop
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <inctst>:

void inctst()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 23                	push   $0x23
  802055:	e8 c5 fb ff ff       	call   801c1f <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
	return ;
  80205d:	90                   	nop
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <gettst>:
uint32 gettst()
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 24                	push   $0x24
  80206f:	e8 ab fb ff ff       	call   801c1f <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 25                	push   $0x25
  80208b:	e8 8f fb ff ff       	call   801c1f <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
  802093:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802096:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80209a:	75 07                	jne    8020a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80209c:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a1:	eb 05                	jmp    8020a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 25                	push   $0x25
  8020bc:	e8 5e fb ff ff       	call   801c1f <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
  8020c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020cb:	75 07                	jne    8020d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d2:	eb 05                	jmp    8020d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 25                	push   $0x25
  8020ed:	e8 2d fb ff ff       	call   801c1f <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
  8020f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020fc:	75 07                	jne    802105 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	eb 05                	jmp    80210a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 25                	push   $0x25
  80211e:	e8 fc fa ff ff       	call   801c1f <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
  802126:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802129:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80212d:	75 07                	jne    802136 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80212f:	b8 01 00 00 00       	mov    $0x1,%eax
  802134:	eb 05                	jmp    80213b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	6a 26                	push   $0x26
  80214d:	e8 cd fa ff ff       	call   801c1f <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
	return ;
  802155:	90                   	nop
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80215c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802162:	8b 55 0c             	mov    0xc(%ebp),%edx
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	6a 00                	push   $0x0
  80216a:	53                   	push   %ebx
  80216b:	51                   	push   %ecx
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	6a 27                	push   $0x27
  802170:	e8 aa fa ff ff       	call   801c1f <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802180:	8b 55 0c             	mov    0xc(%ebp),%edx
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	52                   	push   %edx
  80218d:	50                   	push   %eax
  80218e:	6a 28                	push   $0x28
  802190:	e8 8a fa ff ff       	call   801c1f <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80219d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	51                   	push   %ecx
  8021a9:	ff 75 10             	pushl  0x10(%ebp)
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 29                	push   $0x29
  8021b0:	e8 6a fa ff ff       	call   801c1f <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	ff 75 10             	pushl  0x10(%ebp)
  8021c4:	ff 75 0c             	pushl  0xc(%ebp)
  8021c7:	ff 75 08             	pushl  0x8(%ebp)
  8021ca:	6a 12                	push   $0x12
  8021cc:	e8 4e fa ff ff       	call   801c1f <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d4:	90                   	nop
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	52                   	push   %edx
  8021e7:	50                   	push   %eax
  8021e8:	6a 2a                	push   $0x2a
  8021ea:	e8 30 fa ff ff       	call   801c1f <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
	return;
  8021f2:	90                   	nop
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	50                   	push   %eax
  802204:	6a 2b                	push   $0x2b
  802206:	e8 14 fa ff ff       	call   801c1f <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 2c                	push   $0x2c
  802221:	e8 f9 f9 ff ff       	call   801c1f <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	ff 75 0c             	pushl  0xc(%ebp)
  802238:	ff 75 08             	pushl  0x8(%ebp)
  80223b:	6a 2d                	push   $0x2d
  80223d:	e8 dd f9 ff ff       	call   801c1f <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
	return;
  802245:	90                   	nop
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	83 e8 04             	sub    $0x4,%eax
  802254:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802257:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	83 e8 04             	sub    $0x4,%eax
  80226d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	83 e0 01             	and    $0x1,%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	0f 94 c0             	sete   %al
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	83 f8 02             	cmp    $0x2,%eax
  802292:	74 2b                	je     8022bf <alloc_block+0x40>
  802294:	83 f8 02             	cmp    $0x2,%eax
  802297:	7f 07                	jg     8022a0 <alloc_block+0x21>
  802299:	83 f8 01             	cmp    $0x1,%eax
  80229c:	74 0e                	je     8022ac <alloc_block+0x2d>
  80229e:	eb 58                	jmp    8022f8 <alloc_block+0x79>
  8022a0:	83 f8 03             	cmp    $0x3,%eax
  8022a3:	74 2d                	je     8022d2 <alloc_block+0x53>
  8022a5:	83 f8 04             	cmp    $0x4,%eax
  8022a8:	74 3b                	je     8022e5 <alloc_block+0x66>
  8022aa:	eb 4c                	jmp    8022f8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	ff 75 08             	pushl  0x8(%ebp)
  8022b2:	e8 11 03 00 00       	call   8025c8 <alloc_block_FF>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022bd:	eb 4a                	jmp    802309 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8022bf:	83 ec 0c             	sub    $0xc,%esp
  8022c2:	ff 75 08             	pushl  0x8(%ebp)
  8022c5:	e8 fa 19 00 00       	call   803cc4 <alloc_block_NF>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022d0:	eb 37                	jmp    802309 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	e8 a7 07 00 00       	call   802a84 <alloc_block_BF>
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022e3:	eb 24                	jmp    802309 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 08             	pushl  0x8(%ebp)
  8022eb:	e8 b7 19 00 00       	call   803ca7 <alloc_block_WF>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022f6:	eb 11                	jmp    802309 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022f8:	83 ec 0c             	sub    $0xc,%esp
  8022fb:	68 0c 49 80 00       	push   $0x80490c
  802300:	e8 b8 e6 ff ff       	call   8009bd <cprintf>
  802305:	83 c4 10             	add    $0x10,%esp
		break;
  802308:	90                   	nop
	}
	return va;
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	53                   	push   %ebx
  802312:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	68 2c 49 80 00       	push   $0x80492c
  80231d:	e8 9b e6 ff ff       	call   8009bd <cprintf>
  802322:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802325:	83 ec 0c             	sub    $0xc,%esp
  802328:	68 57 49 80 00       	push   $0x804957
  80232d:	e8 8b e6 ff ff       	call   8009bd <cprintf>
  802332:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233b:	eb 37                	jmp    802374 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80233d:	83 ec 0c             	sub    $0xc,%esp
  802340:	ff 75 f4             	pushl  -0xc(%ebp)
  802343:	e8 19 ff ff ff       	call   802261 <is_free_block>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	0f be d8             	movsbl %al,%ebx
  80234e:	83 ec 0c             	sub    $0xc,%esp
  802351:	ff 75 f4             	pushl  -0xc(%ebp)
  802354:	e8 ef fe ff ff       	call   802248 <get_block_size>
  802359:	83 c4 10             	add    $0x10,%esp
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	53                   	push   %ebx
  802360:	50                   	push   %eax
  802361:	68 6f 49 80 00       	push   $0x80496f
  802366:	e8 52 e6 ff ff       	call   8009bd <cprintf>
  80236b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80236e:	8b 45 10             	mov    0x10(%ebp),%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802378:	74 07                	je     802381 <print_blocks_list+0x73>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 00                	mov    (%eax),%eax
  80237f:	eb 05                	jmp    802386 <print_blocks_list+0x78>
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	89 45 10             	mov    %eax,0x10(%ebp)
  802389:	8b 45 10             	mov    0x10(%ebp),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 ad                	jne    80233d <print_blocks_list+0x2f>
  802390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802394:	75 a7                	jne    80233d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	68 2c 49 80 00       	push   $0x80492c
  80239e:	e8 1a e6 ff ff       	call   8009bd <cprintf>
  8023a3:	83 c4 10             	add    $0x10,%esp

}
  8023a6:	90                   	nop
  8023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8023b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b5:	83 e0 01             	and    $0x1,%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	74 03                	je     8023bf <initialize_dynamic_allocator+0x13>
  8023bc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8023bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c3:	0f 84 c7 01 00 00    	je     802590 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8023c9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8023d0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8023d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d9:	01 d0                	add    %edx,%eax
  8023db:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8023e0:	0f 87 ad 01 00 00    	ja     802593 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	0f 89 a5 01 00 00    	jns    802596 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	83 e8 04             	sub    $0x4,%eax
  8023fc:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  802401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802408:	a1 44 50 80 00       	mov    0x805044,%eax
  80240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802410:	e9 87 00 00 00       	jmp    80249c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	75 14                	jne    80242f <initialize_dynamic_allocator+0x83>
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 87 49 80 00       	push   $0x804987
  802423:	6a 79                	push   $0x79
  802425:	68 a5 49 80 00       	push   $0x8049a5
  80242a:	e8 d1 e2 ff ff       	call   800700 <_panic>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	74 10                	je     802448 <initialize_dynamic_allocator+0x9c>
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	8b 52 04             	mov    0x4(%edx),%edx
  802443:	89 50 04             	mov    %edx,0x4(%eax)
  802446:	eb 0b                	jmp    802453 <initialize_dynamic_allocator+0xa7>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	a3 48 50 80 00       	mov    %eax,0x805048
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 04             	mov    0x4(%eax),%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 0f                	je     80246c <initialize_dynamic_allocator+0xc0>
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 04             	mov    0x4(%eax),%eax
  802463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802466:	8b 12                	mov    (%edx),%edx
  802468:	89 10                	mov    %edx,(%eax)
  80246a:	eb 0a                	jmp    802476 <initialize_dynamic_allocator+0xca>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	a3 44 50 80 00       	mov    %eax,0x805044
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802489:	a1 50 50 80 00       	mov    0x805050,%eax
  80248e:	48                   	dec    %eax
  80248f:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802494:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a0:	74 07                	je     8024a9 <initialize_dynamic_allocator+0xfd>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	eb 05                	jmp    8024ae <initialize_dynamic_allocator+0x102>
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ae:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8024b3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	0f 85 55 ff ff ff    	jne    802415 <initialize_dynamic_allocator+0x69>
  8024c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c4:	0f 85 4b ff ff ff    	jne    802415 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8024d9:	a1 4c 92 80 00       	mov    0x80924c,%eax
  8024de:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  8024e3:	a1 48 92 80 00       	mov    0x809248,%eax
  8024e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	83 c0 08             	add    $0x8,%eax
  8024f4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	83 c0 04             	add    $0x4,%eax
  8024fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802500:	83 ea 08             	sub    $0x8,%edx
  802503:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802505:	8b 55 0c             	mov    0xc(%ebp),%edx
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	01 d0                	add    %edx,%eax
  80250d:	83 e8 08             	sub    $0x8,%eax
  802510:	8b 55 0c             	mov    0xc(%ebp),%edx
  802513:	83 ea 08             	sub    $0x8,%edx
  802516:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802521:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80252b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80252f:	75 17                	jne    802548 <initialize_dynamic_allocator+0x19c>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 c0 49 80 00       	push   $0x8049c0
  802539:	68 90 00 00 00       	push   $0x90
  80253e:	68 a5 49 80 00       	push   $0x8049a5
  802543:	e8 b8 e1 ff ff       	call   800700 <_panic>
  802548:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80254e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802551:	89 10                	mov    %edx,(%eax)
  802553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	74 0d                	je     802569 <initialize_dynamic_allocator+0x1bd>
  80255c:	a1 44 50 80 00       	mov    0x805044,%eax
  802561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802564:	89 50 04             	mov    %edx,0x4(%eax)
  802567:	eb 08                	jmp    802571 <initialize_dynamic_allocator+0x1c5>
  802569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256c:	a3 48 50 80 00       	mov    %eax,0x805048
  802571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802574:	a3 44 50 80 00       	mov    %eax,0x805044
  802579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802583:	a1 50 50 80 00       	mov    0x805050,%eax
  802588:	40                   	inc    %eax
  802589:	a3 50 50 80 00       	mov    %eax,0x805050
  80258e:	eb 07                	jmp    802597 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802590:	90                   	nop
  802591:	eb 04                	jmp    802597 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802593:	90                   	nop
  802594:	eb 01                	jmp    802597 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802596:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80259c:	8b 45 10             	mov    0x10(%ebp),%eax
  80259f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ab:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	83 e8 04             	sub    $0x4,%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8025b8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	01 c2                	add    %eax,%edx
  8025c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c3:	89 02                	mov    %eax,(%edx)
}
  8025c5:	90                   	nop
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    

008025c8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	83 e0 01             	and    $0x1,%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 03                	je     8025db <alloc_block_FF+0x13>
  8025d8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025db:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025df:	77 07                	ja     8025e8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025e1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025e8:	a1 24 50 80 00       	mov    0x805024,%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	75 73                	jne    802664 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	83 c0 10             	add    $0x10,%eax
  8025f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025fa:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802601:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802607:	01 d0                	add    %edx,%eax
  802609:	48                   	dec    %eax
  80260a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80260d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802610:	ba 00 00 00 00       	mov    $0x0,%edx
  802615:	f7 75 ec             	divl   -0x14(%ebp)
  802618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261b:	29 d0                	sub    %edx,%eax
  80261d:	c1 e8 0c             	shr    $0xc,%eax
  802620:	83 ec 0c             	sub    $0xc,%esp
  802623:	50                   	push   %eax
  802624:	e8 2e f1 ff ff       	call   801757 <sbrk>
  802629:	83 c4 10             	add    $0x10,%esp
  80262c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	6a 00                	push   $0x0
  802634:	e8 1e f1 ff ff       	call   801757 <sbrk>
  802639:	83 c4 10             	add    $0x10,%esp
  80263c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80263f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802642:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802645:	83 ec 08             	sub    $0x8,%esp
  802648:	50                   	push   %eax
  802649:	ff 75 e4             	pushl  -0x1c(%ebp)
  80264c:	e8 5b fd ff ff       	call   8023ac <initialize_dynamic_allocator>
  802651:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	68 e3 49 80 00       	push   $0x8049e3
  80265c:	e8 5c e3 ff ff       	call   8009bd <cprintf>
  802661:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802664:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802668:	75 0a                	jne    802674 <alloc_block_FF+0xac>
	        return NULL;
  80266a:	b8 00 00 00 00       	mov    $0x0,%eax
  80266f:	e9 0e 04 00 00       	jmp    802a82 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80267b:	a1 44 50 80 00       	mov    0x805044,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	e9 f3 02 00 00       	jmp    80297b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80268e:	83 ec 0c             	sub    $0xc,%esp
  802691:	ff 75 bc             	pushl  -0x44(%ebp)
  802694:	e8 af fb ff ff       	call   802248 <get_block_size>
  802699:	83 c4 10             	add    $0x10,%esp
  80269c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	83 c0 08             	add    $0x8,%eax
  8026a5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8026a8:	0f 87 c5 02 00 00    	ja     802973 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	83 c0 18             	add    $0x18,%eax
  8026b4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8026b7:	0f 87 19 02 00 00    	ja     8028d6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8026bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c3:	83 e8 08             	sub    $0x8,%eax
  8026c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	8d 50 08             	lea    0x8(%eax),%edx
  8026cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026d2:	01 d0                	add    %edx,%eax
  8026d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	83 c0 08             	add    $0x8,%eax
  8026dd:	83 ec 04             	sub    $0x4,%esp
  8026e0:	6a 01                	push   $0x1
  8026e2:	50                   	push   %eax
  8026e3:	ff 75 bc             	pushl  -0x44(%ebp)
  8026e6:	e8 ae fe ff ff       	call   802599 <set_block_data>
  8026eb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	75 68                	jne    802760 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026f8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026fc:	75 17                	jne    802715 <alloc_block_FF+0x14d>
  8026fe:	83 ec 04             	sub    $0x4,%esp
  802701:	68 c0 49 80 00       	push   $0x8049c0
  802706:	68 d7 00 00 00       	push   $0xd7
  80270b:	68 a5 49 80 00       	push   $0x8049a5
  802710:	e8 eb df ff ff       	call   800700 <_panic>
  802715:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80271b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0d                	je     802736 <alloc_block_FF+0x16e>
  802729:	a1 44 50 80 00       	mov    0x805044,%eax
  80272e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802731:	89 50 04             	mov    %edx,0x4(%eax)
  802734:	eb 08                	jmp    80273e <alloc_block_FF+0x176>
  802736:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802739:	a3 48 50 80 00       	mov    %eax,0x805048
  80273e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802741:	a3 44 50 80 00       	mov    %eax,0x805044
  802746:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802750:	a1 50 50 80 00       	mov    0x805050,%eax
  802755:	40                   	inc    %eax
  802756:	a3 50 50 80 00       	mov    %eax,0x805050
  80275b:	e9 dc 00 00 00       	jmp    80283c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	75 65                	jne    8027ce <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802769:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80276d:	75 17                	jne    802786 <alloc_block_FF+0x1be>
  80276f:	83 ec 04             	sub    $0x4,%esp
  802772:	68 f4 49 80 00       	push   $0x8049f4
  802777:	68 db 00 00 00       	push   $0xdb
  80277c:	68 a5 49 80 00       	push   $0x8049a5
  802781:	e8 7a df ff ff       	call   800700 <_panic>
  802786:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80278c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80278f:	89 50 04             	mov    %edx,0x4(%eax)
  802792:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 0c                	je     8027a8 <alloc_block_FF+0x1e0>
  80279c:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 08                	jmp    8027b0 <alloc_block_FF+0x1e8>
  8027a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8027b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b3:	a3 48 50 80 00       	mov    %eax,0x805048
  8027b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c6:	40                   	inc    %eax
  8027c7:	a3 50 50 80 00       	mov    %eax,0x805050
  8027cc:	eb 6e                	jmp    80283c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d2:	74 06                	je     8027da <alloc_block_FF+0x212>
  8027d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027d8:	75 17                	jne    8027f1 <alloc_block_FF+0x229>
  8027da:	83 ec 04             	sub    $0x4,%esp
  8027dd:	68 18 4a 80 00       	push   $0x804a18
  8027e2:	68 df 00 00 00       	push   $0xdf
  8027e7:	68 a5 49 80 00       	push   $0x8049a5
  8027ec:	e8 0f df ff ff       	call   800700 <_panic>
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 10                	mov    (%eax),%edx
  8027f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027f9:	89 10                	mov    %edx,(%eax)
  8027fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 0b                	je     80280f <alloc_block_FF+0x247>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80281a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281d:	89 50 04             	mov    %edx,0x4(%eax)
  802820:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	75 08                	jne    802831 <alloc_block_FF+0x269>
  802829:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282c:	a3 48 50 80 00       	mov    %eax,0x805048
  802831:	a1 50 50 80 00       	mov    0x805050,%eax
  802836:	40                   	inc    %eax
  802837:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80283c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802840:	75 17                	jne    802859 <alloc_block_FF+0x291>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 87 49 80 00       	push   $0x804987
  80284a:	68 e1 00 00 00       	push   $0xe1
  80284f:	68 a5 49 80 00       	push   $0x8049a5
  802854:	e8 a7 de ff ff       	call   800700 <_panic>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 10                	je     802872 <alloc_block_FF+0x2aa>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286a:	8b 52 04             	mov    0x4(%edx),%edx
  80286d:	89 50 04             	mov    %edx,0x4(%eax)
  802870:	eb 0b                	jmp    80287d <alloc_block_FF+0x2b5>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	a3 48 50 80 00       	mov    %eax,0x805048
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 0f                	je     802896 <alloc_block_FF+0x2ce>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802890:	8b 12                	mov    (%edx),%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	eb 0a                	jmp    8028a0 <alloc_block_FF+0x2d8>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	a3 44 50 80 00       	mov    %eax,0x805044
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b8:	48                   	dec    %eax
  8028b9:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	6a 00                	push   $0x0
  8028c3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8028c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8028c9:	e8 cb fc ff ff       	call   802599 <set_block_data>
  8028ce:	83 c4 10             	add    $0x10,%esp
  8028d1:	e9 95 00 00 00       	jmp    80296b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	6a 01                	push   $0x1
  8028db:	ff 75 b8             	pushl  -0x48(%ebp)
  8028de:	ff 75 bc             	pushl  -0x44(%ebp)
  8028e1:	e8 b3 fc ff ff       	call   802599 <set_block_data>
  8028e6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8028e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ed:	75 17                	jne    802906 <alloc_block_FF+0x33e>
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 87 49 80 00       	push   $0x804987
  8028f7:	68 e8 00 00 00       	push   $0xe8
  8028fc:	68 a5 49 80 00       	push   $0x8049a5
  802901:	e8 fa dd ff ff       	call   800700 <_panic>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	74 10                	je     80291f <alloc_block_FF+0x357>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802917:	8b 52 04             	mov    0x4(%edx),%edx
  80291a:	89 50 04             	mov    %edx,0x4(%eax)
  80291d:	eb 0b                	jmp    80292a <alloc_block_FF+0x362>
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	a3 48 50 80 00       	mov    %eax,0x805048
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 04             	mov    0x4(%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 0f                	je     802943 <alloc_block_FF+0x37b>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293d:	8b 12                	mov    (%edx),%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	eb 0a                	jmp    80294d <alloc_block_FF+0x385>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	a3 44 50 80 00       	mov    %eax,0x805044
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802960:	a1 50 50 80 00       	mov    0x805050,%eax
  802965:	48                   	dec    %eax
  802966:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  80296b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80296e:	e9 0f 01 00 00       	jmp    802a82 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802973:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	74 07                	je     802988 <alloc_block_FF+0x3c0>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	eb 05                	jmp    80298d <alloc_block_FF+0x3c5>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802992:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	0f 85 e9 fc ff ff    	jne    802688 <alloc_block_FF+0xc0>
  80299f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a3:	0f 85 df fc ff ff    	jne    802688 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	83 c0 08             	add    $0x8,%eax
  8029af:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029b2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029bf:	01 d0                	add    %edx,%eax
  8029c1:	48                   	dec    %eax
  8029c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cd:	f7 75 d8             	divl   -0x28(%ebp)
  8029d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029d3:	29 d0                	sub    %edx,%eax
  8029d5:	c1 e8 0c             	shr    $0xc,%eax
  8029d8:	83 ec 0c             	sub    $0xc,%esp
  8029db:	50                   	push   %eax
  8029dc:	e8 76 ed ff ff       	call   801757 <sbrk>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8029e7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8029eb:	75 0a                	jne    8029f7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	e9 8b 00 00 00       	jmp    802a82 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029f7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a04:	01 d0                	add    %edx,%eax
  802a06:	48                   	dec    %eax
  802a07:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802a0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a0d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a12:	f7 75 cc             	divl   -0x34(%ebp)
  802a15:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a18:	29 d0                	sub    %edx,%eax
  802a1a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a20:	01 d0                	add    %edx,%eax
  802a22:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  802a27:	a1 48 92 80 00       	mov    0x809248,%eax
  802a2c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a32:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a3c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a3f:	01 d0                	add    %edx,%eax
  802a41:	48                   	dec    %eax
  802a42:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a48:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4d:	f7 75 c4             	divl   -0x3c(%ebp)
  802a50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a53:	29 d0                	sub    %edx,%eax
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	6a 01                	push   $0x1
  802a5a:	50                   	push   %eax
  802a5b:	ff 75 d0             	pushl  -0x30(%ebp)
  802a5e:	e8 36 fb ff ff       	call   802599 <set_block_data>
  802a63:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a66:	83 ec 0c             	sub    $0xc,%esp
  802a69:	ff 75 d0             	pushl  -0x30(%ebp)
  802a6c:	e8 1b 0a 00 00       	call   80348c <free_block>
  802a71:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	ff 75 08             	pushl  0x8(%ebp)
  802a7a:	e8 49 fb ff ff       	call   8025c8 <alloc_block_FF>
  802a7f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a82:	c9                   	leave  
  802a83:	c3                   	ret    

00802a84 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	83 e0 01             	and    $0x1,%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	74 03                	je     802a97 <alloc_block_BF+0x13>
  802a94:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a97:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a9b:	77 07                	ja     802aa4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a9d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802aa4:	a1 24 50 80 00       	mov    0x805024,%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	75 73                	jne    802b20 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	83 c0 10             	add    $0x10,%eax
  802ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ab6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802abd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac3:	01 d0                	add    %edx,%eax
  802ac5:	48                   	dec    %eax
  802ac6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ac9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802acc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad1:	f7 75 e0             	divl   -0x20(%ebp)
  802ad4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ad7:	29 d0                	sub    %edx,%eax
  802ad9:	c1 e8 0c             	shr    $0xc,%eax
  802adc:	83 ec 0c             	sub    $0xc,%esp
  802adf:	50                   	push   %eax
  802ae0:	e8 72 ec ff ff       	call   801757 <sbrk>
  802ae5:	83 c4 10             	add    $0x10,%esp
  802ae8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	6a 00                	push   $0x0
  802af0:	e8 62 ec ff ff       	call   801757 <sbrk>
  802af5:	83 c4 10             	add    $0x10,%esp
  802af8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802afb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802afe:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802b01:	83 ec 08             	sub    $0x8,%esp
  802b04:	50                   	push   %eax
  802b05:	ff 75 d8             	pushl  -0x28(%ebp)
  802b08:	e8 9f f8 ff ff       	call   8023ac <initialize_dynamic_allocator>
  802b0d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b10:	83 ec 0c             	sub    $0xc,%esp
  802b13:	68 e3 49 80 00       	push   $0x8049e3
  802b18:	e8 a0 de ff ff       	call   8009bd <cprintf>
  802b1d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802b27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802b2e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802b35:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802b3c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b44:	e9 1d 01 00 00       	jmp    802c66 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	ff 75 a8             	pushl  -0x58(%ebp)
  802b55:	e8 ee f6 ff ff       	call   802248 <get_block_size>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	83 c0 08             	add    $0x8,%eax
  802b66:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b69:	0f 87 ef 00 00 00    	ja     802c5e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	83 c0 18             	add    $0x18,%eax
  802b75:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b78:	77 1d                	ja     802b97 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b80:	0f 86 d8 00 00 00    	jbe    802c5e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b86:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b8c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b92:	e9 c7 00 00 00       	jmp    802c5e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	83 c0 08             	add    $0x8,%eax
  802b9d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ba0:	0f 85 9d 00 00 00    	jne    802c43 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	6a 01                	push   $0x1
  802bab:	ff 75 a4             	pushl  -0x5c(%ebp)
  802bae:	ff 75 a8             	pushl  -0x58(%ebp)
  802bb1:	e8 e3 f9 ff ff       	call   802599 <set_block_data>
  802bb6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	75 17                	jne    802bd6 <alloc_block_BF+0x152>
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	68 87 49 80 00       	push   $0x804987
  802bc7:	68 2c 01 00 00       	push   $0x12c
  802bcc:	68 a5 49 80 00       	push   $0x8049a5
  802bd1:	e8 2a db ff ff       	call   800700 <_panic>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 10                	je     802bef <alloc_block_BF+0x16b>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	8b 52 04             	mov    0x4(%edx),%edx
  802bea:	89 50 04             	mov    %edx,0x4(%eax)
  802bed:	eb 0b                	jmp    802bfa <alloc_block_BF+0x176>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	a3 48 50 80 00       	mov    %eax,0x805048
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0f                	je     802c13 <alloc_block_BF+0x18f>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0d:	8b 12                	mov    (%edx),%edx
  802c0f:	89 10                	mov    %edx,(%eax)
  802c11:	eb 0a                	jmp    802c1d <alloc_block_BF+0x199>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	a3 44 50 80 00       	mov    %eax,0x805044
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c30:	a1 50 50 80 00       	mov    0x805050,%eax
  802c35:	48                   	dec    %eax
  802c36:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802c3b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c3e:	e9 24 04 00 00       	jmp    803067 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c49:	76 13                	jbe    802c5e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802c4b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802c52:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802c58:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802c5e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6a:	74 07                	je     802c73 <alloc_block_BF+0x1ef>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	eb 05                	jmp    802c78 <alloc_block_BF+0x1f4>
  802c73:	b8 00 00 00 00       	mov    $0x0,%eax
  802c78:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c7d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	0f 85 bf fe ff ff    	jne    802b49 <alloc_block_BF+0xc5>
  802c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8e:	0f 85 b5 fe ff ff    	jne    802b49 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c98:	0f 84 26 02 00 00    	je     802ec4 <alloc_block_BF+0x440>
  802c9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ca2:	0f 85 1c 02 00 00    	jne    802ec4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	2b 45 08             	sub    0x8(%ebp),%eax
  802cae:	83 e8 08             	sub    $0x8,%eax
  802cb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8d 50 08             	lea    0x8(%eax),%edx
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	83 c0 08             	add    $0x8,%eax
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	6a 01                	push   $0x1
  802ccd:	50                   	push   %eax
  802cce:	ff 75 f0             	pushl  -0x10(%ebp)
  802cd1:	e8 c3 f8 ff ff       	call   802599 <set_block_data>
  802cd6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	75 68                	jne    802d4b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ce3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ce7:	75 17                	jne    802d00 <alloc_block_BF+0x27c>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 c0 49 80 00       	push   $0x8049c0
  802cf1:	68 45 01 00 00       	push   $0x145
  802cf6:	68 a5 49 80 00       	push   $0x8049a5
  802cfb:	e8 00 da ff ff       	call   800700 <_panic>
  802d00:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d09:	89 10                	mov    %edx,(%eax)
  802d0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0d                	je     802d21 <alloc_block_BF+0x29d>
  802d14:	a1 44 50 80 00       	mov    0x805044,%eax
  802d19:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	eb 08                	jmp    802d29 <alloc_block_BF+0x2a5>
  802d21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d24:	a3 48 50 80 00       	mov    %eax,0x805048
  802d29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d2c:	a3 44 50 80 00       	mov    %eax,0x805044
  802d31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3b:	a1 50 50 80 00       	mov    0x805050,%eax
  802d40:	40                   	inc    %eax
  802d41:	a3 50 50 80 00       	mov    %eax,0x805050
  802d46:	e9 dc 00 00 00       	jmp    802e27 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	75 65                	jne    802db9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d54:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d58:	75 17                	jne    802d71 <alloc_block_BF+0x2ed>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 f4 49 80 00       	push   $0x8049f4
  802d62:	68 4a 01 00 00       	push   $0x14a
  802d67:	68 a5 49 80 00       	push   $0x8049a5
  802d6c:	e8 8f d9 ff ff       	call   800700 <_panic>
  802d71:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802d77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 0c                	je     802d93 <alloc_block_BF+0x30f>
  802d87:	a1 48 50 80 00       	mov    0x805048,%eax
  802d8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	eb 08                	jmp    802d9b <alloc_block_BF+0x317>
  802d93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d96:	a3 44 50 80 00       	mov    %eax,0x805044
  802d9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d9e:	a3 48 50 80 00       	mov    %eax,0x805048
  802da3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dac:	a1 50 50 80 00       	mov    0x805050,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 50 50 80 00       	mov    %eax,0x805050
  802db7:	eb 6e                	jmp    802e27 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802db9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbd:	74 06                	je     802dc5 <alloc_block_BF+0x341>
  802dbf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dc3:	75 17                	jne    802ddc <alloc_block_BF+0x358>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 18 4a 80 00       	push   $0x804a18
  802dcd:	68 4f 01 00 00       	push   $0x14f
  802dd2:	68 a5 49 80 00       	push   $0x8049a5
  802dd7:	e8 24 d9 ff ff       	call   800700 <_panic>
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 10                	mov    (%eax),%edx
  802de1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0b                	je     802dfa <alloc_block_BF+0x376>
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	75 08                	jne    802e1c <alloc_block_BF+0x398>
  802e14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e17:	a3 48 50 80 00       	mov    %eax,0x805048
  802e1c:	a1 50 50 80 00       	mov    0x805050,%eax
  802e21:	40                   	inc    %eax
  802e22:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2b:	75 17                	jne    802e44 <alloc_block_BF+0x3c0>
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	68 87 49 80 00       	push   $0x804987
  802e35:	68 51 01 00 00       	push   $0x151
  802e3a:	68 a5 49 80 00       	push   $0x8049a5
  802e3f:	e8 bc d8 ff ff       	call   800700 <_panic>
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 10                	je     802e5d <alloc_block_BF+0x3d9>
  802e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e55:	8b 52 04             	mov    0x4(%edx),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 0b                	jmp    802e68 <alloc_block_BF+0x3e4>
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	a3 48 50 80 00       	mov    %eax,0x805048
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0f                	je     802e81 <alloc_block_BF+0x3fd>
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7b:	8b 12                	mov    (%edx),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	eb 0a                	jmp    802e8b <alloc_block_BF+0x407>
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	a3 44 50 80 00       	mov    %eax,0x805044
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9e:	a1 50 50 80 00       	mov    0x805050,%eax
  802ea3:	48                   	dec    %eax
  802ea4:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	6a 00                	push   $0x0
  802eae:	ff 75 d0             	pushl  -0x30(%ebp)
  802eb1:	ff 75 cc             	pushl  -0x34(%ebp)
  802eb4:	e8 e0 f6 ff ff       	call   802599 <set_block_data>
  802eb9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	e9 a3 01 00 00       	jmp    803067 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ec4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ec8:	0f 85 9d 00 00 00    	jne    802f6b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	6a 01                	push   $0x1
  802ed3:	ff 75 ec             	pushl  -0x14(%ebp)
  802ed6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ed9:	e8 bb f6 ff ff       	call   802599 <set_block_data>
  802ede:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee5:	75 17                	jne    802efe <alloc_block_BF+0x47a>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 87 49 80 00       	push   $0x804987
  802eef:	68 58 01 00 00       	push   $0x158
  802ef4:	68 a5 49 80 00       	push   $0x8049a5
  802ef9:	e8 02 d8 ff ff       	call   800700 <_panic>
  802efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <alloc_block_BF+0x493>
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <alloc_block_BF+0x49e>
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 48 50 80 00       	mov    %eax,0x805048
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <alloc_block_BF+0x4b7>
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <alloc_block_BF+0x4c1>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 44 50 80 00       	mov    %eax,0x805044
  802f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 50 50 80 00       	mov    0x805050,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	e9 fc 00 00 00       	jmp    803067 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	83 c0 08             	add    $0x8,%eax
  802f71:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f74:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f81:	01 d0                	add    %edx,%eax
  802f83:	48                   	dec    %eax
  802f84:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f8f:	f7 75 c4             	divl   -0x3c(%ebp)
  802f92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f95:	29 d0                	sub    %edx,%eax
  802f97:	c1 e8 0c             	shr    $0xc,%eax
  802f9a:	83 ec 0c             	sub    $0xc,%esp
  802f9d:	50                   	push   %eax
  802f9e:	e8 b4 e7 ff ff       	call   801757 <sbrk>
  802fa3:	83 c4 10             	add    $0x10,%esp
  802fa6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802fa9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802fad:	75 0a                	jne    802fb9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	e9 ae 00 00 00       	jmp    803067 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802fb9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802fc0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802fc6:	01 d0                	add    %edx,%eax
  802fc8:	48                   	dec    %eax
  802fc9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802fcc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fcf:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd4:	f7 75 b8             	divl   -0x48(%ebp)
  802fd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fda:	29 d0                	sub    %edx,%eax
  802fdc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fdf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fe2:	01 d0                	add    %edx,%eax
  802fe4:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  802fe9:	a1 48 92 80 00       	mov    0x809248,%eax
  802fee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	68 4c 4a 80 00       	push   $0x804a4c
  802ffc:	e8 bc d9 ff ff       	call   8009bd <cprintf>
  803001:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803004:	83 ec 08             	sub    $0x8,%esp
  803007:	ff 75 bc             	pushl  -0x44(%ebp)
  80300a:	68 51 4a 80 00       	push   $0x804a51
  80300f:	e8 a9 d9 ff ff       	call   8009bd <cprintf>
  803014:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803017:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80301e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803021:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803024:	01 d0                	add    %edx,%eax
  803026:	48                   	dec    %eax
  803027:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80302a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80302d:	ba 00 00 00 00       	mov    $0x0,%edx
  803032:	f7 75 b0             	divl   -0x50(%ebp)
  803035:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803038:	29 d0                	sub    %edx,%eax
  80303a:	83 ec 04             	sub    $0x4,%esp
  80303d:	6a 01                	push   $0x1
  80303f:	50                   	push   %eax
  803040:	ff 75 bc             	pushl  -0x44(%ebp)
  803043:	e8 51 f5 ff ff       	call   802599 <set_block_data>
  803048:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80304b:	83 ec 0c             	sub    $0xc,%esp
  80304e:	ff 75 bc             	pushl  -0x44(%ebp)
  803051:	e8 36 04 00 00       	call   80348c <free_block>
  803056:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803059:	83 ec 0c             	sub    $0xc,%esp
  80305c:	ff 75 08             	pushl  0x8(%ebp)
  80305f:	e8 20 fa ff ff       	call   802a84 <alloc_block_BF>
  803064:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803067:	c9                   	leave  
  803068:	c3                   	ret    

00803069 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803069:	55                   	push   %ebp
  80306a:	89 e5                	mov    %esp,%ebp
  80306c:	53                   	push   %ebx
  80306d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803070:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803077:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80307e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803082:	74 1e                	je     8030a2 <merging+0x39>
  803084:	ff 75 08             	pushl  0x8(%ebp)
  803087:	e8 bc f1 ff ff       	call   802248 <get_block_size>
  80308c:	83 c4 04             	add    $0x4,%esp
  80308f:	89 c2                	mov    %eax,%edx
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	3b 45 10             	cmp    0x10(%ebp),%eax
  803099:	75 07                	jne    8030a2 <merging+0x39>
		prev_is_free = 1;
  80309b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8030a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a6:	74 1e                	je     8030c6 <merging+0x5d>
  8030a8:	ff 75 10             	pushl  0x10(%ebp)
  8030ab:	e8 98 f1 ff ff       	call   802248 <get_block_size>
  8030b0:	83 c4 04             	add    $0x4,%esp
  8030b3:	89 c2                	mov    %eax,%edx
  8030b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b8:	01 d0                	add    %edx,%eax
  8030ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030bd:	75 07                	jne    8030c6 <merging+0x5d>
		next_is_free = 1;
  8030bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8030c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ca:	0f 84 cc 00 00 00    	je     80319c <merging+0x133>
  8030d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d4:	0f 84 c2 00 00 00    	je     80319c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8030da:	ff 75 08             	pushl  0x8(%ebp)
  8030dd:	e8 66 f1 ff ff       	call   802248 <get_block_size>
  8030e2:	83 c4 04             	add    $0x4,%esp
  8030e5:	89 c3                	mov    %eax,%ebx
  8030e7:	ff 75 10             	pushl  0x10(%ebp)
  8030ea:	e8 59 f1 ff ff       	call   802248 <get_block_size>
  8030ef:	83 c4 04             	add    $0x4,%esp
  8030f2:	01 c3                	add    %eax,%ebx
  8030f4:	ff 75 0c             	pushl  0xc(%ebp)
  8030f7:	e8 4c f1 ff ff       	call   802248 <get_block_size>
  8030fc:	83 c4 04             	add    $0x4,%esp
  8030ff:	01 d8                	add    %ebx,%eax
  803101:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803104:	6a 00                	push   $0x0
  803106:	ff 75 ec             	pushl  -0x14(%ebp)
  803109:	ff 75 08             	pushl  0x8(%ebp)
  80310c:	e8 88 f4 ff ff       	call   802599 <set_block_data>
  803111:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803114:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803118:	75 17                	jne    803131 <merging+0xc8>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 87 49 80 00       	push   $0x804987
  803122:	68 7d 01 00 00       	push   $0x17d
  803127:	68 a5 49 80 00       	push   $0x8049a5
  80312c:	e8 cf d5 ff ff       	call   800700 <_panic>
  803131:	8b 45 0c             	mov    0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 10                	je     80314a <merging+0xe1>
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	8b 00                	mov    (%eax),%eax
  80313f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803142:	8b 52 04             	mov    0x4(%edx),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	eb 0b                	jmp    803155 <merging+0xec>
  80314a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	a3 48 50 80 00       	mov    %eax,0x805048
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 0f                	je     80316e <merging+0x105>
  80315f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	8b 55 0c             	mov    0xc(%ebp),%edx
  803168:	8b 12                	mov    (%edx),%edx
  80316a:	89 10                	mov    %edx,(%eax)
  80316c:	eb 0a                	jmp    803178 <merging+0x10f>
  80316e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	a3 44 50 80 00       	mov    %eax,0x805044
  803178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803181:	8b 45 0c             	mov    0xc(%ebp),%eax
  803184:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318b:	a1 50 50 80 00       	mov    0x805050,%eax
  803190:	48                   	dec    %eax
  803191:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803196:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803197:	e9 ea 02 00 00       	jmp    803486 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80319c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a0:	74 3b                	je     8031dd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8031a2:	83 ec 0c             	sub    $0xc,%esp
  8031a5:	ff 75 08             	pushl  0x8(%ebp)
  8031a8:	e8 9b f0 ff ff       	call   802248 <get_block_size>
  8031ad:	83 c4 10             	add    $0x10,%esp
  8031b0:	89 c3                	mov    %eax,%ebx
  8031b2:	83 ec 0c             	sub    $0xc,%esp
  8031b5:	ff 75 10             	pushl  0x10(%ebp)
  8031b8:	e8 8b f0 ff ff       	call   802248 <get_block_size>
  8031bd:	83 c4 10             	add    $0x10,%esp
  8031c0:	01 d8                	add    %ebx,%eax
  8031c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	6a 00                	push   $0x0
  8031ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8031cd:	ff 75 08             	pushl  0x8(%ebp)
  8031d0:	e8 c4 f3 ff ff       	call   802599 <set_block_data>
  8031d5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031d8:	e9 a9 02 00 00       	jmp    803486 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8031dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e1:	0f 84 2d 01 00 00    	je     803314 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8031e7:	83 ec 0c             	sub    $0xc,%esp
  8031ea:	ff 75 10             	pushl  0x10(%ebp)
  8031ed:	e8 56 f0 ff ff       	call   802248 <get_block_size>
  8031f2:	83 c4 10             	add    $0x10,%esp
  8031f5:	89 c3                	mov    %eax,%ebx
  8031f7:	83 ec 0c             	sub    $0xc,%esp
  8031fa:	ff 75 0c             	pushl  0xc(%ebp)
  8031fd:	e8 46 f0 ff ff       	call   802248 <get_block_size>
  803202:	83 c4 10             	add    $0x10,%esp
  803205:	01 d8                	add    %ebx,%eax
  803207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	6a 00                	push   $0x0
  80320f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803212:	ff 75 10             	pushl  0x10(%ebp)
  803215:	e8 7f f3 ff ff       	call   802599 <set_block_data>
  80321a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80321d:	8b 45 10             	mov    0x10(%ebp),%eax
  803220:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803223:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803227:	74 06                	je     80322f <merging+0x1c6>
  803229:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80322d:	75 17                	jne    803246 <merging+0x1dd>
  80322f:	83 ec 04             	sub    $0x4,%esp
  803232:	68 60 4a 80 00       	push   $0x804a60
  803237:	68 8d 01 00 00       	push   $0x18d
  80323c:	68 a5 49 80 00       	push   $0x8049a5
  803241:	e8 ba d4 ff ff       	call   800700 <_panic>
  803246:	8b 45 0c             	mov    0xc(%ebp),%eax
  803249:	8b 50 04             	mov    0x4(%eax),%edx
  80324c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803255:	8b 55 0c             	mov    0xc(%ebp),%edx
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 0d                	je     803271 <merging+0x208>
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80326d:	89 10                	mov    %edx,(%eax)
  80326f:	eb 08                	jmp    803279 <merging+0x210>
  803271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803274:	a3 44 50 80 00       	mov    %eax,0x805044
  803279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80327f:	89 50 04             	mov    %edx,0x4(%eax)
  803282:	a1 50 50 80 00       	mov    0x805050,%eax
  803287:	40                   	inc    %eax
  803288:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  80328d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803291:	75 17                	jne    8032aa <merging+0x241>
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 87 49 80 00       	push   $0x804987
  80329b:	68 8e 01 00 00       	push   $0x18e
  8032a0:	68 a5 49 80 00       	push   $0x8049a5
  8032a5:	e8 56 d4 ff ff       	call   800700 <_panic>
  8032aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 10                	je     8032c3 <merging+0x25a>
  8032b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032bb:	8b 52 04             	mov    0x4(%edx),%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 0b                	jmp    8032ce <merging+0x265>
  8032c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	a3 48 50 80 00       	mov    %eax,0x805048
  8032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d1:	8b 40 04             	mov    0x4(%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 0f                	je     8032e7 <merging+0x27e>
  8032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e1:	8b 12                	mov    (%edx),%edx
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	eb 0a                	jmp    8032f1 <merging+0x288>
  8032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	a3 44 50 80 00       	mov    %eax,0x805044
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803304:	a1 50 50 80 00       	mov    0x805050,%eax
  803309:	48                   	dec    %eax
  80330a:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80330f:	e9 72 01 00 00       	jmp    803486 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803314:	8b 45 10             	mov    0x10(%ebp),%eax
  803317:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80331a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331e:	74 79                	je     803399 <merging+0x330>
  803320:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803324:	74 73                	je     803399 <merging+0x330>
  803326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332a:	74 06                	je     803332 <merging+0x2c9>
  80332c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803330:	75 17                	jne    803349 <merging+0x2e0>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 18 4a 80 00       	push   $0x804a18
  80333a:	68 94 01 00 00       	push   $0x194
  80333f:	68 a5 49 80 00       	push   $0x8049a5
  803344:	e8 b7 d3 ff ff       	call   800700 <_panic>
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 10                	mov    (%eax),%edx
  80334e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803351:	89 10                	mov    %edx,(%eax)
  803353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	85 c0                	test   %eax,%eax
  80335a:	74 0b                	je     803367 <merging+0x2fe>
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80336d:	89 10                	mov    %edx,(%eax)
  80336f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803372:	8b 55 08             	mov    0x8(%ebp),%edx
  803375:	89 50 04             	mov    %edx,0x4(%eax)
  803378:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	75 08                	jne    803389 <merging+0x320>
  803381:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803384:	a3 48 50 80 00       	mov    %eax,0x805048
  803389:	a1 50 50 80 00       	mov    0x805050,%eax
  80338e:	40                   	inc    %eax
  80338f:	a3 50 50 80 00       	mov    %eax,0x805050
  803394:	e9 ce 00 00 00       	jmp    803467 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339d:	74 65                	je     803404 <merging+0x39b>
  80339f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033a3:	75 17                	jne    8033bc <merging+0x353>
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	68 f4 49 80 00       	push   $0x8049f4
  8033ad:	68 95 01 00 00       	push   $0x195
  8033b2:	68 a5 49 80 00       	push   $0x8049a5
  8033b7:	e8 44 d3 ff ff       	call   800700 <_panic>
  8033bc:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8033c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033c5:	89 50 04             	mov    %edx,0x4(%eax)
  8033c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033cb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	74 0c                	je     8033de <merging+0x375>
  8033d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8033d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	eb 08                	jmp    8033e6 <merging+0x37d>
  8033de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e1:	a3 44 50 80 00       	mov    %eax,0x805044
  8033e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8033ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f7:	a1 50 50 80 00       	mov    0x805050,%eax
  8033fc:	40                   	inc    %eax
  8033fd:	a3 50 50 80 00       	mov    %eax,0x805050
  803402:	eb 63                	jmp    803467 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803404:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803408:	75 17                	jne    803421 <merging+0x3b8>
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 c0 49 80 00       	push   $0x8049c0
  803412:	68 98 01 00 00       	push   $0x198
  803417:	68 a5 49 80 00       	push   $0x8049a5
  80341c:	e8 df d2 ff ff       	call   800700 <_panic>
  803421:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803427:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0d                	je     803442 <merging+0x3d9>
  803435:	a1 44 50 80 00       	mov    0x805044,%eax
  80343a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	eb 08                	jmp    80344a <merging+0x3e1>
  803442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803445:	a3 48 50 80 00       	mov    %eax,0x805048
  80344a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80344d:	a3 44 50 80 00       	mov    %eax,0x805044
  803452:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345c:	a1 50 50 80 00       	mov    0x805050,%eax
  803461:	40                   	inc    %eax
  803462:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	ff 75 10             	pushl  0x10(%ebp)
  80346d:	e8 d6 ed ff ff       	call   802248 <get_block_size>
  803472:	83 c4 10             	add    $0x10,%esp
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	6a 00                	push   $0x0
  80347a:	50                   	push   %eax
  80347b:	ff 75 10             	pushl  0x10(%ebp)
  80347e:	e8 16 f1 ff ff       	call   802599 <set_block_data>
  803483:	83 c4 10             	add    $0x10,%esp
	}
}
  803486:	90                   	nop
  803487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    

0080348c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80348c:	55                   	push   %ebp
  80348d:	89 e5                	mov    %esp,%ebp
  80348f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803492:	a1 44 50 80 00       	mov    0x805044,%eax
  803497:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80349a:	a1 48 50 80 00       	mov    0x805048,%eax
  80349f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a2:	73 1b                	jae    8034bf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8034a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	ff 75 08             	pushl  0x8(%ebp)
  8034af:	6a 00                	push   $0x0
  8034b1:	50                   	push   %eax
  8034b2:	e8 b2 fb ff ff       	call   803069 <merging>
  8034b7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034ba:	e9 8b 00 00 00       	jmp    80354a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8034bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8034c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034c7:	76 18                	jbe    8034e1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8034c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	ff 75 08             	pushl  0x8(%ebp)
  8034d4:	50                   	push   %eax
  8034d5:	6a 00                	push   $0x0
  8034d7:	e8 8d fb ff ff       	call   803069 <merging>
  8034dc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034df:	eb 69                	jmp    80354a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034e1:	a1 44 50 80 00       	mov    0x805044,%eax
  8034e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e9:	eb 39                	jmp    803524 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034f1:	73 29                	jae    80351c <free_block+0x90>
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fb:	76 1f                	jbe    80351c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803505:	83 ec 04             	sub    $0x4,%esp
  803508:	ff 75 08             	pushl  0x8(%ebp)
  80350b:	ff 75 f0             	pushl  -0x10(%ebp)
  80350e:	ff 75 f4             	pushl  -0xc(%ebp)
  803511:	e8 53 fb ff ff       	call   803069 <merging>
  803516:	83 c4 10             	add    $0x10,%esp
			break;
  803519:	90                   	nop
		}
	}
}
  80351a:	eb 2e                	jmp    80354a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80351c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	74 07                	je     803531 <free_block+0xa5>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	eb 05                	jmp    803536 <free_block+0xaa>
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80353b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803540:	85 c0                	test   %eax,%eax
  803542:	75 a7                	jne    8034eb <free_block+0x5f>
  803544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803548:	75 a1                	jne    8034eb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80354a:	90                   	nop
  80354b:	c9                   	leave  
  80354c:	c3                   	ret    

0080354d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80354d:	55                   	push   %ebp
  80354e:	89 e5                	mov    %esp,%ebp
  803550:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803553:	ff 75 08             	pushl  0x8(%ebp)
  803556:	e8 ed ec ff ff       	call   802248 <get_block_size>
  80355b:	83 c4 04             	add    $0x4,%esp
  80355e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803568:	eb 17                	jmp    803581 <copy_data+0x34>
  80356a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80356d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803570:	01 c2                	add    %eax,%edx
  803572:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	01 c8                	add    %ecx,%eax
  80357a:	8a 00                	mov    (%eax),%al
  80357c:	88 02                	mov    %al,(%edx)
  80357e:	ff 45 fc             	incl   -0x4(%ebp)
  803581:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803584:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803587:	72 e1                	jb     80356a <copy_data+0x1d>
}
  803589:	90                   	nop
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    

0080358c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80358c:	55                   	push   %ebp
  80358d:	89 e5                	mov    %esp,%ebp
  80358f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803596:	75 23                	jne    8035bb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80359c:	74 13                	je     8035b1 <realloc_block_FF+0x25>
  80359e:	83 ec 0c             	sub    $0xc,%esp
  8035a1:	ff 75 0c             	pushl  0xc(%ebp)
  8035a4:	e8 1f f0 ff ff       	call   8025c8 <alloc_block_FF>
  8035a9:	83 c4 10             	add    $0x10,%esp
  8035ac:	e9 f4 06 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
		return NULL;
  8035b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b6:	e9 ea 06 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8035bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035bf:	75 18                	jne    8035d9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8035c1:	83 ec 0c             	sub    $0xc,%esp
  8035c4:	ff 75 08             	pushl  0x8(%ebp)
  8035c7:	e8 c0 fe ff ff       	call   80348c <free_block>
  8035cc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8035cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d4:	e9 cc 06 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8035d9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8035dd:	77 07                	ja     8035e6 <realloc_block_FF+0x5a>
  8035df:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8035e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e9:	83 e0 01             	and    $0x1,%eax
  8035ec:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8035ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f2:	83 c0 08             	add    $0x8,%eax
  8035f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8035f8:	83 ec 0c             	sub    $0xc,%esp
  8035fb:	ff 75 08             	pushl  0x8(%ebp)
  8035fe:	e8 45 ec ff ff       	call   802248 <get_block_size>
  803603:	83 c4 10             	add    $0x10,%esp
  803606:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360c:	83 e8 08             	sub    $0x8,%eax
  80360f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	83 e8 04             	sub    $0x4,%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	83 e0 fe             	and    $0xfffffffe,%eax
  80361d:	89 c2                	mov    %eax,%edx
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	01 d0                	add    %edx,%eax
  803624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803627:	83 ec 0c             	sub    $0xc,%esp
  80362a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80362d:	e8 16 ec ff ff       	call   802248 <get_block_size>
  803632:	83 c4 10             	add    $0x10,%esp
  803635:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80363b:	83 e8 08             	sub    $0x8,%eax
  80363e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803641:	8b 45 0c             	mov    0xc(%ebp),%eax
  803644:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803647:	75 08                	jne    803651 <realloc_block_FF+0xc5>
	{
		 return va;
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	e9 54 06 00 00       	jmp    803ca5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803651:	8b 45 0c             	mov    0xc(%ebp),%eax
  803654:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803657:	0f 83 e5 03 00 00    	jae    803a42 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80365d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803660:	2b 45 0c             	sub    0xc(%ebp),%eax
  803663:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803666:	83 ec 0c             	sub    $0xc,%esp
  803669:	ff 75 e4             	pushl  -0x1c(%ebp)
  80366c:	e8 f0 eb ff ff       	call   802261 <is_free_block>
  803671:	83 c4 10             	add    $0x10,%esp
  803674:	84 c0                	test   %al,%al
  803676:	0f 84 3b 01 00 00    	je     8037b7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80367c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803682:	01 d0                	add    %edx,%eax
  803684:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	6a 01                	push   $0x1
  80368c:	ff 75 f0             	pushl  -0x10(%ebp)
  80368f:	ff 75 08             	pushl  0x8(%ebp)
  803692:	e8 02 ef ff ff       	call   802599 <set_block_data>
  803697:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	83 e8 04             	sub    $0x4,%eax
  8036a0:	8b 00                	mov    (%eax),%eax
  8036a2:	83 e0 fe             	and    $0xfffffffe,%eax
  8036a5:	89 c2                	mov    %eax,%edx
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	01 d0                	add    %edx,%eax
  8036ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8036af:	83 ec 04             	sub    $0x4,%esp
  8036b2:	6a 00                	push   $0x0
  8036b4:	ff 75 cc             	pushl  -0x34(%ebp)
  8036b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8036ba:	e8 da ee ff ff       	call   802599 <set_block_data>
  8036bf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c6:	74 06                	je     8036ce <realloc_block_FF+0x142>
  8036c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8036cc:	75 17                	jne    8036e5 <realloc_block_FF+0x159>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 18 4a 80 00       	push   $0x804a18
  8036d6:	68 f6 01 00 00       	push   $0x1f6
  8036db:	68 a5 49 80 00       	push   $0x8049a5
  8036e0:	e8 1b d0 ff ff       	call   800700 <_panic>
  8036e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e8:	8b 10                	mov    (%eax),%edx
  8036ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036ed:	89 10                	mov    %edx,(%eax)
  8036ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	74 0b                	je     803703 <realloc_block_FF+0x177>
  8036f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80370e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803711:	89 50 04             	mov    %edx,0x4(%eax)
  803714:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803717:	8b 00                	mov    (%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	75 08                	jne    803725 <realloc_block_FF+0x199>
  80371d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803720:	a3 48 50 80 00       	mov    %eax,0x805048
  803725:	a1 50 50 80 00       	mov    0x805050,%eax
  80372a:	40                   	inc    %eax
  80372b:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803734:	75 17                	jne    80374d <realloc_block_FF+0x1c1>
  803736:	83 ec 04             	sub    $0x4,%esp
  803739:	68 87 49 80 00       	push   $0x804987
  80373e:	68 f7 01 00 00       	push   $0x1f7
  803743:	68 a5 49 80 00       	push   $0x8049a5
  803748:	e8 b3 cf ff ff       	call   800700 <_panic>
  80374d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 10                	je     803766 <realloc_block_FF+0x1da>
  803756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375e:	8b 52 04             	mov    0x4(%edx),%edx
  803761:	89 50 04             	mov    %edx,0x4(%eax)
  803764:	eb 0b                	jmp    803771 <realloc_block_FF+0x1e5>
  803766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803769:	8b 40 04             	mov    0x4(%eax),%eax
  80376c:	a3 48 50 80 00       	mov    %eax,0x805048
  803771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 0f                	je     80378a <realloc_block_FF+0x1fe>
  80377b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377e:	8b 40 04             	mov    0x4(%eax),%eax
  803781:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803784:	8b 12                	mov    (%edx),%edx
  803786:	89 10                	mov    %edx,(%eax)
  803788:	eb 0a                	jmp    803794 <realloc_block_FF+0x208>
  80378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	a3 44 50 80 00       	mov    %eax,0x805044
  803794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8037ac:	48                   	dec    %eax
  8037ad:	a3 50 50 80 00       	mov    %eax,0x805050
  8037b2:	e9 83 02 00 00       	jmp    803a3a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8037b7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8037bb:	0f 86 69 02 00 00    	jbe    803a2a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	6a 01                	push   $0x1
  8037c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c9:	ff 75 08             	pushl  0x8(%ebp)
  8037cc:	e8 c8 ed ff ff       	call   802599 <set_block_data>
  8037d1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	83 e8 04             	sub    $0x4,%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8037df:	89 c2                	mov    %eax,%edx
  8037e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e4:	01 d0                	add    %edx,%eax
  8037e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8037e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8037ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8037f1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8037f5:	75 68                	jne    80385f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037fb:	75 17                	jne    803814 <realloc_block_FF+0x288>
  8037fd:	83 ec 04             	sub    $0x4,%esp
  803800:	68 c0 49 80 00       	push   $0x8049c0
  803805:	68 06 02 00 00       	push   $0x206
  80380a:	68 a5 49 80 00       	push   $0x8049a5
  80380f:	e8 ec ce ff ff       	call   800700 <_panic>
  803814:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80381a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80381d:	89 10                	mov    %edx,(%eax)
  80381f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 0d                	je     803835 <realloc_block_FF+0x2a9>
  803828:	a1 44 50 80 00       	mov    0x805044,%eax
  80382d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803830:	89 50 04             	mov    %edx,0x4(%eax)
  803833:	eb 08                	jmp    80383d <realloc_block_FF+0x2b1>
  803835:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803838:	a3 48 50 80 00       	mov    %eax,0x805048
  80383d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803840:	a3 44 50 80 00       	mov    %eax,0x805044
  803845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803848:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384f:	a1 50 50 80 00       	mov    0x805050,%eax
  803854:	40                   	inc    %eax
  803855:	a3 50 50 80 00       	mov    %eax,0x805050
  80385a:	e9 b0 01 00 00       	jmp    803a0f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80385f:	a1 44 50 80 00       	mov    0x805044,%eax
  803864:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803867:	76 68                	jbe    8038d1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803869:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80386d:	75 17                	jne    803886 <realloc_block_FF+0x2fa>
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	68 c0 49 80 00       	push   $0x8049c0
  803877:	68 0b 02 00 00       	push   $0x20b
  80387c:	68 a5 49 80 00       	push   $0x8049a5
  803881:	e8 7a ce ff ff       	call   800700 <_panic>
  803886:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80388c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388f:	89 10                	mov    %edx,(%eax)
  803891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	85 c0                	test   %eax,%eax
  803898:	74 0d                	je     8038a7 <realloc_block_FF+0x31b>
  80389a:	a1 44 50 80 00       	mov    0x805044,%eax
  80389f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038a2:	89 50 04             	mov    %edx,0x4(%eax)
  8038a5:	eb 08                	jmp    8038af <realloc_block_FF+0x323>
  8038a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038aa:	a3 48 50 80 00       	mov    %eax,0x805048
  8038af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8038b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8038c6:	40                   	inc    %eax
  8038c7:	a3 50 50 80 00       	mov    %eax,0x805050
  8038cc:	e9 3e 01 00 00       	jmp    803a0f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8038d1:	a1 44 50 80 00       	mov    0x805044,%eax
  8038d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038d9:	73 68                	jae    803943 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038df:	75 17                	jne    8038f8 <realloc_block_FF+0x36c>
  8038e1:	83 ec 04             	sub    $0x4,%esp
  8038e4:	68 f4 49 80 00       	push   $0x8049f4
  8038e9:	68 10 02 00 00       	push   $0x210
  8038ee:	68 a5 49 80 00       	push   $0x8049a5
  8038f3:	e8 08 ce ff ff       	call   800700 <_panic>
  8038f8:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8038fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803901:	89 50 04             	mov    %edx,0x4(%eax)
  803904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	74 0c                	je     80391a <realloc_block_FF+0x38e>
  80390e:	a1 48 50 80 00       	mov    0x805048,%eax
  803913:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 08                	jmp    803922 <realloc_block_FF+0x396>
  80391a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80391d:	a3 44 50 80 00       	mov    %eax,0x805044
  803922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803925:	a3 48 50 80 00       	mov    %eax,0x805048
  80392a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803933:	a1 50 50 80 00       	mov    0x805050,%eax
  803938:	40                   	inc    %eax
  803939:	a3 50 50 80 00       	mov    %eax,0x805050
  80393e:	e9 cc 00 00 00       	jmp    803a0f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803943:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80394a:	a1 44 50 80 00       	mov    0x805044,%eax
  80394f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803952:	e9 8a 00 00 00       	jmp    8039e1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80395d:	73 7a                	jae    8039d9 <realloc_block_FF+0x44d>
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803967:	73 70                	jae    8039d9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396d:	74 06                	je     803975 <realloc_block_FF+0x3e9>
  80396f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803973:	75 17                	jne    80398c <realloc_block_FF+0x400>
  803975:	83 ec 04             	sub    $0x4,%esp
  803978:	68 18 4a 80 00       	push   $0x804a18
  80397d:	68 1a 02 00 00       	push   $0x21a
  803982:	68 a5 49 80 00       	push   $0x8049a5
  803987:	e8 74 cd ff ff       	call   800700 <_panic>
  80398c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398f:	8b 10                	mov    (%eax),%edx
  803991:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803994:	89 10                	mov    %edx,(%eax)
  803996:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 0b                	je     8039aa <realloc_block_FF+0x41e>
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039b0:	89 10                	mov    %edx,(%eax)
  8039b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b8:	89 50 04             	mov    %edx,0x4(%eax)
  8039bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	75 08                	jne    8039cc <realloc_block_FF+0x440>
  8039c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039c7:	a3 48 50 80 00       	mov    %eax,0x805048
  8039cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8039d1:	40                   	inc    %eax
  8039d2:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  8039d7:	eb 36                	jmp    803a0f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8039d9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e5:	74 07                	je     8039ee <realloc_block_FF+0x462>
  8039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	eb 05                	jmp    8039f3 <realloc_block_FF+0x467>
  8039ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8039f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	0f 85 52 ff ff ff    	jne    803957 <realloc_block_FF+0x3cb>
  803a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a09:	0f 85 48 ff ff ff    	jne    803957 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803a0f:	83 ec 04             	sub    $0x4,%esp
  803a12:	6a 00                	push   $0x0
  803a14:	ff 75 d8             	pushl  -0x28(%ebp)
  803a17:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a1a:	e8 7a eb ff ff       	call   802599 <set_block_data>
  803a1f:	83 c4 10             	add    $0x10,%esp
				return va;
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	e9 7b 02 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803a2a:	83 ec 0c             	sub    $0xc,%esp
  803a2d:	68 95 4a 80 00       	push   $0x804a95
  803a32:	e8 86 cf ff ff       	call   8009bd <cprintf>
  803a37:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	e9 63 02 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a45:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a48:	0f 86 4d 02 00 00    	jbe    803c9b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803a4e:	83 ec 0c             	sub    $0xc,%esp
  803a51:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a54:	e8 08 e8 ff ff       	call   802261 <is_free_block>
  803a59:	83 c4 10             	add    $0x10,%esp
  803a5c:	84 c0                	test   %al,%al
  803a5e:	0f 84 37 02 00 00    	je     803c9b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a67:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a70:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a73:	76 38                	jbe    803aad <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a75:	83 ec 0c             	sub    $0xc,%esp
  803a78:	ff 75 08             	pushl  0x8(%ebp)
  803a7b:	e8 0c fa ff ff       	call   80348c <free_block>
  803a80:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a83:	83 ec 0c             	sub    $0xc,%esp
  803a86:	ff 75 0c             	pushl  0xc(%ebp)
  803a89:	e8 3a eb ff ff       	call   8025c8 <alloc_block_FF>
  803a8e:	83 c4 10             	add    $0x10,%esp
  803a91:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a94:	83 ec 08             	sub    $0x8,%esp
  803a97:	ff 75 c0             	pushl  -0x40(%ebp)
  803a9a:	ff 75 08             	pushl  0x8(%ebp)
  803a9d:	e8 ab fa ff ff       	call   80354d <copy_data>
  803aa2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803aa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803aa8:	e9 f8 01 00 00       	jmp    803ca5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ab3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ab6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803aba:	0f 87 a0 00 00 00    	ja     803b60 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ac0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac4:	75 17                	jne    803add <realloc_block_FF+0x551>
  803ac6:	83 ec 04             	sub    $0x4,%esp
  803ac9:	68 87 49 80 00       	push   $0x804987
  803ace:	68 38 02 00 00       	push   $0x238
  803ad3:	68 a5 49 80 00       	push   $0x8049a5
  803ad8:	e8 23 cc ff ff       	call   800700 <_panic>
  803add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae0:	8b 00                	mov    (%eax),%eax
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	74 10                	je     803af6 <realloc_block_FF+0x56a>
  803ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae9:	8b 00                	mov    (%eax),%eax
  803aeb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aee:	8b 52 04             	mov    0x4(%edx),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%eax)
  803af4:	eb 0b                	jmp    803b01 <realloc_block_FF+0x575>
  803af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af9:	8b 40 04             	mov    0x4(%eax),%eax
  803afc:	a3 48 50 80 00       	mov    %eax,0x805048
  803b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b04:	8b 40 04             	mov    0x4(%eax),%eax
  803b07:	85 c0                	test   %eax,%eax
  803b09:	74 0f                	je     803b1a <realloc_block_FF+0x58e>
  803b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0e:	8b 40 04             	mov    0x4(%eax),%eax
  803b11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b14:	8b 12                	mov    (%edx),%edx
  803b16:	89 10                	mov    %edx,(%eax)
  803b18:	eb 0a                	jmp    803b24 <realloc_block_FF+0x598>
  803b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1d:	8b 00                	mov    (%eax),%eax
  803b1f:	a3 44 50 80 00       	mov    %eax,0x805044
  803b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b37:	a1 50 50 80 00       	mov    0x805050,%eax
  803b3c:	48                   	dec    %eax
  803b3d:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803b42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b48:	01 d0                	add    %edx,%eax
  803b4a:	83 ec 04             	sub    $0x4,%esp
  803b4d:	6a 01                	push   $0x1
  803b4f:	50                   	push   %eax
  803b50:	ff 75 08             	pushl  0x8(%ebp)
  803b53:	e8 41 ea ff ff       	call   802599 <set_block_data>
  803b58:	83 c4 10             	add    $0x10,%esp
  803b5b:	e9 36 01 00 00       	jmp    803c96 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b66:	01 d0                	add    %edx,%eax
  803b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	6a 01                	push   $0x1
  803b70:	ff 75 f0             	pushl  -0x10(%ebp)
  803b73:	ff 75 08             	pushl  0x8(%ebp)
  803b76:	e8 1e ea ff ff       	call   802599 <set_block_data>
  803b7b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	83 e8 04             	sub    $0x4,%eax
  803b84:	8b 00                	mov    (%eax),%eax
  803b86:	83 e0 fe             	and    $0xfffffffe,%eax
  803b89:	89 c2                	mov    %eax,%edx
  803b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8e:	01 d0                	add    %edx,%eax
  803b90:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b97:	74 06                	je     803b9f <realloc_block_FF+0x613>
  803b99:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b9d:	75 17                	jne    803bb6 <realloc_block_FF+0x62a>
  803b9f:	83 ec 04             	sub    $0x4,%esp
  803ba2:	68 18 4a 80 00       	push   $0x804a18
  803ba7:	68 44 02 00 00       	push   $0x244
  803bac:	68 a5 49 80 00       	push   $0x8049a5
  803bb1:	e8 4a cb ff ff       	call   800700 <_panic>
  803bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb9:	8b 10                	mov    (%eax),%edx
  803bbb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bbe:	89 10                	mov    %edx,(%eax)
  803bc0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bc3:	8b 00                	mov    (%eax),%eax
  803bc5:	85 c0                	test   %eax,%eax
  803bc7:	74 0b                	je     803bd4 <realloc_block_FF+0x648>
  803bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803bda:	89 10                	mov    %edx,(%eax)
  803bdc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be2:	89 50 04             	mov    %edx,0x4(%eax)
  803be5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803be8:	8b 00                	mov    (%eax),%eax
  803bea:	85 c0                	test   %eax,%eax
  803bec:	75 08                	jne    803bf6 <realloc_block_FF+0x66a>
  803bee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803bf1:	a3 48 50 80 00       	mov    %eax,0x805048
  803bf6:	a1 50 50 80 00       	mov    0x805050,%eax
  803bfb:	40                   	inc    %eax
  803bfc:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c05:	75 17                	jne    803c1e <realloc_block_FF+0x692>
  803c07:	83 ec 04             	sub    $0x4,%esp
  803c0a:	68 87 49 80 00       	push   $0x804987
  803c0f:	68 45 02 00 00       	push   $0x245
  803c14:	68 a5 49 80 00       	push   $0x8049a5
  803c19:	e8 e2 ca ff ff       	call   800700 <_panic>
  803c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	85 c0                	test   %eax,%eax
  803c25:	74 10                	je     803c37 <realloc_block_FF+0x6ab>
  803c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c2f:	8b 52 04             	mov    0x4(%edx),%edx
  803c32:	89 50 04             	mov    %edx,0x4(%eax)
  803c35:	eb 0b                	jmp    803c42 <realloc_block_FF+0x6b6>
  803c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3a:	8b 40 04             	mov    0x4(%eax),%eax
  803c3d:	a3 48 50 80 00       	mov    %eax,0x805048
  803c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c45:	8b 40 04             	mov    0x4(%eax),%eax
  803c48:	85 c0                	test   %eax,%eax
  803c4a:	74 0f                	je     803c5b <realloc_block_FF+0x6cf>
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	8b 40 04             	mov    0x4(%eax),%eax
  803c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c55:	8b 12                	mov    (%edx),%edx
  803c57:	89 10                	mov    %edx,(%eax)
  803c59:	eb 0a                	jmp    803c65 <realloc_block_FF+0x6d9>
  803c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5e:	8b 00                	mov    (%eax),%eax
  803c60:	a3 44 50 80 00       	mov    %eax,0x805044
  803c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c78:	a1 50 50 80 00       	mov    0x805050,%eax
  803c7d:	48                   	dec    %eax
  803c7e:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803c83:	83 ec 04             	sub    $0x4,%esp
  803c86:	6a 00                	push   $0x0
  803c88:	ff 75 bc             	pushl  -0x44(%ebp)
  803c8b:	ff 75 b8             	pushl  -0x48(%ebp)
  803c8e:	e8 06 e9 ff ff       	call   802599 <set_block_data>
  803c93:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c96:	8b 45 08             	mov    0x8(%ebp),%eax
  803c99:	eb 0a                	jmp    803ca5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c9b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ca2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ca5:	c9                   	leave  
  803ca6:	c3                   	ret    

00803ca7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ca7:	55                   	push   %ebp
  803ca8:	89 e5                	mov    %esp,%ebp
  803caa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803cad:	83 ec 04             	sub    $0x4,%esp
  803cb0:	68 9c 4a 80 00       	push   $0x804a9c
  803cb5:	68 58 02 00 00       	push   $0x258
  803cba:	68 a5 49 80 00       	push   $0x8049a5
  803cbf:	e8 3c ca ff ff       	call   800700 <_panic>

00803cc4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803cc4:	55                   	push   %ebp
  803cc5:	89 e5                	mov    %esp,%ebp
  803cc7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803cca:	83 ec 04             	sub    $0x4,%esp
  803ccd:	68 c4 4a 80 00       	push   $0x804ac4
  803cd2:	68 61 02 00 00       	push   $0x261
  803cd7:	68 a5 49 80 00       	push   $0x8049a5
  803cdc:	e8 1f ca ff ff       	call   800700 <_panic>
  803ce1:	66 90                	xchg   %ax,%ax
  803ce3:	90                   	nop

00803ce4 <__udivdi3>:
  803ce4:	55                   	push   %ebp
  803ce5:	57                   	push   %edi
  803ce6:	56                   	push   %esi
  803ce7:	53                   	push   %ebx
  803ce8:	83 ec 1c             	sub    $0x1c,%esp
  803ceb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cf7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cfb:	89 ca                	mov    %ecx,%edx
  803cfd:	89 f8                	mov    %edi,%eax
  803cff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d03:	85 f6                	test   %esi,%esi
  803d05:	75 2d                	jne    803d34 <__udivdi3+0x50>
  803d07:	39 cf                	cmp    %ecx,%edi
  803d09:	77 65                	ja     803d70 <__udivdi3+0x8c>
  803d0b:	89 fd                	mov    %edi,%ebp
  803d0d:	85 ff                	test   %edi,%edi
  803d0f:	75 0b                	jne    803d1c <__udivdi3+0x38>
  803d11:	b8 01 00 00 00       	mov    $0x1,%eax
  803d16:	31 d2                	xor    %edx,%edx
  803d18:	f7 f7                	div    %edi
  803d1a:	89 c5                	mov    %eax,%ebp
  803d1c:	31 d2                	xor    %edx,%edx
  803d1e:	89 c8                	mov    %ecx,%eax
  803d20:	f7 f5                	div    %ebp
  803d22:	89 c1                	mov    %eax,%ecx
  803d24:	89 d8                	mov    %ebx,%eax
  803d26:	f7 f5                	div    %ebp
  803d28:	89 cf                	mov    %ecx,%edi
  803d2a:	89 fa                	mov    %edi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	39 ce                	cmp    %ecx,%esi
  803d36:	77 28                	ja     803d60 <__udivdi3+0x7c>
  803d38:	0f bd fe             	bsr    %esi,%edi
  803d3b:	83 f7 1f             	xor    $0x1f,%edi
  803d3e:	75 40                	jne    803d80 <__udivdi3+0x9c>
  803d40:	39 ce                	cmp    %ecx,%esi
  803d42:	72 0a                	jb     803d4e <__udivdi3+0x6a>
  803d44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d48:	0f 87 9e 00 00 00    	ja     803dec <__udivdi3+0x108>
  803d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d53:	89 fa                	mov    %edi,%edx
  803d55:	83 c4 1c             	add    $0x1c,%esp
  803d58:	5b                   	pop    %ebx
  803d59:	5e                   	pop    %esi
  803d5a:	5f                   	pop    %edi
  803d5b:	5d                   	pop    %ebp
  803d5c:	c3                   	ret    
  803d5d:	8d 76 00             	lea    0x0(%esi),%esi
  803d60:	31 ff                	xor    %edi,%edi
  803d62:	31 c0                	xor    %eax,%eax
  803d64:	89 fa                	mov    %edi,%edx
  803d66:	83 c4 1c             	add    $0x1c,%esp
  803d69:	5b                   	pop    %ebx
  803d6a:	5e                   	pop    %esi
  803d6b:	5f                   	pop    %edi
  803d6c:	5d                   	pop    %ebp
  803d6d:	c3                   	ret    
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	89 d8                	mov    %ebx,%eax
  803d72:	f7 f7                	div    %edi
  803d74:	31 ff                	xor    %edi,%edi
  803d76:	89 fa                	mov    %edi,%edx
  803d78:	83 c4 1c             	add    $0x1c,%esp
  803d7b:	5b                   	pop    %ebx
  803d7c:	5e                   	pop    %esi
  803d7d:	5f                   	pop    %edi
  803d7e:	5d                   	pop    %ebp
  803d7f:	c3                   	ret    
  803d80:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d85:	89 eb                	mov    %ebp,%ebx
  803d87:	29 fb                	sub    %edi,%ebx
  803d89:	89 f9                	mov    %edi,%ecx
  803d8b:	d3 e6                	shl    %cl,%esi
  803d8d:	89 c5                	mov    %eax,%ebp
  803d8f:	88 d9                	mov    %bl,%cl
  803d91:	d3 ed                	shr    %cl,%ebp
  803d93:	89 e9                	mov    %ebp,%ecx
  803d95:	09 f1                	or     %esi,%ecx
  803d97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d9b:	89 f9                	mov    %edi,%ecx
  803d9d:	d3 e0                	shl    %cl,%eax
  803d9f:	89 c5                	mov    %eax,%ebp
  803da1:	89 d6                	mov    %edx,%esi
  803da3:	88 d9                	mov    %bl,%cl
  803da5:	d3 ee                	shr    %cl,%esi
  803da7:	89 f9                	mov    %edi,%ecx
  803da9:	d3 e2                	shl    %cl,%edx
  803dab:	8b 44 24 08          	mov    0x8(%esp),%eax
  803daf:	88 d9                	mov    %bl,%cl
  803db1:	d3 e8                	shr    %cl,%eax
  803db3:	09 c2                	or     %eax,%edx
  803db5:	89 d0                	mov    %edx,%eax
  803db7:	89 f2                	mov    %esi,%edx
  803db9:	f7 74 24 0c          	divl   0xc(%esp)
  803dbd:	89 d6                	mov    %edx,%esi
  803dbf:	89 c3                	mov    %eax,%ebx
  803dc1:	f7 e5                	mul    %ebp
  803dc3:	39 d6                	cmp    %edx,%esi
  803dc5:	72 19                	jb     803de0 <__udivdi3+0xfc>
  803dc7:	74 0b                	je     803dd4 <__udivdi3+0xf0>
  803dc9:	89 d8                	mov    %ebx,%eax
  803dcb:	31 ff                	xor    %edi,%edi
  803dcd:	e9 58 ff ff ff       	jmp    803d2a <__udivdi3+0x46>
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dd8:	89 f9                	mov    %edi,%ecx
  803dda:	d3 e2                	shl    %cl,%edx
  803ddc:	39 c2                	cmp    %eax,%edx
  803dde:	73 e9                	jae    803dc9 <__udivdi3+0xe5>
  803de0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803de3:	31 ff                	xor    %edi,%edi
  803de5:	e9 40 ff ff ff       	jmp    803d2a <__udivdi3+0x46>
  803dea:	66 90                	xchg   %ax,%ax
  803dec:	31 c0                	xor    %eax,%eax
  803dee:	e9 37 ff ff ff       	jmp    803d2a <__udivdi3+0x46>
  803df3:	90                   	nop

00803df4 <__umoddi3>:
  803df4:	55                   	push   %ebp
  803df5:	57                   	push   %edi
  803df6:	56                   	push   %esi
  803df7:	53                   	push   %ebx
  803df8:	83 ec 1c             	sub    $0x1c,%esp
  803dfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803dff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e13:	89 f3                	mov    %esi,%ebx
  803e15:	89 fa                	mov    %edi,%edx
  803e17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e1b:	89 34 24             	mov    %esi,(%esp)
  803e1e:	85 c0                	test   %eax,%eax
  803e20:	75 1a                	jne    803e3c <__umoddi3+0x48>
  803e22:	39 f7                	cmp    %esi,%edi
  803e24:	0f 86 a2 00 00 00    	jbe    803ecc <__umoddi3+0xd8>
  803e2a:	89 c8                	mov    %ecx,%eax
  803e2c:	89 f2                	mov    %esi,%edx
  803e2e:	f7 f7                	div    %edi
  803e30:	89 d0                	mov    %edx,%eax
  803e32:	31 d2                	xor    %edx,%edx
  803e34:	83 c4 1c             	add    $0x1c,%esp
  803e37:	5b                   	pop    %ebx
  803e38:	5e                   	pop    %esi
  803e39:	5f                   	pop    %edi
  803e3a:	5d                   	pop    %ebp
  803e3b:	c3                   	ret    
  803e3c:	39 f0                	cmp    %esi,%eax
  803e3e:	0f 87 ac 00 00 00    	ja     803ef0 <__umoddi3+0xfc>
  803e44:	0f bd e8             	bsr    %eax,%ebp
  803e47:	83 f5 1f             	xor    $0x1f,%ebp
  803e4a:	0f 84 ac 00 00 00    	je     803efc <__umoddi3+0x108>
  803e50:	bf 20 00 00 00       	mov    $0x20,%edi
  803e55:	29 ef                	sub    %ebp,%edi
  803e57:	89 fe                	mov    %edi,%esi
  803e59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e5d:	89 e9                	mov    %ebp,%ecx
  803e5f:	d3 e0                	shl    %cl,%eax
  803e61:	89 d7                	mov    %edx,%edi
  803e63:	89 f1                	mov    %esi,%ecx
  803e65:	d3 ef                	shr    %cl,%edi
  803e67:	09 c7                	or     %eax,%edi
  803e69:	89 e9                	mov    %ebp,%ecx
  803e6b:	d3 e2                	shl    %cl,%edx
  803e6d:	89 14 24             	mov    %edx,(%esp)
  803e70:	89 d8                	mov    %ebx,%eax
  803e72:	d3 e0                	shl    %cl,%eax
  803e74:	89 c2                	mov    %eax,%edx
  803e76:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e7a:	d3 e0                	shl    %cl,%eax
  803e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e80:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e84:	89 f1                	mov    %esi,%ecx
  803e86:	d3 e8                	shr    %cl,%eax
  803e88:	09 d0                	or     %edx,%eax
  803e8a:	d3 eb                	shr    %cl,%ebx
  803e8c:	89 da                	mov    %ebx,%edx
  803e8e:	f7 f7                	div    %edi
  803e90:	89 d3                	mov    %edx,%ebx
  803e92:	f7 24 24             	mull   (%esp)
  803e95:	89 c6                	mov    %eax,%esi
  803e97:	89 d1                	mov    %edx,%ecx
  803e99:	39 d3                	cmp    %edx,%ebx
  803e9b:	0f 82 87 00 00 00    	jb     803f28 <__umoddi3+0x134>
  803ea1:	0f 84 91 00 00 00    	je     803f38 <__umoddi3+0x144>
  803ea7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803eab:	29 f2                	sub    %esi,%edx
  803ead:	19 cb                	sbb    %ecx,%ebx
  803eaf:	89 d8                	mov    %ebx,%eax
  803eb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803eb5:	d3 e0                	shl    %cl,%eax
  803eb7:	89 e9                	mov    %ebp,%ecx
  803eb9:	d3 ea                	shr    %cl,%edx
  803ebb:	09 d0                	or     %edx,%eax
  803ebd:	89 e9                	mov    %ebp,%ecx
  803ebf:	d3 eb                	shr    %cl,%ebx
  803ec1:	89 da                	mov    %ebx,%edx
  803ec3:	83 c4 1c             	add    $0x1c,%esp
  803ec6:	5b                   	pop    %ebx
  803ec7:	5e                   	pop    %esi
  803ec8:	5f                   	pop    %edi
  803ec9:	5d                   	pop    %ebp
  803eca:	c3                   	ret    
  803ecb:	90                   	nop
  803ecc:	89 fd                	mov    %edi,%ebp
  803ece:	85 ff                	test   %edi,%edi
  803ed0:	75 0b                	jne    803edd <__umoddi3+0xe9>
  803ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed7:	31 d2                	xor    %edx,%edx
  803ed9:	f7 f7                	div    %edi
  803edb:	89 c5                	mov    %eax,%ebp
  803edd:	89 f0                	mov    %esi,%eax
  803edf:	31 d2                	xor    %edx,%edx
  803ee1:	f7 f5                	div    %ebp
  803ee3:	89 c8                	mov    %ecx,%eax
  803ee5:	f7 f5                	div    %ebp
  803ee7:	89 d0                	mov    %edx,%eax
  803ee9:	e9 44 ff ff ff       	jmp    803e32 <__umoddi3+0x3e>
  803eee:	66 90                	xchg   %ax,%ax
  803ef0:	89 c8                	mov    %ecx,%eax
  803ef2:	89 f2                	mov    %esi,%edx
  803ef4:	83 c4 1c             	add    $0x1c,%esp
  803ef7:	5b                   	pop    %ebx
  803ef8:	5e                   	pop    %esi
  803ef9:	5f                   	pop    %edi
  803efa:	5d                   	pop    %ebp
  803efb:	c3                   	ret    
  803efc:	3b 04 24             	cmp    (%esp),%eax
  803eff:	72 06                	jb     803f07 <__umoddi3+0x113>
  803f01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f05:	77 0f                	ja     803f16 <__umoddi3+0x122>
  803f07:	89 f2                	mov    %esi,%edx
  803f09:	29 f9                	sub    %edi,%ecx
  803f0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f0f:	89 14 24             	mov    %edx,(%esp)
  803f12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f1a:	8b 14 24             	mov    (%esp),%edx
  803f1d:	83 c4 1c             	add    $0x1c,%esp
  803f20:	5b                   	pop    %ebx
  803f21:	5e                   	pop    %esi
  803f22:	5f                   	pop    %edi
  803f23:	5d                   	pop    %ebp
  803f24:	c3                   	ret    
  803f25:	8d 76 00             	lea    0x0(%esi),%esi
  803f28:	2b 04 24             	sub    (%esp),%eax
  803f2b:	19 fa                	sbb    %edi,%edx
  803f2d:	89 d1                	mov    %edx,%ecx
  803f2f:	89 c6                	mov    %eax,%esi
  803f31:	e9 71 ff ff ff       	jmp    803ea7 <__umoddi3+0xb3>
  803f36:	66 90                	xchg   %ax,%ax
  803f38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f3c:	72 ea                	jb     803f28 <__umoddi3+0x134>
  803f3e:	89 d9                	mov    %ebx,%ecx
  803f40:	e9 62 ff ff ff       	jmp    803ea7 <__umoddi3+0xb3>
