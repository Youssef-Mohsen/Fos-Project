
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
  800055:	68 20 21 80 00       	push   $0x802120
  80005a:	e8 56 09 00 00       	call   8009b5 <cprintf>
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
  8000a5:	68 50 21 80 00       	push   $0x802150
  8000aa:	e8 06 09 00 00       	call   8009b5 <cprintf>
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
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  8000d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 89 21 80 00       	push   $0x802189
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 a5 21 80 00       	push   $0x8021a5
  8000f3:	e8 00 06 00 00       	call   8006f8 <_panic>
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
  800114:	e8 cb 18 00 00       	call   8019e4 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 78 18 00 00       	call   801999 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 bc 21 80 00       	push   $0x8021bc
  80012c:	e8 84 08 00 00       	call   8009b5 <cprintf>
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
  800164:	8b 04 85 00 30 80 00 	mov    0x803000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 e9 15 00 00       	call   801765 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 60 30 80 00 	mov    %edx,0x803060(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 60 5c 80 00 	mov    %edx,0x805c60(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 60 46 80 00 	mov    %edx,0x804660(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 30 80 00 	mov    0x803000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 30 80 00 	mov    0x803000(,%eax,4),%eax
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
  800266:	8b 04 85 00 30 80 00 	mov    0x803000(,%eax,4),%eax
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
  8002a0:	68 18 22 80 00       	push   $0x802218
  8002a5:	e8 0b 07 00 00       	call   8009b5 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b0:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  8002b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ba:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c0:	8b 14 85 60 5c 80 00 	mov    0x805c60(,%eax,4),%edx
  8002c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ca:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d0:	8b 14 85 60 46 80 00 	mov    0x804660(,%eax,4),%edx
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
  80030a:	68 3c 22 80 00       	push   $0x80223c
  80030f:	e8 a1 06 00 00       	call   8009b5 <cprintf>
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
  80032a:	8b 04 85 60 30 80 00 	mov    0x803060(,%eax,4),%eax
  800331:	66 8b 00             	mov    (%eax),%ax
  800334:	98                   	cwtl   
  800335:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800338:	75 26                	jne    800360 <_main+0x2a0>
  80033a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033d:	8b 04 85 60 5c 80 00 	mov    0x805c60(,%eax,4),%eax
  800344:	66 8b 00             	mov    (%eax),%ax
  800347:	98                   	cwtl   
  800348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80034b:	75 13                	jne    800360 <_main+0x2a0>
  80034d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800350:	8b 04 85 60 46 80 00 	mov    0x804660(,%eax,4),%eax
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
  800370:	68 78 22 80 00       	push   $0x802278
  800375:	e8 3b 06 00 00       	call   8009b5 <cprintf>
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
  800397:	68 c8 22 80 00       	push   $0x8022c8
  80039c:	e8 14 06 00 00       	call   8009b5 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 34 16 00 00       	call   8019e4 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 08 23 80 00       	push   $0x802308
  8003bd:	e8 f3 05 00 00       	call   8009b5 <cprintf>
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
  80047b:	68 44 23 80 00       	push   $0x802344
  800480:	e8 30 05 00 00       	call   8009b5 <cprintf>
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
  8004a8:	e8 ec 14 00 00       	call   801999 <sys_calculate_free_frames>
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
  8004d4:	68 88 23 80 00       	push   $0x802388
  8004d9:	e8 d7 04 00 00       	call   8009b5 <cprintf>
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
  8004f5:	68 d4 23 80 00       	push   $0x8023d4
  8004fa:	e8 b6 04 00 00       	call   8009b5 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800509:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80050c:	c1 e0 02             	shl    $0x2,%eax
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	50                   	push   %eax
  800513:	e8 4d 12 00 00       	call   801765 <malloc>
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
  800570:	e8 7f 18 00 00       	call   801df4 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 f8 23 80 00       	push   $0x8023f8
  80058f:	e8 21 04 00 00       	call   8009b5 <cprintf>
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
  8005ae:	68 1c 24 80 00       	push   $0x80241c
  8005b3:	e8 fd 03 00 00       	call   8009b5 <cprintf>
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
  8005c7:	e8 96 15 00 00       	call   801b62 <sys_getenvindex>
  8005cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8005cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	c1 e0 02             	shl    $0x2,%eax
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	01 c0                	add    %eax,%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	c1 e0 02             	shl    $0x2,%eax
  8005e0:	01 d0                	add    %edx,%eax
  8005e2:	01 c0                	add    %eax,%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	c1 e0 04             	shl    $0x4,%eax
  8005e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ee:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f8:	8a 40 20             	mov    0x20(%eax),%al
  8005fb:	84 c0                	test   %al,%al
  8005fd:	74 0d                	je     80060c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8005ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800604:	83 c0 20             	add    $0x20,%eax
  800607:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800610:	7e 0a                	jle    80061c <libmain+0x5b>
		binaryname = argv[0];
  800612:	8b 45 0c             	mov    0xc(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	_main(argc, argv);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 0c             	pushl  0xc(%ebp)
  800622:	ff 75 08             	pushl  0x8(%ebp)
  800625:	e8 96 fa ff ff       	call   8000c0 <_main>
  80062a:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80062d:	e8 b4 12 00 00       	call   8018e6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	68 7c 24 80 00       	push   $0x80247c
  80063a:	e8 76 03 00 00       	call   8009b5 <cprintf>
  80063f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800642:	a1 20 30 80 00       	mov    0x803020,%eax
  800647:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80064d:	a1 20 30 80 00       	mov    0x803020,%eax
  800652:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	52                   	push   %edx
  80065c:	50                   	push   %eax
  80065d:	68 a4 24 80 00       	push   $0x8024a4
  800662:	e8 4e 03 00 00       	call   8009b5 <cprintf>
  800667:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80066a:	a1 20 30 80 00       	mov    0x803020,%eax
  80066f:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80068b:	51                   	push   %ecx
  80068c:	52                   	push   %edx
  80068d:	50                   	push   %eax
  80068e:	68 cc 24 80 00       	push   $0x8024cc
  800693:	e8 1d 03 00 00       	call   8009b5 <cprintf>
  800698:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80069b:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a0:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	50                   	push   %eax
  8006aa:	68 24 25 80 00       	push   $0x802524
  8006af:	e8 01 03 00 00       	call   8009b5 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	68 7c 24 80 00       	push   $0x80247c
  8006bf:	e8 f1 02 00 00       	call   8009b5 <cprintf>
  8006c4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8006c7:	e8 34 12 00 00       	call   801900 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8006cc:	e8 19 00 00 00       	call   8006ea <exit>
}
  8006d1:	90                   	nop
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	6a 00                	push   $0x0
  8006df:	e8 4a 14 00 00       	call   801b2e <sys_destroy_env>
  8006e4:	83 c4 10             	add    $0x10,%esp
}
  8006e7:	90                   	nop
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <exit>:

void
exit(void)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006f0:	e8 9f 14 00 00       	call   801b94 <sys_exit_env>
}
  8006f5:	90                   	nop
  8006f6:	c9                   	leave  
  8006f7:	c3                   	ret    

008006f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800701:	83 c0 04             	add    $0x4,%eax
  800704:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800707:	a1 54 72 80 00       	mov    0x807254,%eax
  80070c:	85 c0                	test   %eax,%eax
  80070e:	74 16                	je     800726 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800710:	a1 54 72 80 00       	mov    0x807254,%eax
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	50                   	push   %eax
  800719:	68 38 25 80 00       	push   $0x802538
  80071e:	e8 92 02 00 00       	call   8009b5 <cprintf>
  800723:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800726:	a1 1c 30 80 00       	mov    0x80301c,%eax
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	ff 75 08             	pushl  0x8(%ebp)
  800731:	50                   	push   %eax
  800732:	68 3d 25 80 00       	push   $0x80253d
  800737:	e8 79 02 00 00       	call   8009b5 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	ff 75 f4             	pushl  -0xc(%ebp)
  800748:	50                   	push   %eax
  800749:	e8 fc 01 00 00       	call   80094a <vcprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	68 59 25 80 00       	push   $0x802559
  80075b:	e8 ea 01 00 00       	call   80094a <vcprintf>
  800760:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800763:	e8 82 ff ff ff       	call   8006ea <exit>

	// should not return here
	while (1) ;
  800768:	eb fe                	jmp    800768 <_panic+0x70>

0080076a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800770:	a1 20 30 80 00       	mov    0x803020,%eax
  800775:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80077b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077e:	39 c2                	cmp    %eax,%edx
  800780:	74 14                	je     800796 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800782:	83 ec 04             	sub    $0x4,%esp
  800785:	68 5c 25 80 00       	push   $0x80255c
  80078a:	6a 26                	push   $0x26
  80078c:	68 a8 25 80 00       	push   $0x8025a8
  800791:	e8 62 ff ff ff       	call   8006f8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80079d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007a4:	e9 c5 00 00 00       	jmp    80086e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	01 d0                	add    %edx,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	75 08                	jne    8007c6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8007be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007c1:	e9 a5 00 00 00       	jmp    80086b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8007c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007d4:	eb 69                	jmp    80083f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8007db:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8007e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007e4:	89 d0                	mov    %edx,%eax
  8007e6:	01 c0                	add    %eax,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 03             	shl    $0x3,%eax
  8007ed:	01 c8                	add    %ecx,%eax
  8007ef:	8a 40 04             	mov    0x4(%eax),%al
  8007f2:	84 c0                	test   %al,%al
  8007f4:	75 46                	jne    80083c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8007fb:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800801:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	01 c0                	add    %eax,%eax
  800808:	01 d0                	add    %edx,%eax
  80080a:	c1 e0 03             	shl    $0x3,%eax
  80080d:	01 c8                	add    %ecx,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800817:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80081e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800821:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	01 c8                	add    %ecx,%eax
  80082d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80082f:	39 c2                	cmp    %eax,%edx
  800831:	75 09                	jne    80083c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800833:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80083a:	eb 15                	jmp    800851 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80083c:	ff 45 e8             	incl   -0x18(%ebp)
  80083f:	a1 20 30 80 00       	mov    0x803020,%eax
  800844:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80084a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80084d:	39 c2                	cmp    %eax,%edx
  80084f:	77 85                	ja     8007d6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800855:	75 14                	jne    80086b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800857:	83 ec 04             	sub    $0x4,%esp
  80085a:	68 b4 25 80 00       	push   $0x8025b4
  80085f:	6a 3a                	push   $0x3a
  800861:	68 a8 25 80 00       	push   $0x8025a8
  800866:	e8 8d fe ff ff       	call   8006f8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80086b:	ff 45 f0             	incl   -0x10(%ebp)
  80086e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800871:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800874:	0f 8c 2f ff ff ff    	jl     8007a9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80087a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800881:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800888:	eb 26                	jmp    8008b0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80088a:	a1 20 30 80 00       	mov    0x803020,%eax
  80088f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800895:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800898:	89 d0                	mov    %edx,%eax
  80089a:	01 c0                	add    %eax,%eax
  80089c:	01 d0                	add    %edx,%eax
  80089e:	c1 e0 03             	shl    $0x3,%eax
  8008a1:	01 c8                	add    %ecx,%eax
  8008a3:	8a 40 04             	mov    0x4(%eax),%al
  8008a6:	3c 01                	cmp    $0x1,%al
  8008a8:	75 03                	jne    8008ad <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008aa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008be:	39 c2                	cmp    %eax,%edx
  8008c0:	77 c8                	ja     80088a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008c8:	74 14                	je     8008de <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8008ca:	83 ec 04             	sub    $0x4,%esp
  8008cd:	68 08 26 80 00       	push   $0x802608
  8008d2:	6a 44                	push   $0x44
  8008d4:	68 a8 25 80 00       	push   $0x8025a8
  8008d9:	e8 1a fe ff ff       	call   8006f8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008de:	90                   	nop
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f2:	89 0a                	mov    %ecx,(%edx)
  8008f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f7:	88 d1                	mov    %dl,%cl
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	3d ff 00 00 00       	cmp    $0xff,%eax
  80090a:	75 2c                	jne    800938 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80090c:	a0 40 30 80 00       	mov    0x803040,%al
  800911:	0f b6 c0             	movzbl %al,%eax
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	8b 12                	mov    (%edx),%edx
  800919:	89 d1                	mov    %edx,%ecx
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091e:	83 c2 08             	add    $0x8,%edx
  800921:	83 ec 04             	sub    $0x4,%esp
  800924:	50                   	push   %eax
  800925:	51                   	push   %ecx
  800926:	52                   	push   %edx
  800927:	e8 78 0f 00 00       	call   8018a4 <sys_cputs>
  80092c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 40 04             	mov    0x4(%eax),%eax
  80093e:	8d 50 01             	lea    0x1(%eax),%edx
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	89 50 04             	mov    %edx,0x4(%eax)
}
  800947:	90                   	nop
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800953:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80095a:	00 00 00 
	b.cnt = 0;
  80095d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800964:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	ff 75 08             	pushl  0x8(%ebp)
  80096d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	68 e1 08 80 00       	push   $0x8008e1
  800979:	e8 11 02 00 00       	call   800b8f <vprintfmt>
  80097e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800981:	a0 40 30 80 00       	mov    0x803040,%al
  800986:	0f b6 c0             	movzbl %al,%eax
  800989:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80098f:	83 ec 04             	sub    $0x4,%esp
  800992:	50                   	push   %eax
  800993:	52                   	push   %edx
  800994:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099a:	83 c0 08             	add    $0x8,%eax
  80099d:	50                   	push   %eax
  80099e:	e8 01 0f 00 00       	call   8018a4 <sys_cputs>
  8009a3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009a6:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
	return b.cnt;
  8009ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bb:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
	va_start(ap, fmt);
  8009c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d1:	50                   	push   %eax
  8009d2:	e8 73 ff ff ff       	call   80094a <vcprintf>
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8009e8:	e8 f9 0e 00 00       	call   8018e6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8009ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	e8 48 ff ff ff       	call   80094a <vcprintf>
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a08:	e8 f3 0e 00 00       	call   801900 <sys_unlock_cons>
	return cnt;
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	83 ec 14             	sub    $0x14,%esp
  800a19:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a25:	8b 45 18             	mov    0x18(%ebp),%eax
  800a28:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a30:	77 55                	ja     800a87 <printnum+0x75>
  800a32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a35:	72 05                	jb     800a3c <printnum+0x2a>
  800a37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a3a:	77 4b                	ja     800a87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	52                   	push   %edx
  800a4b:	50                   	push   %eax
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a52:	e8 4d 14 00 00       	call   801ea4 <__udivdi3>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	ff 75 20             	pushl  0x20(%ebp)
  800a60:	53                   	push   %ebx
  800a61:	ff 75 18             	pushl  0x18(%ebp)
  800a64:	52                   	push   %edx
  800a65:	50                   	push   %eax
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	ff 75 08             	pushl  0x8(%ebp)
  800a6c:	e8 a1 ff ff ff       	call   800a12 <printnum>
  800a71:	83 c4 20             	add    $0x20,%esp
  800a74:	eb 1a                	jmp    800a90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	ff 75 20             	pushl  0x20(%ebp)
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a87:	ff 4d 1c             	decl   0x1c(%ebp)
  800a8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a8e:	7f e6                	jg     800a76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9e:	53                   	push   %ebx
  800a9f:	51                   	push   %ecx
  800aa0:	52                   	push   %edx
  800aa1:	50                   	push   %eax
  800aa2:	e8 0d 15 00 00       	call   801fb4 <__umoddi3>
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	05 74 28 80 00       	add    $0x802874,%eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	0f be c0             	movsbl %al,%eax
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	50                   	push   %eax
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
}
  800ac3:	90                   	nop
  800ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800acc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad0:	7e 1c                	jle    800aee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 00                	mov    (%eax),%eax
  800ad7:	8d 50 08             	lea    0x8(%eax),%edx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	89 10                	mov    %edx,(%eax)
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	83 e8 08             	sub    $0x8,%eax
  800ae7:	8b 50 04             	mov    0x4(%eax),%edx
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	eb 40                	jmp    800b2e <getuint+0x65>
	else if (lflag)
  800aee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af2:	74 1e                	je     800b12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	8d 50 04             	lea    0x4(%eax),%edx
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	89 10                	mov    %edx,(%eax)
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	83 e8 04             	sub    $0x4,%eax
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	eb 1c                	jmp    800b2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	8d 50 04             	lea    0x4(%eax),%edx
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	89 10                	mov    %edx,(%eax)
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b37:	7e 1c                	jle    800b55 <getint+0x25>
		return va_arg(*ap, long long);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8d 50 08             	lea    0x8(%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	83 e8 08             	sub    $0x8,%eax
  800b4e:	8b 50 04             	mov    0x4(%eax),%edx
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	eb 38                	jmp    800b8d <getint+0x5d>
	else if (lflag)
  800b55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b59:	74 1a                	je     800b75 <getint+0x45>
		return va_arg(*ap, long);
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	8d 50 04             	lea    0x4(%eax),%edx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	89 10                	mov    %edx,(%eax)
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	83 e8 04             	sub    $0x4,%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	99                   	cltd   
  800b73:	eb 18                	jmp    800b8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	8d 50 04             	lea    0x4(%eax),%edx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 10                	mov    %edx,(%eax)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	83 e8 04             	sub    $0x4,%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	99                   	cltd   
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b97:	eb 17                	jmp    800bb0 <vprintfmt+0x21>
			if (ch == '\0')
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	0f 84 c1 03 00 00    	je     800f62 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	8d 50 01             	lea    0x1(%eax),%edx
  800bb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	0f b6 d8             	movzbl %al,%ebx
  800bbe:	83 fb 25             	cmp    $0x25,%ebx
  800bc1:	75 d6                	jne    800b99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bdc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be3:	8b 45 10             	mov    0x10(%ebp),%eax
  800be6:	8d 50 01             	lea    0x1(%eax),%edx
  800be9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	0f b6 d8             	movzbl %al,%ebx
  800bf1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bf4:	83 f8 5b             	cmp    $0x5b,%eax
  800bf7:	0f 87 3d 03 00 00    	ja     800f3a <vprintfmt+0x3ab>
  800bfd:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  800c04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c0a:	eb d7                	jmp    800be3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c10:	eb d1                	jmp    800be3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1c:	89 d0                	mov    %edx,%eax
  800c1e:	c1 e0 02             	shl    $0x2,%eax
  800c21:	01 d0                	add    %edx,%eax
  800c23:	01 c0                	add    %eax,%eax
  800c25:	01 d8                	add    %ebx,%eax
  800c27:	83 e8 30             	sub    $0x30,%eax
  800c2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c35:	83 fb 2f             	cmp    $0x2f,%ebx
  800c38:	7e 3e                	jle    800c78 <vprintfmt+0xe9>
  800c3a:	83 fb 39             	cmp    $0x39,%ebx
  800c3d:	7f 39                	jg     800c78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c42:	eb d5                	jmp    800c19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c44:	8b 45 14             	mov    0x14(%ebp),%eax
  800c47:	83 c0 04             	add    $0x4,%eax
  800c4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c50:	83 e8 04             	sub    $0x4,%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c58:	eb 1f                	jmp    800c79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5e:	79 83                	jns    800be3 <vprintfmt+0x54>
				width = 0;
  800c60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c67:	e9 77 ff ff ff       	jmp    800be3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c73:	e9 6b ff ff ff       	jmp    800be3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7d:	0f 89 60 ff ff ff    	jns    800be3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c90:	e9 4e ff ff ff       	jmp    800be3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c98:	e9 46 ff ff ff       	jmp    800be3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	83 c0 04             	add    $0x4,%eax
  800ca3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca9:	83 e8 04             	sub    $0x4,%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	50                   	push   %eax
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	ff d0                	call   *%eax
  800cba:	83 c4 10             	add    $0x10,%esp
			break;
  800cbd:	e9 9b 02 00 00       	jmp    800f5d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cd3:	85 db                	test   %ebx,%ebx
  800cd5:	79 02                	jns    800cd9 <vprintfmt+0x14a>
				err = -err;
  800cd7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cd9:	83 fb 64             	cmp    $0x64,%ebx
  800cdc:	7f 0b                	jg     800ce9 <vprintfmt+0x15a>
  800cde:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800ce5:	85 f6                	test   %esi,%esi
  800ce7:	75 19                	jne    800d02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ce9:	53                   	push   %ebx
  800cea:	68 85 28 80 00       	push   $0x802885
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 70 02 00 00       	call   800f6a <printfmt>
  800cfa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cfd:	e9 5b 02 00 00       	jmp    800f5d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d02:	56                   	push   %esi
  800d03:	68 8e 28 80 00       	push   $0x80288e
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	ff 75 08             	pushl  0x8(%ebp)
  800d0e:	e8 57 02 00 00       	call   800f6a <printfmt>
  800d13:	83 c4 10             	add    $0x10,%esp
			break;
  800d16:	e9 42 02 00 00       	jmp    800f5d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1e:	83 c0 04             	add    $0x4,%eax
  800d21:	89 45 14             	mov    %eax,0x14(%ebp)
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	83 e8 04             	sub    $0x4,%eax
  800d2a:	8b 30                	mov    (%eax),%esi
  800d2c:	85 f6                	test   %esi,%esi
  800d2e:	75 05                	jne    800d35 <vprintfmt+0x1a6>
				p = "(null)";
  800d30:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  800d35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d39:	7e 6d                	jle    800da8 <vprintfmt+0x219>
  800d3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d3f:	74 67                	je     800da8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d44:	83 ec 08             	sub    $0x8,%esp
  800d47:	50                   	push   %eax
  800d48:	56                   	push   %esi
  800d49:	e8 1e 03 00 00       	call   80106c <strnlen>
  800d4e:	83 c4 10             	add    $0x10,%esp
  800d51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d54:	eb 16                	jmp    800d6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d5a:	83 ec 08             	sub    $0x8,%esp
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	50                   	push   %eax
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d69:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d70:	7f e4                	jg     800d56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d72:	eb 34                	jmp    800da8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d78:	74 1c                	je     800d96 <vprintfmt+0x207>
  800d7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d7d:	7e 05                	jle    800d84 <vprintfmt+0x1f5>
  800d7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d82:	7e 12                	jle    800d96 <vprintfmt+0x207>
					putch('?', putdat);
  800d84:	83 ec 08             	sub    $0x8,%esp
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	6a 3f                	push   $0x3f
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	ff d0                	call   *%eax
  800d91:	83 c4 10             	add    $0x10,%esp
  800d94:	eb 0f                	jmp    800da5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	53                   	push   %ebx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	89 f0                	mov    %esi,%eax
  800daa:	8d 70 01             	lea    0x1(%eax),%esi
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	0f be d8             	movsbl %al,%ebx
  800db2:	85 db                	test   %ebx,%ebx
  800db4:	74 24                	je     800dda <vprintfmt+0x24b>
  800db6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dba:	78 b8                	js     800d74 <vprintfmt+0x1e5>
  800dbc:	ff 4d e0             	decl   -0x20(%ebp)
  800dbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc3:	79 af                	jns    800d74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc5:	eb 13                	jmp    800dda <vprintfmt+0x24b>
				putch(' ', putdat);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	6a 20                	push   $0x20
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	ff d0                	call   *%eax
  800dd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dde:	7f e7                	jg     800dc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800de0:	e9 78 01 00 00       	jmp    800f5d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	ff 75 e8             	pushl  -0x18(%ebp)
  800deb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dee:	50                   	push   %eax
  800def:	e8 3c fd ff ff       	call   800b30 <getint>
  800df4:	83 c4 10             	add    $0x10,%esp
  800df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e03:	85 d2                	test   %edx,%edx
  800e05:	79 23                	jns    800e2a <vprintfmt+0x29b>
				putch('-', putdat);
  800e07:	83 ec 08             	sub    $0x8,%esp
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	6a 2d                	push   $0x2d
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	ff d0                	call   *%eax
  800e14:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1d:	f7 d8                	neg    %eax
  800e1f:	83 d2 00             	adc    $0x0,%edx
  800e22:	f7 da                	neg    %edx
  800e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e2a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e31:	e9 bc 00 00 00       	jmp    800ef2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e3f:	50                   	push   %eax
  800e40:	e8 84 fc ff ff       	call   800ac9 <getuint>
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e55:	e9 98 00 00 00       	jmp    800ef2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	6a 58                	push   $0x58
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	ff d0                	call   *%eax
  800e77:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e7a:	83 ec 08             	sub    $0x8,%esp
  800e7d:	ff 75 0c             	pushl  0xc(%ebp)
  800e80:	6a 58                	push   $0x58
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	ff d0                	call   *%eax
  800e87:	83 c4 10             	add    $0x10,%esp
			break;
  800e8a:	e9 ce 00 00 00       	jmp    800f5d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 30                	push   $0x30
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 78                	push   $0x78
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb2:	83 c0 04             	add    $0x4,%eax
  800eb5:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ed1:	eb 1f                	jmp    800ef2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed9:	8d 45 14             	lea    0x14(%ebp),%eax
  800edc:	50                   	push   %eax
  800edd:	e8 e7 fb ff ff       	call   800ac9 <getuint>
  800ee2:	83 c4 10             	add    $0x10,%esp
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eeb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ef2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	52                   	push   %edx
  800efd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f00:	50                   	push   %eax
  800f01:	ff 75 f4             	pushl  -0xc(%ebp)
  800f04:	ff 75 f0             	pushl  -0x10(%ebp)
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	ff 75 08             	pushl  0x8(%ebp)
  800f0d:	e8 00 fb ff ff       	call   800a12 <printnum>
  800f12:	83 c4 20             	add    $0x20,%esp
			break;
  800f15:	eb 46                	jmp    800f5d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	ff 75 0c             	pushl  0xc(%ebp)
  800f1d:	53                   	push   %ebx
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	ff d0                	call   *%eax
  800f23:	83 c4 10             	add    $0x10,%esp
			break;
  800f26:	eb 35                	jmp    800f5d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f28:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
			break;
  800f2f:	eb 2c                	jmp    800f5d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f31:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
			break;
  800f38:	eb 23                	jmp    800f5d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	6a 25                	push   $0x25
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	ff d0                	call   *%eax
  800f47:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f4a:	ff 4d 10             	decl   0x10(%ebp)
  800f4d:	eb 03                	jmp    800f52 <vprintfmt+0x3c3>
  800f4f:	ff 4d 10             	decl   0x10(%ebp)
  800f52:	8b 45 10             	mov    0x10(%ebp),%eax
  800f55:	48                   	dec    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 25                	cmp    $0x25,%al
  800f5a:	75 f3                	jne    800f4f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f5c:	90                   	nop
		}
	}
  800f5d:	e9 35 fc ff ff       	jmp    800b97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f62:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f70:	8d 45 10             	lea    0x10(%ebp),%eax
  800f73:	83 c0 04             	add    $0x4,%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f79:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	ff 75 08             	pushl  0x8(%ebp)
  800f86:	e8 04 fc ff ff       	call   800b8f <vprintfmt>
  800f8b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f8e:	90                   	nop
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8b 40 08             	mov    0x8(%eax),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8b 10                	mov    (%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	8b 40 04             	mov    0x4(%eax),%eax
  800fae:	39 c2                	cmp    %eax,%edx
  800fb0:	73 12                	jae    800fc4 <sprintputch+0x33>
		*b->buf++ = ch;
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8b 00                	mov    (%eax),%eax
  800fb7:	8d 48 01             	lea    0x1(%eax),%ecx
  800fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbd:	89 0a                	mov    %ecx,(%edx)
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	88 10                	mov    %dl,(%eax)
}
  800fc4:	90                   	nop
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 d0                	add    %edx,%eax
  800fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fe8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fec:	74 06                	je     800ff4 <vsnprintf+0x2d>
  800fee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ff2:	7f 07                	jg     800ffb <vsnprintf+0x34>
		return -E_INVAL;
  800ff4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff9:	eb 20                	jmp    80101b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ffb:	ff 75 14             	pushl  0x14(%ebp)
  800ffe:	ff 75 10             	pushl  0x10(%ebp)
  801001:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801004:	50                   	push   %eax
  801005:	68 91 0f 80 00       	push   $0x800f91
  80100a:	e8 80 fb ff ff       	call   800b8f <vprintfmt>
  80100f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801015:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801018:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801023:	8d 45 10             	lea    0x10(%ebp),%eax
  801026:	83 c0 04             	add    $0x4,%eax
  801029:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	ff 75 f4             	pushl  -0xc(%ebp)
  801032:	50                   	push   %eax
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	ff 75 08             	pushl  0x8(%ebp)
  801039:	e8 89 ff ff ff       	call   800fc7 <vsnprintf>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801056:	eb 06                	jmp    80105e <strlen+0x15>
		n++;
  801058:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80105b:	ff 45 08             	incl   0x8(%ebp)
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	84 c0                	test   %al,%al
  801065:	75 f1                	jne    801058 <strlen+0xf>
		n++;
	return n;
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 09                	jmp    801084 <strnlen+0x18>
		n++;
  80107b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	ff 4d 0c             	decl   0xc(%ebp)
  801084:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801088:	74 09                	je     801093 <strnlen+0x27>
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	84 c0                	test   %al,%al
  801091:	75 e8                	jne    80107b <strnlen+0xf>
		n++;
	return n;
  801093:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010a4:	90                   	nop
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b7:	8a 12                	mov    (%edx),%dl
  8010b9:	88 10                	mov    %dl,(%eax)
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	84 c0                	test   %al,%al
  8010bf:	75 e4                	jne    8010a5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strncpy+0x34>
		*dst++ = *src;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e7:	8a 12                	mov    (%edx),%dl
  8010e9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	84 c0                	test   %al,%al
  8010f2:	74 03                	je     8010f7 <strncpy+0x31>
			src++;
  8010f4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f7:	ff 45 fc             	incl   -0x4(%ebp)
  8010fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fd:	3b 45 10             	cmp    0x10(%ebp),%eax
  801100:	72 d9                	jb     8010db <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	74 30                	je     801149 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801119:	eb 16                	jmp    801131 <strlcpy+0x2a>
			*dst++ = *src++;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	89 55 08             	mov    %edx,0x8(%ebp)
  801124:	8b 55 0c             	mov    0xc(%ebp),%edx
  801127:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801131:	ff 4d 10             	decl   0x10(%ebp)
  801134:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801138:	74 09                	je     801143 <strlcpy+0x3c>
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	84 c0                	test   %al,%al
  801141:	75 d8                	jne    80111b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	29 c2                	sub    %eax,%edx
  801151:	89 d0                	mov    %edx,%eax
}
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801158:	eb 06                	jmp    801160 <strcmp+0xb>
		p++, q++;
  80115a:	ff 45 08             	incl   0x8(%ebp)
  80115d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	84 c0                	test   %al,%al
  801167:	74 0e                	je     801177 <strcmp+0x22>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 10                	mov    (%eax),%dl
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	38 c2                	cmp    %al,%dl
  801175:	74 e3                	je     80115a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 d0             	movzbl %al,%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f b6 c0             	movzbl %al,%eax
  801187:	29 c2                	sub    %eax,%edx
  801189:	89 d0                	mov    %edx,%eax
}
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801190:	eb 09                	jmp    80119b <strncmp+0xe>
		n--, p++, q++;
  801192:	ff 4d 10             	decl   0x10(%ebp)
  801195:	ff 45 08             	incl   0x8(%ebp)
  801198:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 17                	je     8011b8 <strncmp+0x2b>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	84 c0                	test   %al,%al
  8011a8:	74 0e                	je     8011b8 <strncmp+0x2b>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 10                	mov    (%eax),%dl
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	38 c2                	cmp    %al,%dl
  8011b6:	74 da                	je     801192 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	75 07                	jne    8011c5 <strncmp+0x38>
		return 0;
  8011be:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c3:	eb 14                	jmp    8011d9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 d0             	movzbl %al,%edx
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	0f b6 c0             	movzbl %al,%eax
  8011d5:	29 c2                	sub    %eax,%edx
  8011d7:	89 d0                	mov    %edx,%eax
}
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e7:	eb 12                	jmp    8011fb <strchr+0x20>
		if (*s == c)
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f1:	75 05                	jne    8011f8 <strchr+0x1d>
			return (char *) s;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	eb 11                	jmp    801209 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f8:	ff 45 08             	incl   0x8(%ebp)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	84 c0                	test   %al,%al
  801202:	75 e5                	jne    8011e9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801217:	eb 0d                	jmp    801226 <strfind+0x1b>
		if (*s == c)
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801221:	74 0e                	je     801231 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	84 c0                	test   %al,%al
  80122d:	75 ea                	jne    801219 <strfind+0xe>
  80122f:	eb 01                	jmp    801232 <strfind+0x27>
		if (*s == c)
			break;
  801231:	90                   	nop
	return (char *) s;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801249:	eb 0e                	jmp    801259 <memset+0x22>
		*p++ = c;
  80124b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124e:	8d 50 01             	lea    0x1(%eax),%edx
  801251:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801254:	8b 55 0c             	mov    0xc(%ebp),%edx
  801257:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801259:	ff 4d f8             	decl   -0x8(%ebp)
  80125c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801260:	79 e9                	jns    80124b <memset+0x14>
		*p++ = c;

	return v;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80126d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801270:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801279:	eb 16                	jmp    801291 <memcpy+0x2a>
		*d++ = *s++;
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	8d 50 01             	lea    0x1(%eax),%edx
  801281:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8d 4a 01             	lea    0x1(%edx),%ecx
  80128a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80128d:	8a 12                	mov    (%edx),%dl
  80128f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	8d 50 ff             	lea    -0x1(%eax),%edx
  801297:	89 55 10             	mov    %edx,0x10(%ebp)
  80129a:	85 c0                	test   %eax,%eax
  80129c:	75 dd                	jne    80127b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012bb:	73 50                	jae    80130d <memmove+0x6a>
  8012bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	01 d0                	add    %edx,%eax
  8012c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c8:	76 43                	jbe    80130d <memmove+0x6a>
		s += n;
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d6:	eb 10                	jmp    8012e8 <memmove+0x45>
			*--d = *--s;
  8012d8:	ff 4d f8             	decl   -0x8(%ebp)
  8012db:	ff 4d fc             	decl   -0x4(%ebp)
  8012de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e1:	8a 10                	mov    (%eax),%dl
  8012e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	75 e3                	jne    8012d8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012f5:	eb 23                	jmp    80131a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fa:	8d 50 01             	lea    0x1(%eax),%edx
  8012fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801300:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801303:	8d 4a 01             	lea    0x1(%edx),%ecx
  801306:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801309:	8a 12                	mov    (%edx),%dl
  80130b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	8d 50 ff             	lea    -0x1(%eax),%edx
  801313:	89 55 10             	mov    %edx,0x10(%ebp)
  801316:	85 c0                	test   %eax,%eax
  801318:	75 dd                	jne    8012f7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801331:	eb 2a                	jmp    80135d <memcmp+0x3e>
		if (*s1 != *s2)
  801333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801336:	8a 10                	mov    (%eax),%dl
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	38 c2                	cmp    %al,%dl
  80133f:	74 16                	je     801357 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f b6 d0             	movzbl %al,%edx
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f b6 c0             	movzbl %al,%eax
  801351:	29 c2                	sub    %eax,%edx
  801353:	89 d0                	mov    %edx,%eax
  801355:	eb 18                	jmp    80136f <memcmp+0x50>
		s1++, s2++;
  801357:	ff 45 fc             	incl   -0x4(%ebp)
  80135a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80135d:	8b 45 10             	mov    0x10(%ebp),%eax
  801360:	8d 50 ff             	lea    -0x1(%eax),%edx
  801363:	89 55 10             	mov    %edx,0x10(%ebp)
  801366:	85 c0                	test   %eax,%eax
  801368:	75 c9                	jne    801333 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801377:	8b 55 08             	mov    0x8(%ebp),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 d0                	add    %edx,%eax
  80137f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801382:	eb 15                	jmp    801399 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	0f b6 d0             	movzbl %al,%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	0f b6 c0             	movzbl %al,%eax
  801392:	39 c2                	cmp    %eax,%edx
  801394:	74 0d                	je     8013a3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801396:	ff 45 08             	incl   0x8(%ebp)
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80139f:	72 e3                	jb     801384 <memfind+0x13>
  8013a1:	eb 01                	jmp    8013a4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013a3:	90                   	nop
	return (void *) s;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013bd:	eb 03                	jmp    8013c2 <strtol+0x19>
		s++;
  8013bf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 20                	cmp    $0x20,%al
  8013c9:	74 f4                	je     8013bf <strtol+0x16>
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	3c 09                	cmp    $0x9,%al
  8013d2:	74 eb                	je     8013bf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	3c 2b                	cmp    $0x2b,%al
  8013db:	75 05                	jne    8013e2 <strtol+0x39>
		s++;
  8013dd:	ff 45 08             	incl   0x8(%ebp)
  8013e0:	eb 13                	jmp    8013f5 <strtol+0x4c>
	else if (*s == '-')
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3c 2d                	cmp    $0x2d,%al
  8013e9:	75 0a                	jne    8013f5 <strtol+0x4c>
		s++, neg = 1;
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f9:	74 06                	je     801401 <strtol+0x58>
  8013fb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ff:	75 20                	jne    801421 <strtol+0x78>
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 30                	cmp    $0x30,%al
  801408:	75 17                	jne    801421 <strtol+0x78>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	40                   	inc    %eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 78                	cmp    $0x78,%al
  801412:	75 0d                	jne    801421 <strtol+0x78>
		s += 2, base = 16;
  801414:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801418:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80141f:	eb 28                	jmp    801449 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801421:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801425:	75 15                	jne    80143c <strtol+0x93>
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 30                	cmp    $0x30,%al
  80142e:	75 0c                	jne    80143c <strtol+0x93>
		s++, base = 8;
  801430:	ff 45 08             	incl   0x8(%ebp)
  801433:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80143a:	eb 0d                	jmp    801449 <strtol+0xa0>
	else if (base == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strtol+0xa0>
		base = 10;
  801442:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 2f                	cmp    $0x2f,%al
  801450:	7e 19                	jle    80146b <strtol+0xc2>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 39                	cmp    $0x39,%al
  801459:	7f 10                	jg     80146b <strtol+0xc2>
			dig = *s - '0';
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 30             	sub    $0x30,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801469:	eb 42                	jmp    8014ad <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 60                	cmp    $0x60,%al
  801472:	7e 19                	jle    80148d <strtol+0xe4>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 7a                	cmp    $0x7a,%al
  80147b:	7f 10                	jg     80148d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	0f be c0             	movsbl %al,%eax
  801485:	83 e8 57             	sub    $0x57,%eax
  801488:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80148b:	eb 20                	jmp    8014ad <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	3c 40                	cmp    $0x40,%al
  801494:	7e 39                	jle    8014cf <strtol+0x126>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	3c 5a                	cmp    $0x5a,%al
  80149d:	7f 30                	jg     8014cf <strtol+0x126>
			dig = *s - 'A' + 10;
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	0f be c0             	movsbl %al,%eax
  8014a7:	83 e8 37             	sub    $0x37,%eax
  8014aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014b3:	7d 19                	jge    8014ce <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014b5:	ff 45 08             	incl   0x8(%ebp)
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014bf:	89 c2                	mov    %eax,%edx
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014c9:	e9 7b ff ff ff       	jmp    801449 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ce:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014d3:	74 08                	je     8014dd <strtol+0x134>
		*endptr = (char *) s;
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014db:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014e1:	74 07                	je     8014ea <strtol+0x141>
  8014e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e6:	f7 d8                	neg    %eax
  8014e8:	eb 03                	jmp    8014ed <strtol+0x144>
  8014ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <ltostr>:

void
ltostr(long value, char *str)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801507:	79 13                	jns    80151c <ltostr+0x2d>
	{
		neg = 1;
  801509:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801516:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801519:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801524:	99                   	cltd   
  801525:	f7 f9                	idiv   %ecx
  801527:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80152a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152d:	8d 50 01             	lea    0x1(%eax),%edx
  801530:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801533:	89 c2                	mov    %eax,%edx
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	01 d0                	add    %edx,%eax
  80153a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80153d:	83 c2 30             	add    $0x30,%edx
  801540:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801542:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801545:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80154a:	f7 e9                	imul   %ecx
  80154c:	c1 fa 02             	sar    $0x2,%edx
  80154f:	89 c8                	mov    %ecx,%eax
  801551:	c1 f8 1f             	sar    $0x1f,%eax
  801554:	29 c2                	sub    %eax,%edx
  801556:	89 d0                	mov    %edx,%eax
  801558:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80155b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155f:	75 bb                	jne    80151c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801561:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801568:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156b:	48                   	dec    %eax
  80156c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80156f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801573:	74 3d                	je     8015b2 <ltostr+0xc3>
		start = 1 ;
  801575:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80157c:	eb 34                	jmp    8015b2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80157e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	01 d0                	add    %edx,%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80158b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	01 c2                	add    %eax,%edx
  801593:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 c8                	add    %ecx,%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80159f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	01 c2                	add    %eax,%edx
  8015a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b8:	7c c4                	jl     80157e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015c5:	90                   	nop
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	e8 73 fa ff ff       	call   801049 <strlen>
  8015d6:	83 c4 04             	add    $0x4,%esp
  8015d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	e8 65 fa ff ff       	call   801049 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f8:	eb 17                	jmp    801611 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801600:	01 c2                	add    %eax,%edx
  801602:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	01 c8                	add    %ecx,%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80160e:	ff 45 fc             	incl   -0x4(%ebp)
  801611:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801614:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801617:	7c e1                	jl     8015fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801619:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801620:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801627:	eb 1f                	jmp    801648 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801629:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162c:	8d 50 01             	lea    0x1(%eax),%edx
  80162f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801632:	89 c2                	mov    %eax,%edx
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	01 c2                	add    %eax,%edx
  801639:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	01 c8                	add    %ecx,%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801645:	ff 45 f8             	incl   -0x8(%ebp)
  801648:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164e:	7c d9                	jl     801629 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801650:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801653:	8b 45 10             	mov    0x10(%ebp),%eax
  801656:	01 d0                	add    %edx,%eax
  801658:	c6 00 00             	movb   $0x0,(%eax)
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801661:	8b 45 14             	mov    0x14(%ebp),%eax
  801664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80166a:	8b 45 14             	mov    0x14(%ebp),%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	01 d0                	add    %edx,%eax
  80167b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801681:	eb 0c                	jmp    80168f <strsplit+0x31>
			*string++ = 0;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8d 50 01             	lea    0x1(%eax),%edx
  801689:	89 55 08             	mov    %edx,0x8(%ebp)
  80168c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	84 c0                	test   %al,%al
  801696:	74 18                	je     8016b0 <strsplit+0x52>
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	50                   	push   %eax
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	e8 32 fb ff ff       	call   8011db <strchr>
  8016a9:	83 c4 08             	add    $0x8,%esp
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	75 d3                	jne    801683 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	84 c0                	test   %al,%al
  8016b7:	74 5a                	je     801713 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bc:	8b 00                	mov    (%eax),%eax
  8016be:	83 f8 0f             	cmp    $0xf,%eax
  8016c1:	75 07                	jne    8016ca <strsplit+0x6c>
		{
			return 0;
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c8:	eb 66                	jmp    801730 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cd:	8b 00                	mov    (%eax),%eax
  8016cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8016d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8016d5:	89 0a                	mov    %ecx,(%edx)
  8016d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016de:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e1:	01 c2                	add    %eax,%edx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e8:	eb 03                	jmp    8016ed <strsplit+0x8f>
			string++;
  8016ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 8b                	je     801681 <strsplit+0x23>
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f be c0             	movsbl %al,%eax
  8016fe:	50                   	push   %eax
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	e8 d4 fa ff ff       	call   8011db <strchr>
  801707:	83 c4 08             	add    $0x8,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 dc                	je     8016ea <strsplit+0x8c>
			string++;
	}
  80170e:	e9 6e ff ff ff       	jmp    801681 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801713:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801714:	8b 45 14             	mov    0x14(%ebp),%eax
  801717:	8b 00                	mov    (%eax),%eax
  801719:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80172b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 08 2a 80 00       	push   $0x802a08
  801740:	68 3f 01 00 00       	push   $0x13f
  801745:	68 2a 2a 80 00       	push   $0x802a2a
  80174a:	e8 a9 ef ff ff       	call   8006f8 <_panic>

0080174f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801755:	83 ec 0c             	sub    $0xc,%esp
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 ef 06 00 00       	call   801e4f <sys_sbrk>
  801760:	83 c4 10             	add    $0x10,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80176b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80176f:	75 07                	jne    801778 <malloc+0x13>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 14                	jmp    80178c <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 38 2a 80 00       	push   $0x802a38
  801780:	6a 1b                	push   $0x1b
  801782:	68 5d 2a 80 00       	push   $0x802a5d
  801787:	e8 6c ef ff ff       	call   8006f8 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 6c 2a 80 00       	push   $0x802a6c
  80179c:	6a 29                	push   $0x29
  80179e:	68 5d 2a 80 00       	push   $0x802a5d
  8017a3:	e8 50 ef ff ff       	call   8006f8 <_panic>

008017a8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 18             	sub    $0x18,%esp
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8017b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017b8:	75 07                	jne    8017c1 <smalloc+0x19>
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bf:	eb 14                	jmp    8017d5 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	68 90 2a 80 00       	push   $0x802a90
  8017c9:	6a 38                	push   $0x38
  8017cb:	68 5d 2a 80 00       	push   $0x802a5d
  8017d0:	e8 23 ef ff ff       	call   8006f8 <_panic>
	return NULL;
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 b8 2a 80 00       	push   $0x802ab8
  8017e5:	6a 43                	push   $0x43
  8017e7:	68 5d 2a 80 00       	push   $0x802a5d
  8017ec:	e8 07 ef ff ff       	call   8006f8 <_panic>

008017f1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 dc 2a 80 00       	push   $0x802adc
  8017ff:	6a 5b                	push   $0x5b
  801801:	68 5d 2a 80 00       	push   $0x802a5d
  801806:	e8 ed ee ff ff       	call   8006f8 <_panic>

0080180b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 00 2b 80 00       	push   $0x802b00
  801819:	6a 72                	push   $0x72
  80181b:	68 5d 2a 80 00       	push   $0x802a5d
  801820:	e8 d3 ee ff ff       	call   8006f8 <_panic>

00801825 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 26 2b 80 00       	push   $0x802b26
  801833:	6a 7e                	push   $0x7e
  801835:	68 5d 2a 80 00       	push   $0x802a5d
  80183a:	e8 b9 ee ff ff       	call   8006f8 <_panic>

0080183f <shrink>:

}
void shrink(uint32 newSize)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	68 26 2b 80 00       	push   $0x802b26
  80184d:	68 83 00 00 00       	push   $0x83
  801852:	68 5d 2a 80 00       	push   $0x802a5d
  801857:	e8 9c ee ff ff       	call   8006f8 <_panic>

0080185c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	68 26 2b 80 00       	push   $0x802b26
  80186a:	68 88 00 00 00       	push   $0x88
  80186f:	68 5d 2a 80 00       	push   $0x802a5d
  801874:	e8 7f ee ff ff       	call   8006f8 <_panic>

00801879 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	57                   	push   %edi
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
  80187f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801891:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801894:	cd 30                	int    $0x30
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5f                   	pop    %edi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	e8 b2 ff ff ff       	call   801879 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 02                	push   $0x2
  8018dc:	e8 98 ff ff ff       	call   801879 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 03                	push   $0x3
  8018f5:	e8 7f ff ff ff       	call   801879 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 04                	push   $0x4
  80190f:	e8 65 ff ff ff       	call   801879 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 08                	push   $0x8
  80192d:	e8 47 ff ff ff       	call   801879 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80193c:	8b 75 18             	mov    0x18(%ebp),%esi
  80193f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801942:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801945:	8b 55 0c             	mov    0xc(%ebp),%edx
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	51                   	push   %ecx
  80194e:	52                   	push   %edx
  80194f:	50                   	push   %eax
  801950:	6a 09                	push   $0x9
  801952:	e8 22 ff ff ff       	call   801879 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5e                   	pop    %esi
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    

00801961 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 0a                	push   $0xa
  801974:	e8 00 ff ff ff       	call   801879 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 0b                	push   $0xb
  80198f:	e8 e5 fe ff ff       	call   801879 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 0c                	push   $0xc
  8019a8:	e8 cc fe ff ff       	call   801879 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 0d                	push   $0xd
  8019c1:	e8 b3 fe ff ff       	call   801879 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 0e                	push   $0xe
  8019da:	e8 9a fe ff ff       	call   801879 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 0f                	push   $0xf
  8019f3:	e8 81 fe ff ff       	call   801879 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	6a 10                	push   $0x10
  801a0d:	e8 67 fe ff ff       	call   801879 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 11                	push   $0x11
  801a26:	e8 4e fe ff ff       	call   801879 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	50                   	push   %eax
  801a4a:	6a 01                	push   $0x1
  801a4c:	e8 28 fe ff ff       	call   801879 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	90                   	nop
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 14                	push   $0x14
  801a66:	e8 0e fe ff ff       	call   801879 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a7d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a80:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	51                   	push   %ecx
  801a8a:	52                   	push   %edx
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	6a 15                	push   $0x15
  801a91:	e8 e3 fd ff ff       	call   801879 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 16                	push   $0x16
  801aae:	e8 c6 fd ff ff       	call   801879 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	51                   	push   %ecx
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 17                	push   $0x17
  801acd:	e8 a7 fd ff ff       	call   801879 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 18                	push   $0x18
  801aea:	e8 8a fd ff ff       	call   801879 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	ff 75 14             	pushl  0x14(%ebp)
  801aff:	ff 75 10             	pushl  0x10(%ebp)
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	50                   	push   %eax
  801b06:	6a 19                	push   $0x19
  801b08:	e8 6c fd ff ff       	call   801879 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	50                   	push   %eax
  801b21:	6a 1a                	push   $0x1a
  801b23:	e8 51 fd ff ff       	call   801879 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	90                   	nop
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	50                   	push   %eax
  801b3d:	6a 1b                	push   $0x1b
  801b3f:	e8 35 fd ff ff       	call   801879 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 05                	push   $0x5
  801b58:	e8 1c fd ff ff       	call   801879 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 06                	push   $0x6
  801b71:	e8 03 fd ff ff       	call   801879 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 07                	push   $0x7
  801b8a:	e8 ea fc ff ff       	call   801879 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_exit_env>:


void sys_exit_env(void)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 1c                	push   $0x1c
  801ba3:	e8 d1 fc ff ff       	call   801879 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bb4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb7:	8d 50 04             	lea    0x4(%eax),%edx
  801bba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 1d                	push   $0x1d
  801bc7:	e8 ad fc ff ff       	call   801879 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return result;
  801bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd8:	89 01                	mov    %eax,(%ecx)
  801bda:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	c9                   	leave  
  801be1:	c2 04 00             	ret    $0x4

00801be4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	ff 75 10             	pushl  0x10(%ebp)
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 13                	push   $0x13
  801bf6:	e8 7e fc ff ff       	call   801879 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 1e                	push   $0x1e
  801c10:	e8 64 fc ff ff       	call   801879 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	50                   	push   %eax
  801c33:	6a 1f                	push   $0x1f
  801c35:	e8 3f fc ff ff       	call   801879 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <rsttst>:
void rsttst()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 21                	push   $0x21
  801c4f:	e8 25 fc ff ff       	call   801879 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	8b 45 14             	mov    0x14(%ebp),%eax
  801c63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c66:	8b 55 18             	mov    0x18(%ebp),%edx
  801c69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6d:	52                   	push   %edx
  801c6e:	50                   	push   %eax
  801c6f:	ff 75 10             	pushl  0x10(%ebp)
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	6a 20                	push   $0x20
  801c7a:	e8 fa fb ff ff       	call   801879 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <chktst>:
void chktst(uint32 n)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 22                	push   $0x22
  801c95:	e8 df fb ff ff       	call   801879 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <inctst>:

void inctst()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 23                	push   $0x23
  801caf:	e8 c5 fb ff ff       	call   801879 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb7:	90                   	nop
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <gettst>:
uint32 gettst()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 24                	push   $0x24
  801cc9:	e8 ab fb ff ff       	call   801879 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 25                	push   $0x25
  801ce5:	e8 8f fb ff ff       	call   801879 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
  801ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cf0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cf4:	75 07                	jne    801cfd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	eb 05                	jmp    801d02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 25                	push   $0x25
  801d16:	e8 5e fb ff ff       	call   801879 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
  801d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d25:	75 07                	jne    801d2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2c:	eb 05                	jmp    801d33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 25                	push   $0x25
  801d47:	e8 2d fb ff ff       	call   801879 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
  801d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d56:	75 07                	jne    801d5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d58:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5d:	eb 05                	jmp    801d64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 25                	push   $0x25
  801d78:	e8 fc fa ff ff       	call   801879 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
  801d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d87:	75 07                	jne    801d90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	eb 05                	jmp    801d95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	6a 26                	push   $0x26
  801da7:	e8 cd fa ff ff       	call   801879 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
	return ;
  801daf:	90                   	nop
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801db6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	6a 00                	push   $0x0
  801dc4:	53                   	push   %ebx
  801dc5:	51                   	push   %ecx
  801dc6:	52                   	push   %edx
  801dc7:	50                   	push   %eax
  801dc8:	6a 27                	push   $0x27
  801dca:	e8 aa fa ff ff       	call   801879 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	52                   	push   %edx
  801de7:	50                   	push   %eax
  801de8:	6a 28                	push   $0x28
  801dea:	e8 8a fa ff ff       	call   801879 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801df7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	51                   	push   %ecx
  801e03:	ff 75 10             	pushl  0x10(%ebp)
  801e06:	52                   	push   %edx
  801e07:	50                   	push   %eax
  801e08:	6a 29                	push   $0x29
  801e0a:	e8 6a fa ff ff       	call   801879 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	ff 75 10             	pushl  0x10(%ebp)
  801e1e:	ff 75 0c             	pushl  0xc(%ebp)
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	6a 12                	push   $0x12
  801e26:	e8 4e fa ff ff       	call   801879 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2e:	90                   	nop
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 2a                	push   $0x2a
  801e44:	e8 30 fa ff ff       	call   801879 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
	return;
  801e4c:	90                   	nop
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	50                   	push   %eax
  801e5e:	6a 2b                	push   $0x2b
  801e60:	e8 14 fa ff ff       	call   801879 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	6a 2c                	push   $0x2c
  801e7b:	e8 f9 f9 ff ff       	call   801879 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
	return;
  801e83:	90                   	nop
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	6a 2d                	push   $0x2d
  801e97:	e8 dd f9 ff ff       	call   801879 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    
  801ea2:	66 90                	xchg   %ax,%ax

00801ea4 <__udivdi3>:
  801ea4:	55                   	push   %ebp
  801ea5:	57                   	push   %edi
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 1c             	sub    $0x1c,%esp
  801eab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eaf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ebb:	89 ca                	mov    %ecx,%edx
  801ebd:	89 f8                	mov    %edi,%eax
  801ebf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ec3:	85 f6                	test   %esi,%esi
  801ec5:	75 2d                	jne    801ef4 <__udivdi3+0x50>
  801ec7:	39 cf                	cmp    %ecx,%edi
  801ec9:	77 65                	ja     801f30 <__udivdi3+0x8c>
  801ecb:	89 fd                	mov    %edi,%ebp
  801ecd:	85 ff                	test   %edi,%edi
  801ecf:	75 0b                	jne    801edc <__udivdi3+0x38>
  801ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed6:	31 d2                	xor    %edx,%edx
  801ed8:	f7 f7                	div    %edi
  801eda:	89 c5                	mov    %eax,%ebp
  801edc:	31 d2                	xor    %edx,%edx
  801ede:	89 c8                	mov    %ecx,%eax
  801ee0:	f7 f5                	div    %ebp
  801ee2:	89 c1                	mov    %eax,%ecx
  801ee4:	89 d8                	mov    %ebx,%eax
  801ee6:	f7 f5                	div    %ebp
  801ee8:	89 cf                	mov    %ecx,%edi
  801eea:	89 fa                	mov    %edi,%edx
  801eec:	83 c4 1c             	add    $0x1c,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5f                   	pop    %edi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    
  801ef4:	39 ce                	cmp    %ecx,%esi
  801ef6:	77 28                	ja     801f20 <__udivdi3+0x7c>
  801ef8:	0f bd fe             	bsr    %esi,%edi
  801efb:	83 f7 1f             	xor    $0x1f,%edi
  801efe:	75 40                	jne    801f40 <__udivdi3+0x9c>
  801f00:	39 ce                	cmp    %ecx,%esi
  801f02:	72 0a                	jb     801f0e <__udivdi3+0x6a>
  801f04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f08:	0f 87 9e 00 00 00    	ja     801fac <__udivdi3+0x108>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	89 fa                	mov    %edi,%edx
  801f15:	83 c4 1c             	add    $0x1c,%esp
  801f18:	5b                   	pop    %ebx
  801f19:	5e                   	pop    %esi
  801f1a:	5f                   	pop    %edi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    
  801f1d:	8d 76 00             	lea    0x0(%esi),%esi
  801f20:	31 ff                	xor    %edi,%edi
  801f22:	31 c0                	xor    %eax,%eax
  801f24:	89 fa                	mov    %edi,%edx
  801f26:	83 c4 1c             	add    $0x1c,%esp
  801f29:	5b                   	pop    %ebx
  801f2a:	5e                   	pop    %esi
  801f2b:	5f                   	pop    %edi
  801f2c:	5d                   	pop    %ebp
  801f2d:	c3                   	ret    
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	89 d8                	mov    %ebx,%eax
  801f32:	f7 f7                	div    %edi
  801f34:	31 ff                	xor    %edi,%edi
  801f36:	89 fa                	mov    %edi,%edx
  801f38:	83 c4 1c             	add    $0x1c,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
  801f40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f45:	89 eb                	mov    %ebp,%ebx
  801f47:	29 fb                	sub    %edi,%ebx
  801f49:	89 f9                	mov    %edi,%ecx
  801f4b:	d3 e6                	shl    %cl,%esi
  801f4d:	89 c5                	mov    %eax,%ebp
  801f4f:	88 d9                	mov    %bl,%cl
  801f51:	d3 ed                	shr    %cl,%ebp
  801f53:	89 e9                	mov    %ebp,%ecx
  801f55:	09 f1                	or     %esi,%ecx
  801f57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f5b:	89 f9                	mov    %edi,%ecx
  801f5d:	d3 e0                	shl    %cl,%eax
  801f5f:	89 c5                	mov    %eax,%ebp
  801f61:	89 d6                	mov    %edx,%esi
  801f63:	88 d9                	mov    %bl,%cl
  801f65:	d3 ee                	shr    %cl,%esi
  801f67:	89 f9                	mov    %edi,%ecx
  801f69:	d3 e2                	shl    %cl,%edx
  801f6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f6f:	88 d9                	mov    %bl,%cl
  801f71:	d3 e8                	shr    %cl,%eax
  801f73:	09 c2                	or     %eax,%edx
  801f75:	89 d0                	mov    %edx,%eax
  801f77:	89 f2                	mov    %esi,%edx
  801f79:	f7 74 24 0c          	divl   0xc(%esp)
  801f7d:	89 d6                	mov    %edx,%esi
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	f7 e5                	mul    %ebp
  801f83:	39 d6                	cmp    %edx,%esi
  801f85:	72 19                	jb     801fa0 <__udivdi3+0xfc>
  801f87:	74 0b                	je     801f94 <__udivdi3+0xf0>
  801f89:	89 d8                	mov    %ebx,%eax
  801f8b:	31 ff                	xor    %edi,%edi
  801f8d:	e9 58 ff ff ff       	jmp    801eea <__udivdi3+0x46>
  801f92:	66 90                	xchg   %ax,%ax
  801f94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f98:	89 f9                	mov    %edi,%ecx
  801f9a:	d3 e2                	shl    %cl,%edx
  801f9c:	39 c2                	cmp    %eax,%edx
  801f9e:	73 e9                	jae    801f89 <__udivdi3+0xe5>
  801fa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fa3:	31 ff                	xor    %edi,%edi
  801fa5:	e9 40 ff ff ff       	jmp    801eea <__udivdi3+0x46>
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	31 c0                	xor    %eax,%eax
  801fae:	e9 37 ff ff ff       	jmp    801eea <__udivdi3+0x46>
  801fb3:	90                   	nop

00801fb4 <__umoddi3>:
  801fb4:	55                   	push   %ebp
  801fb5:	57                   	push   %edi
  801fb6:	56                   	push   %esi
  801fb7:	53                   	push   %ebx
  801fb8:	83 ec 1c             	sub    $0x1c,%esp
  801fbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fd3:	89 f3                	mov    %esi,%ebx
  801fd5:	89 fa                	mov    %edi,%edx
  801fd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fdb:	89 34 24             	mov    %esi,(%esp)
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 1a                	jne    801ffc <__umoddi3+0x48>
  801fe2:	39 f7                	cmp    %esi,%edi
  801fe4:	0f 86 a2 00 00 00    	jbe    80208c <__umoddi3+0xd8>
  801fea:	89 c8                	mov    %ecx,%eax
  801fec:	89 f2                	mov    %esi,%edx
  801fee:	f7 f7                	div    %edi
  801ff0:	89 d0                	mov    %edx,%eax
  801ff2:	31 d2                	xor    %edx,%edx
  801ff4:	83 c4 1c             	add    $0x1c,%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    
  801ffc:	39 f0                	cmp    %esi,%eax
  801ffe:	0f 87 ac 00 00 00    	ja     8020b0 <__umoddi3+0xfc>
  802004:	0f bd e8             	bsr    %eax,%ebp
  802007:	83 f5 1f             	xor    $0x1f,%ebp
  80200a:	0f 84 ac 00 00 00    	je     8020bc <__umoddi3+0x108>
  802010:	bf 20 00 00 00       	mov    $0x20,%edi
  802015:	29 ef                	sub    %ebp,%edi
  802017:	89 fe                	mov    %edi,%esi
  802019:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80201d:	89 e9                	mov    %ebp,%ecx
  80201f:	d3 e0                	shl    %cl,%eax
  802021:	89 d7                	mov    %edx,%edi
  802023:	89 f1                	mov    %esi,%ecx
  802025:	d3 ef                	shr    %cl,%edi
  802027:	09 c7                	or     %eax,%edi
  802029:	89 e9                	mov    %ebp,%ecx
  80202b:	d3 e2                	shl    %cl,%edx
  80202d:	89 14 24             	mov    %edx,(%esp)
  802030:	89 d8                	mov    %ebx,%eax
  802032:	d3 e0                	shl    %cl,%eax
  802034:	89 c2                	mov    %eax,%edx
  802036:	8b 44 24 08          	mov    0x8(%esp),%eax
  80203a:	d3 e0                	shl    %cl,%eax
  80203c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802040:	8b 44 24 08          	mov    0x8(%esp),%eax
  802044:	89 f1                	mov    %esi,%ecx
  802046:	d3 e8                	shr    %cl,%eax
  802048:	09 d0                	or     %edx,%eax
  80204a:	d3 eb                	shr    %cl,%ebx
  80204c:	89 da                	mov    %ebx,%edx
  80204e:	f7 f7                	div    %edi
  802050:	89 d3                	mov    %edx,%ebx
  802052:	f7 24 24             	mull   (%esp)
  802055:	89 c6                	mov    %eax,%esi
  802057:	89 d1                	mov    %edx,%ecx
  802059:	39 d3                	cmp    %edx,%ebx
  80205b:	0f 82 87 00 00 00    	jb     8020e8 <__umoddi3+0x134>
  802061:	0f 84 91 00 00 00    	je     8020f8 <__umoddi3+0x144>
  802067:	8b 54 24 04          	mov    0x4(%esp),%edx
  80206b:	29 f2                	sub    %esi,%edx
  80206d:	19 cb                	sbb    %ecx,%ebx
  80206f:	89 d8                	mov    %ebx,%eax
  802071:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802075:	d3 e0                	shl    %cl,%eax
  802077:	89 e9                	mov    %ebp,%ecx
  802079:	d3 ea                	shr    %cl,%edx
  80207b:	09 d0                	or     %edx,%eax
  80207d:	89 e9                	mov    %ebp,%ecx
  80207f:	d3 eb                	shr    %cl,%ebx
  802081:	89 da                	mov    %ebx,%edx
  802083:	83 c4 1c             	add    $0x1c,%esp
  802086:	5b                   	pop    %ebx
  802087:	5e                   	pop    %esi
  802088:	5f                   	pop    %edi
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    
  80208b:	90                   	nop
  80208c:	89 fd                	mov    %edi,%ebp
  80208e:	85 ff                	test   %edi,%edi
  802090:	75 0b                	jne    80209d <__umoddi3+0xe9>
  802092:	b8 01 00 00 00       	mov    $0x1,%eax
  802097:	31 d2                	xor    %edx,%edx
  802099:	f7 f7                	div    %edi
  80209b:	89 c5                	mov    %eax,%ebp
  80209d:	89 f0                	mov    %esi,%eax
  80209f:	31 d2                	xor    %edx,%edx
  8020a1:	f7 f5                	div    %ebp
  8020a3:	89 c8                	mov    %ecx,%eax
  8020a5:	f7 f5                	div    %ebp
  8020a7:	89 d0                	mov    %edx,%eax
  8020a9:	e9 44 ff ff ff       	jmp    801ff2 <__umoddi3+0x3e>
  8020ae:	66 90                	xchg   %ax,%ax
  8020b0:	89 c8                	mov    %ecx,%eax
  8020b2:	89 f2                	mov    %esi,%edx
  8020b4:	83 c4 1c             	add    $0x1c,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    
  8020bc:	3b 04 24             	cmp    (%esp),%eax
  8020bf:	72 06                	jb     8020c7 <__umoddi3+0x113>
  8020c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020c5:	77 0f                	ja     8020d6 <__umoddi3+0x122>
  8020c7:	89 f2                	mov    %esi,%edx
  8020c9:	29 f9                	sub    %edi,%ecx
  8020cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020cf:	89 14 24             	mov    %edx,(%esp)
  8020d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020da:	8b 14 24             	mov    (%esp),%edx
  8020dd:	83 c4 1c             	add    $0x1c,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	8d 76 00             	lea    0x0(%esi),%esi
  8020e8:	2b 04 24             	sub    (%esp),%eax
  8020eb:	19 fa                	sbb    %edi,%edx
  8020ed:	89 d1                	mov    %edx,%ecx
  8020ef:	89 c6                	mov    %eax,%esi
  8020f1:	e9 71 ff ff ff       	jmp    802067 <__umoddi3+0xb3>
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020fc:	72 ea                	jb     8020e8 <__umoddi3+0x134>
  8020fe:	89 d9                	mov    %ebx,%ecx
  802100:	e9 62 ff ff ff       	jmp    802067 <__umoddi3+0xb3>
