
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
  800055:	68 20 40 80 00       	push   $0x804020
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
  8000a5:	68 50 40 80 00       	push   $0x804050
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
  8000e7:	68 89 40 80 00       	push   $0x804089
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 a5 40 80 00       	push   $0x8040a5
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
  800114:	e8 dc 1c 00 00       	call   801df5 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 89 1c 00 00       	call   801daa <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 bc 40 80 00       	push   $0x8040bc
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
  8002a0:	68 18 41 80 00       	push   $0x804118
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
  80030a:	68 3c 41 80 00       	push   $0x80413c
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
  800370:	68 78 41 80 00       	push   $0x804178
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
  800397:	68 c8 41 80 00       	push   $0x8041c8
  80039c:	e8 1c 06 00 00       	call   8009bd <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 45 1a 00 00       	call   801df5 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 08 42 80 00       	push   $0x804208
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
  80047b:	68 44 42 80 00       	push   $0x804244
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
  8004a8:	e8 fd 18 00 00       	call   801daa <sys_calculate_free_frames>
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
  8004d4:	68 88 42 80 00       	push   $0x804288
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
  8004f5:	68 d4 42 80 00       	push   $0x8042d4
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
  800570:	e8 90 1c 00 00       	call   802205 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 f8 42 80 00       	push   $0x8042f8
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
  8005ae:	68 1c 43 80 00       	push   $0x80431c
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
  8005c7:	e8 a7 19 00 00       	call   801f73 <sys_getenvindex>
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
  800635:	e8 bd 16 00 00       	call   801cf7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	68 7c 43 80 00       	push   $0x80437c
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
  800665:	68 a4 43 80 00       	push   $0x8043a4
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
  800696:	68 cc 43 80 00       	push   $0x8043cc
  80069b:	e8 1d 03 00 00       	call   8009bd <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	50                   	push   %eax
  8006b2:	68 24 44 80 00       	push   $0x804424
  8006b7:	e8 01 03 00 00       	call   8009bd <cprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	68 7c 43 80 00       	push   $0x80437c
  8006c7:	e8 f1 02 00 00       	call   8009bd <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006cf:	e8 3d 16 00 00       	call   801d11 <sys_unlock_cons>
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
  8006e7:	e8 53 18 00 00       	call   801f3f <sys_destroy_env>
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
  8006f8:	e8 a8 18 00 00       	call   801fa5 <sys_exit_env>
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
  800721:	68 38 44 80 00       	push   $0x804438
  800726:	e8 92 02 00 00       	call   8009bd <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80072e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	50                   	push   %eax
  80073a:	68 3d 44 80 00       	push   $0x80443d
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
  80075e:	68 59 44 80 00       	push   $0x804459
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
  80078d:	68 5c 44 80 00       	push   $0x80445c
  800792:	6a 26                	push   $0x26
  800794:	68 a8 44 80 00       	push   $0x8044a8
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
  800862:	68 b4 44 80 00       	push   $0x8044b4
  800867:	6a 3a                	push   $0x3a
  800869:	68 a8 44 80 00       	push   $0x8044a8
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
  8008d5:	68 08 45 80 00       	push   $0x804508
  8008da:	6a 44                	push   $0x44
  8008dc:	68 a8 44 80 00       	push   $0x8044a8
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
  80092f:	e8 81 13 00 00       	call   801cb5 <sys_cputs>
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
  8009a6:	e8 0a 13 00 00       	call   801cb5 <sys_cputs>
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
  8009f0:	e8 02 13 00 00       	call   801cf7 <sys_lock_cons>
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
  800a10:	e8 fc 12 00 00       	call   801d11 <sys_unlock_cons>
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
  800a5a:	e8 59 33 00 00       	call   803db8 <__udivdi3>
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
  800aaa:	e8 19 34 00 00       	call   803ec8 <__umoddi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	05 74 47 80 00       	add    $0x804774,%eax
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
  800c05:	8b 04 85 98 47 80 00 	mov    0x804798(,%eax,4),%eax
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
  800ce6:	8b 34 9d e0 45 80 00 	mov    0x8045e0(,%ebx,4),%esi
  800ced:	85 f6                	test   %esi,%esi
  800cef:	75 19                	jne    800d0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf1:	53                   	push   %ebx
  800cf2:	68 85 47 80 00       	push   $0x804785
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
  800d0b:	68 8e 47 80 00       	push   $0x80478e
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
  800d38:	be 91 47 80 00       	mov    $0x804791,%esi
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
  801743:	68 08 49 80 00       	push   $0x804908
  801748:	68 3f 01 00 00       	push   $0x13f
  80174d:	68 2a 49 80 00       	push   $0x80492a
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
  801763:	e8 f8 0a 00 00       	call   802260 <sys_sbrk>
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
  8017de:	e8 01 09 00 00       	call   8020e4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 16                	je     8017fd <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 dd 0e 00 00       	call   8026cf <alloc_block_FF>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	e9 8a 01 00 00       	jmp    801987 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8017fd:	e8 13 09 00 00       	call   802115 <sys_isUHeapPlacementStrategyBESTFIT>
  801802:	85 c0                	test   %eax,%eax
  801804:	0f 84 7d 01 00 00    	je     801987 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	e8 76 13 00 00       	call   802b8b <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801872:	05 00 10 00 00       	add    $0x1000,%eax
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80187a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  80191a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191e:	75 16                	jne    801936 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801920:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801927:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80192e:	0f 86 15 ff ff ff    	jbe    801849 <malloc+0xdc>
  801934:	eb 01                	jmp    801937 <malloc+0x1ca>
				}
				

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
  801976:	e8 1c 09 00 00       	call   802297 <sys_allocate_user_mem>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	eb 07                	jmp    801987 <malloc+0x21a>
		
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
  8019be:	e8 8c 09 00 00       	call   80234f <get_block_size>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 9c 1b 00 00       	call   803570 <free_block>
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
  801a09:	8b 04 85 60 92 90 00 	mov    0x909260(,%eax,4),%eax
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
  801a46:	c7 04 85 60 92 88 00 	movl   $0x0,0x889260(,%eax,4)
  801a4d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	e8 1a 08 00 00       	call   80227b <sys_free_user_mem>
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
  801a74:	68 38 49 80 00       	push   $0x804938
  801a79:	68 87 00 00 00       	push   $0x87
  801a7e:	68 62 49 80 00       	push   $0x804962
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
  801aa2:	e9 87 00 00 00       	jmp    801b2e <smalloc+0xa3>
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
  801ad3:	75 07                	jne    801adc <smalloc+0x51>
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	eb 52                	jmp    801b2e <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801adc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ae0:	ff 75 ec             	pushl  -0x14(%ebp)
  801ae3:	50                   	push   %eax
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	e8 93 03 00 00       	call   801e82 <sys_createSharedObject>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801af5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801af9:	74 06                	je     801b01 <smalloc+0x76>
  801afb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801aff:	75 07                	jne    801b08 <smalloc+0x7d>
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
  801b06:	eb 26                	jmp    801b2e <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0b:	a1 20 50 80 00       	mov    0x805020,%eax
  801b10:	8b 40 78             	mov    0x78(%eax),%eax
  801b13:	29 c2                	sub    %eax,%edx
  801b15:	89 d0                	mov    %edx,%eax
  801b17:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b1c:	c1 e8 0c             	shr    $0xc,%eax
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b24:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	 return ptr;
  801b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b36:	83 ec 08             	sub    $0x8,%esp
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	e8 68 03 00 00       	call   801eac <sys_getSizeOfSharedObject>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801b4a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b4e:	75 07                	jne    801b57 <sget+0x27>
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	eb 7f                	jmp    801bd6 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b5d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6a:	39 d0                	cmp    %edx,%eax
  801b6c:	73 02                	jae    801b70 <sget+0x40>
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	50                   	push   %eax
  801b74:	e8 f4 fb ff ff       	call   80176d <malloc>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801b7f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b83:	75 07                	jne    801b8c <sget+0x5c>
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8a:	eb 4a                	jmp    801bd6 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	ff 75 e8             	pushl  -0x18(%ebp)
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	e8 2c 03 00 00       	call   801ec9 <sys_getSharedObject>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801ba3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ba6:	a1 20 50 80 00       	mov    0x805020,%eax
  801bab:	8b 40 78             	mov    0x78(%eax),%eax
  801bae:	29 c2                	sub    %eax,%edx
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb7:	c1 e8 0c             	shr    $0xc,%eax
  801bba:	89 c2                	mov    %eax,%edx
  801bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbf:	89 04 95 60 92 80 00 	mov    %eax,0x809260(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801bc6:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801bca:	75 07                	jne    801bd3 <sget+0xa3>
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd1:	eb 03                	jmp    801bd6 <sget+0xa6>
	return ptr;
  801bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801bde:	8b 55 08             	mov    0x8(%ebp),%edx
  801be1:	a1 20 50 80 00       	mov    0x805020,%eax
  801be6:	8b 40 78             	mov    0x78(%eax),%eax
  801be9:	29 c2                	sub    %eax,%edx
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf2:	c1 e8 0c             	shr    $0xc,%eax
  801bf5:	8b 04 85 60 92 80 00 	mov    0x809260(,%eax,4),%eax
  801bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	ff 75 f4             	pushl  -0xc(%ebp)
  801c08:	e8 db 02 00 00       	call   801ee8 <sys_freeSharedObject>
  801c0d:	83 c4 10             	add    $0x10,%esp
  801c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	68 70 49 80 00       	push   $0x804970
  801c24:	68 e4 00 00 00       	push   $0xe4
  801c29:	68 62 49 80 00       	push   $0x804962
  801c2e:	e8 cd ea ff ff       	call   800700 <_panic>

00801c33 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	68 96 49 80 00       	push   $0x804996
  801c41:	68 f0 00 00 00       	push   $0xf0
  801c46:	68 62 49 80 00       	push   $0x804962
  801c4b:	e8 b0 ea ff ff       	call   800700 <_panic>

00801c50 <shrink>:

}
void shrink(uint32 newSize)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	68 96 49 80 00       	push   $0x804996
  801c5e:	68 f5 00 00 00       	push   $0xf5
  801c63:	68 62 49 80 00       	push   $0x804962
  801c68:	e8 93 ea ff ff       	call   800700 <_panic>

00801c6d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	68 96 49 80 00       	push   $0x804996
  801c7b:	68 fa 00 00 00       	push   $0xfa
  801c80:	68 62 49 80 00       	push   $0x804962
  801c85:	e8 76 ea ff ff       	call   800700 <_panic>

00801c8a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	57                   	push   %edi
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c9f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ca2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ca5:	cd 30                	int    $0x30
  801ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5f                   	pop    %edi
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cc1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	50                   	push   %eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	e8 b2 ff ff ff       	call   801c8a <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_cgetc>:

int
sys_cgetc(void)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 02                	push   $0x2
  801ced:	e8 98 ff ff ff       	call   801c8a <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 03                	push   $0x3
  801d06:	e8 7f ff ff ff       	call   801c8a <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 04                	push   $0x4
  801d20:	e8 65 ff ff ff       	call   801c8a <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	90                   	nop
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	6a 08                	push   $0x8
  801d3e:	e8 47 ff ff ff       	call   801c8a <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4d:	8b 75 18             	mov    0x18(%ebp),%esi
  801d50:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	51                   	push   %ecx
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 09                	push   $0x9
  801d63:	e8 22 ff ff ff       	call   801c8a <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	6a 0a                	push   $0xa
  801d85:	e8 00 ff ff ff       	call   801c8a <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	6a 0b                	push   $0xb
  801da0:	e8 e5 fe ff ff       	call   801c8a <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 0c                	push   $0xc
  801db9:	e8 cc fe ff ff       	call   801c8a <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 0d                	push   $0xd
  801dd2:	e8 b3 fe ff ff       	call   801c8a <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 0e                	push   $0xe
  801deb:	e8 9a fe ff ff       	call   801c8a <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 0f                	push   $0xf
  801e04:	e8 81 fe ff ff       	call   801c8a <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 10                	push   $0x10
  801e1e:	e8 67 fe ff ff       	call   801c8a <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 11                	push   $0x11
  801e37:	e8 4e fe ff ff       	call   801c8a <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	50                   	push   %eax
  801e5b:	6a 01                	push   $0x1
  801e5d:	e8 28 fe ff ff       	call   801c8a <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	90                   	nop
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 14                	push   $0x14
  801e77:	e8 0e fe ff ff       	call   801c8a <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	51                   	push   %ecx
  801e9b:	52                   	push   %edx
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	50                   	push   %eax
  801ea0:	6a 15                	push   $0x15
  801ea2:	e8 e3 fd ff ff       	call   801c8a <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 16                	push   $0x16
  801ebf:	e8 c6 fd ff ff       	call   801c8a <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ecc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	51                   	push   %ecx
  801eda:	52                   	push   %edx
  801edb:	50                   	push   %eax
  801edc:	6a 17                	push   $0x17
  801ede:	e8 a7 fd ff ff       	call   801c8a <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 18                	push   $0x18
  801efb:	e8 8a fd ff ff       	call   801c8a <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 14             	pushl  0x14(%ebp)
  801f10:	ff 75 10             	pushl  0x10(%ebp)
  801f13:	ff 75 0c             	pushl  0xc(%ebp)
  801f16:	50                   	push   %eax
  801f17:	6a 19                	push   $0x19
  801f19:	e8 6c fd ff ff       	call   801c8a <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	50                   	push   %eax
  801f32:	6a 1a                	push   $0x1a
  801f34:	e8 51 fd ff ff       	call   801c8a <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	90                   	nop
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	50                   	push   %eax
  801f4e:	6a 1b                	push   $0x1b
  801f50:	e8 35 fd ff ff       	call   801c8a <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 05                	push   $0x5
  801f69:	e8 1c fd ff ff       	call   801c8a <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 06                	push   $0x6
  801f82:	e8 03 fd ff ff       	call   801c8a <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 07                	push   $0x7
  801f9b:	e8 ea fc ff ff       	call   801c8a <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_exit_env>:


void sys_exit_env(void)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 1c                	push   $0x1c
  801fb4:	e8 d1 fc ff ff       	call   801c8a <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	90                   	nop
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fc5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fc8:	8d 50 04             	lea    0x4(%eax),%edx
  801fcb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 1d                	push   $0x1d
  801fd8:	e8 ad fc ff ff       	call   801c8a <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return result;
  801fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fe9:	89 01                	mov    %eax,(%ecx)
  801feb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	c9                   	leave  
  801ff2:	c2 04 00             	ret    $0x4

00801ff5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	ff 75 10             	pushl  0x10(%ebp)
  801fff:	ff 75 0c             	pushl  0xc(%ebp)
  802002:	ff 75 08             	pushl  0x8(%ebp)
  802005:	6a 13                	push   $0x13
  802007:	e8 7e fc ff ff       	call   801c8a <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
	return ;
  80200f:	90                   	nop
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_rcr2>:
uint32 sys_rcr2()
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 1e                	push   $0x1e
  802021:	e8 64 fc ff ff       	call   801c8a <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802037:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	50                   	push   %eax
  802044:	6a 1f                	push   $0x1f
  802046:	e8 3f fc ff ff       	call   801c8a <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
	return ;
  80204e:	90                   	nop
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <rsttst>:
void rsttst()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 21                	push   $0x21
  802060:	e8 25 fc ff ff       	call   801c8a <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
	return ;
  802068:	90                   	nop
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	8b 45 14             	mov    0x14(%ebp),%eax
  802074:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802077:	8b 55 18             	mov    0x18(%ebp),%edx
  80207a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80207e:	52                   	push   %edx
  80207f:	50                   	push   %eax
  802080:	ff 75 10             	pushl  0x10(%ebp)
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	ff 75 08             	pushl  0x8(%ebp)
  802089:	6a 20                	push   $0x20
  80208b:	e8 fa fb ff ff       	call   801c8a <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
	return ;
  802093:	90                   	nop
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <chktst>:
void chktst(uint32 n)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	ff 75 08             	pushl  0x8(%ebp)
  8020a4:	6a 22                	push   $0x22
  8020a6:	e8 df fb ff ff       	call   801c8a <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ae:	90                   	nop
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <inctst>:

void inctst()
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 23                	push   $0x23
  8020c0:	e8 c5 fb ff ff       	call   801c8a <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c8:	90                   	nop
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <gettst>:
uint32 gettst()
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 24                	push   $0x24
  8020da:	e8 ab fb ff ff       	call   801c8a <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 25                	push   $0x25
  8020f6:	e8 8f fb ff ff       	call   801c8a <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802101:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802105:	75 07                	jne    80210e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802107:	b8 01 00 00 00       	mov    $0x1,%eax
  80210c:	eb 05                	jmp    802113 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 25                	push   $0x25
  802127:	e8 5e fb ff ff       	call   801c8a <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
  80212f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802132:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802136:	75 07                	jne    80213f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802138:	b8 01 00 00 00       	mov    $0x1,%eax
  80213d:	eb 05                	jmp    802144 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 25                	push   $0x25
  802158:	e8 2d fb ff ff       	call   801c8a <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
  802160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802163:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802167:	75 07                	jne    802170 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802169:	b8 01 00 00 00       	mov    $0x1,%eax
  80216e:	eb 05                	jmp    802175 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 25                	push   $0x25
  802189:	e8 fc fa ff ff       	call   801c8a <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
  802191:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802194:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802198:	75 07                	jne    8021a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80219a:	b8 01 00 00 00       	mov    $0x1,%eax
  80219f:	eb 05                	jmp    8021a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	6a 26                	push   $0x26
  8021b8:	e8 cd fa ff ff       	call   801c8a <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c0:	90                   	nop
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	53                   	push   %ebx
  8021d6:	51                   	push   %ecx
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 27                	push   $0x27
  8021db:	e8 aa fa ff ff       	call   801c8a <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	6a 28                	push   $0x28
  8021fb:	e8 8a fa ff ff       	call   801c8a <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802208:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80220b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	6a 00                	push   $0x0
  802213:	51                   	push   %ecx
  802214:	ff 75 10             	pushl  0x10(%ebp)
  802217:	52                   	push   %edx
  802218:	50                   	push   %eax
  802219:	6a 29                	push   $0x29
  80221b:	e8 6a fa ff ff       	call   801c8a <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	ff 75 10             	pushl  0x10(%ebp)
  80222f:	ff 75 0c             	pushl  0xc(%ebp)
  802232:	ff 75 08             	pushl  0x8(%ebp)
  802235:	6a 12                	push   $0x12
  802237:	e8 4e fa ff ff       	call   801c8a <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
	return ;
  80223f:	90                   	nop
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802245:	8b 55 0c             	mov    0xc(%ebp),%edx
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	52                   	push   %edx
  802252:	50                   	push   %eax
  802253:	6a 2a                	push   $0x2a
  802255:	e8 30 fa ff ff       	call   801c8a <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
	return;
  80225d:	90                   	nop
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	50                   	push   %eax
  80226f:	6a 2b                	push   $0x2b
  802271:	e8 14 fa ff ff       	call   801c8a <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	6a 2c                	push   $0x2c
  80228c:	e8 f9 f9 ff ff       	call   801c8a <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
	return;
  802294:	90                   	nop
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	6a 2d                	push   $0x2d
  8022a8:	e8 dd f9 ff ff       	call   801c8a <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
	return;
  8022b0:	90                   	nop
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 2e                	push   $0x2e
  8022c5:	e8 c0 f9 ff ff       	call   801c8a <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
  8022cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8022d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	50                   	push   %eax
  8022e4:	6a 2f                	push   $0x2f
  8022e6:	e8 9f f9 ff ff       	call   801c8a <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
	return;
  8022ee:	90                   	nop
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	52                   	push   %edx
  802301:	50                   	push   %eax
  802302:	6a 30                	push   $0x30
  802304:	e8 81 f9 ff ff       	call   801c8a <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
	return;
  80230c:	90                   	nop
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	50                   	push   %eax
  802321:	6a 31                	push   $0x31
  802323:	e8 62 f9 ff ff       	call   801c8a <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
  80232b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80232e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	50                   	push   %eax
  802342:	6a 32                	push   $0x32
  802344:	e8 41 f9 ff ff       	call   801c8a <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
	return;
  80234c:	90                   	nop
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	83 e8 04             	sub    $0x4,%eax
  80235b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8b 00                	mov    (%eax),%eax
  802363:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	83 e8 04             	sub    $0x4,%eax
  802374:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	83 e0 01             	and    $0x1,%eax
  80237f:	85 c0                	test   %eax,%eax
  802381:	0f 94 c0             	sete   %al
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80238c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802393:	8b 45 0c             	mov    0xc(%ebp),%eax
  802396:	83 f8 02             	cmp    $0x2,%eax
  802399:	74 2b                	je     8023c6 <alloc_block+0x40>
  80239b:	83 f8 02             	cmp    $0x2,%eax
  80239e:	7f 07                	jg     8023a7 <alloc_block+0x21>
  8023a0:	83 f8 01             	cmp    $0x1,%eax
  8023a3:	74 0e                	je     8023b3 <alloc_block+0x2d>
  8023a5:	eb 58                	jmp    8023ff <alloc_block+0x79>
  8023a7:	83 f8 03             	cmp    $0x3,%eax
  8023aa:	74 2d                	je     8023d9 <alloc_block+0x53>
  8023ac:	83 f8 04             	cmp    $0x4,%eax
  8023af:	74 3b                	je     8023ec <alloc_block+0x66>
  8023b1:	eb 4c                	jmp    8023ff <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	ff 75 08             	pushl  0x8(%ebp)
  8023b9:	e8 11 03 00 00       	call   8026cf <alloc_block_FF>
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023c4:	eb 4a                	jmp    802410 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 08             	pushl  0x8(%ebp)
  8023cc:	e8 c7 19 00 00       	call   803d98 <alloc_block_NF>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023d7:	eb 37                	jmp    802410 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	ff 75 08             	pushl  0x8(%ebp)
  8023df:	e8 a7 07 00 00       	call   802b8b <alloc_block_BF>
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023ea:	eb 24                	jmp    802410 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	e8 84 19 00 00       	call   803d7b <alloc_block_WF>
  8023f7:	83 c4 10             	add    $0x10,%esp
  8023fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023fd:	eb 11                	jmp    802410 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023ff:	83 ec 0c             	sub    $0xc,%esp
  802402:	68 a8 49 80 00       	push   $0x8049a8
  802407:	e8 b1 e5 ff ff       	call   8009bd <cprintf>
  80240c:	83 c4 10             	add    $0x10,%esp
		break;
  80240f:	90                   	nop
	}
	return va;
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	53                   	push   %ebx
  802419:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80241c:	83 ec 0c             	sub    $0xc,%esp
  80241f:	68 c8 49 80 00       	push   $0x8049c8
  802424:	e8 94 e5 ff ff       	call   8009bd <cprintf>
  802429:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	68 f3 49 80 00       	push   $0x8049f3
  802434:	e8 84 e5 ff ff       	call   8009bd <cprintf>
  802439:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	eb 37                	jmp    80247b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	ff 75 f4             	pushl  -0xc(%ebp)
  80244a:	e8 19 ff ff ff       	call   802368 <is_free_block>
  80244f:	83 c4 10             	add    $0x10,%esp
  802452:	0f be d8             	movsbl %al,%ebx
  802455:	83 ec 0c             	sub    $0xc,%esp
  802458:	ff 75 f4             	pushl  -0xc(%ebp)
  80245b:	e8 ef fe ff ff       	call   80234f <get_block_size>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	53                   	push   %ebx
  802467:	50                   	push   %eax
  802468:	68 0b 4a 80 00       	push   $0x804a0b
  80246d:	e8 4b e5 ff ff       	call   8009bd <cprintf>
  802472:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802475:	8b 45 10             	mov    0x10(%ebp),%eax
  802478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	74 07                	je     802488 <print_blocks_list+0x73>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	eb 05                	jmp    80248d <print_blocks_list+0x78>
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
  80248d:	89 45 10             	mov    %eax,0x10(%ebp)
  802490:	8b 45 10             	mov    0x10(%ebp),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	75 ad                	jne    802444 <print_blocks_list+0x2f>
  802497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249b:	75 a7                	jne    802444 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	68 c8 49 80 00       	push   $0x8049c8
  8024a5:	e8 13 e5 ff ff       	call   8009bd <cprintf>
  8024aa:	83 c4 10             	add    $0x10,%esp

}
  8024ad:	90                   	nop
  8024ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bc:	83 e0 01             	and    $0x1,%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	74 03                	je     8024c6 <initialize_dynamic_allocator+0x13>
  8024c3:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8024c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024ca:	0f 84 c7 01 00 00    	je     802697 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8024d0:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8024d7:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8024da:	8b 55 08             	mov    0x8(%ebp),%edx
  8024dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8024e7:	0f 87 ad 01 00 00    	ja     80269a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 89 a5 01 00 00    	jns    80269d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8024f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fe:	01 d0                	add    %edx,%eax
  802500:	83 e8 04             	sub    $0x4,%eax
  802503:	a3 4c 92 80 00       	mov    %eax,0x80924c
     struct BlockElement * element = NULL;
  802508:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80250f:	a1 44 50 80 00       	mov    0x805044,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802517:	e9 87 00 00 00       	jmp    8025a3 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80251c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802520:	75 14                	jne    802536 <initialize_dynamic_allocator+0x83>
  802522:	83 ec 04             	sub    $0x4,%esp
  802525:	68 23 4a 80 00       	push   $0x804a23
  80252a:	6a 79                	push   $0x79
  80252c:	68 41 4a 80 00       	push   $0x804a41
  802531:	e8 ca e1 ff ff       	call   800700 <_panic>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	74 10                	je     80254f <initialize_dynamic_allocator+0x9c>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802547:	8b 52 04             	mov    0x4(%edx),%edx
  80254a:	89 50 04             	mov    %edx,0x4(%eax)
  80254d:	eb 0b                	jmp    80255a <initialize_dynamic_allocator+0xa7>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 04             	mov    0x4(%eax),%eax
  802555:	a3 48 50 80 00       	mov    %eax,0x805048
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	74 0f                	je     802573 <initialize_dynamic_allocator+0xc0>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	8b 12                	mov    (%edx),%edx
  80256f:	89 10                	mov    %edx,(%eax)
  802571:	eb 0a                	jmp    80257d <initialize_dynamic_allocator+0xca>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	a3 44 50 80 00       	mov    %eax,0x805044
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802590:	a1 50 50 80 00       	mov    0x805050,%eax
  802595:	48                   	dec    %eax
  802596:	a3 50 50 80 00       	mov    %eax,0x805050
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80259b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a7:	74 07                	je     8025b0 <initialize_dynamic_allocator+0xfd>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	eb 05                	jmp    8025b5 <initialize_dynamic_allocator+0x102>
  8025b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025ba:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	0f 85 55 ff ff ff    	jne    80251c <initialize_dynamic_allocator+0x69>
  8025c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cb:	0f 85 4b ff ff ff    	jne    80251c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8025e0:	a1 4c 92 80 00       	mov    0x80924c,%eax
  8025e5:	a3 48 92 80 00       	mov    %eax,0x809248
    end_block->info = 1;
  8025ea:	a1 48 92 80 00       	mov    0x809248,%eax
  8025ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	83 c0 08             	add    $0x8,%eax
  8025fb:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	83 c0 04             	add    $0x4,%eax
  802604:	8b 55 0c             	mov    0xc(%ebp),%edx
  802607:	83 ea 08             	sub    $0x8,%edx
  80260a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80260c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	01 d0                	add    %edx,%eax
  802614:	83 e8 08             	sub    $0x8,%eax
  802617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261a:	83 ea 08             	sub    $0x8,%edx
  80261d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802632:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802636:	75 17                	jne    80264f <initialize_dynamic_allocator+0x19c>
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	68 5c 4a 80 00       	push   $0x804a5c
  802640:	68 90 00 00 00       	push   $0x90
  802645:	68 41 4a 80 00       	push   $0x804a41
  80264a:	e8 b1 e0 ff ff       	call   800700 <_panic>
  80264f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	74 0d                	je     802670 <initialize_dynamic_allocator+0x1bd>
  802663:	a1 44 50 80 00       	mov    0x805044,%eax
  802668:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80266b:	89 50 04             	mov    %edx,0x4(%eax)
  80266e:	eb 08                	jmp    802678 <initialize_dynamic_allocator+0x1c5>
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	a3 48 50 80 00       	mov    %eax,0x805048
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	a3 44 50 80 00       	mov    %eax,0x805044
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268a:	a1 50 50 80 00       	mov    0x805050,%eax
  80268f:	40                   	inc    %eax
  802690:	a3 50 50 80 00       	mov    %eax,0x805050
  802695:	eb 07                	jmp    80269e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802697:	90                   	nop
  802698:	eb 04                	jmp    80269e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80269a:	90                   	nop
  80269b:	eb 01                	jmp    80269e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80269d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8026a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a6:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b2:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	83 e8 04             	sub    $0x4,%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	83 e0 fe             	and    $0xfffffffe,%eax
  8026bf:	8d 50 f8             	lea    -0x8(%eax),%edx
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	01 c2                	add    %eax,%edx
  8026c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ca:	89 02                	mov    %eax,(%edx)
}
  8026cc:	90                   	nop
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    

008026cf <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	83 e0 01             	and    $0x1,%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 03                	je     8026e2 <alloc_block_FF+0x13>
  8026df:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026e2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026e6:	77 07                	ja     8026ef <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026e8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	75 73                	jne    80276b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	83 c0 10             	add    $0x10,%eax
  8026fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802701:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270e:	01 d0                	add    %edx,%eax
  802710:	48                   	dec    %eax
  802711:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802717:	ba 00 00 00 00       	mov    $0x0,%edx
  80271c:	f7 75 ec             	divl   -0x14(%ebp)
  80271f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802722:	29 d0                	sub    %edx,%eax
  802724:	c1 e8 0c             	shr    $0xc,%eax
  802727:	83 ec 0c             	sub    $0xc,%esp
  80272a:	50                   	push   %eax
  80272b:	e8 27 f0 ff ff       	call   801757 <sbrk>
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802736:	83 ec 0c             	sub    $0xc,%esp
  802739:	6a 00                	push   $0x0
  80273b:	e8 17 f0 ff ff       	call   801757 <sbrk>
  802740:	83 c4 10             	add    $0x10,%esp
  802743:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802749:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80274c:	83 ec 08             	sub    $0x8,%esp
  80274f:	50                   	push   %eax
  802750:	ff 75 e4             	pushl  -0x1c(%ebp)
  802753:	e8 5b fd ff ff       	call   8024b3 <initialize_dynamic_allocator>
  802758:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	68 7f 4a 80 00       	push   $0x804a7f
  802763:	e8 55 e2 ff ff       	call   8009bd <cprintf>
  802768:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80276b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80276f:	75 0a                	jne    80277b <alloc_block_FF+0xac>
	        return NULL;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	e9 0e 04 00 00       	jmp    802b89 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80277b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802782:	a1 44 50 80 00       	mov    0x805044,%eax
  802787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278a:	e9 f3 02 00 00       	jmp    802a82 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	ff 75 bc             	pushl  -0x44(%ebp)
  80279b:	e8 af fb ff ff       	call   80234f <get_block_size>
  8027a0:	83 c4 10             	add    $0x10,%esp
  8027a3:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	83 c0 08             	add    $0x8,%eax
  8027ac:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027af:	0f 87 c5 02 00 00    	ja     802a7a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	83 c0 18             	add    $0x18,%eax
  8027bb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027be:	0f 87 19 02 00 00    	ja     8029dd <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8027c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ca:	83 e8 08             	sub    $0x8,%eax
  8027cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8d 50 08             	lea    0x8(%eax),%edx
  8027d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027d9:	01 d0                	add    %edx,%eax
  8027db:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	83 c0 08             	add    $0x8,%eax
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	6a 01                	push   $0x1
  8027e9:	50                   	push   %eax
  8027ea:	ff 75 bc             	pushl  -0x44(%ebp)
  8027ed:	e8 ae fe ff ff       	call   8026a0 <set_block_data>
  8027f2:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	75 68                	jne    802867 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027ff:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802803:	75 17                	jne    80281c <alloc_block_FF+0x14d>
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 5c 4a 80 00       	push   $0x804a5c
  80280d:	68 d7 00 00 00       	push   $0xd7
  802812:	68 41 4a 80 00       	push   $0x804a41
  802817:	e8 e4 de ff ff       	call   800700 <_panic>
  80281c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802822:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802825:	89 10                	mov    %edx,(%eax)
  802827:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	74 0d                	je     80283d <alloc_block_FF+0x16e>
  802830:	a1 44 50 80 00       	mov    0x805044,%eax
  802835:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802838:	89 50 04             	mov    %edx,0x4(%eax)
  80283b:	eb 08                	jmp    802845 <alloc_block_FF+0x176>
  80283d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802840:	a3 48 50 80 00       	mov    %eax,0x805048
  802845:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802848:	a3 44 50 80 00       	mov    %eax,0x805044
  80284d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802850:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802857:	a1 50 50 80 00       	mov    0x805050,%eax
  80285c:	40                   	inc    %eax
  80285d:	a3 50 50 80 00       	mov    %eax,0x805050
  802862:	e9 dc 00 00 00       	jmp    802943 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	75 65                	jne    8028d5 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802870:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802874:	75 17                	jne    80288d <alloc_block_FF+0x1be>
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	68 90 4a 80 00       	push   $0x804a90
  80287e:	68 db 00 00 00       	push   $0xdb
  802883:	68 41 4a 80 00       	push   $0x804a41
  802888:	e8 73 de ff ff       	call   800700 <_panic>
  80288d:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802893:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802896:	89 50 04             	mov    %edx,0x4(%eax)
  802899:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	74 0c                	je     8028af <alloc_block_FF+0x1e0>
  8028a3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	eb 08                	jmp    8028b7 <alloc_block_FF+0x1e8>
  8028af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8028b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8028bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cd:	40                   	inc    %eax
  8028ce:	a3 50 50 80 00       	mov    %eax,0x805050
  8028d3:	eb 6e                	jmp    802943 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8028d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d9:	74 06                	je     8028e1 <alloc_block_FF+0x212>
  8028db:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028df:	75 17                	jne    8028f8 <alloc_block_FF+0x229>
  8028e1:	83 ec 04             	sub    $0x4,%esp
  8028e4:	68 b4 4a 80 00       	push   $0x804ab4
  8028e9:	68 df 00 00 00       	push   $0xdf
  8028ee:	68 41 4a 80 00       	push   $0x804a41
  8028f3:	e8 08 de ff ff       	call   800700 <_panic>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 10                	mov    (%eax),%edx
  8028fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802900:	89 10                	mov    %edx,(%eax)
  802902:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	85 c0                	test   %eax,%eax
  802909:	74 0b                	je     802916 <alloc_block_FF+0x247>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802913:	89 50 04             	mov    %edx,0x4(%eax)
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802924:	89 50 04             	mov    %edx,0x4(%eax)
  802927:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	75 08                	jne    802938 <alloc_block_FF+0x269>
  802930:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802933:	a3 48 50 80 00       	mov    %eax,0x805048
  802938:	a1 50 50 80 00       	mov    0x805050,%eax
  80293d:	40                   	inc    %eax
  80293e:	a3 50 50 80 00       	mov    %eax,0x805050
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802947:	75 17                	jne    802960 <alloc_block_FF+0x291>
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	68 23 4a 80 00       	push   $0x804a23
  802951:	68 e1 00 00 00       	push   $0xe1
  802956:	68 41 4a 80 00       	push   $0x804a41
  80295b:	e8 a0 dd ff ff       	call   800700 <_panic>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	85 c0                	test   %eax,%eax
  802967:	74 10                	je     802979 <alloc_block_FF+0x2aa>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802971:	8b 52 04             	mov    0x4(%edx),%edx
  802974:	89 50 04             	mov    %edx,0x4(%eax)
  802977:	eb 0b                	jmp    802984 <alloc_block_FF+0x2b5>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	a3 48 50 80 00       	mov    %eax,0x805048
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0f                	je     80299d <alloc_block_FF+0x2ce>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	8b 12                	mov    (%edx),%edx
  802999:	89 10                	mov    %edx,(%eax)
  80299b:	eb 0a                	jmp    8029a7 <alloc_block_FF+0x2d8>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8029bf:	48                   	dec    %eax
  8029c0:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(new_block_va, remaining_size, 0);
  8029c5:	83 ec 04             	sub    $0x4,%esp
  8029c8:	6a 00                	push   $0x0
  8029ca:	ff 75 b4             	pushl  -0x4c(%ebp)
  8029cd:	ff 75 b0             	pushl  -0x50(%ebp)
  8029d0:	e8 cb fc ff ff       	call   8026a0 <set_block_data>
  8029d5:	83 c4 10             	add    $0x10,%esp
  8029d8:	e9 95 00 00 00       	jmp    802a72 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	6a 01                	push   $0x1
  8029e2:	ff 75 b8             	pushl  -0x48(%ebp)
  8029e5:	ff 75 bc             	pushl  -0x44(%ebp)
  8029e8:	e8 b3 fc ff ff       	call   8026a0 <set_block_data>
  8029ed:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_FF+0x33e>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 23 4a 80 00       	push   $0x804a23
  8029fe:	68 e8 00 00 00       	push   $0xe8
  802a03:	68 41 4a 80 00       	push   $0x804a41
  802a08:	e8 f3 dc ff ff       	call   800700 <_panic>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 10                	je     802a26 <alloc_block_FF+0x357>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1e:	8b 52 04             	mov    0x4(%edx),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 0b                	jmp    802a31 <alloc_block_FF+0x362>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	a3 48 50 80 00       	mov    %eax,0x805048
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0f                	je     802a4a <alloc_block_FF+0x37b>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	8b 12                	mov    (%edx),%edx
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	eb 0a                	jmp    802a54 <alloc_block_FF+0x385>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	a3 44 50 80 00       	mov    %eax,0x805044
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 50 50 80 00       	mov    0x805050,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	a3 50 50 80 00       	mov    %eax,0x805050
	            }
	            return va;
  802a72:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a75:	e9 0f 01 00 00       	jmp    802b89 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a7a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	74 07                	je     802a8f <alloc_block_FF+0x3c0>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	eb 05                	jmp    802a94 <alloc_block_FF+0x3c5>
  802a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a94:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a99:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	0f 85 e9 fc ff ff    	jne    80278f <alloc_block_FF+0xc0>
  802aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaa:	0f 85 df fc ff ff    	jne    80278f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	83 c0 08             	add    $0x8,%eax
  802ab6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ab9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac6:	01 d0                	add    %edx,%eax
  802ac8:	48                   	dec    %eax
  802ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802acc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802acf:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad4:	f7 75 d8             	divl   -0x28(%ebp)
  802ad7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ada:	29 d0                	sub    %edx,%eax
  802adc:	c1 e8 0c             	shr    $0xc,%eax
  802adf:	83 ec 0c             	sub    $0xc,%esp
  802ae2:	50                   	push   %eax
  802ae3:	e8 6f ec ff ff       	call   801757 <sbrk>
  802ae8:	83 c4 10             	add    $0x10,%esp
  802aeb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802aee:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802af2:	75 0a                	jne    802afe <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802af4:	b8 00 00 00 00       	mov    $0x0,%eax
  802af9:	e9 8b 00 00 00       	jmp    802b89 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802afe:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	48                   	dec    %eax
  802b0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b11:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b14:	ba 00 00 00 00       	mov    $0x0,%edx
  802b19:	f7 75 cc             	divl   -0x34(%ebp)
  802b1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b1f:	29 d0                	sub    %edx,%eax
  802b21:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b27:	01 d0                	add    %edx,%eax
  802b29:	a3 48 92 80 00       	mov    %eax,0x809248
			end_block->info = 1;
  802b2e:	a1 48 92 80 00       	mov    0x809248,%eax
  802b33:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b39:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	48                   	dec    %eax
  802b49:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b54:	f7 75 c4             	divl   -0x3c(%ebp)
  802b57:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b5a:	29 d0                	sub    %edx,%eax
  802b5c:	83 ec 04             	sub    $0x4,%esp
  802b5f:	6a 01                	push   $0x1
  802b61:	50                   	push   %eax
  802b62:	ff 75 d0             	pushl  -0x30(%ebp)
  802b65:	e8 36 fb ff ff       	call   8026a0 <set_block_data>
  802b6a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b6d:	83 ec 0c             	sub    $0xc,%esp
  802b70:	ff 75 d0             	pushl  -0x30(%ebp)
  802b73:	e8 f8 09 00 00       	call   803570 <free_block>
  802b78:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b7b:	83 ec 0c             	sub    $0xc,%esp
  802b7e:	ff 75 08             	pushl  0x8(%ebp)
  802b81:	e8 49 fb ff ff       	call   8026cf <alloc_block_FF>
  802b86:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802b89:	c9                   	leave  
  802b8a:	c3                   	ret    

00802b8b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b8b:	55                   	push   %ebp
  802b8c:	89 e5                	mov    %esp,%ebp
  802b8e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	83 e0 01             	and    $0x1,%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	74 03                	je     802b9e <alloc_block_BF+0x13>
  802b9b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b9e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ba2:	77 07                	ja     802bab <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ba4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bab:	a1 24 50 80 00       	mov    0x805024,%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	75 73                	jne    802c27 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	83 c0 10             	add    $0x10,%eax
  802bba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bbd:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802bc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bca:	01 d0                	add    %edx,%eax
  802bcc:	48                   	dec    %eax
  802bcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd8:	f7 75 e0             	divl   -0x20(%ebp)
  802bdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bde:	29 d0                	sub    %edx,%eax
  802be0:	c1 e8 0c             	shr    $0xc,%eax
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	50                   	push   %eax
  802be7:	e8 6b eb ff ff       	call   801757 <sbrk>
  802bec:	83 c4 10             	add    $0x10,%esp
  802bef:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bf2:	83 ec 0c             	sub    $0xc,%esp
  802bf5:	6a 00                	push   $0x0
  802bf7:	e8 5b eb ff ff       	call   801757 <sbrk>
  802bfc:	83 c4 10             	add    $0x10,%esp
  802bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c05:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c08:	83 ec 08             	sub    $0x8,%esp
  802c0b:	50                   	push   %eax
  802c0c:	ff 75 d8             	pushl  -0x28(%ebp)
  802c0f:	e8 9f f8 ff ff       	call   8024b3 <initialize_dynamic_allocator>
  802c14:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c17:	83 ec 0c             	sub    $0xc,%esp
  802c1a:	68 7f 4a 80 00       	push   $0x804a7f
  802c1f:	e8 99 dd ff ff       	call   8009bd <cprintf>
  802c24:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c35:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c43:	a1 44 50 80 00       	mov    0x805044,%eax
  802c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4b:	e9 1d 01 00 00       	jmp    802d6d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c56:	83 ec 0c             	sub    $0xc,%esp
  802c59:	ff 75 a8             	pushl  -0x58(%ebp)
  802c5c:	e8 ee f6 ff ff       	call   80234f <get_block_size>
  802c61:	83 c4 10             	add    $0x10,%esp
  802c64:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	83 c0 08             	add    $0x8,%eax
  802c6d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c70:	0f 87 ef 00 00 00    	ja     802d65 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	83 c0 18             	add    $0x18,%eax
  802c7c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c7f:	77 1d                	ja     802c9e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c87:	0f 86 d8 00 00 00    	jbe    802d65 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c8d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c93:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c99:	e9 c7 00 00 00       	jmp    802d65 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	83 c0 08             	add    $0x8,%eax
  802ca4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ca7:	0f 85 9d 00 00 00    	jne    802d4a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	6a 01                	push   $0x1
  802cb2:	ff 75 a4             	pushl  -0x5c(%ebp)
  802cb5:	ff 75 a8             	pushl  -0x58(%ebp)
  802cb8:	e8 e3 f9 ff ff       	call   8026a0 <set_block_data>
  802cbd:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc4:	75 17                	jne    802cdd <alloc_block_BF+0x152>
  802cc6:	83 ec 04             	sub    $0x4,%esp
  802cc9:	68 23 4a 80 00       	push   $0x804a23
  802cce:	68 2c 01 00 00       	push   $0x12c
  802cd3:	68 41 4a 80 00       	push   $0x804a41
  802cd8:	e8 23 da ff ff       	call   800700 <_panic>
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 10                	je     802cf6 <alloc_block_BF+0x16b>
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	8b 52 04             	mov    0x4(%edx),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 0b                	jmp    802d01 <alloc_block_BF+0x176>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	a3 48 50 80 00       	mov    %eax,0x805048
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0f                	je     802d1a <alloc_block_BF+0x18f>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d14:	8b 12                	mov    (%edx),%edx
  802d16:	89 10                	mov    %edx,(%eax)
  802d18:	eb 0a                	jmp    802d24 <alloc_block_BF+0x199>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	a3 44 50 80 00       	mov    %eax,0x805044
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 50 50 80 00       	mov    0x805050,%eax
  802d3c:	48                   	dec    %eax
  802d3d:	a3 50 50 80 00       	mov    %eax,0x805050
					return va;
  802d42:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d45:	e9 01 04 00 00       	jmp    80314b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d50:	76 13                	jbe    802d65 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d52:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d59:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802d5f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d62:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802d65:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d71:	74 07                	je     802d7a <alloc_block_BF+0x1ef>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	eb 05                	jmp    802d7f <alloc_block_BF+0x1f4>
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d84:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	0f 85 bf fe ff ff    	jne    802c50 <alloc_block_BF+0xc5>
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d95:	0f 85 b5 fe ff ff    	jne    802c50 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9f:	0f 84 26 02 00 00    	je     802fcb <alloc_block_BF+0x440>
  802da5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da9:	0f 85 1c 02 00 00    	jne    802fcb <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	2b 45 08             	sub    0x8(%ebp),%eax
  802db5:	83 e8 08             	sub    $0x8,%eax
  802db8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8d 50 08             	lea    0x8(%eax),%edx
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	83 c0 08             	add    $0x8,%eax
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	6a 01                	push   $0x1
  802dd4:	50                   	push   %eax
  802dd5:	ff 75 f0             	pushl  -0x10(%ebp)
  802dd8:	e8 c3 f8 ff ff       	call   8026a0 <set_block_data>
  802ddd:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	75 68                	jne    802e52 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802dea:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dee:	75 17                	jne    802e07 <alloc_block_BF+0x27c>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 5c 4a 80 00       	push   $0x804a5c
  802df8:	68 45 01 00 00       	push   $0x145
  802dfd:	68 41 4a 80 00       	push   $0x804a41
  802e02:	e8 f9 d8 ff ff       	call   800700 <_panic>
  802e07:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e10:	89 10                	mov    %edx,(%eax)
  802e12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	74 0d                	je     802e28 <alloc_block_BF+0x29d>
  802e1b:	a1 44 50 80 00       	mov    0x805044,%eax
  802e20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e23:	89 50 04             	mov    %edx,0x4(%eax)
  802e26:	eb 08                	jmp    802e30 <alloc_block_BF+0x2a5>
  802e28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e2b:	a3 48 50 80 00       	mov    %eax,0x805048
  802e30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e33:	a3 44 50 80 00       	mov    %eax,0x805044
  802e38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e42:	a1 50 50 80 00       	mov    0x805050,%eax
  802e47:	40                   	inc    %eax
  802e48:	a3 50 50 80 00       	mov    %eax,0x805050
  802e4d:	e9 dc 00 00 00       	jmp    802f2e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	75 65                	jne    802ec0 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e5b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e5f:	75 17                	jne    802e78 <alloc_block_BF+0x2ed>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 90 4a 80 00       	push   $0x804a90
  802e69:	68 4a 01 00 00       	push   $0x14a
  802e6e:	68 41 4a 80 00       	push   $0x804a41
  802e73:	e8 88 d8 ff ff       	call   800700 <_panic>
  802e78:	8b 15 48 50 80 00    	mov    0x805048,%edx
  802e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 0c                	je     802e9a <alloc_block_BF+0x30f>
  802e8e:	a1 48 50 80 00       	mov    0x805048,%eax
  802e93:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 08                	jmp    802ea2 <alloc_block_BF+0x317>
  802e9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9d:	a3 44 50 80 00       	mov    %eax,0x805044
  802ea2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea5:	a3 48 50 80 00       	mov    %eax,0x805048
  802eaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ead:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb3:	a1 50 50 80 00       	mov    0x805050,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 50 50 80 00       	mov    %eax,0x805050
  802ebe:	eb 6e                	jmp    802f2e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ec0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec4:	74 06                	je     802ecc <alloc_block_BF+0x341>
  802ec6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802eca:	75 17                	jne    802ee3 <alloc_block_BF+0x358>
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	68 b4 4a 80 00       	push   $0x804ab4
  802ed4:	68 4f 01 00 00       	push   $0x14f
  802ed9:	68 41 4a 80 00       	push   $0x804a41
  802ede:	e8 1d d8 ff ff       	call   800700 <_panic>
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	8b 10                	mov    (%eax),%edx
  802ee8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0b                	je     802f01 <alloc_block_BF+0x376>
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0f:	89 50 04             	mov    %edx,0x4(%eax)
  802f12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	75 08                	jne    802f23 <alloc_block_BF+0x398>
  802f1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1e:	a3 48 50 80 00       	mov    %eax,0x805048
  802f23:	a1 50 50 80 00       	mov    0x805050,%eax
  802f28:	40                   	inc    %eax
  802f29:	a3 50 50 80 00       	mov    %eax,0x805050
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f32:	75 17                	jne    802f4b <alloc_block_BF+0x3c0>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 23 4a 80 00       	push   $0x804a23
  802f3c:	68 51 01 00 00       	push   $0x151
  802f41:	68 41 4a 80 00       	push   $0x804a41
  802f46:	e8 b5 d7 ff ff       	call   800700 <_panic>
  802f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 10                	je     802f64 <alloc_block_BF+0x3d9>
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5c:	8b 52 04             	mov    0x4(%edx),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	eb 0b                	jmp    802f6f <alloc_block_BF+0x3e4>
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	a3 48 50 80 00       	mov    %eax,0x805048
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0f                	je     802f88 <alloc_block_BF+0x3fd>
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f82:	8b 12                	mov    (%edx),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 0a                	jmp    802f92 <alloc_block_BF+0x407>
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	a3 44 50 80 00       	mov    %eax,0x805044
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 50 50 80 00       	mov    0x805050,%eax
  802faa:	48                   	dec    %eax
  802fab:	a3 50 50 80 00       	mov    %eax,0x805050
			set_block_data(new_block_va, remaining_size, 0);
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	6a 00                	push   $0x0
  802fb5:	ff 75 d0             	pushl  -0x30(%ebp)
  802fb8:	ff 75 cc             	pushl  -0x34(%ebp)
  802fbb:	e8 e0 f6 ff ff       	call   8026a0 <set_block_data>
  802fc0:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc6:	e9 80 01 00 00       	jmp    80314b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802fcb:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802fcf:	0f 85 9d 00 00 00    	jne    803072 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	6a 01                	push   $0x1
  802fda:	ff 75 ec             	pushl  -0x14(%ebp)
  802fdd:	ff 75 f0             	pushl  -0x10(%ebp)
  802fe0:	e8 bb f6 ff ff       	call   8026a0 <set_block_data>
  802fe5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fec:	75 17                	jne    803005 <alloc_block_BF+0x47a>
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	68 23 4a 80 00       	push   $0x804a23
  802ff6:	68 58 01 00 00       	push   $0x158
  802ffb:	68 41 4a 80 00       	push   $0x804a41
  803000:	e8 fb d6 ff ff       	call   800700 <_panic>
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 10                	je     80301e <alloc_block_BF+0x493>
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803016:	8b 52 04             	mov    0x4(%edx),%edx
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	eb 0b                	jmp    803029 <alloc_block_BF+0x49e>
  80301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	a3 48 50 80 00       	mov    %eax,0x805048
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 0f                	je     803042 <alloc_block_BF+0x4b7>
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	8b 40 04             	mov    0x4(%eax),%eax
  803039:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303c:	8b 12                	mov    (%edx),%edx
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	eb 0a                	jmp    80304c <alloc_block_BF+0x4c1>
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	a3 44 50 80 00       	mov    %eax,0x805044
  80304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305f:	a1 50 50 80 00       	mov    0x805050,%eax
  803064:	48                   	dec    %eax
  803065:	a3 50 50 80 00       	mov    %eax,0x805050
		return best_va;
  80306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306d:	e9 d9 00 00 00       	jmp    80314b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	83 c0 08             	add    $0x8,%eax
  803078:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80307b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803082:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803085:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803088:	01 d0                	add    %edx,%eax
  80308a:	48                   	dec    %eax
  80308b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80308e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803091:	ba 00 00 00 00       	mov    $0x0,%edx
  803096:	f7 75 c4             	divl   -0x3c(%ebp)
  803099:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80309c:	29 d0                	sub    %edx,%eax
  80309e:	c1 e8 0c             	shr    $0xc,%eax
  8030a1:	83 ec 0c             	sub    $0xc,%esp
  8030a4:	50                   	push   %eax
  8030a5:	e8 ad e6 ff ff       	call   801757 <sbrk>
  8030aa:	83 c4 10             	add    $0x10,%esp
  8030ad:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8030b0:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8030b4:	75 0a                	jne    8030c0 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8030b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bb:	e9 8b 00 00 00       	jmp    80314b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8030c0:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8030c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030cd:	01 d0                	add    %edx,%eax
  8030cf:	48                   	dec    %eax
  8030d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8030d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8030db:	f7 75 b8             	divl   -0x48(%ebp)
  8030de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030e1:	29 d0                	sub    %edx,%eax
  8030e3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8030e6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030e9:	01 d0                	add    %edx,%eax
  8030eb:	a3 48 92 80 00       	mov    %eax,0x809248
				end_block->info = 1;
  8030f0:	a1 48 92 80 00       	mov    0x809248,%eax
  8030f5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8030fb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803102:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803105:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803108:	01 d0                	add    %edx,%eax
  80310a:	48                   	dec    %eax
  80310b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80310e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803111:	ba 00 00 00 00       	mov    $0x0,%edx
  803116:	f7 75 b0             	divl   -0x50(%ebp)
  803119:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80311c:	29 d0                	sub    %edx,%eax
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	6a 01                	push   $0x1
  803123:	50                   	push   %eax
  803124:	ff 75 bc             	pushl  -0x44(%ebp)
  803127:	e8 74 f5 ff ff       	call   8026a0 <set_block_data>
  80312c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80312f:	83 ec 0c             	sub    $0xc,%esp
  803132:	ff 75 bc             	pushl  -0x44(%ebp)
  803135:	e8 36 04 00 00       	call   803570 <free_block>
  80313a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80313d:	83 ec 0c             	sub    $0xc,%esp
  803140:	ff 75 08             	pushl  0x8(%ebp)
  803143:	e8 43 fa ff ff       	call   802b8b <alloc_block_BF>
  803148:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
  803150:	53                   	push   %ebx
  803151:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80315b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803166:	74 1e                	je     803186 <merging+0x39>
  803168:	ff 75 08             	pushl  0x8(%ebp)
  80316b:	e8 df f1 ff ff       	call   80234f <get_block_size>
  803170:	83 c4 04             	add    $0x4,%esp
  803173:	89 c2                	mov    %eax,%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	01 d0                	add    %edx,%eax
  80317a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80317d:	75 07                	jne    803186 <merging+0x39>
		prev_is_free = 1;
  80317f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803186:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80318a:	74 1e                	je     8031aa <merging+0x5d>
  80318c:	ff 75 10             	pushl  0x10(%ebp)
  80318f:	e8 bb f1 ff ff       	call   80234f <get_block_size>
  803194:	83 c4 04             	add    $0x4,%esp
  803197:	89 c2                	mov    %eax,%edx
  803199:	8b 45 10             	mov    0x10(%ebp),%eax
  80319c:	01 d0                	add    %edx,%eax
  80319e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031a1:	75 07                	jne    8031aa <merging+0x5d>
		next_is_free = 1;
  8031a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8031aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ae:	0f 84 cc 00 00 00    	je     803280 <merging+0x133>
  8031b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b8:	0f 84 c2 00 00 00    	je     803280 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8031be:	ff 75 08             	pushl  0x8(%ebp)
  8031c1:	e8 89 f1 ff ff       	call   80234f <get_block_size>
  8031c6:	83 c4 04             	add    $0x4,%esp
  8031c9:	89 c3                	mov    %eax,%ebx
  8031cb:	ff 75 10             	pushl  0x10(%ebp)
  8031ce:	e8 7c f1 ff ff       	call   80234f <get_block_size>
  8031d3:	83 c4 04             	add    $0x4,%esp
  8031d6:	01 c3                	add    %eax,%ebx
  8031d8:	ff 75 0c             	pushl  0xc(%ebp)
  8031db:	e8 6f f1 ff ff       	call   80234f <get_block_size>
  8031e0:	83 c4 04             	add    $0x4,%esp
  8031e3:	01 d8                	add    %ebx,%eax
  8031e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031e8:	6a 00                	push   $0x0
  8031ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8031ed:	ff 75 08             	pushl  0x8(%ebp)
  8031f0:	e8 ab f4 ff ff       	call   8026a0 <set_block_data>
  8031f5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8031f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031fc:	75 17                	jne    803215 <merging+0xc8>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 23 4a 80 00       	push   $0x804a23
  803206:	68 7d 01 00 00       	push   $0x17d
  80320b:	68 41 4a 80 00       	push   $0x804a41
  803210:	e8 eb d4 ff ff       	call   800700 <_panic>
  803215:	8b 45 0c             	mov    0xc(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 10                	je     80322e <merging+0xe1>
  80321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	8b 55 0c             	mov    0xc(%ebp),%edx
  803226:	8b 52 04             	mov    0x4(%edx),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	eb 0b                	jmp    803239 <merging+0xec>
  80322e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	a3 48 50 80 00       	mov    %eax,0x805048
  803239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 0f                	je     803252 <merging+0x105>
  803243:	8b 45 0c             	mov    0xc(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80324c:	8b 12                	mov    (%edx),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	eb 0a                	jmp    80325c <merging+0x10f>
  803252:	8b 45 0c             	mov    0xc(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	a3 44 50 80 00       	mov    %eax,0x805044
  80325c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803265:	8b 45 0c             	mov    0xc(%ebp),%eax
  803268:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326f:	a1 50 50 80 00       	mov    0x805050,%eax
  803274:	48                   	dec    %eax
  803275:	a3 50 50 80 00       	mov    %eax,0x805050
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80327a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80327b:	e9 ea 02 00 00       	jmp    80356a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803284:	74 3b                	je     8032c1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803286:	83 ec 0c             	sub    $0xc,%esp
  803289:	ff 75 08             	pushl  0x8(%ebp)
  80328c:	e8 be f0 ff ff       	call   80234f <get_block_size>
  803291:	83 c4 10             	add    $0x10,%esp
  803294:	89 c3                	mov    %eax,%ebx
  803296:	83 ec 0c             	sub    $0xc,%esp
  803299:	ff 75 10             	pushl  0x10(%ebp)
  80329c:	e8 ae f0 ff ff       	call   80234f <get_block_size>
  8032a1:	83 c4 10             	add    $0x10,%esp
  8032a4:	01 d8                	add    %ebx,%eax
  8032a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	6a 00                	push   $0x0
  8032ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	e8 e7 f3 ff ff       	call   8026a0 <set_block_data>
  8032b9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032bc:	e9 a9 02 00 00       	jmp    80356a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8032c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c5:	0f 84 2d 01 00 00    	je     8033f8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8032cb:	83 ec 0c             	sub    $0xc,%esp
  8032ce:	ff 75 10             	pushl  0x10(%ebp)
  8032d1:	e8 79 f0 ff ff       	call   80234f <get_block_size>
  8032d6:	83 c4 10             	add    $0x10,%esp
  8032d9:	89 c3                	mov    %eax,%ebx
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	ff 75 0c             	pushl  0xc(%ebp)
  8032e1:	e8 69 f0 ff ff       	call   80234f <get_block_size>
  8032e6:	83 c4 10             	add    $0x10,%esp
  8032e9:	01 d8                	add    %ebx,%eax
  8032eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	6a 00                	push   $0x0
  8032f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f6:	ff 75 10             	pushl  0x10(%ebp)
  8032f9:	e8 a2 f3 ff ff       	call   8026a0 <set_block_data>
  8032fe:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803301:	8b 45 10             	mov    0x10(%ebp),%eax
  803304:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803307:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80330b:	74 06                	je     803313 <merging+0x1c6>
  80330d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803311:	75 17                	jne    80332a <merging+0x1dd>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 e8 4a 80 00       	push   $0x804ae8
  80331b:	68 8d 01 00 00       	push   $0x18d
  803320:	68 41 4a 80 00       	push   $0x804a41
  803325:	e8 d6 d3 ff ff       	call   800700 <_panic>
  80332a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332d:	8b 50 04             	mov    0x4(%eax),%edx
  803330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80333c:	89 10                	mov    %edx,(%eax)
  80333e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0d                	je     803355 <merging+0x208>
  803348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803351:	89 10                	mov    %edx,(%eax)
  803353:	eb 08                	jmp    80335d <merging+0x210>
  803355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803358:	a3 44 50 80 00       	mov    %eax,0x805044
  80335d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803360:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	a1 50 50 80 00       	mov    0x805050,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 50 50 80 00       	mov    %eax,0x805050
		LIST_REMOVE(&freeBlocksList, next_block);
  803371:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803375:	75 17                	jne    80338e <merging+0x241>
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	68 23 4a 80 00       	push   $0x804a23
  80337f:	68 8e 01 00 00       	push   $0x18e
  803384:	68 41 4a 80 00       	push   $0x804a41
  803389:	e8 72 d3 ff ff       	call   800700 <_panic>
  80338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	74 10                	je     8033a7 <merging+0x25a>
  803397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339f:	8b 52 04             	mov    0x4(%edx),%edx
  8033a2:	89 50 04             	mov    %edx,0x4(%eax)
  8033a5:	eb 0b                	jmp    8033b2 <merging+0x265>
  8033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033aa:	8b 40 04             	mov    0x4(%eax),%eax
  8033ad:	a3 48 50 80 00       	mov    %eax,0x805048
  8033b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b5:	8b 40 04             	mov    0x4(%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0f                	je     8033cb <merging+0x27e>
  8033bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c5:	8b 12                	mov    (%edx),%edx
  8033c7:	89 10                	mov    %edx,(%eax)
  8033c9:	eb 0a                	jmp    8033d5 <merging+0x288>
  8033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8033d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8033ed:	48                   	dec    %eax
  8033ee:	a3 50 50 80 00       	mov    %eax,0x805050
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033f3:	e9 72 01 00 00       	jmp    80356a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8033f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8033fb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8033fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803402:	74 79                	je     80347d <merging+0x330>
  803404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803408:	74 73                	je     80347d <merging+0x330>
  80340a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340e:	74 06                	je     803416 <merging+0x2c9>
  803410:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803414:	75 17                	jne    80342d <merging+0x2e0>
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 b4 4a 80 00       	push   $0x804ab4
  80341e:	68 94 01 00 00       	push   $0x194
  803423:	68 41 4a 80 00       	push   $0x804a41
  803428:	e8 d3 d2 ff ff       	call   800700 <_panic>
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	8b 10                	mov    (%eax),%edx
  803432:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803435:	89 10                	mov    %edx,(%eax)
  803437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	85 c0                	test   %eax,%eax
  80343e:	74 0b                	je     80344b <merging+0x2fe>
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803448:	89 50 04             	mov    %edx,0x4(%eax)
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803451:	89 10                	mov    %edx,(%eax)
  803453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803456:	8b 55 08             	mov    0x8(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	85 c0                	test   %eax,%eax
  803463:	75 08                	jne    80346d <merging+0x320>
  803465:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803468:	a3 48 50 80 00       	mov    %eax,0x805048
  80346d:	a1 50 50 80 00       	mov    0x805050,%eax
  803472:	40                   	inc    %eax
  803473:	a3 50 50 80 00       	mov    %eax,0x805050
  803478:	e9 ce 00 00 00       	jmp    80354b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80347d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803481:	74 65                	je     8034e8 <merging+0x39b>
  803483:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803487:	75 17                	jne    8034a0 <merging+0x353>
  803489:	83 ec 04             	sub    $0x4,%esp
  80348c:	68 90 4a 80 00       	push   $0x804a90
  803491:	68 95 01 00 00       	push   $0x195
  803496:	68 41 4a 80 00       	push   $0x804a41
  80349b:	e8 60 d2 ff ff       	call   800700 <_panic>
  8034a0:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8034a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a9:	89 50 04             	mov    %edx,0x4(%eax)
  8034ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	85 c0                	test   %eax,%eax
  8034b4:	74 0c                	je     8034c2 <merging+0x375>
  8034b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8034bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	eb 08                	jmp    8034ca <merging+0x37d>
  8034c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8034ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8034d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034db:	a1 50 50 80 00       	mov    0x805050,%eax
  8034e0:	40                   	inc    %eax
  8034e1:	a3 50 50 80 00       	mov    %eax,0x805050
  8034e6:	eb 63                	jmp    80354b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8034e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034ec:	75 17                	jne    803505 <merging+0x3b8>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 5c 4a 80 00       	push   $0x804a5c
  8034f6:	68 98 01 00 00       	push   $0x198
  8034fb:	68 41 4a 80 00       	push   $0x804a41
  803500:	e8 fb d1 ff ff       	call   800700 <_panic>
  803505:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80350b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350e:	89 10                	mov    %edx,(%eax)
  803510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0d                	je     803526 <merging+0x3d9>
  803519:	a1 44 50 80 00       	mov    0x805044,%eax
  80351e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	eb 08                	jmp    80352e <merging+0x3e1>
  803526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803529:	a3 48 50 80 00       	mov    %eax,0x805048
  80352e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803531:	a3 44 50 80 00       	mov    %eax,0x805044
  803536:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803540:	a1 50 50 80 00       	mov    0x805050,%eax
  803545:	40                   	inc    %eax
  803546:	a3 50 50 80 00       	mov    %eax,0x805050
		}
		set_block_data(va, get_block_size(va), 0);
  80354b:	83 ec 0c             	sub    $0xc,%esp
  80354e:	ff 75 10             	pushl  0x10(%ebp)
  803551:	e8 f9 ed ff ff       	call   80234f <get_block_size>
  803556:	83 c4 10             	add    $0x10,%esp
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	6a 00                	push   $0x0
  80355e:	50                   	push   %eax
  80355f:	ff 75 10             	pushl  0x10(%ebp)
  803562:	e8 39 f1 ff ff       	call   8026a0 <set_block_data>
  803567:	83 c4 10             	add    $0x10,%esp
	}
}
  80356a:	90                   	nop
  80356b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80356e:	c9                   	leave  
  80356f:	c3                   	ret    

00803570 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
  803573:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803576:	a1 44 50 80 00       	mov    0x805044,%eax
  80357b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80357e:	a1 48 50 80 00       	mov    0x805048,%eax
  803583:	3b 45 08             	cmp    0x8(%ebp),%eax
  803586:	73 1b                	jae    8035a3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803588:	a1 48 50 80 00       	mov    0x805048,%eax
  80358d:	83 ec 04             	sub    $0x4,%esp
  803590:	ff 75 08             	pushl  0x8(%ebp)
  803593:	6a 00                	push   $0x0
  803595:	50                   	push   %eax
  803596:	e8 b2 fb ff ff       	call   80314d <merging>
  80359b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80359e:	e9 8b 00 00 00       	jmp    80362e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8035a3:	a1 44 50 80 00       	mov    0x805044,%eax
  8035a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ab:	76 18                	jbe    8035c5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8035ad:	a1 44 50 80 00       	mov    0x805044,%eax
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	ff 75 08             	pushl  0x8(%ebp)
  8035b8:	50                   	push   %eax
  8035b9:	6a 00                	push   $0x0
  8035bb:	e8 8d fb ff ff       	call   80314d <merging>
  8035c0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035c3:	eb 69                	jmp    80362e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8035ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035cd:	eb 39                	jmp    803608 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035d5:	73 29                	jae    803600 <free_block+0x90>
  8035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035df:	76 1f                	jbe    803600 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8035e9:	83 ec 04             	sub    $0x4,%esp
  8035ec:	ff 75 08             	pushl  0x8(%ebp)
  8035ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8035f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8035f5:	e8 53 fb ff ff       	call   80314d <merging>
  8035fa:	83 c4 10             	add    $0x10,%esp
			break;
  8035fd:	90                   	nop
		}
	}
}
  8035fe:	eb 2e                	jmp    80362e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803600:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360c:	74 07                	je     803615 <free_block+0xa5>
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	eb 05                	jmp    80361a <free_block+0xaa>
  803615:	b8 00 00 00 00       	mov    $0x0,%eax
  80361a:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80361f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803624:	85 c0                	test   %eax,%eax
  803626:	75 a7                	jne    8035cf <free_block+0x5f>
  803628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362c:	75 a1                	jne    8035cf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80362e:	90                   	nop
  80362f:	c9                   	leave  
  803630:	c3                   	ret    

00803631 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803631:	55                   	push   %ebp
  803632:	89 e5                	mov    %esp,%ebp
  803634:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803637:	ff 75 08             	pushl  0x8(%ebp)
  80363a:	e8 10 ed ff ff       	call   80234f <get_block_size>
  80363f:	83 c4 04             	add    $0x4,%esp
  803642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803645:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80364c:	eb 17                	jmp    803665 <copy_data+0x34>
  80364e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803651:	8b 45 0c             	mov    0xc(%ebp),%eax
  803654:	01 c2                	add    %eax,%edx
  803656:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	01 c8                	add    %ecx,%eax
  80365e:	8a 00                	mov    (%eax),%al
  803660:	88 02                	mov    %al,(%edx)
  803662:	ff 45 fc             	incl   -0x4(%ebp)
  803665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80366b:	72 e1                	jb     80364e <copy_data+0x1d>
}
  80366d:	90                   	nop
  80366e:	c9                   	leave  
  80366f:	c3                   	ret    

00803670 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803670:	55                   	push   %ebp
  803671:	89 e5                	mov    %esp,%ebp
  803673:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80367a:	75 23                	jne    80369f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80367c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803680:	74 13                	je     803695 <realloc_block_FF+0x25>
  803682:	83 ec 0c             	sub    $0xc,%esp
  803685:	ff 75 0c             	pushl  0xc(%ebp)
  803688:	e8 42 f0 ff ff       	call   8026cf <alloc_block_FF>
  80368d:	83 c4 10             	add    $0x10,%esp
  803690:	e9 e4 06 00 00       	jmp    803d79 <realloc_block_FF+0x709>
		return NULL;
  803695:	b8 00 00 00 00       	mov    $0x0,%eax
  80369a:	e9 da 06 00 00       	jmp    803d79 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80369f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a3:	75 18                	jne    8036bd <realloc_block_FF+0x4d>
	{
		free_block(va);
  8036a5:	83 ec 0c             	sub    $0xc,%esp
  8036a8:	ff 75 08             	pushl  0x8(%ebp)
  8036ab:	e8 c0 fe ff ff       	call   803570 <free_block>
  8036b0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8036b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b8:	e9 bc 06 00 00       	jmp    803d79 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8036bd:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8036c1:	77 07                	ja     8036ca <realloc_block_FF+0x5a>
  8036c3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8036ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cd:	83 e0 01             	and    $0x1,%eax
  8036d0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8036d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d6:	83 c0 08             	add    $0x8,%eax
  8036d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8036dc:	83 ec 0c             	sub    $0xc,%esp
  8036df:	ff 75 08             	pushl  0x8(%ebp)
  8036e2:	e8 68 ec ff ff       	call   80234f <get_block_size>
  8036e7:	83 c4 10             	add    $0x10,%esp
  8036ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f0:	83 e8 08             	sub    $0x8,%eax
  8036f3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	83 e8 04             	sub    $0x4,%eax
  8036fc:	8b 00                	mov    (%eax),%eax
  8036fe:	83 e0 fe             	and    $0xfffffffe,%eax
  803701:	89 c2                	mov    %eax,%edx
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	01 d0                	add    %edx,%eax
  803708:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80370b:	83 ec 0c             	sub    $0xc,%esp
  80370e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803711:	e8 39 ec ff ff       	call   80234f <get_block_size>
  803716:	83 c4 10             	add    $0x10,%esp
  803719:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80371c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371f:	83 e8 08             	sub    $0x8,%eax
  803722:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80372b:	75 08                	jne    803735 <realloc_block_FF+0xc5>
	{
		 return va;
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	e9 44 06 00 00       	jmp    803d79 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803735:	8b 45 0c             	mov    0xc(%ebp),%eax
  803738:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373b:	0f 83 d5 03 00 00    	jae    803b16 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803744:	2b 45 0c             	sub    0xc(%ebp),%eax
  803747:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80374a:	83 ec 0c             	sub    $0xc,%esp
  80374d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803750:	e8 13 ec ff ff       	call   802368 <is_free_block>
  803755:	83 c4 10             	add    $0x10,%esp
  803758:	84 c0                	test   %al,%al
  80375a:	0f 84 3b 01 00 00    	je     80389b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803760:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803763:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803766:	01 d0                	add    %edx,%eax
  803768:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	6a 01                	push   $0x1
  803770:	ff 75 f0             	pushl  -0x10(%ebp)
  803773:	ff 75 08             	pushl  0x8(%ebp)
  803776:	e8 25 ef ff ff       	call   8026a0 <set_block_data>
  80377b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80377e:	8b 45 08             	mov    0x8(%ebp),%eax
  803781:	83 e8 04             	sub    $0x4,%eax
  803784:	8b 00                	mov    (%eax),%eax
  803786:	83 e0 fe             	and    $0xfffffffe,%eax
  803789:	89 c2                	mov    %eax,%edx
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	01 d0                	add    %edx,%eax
  803790:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803793:	83 ec 04             	sub    $0x4,%esp
  803796:	6a 00                	push   $0x0
  803798:	ff 75 cc             	pushl  -0x34(%ebp)
  80379b:	ff 75 c8             	pushl  -0x38(%ebp)
  80379e:	e8 fd ee ff ff       	call   8026a0 <set_block_data>
  8037a3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037aa:	74 06                	je     8037b2 <realloc_block_FF+0x142>
  8037ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037b0:	75 17                	jne    8037c9 <realloc_block_FF+0x159>
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	68 b4 4a 80 00       	push   $0x804ab4
  8037ba:	68 f6 01 00 00       	push   $0x1f6
  8037bf:	68 41 4a 80 00       	push   $0x804a41
  8037c4:	e8 37 cf ff ff       	call   800700 <_panic>
  8037c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cc:	8b 10                	mov    (%eax),%edx
  8037ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037d1:	89 10                	mov    %edx,(%eax)
  8037d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	85 c0                	test   %eax,%eax
  8037da:	74 0b                	je     8037e7 <realloc_block_FF+0x177>
  8037dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037e4:	89 50 04             	mov    %edx,0x4(%eax)
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	75 08                	jne    803809 <realloc_block_FF+0x199>
  803801:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803804:	a3 48 50 80 00       	mov    %eax,0x805048
  803809:	a1 50 50 80 00       	mov    0x805050,%eax
  80380e:	40                   	inc    %eax
  80380f:	a3 50 50 80 00       	mov    %eax,0x805050
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803818:	75 17                	jne    803831 <realloc_block_FF+0x1c1>
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	68 23 4a 80 00       	push   $0x804a23
  803822:	68 f7 01 00 00       	push   $0x1f7
  803827:	68 41 4a 80 00       	push   $0x804a41
  80382c:	e8 cf ce ff ff       	call   800700 <_panic>
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	85 c0                	test   %eax,%eax
  803838:	74 10                	je     80384a <realloc_block_FF+0x1da>
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	8b 00                	mov    (%eax),%eax
  80383f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803842:	8b 52 04             	mov    0x4(%edx),%edx
  803845:	89 50 04             	mov    %edx,0x4(%eax)
  803848:	eb 0b                	jmp    803855 <realloc_block_FF+0x1e5>
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	8b 40 04             	mov    0x4(%eax),%eax
  803850:	a3 48 50 80 00       	mov    %eax,0x805048
  803855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803858:	8b 40 04             	mov    0x4(%eax),%eax
  80385b:	85 c0                	test   %eax,%eax
  80385d:	74 0f                	je     80386e <realloc_block_FF+0x1fe>
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	8b 40 04             	mov    0x4(%eax),%eax
  803865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803868:	8b 12                	mov    (%edx),%edx
  80386a:	89 10                	mov    %edx,(%eax)
  80386c:	eb 0a                	jmp    803878 <realloc_block_FF+0x208>
  80386e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	a3 44 50 80 00       	mov    %eax,0x805044
  803878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388b:	a1 50 50 80 00       	mov    0x805050,%eax
  803890:	48                   	dec    %eax
  803891:	a3 50 50 80 00       	mov    %eax,0x805050
  803896:	e9 73 02 00 00       	jmp    803b0e <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80389b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80389f:	0f 86 69 02 00 00    	jbe    803b0e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	6a 01                	push   $0x1
  8038aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8038ad:	ff 75 08             	pushl  0x8(%ebp)
  8038b0:	e8 eb ed ff ff       	call   8026a0 <set_block_data>
  8038b5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bb:	83 e8 04             	sub    $0x4,%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8038c3:	89 c2                	mov    %eax,%edx
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	01 d0                	add    %edx,%eax
  8038ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8038cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8038d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8038d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038d9:	75 68                	jne    803943 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038df:	75 17                	jne    8038f8 <realloc_block_FF+0x288>
  8038e1:	83 ec 04             	sub    $0x4,%esp
  8038e4:	68 5c 4a 80 00       	push   $0x804a5c
  8038e9:	68 06 02 00 00       	push   $0x206
  8038ee:	68 41 4a 80 00       	push   $0x804a41
  8038f3:	e8 08 ce ff ff       	call   800700 <_panic>
  8038f8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8038fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803901:	89 10                	mov    %edx,(%eax)
  803903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	85 c0                	test   %eax,%eax
  80390a:	74 0d                	je     803919 <realloc_block_FF+0x2a9>
  80390c:	a1 44 50 80 00       	mov    0x805044,%eax
  803911:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803914:	89 50 04             	mov    %edx,0x4(%eax)
  803917:	eb 08                	jmp    803921 <realloc_block_FF+0x2b1>
  803919:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80391c:	a3 48 50 80 00       	mov    %eax,0x805048
  803921:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803924:	a3 44 50 80 00       	mov    %eax,0x805044
  803929:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803933:	a1 50 50 80 00       	mov    0x805050,%eax
  803938:	40                   	inc    %eax
  803939:	a3 50 50 80 00       	mov    %eax,0x805050
  80393e:	e9 b0 01 00 00       	jmp    803af3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803943:	a1 44 50 80 00       	mov    0x805044,%eax
  803948:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80394b:	76 68                	jbe    8039b5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80394d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803951:	75 17                	jne    80396a <realloc_block_FF+0x2fa>
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	68 5c 4a 80 00       	push   $0x804a5c
  80395b:	68 0b 02 00 00       	push   $0x20b
  803960:	68 41 4a 80 00       	push   $0x804a41
  803965:	e8 96 cd ff ff       	call   800700 <_panic>
  80396a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803970:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803973:	89 10                	mov    %edx,(%eax)
  803975:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	74 0d                	je     80398b <realloc_block_FF+0x31b>
  80397e:	a1 44 50 80 00       	mov    0x805044,%eax
  803983:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803986:	89 50 04             	mov    %edx,0x4(%eax)
  803989:	eb 08                	jmp    803993 <realloc_block_FF+0x323>
  80398b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398e:	a3 48 50 80 00       	mov    %eax,0x805048
  803993:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803996:	a3 44 50 80 00       	mov    %eax,0x805044
  80399b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8039aa:	40                   	inc    %eax
  8039ab:	a3 50 50 80 00       	mov    %eax,0x805050
  8039b0:	e9 3e 01 00 00       	jmp    803af3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8039b5:	a1 44 50 80 00       	mov    0x805044,%eax
  8039ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039bd:	73 68                	jae    803a27 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039c3:	75 17                	jne    8039dc <realloc_block_FF+0x36c>
  8039c5:	83 ec 04             	sub    $0x4,%esp
  8039c8:	68 90 4a 80 00       	push   $0x804a90
  8039cd:	68 10 02 00 00       	push   $0x210
  8039d2:	68 41 4a 80 00       	push   $0x804a41
  8039d7:	e8 24 cd ff ff       	call   800700 <_panic>
  8039dc:	8b 15 48 50 80 00    	mov    0x805048,%edx
  8039e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e5:	89 50 04             	mov    %edx,0x4(%eax)
  8039e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039eb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	74 0c                	je     8039fe <realloc_block_FF+0x38e>
  8039f2:	a1 48 50 80 00       	mov    0x805048,%eax
  8039f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039fa:	89 10                	mov    %edx,(%eax)
  8039fc:	eb 08                	jmp    803a06 <realloc_block_FF+0x396>
  8039fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a01:	a3 44 50 80 00       	mov    %eax,0x805044
  803a06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a09:	a3 48 50 80 00       	mov    %eax,0x805048
  803a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a17:	a1 50 50 80 00       	mov    0x805050,%eax
  803a1c:	40                   	inc    %eax
  803a1d:	a3 50 50 80 00       	mov    %eax,0x805050
  803a22:	e9 cc 00 00 00       	jmp    803af3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a2e:	a1 44 50 80 00       	mov    0x805044,%eax
  803a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a36:	e9 8a 00 00 00       	jmp    803ac5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a41:	73 7a                	jae    803abd <realloc_block_FF+0x44d>
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a4b:	73 70                	jae    803abd <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a51:	74 06                	je     803a59 <realloc_block_FF+0x3e9>
  803a53:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a57:	75 17                	jne    803a70 <realloc_block_FF+0x400>
  803a59:	83 ec 04             	sub    $0x4,%esp
  803a5c:	68 b4 4a 80 00       	push   $0x804ab4
  803a61:	68 1a 02 00 00       	push   $0x21a
  803a66:	68 41 4a 80 00       	push   $0x804a41
  803a6b:	e8 90 cc ff ff       	call   800700 <_panic>
  803a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a73:	8b 10                	mov    (%eax),%edx
  803a75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a78:	89 10                	mov    %edx,(%eax)
  803a7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7d:	8b 00                	mov    (%eax),%eax
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	74 0b                	je     803a8e <realloc_block_FF+0x41e>
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a8b:	89 50 04             	mov    %edx,0x4(%eax)
  803a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a94:	89 10                	mov    %edx,(%eax)
  803a96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9c:	89 50 04             	mov    %edx,0x4(%eax)
  803a9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	85 c0                	test   %eax,%eax
  803aa6:	75 08                	jne    803ab0 <realloc_block_FF+0x440>
  803aa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aab:	a3 48 50 80 00       	mov    %eax,0x805048
  803ab0:	a1 50 50 80 00       	mov    0x805050,%eax
  803ab5:	40                   	inc    %eax
  803ab6:	a3 50 50 80 00       	mov    %eax,0x805050
							break;
  803abb:	eb 36                	jmp    803af3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803abd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac9:	74 07                	je     803ad2 <realloc_block_FF+0x462>
  803acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	eb 05                	jmp    803ad7 <realloc_block_FF+0x467>
  803ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad7:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803adc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	0f 85 52 ff ff ff    	jne    803a3b <realloc_block_FF+0x3cb>
  803ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aed:	0f 85 48 ff ff ff    	jne    803a3b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	6a 00                	push   $0x0
  803af8:	ff 75 d8             	pushl  -0x28(%ebp)
  803afb:	ff 75 d4             	pushl  -0x2c(%ebp)
  803afe:	e8 9d eb ff ff       	call   8026a0 <set_block_data>
  803b03:	83 c4 10             	add    $0x10,%esp
				return va;
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	e9 6b 02 00 00       	jmp    803d79 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b11:	e9 63 02 00 00       	jmp    803d79 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b19:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b1c:	0f 86 4d 02 00 00    	jbe    803d6f <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803b22:	83 ec 0c             	sub    $0xc,%esp
  803b25:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b28:	e8 3b e8 ff ff       	call   802368 <is_free_block>
  803b2d:	83 c4 10             	add    $0x10,%esp
  803b30:	84 c0                	test   %al,%al
  803b32:	0f 84 37 02 00 00    	je     803d6f <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b3e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b44:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b47:	76 38                	jbe    803b81 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b49:	83 ec 0c             	sub    $0xc,%esp
  803b4c:	ff 75 0c             	pushl  0xc(%ebp)
  803b4f:	e8 7b eb ff ff       	call   8026cf <alloc_block_FF>
  803b54:	83 c4 10             	add    $0x10,%esp
  803b57:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b5a:	83 ec 08             	sub    $0x8,%esp
  803b5d:	ff 75 c0             	pushl  -0x40(%ebp)
  803b60:	ff 75 08             	pushl  0x8(%ebp)
  803b63:	e8 c9 fa ff ff       	call   803631 <copy_data>
  803b68:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803b6b:	83 ec 0c             	sub    $0xc,%esp
  803b6e:	ff 75 08             	pushl  0x8(%ebp)
  803b71:	e8 fa f9 ff ff       	call   803570 <free_block>
  803b76:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b7c:	e9 f8 01 00 00       	jmp    803d79 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b84:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803b87:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803b8a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803b8e:	0f 87 a0 00 00 00    	ja     803c34 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b98:	75 17                	jne    803bb1 <realloc_block_FF+0x541>
  803b9a:	83 ec 04             	sub    $0x4,%esp
  803b9d:	68 23 4a 80 00       	push   $0x804a23
  803ba2:	68 38 02 00 00       	push   $0x238
  803ba7:	68 41 4a 80 00       	push   $0x804a41
  803bac:	e8 4f cb ff ff       	call   800700 <_panic>
  803bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb4:	8b 00                	mov    (%eax),%eax
  803bb6:	85 c0                	test   %eax,%eax
  803bb8:	74 10                	je     803bca <realloc_block_FF+0x55a>
  803bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbd:	8b 00                	mov    (%eax),%eax
  803bbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc2:	8b 52 04             	mov    0x4(%edx),%edx
  803bc5:	89 50 04             	mov    %edx,0x4(%eax)
  803bc8:	eb 0b                	jmp    803bd5 <realloc_block_FF+0x565>
  803bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcd:	8b 40 04             	mov    0x4(%eax),%eax
  803bd0:	a3 48 50 80 00       	mov    %eax,0x805048
  803bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd8:	8b 40 04             	mov    0x4(%eax),%eax
  803bdb:	85 c0                	test   %eax,%eax
  803bdd:	74 0f                	je     803bee <realloc_block_FF+0x57e>
  803bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be2:	8b 40 04             	mov    0x4(%eax),%eax
  803be5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be8:	8b 12                	mov    (%edx),%edx
  803bea:	89 10                	mov    %edx,(%eax)
  803bec:	eb 0a                	jmp    803bf8 <realloc_block_FF+0x588>
  803bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf1:	8b 00                	mov    (%eax),%eax
  803bf3:	a3 44 50 80 00       	mov    %eax,0x805044
  803bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c0b:	a1 50 50 80 00       	mov    0x805050,%eax
  803c10:	48                   	dec    %eax
  803c11:	a3 50 50 80 00       	mov    %eax,0x805050

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1c:	01 d0                	add    %edx,%eax
  803c1e:	83 ec 04             	sub    $0x4,%esp
  803c21:	6a 01                	push   $0x1
  803c23:	50                   	push   %eax
  803c24:	ff 75 08             	pushl  0x8(%ebp)
  803c27:	e8 74 ea ff ff       	call   8026a0 <set_block_data>
  803c2c:	83 c4 10             	add    $0x10,%esp
  803c2f:	e9 36 01 00 00       	jmp    803d6a <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c3a:	01 d0                	add    %edx,%eax
  803c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c3f:	83 ec 04             	sub    $0x4,%esp
  803c42:	6a 01                	push   $0x1
  803c44:	ff 75 f0             	pushl  -0x10(%ebp)
  803c47:	ff 75 08             	pushl  0x8(%ebp)
  803c4a:	e8 51 ea ff ff       	call   8026a0 <set_block_data>
  803c4f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c52:	8b 45 08             	mov    0x8(%ebp),%eax
  803c55:	83 e8 04             	sub    $0x4,%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	83 e0 fe             	and    $0xfffffffe,%eax
  803c5d:	89 c2                	mov    %eax,%edx
  803c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c62:	01 d0                	add    %edx,%eax
  803c64:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c6b:	74 06                	je     803c73 <realloc_block_FF+0x603>
  803c6d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c71:	75 17                	jne    803c8a <realloc_block_FF+0x61a>
  803c73:	83 ec 04             	sub    $0x4,%esp
  803c76:	68 b4 4a 80 00       	push   $0x804ab4
  803c7b:	68 44 02 00 00       	push   $0x244
  803c80:	68 41 4a 80 00       	push   $0x804a41
  803c85:	e8 76 ca ff ff       	call   800700 <_panic>
  803c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8d:	8b 10                	mov    (%eax),%edx
  803c8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c92:	89 10                	mov    %edx,(%eax)
  803c94:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	85 c0                	test   %eax,%eax
  803c9b:	74 0b                	je     803ca8 <realloc_block_FF+0x638>
  803c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca0:	8b 00                	mov    (%eax),%eax
  803ca2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ca5:	89 50 04             	mov    %edx,0x4(%eax)
  803ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cab:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cae:	89 10                	mov    %edx,(%eax)
  803cb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cb6:	89 50 04             	mov    %edx,0x4(%eax)
  803cb9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cbc:	8b 00                	mov    (%eax),%eax
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	75 08                	jne    803cca <realloc_block_FF+0x65a>
  803cc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cc5:	a3 48 50 80 00       	mov    %eax,0x805048
  803cca:	a1 50 50 80 00       	mov    0x805050,%eax
  803ccf:	40                   	inc    %eax
  803cd0:	a3 50 50 80 00       	mov    %eax,0x805050
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd9:	75 17                	jne    803cf2 <realloc_block_FF+0x682>
  803cdb:	83 ec 04             	sub    $0x4,%esp
  803cde:	68 23 4a 80 00       	push   $0x804a23
  803ce3:	68 45 02 00 00       	push   $0x245
  803ce8:	68 41 4a 80 00       	push   $0x804a41
  803ced:	e8 0e ca ff ff       	call   800700 <_panic>
  803cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	85 c0                	test   %eax,%eax
  803cf9:	74 10                	je     803d0b <realloc_block_FF+0x69b>
  803cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfe:	8b 00                	mov    (%eax),%eax
  803d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d03:	8b 52 04             	mov    0x4(%edx),%edx
  803d06:	89 50 04             	mov    %edx,0x4(%eax)
  803d09:	eb 0b                	jmp    803d16 <realloc_block_FF+0x6a6>
  803d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0e:	8b 40 04             	mov    0x4(%eax),%eax
  803d11:	a3 48 50 80 00       	mov    %eax,0x805048
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	8b 40 04             	mov    0x4(%eax),%eax
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	74 0f                	je     803d2f <realloc_block_FF+0x6bf>
  803d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d23:	8b 40 04             	mov    0x4(%eax),%eax
  803d26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d29:	8b 12                	mov    (%edx),%edx
  803d2b:	89 10                	mov    %edx,(%eax)
  803d2d:	eb 0a                	jmp    803d39 <realloc_block_FF+0x6c9>
  803d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	a3 44 50 80 00       	mov    %eax,0x805044
  803d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d4c:	a1 50 50 80 00       	mov    0x805050,%eax
  803d51:	48                   	dec    %eax
  803d52:	a3 50 50 80 00       	mov    %eax,0x805050
				set_block_data(next_new_va, remaining_size, 0);
  803d57:	83 ec 04             	sub    $0x4,%esp
  803d5a:	6a 00                	push   $0x0
  803d5c:	ff 75 bc             	pushl  -0x44(%ebp)
  803d5f:	ff 75 b8             	pushl  -0x48(%ebp)
  803d62:	e8 39 e9 ff ff       	call   8026a0 <set_block_data>
  803d67:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6d:	eb 0a                	jmp    803d79 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d6f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d79:	c9                   	leave  
  803d7a:	c3                   	ret    

00803d7b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d7b:	55                   	push   %ebp
  803d7c:	89 e5                	mov    %esp,%ebp
  803d7e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803d81:	83 ec 04             	sub    $0x4,%esp
  803d84:	68 20 4b 80 00       	push   $0x804b20
  803d89:	68 58 02 00 00       	push   $0x258
  803d8e:	68 41 4a 80 00       	push   $0x804a41
  803d93:	e8 68 c9 ff ff       	call   800700 <_panic>

00803d98 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803d98:	55                   	push   %ebp
  803d99:	89 e5                	mov    %esp,%ebp
  803d9b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803d9e:	83 ec 04             	sub    $0x4,%esp
  803da1:	68 48 4b 80 00       	push   $0x804b48
  803da6:	68 61 02 00 00       	push   $0x261
  803dab:	68 41 4a 80 00       	push   $0x804a41
  803db0:	e8 4b c9 ff ff       	call   800700 <_panic>
  803db5:	66 90                	xchg   %ax,%ax
  803db7:	90                   	nop

00803db8 <__udivdi3>:
  803db8:	55                   	push   %ebp
  803db9:	57                   	push   %edi
  803dba:	56                   	push   %esi
  803dbb:	53                   	push   %ebx
  803dbc:	83 ec 1c             	sub    $0x1c,%esp
  803dbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803dc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dcb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dcf:	89 ca                	mov    %ecx,%edx
  803dd1:	89 f8                	mov    %edi,%eax
  803dd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803dd7:	85 f6                	test   %esi,%esi
  803dd9:	75 2d                	jne    803e08 <__udivdi3+0x50>
  803ddb:	39 cf                	cmp    %ecx,%edi
  803ddd:	77 65                	ja     803e44 <__udivdi3+0x8c>
  803ddf:	89 fd                	mov    %edi,%ebp
  803de1:	85 ff                	test   %edi,%edi
  803de3:	75 0b                	jne    803df0 <__udivdi3+0x38>
  803de5:	b8 01 00 00 00       	mov    $0x1,%eax
  803dea:	31 d2                	xor    %edx,%edx
  803dec:	f7 f7                	div    %edi
  803dee:	89 c5                	mov    %eax,%ebp
  803df0:	31 d2                	xor    %edx,%edx
  803df2:	89 c8                	mov    %ecx,%eax
  803df4:	f7 f5                	div    %ebp
  803df6:	89 c1                	mov    %eax,%ecx
  803df8:	89 d8                	mov    %ebx,%eax
  803dfa:	f7 f5                	div    %ebp
  803dfc:	89 cf                	mov    %ecx,%edi
  803dfe:	89 fa                	mov    %edi,%edx
  803e00:	83 c4 1c             	add    $0x1c,%esp
  803e03:	5b                   	pop    %ebx
  803e04:	5e                   	pop    %esi
  803e05:	5f                   	pop    %edi
  803e06:	5d                   	pop    %ebp
  803e07:	c3                   	ret    
  803e08:	39 ce                	cmp    %ecx,%esi
  803e0a:	77 28                	ja     803e34 <__udivdi3+0x7c>
  803e0c:	0f bd fe             	bsr    %esi,%edi
  803e0f:	83 f7 1f             	xor    $0x1f,%edi
  803e12:	75 40                	jne    803e54 <__udivdi3+0x9c>
  803e14:	39 ce                	cmp    %ecx,%esi
  803e16:	72 0a                	jb     803e22 <__udivdi3+0x6a>
  803e18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e1c:	0f 87 9e 00 00 00    	ja     803ec0 <__udivdi3+0x108>
  803e22:	b8 01 00 00 00       	mov    $0x1,%eax
  803e27:	89 fa                	mov    %edi,%edx
  803e29:	83 c4 1c             	add    $0x1c,%esp
  803e2c:	5b                   	pop    %ebx
  803e2d:	5e                   	pop    %esi
  803e2e:	5f                   	pop    %edi
  803e2f:	5d                   	pop    %ebp
  803e30:	c3                   	ret    
  803e31:	8d 76 00             	lea    0x0(%esi),%esi
  803e34:	31 ff                	xor    %edi,%edi
  803e36:	31 c0                	xor    %eax,%eax
  803e38:	89 fa                	mov    %edi,%edx
  803e3a:	83 c4 1c             	add    $0x1c,%esp
  803e3d:	5b                   	pop    %ebx
  803e3e:	5e                   	pop    %esi
  803e3f:	5f                   	pop    %edi
  803e40:	5d                   	pop    %ebp
  803e41:	c3                   	ret    
  803e42:	66 90                	xchg   %ax,%ax
  803e44:	89 d8                	mov    %ebx,%eax
  803e46:	f7 f7                	div    %edi
  803e48:	31 ff                	xor    %edi,%edi
  803e4a:	89 fa                	mov    %edi,%edx
  803e4c:	83 c4 1c             	add    $0x1c,%esp
  803e4f:	5b                   	pop    %ebx
  803e50:	5e                   	pop    %esi
  803e51:	5f                   	pop    %edi
  803e52:	5d                   	pop    %ebp
  803e53:	c3                   	ret    
  803e54:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e59:	89 eb                	mov    %ebp,%ebx
  803e5b:	29 fb                	sub    %edi,%ebx
  803e5d:	89 f9                	mov    %edi,%ecx
  803e5f:	d3 e6                	shl    %cl,%esi
  803e61:	89 c5                	mov    %eax,%ebp
  803e63:	88 d9                	mov    %bl,%cl
  803e65:	d3 ed                	shr    %cl,%ebp
  803e67:	89 e9                	mov    %ebp,%ecx
  803e69:	09 f1                	or     %esi,%ecx
  803e6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e6f:	89 f9                	mov    %edi,%ecx
  803e71:	d3 e0                	shl    %cl,%eax
  803e73:	89 c5                	mov    %eax,%ebp
  803e75:	89 d6                	mov    %edx,%esi
  803e77:	88 d9                	mov    %bl,%cl
  803e79:	d3 ee                	shr    %cl,%esi
  803e7b:	89 f9                	mov    %edi,%ecx
  803e7d:	d3 e2                	shl    %cl,%edx
  803e7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e83:	88 d9                	mov    %bl,%cl
  803e85:	d3 e8                	shr    %cl,%eax
  803e87:	09 c2                	or     %eax,%edx
  803e89:	89 d0                	mov    %edx,%eax
  803e8b:	89 f2                	mov    %esi,%edx
  803e8d:	f7 74 24 0c          	divl   0xc(%esp)
  803e91:	89 d6                	mov    %edx,%esi
  803e93:	89 c3                	mov    %eax,%ebx
  803e95:	f7 e5                	mul    %ebp
  803e97:	39 d6                	cmp    %edx,%esi
  803e99:	72 19                	jb     803eb4 <__udivdi3+0xfc>
  803e9b:	74 0b                	je     803ea8 <__udivdi3+0xf0>
  803e9d:	89 d8                	mov    %ebx,%eax
  803e9f:	31 ff                	xor    %edi,%edi
  803ea1:	e9 58 ff ff ff       	jmp    803dfe <__udivdi3+0x46>
  803ea6:	66 90                	xchg   %ax,%ax
  803ea8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803eac:	89 f9                	mov    %edi,%ecx
  803eae:	d3 e2                	shl    %cl,%edx
  803eb0:	39 c2                	cmp    %eax,%edx
  803eb2:	73 e9                	jae    803e9d <__udivdi3+0xe5>
  803eb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803eb7:	31 ff                	xor    %edi,%edi
  803eb9:	e9 40 ff ff ff       	jmp    803dfe <__udivdi3+0x46>
  803ebe:	66 90                	xchg   %ax,%ax
  803ec0:	31 c0                	xor    %eax,%eax
  803ec2:	e9 37 ff ff ff       	jmp    803dfe <__udivdi3+0x46>
  803ec7:	90                   	nop

00803ec8 <__umoddi3>:
  803ec8:	55                   	push   %ebp
  803ec9:	57                   	push   %edi
  803eca:	56                   	push   %esi
  803ecb:	53                   	push   %ebx
  803ecc:	83 ec 1c             	sub    $0x1c,%esp
  803ecf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ed3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803edf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ee3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ee7:	89 f3                	mov    %esi,%ebx
  803ee9:	89 fa                	mov    %edi,%edx
  803eeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eef:	89 34 24             	mov    %esi,(%esp)
  803ef2:	85 c0                	test   %eax,%eax
  803ef4:	75 1a                	jne    803f10 <__umoddi3+0x48>
  803ef6:	39 f7                	cmp    %esi,%edi
  803ef8:	0f 86 a2 00 00 00    	jbe    803fa0 <__umoddi3+0xd8>
  803efe:	89 c8                	mov    %ecx,%eax
  803f00:	89 f2                	mov    %esi,%edx
  803f02:	f7 f7                	div    %edi
  803f04:	89 d0                	mov    %edx,%eax
  803f06:	31 d2                	xor    %edx,%edx
  803f08:	83 c4 1c             	add    $0x1c,%esp
  803f0b:	5b                   	pop    %ebx
  803f0c:	5e                   	pop    %esi
  803f0d:	5f                   	pop    %edi
  803f0e:	5d                   	pop    %ebp
  803f0f:	c3                   	ret    
  803f10:	39 f0                	cmp    %esi,%eax
  803f12:	0f 87 ac 00 00 00    	ja     803fc4 <__umoddi3+0xfc>
  803f18:	0f bd e8             	bsr    %eax,%ebp
  803f1b:	83 f5 1f             	xor    $0x1f,%ebp
  803f1e:	0f 84 ac 00 00 00    	je     803fd0 <__umoddi3+0x108>
  803f24:	bf 20 00 00 00       	mov    $0x20,%edi
  803f29:	29 ef                	sub    %ebp,%edi
  803f2b:	89 fe                	mov    %edi,%esi
  803f2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f31:	89 e9                	mov    %ebp,%ecx
  803f33:	d3 e0                	shl    %cl,%eax
  803f35:	89 d7                	mov    %edx,%edi
  803f37:	89 f1                	mov    %esi,%ecx
  803f39:	d3 ef                	shr    %cl,%edi
  803f3b:	09 c7                	or     %eax,%edi
  803f3d:	89 e9                	mov    %ebp,%ecx
  803f3f:	d3 e2                	shl    %cl,%edx
  803f41:	89 14 24             	mov    %edx,(%esp)
  803f44:	89 d8                	mov    %ebx,%eax
  803f46:	d3 e0                	shl    %cl,%eax
  803f48:	89 c2                	mov    %eax,%edx
  803f4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f4e:	d3 e0                	shl    %cl,%eax
  803f50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f54:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f58:	89 f1                	mov    %esi,%ecx
  803f5a:	d3 e8                	shr    %cl,%eax
  803f5c:	09 d0                	or     %edx,%eax
  803f5e:	d3 eb                	shr    %cl,%ebx
  803f60:	89 da                	mov    %ebx,%edx
  803f62:	f7 f7                	div    %edi
  803f64:	89 d3                	mov    %edx,%ebx
  803f66:	f7 24 24             	mull   (%esp)
  803f69:	89 c6                	mov    %eax,%esi
  803f6b:	89 d1                	mov    %edx,%ecx
  803f6d:	39 d3                	cmp    %edx,%ebx
  803f6f:	0f 82 87 00 00 00    	jb     803ffc <__umoddi3+0x134>
  803f75:	0f 84 91 00 00 00    	je     80400c <__umoddi3+0x144>
  803f7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f7f:	29 f2                	sub    %esi,%edx
  803f81:	19 cb                	sbb    %ecx,%ebx
  803f83:	89 d8                	mov    %ebx,%eax
  803f85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f89:	d3 e0                	shl    %cl,%eax
  803f8b:	89 e9                	mov    %ebp,%ecx
  803f8d:	d3 ea                	shr    %cl,%edx
  803f8f:	09 d0                	or     %edx,%eax
  803f91:	89 e9                	mov    %ebp,%ecx
  803f93:	d3 eb                	shr    %cl,%ebx
  803f95:	89 da                	mov    %ebx,%edx
  803f97:	83 c4 1c             	add    $0x1c,%esp
  803f9a:	5b                   	pop    %ebx
  803f9b:	5e                   	pop    %esi
  803f9c:	5f                   	pop    %edi
  803f9d:	5d                   	pop    %ebp
  803f9e:	c3                   	ret    
  803f9f:	90                   	nop
  803fa0:	89 fd                	mov    %edi,%ebp
  803fa2:	85 ff                	test   %edi,%edi
  803fa4:	75 0b                	jne    803fb1 <__umoddi3+0xe9>
  803fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fab:	31 d2                	xor    %edx,%edx
  803fad:	f7 f7                	div    %edi
  803faf:	89 c5                	mov    %eax,%ebp
  803fb1:	89 f0                	mov    %esi,%eax
  803fb3:	31 d2                	xor    %edx,%edx
  803fb5:	f7 f5                	div    %ebp
  803fb7:	89 c8                	mov    %ecx,%eax
  803fb9:	f7 f5                	div    %ebp
  803fbb:	89 d0                	mov    %edx,%eax
  803fbd:	e9 44 ff ff ff       	jmp    803f06 <__umoddi3+0x3e>
  803fc2:	66 90                	xchg   %ax,%ax
  803fc4:	89 c8                	mov    %ecx,%eax
  803fc6:	89 f2                	mov    %esi,%edx
  803fc8:	83 c4 1c             	add    $0x1c,%esp
  803fcb:	5b                   	pop    %ebx
  803fcc:	5e                   	pop    %esi
  803fcd:	5f                   	pop    %edi
  803fce:	5d                   	pop    %ebp
  803fcf:	c3                   	ret    
  803fd0:	3b 04 24             	cmp    (%esp),%eax
  803fd3:	72 06                	jb     803fdb <__umoddi3+0x113>
  803fd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fd9:	77 0f                	ja     803fea <__umoddi3+0x122>
  803fdb:	89 f2                	mov    %esi,%edx
  803fdd:	29 f9                	sub    %edi,%ecx
  803fdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fe3:	89 14 24             	mov    %edx,(%esp)
  803fe6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fea:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fee:	8b 14 24             	mov    (%esp),%edx
  803ff1:	83 c4 1c             	add    $0x1c,%esp
  803ff4:	5b                   	pop    %ebx
  803ff5:	5e                   	pop    %esi
  803ff6:	5f                   	pop    %edi
  803ff7:	5d                   	pop    %ebp
  803ff8:	c3                   	ret    
  803ff9:	8d 76 00             	lea    0x0(%esi),%esi
  803ffc:	2b 04 24             	sub    (%esp),%eax
  803fff:	19 fa                	sbb    %edi,%edx
  804001:	89 d1                	mov    %edx,%ecx
  804003:	89 c6                	mov    %eax,%esi
  804005:	e9 71 ff ff ff       	jmp    803f7b <__umoddi3+0xb3>
  80400a:	66 90                	xchg   %ax,%ax
  80400c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804010:	72 ea                	jb     803ffc <__umoddi3+0x134>
  804012:	89 d9                	mov    %ebx,%ecx
  804014:	e9 62 ff ff ff       	jmp    803f7b <__umoddi3+0xb3>
