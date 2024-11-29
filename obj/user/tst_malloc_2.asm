
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
  800055:	68 a0 40 80 00       	push   $0x8040a0
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
  8000a5:	68 d0 40 80 00       	push   $0x8040d0
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
  8000e7:	68 09 41 80 00       	push   $0x804109
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 25 41 80 00       	push   $0x804125
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
  800114:	e8 c9 1d 00 00       	call   801ee2 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 76 1d 00 00       	call   801e97 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 3c 41 80 00       	push   $0x80413c
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
  8002a0:	68 98 41 80 00       	push   $0x804198
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
  80030a:	68 bc 41 80 00       	push   $0x8041bc
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
  800370:	68 f8 41 80 00       	push   $0x8041f8
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
  800397:	68 48 42 80 00       	push   $0x804248
  80039c:	e8 1c 06 00 00       	call   8009bd <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 32 1b 00 00       	call   801ee2 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 88 42 80 00       	push   $0x804288
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
  80047b:	68 c4 42 80 00       	push   $0x8042c4
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
  8004a8:	e8 ea 19 00 00       	call   801e97 <sys_calculate_free_frames>
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
  8004d4:	68 08 43 80 00       	push   $0x804308
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
  8004f5:	68 54 43 80 00       	push   $0x804354
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
  800570:	e8 7d 1d 00 00       	call   8022f2 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 78 43 80 00       	push   $0x804378
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
  8005ae:	68 9c 43 80 00       	push   $0x80439c
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
  8005c7:	e8 94 1a 00 00       	call   802060 <sys_getenvindex>
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
  800635:	e8 aa 17 00 00       	call   801de4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	68 fc 43 80 00       	push   $0x8043fc
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
  800665:	68 24 44 80 00       	push   $0x804424
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
  800696:	68 4c 44 80 00       	push   $0x80444c
  80069b:	e8 1d 03 00 00       	call   8009bd <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	50                   	push   %eax
  8006b2:	68 a4 44 80 00       	push   $0x8044a4
  8006b7:	e8 01 03 00 00       	call   8009bd <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 fc 43 80 00       	push   $0x8043fc
  8006c7:	e8 f1 02 00 00       	call   8009bd <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006cf:	e8 2a 17 00 00       	call   801dfe <sys_unlock_cons>
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
  8006e7:	e8 40 19 00 00       	call   80202c <sys_destroy_env>
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
  8006f8:	e8 95 19 00 00       	call   802092 <sys_exit_env>
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
  800721:	68 b8 44 80 00       	push   $0x8044b8
  800726:	e8 92 02 00 00       	call   8009bd <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80072e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	50                   	push   %eax
  80073a:	68 bd 44 80 00       	push   $0x8044bd
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
  80075e:	68 d9 44 80 00       	push   $0x8044d9
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
  80078d:	68 dc 44 80 00       	push   $0x8044dc
  800792:	6a 26                	push   $0x26
  800794:	68 28 45 80 00       	push   $0x804528
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
  800862:	68 34 45 80 00       	push   $0x804534
  800867:	6a 3a                	push   $0x3a
  800869:	68 28 45 80 00       	push   $0x804528
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
  8008d5:	68 88 45 80 00       	push   $0x804588
  8008da:	6a 44                	push   $0x44
  8008dc:	68 28 45 80 00       	push   $0x804528
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
  80092f:	e8 6e 14 00 00       	call   801da2 <sys_cputs>
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
  8009a6:	e8 f7 13 00 00       	call   801da2 <sys_cputs>
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
  8009f0:	e8 ef 13 00 00       	call   801de4 <sys_lock_cons>
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
  800a10:	e8 e9 13 00 00       	call   801dfe <sys_unlock_cons>
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
  800a5a:	e8 dd 33 00 00       	call   803e3c <__udivdi3>
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
  800aaa:	e8 9d 34 00 00       	call   803f4c <__umoddi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	05 f4 47 80 00       	add    $0x8047f4,%eax
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
  800c05:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
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
  800ce6:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  800ced:	85 f6                	test   %esi,%esi
  800cef:	75 19                	jne    800d0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf1:	53                   	push   %ebx
  800cf2:	68 05 48 80 00       	push   $0x804805
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
  800d0b:	68 0e 48 80 00       	push   $0x80480e
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
  800d38:	be 11 48 80 00       	mov    $0x804811,%esi
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
  801743:	68 88 49 80 00       	push   $0x804988
  801748:	68 3f 01 00 00       	push   $0x13f
  80174d:	68 aa 49 80 00       	push   $0x8049aa
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
  801763:	e8 e5 0b 00 00       	call   80234d <sys_sbrk>
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
  8017de:	e8 ee 09 00 00       	call   8021d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 16                	je     8017fd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 2e 0f 00 00       	call   802720 <alloc_block_FF>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	e9 8a 01 00 00       	jmp    801987 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8017fd:	e8 00 0a 00 00       	call   802202 <sys_isUHeapPlacementStrategyBESTFIT>
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 84 7d 01 00 00    	je     801987 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 c7 13 00 00       	call   802bdc <alloc_block_BF>
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
  801860:	8b 04 85 60 d2 08 01 	mov    0x108d260(,%eax,4),%eax
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
  8018ad:	8b 04 85 60 d2 08 01 	mov    0x108d260(,%eax,4),%eax
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
  801904:	c7 04 85 60 d2 08 01 	movl   $0x1,0x108d260(,%eax,4)
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
  801966:	89 04 95 60 d2 10 01 	mov    %eax,0x110d260(,%edx,4)
		sys_allocate_user_mem(i, size);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	ff 75 f0             	pushl  -0x10(%ebp)
  801976:	e8 09 0a 00 00       	call   802384 <sys_allocate_user_mem>
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
  8019be:	e8 dd 09 00 00       	call   8023a0 <get_block_size>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 10 1c 00 00       	call   8035e4 <free_block>
  8019d4:	83 c4 10             	add    $0x10,%esp
		}

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
  801a09:	8b 04 85 60 d2 10 01 	mov    0x110d260(,%eax,4),%eax
  801a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a16:	c1 e0 0c             	shl    $0xc,%eax
  801a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a23:	eb 42                	jmp    801a67 <free+0xdb>
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
  801a46:	c7 04 85 60 d2 08 01 	movl   $0x0,0x108d260(,%eax,4)
  801a4d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	e8 07 09 00 00       	call   802368 <sys_free_user_mem>
  801a61:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801a64:	ff 45 f4             	incl   -0xc(%ebp)
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a6d:	72 b6                	jb     801a25 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801a6f:	eb 17                	jmp    801a88 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	68 b8 49 80 00       	push   $0x8049b8
  801a79:	68 88 00 00 00       	push   $0x88
  801a7e:	68 e2 49 80 00       	push   $0x8049e2
  801a83:	e8 78 ec ff ff       	call   800700 <_panic>
	}
}
  801a88:	90                   	nop
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 28             	sub    $0x28,%esp
  801a91:	8b 45 10             	mov    0x10(%ebp),%eax
  801a94:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9b:	75 0a                	jne    801aa7 <smalloc+0x1c>
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa2:	e9 ec 00 00 00       	jmp    801b93 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aba:	39 d0                	cmp    %edx,%eax
  801abc:	73 02                	jae    801ac0 <smalloc+0x35>
  801abe:	89 d0                	mov    %edx,%eax
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	50                   	push   %eax
  801ac4:	e8 a4 fc ff ff       	call   80176d <malloc>
  801ac9:	83 c4 10             	add    $0x10,%esp
  801acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801acf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ad3:	75 0a                	jne    801adf <smalloc+0x54>
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	e9 b4 00 00 00       	jmp    801b93 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801adf:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ae3:	ff 75 ec             	pushl  -0x14(%ebp)
  801ae6:	50                   	push   %eax
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 7d 04 00 00       	call   801f6f <sys_createSharedObject>
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801af8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801afc:	74 06                	je     801b04 <smalloc+0x79>
  801afe:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801b02:	75 0a                	jne    801b0e <smalloc+0x83>
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
  801b09:	e9 85 00 00 00       	jmp    801b93 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	ff 75 ec             	pushl  -0x14(%ebp)
  801b14:	68 ee 49 80 00       	push   $0x8049ee
  801b19:	e8 9f ee ff ff       	call   8009bd <cprintf>
  801b1e:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b24:	a1 20 50 80 00       	mov    0x805020,%eax
  801b29:	8b 40 78             	mov    0x78(%eax),%eax
  801b2c:	29 c2                	sub    %eax,%edx
  801b2e:	89 d0                	mov    %edx,%eax
  801b30:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b35:	c1 e8 0c             	shr    $0xc,%eax
  801b38:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801b3e:	42                   	inc    %edx
  801b3f:	89 15 24 50 80 00    	mov    %edx,0x805024
  801b45:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801b4b:	89 14 85 60 d2 00 01 	mov    %edx,0x100d260(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801b52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b55:	a1 20 50 80 00       	mov    0x805020,%eax
  801b5a:	8b 40 78             	mov    0x78(%eax),%eax
  801b5d:	29 c2                	sub    %eax,%edx
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b66:	c1 e8 0c             	shr    $0xc,%eax
  801b69:	8b 0c 85 60 d2 00 01 	mov    0x100d260(,%eax,4),%ecx
  801b70:	a1 20 50 80 00       	mov    0x805020,%eax
  801b75:	8b 50 10             	mov    0x10(%eax),%edx
  801b78:	89 c8                	mov    %ecx,%eax
  801b7a:	c1 e0 02             	shl    $0x2,%eax
  801b7d:	89 c1                	mov    %eax,%ecx
  801b7f:	c1 e1 09             	shl    $0x9,%ecx
  801b82:	01 c8                	add    %ecx,%eax
  801b84:	01 c2                	add    %eax,%edx
  801b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b89:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	 return ptr;
  801b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	ff 75 08             	pushl  0x8(%ebp)
  801ba4:	e8 f0 03 00 00       	call   801f99 <sys_getSizeOfSharedObject>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801baf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801bb3:	75 0a                	jne    801bbf <sget+0x2a>
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bba:	e9 e7 00 00 00       	jmp    801ca6 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bc5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd2:	39 d0                	cmp    %edx,%eax
  801bd4:	73 02                	jae    801bd8 <sget+0x43>
  801bd6:	89 d0                	mov    %edx,%eax
  801bd8:	83 ec 0c             	sub    $0xc,%esp
  801bdb:	50                   	push   %eax
  801bdc:	e8 8c fb ff ff       	call   80176d <malloc>
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801be7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801beb:	75 0a                	jne    801bf7 <sget+0x62>
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf2:	e9 af 00 00 00       	jmp    801ca6 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	e8 ae 03 00 00       	call   801fb6 <sys_getSharedObject>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801c0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c11:	a1 20 50 80 00       	mov    0x805020,%eax
  801c16:	8b 40 78             	mov    0x78(%eax),%eax
  801c19:	29 c2                	sub    %eax,%edx
  801c1b:	89 d0                	mov    %edx,%eax
  801c1d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c22:	c1 e8 0c             	shr    $0xc,%eax
  801c25:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c2b:	42                   	inc    %edx
  801c2c:	89 15 24 50 80 00    	mov    %edx,0x805024
  801c32:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c38:	89 14 85 60 d2 00 01 	mov    %edx,0x100d260(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801c3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c42:	a1 20 50 80 00       	mov    0x805020,%eax
  801c47:	8b 40 78             	mov    0x78(%eax),%eax
  801c4a:	29 c2                	sub    %eax,%edx
  801c4c:	89 d0                	mov    %edx,%eax
  801c4e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c53:	c1 e8 0c             	shr    $0xc,%eax
  801c56:	8b 0c 85 60 d2 00 01 	mov    0x100d260(,%eax,4),%ecx
  801c5d:	a1 20 50 80 00       	mov    0x805020,%eax
  801c62:	8b 50 10             	mov    0x10(%eax),%edx
  801c65:	89 c8                	mov    %ecx,%eax
  801c67:	c1 e0 02             	shl    $0x2,%eax
  801c6a:	89 c1                	mov    %eax,%ecx
  801c6c:	c1 e1 09             	shl    $0x9,%ecx
  801c6f:	01 c8                	add    %ecx,%eax
  801c71:	01 c2                	add    %eax,%edx
  801c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c76:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  801c82:	8b 40 10             	mov    0x10(%eax),%eax
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	50                   	push   %eax
  801c89:	68 fd 49 80 00       	push   $0x8049fd
  801c8e:	e8 2a ed ff ff       	call   8009bd <cprintf>
  801c93:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c96:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c9a:	75 07                	jne    801ca3 <sget+0x10e>
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca1:	eb 03                	jmp    801ca6 <sget+0x111>
	return ptr;
  801ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801cae:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb1:	a1 20 50 80 00       	mov    0x805020,%eax
  801cb6:	8b 40 78             	mov    0x78(%eax),%eax
  801cb9:	29 c2                	sub    %eax,%edx
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc2:	c1 e8 0c             	shr    $0xc,%eax
  801cc5:	8b 0c 85 60 d2 00 01 	mov    0x100d260(,%eax,4),%ecx
  801ccc:	a1 20 50 80 00       	mov    0x805020,%eax
  801cd1:	8b 50 10             	mov    0x10(%eax),%edx
  801cd4:	89 c8                	mov    %ecx,%eax
  801cd6:	c1 e0 02             	shl    $0x2,%eax
  801cd9:	89 c1                	mov    %eax,%ecx
  801cdb:	c1 e1 09             	shl    $0x9,%ecx
  801cde:	01 c8                	add    %ecx,%eax
  801ce0:	01 d0                	add    %edx,%eax
  801ce2:	8b 04 85 60 92 80 00 	mov    0x809260(,%eax,4),%eax
  801ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf5:	e8 db 02 00 00       	call   801fd5 <sys_freeSharedObject>
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801d00:	90                   	nop
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 0c 4a 80 00       	push   $0x804a0c
  801d11:	68 e5 00 00 00       	push   $0xe5
  801d16:	68 e2 49 80 00       	push   $0x8049e2
  801d1b:	e8 e0 e9 ff ff       	call   800700 <_panic>

00801d20 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 32 4a 80 00       	push   $0x804a32
  801d2e:	68 f1 00 00 00       	push   $0xf1
  801d33:	68 e2 49 80 00       	push   $0x8049e2
  801d38:	e8 c3 e9 ff ff       	call   800700 <_panic>

00801d3d <shrink>:

}
void shrink(uint32 newSize)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	68 32 4a 80 00       	push   $0x804a32
  801d4b:	68 f6 00 00 00       	push   $0xf6
  801d50:	68 e2 49 80 00       	push   $0x8049e2
  801d55:	e8 a6 e9 ff ff       	call   800700 <_panic>

00801d5a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 32 4a 80 00       	push   $0x804a32
  801d68:	68 fb 00 00 00       	push   $0xfb
  801d6d:	68 e2 49 80 00       	push   $0x8049e2
  801d72:	e8 89 e9 ff ff       	call   800700 <_panic>

00801d77 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	57                   	push   %edi
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
  801d7d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d8f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d92:	cd 30                	int    $0x30
  801d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5f                   	pop    %edi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	e8 b2 ff ff ff       	call   801d77 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	90                   	nop
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_cgetc>:

int
sys_cgetc(void)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 02                	push   $0x2
  801dda:	e8 98 ff ff ff       	call   801d77 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 03                	push   $0x3
  801df3:	e8 7f ff ff ff       	call   801d77 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 04                	push   $0x4
  801e0d:	e8 65 ff ff ff       	call   801d77 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	90                   	nop
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 08                	push   $0x8
  801e2b:	e8 47 ff ff ff       	call   801d77 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e3a:	8b 75 18             	mov    0x18(%ebp),%esi
  801e3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	51                   	push   %ecx
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	6a 09                	push   $0x9
  801e50:	e8 22 ff ff ff       	call   801d77 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 0a                	push   $0xa
  801e72:	e8 00 ff ff ff       	call   801d77 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 0b                	push   $0xb
  801e8d:	e8 e5 fe ff ff       	call   801d77 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 0c                	push   $0xc
  801ea6:	e8 cc fe ff ff       	call   801d77 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 0d                	push   $0xd
  801ebf:	e8 b3 fe ff ff       	call   801d77 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 0e                	push   $0xe
  801ed8:	e8 9a fe ff ff       	call   801d77 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 0f                	push   $0xf
  801ef1:	e8 81 fe ff ff       	call   801d77 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	6a 10                	push   $0x10
  801f0b:	e8 67 fe ff ff       	call   801d77 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 11                	push   $0x11
  801f24:	e8 4e fe ff ff       	call   801d77 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_cputc>:

void
sys_cputc(const char c)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	50                   	push   %eax
  801f48:	6a 01                	push   $0x1
  801f4a:	e8 28 fe ff ff       	call   801d77 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	90                   	nop
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 14                	push   $0x14
  801f64:	e8 0e fe ff ff       	call   801d77 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	8b 45 10             	mov    0x10(%ebp),%eax
  801f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	51                   	push   %ecx
  801f88:	52                   	push   %edx
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	50                   	push   %eax
  801f8d:	6a 15                	push   $0x15
  801f8f:	e8 e3 fd ff ff       	call   801d77 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 16                	push   $0x16
  801fac:	e8 c6 fd ff ff       	call   801d77 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	51                   	push   %ecx
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	6a 17                	push   $0x17
  801fcb:	e8 a7 fd ff ff       	call   801d77 <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	52                   	push   %edx
  801fe5:	50                   	push   %eax
  801fe6:	6a 18                	push   $0x18
  801fe8:	e8 8a fd ff ff       	call   801d77 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	6a 00                	push   $0x0
  801ffa:	ff 75 14             	pushl  0x14(%ebp)
  801ffd:	ff 75 10             	pushl  0x10(%ebp)
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	50                   	push   %eax
  802004:	6a 19                	push   $0x19
  802006:	e8 6c fd ff ff       	call   801d77 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	50                   	push   %eax
  80201f:	6a 1a                	push   $0x1a
  802021:	e8 51 fd ff ff       	call   801d77 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	90                   	nop
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	50                   	push   %eax
  80203b:	6a 1b                	push   $0x1b
  80203d:	e8 35 fd ff ff       	call   801d77 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 05                	push   $0x5
  802056:	e8 1c fd ff ff       	call   801d77 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 06                	push   $0x6
  80206f:	e8 03 fd ff ff       	call   801d77 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 07                	push   $0x7
  802088:	e8 ea fc ff ff       	call   801d77 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_exit_env>:


void sys_exit_env(void)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 1c                	push   $0x1c
  8020a1:	e8 d1 fc ff ff       	call   801d77 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	90                   	nop
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020b5:	8d 50 04             	lea    0x4(%eax),%edx
  8020b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 1d                	push   $0x1d
  8020c5:	e8 ad fc ff ff       	call   801d77 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
	return result;
  8020cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020d6:	89 01                	mov    %eax,(%ecx)
  8020d8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	c9                   	leave  
  8020df:	c2 04 00             	ret    $0x4

008020e2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	ff 75 10             	pushl  0x10(%ebp)
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	6a 13                	push   $0x13
  8020f4:	e8 7e fc ff ff       	call   801d77 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 1e                	push   $0x1e
  80210e:	e8 64 fc ff ff       	call   801d77 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802124:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	50                   	push   %eax
  802131:	6a 1f                	push   $0x1f
  802133:	e8 3f fc ff ff       	call   801d77 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
	return ;
  80213b:	90                   	nop
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <rsttst>:
void rsttst()
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 21                	push   $0x21
  80214d:	e8 25 fc ff ff       	call   801d77 <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
	return ;
  802155:	90                   	nop
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	8b 45 14             	mov    0x14(%ebp),%eax
  802161:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802164:	8b 55 18             	mov    0x18(%ebp),%edx
  802167:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	ff 75 10             	pushl  0x10(%ebp)
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	ff 75 08             	pushl  0x8(%ebp)
  802176:	6a 20                	push   $0x20
  802178:	e8 fa fb ff ff       	call   801d77 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return ;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <chktst>:
void chktst(uint32 n)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	6a 22                	push   $0x22
  802193:	e8 df fb ff ff       	call   801d77 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
	return ;
  80219b:	90                   	nop
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <inctst>:

void inctst()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 23                	push   $0x23
  8021ad:	e8 c5 fb ff ff       	call   801d77 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b5:	90                   	nop
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <gettst>:
uint32 gettst()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 24                	push   $0x24
  8021c7:	e8 ab fb ff ff       	call   801d77 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 25                	push   $0x25
  8021e3:	e8 8f fb ff ff       	call   801d77 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
  8021eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021f2:	75 07                	jne    8021fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f9:	eb 05                	jmp    802200 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 25                	push   $0x25
  802214:	e8 5e fb ff ff       	call   801d77 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
  80221c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80221f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802223:	75 07                	jne    80222c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802225:	b8 01 00 00 00       	mov    $0x1,%eax
  80222a:	eb 05                	jmp    802231 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 25                	push   $0x25
  802245:	e8 2d fb ff ff       	call   801d77 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
  80224d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802250:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802254:	75 07                	jne    80225d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	eb 05                	jmp    802262 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 25                	push   $0x25
  802276:	e8 fc fa ff ff       	call   801d77 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
  80227e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802281:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802285:	75 07                	jne    80228e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802287:	b8 01 00 00 00       	mov    $0x1,%eax
  80228c:	eb 05                	jmp    802293 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	6a 26                	push   $0x26
  8022a5:	e8 cd fa ff ff       	call   801d77 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ad:	90                   	nop
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	53                   	push   %ebx
  8022c3:	51                   	push   %ecx
  8022c4:	52                   	push   %edx
  8022c5:	50                   	push   %eax
  8022c6:	6a 27                	push   $0x27
  8022c8:	e8 aa fa ff ff       	call   801d77 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	52                   	push   %edx
  8022e5:	50                   	push   %eax
  8022e6:	6a 28                	push   $0x28
  8022e8:	e8 8a fa ff ff       	call   801d77 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8022f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	6a 00                	push   $0x0
  802300:	51                   	push   %ecx
  802301:	ff 75 10             	pushl  0x10(%ebp)
  802304:	52                   	push   %edx
  802305:	50                   	push   %eax
  802306:	6a 29                	push   $0x29
  802308:	e8 6a fa ff ff       	call   801d77 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	ff 75 10             	pushl  0x10(%ebp)
  80231c:	ff 75 0c             	pushl  0xc(%ebp)
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	6a 12                	push   $0x12
  802324:	e8 4e fa ff ff       	call   801d77 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
	return ;
  80232c:	90                   	nop
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	52                   	push   %edx
  80233f:	50                   	push   %eax
  802340:	6a 2a                	push   $0x2a
  802342:	e8 30 fa ff ff       	call   801d77 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	50                   	push   %eax
  80235c:	6a 2b                	push   $0x2b
  80235e:	e8 14 fa ff ff       	call   801d77 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	ff 75 0c             	pushl  0xc(%ebp)
  802374:	ff 75 08             	pushl  0x8(%ebp)
  802377:	6a 2c                	push   $0x2c
  802379:	e8 f9 f9 ff ff       	call   801d77 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
	return;
  802381:	90                   	nop
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	ff 75 0c             	pushl  0xc(%ebp)
  802390:	ff 75 08             	pushl  0x8(%ebp)
  802393:	6a 2d                	push   $0x2d
  802395:	e8 dd f9 ff ff       	call   801d77 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
	return;
  80239d:	90                   	nop
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	83 e8 04             	sub    $0x4,%eax
  8023ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8023af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	83 e8 04             	sub    $0x4,%eax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8023c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	83 e0 01             	and    $0x1,%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	0f 94 c0             	sete   %al
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8023dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	83 f8 02             	cmp    $0x2,%eax
  8023ea:	74 2b                	je     802417 <alloc_block+0x40>
  8023ec:	83 f8 02             	cmp    $0x2,%eax
  8023ef:	7f 07                	jg     8023f8 <alloc_block+0x21>
  8023f1:	83 f8 01             	cmp    $0x1,%eax
  8023f4:	74 0e                	je     802404 <alloc_block+0x2d>
  8023f6:	eb 58                	jmp    802450 <alloc_block+0x79>
  8023f8:	83 f8 03             	cmp    $0x3,%eax
  8023fb:	74 2d                	je     80242a <alloc_block+0x53>
  8023fd:	83 f8 04             	cmp    $0x4,%eax
  802400:	74 3b                	je     80243d <alloc_block+0x66>
  802402:	eb 4c                	jmp    802450 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	e8 11 03 00 00       	call   802720 <alloc_block_FF>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802415:	eb 4a                	jmp    802461 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	ff 75 08             	pushl  0x8(%ebp)
  80241d:	e8 fa 19 00 00       	call   803e1c <alloc_block_NF>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802428:	eb 37                	jmp    802461 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80242a:	83 ec 0c             	sub    $0xc,%esp
  80242d:	ff 75 08             	pushl  0x8(%ebp)
  802430:	e8 a7 07 00 00       	call   802bdc <alloc_block_BF>
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80243b:	eb 24                	jmp    802461 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80243d:	83 ec 0c             	sub    $0xc,%esp
  802440:	ff 75 08             	pushl  0x8(%ebp)
  802443:	e8 b7 19 00 00       	call   803dff <alloc_block_WF>
  802448:	83 c4 10             	add    $0x10,%esp
  80244b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80244e:	eb 11                	jmp    802461 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802450:	83 ec 0c             	sub    $0xc,%esp
  802453:	68 44 4a 80 00       	push   $0x804a44
  802458:	e8 60 e5 ff ff       	call   8009bd <cprintf>
  80245d:	83 c4 10             	add    $0x10,%esp
		break;
  802460:	90                   	nop
	}
	return va;
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80246d:	83 ec 0c             	sub    $0xc,%esp
  802470:	68 64 4a 80 00       	push   $0x804a64
  802475:	e8 43 e5 ff ff       	call   8009bd <cprintf>
  80247a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	68 8f 4a 80 00       	push   $0x804a8f
  802485:	e8 33 e5 ff ff       	call   8009bd <cprintf>
  80248a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802493:	eb 37                	jmp    8024cc <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	ff 75 f4             	pushl  -0xc(%ebp)
  80249b:	e8 19 ff ff ff       	call   8023b9 <is_free_block>
  8024a0:	83 c4 10             	add    $0x10,%esp
  8024a3:	0f be d8             	movsbl %al,%ebx
  8024a6:	83 ec 0c             	sub    $0xc,%esp
  8024a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ac:	e8 ef fe ff ff       	call   8023a0 <get_block_size>
  8024b1:	83 c4 10             	add    $0x10,%esp
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	53                   	push   %ebx
  8024b8:	50                   	push   %eax
  8024b9:	68 a7 4a 80 00       	push   $0x804aa7
  8024be:	e8 fa e4 ff ff       	call   8009bd <cprintf>
  8024c3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d0:	74 07                	je     8024d9 <print_blocks_list+0x73>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	eb 05                	jmp    8024de <print_blocks_list+0x78>
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024de:	89 45 10             	mov    %eax,0x10(%ebp)
  8024e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	75 ad                	jne    802495 <print_blocks_list+0x2f>
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	75 a7                	jne    802495 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	68 64 4a 80 00       	push   $0x804a64
  8024f6:	e8 c2 e4 ff ff       	call   8009bd <cprintf>
  8024fb:	83 c4 10             	add    $0x10,%esp

}
  8024fe:	90                   	nop
  8024ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80250a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250d:	83 e0 01             	and    $0x1,%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 03                	je     802517 <initialize_dynamic_allocator+0x13>
  802514:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80251b:	0f 84 c7 01 00 00    	je     8026e8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802521:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802528:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80252b:	8b 55 08             	mov    0x8(%ebp),%edx
  80252e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802531:	01 d0                	add    %edx,%eax
  802533:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802538:	0f 87 ad 01 00 00    	ja     8026eb <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 89 a5 01 00 00    	jns    8026ee <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802549:	8b 55 08             	mov    0x8(%ebp),%edx
  80254c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254f:	01 d0                	add    %edx,%eax
  802551:	83 e8 04             	sub    $0x4,%eax
  802554:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  802559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802560:	a1 44 50 80 00       	mov    0x805044,%eax
  802565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802568:	e9 87 00 00 00       	jmp    8025f4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	75 14                	jne    802587 <initialize_dynamic_allocator+0x83>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 bf 4a 80 00       	push   $0x804abf
  80257b:	6a 79                	push   $0x79
  80257d:	68 dd 4a 80 00       	push   $0x804add
  802582:	e8 79 e1 ff ff       	call   800700 <_panic>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 10                	je     8025a0 <initialize_dynamic_allocator+0x9c>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802598:	8b 52 04             	mov    0x4(%edx),%edx
  80259b:	89 50 04             	mov    %edx,0x4(%eax)
  80259e:	eb 0b                	jmp    8025ab <initialize_dynamic_allocator+0xa7>
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	a3 48 50 80 00       	mov    %eax,0x805048
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 0f                	je     8025c4 <initialize_dynamic_allocator+0xc0>
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 04             	mov    0x4(%eax),%eax
  8025bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025be:	8b 12                	mov    (%edx),%edx
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	eb 0a                	jmp    8025ce <initialize_dynamic_allocator+0xca>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e6:	48                   	dec    %eax
  8025e7:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8025ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	74 07                	je     802601 <initialize_dynamic_allocator+0xfd>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	eb 05                	jmp    802606 <initialize_dynamic_allocator+0x102>
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
  802606:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80260b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	0f 85 55 ff ff ff    	jne    80256d <initialize_dynamic_allocator+0x69>
  802618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261c:	0f 85 4b ff ff ff    	jne    80256d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802622:	8b 45 08             	mov    0x8(%ebp),%eax
  802625:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802631:	a1 4c 92 80 00       	mov    0x80924c,%eax
  802636:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  80263b:	a1 48 92 80 00       	mov    0x809248,%eax
  802640:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	83 c0 08             	add    $0x8,%eax
  80264c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	83 c0 04             	add    $0x4,%eax
  802655:	8b 55 0c             	mov    0xc(%ebp),%edx
  802658:	83 ea 08             	sub    $0x8,%edx
  80265b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80265d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	01 d0                	add    %edx,%eax
  802665:	83 e8 08             	sub    $0x8,%eax
  802668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266b:	83 ea 08             	sub    $0x8,%edx
  80266e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802683:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802687:	75 17                	jne    8026a0 <initialize_dynamic_allocator+0x19c>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 f8 4a 80 00       	push   $0x804af8
  802691:	68 90 00 00 00       	push   $0x90
  802696:	68 dd 4a 80 00       	push   $0x804add
  80269b:	e8 60 e0 ff ff       	call   800700 <_panic>
  8026a0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0d                	je     8026c1 <initialize_dynamic_allocator+0x1bd>
  8026b4:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bc:	89 50 04             	mov    %edx,0x4(%eax)
  8026bf:	eb 08                	jmp    8026c9 <initialize_dynamic_allocator+0x1c5>
  8026c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c4:	a3 48 50 80 00       	mov    %eax,0x805048
  8026c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cc:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e0:	40                   	inc    %eax
  8026e1:	a3 50 50 80 00       	mov    %eax,0x805050
  8026e6:	eb 07                	jmp    8026ef <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8026e8:	90                   	nop
  8026e9:	eb 04                	jmp    8026ef <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8026eb:	90                   	nop
  8026ec:	eb 01                	jmp    8026ef <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8026ee:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8026f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802700:	8b 45 0c             	mov    0xc(%ebp),%eax
  802703:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	83 e8 04             	sub    $0x4,%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	83 e0 fe             	and    $0xfffffffe,%eax
  802710:	8d 50 f8             	lea    -0x8(%eax),%edx
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	01 c2                	add    %eax,%edx
  802718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271b:	89 02                	mov    %eax,(%edx)
}
  80271d:	90                   	nop
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    

00802720 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	83 e0 01             	and    $0x1,%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 03                	je     802733 <alloc_block_FF+0x13>
  802730:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802733:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802737:	77 07                	ja     802740 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802739:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802740:	a1 28 50 80 00       	mov    0x805028,%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	75 73                	jne    8027bc <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	83 c0 10             	add    $0x10,%eax
  80274f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802752:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802759:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	01 d0                	add    %edx,%eax
  802761:	48                   	dec    %eax
  802762:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802768:	ba 00 00 00 00       	mov    $0x0,%edx
  80276d:	f7 75 ec             	divl   -0x14(%ebp)
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	29 d0                	sub    %edx,%eax
  802775:	c1 e8 0c             	shr    $0xc,%eax
  802778:	83 ec 0c             	sub    $0xc,%esp
  80277b:	50                   	push   %eax
  80277c:	e8 d6 ef ff ff       	call   801757 <sbrk>
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802787:	83 ec 0c             	sub    $0xc,%esp
  80278a:	6a 00                	push   $0x0
  80278c:	e8 c6 ef ff ff       	call   801757 <sbrk>
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80279d:	83 ec 08             	sub    $0x8,%esp
  8027a0:	50                   	push   %eax
  8027a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027a4:	e8 5b fd ff ff       	call   802504 <initialize_dynamic_allocator>
  8027a9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027ac:	83 ec 0c             	sub    $0xc,%esp
  8027af:	68 1b 4b 80 00       	push   $0x804b1b
  8027b4:	e8 04 e2 ff ff       	call   8009bd <cprintf>
  8027b9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8027bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c0:	75 0a                	jne    8027cc <alloc_block_FF+0xac>
	        return NULL;
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	e9 0e 04 00 00       	jmp    802bda <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8027cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027d3:	a1 44 50 80 00       	mov    0x805044,%eax
  8027d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027db:	e9 f3 02 00 00       	jmp    802ad3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8027ec:	e8 af fb ff ff       	call   8023a0 <get_block_size>
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	83 c0 08             	add    $0x8,%eax
  8027fd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802800:	0f 87 c5 02 00 00    	ja     802acb <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	83 c0 18             	add    $0x18,%eax
  80280c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80280f:	0f 87 19 02 00 00    	ja     802a2e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802815:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802818:	2b 45 08             	sub    0x8(%ebp),%eax
  80281b:	83 e8 08             	sub    $0x8,%eax
  80281e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	8d 50 08             	lea    0x8(%eax),%edx
  802827:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80282a:	01 d0                	add    %edx,%eax
  80282c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	83 c0 08             	add    $0x8,%eax
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	6a 01                	push   $0x1
  80283a:	50                   	push   %eax
  80283b:	ff 75 bc             	pushl  -0x44(%ebp)
  80283e:	e8 ae fe ff ff       	call   8026f1 <set_block_data>
  802843:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	75 68                	jne    8028b8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802850:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802854:	75 17                	jne    80286d <alloc_block_FF+0x14d>
  802856:	83 ec 04             	sub    $0x4,%esp
  802859:	68 f8 4a 80 00       	push   $0x804af8
  80285e:	68 d7 00 00 00       	push   $0xd7
  802863:	68 dd 4a 80 00       	push   $0x804add
  802868:	e8 93 de ff ff       	call   800700 <_panic>
  80286d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802873:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802876:	89 10                	mov    %edx,(%eax)
  802878:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 0d                	je     80288e <alloc_block_FF+0x16e>
  802881:	a1 44 50 80 00       	mov    0x805044,%eax
  802886:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	eb 08                	jmp    802896 <alloc_block_FF+0x176>
  80288e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802891:	a3 48 50 80 00       	mov    %eax,0x805048
  802896:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802899:	a3 44 50 80 00       	mov    %eax,0x805044
  80289e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ad:	40                   	inc    %eax
  8028ae:	a3 50 50 80 00       	mov    %eax,0x805050
  8028b3:	e9 dc 00 00 00       	jmp    802994 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	75 65                	jne    802926 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028c1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028c5:	75 17                	jne    8028de <alloc_block_FF+0x1be>
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	68 2c 4b 80 00       	push   $0x804b2c
  8028cf:	68 db 00 00 00       	push   $0xdb
  8028d4:	68 dd 4a 80 00       	push   $0x804add
  8028d9:	e8 22 de ff ff       	call   800700 <_panic>
  8028de:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8028e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028e7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 0c                	je     802900 <alloc_block_FF+0x1e0>
  8028f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8028f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	eb 08                	jmp    802908 <alloc_block_FF+0x1e8>
  802900:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802903:	a3 44 50 80 00       	mov    %eax,0x805044
  802908:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290b:	a3 48 50 80 00       	mov    %eax,0x805048
  802910:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802919:	a1 50 50 80 00       	mov    0x805050,%eax
  80291e:	40                   	inc    %eax
  80291f:	a3 50 50 80 00       	mov    %eax,0x805050
  802924:	eb 6e                	jmp    802994 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292a:	74 06                	je     802932 <alloc_block_FF+0x212>
  80292c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802930:	75 17                	jne    802949 <alloc_block_FF+0x229>
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	68 50 4b 80 00       	push   $0x804b50
  80293a:	68 df 00 00 00       	push   $0xdf
  80293f:	68 dd 4a 80 00       	push   $0x804add
  802944:	e8 b7 dd ff ff       	call   800700 <_panic>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 10                	mov    (%eax),%edx
  80294e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802951:	89 10                	mov    %edx,(%eax)
  802953:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0b                	je     802967 <alloc_block_FF+0x247>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802964:	89 50 04             	mov    %edx,0x4(%eax)
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80296d:	89 10                	mov    %edx,(%eax)
  80296f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802975:	89 50 04             	mov    %edx,0x4(%eax)
  802978:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	75 08                	jne    802989 <alloc_block_FF+0x269>
  802981:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802984:	a3 48 50 80 00       	mov    %eax,0x805048
  802989:	a1 50 50 80 00       	mov    0x805050,%eax
  80298e:	40                   	inc    %eax
  80298f:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_FF+0x291>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 bf 4a 80 00       	push   $0x804abf
  8029a2:	68 e1 00 00 00       	push   $0xe1
  8029a7:	68 dd 4a 80 00       	push   $0x804add
  8029ac:	e8 4f dd ff ff       	call   800700 <_panic>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 10                	je     8029ca <alloc_block_FF+0x2aa>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c2:	8b 52 04             	mov    0x4(%edx),%edx
  8029c5:	89 50 04             	mov    %edx,0x4(%eax)
  8029c8:	eb 0b                	jmp    8029d5 <alloc_block_FF+0x2b5>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	a3 48 50 80 00       	mov    %eax,0x805048
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0f                	je     8029ee <alloc_block_FF+0x2ce>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e8:	8b 12                	mov    (%edx),%edx
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	eb 0a                	jmp    8029f8 <alloc_block_FF+0x2d8>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	a3 44 50 80 00       	mov    %eax,0x805044
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 50 50 80 00       	mov    0x805050,%eax
  802a10:	48                   	dec    %eax
  802a11:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	6a 00                	push   $0x0
  802a1b:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a1e:	ff 75 b0             	pushl  -0x50(%ebp)
  802a21:	e8 cb fc ff ff       	call   8026f1 <set_block_data>
  802a26:	83 c4 10             	add    $0x10,%esp
  802a29:	e9 95 00 00 00       	jmp    802ac3 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	6a 01                	push   $0x1
  802a33:	ff 75 b8             	pushl  -0x48(%ebp)
  802a36:	ff 75 bc             	pushl  -0x44(%ebp)
  802a39:	e8 b3 fc ff ff       	call   8026f1 <set_block_data>
  802a3e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a45:	75 17                	jne    802a5e <alloc_block_FF+0x33e>
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	68 bf 4a 80 00       	push   $0x804abf
  802a4f:	68 e8 00 00 00       	push   $0xe8
  802a54:	68 dd 4a 80 00       	push   $0x804add
  802a59:	e8 a2 dc ff ff       	call   800700 <_panic>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 10                	je     802a77 <alloc_block_FF+0x357>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6f:	8b 52 04             	mov    0x4(%edx),%edx
  802a72:	89 50 04             	mov    %edx,0x4(%eax)
  802a75:	eb 0b                	jmp    802a82 <alloc_block_FF+0x362>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	a3 48 50 80 00       	mov    %eax,0x805048
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	74 0f                	je     802a9b <alloc_block_FF+0x37b>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a95:	8b 12                	mov    (%edx),%edx
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	eb 0a                	jmp    802aa5 <alloc_block_FF+0x385>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	a3 44 50 80 00       	mov    %eax,0x805044
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab8:	a1 50 50 80 00       	mov    0x805050,%eax
  802abd:	48                   	dec    %eax
  802abe:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  802ac3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ac6:	e9 0f 01 00 00       	jmp    802bda <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802acb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	74 07                	je     802ae0 <alloc_block_FF+0x3c0>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	eb 05                	jmp    802ae5 <alloc_block_FF+0x3c5>
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802aea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	0f 85 e9 fc ff ff    	jne    8027e0 <alloc_block_FF+0xc0>
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	0f 85 df fc ff ff    	jne    8027e0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	83 c0 08             	add    $0x8,%eax
  802b07:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b0a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b11:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b17:	01 d0                	add    %edx,%eax
  802b19:	48                   	dec    %eax
  802b1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b20:	ba 00 00 00 00       	mov    $0x0,%edx
  802b25:	f7 75 d8             	divl   -0x28(%ebp)
  802b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b2b:	29 d0                	sub    %edx,%eax
  802b2d:	c1 e8 0c             	shr    $0xc,%eax
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	50                   	push   %eax
  802b34:	e8 1e ec ff ff       	call   801757 <sbrk>
  802b39:	83 c4 10             	add    $0x10,%esp
  802b3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b3f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b43:	75 0a                	jne    802b4f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b45:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4a:	e9 8b 00 00 00       	jmp    802bda <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b4f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5c:	01 d0                	add    %edx,%eax
  802b5e:	48                   	dec    %eax
  802b5f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b65:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6a:	f7 75 cc             	divl   -0x34(%ebp)
  802b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b70:	29 d0                	sub    %edx,%eax
  802b72:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b75:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  802b7f:	a1 48 92 80 00       	mov    0x809248,%eax
  802b84:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b8a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b94:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b97:	01 d0                	add    %edx,%eax
  802b99:	48                   	dec    %eax
  802b9a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba5:	f7 75 c4             	divl   -0x3c(%ebp)
  802ba8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bab:	29 d0                	sub    %edx,%eax
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	6a 01                	push   $0x1
  802bb2:	50                   	push   %eax
  802bb3:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb6:	e8 36 fb ff ff       	call   8026f1 <set_block_data>
  802bbb:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802bbe:	83 ec 0c             	sub    $0xc,%esp
  802bc1:	ff 75 d0             	pushl  -0x30(%ebp)
  802bc4:	e8 1b 0a 00 00       	call   8035e4 <free_block>
  802bc9:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802bcc:	83 ec 0c             	sub    $0xc,%esp
  802bcf:	ff 75 08             	pushl  0x8(%ebp)
  802bd2:	e8 49 fb ff ff       	call   802720 <alloc_block_FF>
  802bd7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
  802bdf:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	83 e0 01             	and    $0x1,%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 03                	je     802bef <alloc_block_BF+0x13>
  802bec:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802bef:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bf3:	77 07                	ja     802bfc <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bf5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bfc:	a1 28 50 80 00       	mov    0x805028,%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	75 73                	jne    802c78 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	83 c0 10             	add    $0x10,%eax
  802c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c0e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	48                   	dec    %eax
  802c1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c24:	ba 00 00 00 00       	mov    $0x0,%edx
  802c29:	f7 75 e0             	divl   -0x20(%ebp)
  802c2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2f:	29 d0                	sub    %edx,%eax
  802c31:	c1 e8 0c             	shr    $0xc,%eax
  802c34:	83 ec 0c             	sub    $0xc,%esp
  802c37:	50                   	push   %eax
  802c38:	e8 1a eb ff ff       	call   801757 <sbrk>
  802c3d:	83 c4 10             	add    $0x10,%esp
  802c40:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c43:	83 ec 0c             	sub    $0xc,%esp
  802c46:	6a 00                	push   $0x0
  802c48:	e8 0a eb ff ff       	call   801757 <sbrk>
  802c4d:	83 c4 10             	add    $0x10,%esp
  802c50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c56:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c59:	83 ec 08             	sub    $0x8,%esp
  802c5c:	50                   	push   %eax
  802c5d:	ff 75 d8             	pushl  -0x28(%ebp)
  802c60:	e8 9f f8 ff ff       	call   802504 <initialize_dynamic_allocator>
  802c65:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c68:	83 ec 0c             	sub    $0xc,%esp
  802c6b:	68 1b 4b 80 00       	push   $0x804b1b
  802c70:	e8 48 dd ff ff       	call   8009bd <cprintf>
  802c75:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c86:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c94:	a1 44 50 80 00       	mov    0x805044,%eax
  802c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9c:	e9 1d 01 00 00       	jmp    802dbe <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ca7:	83 ec 0c             	sub    $0xc,%esp
  802caa:	ff 75 a8             	pushl  -0x58(%ebp)
  802cad:	e8 ee f6 ff ff       	call   8023a0 <get_block_size>
  802cb2:	83 c4 10             	add    $0x10,%esp
  802cb5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	83 c0 08             	add    $0x8,%eax
  802cbe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cc1:	0f 87 ef 00 00 00    	ja     802db6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	83 c0 18             	add    $0x18,%eax
  802ccd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cd0:	77 1d                	ja     802cef <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cd8:	0f 86 d8 00 00 00    	jbe    802db6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802cde:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ce4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ce7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cea:	e9 c7 00 00 00       	jmp    802db6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	83 c0 08             	add    $0x8,%eax
  802cf5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cf8:	0f 85 9d 00 00 00    	jne    802d9b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	6a 01                	push   $0x1
  802d03:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d06:	ff 75 a8             	pushl  -0x58(%ebp)
  802d09:	e8 e3 f9 ff ff       	call   8026f1 <set_block_data>
  802d0e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d15:	75 17                	jne    802d2e <alloc_block_BF+0x152>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 bf 4a 80 00       	push   $0x804abf
  802d1f:	68 2c 01 00 00       	push   $0x12c
  802d24:	68 dd 4a 80 00       	push   $0x804add
  802d29:	e8 d2 d9 ff ff       	call   800700 <_panic>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 10                	je     802d47 <alloc_block_BF+0x16b>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3f:	8b 52 04             	mov    0x4(%edx),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 0b                	jmp    802d52 <alloc_block_BF+0x176>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	a3 48 50 80 00       	mov    %eax,0x805048
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0f                	je     802d6b <alloc_block_BF+0x18f>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 12                	mov    (%edx),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 0a                	jmp    802d75 <alloc_block_BF+0x199>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	a3 44 50 80 00       	mov    %eax,0x805044
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 50 50 80 00       	mov    0x805050,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802d93:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d96:	e9 24 04 00 00       	jmp    8031bf <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802da1:	76 13                	jbe    802db6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802da3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802daa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802db0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802db3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802db6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc2:	74 07                	je     802dcb <alloc_block_BF+0x1ef>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	eb 05                	jmp    802dd0 <alloc_block_BF+0x1f4>
  802dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dd5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	0f 85 bf fe ff ff    	jne    802ca1 <alloc_block_BF+0xc5>
  802de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de6:	0f 85 b5 fe ff ff    	jne    802ca1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802dec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df0:	0f 84 26 02 00 00    	je     80301c <alloc_block_BF+0x440>
  802df6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dfa:	0f 85 1c 02 00 00    	jne    80301c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e03:	2b 45 08             	sub    0x8(%ebp),%eax
  802e06:	83 e8 08             	sub    $0x8,%eax
  802e09:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8d 50 08             	lea    0x8(%eax),%edx
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	01 d0                	add    %edx,%eax
  802e17:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	83 c0 08             	add    $0x8,%eax
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	6a 01                	push   $0x1
  802e25:	50                   	push   %eax
  802e26:	ff 75 f0             	pushl  -0x10(%ebp)
  802e29:	e8 c3 f8 ff ff       	call   8026f1 <set_block_data>
  802e2e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	75 68                	jne    802ea3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e3b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e3f:	75 17                	jne    802e58 <alloc_block_BF+0x27c>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 f8 4a 80 00       	push   $0x804af8
  802e49:	68 45 01 00 00       	push   $0x145
  802e4e:	68 dd 4a 80 00       	push   $0x804add
  802e53:	e8 a8 d8 ff ff       	call   800700 <_panic>
  802e58:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0d                	je     802e79 <alloc_block_BF+0x29d>
  802e6c:	a1 44 50 80 00       	mov    0x805044,%eax
  802e71:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	eb 08                	jmp    802e81 <alloc_block_BF+0x2a5>
  802e79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7c:	a3 48 50 80 00       	mov    %eax,0x805048
  802e81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e84:	a3 44 50 80 00       	mov    %eax,0x805044
  802e89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e93:	a1 50 50 80 00       	mov    0x805050,%eax
  802e98:	40                   	inc    %eax
  802e99:	a3 50 50 80 00       	mov    %eax,0x805050
  802e9e:	e9 dc 00 00 00       	jmp    802f7f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	75 65                	jne    802f11 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802eac:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802eb0:	75 17                	jne    802ec9 <alloc_block_BF+0x2ed>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 2c 4b 80 00       	push   $0x804b2c
  802eba:	68 4a 01 00 00       	push   $0x14a
  802ebf:	68 dd 4a 80 00       	push   $0x804add
  802ec4:	e8 37 d8 ff ff       	call   800700 <_panic>
  802ec9:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802ecf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed2:	89 50 04             	mov    %edx,0x4(%eax)
  802ed5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 0c                	je     802eeb <alloc_block_BF+0x30f>
  802edf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ee4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	eb 08                	jmp    802ef3 <alloc_block_BF+0x317>
  802eeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eee:	a3 44 50 80 00       	mov    %eax,0x805044
  802ef3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef6:	a3 48 50 80 00       	mov    %eax,0x805048
  802efb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f04:	a1 50 50 80 00       	mov    0x805050,%eax
  802f09:	40                   	inc    %eax
  802f0a:	a3 50 50 80 00       	mov    %eax,0x805050
  802f0f:	eb 6e                	jmp    802f7f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f15:	74 06                	je     802f1d <alloc_block_BF+0x341>
  802f17:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f1b:	75 17                	jne    802f34 <alloc_block_BF+0x358>
  802f1d:	83 ec 04             	sub    $0x4,%esp
  802f20:	68 50 4b 80 00       	push   $0x804b50
  802f25:	68 4f 01 00 00       	push   $0x14f
  802f2a:	68 dd 4a 80 00       	push   $0x804add
  802f2f:	e8 cc d7 ff ff       	call   800700 <_panic>
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	8b 10                	mov    (%eax),%edx
  802f39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f3c:	89 10                	mov    %edx,(%eax)
  802f3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0b                	je     802f52 <alloc_block_BF+0x376>
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f58:	89 10                	mov    %edx,(%eax)
  802f5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	75 08                	jne    802f74 <alloc_block_BF+0x398>
  802f6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f6f:	a3 48 50 80 00       	mov    %eax,0x805048
  802f74:	a1 50 50 80 00       	mov    0x805050,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f83:	75 17                	jne    802f9c <alloc_block_BF+0x3c0>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 bf 4a 80 00       	push   $0x804abf
  802f8d:	68 51 01 00 00       	push   $0x151
  802f92:	68 dd 4a 80 00       	push   $0x804add
  802f97:	e8 64 d7 ff ff       	call   800700 <_panic>
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 10                	je     802fb5 <alloc_block_BF+0x3d9>
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fad:	8b 52 04             	mov    0x4(%edx),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 0b                	jmp    802fc0 <alloc_block_BF+0x3e4>
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	a3 48 50 80 00       	mov    %eax,0x805048
  802fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0f                	je     802fd9 <alloc_block_BF+0x3fd>
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd3:	8b 12                	mov    (%edx),%edx
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	eb 0a                	jmp    802fe3 <alloc_block_BF+0x407>
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	a3 44 50 80 00       	mov    %eax,0x805044
  802fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 50 50 80 00       	mov    0x805050,%eax
  802ffb:	48                   	dec    %eax
  802ffc:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  803001:	83 ec 04             	sub    $0x4,%esp
  803004:	6a 00                	push   $0x0
  803006:	ff 75 d0             	pushl  -0x30(%ebp)
  803009:	ff 75 cc             	pushl  -0x34(%ebp)
  80300c:	e8 e0 f6 ff ff       	call   8026f1 <set_block_data>
  803011:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	e9 a3 01 00 00       	jmp    8031bf <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80301c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803020:	0f 85 9d 00 00 00    	jne    8030c3 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	6a 01                	push   $0x1
  80302b:	ff 75 ec             	pushl  -0x14(%ebp)
  80302e:	ff 75 f0             	pushl  -0x10(%ebp)
  803031:	e8 bb f6 ff ff       	call   8026f1 <set_block_data>
  803036:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803039:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303d:	75 17                	jne    803056 <alloc_block_BF+0x47a>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 bf 4a 80 00       	push   $0x804abf
  803047:	68 58 01 00 00       	push   $0x158
  80304c:	68 dd 4a 80 00       	push   $0x804add
  803051:	e8 aa d6 ff ff       	call   800700 <_panic>
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 10                	je     80306f <alloc_block_BF+0x493>
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803067:	8b 52 04             	mov    0x4(%edx),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 0b                	jmp    80307a <alloc_block_BF+0x49e>
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	a3 48 50 80 00       	mov    %eax,0x805048
  80307a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0f                	je     803093 <alloc_block_BF+0x4b7>
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80308d:	8b 12                	mov    (%edx),%edx
  80308f:	89 10                	mov    %edx,(%eax)
  803091:	eb 0a                	jmp    80309d <alloc_block_BF+0x4c1>
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	a3 44 50 80 00       	mov    %eax,0x805044
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8030b5:	48                   	dec    %eax
  8030b6:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  8030bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030be:	e9 fc 00 00 00       	jmp    8031bf <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	83 c0 08             	add    $0x8,%eax
  8030c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8030cc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030d9:	01 d0                	add    %edx,%eax
  8030db:	48                   	dec    %eax
  8030dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8030df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e7:	f7 75 c4             	divl   -0x3c(%ebp)
  8030ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030ed:	29 d0                	sub    %edx,%eax
  8030ef:	c1 e8 0c             	shr    $0xc,%eax
  8030f2:	83 ec 0c             	sub    $0xc,%esp
  8030f5:	50                   	push   %eax
  8030f6:	e8 5c e6 ff ff       	call   801757 <sbrk>
  8030fb:	83 c4 10             	add    $0x10,%esp
  8030fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803101:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803105:	75 0a                	jne    803111 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803107:	b8 00 00 00 00       	mov    $0x0,%eax
  80310c:	e9 ae 00 00 00       	jmp    8031bf <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803111:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803118:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80311b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80311e:	01 d0                	add    %edx,%eax
  803120:	48                   	dec    %eax
  803121:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803124:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803127:	ba 00 00 00 00       	mov    $0x0,%edx
  80312c:	f7 75 b8             	divl   -0x48(%ebp)
  80312f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803132:	29 d0                	sub    %edx,%eax
  803134:	8d 50 fc             	lea    -0x4(%eax),%edx
  803137:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80313a:	01 d0                	add    %edx,%eax
  80313c:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  803141:	a1 48 92 80 00       	mov    0x809248,%eax
  803146:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80314c:	83 ec 0c             	sub    $0xc,%esp
  80314f:	68 84 4b 80 00       	push   $0x804b84
  803154:	e8 64 d8 ff ff       	call   8009bd <cprintf>
  803159:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80315c:	83 ec 08             	sub    $0x8,%esp
  80315f:	ff 75 bc             	pushl  -0x44(%ebp)
  803162:	68 89 4b 80 00       	push   $0x804b89
  803167:	e8 51 d8 ff ff       	call   8009bd <cprintf>
  80316c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80316f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803176:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803179:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80317c:	01 d0                	add    %edx,%eax
  80317e:	48                   	dec    %eax
  80317f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803182:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803185:	ba 00 00 00 00       	mov    $0x0,%edx
  80318a:	f7 75 b0             	divl   -0x50(%ebp)
  80318d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803190:	29 d0                	sub    %edx,%eax
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	6a 01                	push   $0x1
  803197:	50                   	push   %eax
  803198:	ff 75 bc             	pushl  -0x44(%ebp)
  80319b:	e8 51 f5 ff ff       	call   8026f1 <set_block_data>
  8031a0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8031a3:	83 ec 0c             	sub    $0xc,%esp
  8031a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8031a9:	e8 36 04 00 00       	call   8035e4 <free_block>
  8031ae:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	ff 75 08             	pushl  0x8(%ebp)
  8031b7:	e8 20 fa ff ff       	call   802bdc <alloc_block_BF>
  8031bc:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8031bf:	c9                   	leave  
  8031c0:	c3                   	ret    

008031c1 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8031c1:	55                   	push   %ebp
  8031c2:	89 e5                	mov    %esp,%ebp
  8031c4:	53                   	push   %ebx
  8031c5:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8031c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8031d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031da:	74 1e                	je     8031fa <merging+0x39>
  8031dc:	ff 75 08             	pushl  0x8(%ebp)
  8031df:	e8 bc f1 ff ff       	call   8023a0 <get_block_size>
  8031e4:	83 c4 04             	add    $0x4,%esp
  8031e7:	89 c2                	mov    %eax,%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	3b 45 10             	cmp    0x10(%ebp),%eax
  8031f1:	75 07                	jne    8031fa <merging+0x39>
		prev_is_free = 1;
  8031f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8031fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031fe:	74 1e                	je     80321e <merging+0x5d>
  803200:	ff 75 10             	pushl  0x10(%ebp)
  803203:	e8 98 f1 ff ff       	call   8023a0 <get_block_size>
  803208:	83 c4 04             	add    $0x4,%esp
  80320b:	89 c2                	mov    %eax,%edx
  80320d:	8b 45 10             	mov    0x10(%ebp),%eax
  803210:	01 d0                	add    %edx,%eax
  803212:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803215:	75 07                	jne    80321e <merging+0x5d>
		next_is_free = 1;
  803217:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	0f 84 cc 00 00 00    	je     8032f4 <merging+0x133>
  803228:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322c:	0f 84 c2 00 00 00    	je     8032f4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803232:	ff 75 08             	pushl  0x8(%ebp)
  803235:	e8 66 f1 ff ff       	call   8023a0 <get_block_size>
  80323a:	83 c4 04             	add    $0x4,%esp
  80323d:	89 c3                	mov    %eax,%ebx
  80323f:	ff 75 10             	pushl  0x10(%ebp)
  803242:	e8 59 f1 ff ff       	call   8023a0 <get_block_size>
  803247:	83 c4 04             	add    $0x4,%esp
  80324a:	01 c3                	add    %eax,%ebx
  80324c:	ff 75 0c             	pushl  0xc(%ebp)
  80324f:	e8 4c f1 ff ff       	call   8023a0 <get_block_size>
  803254:	83 c4 04             	add    $0x4,%esp
  803257:	01 d8                	add    %ebx,%eax
  803259:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80325c:	6a 00                	push   $0x0
  80325e:	ff 75 ec             	pushl  -0x14(%ebp)
  803261:	ff 75 08             	pushl  0x8(%ebp)
  803264:	e8 88 f4 ff ff       	call   8026f1 <set_block_data>
  803269:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80326c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803270:	75 17                	jne    803289 <merging+0xc8>
  803272:	83 ec 04             	sub    $0x4,%esp
  803275:	68 bf 4a 80 00       	push   $0x804abf
  80327a:	68 7d 01 00 00       	push   $0x17d
  80327f:	68 dd 4a 80 00       	push   $0x804add
  803284:	e8 77 d4 ff ff       	call   800700 <_panic>
  803289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 10                	je     8032a2 <merging+0xe1>
  803292:	8b 45 0c             	mov    0xc(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80329a:	8b 52 04             	mov    0x4(%edx),%edx
  80329d:	89 50 04             	mov    %edx,0x4(%eax)
  8032a0:	eb 0b                	jmp    8032ad <merging+0xec>
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	8b 40 04             	mov    0x4(%eax),%eax
  8032a8:	a3 48 50 80 00       	mov    %eax,0x805048
  8032ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b0:	8b 40 04             	mov    0x4(%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 0f                	je     8032c6 <merging+0x105>
  8032b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ba:	8b 40 04             	mov    0x4(%eax),%eax
  8032bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c0:	8b 12                	mov    (%edx),%edx
  8032c2:	89 10                	mov    %edx,(%eax)
  8032c4:	eb 0a                	jmp    8032d0 <merging+0x10f>
  8032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8032d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8032e8:	48                   	dec    %eax
  8032e9:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8032ee:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032ef:	e9 ea 02 00 00       	jmp    8035de <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8032f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f8:	74 3b                	je     803335 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8032fa:	83 ec 0c             	sub    $0xc,%esp
  8032fd:	ff 75 08             	pushl  0x8(%ebp)
  803300:	e8 9b f0 ff ff       	call   8023a0 <get_block_size>
  803305:	83 c4 10             	add    $0x10,%esp
  803308:	89 c3                	mov    %eax,%ebx
  80330a:	83 ec 0c             	sub    $0xc,%esp
  80330d:	ff 75 10             	pushl  0x10(%ebp)
  803310:	e8 8b f0 ff ff       	call   8023a0 <get_block_size>
  803315:	83 c4 10             	add    $0x10,%esp
  803318:	01 d8                	add    %ebx,%eax
  80331a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80331d:	83 ec 04             	sub    $0x4,%esp
  803320:	6a 00                	push   $0x0
  803322:	ff 75 e8             	pushl  -0x18(%ebp)
  803325:	ff 75 08             	pushl  0x8(%ebp)
  803328:	e8 c4 f3 ff ff       	call   8026f1 <set_block_data>
  80332d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803330:	e9 a9 02 00 00       	jmp    8035de <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803339:	0f 84 2d 01 00 00    	je     80346c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80333f:	83 ec 0c             	sub    $0xc,%esp
  803342:	ff 75 10             	pushl  0x10(%ebp)
  803345:	e8 56 f0 ff ff       	call   8023a0 <get_block_size>
  80334a:	83 c4 10             	add    $0x10,%esp
  80334d:	89 c3                	mov    %eax,%ebx
  80334f:	83 ec 0c             	sub    $0xc,%esp
  803352:	ff 75 0c             	pushl  0xc(%ebp)
  803355:	e8 46 f0 ff ff       	call   8023a0 <get_block_size>
  80335a:	83 c4 10             	add    $0x10,%esp
  80335d:	01 d8                	add    %ebx,%eax
  80335f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803362:	83 ec 04             	sub    $0x4,%esp
  803365:	6a 00                	push   $0x0
  803367:	ff 75 e4             	pushl  -0x1c(%ebp)
  80336a:	ff 75 10             	pushl  0x10(%ebp)
  80336d:	e8 7f f3 ff ff       	call   8026f1 <set_block_data>
  803372:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803375:	8b 45 10             	mov    0x10(%ebp),%eax
  803378:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80337b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80337f:	74 06                	je     803387 <merging+0x1c6>
  803381:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803385:	75 17                	jne    80339e <merging+0x1dd>
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	68 98 4b 80 00       	push   $0x804b98
  80338f:	68 8d 01 00 00       	push   $0x18d
  803394:	68 dd 4a 80 00       	push   $0x804add
  803399:	e8 62 d3 ff ff       	call   800700 <_panic>
  80339e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a1:	8b 50 04             	mov    0x4(%eax),%edx
  8033a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b5:	8b 40 04             	mov    0x4(%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0d                	je     8033c9 <merging+0x208>
  8033bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	eb 08                	jmp    8033d1 <merging+0x210>
  8033c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033cc:	a3 44 50 80 00       	mov    %eax,0x805044
  8033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033d7:	89 50 04             	mov    %edx,0x4(%eax)
  8033da:	a1 50 50 80 00       	mov    0x805050,%eax
  8033df:	40                   	inc    %eax
  8033e0:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  8033e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e9:	75 17                	jne    803402 <merging+0x241>
  8033eb:	83 ec 04             	sub    $0x4,%esp
  8033ee:	68 bf 4a 80 00       	push   $0x804abf
  8033f3:	68 8e 01 00 00       	push   $0x18e
  8033f8:	68 dd 4a 80 00       	push   $0x804add
  8033fd:	e8 fe d2 ff ff       	call   800700 <_panic>
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	74 10                	je     80341b <merging+0x25a>
  80340b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	8b 55 0c             	mov    0xc(%ebp),%edx
  803413:	8b 52 04             	mov    0x4(%edx),%edx
  803416:	89 50 04             	mov    %edx,0x4(%eax)
  803419:	eb 0b                	jmp    803426 <merging+0x265>
  80341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341e:	8b 40 04             	mov    0x4(%eax),%eax
  803421:	a3 48 50 80 00       	mov    %eax,0x805048
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	8b 40 04             	mov    0x4(%eax),%eax
  80342c:	85 c0                	test   %eax,%eax
  80342e:	74 0f                	je     80343f <merging+0x27e>
  803430:	8b 45 0c             	mov    0xc(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	8b 55 0c             	mov    0xc(%ebp),%edx
  803439:	8b 12                	mov    (%edx),%edx
  80343b:	89 10                	mov    %edx,(%eax)
  80343d:	eb 0a                	jmp    803449 <merging+0x288>
  80343f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	a3 44 50 80 00       	mov    %eax,0x805044
  803449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803452:	8b 45 0c             	mov    0xc(%ebp),%eax
  803455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345c:	a1 50 50 80 00       	mov    0x805050,%eax
  803461:	48                   	dec    %eax
  803462:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803467:	e9 72 01 00 00       	jmp    8035de <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80346c:	8b 45 10             	mov    0x10(%ebp),%eax
  80346f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803472:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803476:	74 79                	je     8034f1 <merging+0x330>
  803478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80347c:	74 73                	je     8034f1 <merging+0x330>
  80347e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803482:	74 06                	je     80348a <merging+0x2c9>
  803484:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803488:	75 17                	jne    8034a1 <merging+0x2e0>
  80348a:	83 ec 04             	sub    $0x4,%esp
  80348d:	68 50 4b 80 00       	push   $0x804b50
  803492:	68 94 01 00 00       	push   $0x194
  803497:	68 dd 4a 80 00       	push   $0x804add
  80349c:	e8 5f d2 ff ff       	call   800700 <_panic>
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 10                	mov    (%eax),%edx
  8034a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a9:	89 10                	mov    %edx,(%eax)
  8034ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ae:	8b 00                	mov    (%eax),%eax
  8034b0:	85 c0                	test   %eax,%eax
  8034b2:	74 0b                	je     8034bf <merging+0x2fe>
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	8b 00                	mov    (%eax),%eax
  8034b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034c5:	89 10                	mov    %edx,(%eax)
  8034c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cd:	89 50 04             	mov    %edx,0x4(%eax)
  8034d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	85 c0                	test   %eax,%eax
  8034d7:	75 08                	jne    8034e1 <merging+0x320>
  8034d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8034e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8034e6:	40                   	inc    %eax
  8034e7:	a3 50 50 80 00       	mov    %eax,0x805050
  8034ec:	e9 ce 00 00 00       	jmp    8035bf <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8034f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f5:	74 65                	je     80355c <merging+0x39b>
  8034f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034fb:	75 17                	jne    803514 <merging+0x353>
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 2c 4b 80 00       	push   $0x804b2c
  803505:	68 95 01 00 00       	push   $0x195
  80350a:	68 dd 4a 80 00       	push   $0x804add
  80350f:	e8 ec d1 ff ff       	call   800700 <_panic>
  803514:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80351a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
  803520:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0c                	je     803536 <merging+0x375>
  80352a:	a1 48 50 80 00       	mov    0x805048,%eax
  80352f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803532:	89 10                	mov    %edx,(%eax)
  803534:	eb 08                	jmp    80353e <merging+0x37d>
  803536:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803539:	a3 44 50 80 00       	mov    %eax,0x805044
  80353e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803541:	a3 48 50 80 00       	mov    %eax,0x805048
  803546:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354f:	a1 50 50 80 00       	mov    0x805050,%eax
  803554:	40                   	inc    %eax
  803555:	a3 50 50 80 00       	mov    %eax,0x805050
  80355a:	eb 63                	jmp    8035bf <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80355c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803560:	75 17                	jne    803579 <merging+0x3b8>
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	68 f8 4a 80 00       	push   $0x804af8
  80356a:	68 98 01 00 00       	push   $0x198
  80356f:	68 dd 4a 80 00       	push   $0x804add
  803574:	e8 87 d1 ff ff       	call   800700 <_panic>
  803579:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80357f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803582:	89 10                	mov    %edx,(%eax)
  803584:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 0d                	je     80359a <merging+0x3d9>
  80358d:	a1 44 50 80 00       	mov    0x805044,%eax
  803592:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	eb 08                	jmp    8035a2 <merging+0x3e1>
  80359a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359d:	a3 48 50 80 00       	mov    %eax,0x805048
  8035a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a5:	a3 44 50 80 00       	mov    %eax,0x805044
  8035aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8035b9:	40                   	inc    %eax
  8035ba:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  8035bf:	83 ec 0c             	sub    $0xc,%esp
  8035c2:	ff 75 10             	pushl  0x10(%ebp)
  8035c5:	e8 d6 ed ff ff       	call   8023a0 <get_block_size>
  8035ca:	83 c4 10             	add    $0x10,%esp
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	6a 00                	push   $0x0
  8035d2:	50                   	push   %eax
  8035d3:	ff 75 10             	pushl  0x10(%ebp)
  8035d6:	e8 16 f1 ff ff       	call   8026f1 <set_block_data>
  8035db:	83 c4 10             	add    $0x10,%esp
	}
}
  8035de:	90                   	nop
  8035df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035e2:	c9                   	leave  
  8035e3:	c3                   	ret    

008035e4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8035e4:	55                   	push   %ebp
  8035e5:	89 e5                	mov    %esp,%ebp
  8035e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8035ea:	a1 44 50 80 00       	mov    0x805044,%eax
  8035ef:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8035f2:	a1 48 50 80 00       	mov    0x805048,%eax
  8035f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035fa:	73 1b                	jae    803617 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8035fc:	a1 48 50 80 00       	mov    0x805048,%eax
  803601:	83 ec 04             	sub    $0x4,%esp
  803604:	ff 75 08             	pushl  0x8(%ebp)
  803607:	6a 00                	push   $0x0
  803609:	50                   	push   %eax
  80360a:	e8 b2 fb ff ff       	call   8031c1 <merging>
  80360f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803612:	e9 8b 00 00 00       	jmp    8036a2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803617:	a1 44 50 80 00       	mov    0x805044,%eax
  80361c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80361f:	76 18                	jbe    803639 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803621:	a1 44 50 80 00       	mov    0x805044,%eax
  803626:	83 ec 04             	sub    $0x4,%esp
  803629:	ff 75 08             	pushl  0x8(%ebp)
  80362c:	50                   	push   %eax
  80362d:	6a 00                	push   $0x0
  80362f:	e8 8d fb ff ff       	call   8031c1 <merging>
  803634:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803637:	eb 69                	jmp    8036a2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803639:	a1 44 50 80 00       	mov    0x805044,%eax
  80363e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803641:	eb 39                	jmp    80367c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803646:	3b 45 08             	cmp    0x8(%ebp),%eax
  803649:	73 29                	jae    803674 <free_block+0x90>
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	3b 45 08             	cmp    0x8(%ebp),%eax
  803653:	76 1f                	jbe    803674 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	ff 75 08             	pushl  0x8(%ebp)
  803663:	ff 75 f0             	pushl  -0x10(%ebp)
  803666:	ff 75 f4             	pushl  -0xc(%ebp)
  803669:	e8 53 fb ff ff       	call   8031c1 <merging>
  80366e:	83 c4 10             	add    $0x10,%esp
			break;
  803671:	90                   	nop
		}
	}
}
  803672:	eb 2e                	jmp    8036a2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803674:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803680:	74 07                	je     803689 <free_block+0xa5>
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	eb 05                	jmp    80368e <free_block+0xaa>
  803689:	b8 00 00 00 00       	mov    $0x0,%eax
  80368e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803693:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	75 a7                	jne    803643 <free_block+0x5f>
  80369c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a0:	75 a1                	jne    803643 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036a2:	90                   	nop
  8036a3:	c9                   	leave  
  8036a4:	c3                   	ret    

008036a5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
  8036a8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8036ab:	ff 75 08             	pushl  0x8(%ebp)
  8036ae:	e8 ed ec ff ff       	call   8023a0 <get_block_size>
  8036b3:	83 c4 04             	add    $0x4,%esp
  8036b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8036b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8036c0:	eb 17                	jmp    8036d9 <copy_data+0x34>
  8036c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c8:	01 c2                	add    %eax,%edx
  8036ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	01 c8                	add    %ecx,%eax
  8036d2:	8a 00                	mov    (%eax),%al
  8036d4:	88 02                	mov    %al,(%edx)
  8036d6:	ff 45 fc             	incl   -0x4(%ebp)
  8036d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036df:	72 e1                	jb     8036c2 <copy_data+0x1d>
}
  8036e1:	90                   	nop
  8036e2:	c9                   	leave  
  8036e3:	c3                   	ret    

008036e4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8036e4:	55                   	push   %ebp
  8036e5:	89 e5                	mov    %esp,%ebp
  8036e7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8036ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ee:	75 23                	jne    803713 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8036f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036f4:	74 13                	je     803709 <realloc_block_FF+0x25>
  8036f6:	83 ec 0c             	sub    $0xc,%esp
  8036f9:	ff 75 0c             	pushl  0xc(%ebp)
  8036fc:	e8 1f f0 ff ff       	call   802720 <alloc_block_FF>
  803701:	83 c4 10             	add    $0x10,%esp
  803704:	e9 f4 06 00 00       	jmp    803dfd <realloc_block_FF+0x719>
		return NULL;
  803709:	b8 00 00 00 00       	mov    $0x0,%eax
  80370e:	e9 ea 06 00 00       	jmp    803dfd <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803717:	75 18                	jne    803731 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803719:	83 ec 0c             	sub    $0xc,%esp
  80371c:	ff 75 08             	pushl  0x8(%ebp)
  80371f:	e8 c0 fe ff ff       	call   8035e4 <free_block>
  803724:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803727:	b8 00 00 00 00       	mov    $0x0,%eax
  80372c:	e9 cc 06 00 00       	jmp    803dfd <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803731:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803735:	77 07                	ja     80373e <realloc_block_FF+0x5a>
  803737:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80373e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803741:	83 e0 01             	and    $0x1,%eax
  803744:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374a:	83 c0 08             	add    $0x8,%eax
  80374d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803750:	83 ec 0c             	sub    $0xc,%esp
  803753:	ff 75 08             	pushl  0x8(%ebp)
  803756:	e8 45 ec ff ff       	call   8023a0 <get_block_size>
  80375b:	83 c4 10             	add    $0x10,%esp
  80375e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803764:	83 e8 08             	sub    $0x8,%eax
  803767:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	83 e8 04             	sub    $0x4,%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	83 e0 fe             	and    $0xfffffffe,%eax
  803775:	89 c2                	mov    %eax,%edx
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	01 d0                	add    %edx,%eax
  80377c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80377f:	83 ec 0c             	sub    $0xc,%esp
  803782:	ff 75 e4             	pushl  -0x1c(%ebp)
  803785:	e8 16 ec ff ff       	call   8023a0 <get_block_size>
  80378a:	83 c4 10             	add    $0x10,%esp
  80378d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803793:	83 e8 08             	sub    $0x8,%eax
  803796:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80379f:	75 08                	jne    8037a9 <realloc_block_FF+0xc5>
	{
		 return va;
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	e9 54 06 00 00       	jmp    803dfd <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8037a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037af:	0f 83 e5 03 00 00    	jae    803b9a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8037b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8037be:	83 ec 0c             	sub    $0xc,%esp
  8037c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c4:	e8 f0 eb ff ff       	call   8023b9 <is_free_block>
  8037c9:	83 c4 10             	add    $0x10,%esp
  8037cc:	84 c0                	test   %al,%al
  8037ce:	0f 84 3b 01 00 00    	je     80390f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8037d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037da:	01 d0                	add    %edx,%eax
  8037dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8037df:	83 ec 04             	sub    $0x4,%esp
  8037e2:	6a 01                	push   $0x1
  8037e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8037e7:	ff 75 08             	pushl  0x8(%ebp)
  8037ea:	e8 02 ef ff ff       	call   8026f1 <set_block_data>
  8037ef:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	83 e8 04             	sub    $0x4,%eax
  8037f8:	8b 00                	mov    (%eax),%eax
  8037fa:	83 e0 fe             	and    $0xfffffffe,%eax
  8037fd:	89 c2                	mov    %eax,%edx
  8037ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803802:	01 d0                	add    %edx,%eax
  803804:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	6a 00                	push   $0x0
  80380c:	ff 75 cc             	pushl  -0x34(%ebp)
  80380f:	ff 75 c8             	pushl  -0x38(%ebp)
  803812:	e8 da ee ff ff       	call   8026f1 <set_block_data>
  803817:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80381a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80381e:	74 06                	je     803826 <realloc_block_FF+0x142>
  803820:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803824:	75 17                	jne    80383d <realloc_block_FF+0x159>
  803826:	83 ec 04             	sub    $0x4,%esp
  803829:	68 50 4b 80 00       	push   $0x804b50
  80382e:	68 f6 01 00 00       	push   $0x1f6
  803833:	68 dd 4a 80 00       	push   $0x804add
  803838:	e8 c3 ce ff ff       	call   800700 <_panic>
  80383d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803840:	8b 10                	mov    (%eax),%edx
  803842:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803845:	89 10                	mov    %edx,(%eax)
  803847:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0b                	je     80385b <realloc_block_FF+0x177>
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	8b 00                	mov    (%eax),%eax
  803855:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803858:	89 50 04             	mov    %edx,0x4(%eax)
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803861:	89 10                	mov    %edx,(%eax)
  803863:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803869:	89 50 04             	mov    %edx,0x4(%eax)
  80386c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80386f:	8b 00                	mov    (%eax),%eax
  803871:	85 c0                	test   %eax,%eax
  803873:	75 08                	jne    80387d <realloc_block_FF+0x199>
  803875:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803878:	a3 48 50 80 00       	mov    %eax,0x805048
  80387d:	a1 50 50 80 00       	mov    0x805050,%eax
  803882:	40                   	inc    %eax
  803883:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80388c:	75 17                	jne    8038a5 <realloc_block_FF+0x1c1>
  80388e:	83 ec 04             	sub    $0x4,%esp
  803891:	68 bf 4a 80 00       	push   $0x804abf
  803896:	68 f7 01 00 00       	push   $0x1f7
  80389b:	68 dd 4a 80 00       	push   $0x804add
  8038a0:	e8 5b ce ff ff       	call   800700 <_panic>
  8038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a8:	8b 00                	mov    (%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 10                	je     8038be <realloc_block_FF+0x1da>
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b6:	8b 52 04             	mov    0x4(%edx),%edx
  8038b9:	89 50 04             	mov    %edx,0x4(%eax)
  8038bc:	eb 0b                	jmp    8038c9 <realloc_block_FF+0x1e5>
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	a3 48 50 80 00       	mov    %eax,0x805048
  8038c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cc:	8b 40 04             	mov    0x4(%eax),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 0f                	je     8038e2 <realloc_block_FF+0x1fe>
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	8b 40 04             	mov    0x4(%eax),%eax
  8038d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038dc:	8b 12                	mov    (%edx),%edx
  8038de:	89 10                	mov    %edx,(%eax)
  8038e0:	eb 0a                	jmp    8038ec <realloc_block_FF+0x208>
  8038e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	a3 44 50 80 00       	mov    %eax,0x805044
  8038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ff:	a1 50 50 80 00       	mov    0x805050,%eax
  803904:	48                   	dec    %eax
  803905:	a3 50 50 80 00       	mov    %eax,0x805050
  80390a:	e9 83 02 00 00       	jmp    803b92 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80390f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803913:	0f 86 69 02 00 00    	jbe    803b82 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803919:	83 ec 04             	sub    $0x4,%esp
  80391c:	6a 01                	push   $0x1
  80391e:	ff 75 f0             	pushl  -0x10(%ebp)
  803921:	ff 75 08             	pushl  0x8(%ebp)
  803924:	e8 c8 ed ff ff       	call   8026f1 <set_block_data>
  803929:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	83 e8 04             	sub    $0x4,%eax
  803932:	8b 00                	mov    (%eax),%eax
  803934:	83 e0 fe             	and    $0xfffffffe,%eax
  803937:	89 c2                	mov    %eax,%edx
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	01 d0                	add    %edx,%eax
  80393e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803941:	a1 50 50 80 00       	mov    0x805050,%eax
  803946:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803949:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80394d:	75 68                	jne    8039b7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80394f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803953:	75 17                	jne    80396c <realloc_block_FF+0x288>
  803955:	83 ec 04             	sub    $0x4,%esp
  803958:	68 f8 4a 80 00       	push   $0x804af8
  80395d:	68 06 02 00 00       	push   $0x206
  803962:	68 dd 4a 80 00       	push   $0x804add
  803967:	e8 94 cd ff ff       	call   800700 <_panic>
  80396c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803972:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803975:	89 10                	mov    %edx,(%eax)
  803977:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	85 c0                	test   %eax,%eax
  80397e:	74 0d                	je     80398d <realloc_block_FF+0x2a9>
  803980:	a1 44 50 80 00       	mov    0x805044,%eax
  803985:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803988:	89 50 04             	mov    %edx,0x4(%eax)
  80398b:	eb 08                	jmp    803995 <realloc_block_FF+0x2b1>
  80398d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803990:	a3 48 50 80 00       	mov    %eax,0x805048
  803995:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803998:	a3 44 50 80 00       	mov    %eax,0x805044
  80399d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8039ac:	40                   	inc    %eax
  8039ad:	a3 50 50 80 00       	mov    %eax,0x805050
  8039b2:	e9 b0 01 00 00       	jmp    803b67 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8039b7:	a1 44 50 80 00       	mov    0x805044,%eax
  8039bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039bf:	76 68                	jbe    803a29 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039c5:	75 17                	jne    8039de <realloc_block_FF+0x2fa>
  8039c7:	83 ec 04             	sub    $0x4,%esp
  8039ca:	68 f8 4a 80 00       	push   $0x804af8
  8039cf:	68 0b 02 00 00       	push   $0x20b
  8039d4:	68 dd 4a 80 00       	push   $0x804add
  8039d9:	e8 22 cd ff ff       	call   800700 <_panic>
  8039de:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8039e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e7:	89 10                	mov    %edx,(%eax)
  8039e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	74 0d                	je     8039ff <realloc_block_FF+0x31b>
  8039f2:	a1 44 50 80 00       	mov    0x805044,%eax
  8039f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039fa:	89 50 04             	mov    %edx,0x4(%eax)
  8039fd:	eb 08                	jmp    803a07 <realloc_block_FF+0x323>
  8039ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a02:	a3 48 50 80 00       	mov    %eax,0x805048
  803a07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0a:	a3 44 50 80 00       	mov    %eax,0x805044
  803a0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a19:	a1 50 50 80 00       	mov    0x805050,%eax
  803a1e:	40                   	inc    %eax
  803a1f:	a3 50 50 80 00       	mov    %eax,0x805050
  803a24:	e9 3e 01 00 00       	jmp    803b67 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a29:	a1 44 50 80 00       	mov    0x805044,%eax
  803a2e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a31:	73 68                	jae    803a9b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a37:	75 17                	jne    803a50 <realloc_block_FF+0x36c>
  803a39:	83 ec 04             	sub    $0x4,%esp
  803a3c:	68 2c 4b 80 00       	push   $0x804b2c
  803a41:	68 10 02 00 00       	push   $0x210
  803a46:	68 dd 4a 80 00       	push   $0x804add
  803a4b:	e8 b0 cc ff ff       	call   800700 <_panic>
  803a50:	8b 15 48 50 80 00    	mov    0x805048,%edx
  803a56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a59:	89 50 04             	mov    %edx,0x4(%eax)
  803a5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a5f:	8b 40 04             	mov    0x4(%eax),%eax
  803a62:	85 c0                	test   %eax,%eax
  803a64:	74 0c                	je     803a72 <realloc_block_FF+0x38e>
  803a66:	a1 48 50 80 00       	mov    0x805048,%eax
  803a6b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a6e:	89 10                	mov    %edx,(%eax)
  803a70:	eb 08                	jmp    803a7a <realloc_block_FF+0x396>
  803a72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a75:	a3 44 50 80 00       	mov    %eax,0x805044
  803a7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7d:	a3 48 50 80 00       	mov    %eax,0x805048
  803a82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8b:	a1 50 50 80 00       	mov    0x805050,%eax
  803a90:	40                   	inc    %eax
  803a91:	a3 50 50 80 00       	mov    %eax,0x805050
  803a96:	e9 cc 00 00 00       	jmp    803b67 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803aa2:	a1 44 50 80 00       	mov    0x805044,%eax
  803aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aaa:	e9 8a 00 00 00       	jmp    803b39 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ab5:	73 7a                	jae    803b31 <realloc_block_FF+0x44d>
  803ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aba:	8b 00                	mov    (%eax),%eax
  803abc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803abf:	73 70                	jae    803b31 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac5:	74 06                	je     803acd <realloc_block_FF+0x3e9>
  803ac7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803acb:	75 17                	jne    803ae4 <realloc_block_FF+0x400>
  803acd:	83 ec 04             	sub    $0x4,%esp
  803ad0:	68 50 4b 80 00       	push   $0x804b50
  803ad5:	68 1a 02 00 00       	push   $0x21a
  803ada:	68 dd 4a 80 00       	push   $0x804add
  803adf:	e8 1c cc ff ff       	call   800700 <_panic>
  803ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae7:	8b 10                	mov    (%eax),%edx
  803ae9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aec:	89 10                	mov    %edx,(%eax)
  803aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 0b                	je     803b02 <realloc_block_FF+0x41e>
  803af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aff:	89 50 04             	mov    %edx,0x4(%eax)
  803b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b08:	89 10                	mov    %edx,(%eax)
  803b0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b10:	89 50 04             	mov    %edx,0x4(%eax)
  803b13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	85 c0                	test   %eax,%eax
  803b1a:	75 08                	jne    803b24 <realloc_block_FF+0x440>
  803b1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1f:	a3 48 50 80 00       	mov    %eax,0x805048
  803b24:	a1 50 50 80 00       	mov    0x805050,%eax
  803b29:	40                   	inc    %eax
  803b2a:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  803b2f:	eb 36                	jmp    803b67 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b31:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b3d:	74 07                	je     803b46 <realloc_block_FF+0x462>
  803b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	eb 05                	jmp    803b4b <realloc_block_FF+0x467>
  803b46:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803b50:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803b55:	85 c0                	test   %eax,%eax
  803b57:	0f 85 52 ff ff ff    	jne    803aaf <realloc_block_FF+0x3cb>
  803b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b61:	0f 85 48 ff ff ff    	jne    803aaf <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b67:	83 ec 04             	sub    $0x4,%esp
  803b6a:	6a 00                	push   $0x0
  803b6c:	ff 75 d8             	pushl  -0x28(%ebp)
  803b6f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b72:	e8 7a eb ff ff       	call   8026f1 <set_block_data>
  803b77:	83 c4 10             	add    $0x10,%esp
				return va;
  803b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7d:	e9 7b 02 00 00       	jmp    803dfd <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b82:	83 ec 0c             	sub    $0xc,%esp
  803b85:	68 cd 4b 80 00       	push   $0x804bcd
  803b8a:	e8 2e ce ff ff       	call   8009bd <cprintf>
  803b8f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	e9 63 02 00 00       	jmp    803dfd <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b9d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ba0:	0f 86 4d 02 00 00    	jbe    803df3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ba6:	83 ec 0c             	sub    $0xc,%esp
  803ba9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bac:	e8 08 e8 ff ff       	call   8023b9 <is_free_block>
  803bb1:	83 c4 10             	add    $0x10,%esp
  803bb4:	84 c0                	test   %al,%al
  803bb6:	0f 84 37 02 00 00    	je     803df3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bbf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803bc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803bc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803bc8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803bcb:	76 38                	jbe    803c05 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803bcd:	83 ec 0c             	sub    $0xc,%esp
  803bd0:	ff 75 08             	pushl  0x8(%ebp)
  803bd3:	e8 0c fa ff ff       	call   8035e4 <free_block>
  803bd8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803bdb:	83 ec 0c             	sub    $0xc,%esp
  803bde:	ff 75 0c             	pushl  0xc(%ebp)
  803be1:	e8 3a eb ff ff       	call   802720 <alloc_block_FF>
  803be6:	83 c4 10             	add    $0x10,%esp
  803be9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803bec:	83 ec 08             	sub    $0x8,%esp
  803bef:	ff 75 c0             	pushl  -0x40(%ebp)
  803bf2:	ff 75 08             	pushl  0x8(%ebp)
  803bf5:	e8 ab fa ff ff       	call   8036a5 <copy_data>
  803bfa:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803bfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c00:	e9 f8 01 00 00       	jmp    803dfd <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c08:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c0b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c0e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c12:	0f 87 a0 00 00 00    	ja     803cb8 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c1c:	75 17                	jne    803c35 <realloc_block_FF+0x551>
  803c1e:	83 ec 04             	sub    $0x4,%esp
  803c21:	68 bf 4a 80 00       	push   $0x804abf
  803c26:	68 38 02 00 00       	push   $0x238
  803c2b:	68 dd 4a 80 00       	push   $0x804add
  803c30:	e8 cb ca ff ff       	call   800700 <_panic>
  803c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	74 10                	je     803c4e <realloc_block_FF+0x56a>
  803c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c41:	8b 00                	mov    (%eax),%eax
  803c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c46:	8b 52 04             	mov    0x4(%edx),%edx
  803c49:	89 50 04             	mov    %edx,0x4(%eax)
  803c4c:	eb 0b                	jmp    803c59 <realloc_block_FF+0x575>
  803c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c51:	8b 40 04             	mov    0x4(%eax),%eax
  803c54:	a3 48 50 80 00       	mov    %eax,0x805048
  803c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5c:	8b 40 04             	mov    0x4(%eax),%eax
  803c5f:	85 c0                	test   %eax,%eax
  803c61:	74 0f                	je     803c72 <realloc_block_FF+0x58e>
  803c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c66:	8b 40 04             	mov    0x4(%eax),%eax
  803c69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c6c:	8b 12                	mov    (%edx),%edx
  803c6e:	89 10                	mov    %edx,(%eax)
  803c70:	eb 0a                	jmp    803c7c <realloc_block_FF+0x598>
  803c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c75:	8b 00                	mov    (%eax),%eax
  803c77:	a3 44 50 80 00       	mov    %eax,0x805044
  803c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8f:	a1 50 50 80 00       	mov    0x805050,%eax
  803c94:	48                   	dec    %eax
  803c95:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca0:	01 d0                	add    %edx,%eax
  803ca2:	83 ec 04             	sub    $0x4,%esp
  803ca5:	6a 01                	push   $0x1
  803ca7:	50                   	push   %eax
  803ca8:	ff 75 08             	pushl  0x8(%ebp)
  803cab:	e8 41 ea ff ff       	call   8026f1 <set_block_data>
  803cb0:	83 c4 10             	add    $0x10,%esp
  803cb3:	e9 36 01 00 00       	jmp    803dee <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803cb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cbb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cbe:	01 d0                	add    %edx,%eax
  803cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803cc3:	83 ec 04             	sub    $0x4,%esp
  803cc6:	6a 01                	push   $0x1
  803cc8:	ff 75 f0             	pushl  -0x10(%ebp)
  803ccb:	ff 75 08             	pushl  0x8(%ebp)
  803cce:	e8 1e ea ff ff       	call   8026f1 <set_block_data>
  803cd3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	83 e8 04             	sub    $0x4,%eax
  803cdc:	8b 00                	mov    (%eax),%eax
  803cde:	83 e0 fe             	and    $0xfffffffe,%eax
  803ce1:	89 c2                	mov    %eax,%edx
  803ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce6:	01 d0                	add    %edx,%eax
  803ce8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ceb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cef:	74 06                	je     803cf7 <realloc_block_FF+0x613>
  803cf1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803cf5:	75 17                	jne    803d0e <realloc_block_FF+0x62a>
  803cf7:	83 ec 04             	sub    $0x4,%esp
  803cfa:	68 50 4b 80 00       	push   $0x804b50
  803cff:	68 44 02 00 00       	push   $0x244
  803d04:	68 dd 4a 80 00       	push   $0x804add
  803d09:	e8 f2 c9 ff ff       	call   800700 <_panic>
  803d0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d11:	8b 10                	mov    (%eax),%edx
  803d13:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d16:	89 10                	mov    %edx,(%eax)
  803d18:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d1b:	8b 00                	mov    (%eax),%eax
  803d1d:	85 c0                	test   %eax,%eax
  803d1f:	74 0b                	je     803d2c <realloc_block_FF+0x648>
  803d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d24:	8b 00                	mov    (%eax),%eax
  803d26:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d29:	89 50 04             	mov    %edx,0x4(%eax)
  803d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d32:	89 10                	mov    %edx,(%eax)
  803d34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d3a:	89 50 04             	mov    %edx,0x4(%eax)
  803d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	85 c0                	test   %eax,%eax
  803d44:	75 08                	jne    803d4e <realloc_block_FF+0x66a>
  803d46:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d49:	a3 48 50 80 00       	mov    %eax,0x805048
  803d4e:	a1 50 50 80 00       	mov    0x805050,%eax
  803d53:	40                   	inc    %eax
  803d54:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d5d:	75 17                	jne    803d76 <realloc_block_FF+0x692>
  803d5f:	83 ec 04             	sub    $0x4,%esp
  803d62:	68 bf 4a 80 00       	push   $0x804abf
  803d67:	68 45 02 00 00       	push   $0x245
  803d6c:	68 dd 4a 80 00       	push   $0x804add
  803d71:	e8 8a c9 ff ff       	call   800700 <_panic>
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d79:	8b 00                	mov    (%eax),%eax
  803d7b:	85 c0                	test   %eax,%eax
  803d7d:	74 10                	je     803d8f <realloc_block_FF+0x6ab>
  803d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d82:	8b 00                	mov    (%eax),%eax
  803d84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d87:	8b 52 04             	mov    0x4(%edx),%edx
  803d8a:	89 50 04             	mov    %edx,0x4(%eax)
  803d8d:	eb 0b                	jmp    803d9a <realloc_block_FF+0x6b6>
  803d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	a3 48 50 80 00       	mov    %eax,0x805048
  803d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9d:	8b 40 04             	mov    0x4(%eax),%eax
  803da0:	85 c0                	test   %eax,%eax
  803da2:	74 0f                	je     803db3 <realloc_block_FF+0x6cf>
  803da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da7:	8b 40 04             	mov    0x4(%eax),%eax
  803daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dad:	8b 12                	mov    (%edx),%edx
  803daf:	89 10                	mov    %edx,(%eax)
  803db1:	eb 0a                	jmp    803dbd <realloc_block_FF+0x6d9>
  803db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db6:	8b 00                	mov    (%eax),%eax
  803db8:	a3 44 50 80 00       	mov    %eax,0x805044
  803dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd0:	a1 50 50 80 00       	mov    0x805050,%eax
  803dd5:	48                   	dec    %eax
  803dd6:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803ddb:	83 ec 04             	sub    $0x4,%esp
  803dde:	6a 00                	push   $0x0
  803de0:	ff 75 bc             	pushl  -0x44(%ebp)
  803de3:	ff 75 b8             	pushl  -0x48(%ebp)
  803de6:	e8 06 e9 ff ff       	call   8026f1 <set_block_data>
  803deb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803dee:	8b 45 08             	mov    0x8(%ebp),%eax
  803df1:	eb 0a                	jmp    803dfd <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803df3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803dfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803dfd:	c9                   	leave  
  803dfe:	c3                   	ret    

00803dff <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803dff:	55                   	push   %ebp
  803e00:	89 e5                	mov    %esp,%ebp
  803e02:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e05:	83 ec 04             	sub    $0x4,%esp
  803e08:	68 d4 4b 80 00       	push   $0x804bd4
  803e0d:	68 58 02 00 00       	push   $0x258
  803e12:	68 dd 4a 80 00       	push   $0x804add
  803e17:	e8 e4 c8 ff ff       	call   800700 <_panic>

00803e1c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e1c:	55                   	push   %ebp
  803e1d:	89 e5                	mov    %esp,%ebp
  803e1f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e22:	83 ec 04             	sub    $0x4,%esp
  803e25:	68 fc 4b 80 00       	push   $0x804bfc
  803e2a:	68 61 02 00 00       	push   $0x261
  803e2f:	68 dd 4a 80 00       	push   $0x804add
  803e34:	e8 c7 c8 ff ff       	call   800700 <_panic>
  803e39:	66 90                	xchg   %ax,%ax
  803e3b:	90                   	nop

00803e3c <__udivdi3>:
  803e3c:	55                   	push   %ebp
  803e3d:	57                   	push   %edi
  803e3e:	56                   	push   %esi
  803e3f:	53                   	push   %ebx
  803e40:	83 ec 1c             	sub    $0x1c,%esp
  803e43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e53:	89 ca                	mov    %ecx,%edx
  803e55:	89 f8                	mov    %edi,%eax
  803e57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e5b:	85 f6                	test   %esi,%esi
  803e5d:	75 2d                	jne    803e8c <__udivdi3+0x50>
  803e5f:	39 cf                	cmp    %ecx,%edi
  803e61:	77 65                	ja     803ec8 <__udivdi3+0x8c>
  803e63:	89 fd                	mov    %edi,%ebp
  803e65:	85 ff                	test   %edi,%edi
  803e67:	75 0b                	jne    803e74 <__udivdi3+0x38>
  803e69:	b8 01 00 00 00       	mov    $0x1,%eax
  803e6e:	31 d2                	xor    %edx,%edx
  803e70:	f7 f7                	div    %edi
  803e72:	89 c5                	mov    %eax,%ebp
  803e74:	31 d2                	xor    %edx,%edx
  803e76:	89 c8                	mov    %ecx,%eax
  803e78:	f7 f5                	div    %ebp
  803e7a:	89 c1                	mov    %eax,%ecx
  803e7c:	89 d8                	mov    %ebx,%eax
  803e7e:	f7 f5                	div    %ebp
  803e80:	89 cf                	mov    %ecx,%edi
  803e82:	89 fa                	mov    %edi,%edx
  803e84:	83 c4 1c             	add    $0x1c,%esp
  803e87:	5b                   	pop    %ebx
  803e88:	5e                   	pop    %esi
  803e89:	5f                   	pop    %edi
  803e8a:	5d                   	pop    %ebp
  803e8b:	c3                   	ret    
  803e8c:	39 ce                	cmp    %ecx,%esi
  803e8e:	77 28                	ja     803eb8 <__udivdi3+0x7c>
  803e90:	0f bd fe             	bsr    %esi,%edi
  803e93:	83 f7 1f             	xor    $0x1f,%edi
  803e96:	75 40                	jne    803ed8 <__udivdi3+0x9c>
  803e98:	39 ce                	cmp    %ecx,%esi
  803e9a:	72 0a                	jb     803ea6 <__udivdi3+0x6a>
  803e9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ea0:	0f 87 9e 00 00 00    	ja     803f44 <__udivdi3+0x108>
  803ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eab:	89 fa                	mov    %edi,%edx
  803ead:	83 c4 1c             	add    $0x1c,%esp
  803eb0:	5b                   	pop    %ebx
  803eb1:	5e                   	pop    %esi
  803eb2:	5f                   	pop    %edi
  803eb3:	5d                   	pop    %ebp
  803eb4:	c3                   	ret    
  803eb5:	8d 76 00             	lea    0x0(%esi),%esi
  803eb8:	31 ff                	xor    %edi,%edi
  803eba:	31 c0                	xor    %eax,%eax
  803ebc:	89 fa                	mov    %edi,%edx
  803ebe:	83 c4 1c             	add    $0x1c,%esp
  803ec1:	5b                   	pop    %ebx
  803ec2:	5e                   	pop    %esi
  803ec3:	5f                   	pop    %edi
  803ec4:	5d                   	pop    %ebp
  803ec5:	c3                   	ret    
  803ec6:	66 90                	xchg   %ax,%ax
  803ec8:	89 d8                	mov    %ebx,%eax
  803eca:	f7 f7                	div    %edi
  803ecc:	31 ff                	xor    %edi,%edi
  803ece:	89 fa                	mov    %edi,%edx
  803ed0:	83 c4 1c             	add    $0x1c,%esp
  803ed3:	5b                   	pop    %ebx
  803ed4:	5e                   	pop    %esi
  803ed5:	5f                   	pop    %edi
  803ed6:	5d                   	pop    %ebp
  803ed7:	c3                   	ret    
  803ed8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803edd:	89 eb                	mov    %ebp,%ebx
  803edf:	29 fb                	sub    %edi,%ebx
  803ee1:	89 f9                	mov    %edi,%ecx
  803ee3:	d3 e6                	shl    %cl,%esi
  803ee5:	89 c5                	mov    %eax,%ebp
  803ee7:	88 d9                	mov    %bl,%cl
  803ee9:	d3 ed                	shr    %cl,%ebp
  803eeb:	89 e9                	mov    %ebp,%ecx
  803eed:	09 f1                	or     %esi,%ecx
  803eef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ef3:	89 f9                	mov    %edi,%ecx
  803ef5:	d3 e0                	shl    %cl,%eax
  803ef7:	89 c5                	mov    %eax,%ebp
  803ef9:	89 d6                	mov    %edx,%esi
  803efb:	88 d9                	mov    %bl,%cl
  803efd:	d3 ee                	shr    %cl,%esi
  803eff:	89 f9                	mov    %edi,%ecx
  803f01:	d3 e2                	shl    %cl,%edx
  803f03:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f07:	88 d9                	mov    %bl,%cl
  803f09:	d3 e8                	shr    %cl,%eax
  803f0b:	09 c2                	or     %eax,%edx
  803f0d:	89 d0                	mov    %edx,%eax
  803f0f:	89 f2                	mov    %esi,%edx
  803f11:	f7 74 24 0c          	divl   0xc(%esp)
  803f15:	89 d6                	mov    %edx,%esi
  803f17:	89 c3                	mov    %eax,%ebx
  803f19:	f7 e5                	mul    %ebp
  803f1b:	39 d6                	cmp    %edx,%esi
  803f1d:	72 19                	jb     803f38 <__udivdi3+0xfc>
  803f1f:	74 0b                	je     803f2c <__udivdi3+0xf0>
  803f21:	89 d8                	mov    %ebx,%eax
  803f23:	31 ff                	xor    %edi,%edi
  803f25:	e9 58 ff ff ff       	jmp    803e82 <__udivdi3+0x46>
  803f2a:	66 90                	xchg   %ax,%ax
  803f2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f30:	89 f9                	mov    %edi,%ecx
  803f32:	d3 e2                	shl    %cl,%edx
  803f34:	39 c2                	cmp    %eax,%edx
  803f36:	73 e9                	jae    803f21 <__udivdi3+0xe5>
  803f38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f3b:	31 ff                	xor    %edi,%edi
  803f3d:	e9 40 ff ff ff       	jmp    803e82 <__udivdi3+0x46>
  803f42:	66 90                	xchg   %ax,%ax
  803f44:	31 c0                	xor    %eax,%eax
  803f46:	e9 37 ff ff ff       	jmp    803e82 <__udivdi3+0x46>
  803f4b:	90                   	nop

00803f4c <__umoddi3>:
  803f4c:	55                   	push   %ebp
  803f4d:	57                   	push   %edi
  803f4e:	56                   	push   %esi
  803f4f:	53                   	push   %ebx
  803f50:	83 ec 1c             	sub    $0x1c,%esp
  803f53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f57:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f6b:	89 f3                	mov    %esi,%ebx
  803f6d:	89 fa                	mov    %edi,%edx
  803f6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f73:	89 34 24             	mov    %esi,(%esp)
  803f76:	85 c0                	test   %eax,%eax
  803f78:	75 1a                	jne    803f94 <__umoddi3+0x48>
  803f7a:	39 f7                	cmp    %esi,%edi
  803f7c:	0f 86 a2 00 00 00    	jbe    804024 <__umoddi3+0xd8>
  803f82:	89 c8                	mov    %ecx,%eax
  803f84:	89 f2                	mov    %esi,%edx
  803f86:	f7 f7                	div    %edi
  803f88:	89 d0                	mov    %edx,%eax
  803f8a:	31 d2                	xor    %edx,%edx
  803f8c:	83 c4 1c             	add    $0x1c,%esp
  803f8f:	5b                   	pop    %ebx
  803f90:	5e                   	pop    %esi
  803f91:	5f                   	pop    %edi
  803f92:	5d                   	pop    %ebp
  803f93:	c3                   	ret    
  803f94:	39 f0                	cmp    %esi,%eax
  803f96:	0f 87 ac 00 00 00    	ja     804048 <__umoddi3+0xfc>
  803f9c:	0f bd e8             	bsr    %eax,%ebp
  803f9f:	83 f5 1f             	xor    $0x1f,%ebp
  803fa2:	0f 84 ac 00 00 00    	je     804054 <__umoddi3+0x108>
  803fa8:	bf 20 00 00 00       	mov    $0x20,%edi
  803fad:	29 ef                	sub    %ebp,%edi
  803faf:	89 fe                	mov    %edi,%esi
  803fb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fb5:	89 e9                	mov    %ebp,%ecx
  803fb7:	d3 e0                	shl    %cl,%eax
  803fb9:	89 d7                	mov    %edx,%edi
  803fbb:	89 f1                	mov    %esi,%ecx
  803fbd:	d3 ef                	shr    %cl,%edi
  803fbf:	09 c7                	or     %eax,%edi
  803fc1:	89 e9                	mov    %ebp,%ecx
  803fc3:	d3 e2                	shl    %cl,%edx
  803fc5:	89 14 24             	mov    %edx,(%esp)
  803fc8:	89 d8                	mov    %ebx,%eax
  803fca:	d3 e0                	shl    %cl,%eax
  803fcc:	89 c2                	mov    %eax,%edx
  803fce:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fd2:	d3 e0                	shl    %cl,%eax
  803fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fdc:	89 f1                	mov    %esi,%ecx
  803fde:	d3 e8                	shr    %cl,%eax
  803fe0:	09 d0                	or     %edx,%eax
  803fe2:	d3 eb                	shr    %cl,%ebx
  803fe4:	89 da                	mov    %ebx,%edx
  803fe6:	f7 f7                	div    %edi
  803fe8:	89 d3                	mov    %edx,%ebx
  803fea:	f7 24 24             	mull   (%esp)
  803fed:	89 c6                	mov    %eax,%esi
  803fef:	89 d1                	mov    %edx,%ecx
  803ff1:	39 d3                	cmp    %edx,%ebx
  803ff3:	0f 82 87 00 00 00    	jb     804080 <__umoddi3+0x134>
  803ff9:	0f 84 91 00 00 00    	je     804090 <__umoddi3+0x144>
  803fff:	8b 54 24 04          	mov    0x4(%esp),%edx
  804003:	29 f2                	sub    %esi,%edx
  804005:	19 cb                	sbb    %ecx,%ebx
  804007:	89 d8                	mov    %ebx,%eax
  804009:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80400d:	d3 e0                	shl    %cl,%eax
  80400f:	89 e9                	mov    %ebp,%ecx
  804011:	d3 ea                	shr    %cl,%edx
  804013:	09 d0                	or     %edx,%eax
  804015:	89 e9                	mov    %ebp,%ecx
  804017:	d3 eb                	shr    %cl,%ebx
  804019:	89 da                	mov    %ebx,%edx
  80401b:	83 c4 1c             	add    $0x1c,%esp
  80401e:	5b                   	pop    %ebx
  80401f:	5e                   	pop    %esi
  804020:	5f                   	pop    %edi
  804021:	5d                   	pop    %ebp
  804022:	c3                   	ret    
  804023:	90                   	nop
  804024:	89 fd                	mov    %edi,%ebp
  804026:	85 ff                	test   %edi,%edi
  804028:	75 0b                	jne    804035 <__umoddi3+0xe9>
  80402a:	b8 01 00 00 00       	mov    $0x1,%eax
  80402f:	31 d2                	xor    %edx,%edx
  804031:	f7 f7                	div    %edi
  804033:	89 c5                	mov    %eax,%ebp
  804035:	89 f0                	mov    %esi,%eax
  804037:	31 d2                	xor    %edx,%edx
  804039:	f7 f5                	div    %ebp
  80403b:	89 c8                	mov    %ecx,%eax
  80403d:	f7 f5                	div    %ebp
  80403f:	89 d0                	mov    %edx,%eax
  804041:	e9 44 ff ff ff       	jmp    803f8a <__umoddi3+0x3e>
  804046:	66 90                	xchg   %ax,%ax
  804048:	89 c8                	mov    %ecx,%eax
  80404a:	89 f2                	mov    %esi,%edx
  80404c:	83 c4 1c             	add    $0x1c,%esp
  80404f:	5b                   	pop    %ebx
  804050:	5e                   	pop    %esi
  804051:	5f                   	pop    %edi
  804052:	5d                   	pop    %ebp
  804053:	c3                   	ret    
  804054:	3b 04 24             	cmp    (%esp),%eax
  804057:	72 06                	jb     80405f <__umoddi3+0x113>
  804059:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80405d:	77 0f                	ja     80406e <__umoddi3+0x122>
  80405f:	89 f2                	mov    %esi,%edx
  804061:	29 f9                	sub    %edi,%ecx
  804063:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804067:	89 14 24             	mov    %edx,(%esp)
  80406a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80406e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804072:	8b 14 24             	mov    (%esp),%edx
  804075:	83 c4 1c             	add    $0x1c,%esp
  804078:	5b                   	pop    %ebx
  804079:	5e                   	pop    %esi
  80407a:	5f                   	pop    %edi
  80407b:	5d                   	pop    %ebp
  80407c:	c3                   	ret    
  80407d:	8d 76 00             	lea    0x0(%esi),%esi
  804080:	2b 04 24             	sub    (%esp),%eax
  804083:	19 fa                	sbb    %edi,%edx
  804085:	89 d1                	mov    %edx,%ecx
  804087:	89 c6                	mov    %eax,%esi
  804089:	e9 71 ff ff ff       	jmp    803fff <__umoddi3+0xb3>
  80408e:	66 90                	xchg   %ax,%ax
  804090:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804094:	72 ea                	jb     804080 <__umoddi3+0x134>
  804096:	89 d9                	mov    %ebx,%ecx
  804098:	e9 62 ff ff ff       	jmp    803fff <__umoddi3+0xb3>
