
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
  800055:	68 00 3f 80 00       	push   $0x803f00
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
  8000a5:	68 30 3f 80 00       	push   $0x803f30
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
  8000e7:	68 69 3f 80 00       	push   $0x803f69
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 85 3f 80 00       	push   $0x803f85
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
  800114:	e8 19 1c 00 00       	call   801d32 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 c6 1b 00 00       	call   801ce7 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 9c 3f 80 00       	push   $0x803f9c
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
  8002a0:	68 f8 3f 80 00       	push   $0x803ff8
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
  80030a:	68 1c 40 80 00       	push   $0x80401c
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
  800370:	68 58 40 80 00       	push   $0x804058
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
  800397:	68 a8 40 80 00       	push   $0x8040a8
  80039c:	e8 1c 06 00 00       	call   8009bd <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 82 19 00 00       	call   801d32 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 e8 40 80 00       	push   $0x8040e8
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
  80047b:	68 24 41 80 00       	push   $0x804124
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
  8004a8:	e8 3a 18 00 00       	call   801ce7 <sys_calculate_free_frames>
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
  8004d4:	68 68 41 80 00       	push   $0x804168
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
  8004f5:	68 b4 41 80 00       	push   $0x8041b4
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
  800570:	e8 cd 1b 00 00       	call   802142 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 d8 41 80 00       	push   $0x8041d8
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
  8005ae:	68 fc 41 80 00       	push   $0x8041fc
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
  8005c7:	e8 e4 18 00 00       	call   801eb0 <sys_getenvindex>
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
  800635:	e8 fa 15 00 00       	call   801c34 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	68 5c 42 80 00       	push   $0x80425c
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
  800665:	68 84 42 80 00       	push   $0x804284
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
  800696:	68 ac 42 80 00       	push   $0x8042ac
  80069b:	e8 1d 03 00 00       	call   8009bd <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	50                   	push   %eax
  8006b2:	68 04 43 80 00       	push   $0x804304
  8006b7:	e8 01 03 00 00       	call   8009bd <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 5c 42 80 00       	push   $0x80425c
  8006c7:	e8 f1 02 00 00       	call   8009bd <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006cf:	e8 7a 15 00 00       	call   801c4e <sys_unlock_cons>
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
  8006e7:	e8 90 17 00 00       	call   801e7c <sys_destroy_env>
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
  8006f8:	e8 e5 17 00 00       	call   801ee2 <sys_exit_env>
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
  800721:	68 18 43 80 00       	push   $0x804318
  800726:	e8 92 02 00 00       	call   8009bd <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80072e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	50                   	push   %eax
  80073a:	68 1d 43 80 00       	push   $0x80431d
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
  80075e:	68 39 43 80 00       	push   $0x804339
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
  80078d:	68 3c 43 80 00       	push   $0x80433c
  800792:	6a 26                	push   $0x26
  800794:	68 88 43 80 00       	push   $0x804388
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
  800862:	68 94 43 80 00       	push   $0x804394
  800867:	6a 3a                	push   $0x3a
  800869:	68 88 43 80 00       	push   $0x804388
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
  8008d5:	68 e8 43 80 00       	push   $0x8043e8
  8008da:	6a 44                	push   $0x44
  8008dc:	68 88 43 80 00       	push   $0x804388
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
  80092f:	e8 be 12 00 00       	call   801bf2 <sys_cputs>
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
  8009a6:	e8 47 12 00 00       	call   801bf2 <sys_cputs>
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
  8009f0:	e8 3f 12 00 00       	call   801c34 <sys_lock_cons>
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
  800a10:	e8 39 12 00 00       	call   801c4e <sys_unlock_cons>
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
  800a5a:	e8 2d 32 00 00       	call   803c8c <__udivdi3>
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
  800aaa:	e8 ed 32 00 00       	call   803d9c <__umoddi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	05 54 46 80 00       	add    $0x804654,%eax
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
  800c05:	8b 04 85 78 46 80 00 	mov    0x804678(,%eax,4),%eax
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
  800ce6:	8b 34 9d c0 44 80 00 	mov    0x8044c0(,%ebx,4),%esi
  800ced:	85 f6                	test   %esi,%esi
  800cef:	75 19                	jne    800d0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf1:	53                   	push   %ebx
  800cf2:	68 65 46 80 00       	push   $0x804665
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
  800d0b:	68 6e 46 80 00       	push   $0x80466e
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
  800d38:	be 71 46 80 00       	mov    $0x804671,%esi
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
  801743:	68 e8 47 80 00       	push   $0x8047e8
  801748:	68 3f 01 00 00       	push   $0x13f
  80174d:	68 0a 48 80 00       	push   $0x80480a
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
  801763:	e8 35 0a 00 00       	call   80219d <sys_sbrk>
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
  8017de:	e8 3e 08 00 00       	call   802021 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 16                	je     8017fd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 7e 0d 00 00       	call   802570 <alloc_block_FF>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	e9 8a 01 00 00       	jmp    801987 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8017fd:	e8 50 08 00 00       	call   802052 <sys_isUHeapPlacementStrategyBESTFIT>
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 84 7d 01 00 00    	je     801987 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 17 12 00 00       	call   802a2c <alloc_block_BF>
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
  801976:	e8 59 08 00 00       	call   8021d4 <sys_allocate_user_mem>
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
  8019be:	e8 2d 08 00 00       	call   8021f0 <get_block_size>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 60 1a 00 00       	call   803434 <free_block>
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
  801a66:	e8 4d 07 00 00       	call   8021b8 <sys_free_user_mem>
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
  801a74:	68 18 48 80 00       	push   $0x804818
  801a79:	68 84 00 00 00       	push   $0x84
  801a7e:	68 42 48 80 00       	push   $0x804842
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
  801aa1:	eb 74                	jmp    801b17 <smalloc+0x8d>
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
  801ad6:	eb 3f                	jmp    801b17 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801ad8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801adc:	ff 75 ec             	pushl  -0x14(%ebp)
  801adf:	50                   	push   %eax
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	e8 d4 02 00 00       	call   801dbf <sys_createSharedObject>
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801af1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801af5:	74 06                	je     801afd <smalloc+0x73>
  801af7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801afb:	75 07                	jne    801b04 <smalloc+0x7a>
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	eb 13                	jmp    801b17 <smalloc+0x8d>
	 cprintf("153\n");
  801b04:	83 ec 0c             	sub    $0xc,%esp
  801b07:	68 4e 48 80 00       	push   $0x80484e
  801b0c:	e8 ac ee ff ff       	call   8009bd <cprintf>
  801b11:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	68 54 48 80 00       	push   $0x804854
  801b27:	68 a4 00 00 00       	push   $0xa4
  801b2c:	68 42 48 80 00       	push   $0x804842
  801b31:	e8 ca eb ff ff       	call   800700 <_panic>

00801b36 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	68 78 48 80 00       	push   $0x804878
  801b44:	68 bc 00 00 00       	push   $0xbc
  801b49:	68 42 48 80 00       	push   $0x804842
  801b4e:	e8 ad eb ff ff       	call   800700 <_panic>

00801b53 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b59:	83 ec 04             	sub    $0x4,%esp
  801b5c:	68 9c 48 80 00       	push   $0x80489c
  801b61:	68 d3 00 00 00       	push   $0xd3
  801b66:	68 42 48 80 00       	push   $0x804842
  801b6b:	e8 90 eb ff ff       	call   800700 <_panic>

00801b70 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 c2 48 80 00       	push   $0x8048c2
  801b7e:	68 df 00 00 00       	push   $0xdf
  801b83:	68 42 48 80 00       	push   $0x804842
  801b88:	e8 73 eb ff ff       	call   800700 <_panic>

00801b8d <shrink>:

}
void shrink(uint32 newSize)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	68 c2 48 80 00       	push   $0x8048c2
  801b9b:	68 e4 00 00 00       	push   $0xe4
  801ba0:	68 42 48 80 00       	push   $0x804842
  801ba5:	e8 56 eb ff ff       	call   800700 <_panic>

00801baa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 c2 48 80 00       	push   $0x8048c2
  801bb8:	68 e9 00 00 00       	push   $0xe9
  801bbd:	68 42 48 80 00       	push   $0x804842
  801bc2:	e8 39 eb ff ff       	call   800700 <_panic>

00801bc7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	57                   	push   %edi
  801bcb:	56                   	push   %esi
  801bcc:	53                   	push   %ebx
  801bcd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bdc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bdf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801be2:	cd 30                	int    $0x30
  801be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5e                   	pop    %esi
  801bef:	5f                   	pop    %edi
  801bf0:	5d                   	pop    %ebp
  801bf1:	c3                   	ret    

00801bf2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bfe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	52                   	push   %edx
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	50                   	push   %eax
  801c0e:	6a 00                	push   $0x0
  801c10:	e8 b2 ff ff ff       	call   801bc7 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	90                   	nop
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_cgetc>:

int
sys_cgetc(void)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 02                	push   $0x2
  801c2a:	e8 98 ff ff ff       	call   801bc7 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 03                	push   $0x3
  801c43:	e8 7f ff ff ff       	call   801bc7 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 04                	push   $0x4
  801c5d:	e8 65 ff ff ff       	call   801bc7 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	90                   	nop
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 08                	push   $0x8
  801c7b:	e8 47 ff ff ff       	call   801bc7 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	56                   	push   %esi
  801c89:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c8a:	8b 75 18             	mov    0x18(%ebp),%esi
  801c8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	56                   	push   %esi
  801c9a:	53                   	push   %ebx
  801c9b:	51                   	push   %ecx
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	6a 09                	push   $0x9
  801ca0:	e8 22 ff ff ff       	call   801bc7 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 0a                	push   $0xa
  801cc2:	e8 00 ff ff ff       	call   801bc7 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 0b                	push   $0xb
  801cdd:	e8 e5 fe ff ff       	call   801bc7 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 0c                	push   $0xc
  801cf6:	e8 cc fe ff ff       	call   801bc7 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 0d                	push   $0xd
  801d0f:	e8 b3 fe ff ff       	call   801bc7 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 0e                	push   $0xe
  801d28:	e8 9a fe ff ff       	call   801bc7 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 0f                	push   $0xf
  801d41:	e8 81 fe ff ff       	call   801bc7 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 08             	pushl  0x8(%ebp)
  801d59:	6a 10                	push   $0x10
  801d5b:	e8 67 fe ff ff       	call   801bc7 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 11                	push   $0x11
  801d74:	e8 4e fe ff ff       	call   801bc7 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	90                   	nop
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_cputc>:

void
sys_cputc(const char c)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	50                   	push   %eax
  801d98:	6a 01                	push   $0x1
  801d9a:	e8 28 fe ff ff       	call   801bc7 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 14                	push   $0x14
  801db4:	e8 0e fe ff ff       	call   801bc7 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	90                   	nop
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dcb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	51                   	push   %ecx
  801dd8:	52                   	push   %edx
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	50                   	push   %eax
  801ddd:	6a 15                	push   $0x15
  801ddf:	e8 e3 fd ff ff       	call   801bc7 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	6a 16                	push   $0x16
  801dfc:	e8 c6 fd ff ff       	call   801bc7 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	51                   	push   %ecx
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	6a 17                	push   $0x17
  801e1b:	e8 a7 fd ff ff       	call   801bc7 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	6a 18                	push   $0x18
  801e38:	e8 8a fd ff ff       	call   801bc7 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 14             	pushl  0x14(%ebp)
  801e4d:	ff 75 10             	pushl  0x10(%ebp)
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	50                   	push   %eax
  801e54:	6a 19                	push   $0x19
  801e56:	e8 6c fd ff ff       	call   801bc7 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	50                   	push   %eax
  801e6f:	6a 1a                	push   $0x1a
  801e71:	e8 51 fd ff ff       	call   801bc7 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	50                   	push   %eax
  801e8b:	6a 1b                	push   $0x1b
  801e8d:	e8 35 fd ff ff       	call   801bc7 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 05                	push   $0x5
  801ea6:	e8 1c fd ff ff       	call   801bc7 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 06                	push   $0x6
  801ebf:	e8 03 fd ff ff       	call   801bc7 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 07                	push   $0x7
  801ed8:	e8 ea fc ff ff       	call   801bc7 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 1c                	push   $0x1c
  801ef1:	e8 d1 fc ff ff       	call   801bc7 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f05:	8d 50 04             	lea    0x4(%eax),%edx
  801f08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 1d                	push   $0x1d
  801f15:	e8 ad fc ff ff       	call   801bc7 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f26:	89 01                	mov    %eax,(%ecx)
  801f28:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	c9                   	leave  
  801f2f:	c2 04 00             	ret    $0x4

00801f32 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	ff 75 10             	pushl  0x10(%ebp)
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	6a 13                	push   $0x13
  801f44:	e8 7e fc ff ff       	call   801bc7 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_rcr2>:
uint32 sys_rcr2()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 1e                	push   $0x1e
  801f5e:	e8 64 fc ff ff       	call   801bc7 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 04             	sub    $0x4,%esp
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f74:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	50                   	push   %eax
  801f81:	6a 1f                	push   $0x1f
  801f83:	e8 3f fc ff ff       	call   801bc7 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8b:	90                   	nop
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <rsttst>:
void rsttst()
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 21                	push   $0x21
  801f9d:	e8 25 fc ff ff       	call   801bc7 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa5:	90                   	nop
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fb4:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	ff 75 10             	pushl  0x10(%ebp)
  801fc0:	ff 75 0c             	pushl  0xc(%ebp)
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	6a 20                	push   $0x20
  801fc8:	e8 fa fb ff ff       	call   801bc7 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd0:	90                   	nop
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <chktst>:
void chktst(uint32 n)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	6a 22                	push   $0x22
  801fe3:	e8 df fb ff ff       	call   801bc7 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
	return ;
  801feb:	90                   	nop
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <inctst>:

void inctst()
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 23                	push   $0x23
  801ffd:	e8 c5 fb ff ff       	call   801bc7 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
	return ;
  802005:	90                   	nop
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <gettst>:
uint32 gettst()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 24                	push   $0x24
  802017:	e8 ab fb ff ff       	call   801bc7 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 25                	push   $0x25
  802033:	e8 8f fb ff ff       	call   801bc7 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
  80203b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80203e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802042:	75 07                	jne    80204b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802044:	b8 01 00 00 00       	mov    $0x1,%eax
  802049:	eb 05                	jmp    802050 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 25                	push   $0x25
  802064:	e8 5e fb ff ff       	call   801bc7 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80206f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802073:	75 07                	jne    80207c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802075:	b8 01 00 00 00       	mov    $0x1,%eax
  80207a:	eb 05                	jmp    802081 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 25                	push   $0x25
  802095:	e8 2d fb ff ff       	call   801bc7 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
  80209d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020a0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020a4:	75 07                	jne    8020ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	eb 05                	jmp    8020b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 25                	push   $0x25
  8020c6:	e8 fc fa ff ff       	call   801bc7 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020d1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020d5:	75 07                	jne    8020de <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020dc:	eb 05                	jmp    8020e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	ff 75 08             	pushl  0x8(%ebp)
  8020f3:	6a 26                	push   $0x26
  8020f5:	e8 cd fa ff ff       	call   801bc7 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fd:	90                   	nop
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802104:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802107:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	6a 00                	push   $0x0
  802112:	53                   	push   %ebx
  802113:	51                   	push   %ecx
  802114:	52                   	push   %edx
  802115:	50                   	push   %eax
  802116:	6a 27                	push   $0x27
  802118:	e8 aa fa ff ff       	call   801bc7 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	52                   	push   %edx
  802135:	50                   	push   %eax
  802136:	6a 28                	push   $0x28
  802138:	e8 8a fa ff ff       	call   801bc7 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802145:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802148:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	51                   	push   %ecx
  802151:	ff 75 10             	pushl  0x10(%ebp)
  802154:	52                   	push   %edx
  802155:	50                   	push   %eax
  802156:	6a 29                	push   $0x29
  802158:	e8 6a fa ff ff       	call   801bc7 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	ff 75 10             	pushl  0x10(%ebp)
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	ff 75 08             	pushl  0x8(%ebp)
  802172:	6a 12                	push   $0x12
  802174:	e8 4e fa ff ff       	call   801bc7 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
	return ;
  80217c:	90                   	nop
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	52                   	push   %edx
  80218f:	50                   	push   %eax
  802190:	6a 2a                	push   $0x2a
  802192:	e8 30 fa ff ff       	call   801bc7 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
	return;
  80219a:	90                   	nop
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	50                   	push   %eax
  8021ac:	6a 2b                	push   $0x2b
  8021ae:	e8 14 fa ff ff       	call   801bc7 <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	ff 75 08             	pushl  0x8(%ebp)
  8021c7:	6a 2c                	push   $0x2c
  8021c9:	e8 f9 f9 ff ff       	call   801bc7 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
	return;
  8021d1:	90                   	nop
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	ff 75 0c             	pushl  0xc(%ebp)
  8021e0:	ff 75 08             	pushl  0x8(%ebp)
  8021e3:	6a 2d                	push   $0x2d
  8021e5:	e8 dd f9 ff ff       	call   801bc7 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
	return;
  8021ed:	90                   	nop
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	83 e8 04             	sub    $0x4,%eax
  8021fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	83 e8 04             	sub    $0x4,%eax
  802215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	83 e0 01             	and    $0x1,%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	0f 94 c0             	sete   %al
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80222d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	83 f8 02             	cmp    $0x2,%eax
  80223a:	74 2b                	je     802267 <alloc_block+0x40>
  80223c:	83 f8 02             	cmp    $0x2,%eax
  80223f:	7f 07                	jg     802248 <alloc_block+0x21>
  802241:	83 f8 01             	cmp    $0x1,%eax
  802244:	74 0e                	je     802254 <alloc_block+0x2d>
  802246:	eb 58                	jmp    8022a0 <alloc_block+0x79>
  802248:	83 f8 03             	cmp    $0x3,%eax
  80224b:	74 2d                	je     80227a <alloc_block+0x53>
  80224d:	83 f8 04             	cmp    $0x4,%eax
  802250:	74 3b                	je     80228d <alloc_block+0x66>
  802252:	eb 4c                	jmp    8022a0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802254:	83 ec 0c             	sub    $0xc,%esp
  802257:	ff 75 08             	pushl  0x8(%ebp)
  80225a:	e8 11 03 00 00       	call   802570 <alloc_block_FF>
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802265:	eb 4a                	jmp    8022b1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	ff 75 08             	pushl  0x8(%ebp)
  80226d:	e8 fa 19 00 00       	call   803c6c <alloc_block_NF>
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802278:	eb 37                	jmp    8022b1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80227a:	83 ec 0c             	sub    $0xc,%esp
  80227d:	ff 75 08             	pushl  0x8(%ebp)
  802280:	e8 a7 07 00 00       	call   802a2c <alloc_block_BF>
  802285:	83 c4 10             	add    $0x10,%esp
  802288:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80228b:	eb 24                	jmp    8022b1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	ff 75 08             	pushl  0x8(%ebp)
  802293:	e8 b7 19 00 00       	call   803c4f <alloc_block_WF>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80229e:	eb 11                	jmp    8022b1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	68 d4 48 80 00       	push   $0x8048d4
  8022a8:	e8 10 e7 ff ff       	call   8009bd <cprintf>
  8022ad:	83 c4 10             	add    $0x10,%esp
		break;
  8022b0:	90                   	nop
	}
	return va;
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	53                   	push   %ebx
  8022ba:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022bd:	83 ec 0c             	sub    $0xc,%esp
  8022c0:	68 f4 48 80 00       	push   $0x8048f4
  8022c5:	e8 f3 e6 ff ff       	call   8009bd <cprintf>
  8022ca:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	68 1f 49 80 00       	push   $0x80491f
  8022d5:	e8 e3 e6 ff ff       	call   8009bd <cprintf>
  8022da:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e3:	eb 37                	jmp    80231c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022eb:	e8 19 ff ff ff       	call   802209 <is_free_block>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	0f be d8             	movsbl %al,%ebx
  8022f6:	83 ec 0c             	sub    $0xc,%esp
  8022f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fc:	e8 ef fe ff ff       	call   8021f0 <get_block_size>
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	53                   	push   %ebx
  802308:	50                   	push   %eax
  802309:	68 37 49 80 00       	push   $0x804937
  80230e:	e8 aa e6 ff ff       	call   8009bd <cprintf>
  802313:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802316:	8b 45 10             	mov    0x10(%ebp),%eax
  802319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802320:	74 07                	je     802329 <print_blocks_list+0x73>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	eb 05                	jmp    80232e <print_blocks_list+0x78>
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
  80232e:	89 45 10             	mov    %eax,0x10(%ebp)
  802331:	8b 45 10             	mov    0x10(%ebp),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 ad                	jne    8022e5 <print_blocks_list+0x2f>
  802338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233c:	75 a7                	jne    8022e5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80233e:	83 ec 0c             	sub    $0xc,%esp
  802341:	68 f4 48 80 00       	push   $0x8048f4
  802346:	e8 72 e6 ff ff       	call   8009bd <cprintf>
  80234b:	83 c4 10             	add    $0x10,%esp

}
  80234e:	90                   	nop
  80234f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80235a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235d:	83 e0 01             	and    $0x1,%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 03                	je     802367 <initialize_dynamic_allocator+0x13>
  802364:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80236b:	0f 84 c7 01 00 00    	je     802538 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802371:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802378:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802381:	01 d0                	add    %edx,%eax
  802383:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802388:	0f 87 ad 01 00 00    	ja     80253b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	0f 89 a5 01 00 00    	jns    80253e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802399:	8b 55 08             	mov    0x8(%ebp),%edx
  80239c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239f:	01 d0                	add    %edx,%eax
  8023a1:	83 e8 04             	sub    $0x4,%eax
  8023a4:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  8023a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b8:	e9 87 00 00 00       	jmp    802444 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	75 14                	jne    8023d7 <initialize_dynamic_allocator+0x83>
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 4f 49 80 00       	push   $0x80494f
  8023cb:	6a 79                	push   $0x79
  8023cd:	68 6d 49 80 00       	push   $0x80496d
  8023d2:	e8 29 e3 ff ff       	call   800700 <_panic>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	74 10                	je     8023f0 <initialize_dynamic_allocator+0x9c>
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e8:	8b 52 04             	mov    0x4(%edx),%edx
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	eb 0b                	jmp    8023fb <initialize_dynamic_allocator+0xa7>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 40 04             	mov    0x4(%eax),%eax
  8023f6:	a3 48 50 80 00       	mov    %eax,0x805048
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	74 0f                	je     802414 <initialize_dynamic_allocator+0xc0>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 04             	mov    0x4(%eax),%eax
  80240b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240e:	8b 12                	mov    (%edx),%edx
  802410:	89 10                	mov    %edx,(%eax)
  802412:	eb 0a                	jmp    80241e <initialize_dynamic_allocator+0xca>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	a3 44 50 80 00       	mov    %eax,0x805044
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802431:	a1 50 50 80 00       	mov    0x805050,%eax
  802436:	48                   	dec    %eax
  802437:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80243c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802448:	74 07                	je     802451 <initialize_dynamic_allocator+0xfd>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	eb 05                	jmp    802456 <initialize_dynamic_allocator+0x102>
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
  802456:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80245b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	0f 85 55 ff ff ff    	jne    8023bd <initialize_dynamic_allocator+0x69>
  802468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246c:	0f 85 4b ff ff ff    	jne    8023bd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802481:	a1 4c 92 80 00       	mov    0x80924c,%eax
  802486:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  80248b:	a1 48 92 80 00       	mov    0x809248,%eax
  802490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	83 c0 08             	add    $0x8,%eax
  80249c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	83 c0 04             	add    $0x4,%eax
  8024a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a8:	83 ea 08             	sub    $0x8,%edx
  8024ab:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	01 d0                	add    %edx,%eax
  8024b5:	83 e8 08             	sub    $0x8,%eax
  8024b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bb:	83 ea 08             	sub    $0x8,%edx
  8024be:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8024c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8024d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d7:	75 17                	jne    8024f0 <initialize_dynamic_allocator+0x19c>
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	68 88 49 80 00       	push   $0x804988
  8024e1:	68 90 00 00 00       	push   $0x90
  8024e6:	68 6d 49 80 00       	push   $0x80496d
  8024eb:	e8 10 e2 ff ff       	call   800700 <_panic>
  8024f0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	89 10                	mov    %edx,(%eax)
  8024fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	85 c0                	test   %eax,%eax
  802502:	74 0d                	je     802511 <initialize_dynamic_allocator+0x1bd>
  802504:	a1 44 50 80 00       	mov    0x805044,%eax
  802509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80250c:	89 50 04             	mov    %edx,0x4(%eax)
  80250f:	eb 08                	jmp    802519 <initialize_dynamic_allocator+0x1c5>
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	a3 48 50 80 00       	mov    %eax,0x805048
  802519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251c:	a3 44 50 80 00       	mov    %eax,0x805044
  802521:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252b:	a1 50 50 80 00       	mov    0x805050,%eax
  802530:	40                   	inc    %eax
  802531:	a3 50 50 80 00       	mov    %eax,0x805050
  802536:	eb 07                	jmp    80253f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802538:	90                   	nop
  802539:	eb 04                	jmp    80253f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80253b:	90                   	nop
  80253c:	eb 01                	jmp    80253f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80253e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802544:	8b 45 10             	mov    0x10(%ebp),%eax
  802547:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802550:	8b 45 0c             	mov    0xc(%ebp),%eax
  802553:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	83 e8 04             	sub    $0x4,%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	83 e0 fe             	and    $0xfffffffe,%eax
  802560:	8d 50 f8             	lea    -0x8(%eax),%edx
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	01 c2                	add    %eax,%edx
  802568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256b:	89 02                	mov    %eax,(%edx)
}
  80256d:	90                   	nop
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    

00802570 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	83 e0 01             	and    $0x1,%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 03                	je     802583 <alloc_block_FF+0x13>
  802580:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802583:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802587:	77 07                	ja     802590 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802589:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802590:	a1 24 50 80 00       	mov    0x805024,%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	75 73                	jne    80260c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	83 c0 10             	add    $0x10,%eax
  80259f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025a2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	01 d0                	add    %edx,%eax
  8025b1:	48                   	dec    %eax
  8025b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025bd:	f7 75 ec             	divl   -0x14(%ebp)
  8025c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025c3:	29 d0                	sub    %edx,%eax
  8025c5:	c1 e8 0c             	shr    $0xc,%eax
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	50                   	push   %eax
  8025cc:	e8 86 f1 ff ff       	call   801757 <sbrk>
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025d7:	83 ec 0c             	sub    $0xc,%esp
  8025da:	6a 00                	push   $0x0
  8025dc:	e8 76 f1 ff ff       	call   801757 <sbrk>
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ea:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025ed:	83 ec 08             	sub    $0x8,%esp
  8025f0:	50                   	push   %eax
  8025f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025f4:	e8 5b fd ff ff       	call   802354 <initialize_dynamic_allocator>
  8025f9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025fc:	83 ec 0c             	sub    $0xc,%esp
  8025ff:	68 ab 49 80 00       	push   $0x8049ab
  802604:	e8 b4 e3 ff ff       	call   8009bd <cprintf>
  802609:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80260c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802610:	75 0a                	jne    80261c <alloc_block_FF+0xac>
	        return NULL;
  802612:	b8 00 00 00 00       	mov    $0x0,%eax
  802617:	e9 0e 04 00 00       	jmp    802a2a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80261c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802623:	a1 44 50 80 00       	mov    0x805044,%eax
  802628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262b:	e9 f3 02 00 00       	jmp    802923 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802636:	83 ec 0c             	sub    $0xc,%esp
  802639:	ff 75 bc             	pushl  -0x44(%ebp)
  80263c:	e8 af fb ff ff       	call   8021f0 <get_block_size>
  802641:	83 c4 10             	add    $0x10,%esp
  802644:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	83 c0 08             	add    $0x8,%eax
  80264d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802650:	0f 87 c5 02 00 00    	ja     80291b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	83 c0 18             	add    $0x18,%eax
  80265c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80265f:	0f 87 19 02 00 00    	ja     80287e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802665:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802668:	2b 45 08             	sub    0x8(%ebp),%eax
  80266b:	83 e8 08             	sub    $0x8,%eax
  80266e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8d 50 08             	lea    0x8(%eax),%edx
  802677:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80267a:	01 d0                	add    %edx,%eax
  80267c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	83 c0 08             	add    $0x8,%eax
  802685:	83 ec 04             	sub    $0x4,%esp
  802688:	6a 01                	push   $0x1
  80268a:	50                   	push   %eax
  80268b:	ff 75 bc             	pushl  -0x44(%ebp)
  80268e:	e8 ae fe ff ff       	call   802541 <set_block_data>
  802693:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	75 68                	jne    802708 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026a4:	75 17                	jne    8026bd <alloc_block_FF+0x14d>
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 88 49 80 00       	push   $0x804988
  8026ae:	68 d7 00 00 00       	push   $0xd7
  8026b3:	68 6d 49 80 00       	push   $0x80496d
  8026b8:	e8 43 e0 ff ff       	call   800700 <_panic>
  8026bd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c6:	89 10                	mov    %edx,(%eax)
  8026c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0d                	je     8026de <alloc_block_FF+0x16e>
  8026d1:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d9:	89 50 04             	mov    %edx,0x4(%eax)
  8026dc:	eb 08                	jmp    8026e6 <alloc_block_FF+0x176>
  8026de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e1:	a3 48 50 80 00       	mov    %eax,0x805048
  8026e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e9:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fd:	40                   	inc    %eax
  8026fe:	a3 50 50 80 00       	mov    %eax,0x805050
  802703:	e9 dc 00 00 00       	jmp    8027e4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	75 65                	jne    802776 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802711:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802715:	75 17                	jne    80272e <alloc_block_FF+0x1be>
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	68 bc 49 80 00       	push   $0x8049bc
  80271f:	68 db 00 00 00       	push   $0xdb
  802724:	68 6d 49 80 00       	push   $0x80496d
  802729:	e8 d2 df ff ff       	call   800700 <_panic>
  80272e:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802734:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802737:	89 50 04             	mov    %edx,0x4(%eax)
  80273a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 0c                	je     802750 <alloc_block_FF+0x1e0>
  802744:	a1 48 50 80 00       	mov    0x805048,%eax
  802749:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	eb 08                	jmp    802758 <alloc_block_FF+0x1e8>
  802750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802753:	a3 44 50 80 00       	mov    %eax,0x805044
  802758:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80275b:	a3 48 50 80 00       	mov    %eax,0x805048
  802760:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802769:	a1 50 50 80 00       	mov    0x805050,%eax
  80276e:	40                   	inc    %eax
  80276f:	a3 50 50 80 00       	mov    %eax,0x805050
  802774:	eb 6e                	jmp    8027e4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277a:	74 06                	je     802782 <alloc_block_FF+0x212>
  80277c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802780:	75 17                	jne    802799 <alloc_block_FF+0x229>
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	68 e0 49 80 00       	push   $0x8049e0
  80278a:	68 df 00 00 00       	push   $0xdf
  80278f:	68 6d 49 80 00       	push   $0x80496d
  802794:	e8 67 df ff ff       	call   800700 <_panic>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 10                	mov    (%eax),%edx
  80279e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a1:	89 10                	mov    %edx,(%eax)
  8027a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	74 0b                	je     8027b7 <alloc_block_FF+0x247>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027b4:	89 50 04             	mov    %edx,0x4(%eax)
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027bd:	89 10                	mov    %edx,(%eax)
  8027bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c5:	89 50 04             	mov    %edx,0x4(%eax)
  8027c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	75 08                	jne    8027d9 <alloc_block_FF+0x269>
  8027d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027de:	40                   	inc    %eax
  8027df:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8027e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e8:	75 17                	jne    802801 <alloc_block_FF+0x291>
  8027ea:	83 ec 04             	sub    $0x4,%esp
  8027ed:	68 4f 49 80 00       	push   $0x80494f
  8027f2:	68 e1 00 00 00       	push   $0xe1
  8027f7:	68 6d 49 80 00       	push   $0x80496d
  8027fc:	e8 ff de ff ff       	call   800700 <_panic>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 10                	je     80281a <alloc_block_FF+0x2aa>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802812:	8b 52 04             	mov    0x4(%edx),%edx
  802815:	89 50 04             	mov    %edx,0x4(%eax)
  802818:	eb 0b                	jmp    802825 <alloc_block_FF+0x2b5>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	a3 48 50 80 00       	mov    %eax,0x805048
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 04             	mov    0x4(%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 0f                	je     80283e <alloc_block_FF+0x2ce>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802838:	8b 12                	mov    (%edx),%edx
  80283a:	89 10                	mov    %edx,(%eax)
  80283c:	eb 0a                	jmp    802848 <alloc_block_FF+0x2d8>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	a3 44 50 80 00       	mov    %eax,0x805044
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285b:	a1 50 50 80 00       	mov    0x805050,%eax
  802860:	48                   	dec    %eax
  802861:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	6a 00                	push   $0x0
  80286b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80286e:	ff 75 b0             	pushl  -0x50(%ebp)
  802871:	e8 cb fc ff ff       	call   802541 <set_block_data>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	e9 95 00 00 00       	jmp    802913 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	6a 01                	push   $0x1
  802883:	ff 75 b8             	pushl  -0x48(%ebp)
  802886:	ff 75 bc             	pushl  -0x44(%ebp)
  802889:	e8 b3 fc ff ff       	call   802541 <set_block_data>
  80288e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802895:	75 17                	jne    8028ae <alloc_block_FF+0x33e>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 4f 49 80 00       	push   $0x80494f
  80289f:	68 e8 00 00 00       	push   $0xe8
  8028a4:	68 6d 49 80 00       	push   $0x80496d
  8028a9:	e8 52 de ff ff       	call   800700 <_panic>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 10                	je     8028c7 <alloc_block_FF+0x357>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bf:	8b 52 04             	mov    0x4(%edx),%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 0b                	jmp    8028d2 <alloc_block_FF+0x362>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 0f                	je     8028eb <alloc_block_FF+0x37b>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e5:	8b 12                	mov    (%edx),%edx
  8028e7:	89 10                	mov    %edx,(%eax)
  8028e9:	eb 0a                	jmp    8028f5 <alloc_block_FF+0x385>
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 50 50 80 00       	mov    0x805050,%eax
  80290d:	48                   	dec    %eax
  80290e:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  802913:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802916:	e9 0f 01 00 00       	jmp    802a2a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80291b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802927:	74 07                	je     802930 <alloc_block_FF+0x3c0>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	eb 05                	jmp    802935 <alloc_block_FF+0x3c5>
  802930:	b8 00 00 00 00       	mov    $0x0,%eax
  802935:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80293a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	0f 85 e9 fc ff ff    	jne    802630 <alloc_block_FF+0xc0>
  802947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294b:	0f 85 df fc ff ff    	jne    802630 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	83 c0 08             	add    $0x8,%eax
  802957:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80295a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802961:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802967:	01 d0                	add    %edx,%eax
  802969:	48                   	dec    %eax
  80296a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80296d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802970:	ba 00 00 00 00       	mov    $0x0,%edx
  802975:	f7 75 d8             	divl   -0x28(%ebp)
  802978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297b:	29 d0                	sub    %edx,%eax
  80297d:	c1 e8 0c             	shr    $0xc,%eax
  802980:	83 ec 0c             	sub    $0xc,%esp
  802983:	50                   	push   %eax
  802984:	e8 ce ed ff ff       	call   801757 <sbrk>
  802989:	83 c4 10             	add    $0x10,%esp
  80298c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80298f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802993:	75 0a                	jne    80299f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	e9 8b 00 00 00       	jmp    802a2a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80299f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	48                   	dec    %eax
  8029af:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ba:	f7 75 cc             	divl   -0x34(%ebp)
  8029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029c0:	29 d0                	sub    %edx,%eax
  8029c2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  8029cf:	a1 48 92 80 00       	mov    0x809248,%eax
  8029d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029da:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029e7:	01 d0                	add    %edx,%eax
  8029e9:	48                   	dec    %eax
  8029ea:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f5:	f7 75 c4             	divl   -0x3c(%ebp)
  8029f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029fb:	29 d0                	sub    %edx,%eax
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	6a 01                	push   $0x1
  802a02:	50                   	push   %eax
  802a03:	ff 75 d0             	pushl  -0x30(%ebp)
  802a06:	e8 36 fb ff ff       	call   802541 <set_block_data>
  802a0b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a0e:	83 ec 0c             	sub    $0xc,%esp
  802a11:	ff 75 d0             	pushl  -0x30(%ebp)
  802a14:	e8 1b 0a 00 00       	call   803434 <free_block>
  802a19:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a1c:	83 ec 0c             	sub    $0xc,%esp
  802a1f:	ff 75 08             	pushl  0x8(%ebp)
  802a22:	e8 49 fb ff ff       	call   802570 <alloc_block_FF>
  802a27:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	83 e0 01             	and    $0x1,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 03                	je     802a3f <alloc_block_BF+0x13>
  802a3c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a3f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a43:	77 07                	ja     802a4c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a45:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a4c:	a1 24 50 80 00       	mov    0x805024,%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	75 73                	jne    802ac8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	83 c0 10             	add    $0x10,%eax
  802a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a5e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6b:	01 d0                	add    %edx,%eax
  802a6d:	48                   	dec    %eax
  802a6e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a74:	ba 00 00 00 00       	mov    $0x0,%edx
  802a79:	f7 75 e0             	divl   -0x20(%ebp)
  802a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a7f:	29 d0                	sub    %edx,%eax
  802a81:	c1 e8 0c             	shr    $0xc,%eax
  802a84:	83 ec 0c             	sub    $0xc,%esp
  802a87:	50                   	push   %eax
  802a88:	e8 ca ec ff ff       	call   801757 <sbrk>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a93:	83 ec 0c             	sub    $0xc,%esp
  802a96:	6a 00                	push   $0x0
  802a98:	e8 ba ec ff ff       	call   801757 <sbrk>
  802a9d:	83 c4 10             	add    $0x10,%esp
  802aa0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802aa9:	83 ec 08             	sub    $0x8,%esp
  802aac:	50                   	push   %eax
  802aad:	ff 75 d8             	pushl  -0x28(%ebp)
  802ab0:	e8 9f f8 ff ff       	call   802354 <initialize_dynamic_allocator>
  802ab5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ab8:	83 ec 0c             	sub    $0xc,%esp
  802abb:	68 ab 49 80 00       	push   $0x8049ab
  802ac0:	e8 f8 de ff ff       	call   8009bd <cprintf>
  802ac5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802acf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ad6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802add:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ae4:	a1 44 50 80 00       	mov    0x805044,%eax
  802ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aec:	e9 1d 01 00 00       	jmp    802c0e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802af7:	83 ec 0c             	sub    $0xc,%esp
  802afa:	ff 75 a8             	pushl  -0x58(%ebp)
  802afd:	e8 ee f6 ff ff       	call   8021f0 <get_block_size>
  802b02:	83 c4 10             	add    $0x10,%esp
  802b05:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	83 c0 08             	add    $0x8,%eax
  802b0e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b11:	0f 87 ef 00 00 00    	ja     802c06 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	83 c0 18             	add    $0x18,%eax
  802b1d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b20:	77 1d                	ja     802b3f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b28:	0f 86 d8 00 00 00    	jbe    802c06 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b2e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b34:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b3a:	e9 c7 00 00 00       	jmp    802c06 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	83 c0 08             	add    $0x8,%eax
  802b45:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b48:	0f 85 9d 00 00 00    	jne    802beb <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b4e:	83 ec 04             	sub    $0x4,%esp
  802b51:	6a 01                	push   $0x1
  802b53:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b56:	ff 75 a8             	pushl  -0x58(%ebp)
  802b59:	e8 e3 f9 ff ff       	call   802541 <set_block_data>
  802b5e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	75 17                	jne    802b7e <alloc_block_BF+0x152>
  802b67:	83 ec 04             	sub    $0x4,%esp
  802b6a:	68 4f 49 80 00       	push   $0x80494f
  802b6f:	68 2c 01 00 00       	push   $0x12c
  802b74:	68 6d 49 80 00       	push   $0x80496d
  802b79:	e8 82 db ff ff       	call   800700 <_panic>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 10                	je     802b97 <alloc_block_BF+0x16b>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8f:	8b 52 04             	mov    0x4(%edx),%edx
  802b92:	89 50 04             	mov    %edx,0x4(%eax)
  802b95:	eb 0b                	jmp    802ba2 <alloc_block_BF+0x176>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	a3 48 50 80 00       	mov    %eax,0x805048
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 0f                	je     802bbb <alloc_block_BF+0x18f>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 04             	mov    0x4(%eax),%eax
  802bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb5:	8b 12                	mov    (%edx),%edx
  802bb7:	89 10                	mov    %edx,(%eax)
  802bb9:	eb 0a                	jmp    802bc5 <alloc_block_BF+0x199>
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd8:	a1 50 50 80 00       	mov    0x805050,%eax
  802bdd:	48                   	dec    %eax
  802bde:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802be3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802be6:	e9 24 04 00 00       	jmp    80300f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bf1:	76 13                	jbe    802c06 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802bf3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802bfa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802c00:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c03:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802c06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c12:	74 07                	je     802c1b <alloc_block_BF+0x1ef>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	eb 05                	jmp    802c20 <alloc_block_BF+0x1f4>
  802c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c20:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c25:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	0f 85 bf fe ff ff    	jne    802af1 <alloc_block_BF+0xc5>
  802c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c36:	0f 85 b5 fe ff ff    	jne    802af1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c40:	0f 84 26 02 00 00    	je     802e6c <alloc_block_BF+0x440>
  802c46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4a:	0f 85 1c 02 00 00    	jne    802e6c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	2b 45 08             	sub    0x8(%ebp),%eax
  802c56:	83 e8 08             	sub    $0x8,%eax
  802c59:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8d 50 08             	lea    0x8(%eax),%edx
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	83 c0 08             	add    $0x8,%eax
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	6a 01                	push   $0x1
  802c75:	50                   	push   %eax
  802c76:	ff 75 f0             	pushl  -0x10(%ebp)
  802c79:	e8 c3 f8 ff ff       	call   802541 <set_block_data>
  802c7e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	75 68                	jne    802cf3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c8b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_BF+0x27c>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 88 49 80 00       	push   $0x804988
  802c99:	68 45 01 00 00       	push   $0x145
  802c9e:	68 6d 49 80 00       	push   $0x80496d
  802ca3:	e8 58 da ff ff       	call   800700 <_panic>
  802ca8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802cae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0d                	je     802cc9 <alloc_block_BF+0x29d>
  802cbc:	a1 44 50 80 00       	mov    0x805044,%eax
  802cc1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	eb 08                	jmp    802cd1 <alloc_block_BF+0x2a5>
  802cc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccc:	a3 48 50 80 00       	mov    %eax,0x805048
  802cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd4:	a3 44 50 80 00       	mov    %eax,0x805044
  802cd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 50 50 80 00       	mov    0x805050,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 50 50 80 00       	mov    %eax,0x805050
  802cee:	e9 dc 00 00 00       	jmp    802dcf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	75 65                	jne    802d61 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cfc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_BF+0x2ed>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 bc 49 80 00       	push   $0x8049bc
  802d0a:	68 4a 01 00 00       	push   $0x14a
  802d0f:	68 6d 49 80 00       	push   $0x80496d
  802d14:	e8 e7 d9 ff ff       	call   800700 <_panic>
  802d19:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802d1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d22:	89 50 04             	mov    %edx,0x4(%eax)
  802d25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0c                	je     802d3b <alloc_block_BF+0x30f>
  802d2f:	a1 48 50 80 00       	mov    0x805048,%eax
  802d34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 08                	jmp    802d43 <alloc_block_BF+0x317>
  802d3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3e:	a3 44 50 80 00       	mov    %eax,0x805044
  802d43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d46:	a3 48 50 80 00       	mov    %eax,0x805048
  802d4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d54:	a1 50 50 80 00       	mov    0x805050,%eax
  802d59:	40                   	inc    %eax
  802d5a:	a3 50 50 80 00       	mov    %eax,0x805050
  802d5f:	eb 6e                	jmp    802dcf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d65:	74 06                	je     802d6d <alloc_block_BF+0x341>
  802d67:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d6b:	75 17                	jne    802d84 <alloc_block_BF+0x358>
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	68 e0 49 80 00       	push   $0x8049e0
  802d75:	68 4f 01 00 00       	push   $0x14f
  802d7a:	68 6d 49 80 00       	push   $0x80496d
  802d7f:	e8 7c d9 ff ff       	call   800700 <_panic>
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 10                	mov    (%eax),%edx
  802d89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0b                	je     802da2 <alloc_block_BF+0x376>
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802da8:	89 10                	mov    %edx,(%eax)
  802daa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db0:	89 50 04             	mov    %edx,0x4(%eax)
  802db3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	75 08                	jne    802dc4 <alloc_block_BF+0x398>
  802dbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dbf:	a3 48 50 80 00       	mov    %eax,0x805048
  802dc4:	a1 50 50 80 00       	mov    0x805050,%eax
  802dc9:	40                   	inc    %eax
  802dca:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802dcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd3:	75 17                	jne    802dec <alloc_block_BF+0x3c0>
  802dd5:	83 ec 04             	sub    $0x4,%esp
  802dd8:	68 4f 49 80 00       	push   $0x80494f
  802ddd:	68 51 01 00 00       	push   $0x151
  802de2:	68 6d 49 80 00       	push   $0x80496d
  802de7:	e8 14 d9 ff ff       	call   800700 <_panic>
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 10                	je     802e05 <alloc_block_BF+0x3d9>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfd:	8b 52 04             	mov    0x4(%edx),%edx
  802e00:	89 50 04             	mov    %edx,0x4(%eax)
  802e03:	eb 0b                	jmp    802e10 <alloc_block_BF+0x3e4>
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	a3 48 50 80 00       	mov    %eax,0x805048
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0f                	je     802e29 <alloc_block_BF+0x3fd>
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e23:	8b 12                	mov    (%edx),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	eb 0a                	jmp    802e33 <alloc_block_BF+0x407>
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	a3 44 50 80 00       	mov    %eax,0x805044
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e46:	a1 50 50 80 00       	mov    0x805050,%eax
  802e4b:	48                   	dec    %eax
  802e4c:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	6a 00                	push   $0x0
  802e56:	ff 75 d0             	pushl  -0x30(%ebp)
  802e59:	ff 75 cc             	pushl  -0x34(%ebp)
  802e5c:	e8 e0 f6 ff ff       	call   802541 <set_block_data>
  802e61:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	e9 a3 01 00 00       	jmp    80300f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802e6c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802e70:	0f 85 9d 00 00 00    	jne    802f13 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	6a 01                	push   $0x1
  802e7b:	ff 75 ec             	pushl  -0x14(%ebp)
  802e7e:	ff 75 f0             	pushl  -0x10(%ebp)
  802e81:	e8 bb f6 ff ff       	call   802541 <set_block_data>
  802e86:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802e89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8d:	75 17                	jne    802ea6 <alloc_block_BF+0x47a>
  802e8f:	83 ec 04             	sub    $0x4,%esp
  802e92:	68 4f 49 80 00       	push   $0x80494f
  802e97:	68 58 01 00 00       	push   $0x158
  802e9c:	68 6d 49 80 00       	push   $0x80496d
  802ea1:	e8 5a d8 ff ff       	call   800700 <_panic>
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 10                	je     802ebf <alloc_block_BF+0x493>
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb7:	8b 52 04             	mov    0x4(%edx),%edx
  802eba:	89 50 04             	mov    %edx,0x4(%eax)
  802ebd:	eb 0b                	jmp    802eca <alloc_block_BF+0x49e>
  802ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec2:	8b 40 04             	mov    0x4(%eax),%eax
  802ec5:	a3 48 50 80 00       	mov    %eax,0x805048
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 0f                	je     802ee3 <alloc_block_BF+0x4b7>
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edd:	8b 12                	mov    (%edx),%edx
  802edf:	89 10                	mov    %edx,(%eax)
  802ee1:	eb 0a                	jmp    802eed <alloc_block_BF+0x4c1>
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	a3 44 50 80 00       	mov    %eax,0x805044
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f00:	a1 50 50 80 00       	mov    0x805050,%eax
  802f05:	48                   	dec    %eax
  802f06:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	e9 fc 00 00 00       	jmp    80300f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	83 c0 08             	add    $0x8,%eax
  802f19:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f1c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f23:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f29:	01 d0                	add    %edx,%eax
  802f2b:	48                   	dec    %eax
  802f2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f32:	ba 00 00 00 00       	mov    $0x0,%edx
  802f37:	f7 75 c4             	divl   -0x3c(%ebp)
  802f3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f3d:	29 d0                	sub    %edx,%eax
  802f3f:	c1 e8 0c             	shr    $0xc,%eax
  802f42:	83 ec 0c             	sub    $0xc,%esp
  802f45:	50                   	push   %eax
  802f46:	e8 0c e8 ff ff       	call   801757 <sbrk>
  802f4b:	83 c4 10             	add    $0x10,%esp
  802f4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f51:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f55:	75 0a                	jne    802f61 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f57:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5c:	e9 ae 00 00 00       	jmp    80300f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f61:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802f68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f6e:	01 d0                	add    %edx,%eax
  802f70:	48                   	dec    %eax
  802f71:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802f74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f77:	ba 00 00 00 00       	mov    $0x0,%edx
  802f7c:	f7 75 b8             	divl   -0x48(%ebp)
  802f7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f82:	29 d0                	sub    %edx,%eax
  802f84:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f8a:	01 d0                	add    %edx,%eax
  802f8c:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  802f91:	a1 48 92 80 00       	mov    0x809248,%eax
  802f96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802f9c:	83 ec 0c             	sub    $0xc,%esp
  802f9f:	68 14 4a 80 00       	push   $0x804a14
  802fa4:	e8 14 da ff ff       	call   8009bd <cprintf>
  802fa9:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802fac:	83 ec 08             	sub    $0x8,%esp
  802faf:	ff 75 bc             	pushl  -0x44(%ebp)
  802fb2:	68 19 4a 80 00       	push   $0x804a19
  802fb7:	e8 01 da ff ff       	call   8009bd <cprintf>
  802fbc:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fbf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802fc6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fcc:	01 d0                	add    %edx,%eax
  802fce:	48                   	dec    %eax
  802fcf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802fd2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802fda:	f7 75 b0             	divl   -0x50(%ebp)
  802fdd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fe0:	29 d0                	sub    %edx,%eax
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	6a 01                	push   $0x1
  802fe7:	50                   	push   %eax
  802fe8:	ff 75 bc             	pushl  -0x44(%ebp)
  802feb:	e8 51 f5 ff ff       	call   802541 <set_block_data>
  802ff0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ff3:	83 ec 0c             	sub    $0xc,%esp
  802ff6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ff9:	e8 36 04 00 00       	call   803434 <free_block>
  802ffe:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803001:	83 ec 0c             	sub    $0xc,%esp
  803004:	ff 75 08             	pushl  0x8(%ebp)
  803007:	e8 20 fa ff ff       	call   802a2c <alloc_block_BF>
  80300c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80300f:	c9                   	leave  
  803010:	c3                   	ret    

00803011 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803011:	55                   	push   %ebp
  803012:	89 e5                	mov    %esp,%ebp
  803014:	53                   	push   %ebx
  803015:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80301f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803026:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302a:	74 1e                	je     80304a <merging+0x39>
  80302c:	ff 75 08             	pushl  0x8(%ebp)
  80302f:	e8 bc f1 ff ff       	call   8021f0 <get_block_size>
  803034:	83 c4 04             	add    $0x4,%esp
  803037:	89 c2                	mov    %eax,%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	01 d0                	add    %edx,%eax
  80303e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803041:	75 07                	jne    80304a <merging+0x39>
		prev_is_free = 1;
  803043:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80304a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80304e:	74 1e                	je     80306e <merging+0x5d>
  803050:	ff 75 10             	pushl  0x10(%ebp)
  803053:	e8 98 f1 ff ff       	call   8021f0 <get_block_size>
  803058:	83 c4 04             	add    $0x4,%esp
  80305b:	89 c2                	mov    %eax,%edx
  80305d:	8b 45 10             	mov    0x10(%ebp),%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803065:	75 07                	jne    80306e <merging+0x5d>
		next_is_free = 1;
  803067:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	0f 84 cc 00 00 00    	je     803144 <merging+0x133>
  803078:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307c:	0f 84 c2 00 00 00    	je     803144 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803082:	ff 75 08             	pushl  0x8(%ebp)
  803085:	e8 66 f1 ff ff       	call   8021f0 <get_block_size>
  80308a:	83 c4 04             	add    $0x4,%esp
  80308d:	89 c3                	mov    %eax,%ebx
  80308f:	ff 75 10             	pushl  0x10(%ebp)
  803092:	e8 59 f1 ff ff       	call   8021f0 <get_block_size>
  803097:	83 c4 04             	add    $0x4,%esp
  80309a:	01 c3                	add    %eax,%ebx
  80309c:	ff 75 0c             	pushl  0xc(%ebp)
  80309f:	e8 4c f1 ff ff       	call   8021f0 <get_block_size>
  8030a4:	83 c4 04             	add    $0x4,%esp
  8030a7:	01 d8                	add    %ebx,%eax
  8030a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030ac:	6a 00                	push   $0x0
  8030ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8030b1:	ff 75 08             	pushl  0x8(%ebp)
  8030b4:	e8 88 f4 ff ff       	call   802541 <set_block_data>
  8030b9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8030bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c0:	75 17                	jne    8030d9 <merging+0xc8>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 4f 49 80 00       	push   $0x80494f
  8030ca:	68 7d 01 00 00       	push   $0x17d
  8030cf:	68 6d 49 80 00       	push   $0x80496d
  8030d4:	e8 27 d6 ff ff       	call   800700 <_panic>
  8030d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 10                	je     8030f2 <merging+0xe1>
  8030e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ea:	8b 52 04             	mov    0x4(%edx),%edx
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	eb 0b                	jmp    8030fd <merging+0xec>
  8030f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	a3 48 50 80 00       	mov    %eax,0x805048
  8030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 0f                	je     803116 <merging+0x105>
  803107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803110:	8b 12                	mov    (%edx),%edx
  803112:	89 10                	mov    %edx,(%eax)
  803114:	eb 0a                	jmp    803120 <merging+0x10f>
  803116:	8b 45 0c             	mov    0xc(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	a3 44 50 80 00       	mov    %eax,0x805044
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 50 50 80 00       	mov    0x805050,%eax
  803138:	48                   	dec    %eax
  803139:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80313e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80313f:	e9 ea 02 00 00       	jmp    80342e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803148:	74 3b                	je     803185 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	ff 75 08             	pushl  0x8(%ebp)
  803150:	e8 9b f0 ff ff       	call   8021f0 <get_block_size>
  803155:	83 c4 10             	add    $0x10,%esp
  803158:	89 c3                	mov    %eax,%ebx
  80315a:	83 ec 0c             	sub    $0xc,%esp
  80315d:	ff 75 10             	pushl  0x10(%ebp)
  803160:	e8 8b f0 ff ff       	call   8021f0 <get_block_size>
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	01 d8                	add    %ebx,%eax
  80316a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	6a 00                	push   $0x0
  803172:	ff 75 e8             	pushl  -0x18(%ebp)
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	e8 c4 f3 ff ff       	call   802541 <set_block_data>
  80317d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803180:	e9 a9 02 00 00       	jmp    80342e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803185:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803189:	0f 84 2d 01 00 00    	je     8032bc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80318f:	83 ec 0c             	sub    $0xc,%esp
  803192:	ff 75 10             	pushl  0x10(%ebp)
  803195:	e8 56 f0 ff ff       	call   8021f0 <get_block_size>
  80319a:	83 c4 10             	add    $0x10,%esp
  80319d:	89 c3                	mov    %eax,%ebx
  80319f:	83 ec 0c             	sub    $0xc,%esp
  8031a2:	ff 75 0c             	pushl  0xc(%ebp)
  8031a5:	e8 46 f0 ff ff       	call   8021f0 <get_block_size>
  8031aa:	83 c4 10             	add    $0x10,%esp
  8031ad:	01 d8                	add    %ebx,%eax
  8031af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	6a 00                	push   $0x0
  8031b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031ba:	ff 75 10             	pushl  0x10(%ebp)
  8031bd:	e8 7f f3 ff ff       	call   802541 <set_block_data>
  8031c2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8031c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8031c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8031cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031cf:	74 06                	je     8031d7 <merging+0x1c6>
  8031d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031d5:	75 17                	jne    8031ee <merging+0x1dd>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 28 4a 80 00       	push   $0x804a28
  8031df:	68 8d 01 00 00       	push   $0x18d
  8031e4:	68 6d 49 80 00       	push   $0x80496d
  8031e9:	e8 12 d5 ff ff       	call   800700 <_panic>
  8031ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f1:	8b 50 04             	mov    0x4(%eax),%edx
  8031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f7:	89 50 04             	mov    %edx,0x4(%eax)
  8031fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803200:	89 10                	mov    %edx,(%eax)
  803202:	8b 45 0c             	mov    0xc(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <merging+0x208>
  80320c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320f:	8b 40 04             	mov    0x4(%eax),%eax
  803212:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803215:	89 10                	mov    %edx,(%eax)
  803217:	eb 08                	jmp    803221 <merging+0x210>
  803219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321c:	a3 44 50 80 00       	mov    %eax,0x805044
  803221:	8b 45 0c             	mov    0xc(%ebp),%eax
  803224:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	a1 50 50 80 00       	mov    0x805050,%eax
  80322f:	40                   	inc    %eax
  803230:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  803235:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803239:	75 17                	jne    803252 <merging+0x241>
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	68 4f 49 80 00       	push   $0x80494f
  803243:	68 8e 01 00 00       	push   $0x18e
  803248:	68 6d 49 80 00       	push   $0x80496d
  80324d:	e8 ae d4 ff ff       	call   800700 <_panic>
  803252:	8b 45 0c             	mov    0xc(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 10                	je     80326b <merging+0x25a>
  80325b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	8b 55 0c             	mov    0xc(%ebp),%edx
  803263:	8b 52 04             	mov    0x4(%edx),%edx
  803266:	89 50 04             	mov    %edx,0x4(%eax)
  803269:	eb 0b                	jmp    803276 <merging+0x265>
  80326b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326e:	8b 40 04             	mov    0x4(%eax),%eax
  803271:	a3 48 50 80 00       	mov    %eax,0x805048
  803276:	8b 45 0c             	mov    0xc(%ebp),%eax
  803279:	8b 40 04             	mov    0x4(%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 0f                	je     80328f <merging+0x27e>
  803280:	8b 45 0c             	mov    0xc(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	8b 55 0c             	mov    0xc(%ebp),%edx
  803289:	8b 12                	mov    (%edx),%edx
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	eb 0a                	jmp    803299 <merging+0x288>
  80328f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803292:	8b 00                	mov    (%eax),%eax
  803294:	a3 44 50 80 00       	mov    %eax,0x805044
  803299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8032b1:	48                   	dec    %eax
  8032b2:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032b7:	e9 72 01 00 00       	jmp    80342e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8032bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8032bf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8032c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c6:	74 79                	je     803341 <merging+0x330>
  8032c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032cc:	74 73                	je     803341 <merging+0x330>
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	74 06                	je     8032da <merging+0x2c9>
  8032d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032d8:	75 17                	jne    8032f1 <merging+0x2e0>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 e0 49 80 00       	push   $0x8049e0
  8032e2:	68 94 01 00 00       	push   $0x194
  8032e7:	68 6d 49 80 00       	push   $0x80496d
  8032ec:	e8 0f d4 ff ff       	call   800700 <_panic>
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 10                	mov    (%eax),%edx
  8032f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 0b                	je     80330f <merging+0x2fe>
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803315:	89 10                	mov    %edx,(%eax)
  803317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331a:	8b 55 08             	mov    0x8(%ebp),%edx
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803323:	8b 00                	mov    (%eax),%eax
  803325:	85 c0                	test   %eax,%eax
  803327:	75 08                	jne    803331 <merging+0x320>
  803329:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80332c:	a3 48 50 80 00       	mov    %eax,0x805048
  803331:	a1 50 50 80 00       	mov    0x805050,%eax
  803336:	40                   	inc    %eax
  803337:	a3 50 50 80 00       	mov    %eax,0x805050
  80333c:	e9 ce 00 00 00       	jmp    80340f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803345:	74 65                	je     8033ac <merging+0x39b>
  803347:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80334b:	75 17                	jne    803364 <merging+0x353>
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	68 bc 49 80 00       	push   $0x8049bc
  803355:	68 95 01 00 00       	push   $0x195
  80335a:	68 6d 49 80 00       	push   $0x80496d
  80335f:	e8 9c d3 ff ff       	call   800700 <_panic>
  803364:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80336a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0c                	je     803386 <merging+0x375>
  80337a:	a1 48 50 80 00       	mov    0x805048,%eax
  80337f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	eb 08                	jmp    80338e <merging+0x37d>
  803386:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803389:	a3 44 50 80 00       	mov    %eax,0x805044
  80338e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803391:	a3 48 50 80 00       	mov    %eax,0x805048
  803396:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339f:	a1 50 50 80 00       	mov    0x805050,%eax
  8033a4:	40                   	inc    %eax
  8033a5:	a3 50 50 80 00       	mov    %eax,0x805050
  8033aa:	eb 63                	jmp    80340f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8033ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033b0:	75 17                	jne    8033c9 <merging+0x3b8>
  8033b2:	83 ec 04             	sub    $0x4,%esp
  8033b5:	68 88 49 80 00       	push   $0x804988
  8033ba:	68 98 01 00 00       	push   $0x198
  8033bf:	68 6d 49 80 00       	push   $0x80496d
  8033c4:	e8 37 d3 ff ff       	call   800700 <_panic>
  8033c9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8033cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d2:	89 10                	mov    %edx,(%eax)
  8033d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 0d                	je     8033ea <merging+0x3d9>
  8033dd:	a1 44 50 80 00       	mov    0x805044,%eax
  8033e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	eb 08                	jmp    8033f2 <merging+0x3e1>
  8033ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ed:	a3 48 50 80 00       	mov    %eax,0x805048
  8033f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8033fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803404:	a1 50 50 80 00       	mov    0x805050,%eax
  803409:	40                   	inc    %eax
  80340a:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  80340f:	83 ec 0c             	sub    $0xc,%esp
  803412:	ff 75 10             	pushl  0x10(%ebp)
  803415:	e8 d6 ed ff ff       	call   8021f0 <get_block_size>
  80341a:	83 c4 10             	add    $0x10,%esp
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	6a 00                	push   $0x0
  803422:	50                   	push   %eax
  803423:	ff 75 10             	pushl  0x10(%ebp)
  803426:	e8 16 f1 ff ff       	call   802541 <set_block_data>
  80342b:	83 c4 10             	add    $0x10,%esp
	}
}
  80342e:	90                   	nop
  80342f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803432:	c9                   	leave  
  803433:	c3                   	ret    

00803434 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803434:	55                   	push   %ebp
  803435:	89 e5                	mov    %esp,%ebp
  803437:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80343a:	a1 44 50 80 00       	mov    0x805044,%eax
  80343f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803442:	a1 48 50 80 00       	mov    0x805048,%eax
  803447:	3b 45 08             	cmp    0x8(%ebp),%eax
  80344a:	73 1b                	jae    803467 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80344c:	a1 48 50 80 00       	mov    0x805048,%eax
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	ff 75 08             	pushl  0x8(%ebp)
  803457:	6a 00                	push   $0x0
  803459:	50                   	push   %eax
  80345a:	e8 b2 fb ff ff       	call   803011 <merging>
  80345f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803462:	e9 8b 00 00 00       	jmp    8034f2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803467:	a1 44 50 80 00       	mov    0x805044,%eax
  80346c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346f:	76 18                	jbe    803489 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803471:	a1 44 50 80 00       	mov    0x805044,%eax
  803476:	83 ec 04             	sub    $0x4,%esp
  803479:	ff 75 08             	pushl  0x8(%ebp)
  80347c:	50                   	push   %eax
  80347d:	6a 00                	push   $0x0
  80347f:	e8 8d fb ff ff       	call   803011 <merging>
  803484:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803487:	eb 69                	jmp    8034f2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803489:	a1 44 50 80 00       	mov    0x805044,%eax
  80348e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803491:	eb 39                	jmp    8034cc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	3b 45 08             	cmp    0x8(%ebp),%eax
  803499:	73 29                	jae    8034c4 <free_block+0x90>
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a3:	76 1f                	jbe    8034c4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8034ad:	83 ec 04             	sub    $0x4,%esp
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8034b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8034b9:	e8 53 fb ff ff       	call   803011 <merging>
  8034be:	83 c4 10             	add    $0x10,%esp
			break;
  8034c1:	90                   	nop
		}
	}
}
  8034c2:	eb 2e                	jmp    8034f2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8034c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d0:	74 07                	je     8034d9 <free_block+0xa5>
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	eb 05                	jmp    8034de <free_block+0xaa>
  8034d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034de:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8034e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	75 a7                	jne    803493 <free_block+0x5f>
  8034ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f0:	75 a1                	jne    803493 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034f2:	90                   	nop
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    

008034f5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8034f5:	55                   	push   %ebp
  8034f6:	89 e5                	mov    %esp,%ebp
  8034f8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8034fb:	ff 75 08             	pushl  0x8(%ebp)
  8034fe:	e8 ed ec ff ff       	call   8021f0 <get_block_size>
  803503:	83 c4 04             	add    $0x4,%esp
  803506:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803509:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803510:	eb 17                	jmp    803529 <copy_data+0x34>
  803512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803515:	8b 45 0c             	mov    0xc(%ebp),%eax
  803518:	01 c2                	add    %eax,%edx
  80351a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	01 c8                	add    %ecx,%eax
  803522:	8a 00                	mov    (%eax),%al
  803524:	88 02                	mov    %al,(%edx)
  803526:	ff 45 fc             	incl   -0x4(%ebp)
  803529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80352c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80352f:	72 e1                	jb     803512 <copy_data+0x1d>
}
  803531:	90                   	nop
  803532:	c9                   	leave  
  803533:	c3                   	ret    

00803534 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80353a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353e:	75 23                	jne    803563 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803540:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803544:	74 13                	je     803559 <realloc_block_FF+0x25>
  803546:	83 ec 0c             	sub    $0xc,%esp
  803549:	ff 75 0c             	pushl  0xc(%ebp)
  80354c:	e8 1f f0 ff ff       	call   802570 <alloc_block_FF>
  803551:	83 c4 10             	add    $0x10,%esp
  803554:	e9 f4 06 00 00       	jmp    803c4d <realloc_block_FF+0x719>
		return NULL;
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	e9 ea 06 00 00       	jmp    803c4d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803567:	75 18                	jne    803581 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803569:	83 ec 0c             	sub    $0xc,%esp
  80356c:	ff 75 08             	pushl  0x8(%ebp)
  80356f:	e8 c0 fe ff ff       	call   803434 <free_block>
  803574:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
  80357c:	e9 cc 06 00 00       	jmp    803c4d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803581:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803585:	77 07                	ja     80358e <realloc_block_FF+0x5a>
  803587:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80358e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803591:	83 e0 01             	and    $0x1,%eax
  803594:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359a:	83 c0 08             	add    $0x8,%eax
  80359d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8035a0:	83 ec 0c             	sub    $0xc,%esp
  8035a3:	ff 75 08             	pushl  0x8(%ebp)
  8035a6:	e8 45 ec ff ff       	call   8021f0 <get_block_size>
  8035ab:	83 c4 10             	add    $0x10,%esp
  8035ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b4:	83 e8 08             	sub    $0x8,%eax
  8035b7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	83 e8 04             	sub    $0x4,%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	83 e0 fe             	and    $0xfffffffe,%eax
  8035c5:	89 c2                	mov    %eax,%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	01 d0                	add    %edx,%eax
  8035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8035cf:	83 ec 0c             	sub    $0xc,%esp
  8035d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d5:	e8 16 ec ff ff       	call   8021f0 <get_block_size>
  8035da:	83 c4 10             	add    $0x10,%esp
  8035dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e3:	83 e8 08             	sub    $0x8,%eax
  8035e6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8035e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035ef:	75 08                	jne    8035f9 <realloc_block_FF+0xc5>
	{
		 return va;
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	e9 54 06 00 00       	jmp    803c4d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8035f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035ff:	0f 83 e5 03 00 00    	jae    8039ea <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803608:	2b 45 0c             	sub    0xc(%ebp),%eax
  80360b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80360e:	83 ec 0c             	sub    $0xc,%esp
  803611:	ff 75 e4             	pushl  -0x1c(%ebp)
  803614:	e8 f0 eb ff ff       	call   802209 <is_free_block>
  803619:	83 c4 10             	add    $0x10,%esp
  80361c:	84 c0                	test   %al,%al
  80361e:	0f 84 3b 01 00 00    	je     80375f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803624:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80362a:	01 d0                	add    %edx,%eax
  80362c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80362f:	83 ec 04             	sub    $0x4,%esp
  803632:	6a 01                	push   $0x1
  803634:	ff 75 f0             	pushl  -0x10(%ebp)
  803637:	ff 75 08             	pushl  0x8(%ebp)
  80363a:	e8 02 ef ff ff       	call   802541 <set_block_data>
  80363f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	83 e8 04             	sub    $0x4,%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	83 e0 fe             	and    $0xfffffffe,%eax
  80364d:	89 c2                	mov    %eax,%edx
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	01 d0                	add    %edx,%eax
  803654:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	6a 00                	push   $0x0
  80365c:	ff 75 cc             	pushl  -0x34(%ebp)
  80365f:	ff 75 c8             	pushl  -0x38(%ebp)
  803662:	e8 da ee ff ff       	call   802541 <set_block_data>
  803667:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80366a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80366e:	74 06                	je     803676 <realloc_block_FF+0x142>
  803670:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803674:	75 17                	jne    80368d <realloc_block_FF+0x159>
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	68 e0 49 80 00       	push   $0x8049e0
  80367e:	68 f6 01 00 00       	push   $0x1f6
  803683:	68 6d 49 80 00       	push   $0x80496d
  803688:	e8 73 d0 ff ff       	call   800700 <_panic>
  80368d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803690:	8b 10                	mov    (%eax),%edx
  803692:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803695:	89 10                	mov    %edx,(%eax)
  803697:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 0b                	je     8036ab <realloc_block_FF+0x177>
  8036a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036b1:	89 10                	mov    %edx,(%eax)
  8036b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b9:	89 50 04             	mov    %edx,0x4(%eax)
  8036bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	85 c0                	test   %eax,%eax
  8036c3:	75 08                	jne    8036cd <realloc_block_FF+0x199>
  8036c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036c8:	a3 48 50 80 00       	mov    %eax,0x805048
  8036cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8036d2:	40                   	inc    %eax
  8036d3:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036dc:	75 17                	jne    8036f5 <realloc_block_FF+0x1c1>
  8036de:	83 ec 04             	sub    $0x4,%esp
  8036e1:	68 4f 49 80 00       	push   $0x80494f
  8036e6:	68 f7 01 00 00       	push   $0x1f7
  8036eb:	68 6d 49 80 00       	push   $0x80496d
  8036f0:	e8 0b d0 ff ff       	call   800700 <_panic>
  8036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	85 c0                	test   %eax,%eax
  8036fc:	74 10                	je     80370e <realloc_block_FF+0x1da>
  8036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803706:	8b 52 04             	mov    0x4(%edx),%edx
  803709:	89 50 04             	mov    %edx,0x4(%eax)
  80370c:	eb 0b                	jmp    803719 <realloc_block_FF+0x1e5>
  80370e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	a3 48 50 80 00       	mov    %eax,0x805048
  803719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371c:	8b 40 04             	mov    0x4(%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	74 0f                	je     803732 <realloc_block_FF+0x1fe>
  803723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803726:	8b 40 04             	mov    0x4(%eax),%eax
  803729:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80372c:	8b 12                	mov    (%edx),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	eb 0a                	jmp    80373c <realloc_block_FF+0x208>
  803732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	a3 44 50 80 00       	mov    %eax,0x805044
  80373c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374f:	a1 50 50 80 00       	mov    0x805050,%eax
  803754:	48                   	dec    %eax
  803755:	a3 50 50 80 00       	mov    %eax,0x805050
  80375a:	e9 83 02 00 00       	jmp    8039e2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80375f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803763:	0f 86 69 02 00 00    	jbe    8039d2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	6a 01                	push   $0x1
  80376e:	ff 75 f0             	pushl  -0x10(%ebp)
  803771:	ff 75 08             	pushl  0x8(%ebp)
  803774:	e8 c8 ed ff ff       	call   802541 <set_block_data>
  803779:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	83 e8 04             	sub    $0x4,%eax
  803782:	8b 00                	mov    (%eax),%eax
  803784:	83 e0 fe             	and    $0xfffffffe,%eax
  803787:	89 c2                	mov    %eax,%edx
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	01 d0                	add    %edx,%eax
  80378e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803791:	a1 50 50 80 00       	mov    0x805050,%eax
  803796:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803799:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80379d:	75 68                	jne    803807 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80379f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037a3:	75 17                	jne    8037bc <realloc_block_FF+0x288>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 88 49 80 00       	push   $0x804988
  8037ad:	68 06 02 00 00       	push   $0x206
  8037b2:	68 6d 49 80 00       	push   $0x80496d
  8037b7:	e8 44 cf ff ff       	call   800700 <_panic>
  8037bc:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8037c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c5:	89 10                	mov    %edx,(%eax)
  8037c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	85 c0                	test   %eax,%eax
  8037ce:	74 0d                	je     8037dd <realloc_block_FF+0x2a9>
  8037d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8037d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037d8:	89 50 04             	mov    %edx,0x4(%eax)
  8037db:	eb 08                	jmp    8037e5 <realloc_block_FF+0x2b1>
  8037dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e0:	a3 48 50 80 00       	mov    %eax,0x805048
  8037e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e8:	a3 44 50 80 00       	mov    %eax,0x805044
  8037ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f7:	a1 50 50 80 00       	mov    0x805050,%eax
  8037fc:	40                   	inc    %eax
  8037fd:	a3 50 50 80 00       	mov    %eax,0x805050
  803802:	e9 b0 01 00 00       	jmp    8039b7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803807:	a1 44 50 80 00       	mov    0x805044,%eax
  80380c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80380f:	76 68                	jbe    803879 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803811:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803815:	75 17                	jne    80382e <realloc_block_FF+0x2fa>
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 88 49 80 00       	push   $0x804988
  80381f:	68 0b 02 00 00       	push   $0x20b
  803824:	68 6d 49 80 00       	push   $0x80496d
  803829:	e8 d2 ce ff ff       	call   800700 <_panic>
  80382e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803837:	89 10                	mov    %edx,(%eax)
  803839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	74 0d                	je     80384f <realloc_block_FF+0x31b>
  803842:	a1 44 50 80 00       	mov    0x805044,%eax
  803847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	eb 08                	jmp    803857 <realloc_block_FF+0x323>
  80384f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803852:	a3 48 50 80 00       	mov    %eax,0x805048
  803857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385a:	a3 44 50 80 00       	mov    %eax,0x805044
  80385f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803869:	a1 50 50 80 00       	mov    0x805050,%eax
  80386e:	40                   	inc    %eax
  80386f:	a3 50 50 80 00       	mov    %eax,0x805050
  803874:	e9 3e 01 00 00       	jmp    8039b7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803879:	a1 44 50 80 00       	mov    0x805044,%eax
  80387e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803881:	73 68                	jae    8038eb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803883:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803887:	75 17                	jne    8038a0 <realloc_block_FF+0x36c>
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	68 bc 49 80 00       	push   $0x8049bc
  803891:	68 10 02 00 00       	push   $0x210
  803896:	68 6d 49 80 00       	push   $0x80496d
  80389b:	e8 60 ce ff ff       	call   800700 <_panic>
  8038a0:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8038a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a9:	89 50 04             	mov    %edx,0x4(%eax)
  8038ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038af:	8b 40 04             	mov    0x4(%eax),%eax
  8038b2:	85 c0                	test   %eax,%eax
  8038b4:	74 0c                	je     8038c2 <realloc_block_FF+0x38e>
  8038b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8038bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038be:	89 10                	mov    %edx,(%eax)
  8038c0:	eb 08                	jmp    8038ca <realloc_block_FF+0x396>
  8038c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8038ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8038d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038db:	a1 50 50 80 00       	mov    0x805050,%eax
  8038e0:	40                   	inc    %eax
  8038e1:	a3 50 50 80 00       	mov    %eax,0x805050
  8038e6:	e9 cc 00 00 00       	jmp    8039b7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8038eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8038f2:	a1 44 50 80 00       	mov    0x805044,%eax
  8038f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038fa:	e9 8a 00 00 00       	jmp    803989 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803905:	73 7a                	jae    803981 <realloc_block_FF+0x44d>
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80390f:	73 70                	jae    803981 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803915:	74 06                	je     80391d <realloc_block_FF+0x3e9>
  803917:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80391b:	75 17                	jne    803934 <realloc_block_FF+0x400>
  80391d:	83 ec 04             	sub    $0x4,%esp
  803920:	68 e0 49 80 00       	push   $0x8049e0
  803925:	68 1a 02 00 00       	push   $0x21a
  80392a:	68 6d 49 80 00       	push   $0x80496d
  80392f:	e8 cc cd ff ff       	call   800700 <_panic>
  803934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803937:	8b 10                	mov    (%eax),%edx
  803939:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80393c:	89 10                	mov    %edx,(%eax)
  80393e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 0b                	je     803952 <realloc_block_FF+0x41e>
  803947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394a:	8b 00                	mov    (%eax),%eax
  80394c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80394f:	89 50 04             	mov    %edx,0x4(%eax)
  803952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803955:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80395d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803960:	89 50 04             	mov    %edx,0x4(%eax)
  803963:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	85 c0                	test   %eax,%eax
  80396a:	75 08                	jne    803974 <realloc_block_FF+0x440>
  80396c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396f:	a3 48 50 80 00       	mov    %eax,0x805048
  803974:	a1 50 50 80 00       	mov    0x805050,%eax
  803979:	40                   	inc    %eax
  80397a:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  80397f:	eb 36                	jmp    8039b7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803981:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398d:	74 07                	je     803996 <realloc_block_FF+0x462>
  80398f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	eb 05                	jmp    80399b <realloc_block_FF+0x467>
  803996:	b8 00 00 00 00       	mov    $0x0,%eax
  80399b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8039a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039a5:	85 c0                	test   %eax,%eax
  8039a7:	0f 85 52 ff ff ff    	jne    8038ff <realloc_block_FF+0x3cb>
  8039ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b1:	0f 85 48 ff ff ff    	jne    8038ff <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	6a 00                	push   $0x0
  8039bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8039bf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039c2:	e8 7a eb ff ff       	call   802541 <set_block_data>
  8039c7:	83 c4 10             	add    $0x10,%esp
				return va;
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	e9 7b 02 00 00       	jmp    803c4d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8039d2:	83 ec 0c             	sub    $0xc,%esp
  8039d5:	68 5d 4a 80 00       	push   $0x804a5d
  8039da:	e8 de cf ff ff       	call   8009bd <cprintf>
  8039df:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	e9 63 02 00 00       	jmp    803c4d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8039ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039f0:	0f 86 4d 02 00 00    	jbe    803c43 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8039f6:	83 ec 0c             	sub    $0xc,%esp
  8039f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039fc:	e8 08 e8 ff ff       	call   802209 <is_free_block>
  803a01:	83 c4 10             	add    $0x10,%esp
  803a04:	84 c0                	test   %al,%al
  803a06:	0f 84 37 02 00 00    	je     803c43 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a15:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a18:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a1b:	76 38                	jbe    803a55 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a1d:	83 ec 0c             	sub    $0xc,%esp
  803a20:	ff 75 08             	pushl  0x8(%ebp)
  803a23:	e8 0c fa ff ff       	call   803434 <free_block>
  803a28:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a2b:	83 ec 0c             	sub    $0xc,%esp
  803a2e:	ff 75 0c             	pushl  0xc(%ebp)
  803a31:	e8 3a eb ff ff       	call   802570 <alloc_block_FF>
  803a36:	83 c4 10             	add    $0x10,%esp
  803a39:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a3c:	83 ec 08             	sub    $0x8,%esp
  803a3f:	ff 75 c0             	pushl  -0x40(%ebp)
  803a42:	ff 75 08             	pushl  0x8(%ebp)
  803a45:	e8 ab fa ff ff       	call   8034f5 <copy_data>
  803a4a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a50:	e9 f8 01 00 00       	jmp    803c4d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a58:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803a5b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803a5e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803a62:	0f 87 a0 00 00 00    	ja     803b08 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803a68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a6c:	75 17                	jne    803a85 <realloc_block_FF+0x551>
  803a6e:	83 ec 04             	sub    $0x4,%esp
  803a71:	68 4f 49 80 00       	push   $0x80494f
  803a76:	68 38 02 00 00       	push   $0x238
  803a7b:	68 6d 49 80 00       	push   $0x80496d
  803a80:	e8 7b cc ff ff       	call   800700 <_panic>
  803a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a88:	8b 00                	mov    (%eax),%eax
  803a8a:	85 c0                	test   %eax,%eax
  803a8c:	74 10                	je     803a9e <realloc_block_FF+0x56a>
  803a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a91:	8b 00                	mov    (%eax),%eax
  803a93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a96:	8b 52 04             	mov    0x4(%edx),%edx
  803a99:	89 50 04             	mov    %edx,0x4(%eax)
  803a9c:	eb 0b                	jmp    803aa9 <realloc_block_FF+0x575>
  803a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa1:	8b 40 04             	mov    0x4(%eax),%eax
  803aa4:	a3 48 50 80 00       	mov    %eax,0x805048
  803aa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aac:	8b 40 04             	mov    0x4(%eax),%eax
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	74 0f                	je     803ac2 <realloc_block_FF+0x58e>
  803ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab6:	8b 40 04             	mov    0x4(%eax),%eax
  803ab9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803abc:	8b 12                	mov    (%edx),%edx
  803abe:	89 10                	mov    %edx,(%eax)
  803ac0:	eb 0a                	jmp    803acc <realloc_block_FF+0x598>
  803ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac5:	8b 00                	mov    (%eax),%eax
  803ac7:	a3 44 50 80 00       	mov    %eax,0x805044
  803acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adf:	a1 50 50 80 00       	mov    0x805050,%eax
  803ae4:	48                   	dec    %eax
  803ae5:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803aea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af0:	01 d0                	add    %edx,%eax
  803af2:	83 ec 04             	sub    $0x4,%esp
  803af5:	6a 01                	push   $0x1
  803af7:	50                   	push   %eax
  803af8:	ff 75 08             	pushl  0x8(%ebp)
  803afb:	e8 41 ea ff ff       	call   802541 <set_block_data>
  803b00:	83 c4 10             	add    $0x10,%esp
  803b03:	e9 36 01 00 00       	jmp    803c3e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b0e:	01 d0                	add    %edx,%eax
  803b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b13:	83 ec 04             	sub    $0x4,%esp
  803b16:	6a 01                	push   $0x1
  803b18:	ff 75 f0             	pushl  -0x10(%ebp)
  803b1b:	ff 75 08             	pushl  0x8(%ebp)
  803b1e:	e8 1e ea ff ff       	call   802541 <set_block_data>
  803b23:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b26:	8b 45 08             	mov    0x8(%ebp),%eax
  803b29:	83 e8 04             	sub    $0x4,%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	83 e0 fe             	and    $0xfffffffe,%eax
  803b31:	89 c2                	mov    %eax,%edx
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	01 d0                	add    %edx,%eax
  803b38:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b3f:	74 06                	je     803b47 <realloc_block_FF+0x613>
  803b41:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b45:	75 17                	jne    803b5e <realloc_block_FF+0x62a>
  803b47:	83 ec 04             	sub    $0x4,%esp
  803b4a:	68 e0 49 80 00       	push   $0x8049e0
  803b4f:	68 44 02 00 00       	push   $0x244
  803b54:	68 6d 49 80 00       	push   $0x80496d
  803b59:	e8 a2 cb ff ff       	call   800700 <_panic>
  803b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b61:	8b 10                	mov    (%eax),%edx
  803b63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b66:	89 10                	mov    %edx,(%eax)
  803b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 0b                	je     803b7c <realloc_block_FF+0x648>
  803b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b74:	8b 00                	mov    (%eax),%eax
  803b76:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b79:	89 50 04             	mov    %edx,0x4(%eax)
  803b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b82:	89 10                	mov    %edx,(%eax)
  803b84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b8a:	89 50 04             	mov    %edx,0x4(%eax)
  803b8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b90:	8b 00                	mov    (%eax),%eax
  803b92:	85 c0                	test   %eax,%eax
  803b94:	75 08                	jne    803b9e <realloc_block_FF+0x66a>
  803b96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b99:	a3 48 50 80 00       	mov    %eax,0x805048
  803b9e:	a1 50 50 80 00       	mov    0x805050,%eax
  803ba3:	40                   	inc    %eax
  803ba4:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bad:	75 17                	jne    803bc6 <realloc_block_FF+0x692>
  803baf:	83 ec 04             	sub    $0x4,%esp
  803bb2:	68 4f 49 80 00       	push   $0x80494f
  803bb7:	68 45 02 00 00       	push   $0x245
  803bbc:	68 6d 49 80 00       	push   $0x80496d
  803bc1:	e8 3a cb ff ff       	call   800700 <_panic>
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	74 10                	je     803bdf <realloc_block_FF+0x6ab>
  803bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd2:	8b 00                	mov    (%eax),%eax
  803bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd7:	8b 52 04             	mov    0x4(%edx),%edx
  803bda:	89 50 04             	mov    %edx,0x4(%eax)
  803bdd:	eb 0b                	jmp    803bea <realloc_block_FF+0x6b6>
  803bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be2:	8b 40 04             	mov    0x4(%eax),%eax
  803be5:	a3 48 50 80 00       	mov    %eax,0x805048
  803bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bed:	8b 40 04             	mov    0x4(%eax),%eax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	74 0f                	je     803c03 <realloc_block_FF+0x6cf>
  803bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf7:	8b 40 04             	mov    0x4(%eax),%eax
  803bfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bfd:	8b 12                	mov    (%edx),%edx
  803bff:	89 10                	mov    %edx,(%eax)
  803c01:	eb 0a                	jmp    803c0d <realloc_block_FF+0x6d9>
  803c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c06:	8b 00                	mov    (%eax),%eax
  803c08:	a3 44 50 80 00       	mov    %eax,0x805044
  803c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c20:	a1 50 50 80 00       	mov    0x805050,%eax
  803c25:	48                   	dec    %eax
  803c26:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803c2b:	83 ec 04             	sub    $0x4,%esp
  803c2e:	6a 00                	push   $0x0
  803c30:	ff 75 bc             	pushl  -0x44(%ebp)
  803c33:	ff 75 b8             	pushl  -0x48(%ebp)
  803c36:	e8 06 e9 ff ff       	call   802541 <set_block_data>
  803c3b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c41:	eb 0a                	jmp    803c4d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c43:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c4d:	c9                   	leave  
  803c4e:	c3                   	ret    

00803c4f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c4f:	55                   	push   %ebp
  803c50:	89 e5                	mov    %esp,%ebp
  803c52:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c55:	83 ec 04             	sub    $0x4,%esp
  803c58:	68 64 4a 80 00       	push   $0x804a64
  803c5d:	68 58 02 00 00       	push   $0x258
  803c62:	68 6d 49 80 00       	push   $0x80496d
  803c67:	e8 94 ca ff ff       	call   800700 <_panic>

00803c6c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c6c:	55                   	push   %ebp
  803c6d:	89 e5                	mov    %esp,%ebp
  803c6f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c72:	83 ec 04             	sub    $0x4,%esp
  803c75:	68 8c 4a 80 00       	push   $0x804a8c
  803c7a:	68 61 02 00 00       	push   $0x261
  803c7f:	68 6d 49 80 00       	push   $0x80496d
  803c84:	e8 77 ca ff ff       	call   800700 <_panic>
  803c89:	66 90                	xchg   %ax,%ax
  803c8b:	90                   	nop

00803c8c <__udivdi3>:
  803c8c:	55                   	push   %ebp
  803c8d:	57                   	push   %edi
  803c8e:	56                   	push   %esi
  803c8f:	53                   	push   %ebx
  803c90:	83 ec 1c             	sub    $0x1c,%esp
  803c93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ca3:	89 ca                	mov    %ecx,%edx
  803ca5:	89 f8                	mov    %edi,%eax
  803ca7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cab:	85 f6                	test   %esi,%esi
  803cad:	75 2d                	jne    803cdc <__udivdi3+0x50>
  803caf:	39 cf                	cmp    %ecx,%edi
  803cb1:	77 65                	ja     803d18 <__udivdi3+0x8c>
  803cb3:	89 fd                	mov    %edi,%ebp
  803cb5:	85 ff                	test   %edi,%edi
  803cb7:	75 0b                	jne    803cc4 <__udivdi3+0x38>
  803cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cbe:	31 d2                	xor    %edx,%edx
  803cc0:	f7 f7                	div    %edi
  803cc2:	89 c5                	mov    %eax,%ebp
  803cc4:	31 d2                	xor    %edx,%edx
  803cc6:	89 c8                	mov    %ecx,%eax
  803cc8:	f7 f5                	div    %ebp
  803cca:	89 c1                	mov    %eax,%ecx
  803ccc:	89 d8                	mov    %ebx,%eax
  803cce:	f7 f5                	div    %ebp
  803cd0:	89 cf                	mov    %ecx,%edi
  803cd2:	89 fa                	mov    %edi,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	39 ce                	cmp    %ecx,%esi
  803cde:	77 28                	ja     803d08 <__udivdi3+0x7c>
  803ce0:	0f bd fe             	bsr    %esi,%edi
  803ce3:	83 f7 1f             	xor    $0x1f,%edi
  803ce6:	75 40                	jne    803d28 <__udivdi3+0x9c>
  803ce8:	39 ce                	cmp    %ecx,%esi
  803cea:	72 0a                	jb     803cf6 <__udivdi3+0x6a>
  803cec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cf0:	0f 87 9e 00 00 00    	ja     803d94 <__udivdi3+0x108>
  803cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfb:	89 fa                	mov    %edi,%edx
  803cfd:	83 c4 1c             	add    $0x1c,%esp
  803d00:	5b                   	pop    %ebx
  803d01:	5e                   	pop    %esi
  803d02:	5f                   	pop    %edi
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    
  803d05:	8d 76 00             	lea    0x0(%esi),%esi
  803d08:	31 ff                	xor    %edi,%edi
  803d0a:	31 c0                	xor    %eax,%eax
  803d0c:	89 fa                	mov    %edi,%edx
  803d0e:	83 c4 1c             	add    $0x1c,%esp
  803d11:	5b                   	pop    %ebx
  803d12:	5e                   	pop    %esi
  803d13:	5f                   	pop    %edi
  803d14:	5d                   	pop    %ebp
  803d15:	c3                   	ret    
  803d16:	66 90                	xchg   %ax,%ax
  803d18:	89 d8                	mov    %ebx,%eax
  803d1a:	f7 f7                	div    %edi
  803d1c:	31 ff                	xor    %edi,%edi
  803d1e:	89 fa                	mov    %edi,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d2d:	89 eb                	mov    %ebp,%ebx
  803d2f:	29 fb                	sub    %edi,%ebx
  803d31:	89 f9                	mov    %edi,%ecx
  803d33:	d3 e6                	shl    %cl,%esi
  803d35:	89 c5                	mov    %eax,%ebp
  803d37:	88 d9                	mov    %bl,%cl
  803d39:	d3 ed                	shr    %cl,%ebp
  803d3b:	89 e9                	mov    %ebp,%ecx
  803d3d:	09 f1                	or     %esi,%ecx
  803d3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d43:	89 f9                	mov    %edi,%ecx
  803d45:	d3 e0                	shl    %cl,%eax
  803d47:	89 c5                	mov    %eax,%ebp
  803d49:	89 d6                	mov    %edx,%esi
  803d4b:	88 d9                	mov    %bl,%cl
  803d4d:	d3 ee                	shr    %cl,%esi
  803d4f:	89 f9                	mov    %edi,%ecx
  803d51:	d3 e2                	shl    %cl,%edx
  803d53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d57:	88 d9                	mov    %bl,%cl
  803d59:	d3 e8                	shr    %cl,%eax
  803d5b:	09 c2                	or     %eax,%edx
  803d5d:	89 d0                	mov    %edx,%eax
  803d5f:	89 f2                	mov    %esi,%edx
  803d61:	f7 74 24 0c          	divl   0xc(%esp)
  803d65:	89 d6                	mov    %edx,%esi
  803d67:	89 c3                	mov    %eax,%ebx
  803d69:	f7 e5                	mul    %ebp
  803d6b:	39 d6                	cmp    %edx,%esi
  803d6d:	72 19                	jb     803d88 <__udivdi3+0xfc>
  803d6f:	74 0b                	je     803d7c <__udivdi3+0xf0>
  803d71:	89 d8                	mov    %ebx,%eax
  803d73:	31 ff                	xor    %edi,%edi
  803d75:	e9 58 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d80:	89 f9                	mov    %edi,%ecx
  803d82:	d3 e2                	shl    %cl,%edx
  803d84:	39 c2                	cmp    %eax,%edx
  803d86:	73 e9                	jae    803d71 <__udivdi3+0xe5>
  803d88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d8b:	31 ff                	xor    %edi,%edi
  803d8d:	e9 40 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d92:	66 90                	xchg   %ax,%ax
  803d94:	31 c0                	xor    %eax,%eax
  803d96:	e9 37 ff ff ff       	jmp    803cd2 <__udivdi3+0x46>
  803d9b:	90                   	nop

00803d9c <__umoddi3>:
  803d9c:	55                   	push   %ebp
  803d9d:	57                   	push   %edi
  803d9e:	56                   	push   %esi
  803d9f:	53                   	push   %ebx
  803da0:	83 ec 1c             	sub    $0x1c,%esp
  803da3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803da7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803daf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803db3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803db7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dbb:	89 f3                	mov    %esi,%ebx
  803dbd:	89 fa                	mov    %edi,%edx
  803dbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dc3:	89 34 24             	mov    %esi,(%esp)
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	75 1a                	jne    803de4 <__umoddi3+0x48>
  803dca:	39 f7                	cmp    %esi,%edi
  803dcc:	0f 86 a2 00 00 00    	jbe    803e74 <__umoddi3+0xd8>
  803dd2:	89 c8                	mov    %ecx,%eax
  803dd4:	89 f2                	mov    %esi,%edx
  803dd6:	f7 f7                	div    %edi
  803dd8:	89 d0                	mov    %edx,%eax
  803dda:	31 d2                	xor    %edx,%edx
  803ddc:	83 c4 1c             	add    $0x1c,%esp
  803ddf:	5b                   	pop    %ebx
  803de0:	5e                   	pop    %esi
  803de1:	5f                   	pop    %edi
  803de2:	5d                   	pop    %ebp
  803de3:	c3                   	ret    
  803de4:	39 f0                	cmp    %esi,%eax
  803de6:	0f 87 ac 00 00 00    	ja     803e98 <__umoddi3+0xfc>
  803dec:	0f bd e8             	bsr    %eax,%ebp
  803def:	83 f5 1f             	xor    $0x1f,%ebp
  803df2:	0f 84 ac 00 00 00    	je     803ea4 <__umoddi3+0x108>
  803df8:	bf 20 00 00 00       	mov    $0x20,%edi
  803dfd:	29 ef                	sub    %ebp,%edi
  803dff:	89 fe                	mov    %edi,%esi
  803e01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e05:	89 e9                	mov    %ebp,%ecx
  803e07:	d3 e0                	shl    %cl,%eax
  803e09:	89 d7                	mov    %edx,%edi
  803e0b:	89 f1                	mov    %esi,%ecx
  803e0d:	d3 ef                	shr    %cl,%edi
  803e0f:	09 c7                	or     %eax,%edi
  803e11:	89 e9                	mov    %ebp,%ecx
  803e13:	d3 e2                	shl    %cl,%edx
  803e15:	89 14 24             	mov    %edx,(%esp)
  803e18:	89 d8                	mov    %ebx,%eax
  803e1a:	d3 e0                	shl    %cl,%eax
  803e1c:	89 c2                	mov    %eax,%edx
  803e1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e22:	d3 e0                	shl    %cl,%eax
  803e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e2c:	89 f1                	mov    %esi,%ecx
  803e2e:	d3 e8                	shr    %cl,%eax
  803e30:	09 d0                	or     %edx,%eax
  803e32:	d3 eb                	shr    %cl,%ebx
  803e34:	89 da                	mov    %ebx,%edx
  803e36:	f7 f7                	div    %edi
  803e38:	89 d3                	mov    %edx,%ebx
  803e3a:	f7 24 24             	mull   (%esp)
  803e3d:	89 c6                	mov    %eax,%esi
  803e3f:	89 d1                	mov    %edx,%ecx
  803e41:	39 d3                	cmp    %edx,%ebx
  803e43:	0f 82 87 00 00 00    	jb     803ed0 <__umoddi3+0x134>
  803e49:	0f 84 91 00 00 00    	je     803ee0 <__umoddi3+0x144>
  803e4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e53:	29 f2                	sub    %esi,%edx
  803e55:	19 cb                	sbb    %ecx,%ebx
  803e57:	89 d8                	mov    %ebx,%eax
  803e59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e5d:	d3 e0                	shl    %cl,%eax
  803e5f:	89 e9                	mov    %ebp,%ecx
  803e61:	d3 ea                	shr    %cl,%edx
  803e63:	09 d0                	or     %edx,%eax
  803e65:	89 e9                	mov    %ebp,%ecx
  803e67:	d3 eb                	shr    %cl,%ebx
  803e69:	89 da                	mov    %ebx,%edx
  803e6b:	83 c4 1c             	add    $0x1c,%esp
  803e6e:	5b                   	pop    %ebx
  803e6f:	5e                   	pop    %esi
  803e70:	5f                   	pop    %edi
  803e71:	5d                   	pop    %ebp
  803e72:	c3                   	ret    
  803e73:	90                   	nop
  803e74:	89 fd                	mov    %edi,%ebp
  803e76:	85 ff                	test   %edi,%edi
  803e78:	75 0b                	jne    803e85 <__umoddi3+0xe9>
  803e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7f:	31 d2                	xor    %edx,%edx
  803e81:	f7 f7                	div    %edi
  803e83:	89 c5                	mov    %eax,%ebp
  803e85:	89 f0                	mov    %esi,%eax
  803e87:	31 d2                	xor    %edx,%edx
  803e89:	f7 f5                	div    %ebp
  803e8b:	89 c8                	mov    %ecx,%eax
  803e8d:	f7 f5                	div    %ebp
  803e8f:	89 d0                	mov    %edx,%eax
  803e91:	e9 44 ff ff ff       	jmp    803dda <__umoddi3+0x3e>
  803e96:	66 90                	xchg   %ax,%ax
  803e98:	89 c8                	mov    %ecx,%eax
  803e9a:	89 f2                	mov    %esi,%edx
  803e9c:	83 c4 1c             	add    $0x1c,%esp
  803e9f:	5b                   	pop    %ebx
  803ea0:	5e                   	pop    %esi
  803ea1:	5f                   	pop    %edi
  803ea2:	5d                   	pop    %ebp
  803ea3:	c3                   	ret    
  803ea4:	3b 04 24             	cmp    (%esp),%eax
  803ea7:	72 06                	jb     803eaf <__umoddi3+0x113>
  803ea9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ead:	77 0f                	ja     803ebe <__umoddi3+0x122>
  803eaf:	89 f2                	mov    %esi,%edx
  803eb1:	29 f9                	sub    %edi,%ecx
  803eb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803eb7:	89 14 24             	mov    %edx,(%esp)
  803eba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ebe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ec2:	8b 14 24             	mov    (%esp),%edx
  803ec5:	83 c4 1c             	add    $0x1c,%esp
  803ec8:	5b                   	pop    %ebx
  803ec9:	5e                   	pop    %esi
  803eca:	5f                   	pop    %edi
  803ecb:	5d                   	pop    %ebp
  803ecc:	c3                   	ret    
  803ecd:	8d 76 00             	lea    0x0(%esi),%esi
  803ed0:	2b 04 24             	sub    (%esp),%eax
  803ed3:	19 fa                	sbb    %edi,%edx
  803ed5:	89 d1                	mov    %edx,%ecx
  803ed7:	89 c6                	mov    %eax,%esi
  803ed9:	e9 71 ff ff ff       	jmp    803e4f <__umoddi3+0xb3>
  803ede:	66 90                	xchg   %ax,%ax
  803ee0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ee4:	72 ea                	jb     803ed0 <__umoddi3+0x134>
  803ee6:	89 d9                	mov    %ebx,%ecx
  803ee8:	e9 62 ff ff ff       	jmp    803e4f <__umoddi3+0xb3>
