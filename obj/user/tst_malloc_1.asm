
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 d1 10 00 00       	call   801107 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
	char a;
	short b;
	int c;
};
int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <_main>:
void _main(void)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	53                   	push   %ebx
  80005e:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 04 50 80 00       	mov    0x805004,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 04 50 80 00       	mov    0x805004,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 60 2c 80 00       	push   $0x802c60
  800086:	6a 1f                	push   $0x1f
  800088:	68 7c 2c 80 00       	push   $0x802c7c
  80008d:	e8 ac 11 00 00       	call   80123e <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	//cprintf("2\n");
	int eval = 0;
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800099:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000a0:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  8000a7:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000ae:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	char minByte = 1<<7;
  8000b5:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
	char maxByte = 0x7F;
  8000b9:	c6 45 e2 7f          	movb   $0x7f,-0x1e(%ebp)
	short minShort = 1<<15 ;
  8000bd:	66 c7 45 e0 00 80    	movw   $0x8000,-0x20(%ebp)
	short maxShort = 0x7FFF;
  8000c3:	66 c7 45 de ff 7f    	movw   $0x7fff,-0x22(%ebp)
	int minInt = 1<<31 ;
  8000c9:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d0:	c7 45 d4 ff ff ff 7f 	movl   $0x7fffffff,-0x2c(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 03 24 00 00       	call   8024df <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 90 2c 80 00       	push   $0x802c90
  8000e7:	e8 0f 14 00 00       	call   8014fb <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 d7 23 00 00       	call   8024df <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 1a 24 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 87 21 00 00       	call   8022ab <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 f0 2c 80 00       	push   $0x802cf0
  800147:	e8 af 13 00 00       	call   8014fb <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 81 23 00 00       	call   8024df <sys_calculate_free_frames>
  80015e:	29 c3                	sub    %eax,%ebx
  800160:	89 d8                	mov    %ebx,%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800165:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800168:	83 c0 02             	add    $0x2,%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800172:	ff 75 c0             	pushl  -0x40(%ebp)
  800175:	e8 be fe ff ff       	call   800038 <inRange>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	75 21                	jne    8001a2 <_main+0x149>
			{is_correct = 0; cprintf("1 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80018b:	83 c0 02             	add    $0x2,%eax
  80018e:	ff 75 c0             	pushl  -0x40(%ebp)
  800191:	50                   	push   %eax
  800192:	ff 75 c4             	pushl  -0x3c(%ebp)
  800195:	68 24 2d 80 00       	push   $0x802d24
  80019a:	e8 5c 13 00 00       	call   8014fb <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 83 23 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 94 2d 80 00       	push   $0x802d94
  8001bb:	e8 3b 13 00 00       	call   8014fb <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 17 23 00 00       	call   8024df <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8001dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
			byteArr[0] = minByte ;
  8001e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e3:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8001e6:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  8001e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001ee:	01 c2                	add    %eax,%edx
  8001f0:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8001f3:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  8001f5:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8001ff:	e8 db 22 00 00       	call   8024df <sys_calculate_free_frames>
  800204:	29 c3                	sub    %eax,%ebx
  800206:	89 d8                	mov    %ebx,%eax
  800208:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80020b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80020e:	83 c0 02             	add    $0x2,%eax
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	50                   	push   %eax
  800215:	ff 75 c4             	pushl  -0x3c(%ebp)
  800218:	ff 75 c0             	pushl  -0x40(%ebp)
  80021b:	e8 18 fe ff ff       	call   800038 <inRange>
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	85 c0                	test   %eax,%eax
  800225:	75 1d                	jne    800244 <_main+0x1eb>
			{ is_correct = 0; cprintf("1 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	ff 75 c0             	pushl  -0x40(%ebp)
  800234:	ff 75 c4             	pushl  -0x3c(%ebp)
  800237:	68 c8 2d 80 00       	push   $0x802dc8
  80023c:	e8 ba 12 00 00       	call   8014fb <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 b7 26 00 00       	call   80293a <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 48 2e 80 00       	push   $0x802e48
  80029e:	e8 58 12 00 00       	call   8014fb <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("4\n");
		if (is_correct)
  8002a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002aa:	74 04                	je     8002b0 <_main+0x257>
		{
			eval += 10;
  8002ac:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8002b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002b7:	e8 23 22 00 00       	call   8024df <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 66 22 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  8002c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	50                   	push   %eax
  8002d3:	e8 d3 1f 00 00       	call   8022ab <malloc>
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002e1:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	89 c1                	mov    %eax,%ecx
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	01 c8                	add    %ecx,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 17                	je     800310 <_main+0x2b7>
  8002f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 6c 2e 80 00       	push   $0x802e6c
  800308:	e8 ee 11 00 00       	call   8014fb <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 c0 21 00 00       	call   8024df <sys_calculate_free_frames>
  80031f:	29 c3                	sub    %eax,%ebx
  800321:	89 d8                	mov    %ebx,%eax
  800323:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800326:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800329:	83 c0 02             	add    $0x2,%eax
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	ff 75 c4             	pushl  -0x3c(%ebp)
  800333:	ff 75 c0             	pushl  -0x40(%ebp)
  800336:	e8 fd fc ff ff       	call   800038 <inRange>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 21                	jne    800363 <_main+0x30a>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80034c:	83 c0 02             	add    $0x2,%eax
  80034f:	ff 75 c0             	pushl  -0x40(%ebp)
  800352:	50                   	push   %eax
  800353:	ff 75 c4             	pushl  -0x3c(%ebp)
  800356:	68 a0 2e 80 00       	push   $0x802ea0
  80035b:	e8 9b 11 00 00       	call   8014fb <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 c2 21 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 10 2f 80 00       	push   $0x802f10
  80037c:	e8 7a 11 00 00       	call   8014fb <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 56 21 00 00       	call   8024df <sys_calculate_free_frames>
  800389:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80038c:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800392:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80039d:	d1 e8                	shr    %eax
  80039f:	48                   	dec    %eax
  8003a0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  8003a3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8003ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003b6:	01 c2                	add    %eax,%edx
  8003b8:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003bc:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003bf:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003c9:	e8 11 21 00 00       	call   8024df <sys_calculate_free_frames>
  8003ce:	29 c3                	sub    %eax,%ebx
  8003d0:	89 d8                	mov    %ebx,%eax
  8003d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d8:	83 c0 02             	add    $0x2,%eax
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	50                   	push   %eax
  8003df:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e2:	ff 75 c0             	pushl  -0x40(%ebp)
  8003e5:	e8 4e fc ff ff       	call   800038 <inRange>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	75 1d                	jne    80040e <_main+0x3b5>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8003fe:	ff 75 c4             	pushl  -0x3c(%ebp)
  800401:	68 44 2f 80 00       	push   $0x802f44
  800406:	e8 f0 10 00 00       	call   8014fb <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  80040e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800411:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800414:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800422:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800431:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80043f:	6a 02                	push   $0x2
  800441:	6a 00                	push   $0x0
  800443:	6a 02                	push   $0x2
  800445:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80044b:	50                   	push   %eax
  80044c:	e8 e9 24 00 00       	call   80293a <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 c4 2f 80 00       	push   $0x802fc4
  80046c:	e8 8a 10 00 00       	call   8014fb <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("5\n");
		if (is_correct)
  800474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800478:	74 04                	je     80047e <_main+0x425>
		{
			eval += 10;
  80047a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80047e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800485:	e8 a0 20 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  80048a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	89 c2                	mov    %eax,%edx
  800492:	01 d2                	add    %edx,%edx
  800494:	01 d0                	add    %edx,%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 0c 1e 00 00       	call   8022ab <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  8004a8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b3:	c1 e0 02             	shl    $0x2,%eax
  8004b6:	89 c1                	mov    %eax,%ecx
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x47f>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 e8 2f 80 00       	push   $0x802fe8
  8004d0:	e8 26 10 00 00       	call   8014fb <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 f8 1f 00 00       	call   8024df <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f1:	83 c0 02             	add    $0x2,%eax
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	50                   	push   %eax
  8004f8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004fe:	e8 35 fb ff ff       	call   800038 <inRange>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	85 c0                	test   %eax,%eax
  800508:	75 21                	jne    80052b <_main+0x4d2>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80050a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800511:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800514:	83 c0 02             	add    $0x2,%eax
  800517:	ff 75 c0             	pushl  -0x40(%ebp)
  80051a:	50                   	push   %eax
  80051b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051e:	68 1c 30 80 00       	push   $0x80301c
  800523:	e8 d3 0f 00 00       	call   8014fb <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 fa 1f 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 8c 30 80 00       	push   $0x80308c
  800544:	e8 b2 0f 00 00       	call   8014fb <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 8e 1f 00 00       	call   8024df <sys_calculate_free_frames>
  800551:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800554:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80055a:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80055d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	c1 e8 02             	shr    $0x2,%eax
  800565:	48                   	dec    %eax
  800566:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800569:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056f:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  800571:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80057e:	01 c2                	add    %eax,%edx
  800580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800583:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800585:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80058c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80058f:	e8 4b 1f 00 00       	call   8024df <sys_calculate_free_frames>
  800594:	29 c3                	sub    %eax,%ebx
  800596:	89 d8                	mov    %ebx,%eax
  800598:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80059b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059e:	83 c0 02             	add    $0x2,%eax
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a8:	ff 75 c0             	pushl  -0x40(%ebp)
  8005ab:	e8 88 fa ff ff       	call   800038 <inRange>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	75 1d                	jne    8005d4 <_main+0x57b>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8005b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	ff 75 c0             	pushl  -0x40(%ebp)
  8005c4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005c7:	68 c0 30 80 00       	push   $0x8030c0
  8005cc:	e8 2a 0f 00 00       	call   8014fb <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005d4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d7:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005da:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e2:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8005e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005fa:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800602:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800608:	6a 02                	push   $0x2
  80060a:	6a 00                	push   $0x0
  80060c:	6a 02                	push   $0x2
  80060e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	e8 20 23 00 00       	call   80293a <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 40 31 80 00       	push   $0x803140
  800635:	e8 c1 0e 00 00       	call   8014fb <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 e8 1e 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800648:	89 c2                	mov    %eax,%edx
  80064a:	01 d2                	add    %edx,%edx
  80064c:	01 d0                	add    %edx,%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 54 1c 00 00       	call   8022ab <malloc>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  800660:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066b:	c1 e0 02             	shl    $0x2,%eax
  80066e:	89 c1                	mov    %eax,%ecx
  800670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	01 c1                	add    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x63f>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 64 31 80 00       	push   $0x803164
  800690:	e8 66 0e 00 00       	call   8014fb <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 8d 1e 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 98 31 80 00       	push   $0x803198
  8006b1:	e8 45 0e 00 00       	call   8014fb <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x66a>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 10 1e 00 00       	call   8024df <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 53 1e 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d0                	add    %edx,%eax
  8006e3:	01 c0                	add    %eax,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 bb 1b 00 00       	call   8022ab <malloc>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006f9:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8006ff:	89 c2                	mov    %eax,%edx
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800704:	c1 e0 02             	shl    $0x2,%eax
  800707:	89 c1                	mov    %eax,%ecx
  800709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80070c:	c1 e0 03             	shl    $0x3,%eax
  80070f:	01 c1                	add    %eax,%ecx
  800711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	39 c2                	cmp    %eax,%edx
  800718:	74 17                	je     800731 <_main+0x6d8>
  80071a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	68 cc 31 80 00       	push   $0x8031cc
  800729:	e8 cd 0d 00 00       	call   8014fb <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 9f 1d 00 00       	call   8024df <sys_calculate_free_frames>
  800740:	29 c3                	sub    %eax,%ebx
  800742:	89 d8                	mov    %ebx,%eax
  800744:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80074a:	83 c0 02             	add    $0x2,%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	50                   	push   %eax
  800751:	ff 75 c4             	pushl  -0x3c(%ebp)
  800754:	ff 75 c0             	pushl  -0x40(%ebp)
  800757:	e8 dc f8 ff ff       	call   800038 <inRange>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 21                	jne    800784 <_main+0x72b>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80076d:	83 c0 02             	add    $0x2,%eax
  800770:	ff 75 c0             	pushl  -0x40(%ebp)
  800773:	50                   	push   %eax
  800774:	ff 75 c4             	pushl  -0x3c(%ebp)
  800777:	68 00 32 80 00       	push   $0x803200
  80077c:	e8 7a 0d 00 00       	call   8014fb <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 a1 1d 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 70 32 80 00       	push   $0x803270
  80079d:	e8 59 0d 00 00       	call   8014fb <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 35 1d 00 00       	call   8024df <sys_calculate_free_frames>
  8007aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  8007ad:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8007b3:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8007b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b9:	89 d0                	mov    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	01 c0                	add    %eax,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	c1 e8 03             	shr    $0x3,%eax
  8007c6:	48                   	dec    %eax
  8007c7:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8007ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007cd:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8007d0:	88 10                	mov    %dl,(%eax)
  8007d2:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e2:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007e5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007ef:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007f2:	01 c2                	add    %eax,%edx
  8007f4:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007f7:	88 02                	mov    %al,(%edx)
  8007f9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800803:	8b 45 88             	mov    -0x78(%ebp),%eax
  800806:	01 c2                	add    %eax,%edx
  800808:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  80080c:	66 89 42 02          	mov    %ax,0x2(%edx)
  800810:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800813:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80081a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80081d:	01 c2                	add    %eax,%edx
  80081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800822:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800825:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80082c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80082f:	e8 ab 1c 00 00       	call   8024df <sys_calculate_free_frames>
  800834:	29 c3                	sub    %eax,%ebx
  800836:	89 d8                	mov    %ebx,%eax
  800838:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80083b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083e:	83 c0 02             	add    $0x2,%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	50                   	push   %eax
  800845:	ff 75 c4             	pushl  -0x3c(%ebp)
  800848:	ff 75 c0             	pushl  -0x40(%ebp)
  80084b:	e8 e8 f7 ff ff       	call   800038 <inRange>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 c0                	test   %eax,%eax
  800855:	75 1d                	jne    800874 <_main+0x81b>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800857:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 c0             	pushl  -0x40(%ebp)
  800864:	ff 75 c4             	pushl  -0x3c(%ebp)
  800867:	68 a4 32 80 00       	push   $0x8032a4
  80086c:	e8 8a 0c 00 00       	call   8014fb <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800874:	8b 45 88             	mov    -0x78(%ebp),%eax
  800877:	89 45 80             	mov    %eax,-0x80(%ebp)
  80087a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80087d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800882:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800888:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80088b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800892:	8b 45 88             	mov    -0x78(%ebp),%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80089d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8008ae:	6a 02                	push   $0x2
  8008b0:	6a 00                	push   $0x0
  8008b2:	6a 02                	push   $0x2
  8008b4:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	e8 7a 20 00 00       	call   80293a <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 24 33 80 00       	push   $0x803324
  8008db:	e8 1b 0c 00 00       	call   8014fb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8008e7:	74 04                	je     8008ed <_main+0x894>
		{
			eval += 10;
  8008e9:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8008ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008f4:	e8 e6 1b 00 00       	call   8024df <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 29 1c 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800907:	89 c2                	mov    %eax,%edx
  800909:	01 d2                	add    %edx,%edx
  80090b:	01 d0                	add    %edx,%eax
  80090d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	50                   	push   %eax
  800914:	e8 92 19 00 00       	call   8022ab <malloc>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  800922:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800928:	89 c2                	mov    %eax,%edx
  80092a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092d:	c1 e0 02             	shl    $0x2,%eax
  800930:	89 c1                	mov    %eax,%ecx
  800932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800935:	c1 e0 04             	shl    $0x4,%eax
  800938:	01 c1                	add    %eax,%ecx
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	01 c8                	add    %ecx,%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 17                	je     80095a <_main+0x901>
  800943:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	68 48 33 80 00       	push   $0x803348
  800952:	e8 a4 0b 00 00       	call   8014fb <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 76 1b 00 00       	call   8024df <sys_calculate_free_frames>
  800969:	29 c3                	sub    %eax,%ebx
  80096b:	89 d8                	mov    %ebx,%eax
  80096d:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800970:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800973:	83 c0 02             	add    $0x2,%eax
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	50                   	push   %eax
  80097a:	ff 75 c4             	pushl  -0x3c(%ebp)
  80097d:	ff 75 c0             	pushl  -0x40(%ebp)
  800980:	e8 b3 f6 ff ff       	call   800038 <inRange>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	75 21                	jne    8009ad <_main+0x954>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80098c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800996:	83 c0 02             	add    $0x2,%eax
  800999:	ff 75 c0             	pushl  -0x40(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 c4             	pushl  -0x3c(%ebp)
  8009a0:	68 7c 33 80 00       	push   $0x80337c
  8009a5:	e8 51 0b 00 00       	call   8014fb <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 78 1b 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 ec 33 80 00       	push   $0x8033ec
  8009c6:	e8 30 0b 00 00       	call   8014fb <cprintf>
  8009cb:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8009ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d2:	74 04                	je     8009d8 <_main+0x97f>
		{
			eval += 10;
  8009d4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8009d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009df:	e8 fb 1a 00 00       	call   8024df <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 3e 1b 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  8009ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8009ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	50                   	push   %eax
  800a01:	e8 a5 18 00 00       	call   8022ab <malloc>
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  800a0f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800a15:	89 c1                	mov    %eax,%ecx
  800a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	01 c0                	add    %eax,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a29:	c1 e0 04             	shl    $0x4,%eax
  800a2c:	01 c2                	add    %eax,%edx
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	39 c1                	cmp    %eax,%ecx
  800a35:	74 17                	je     800a4e <_main+0x9f5>
  800a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	68 20 34 80 00       	push   $0x803420
  800a46:	e8 b0 0a 00 00       	call   8014fb <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 82 1a 00 00       	call   8024df <sys_calculate_free_frames>
  800a5d:	29 c3                	sub    %eax,%ebx
  800a5f:	89 d8                	mov    %ebx,%eax
  800a61:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a67:	83 c0 02             	add    $0x2,%eax
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a71:	ff 75 c0             	pushl  -0x40(%ebp)
  800a74:	e8 bf f5 ff ff       	call   800038 <inRange>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 21                	jne    800aa1 <_main+0xa48>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a8a:	83 c0 02             	add    $0x2,%eax
  800a8d:	ff 75 c0             	pushl  -0x40(%ebp)
  800a90:	50                   	push   %eax
  800a91:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a94:	68 54 34 80 00       	push   $0x803454
  800a99:	e8 5d 0a 00 00       	call   8014fb <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 84 1a 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 c4 34 80 00       	push   $0x8034c4
  800aba:	e8 3c 0a 00 00       	call   8014fb <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 18 1a 00 00       	call   8024df <sys_calculate_free_frames>
  800ac7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800aca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800acd:	89 d0                	mov    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	01 d0                	add    %edx,%eax
  800ad3:	01 c0                	add    %eax,%eax
  800ad5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ad8:	48                   	dec    %eax
  800ad9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800adf:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ae5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800aeb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800af1:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800af4:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800af6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	c1 ea 1f             	shr    $0x1f,%edx
  800b01:	01 d0                	add    %edx,%eax
  800b03:	d1 f8                	sar    %eax
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b0d:	01 c2                	add    %eax,%edx
  800b0f:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b12:	88 c1                	mov    %al,%cl
  800b14:	c0 e9 07             	shr    $0x7,%cl
  800b17:	01 c8                	add    %ecx,%eax
  800b19:	d0 f8                	sar    %al
  800b1b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800b1d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b23:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b29:	01 c2                	add    %eax,%edx
  800b2b:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b2e:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800b30:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b37:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b3a:	e8 a0 19 00 00       	call   8024df <sys_calculate_free_frames>
  800b3f:	29 c3                	sub    %eax,%ebx
  800b41:	89 d8                	mov    %ebx,%eax
  800b43:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b49:	83 c0 02             	add    $0x2,%eax
  800b4c:	83 ec 04             	sub    $0x4,%esp
  800b4f:	50                   	push   %eax
  800b50:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b53:	ff 75 c0             	pushl  -0x40(%ebp)
  800b56:	e8 dd f4 ff ff       	call   800038 <inRange>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 1d                	jne    800b7f <_main+0xb26>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	ff 75 c0             	pushl  -0x40(%ebp)
  800b6f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b72:	68 f8 34 80 00       	push   $0x8034f8
  800b77:	e8 7f 09 00 00       	call   8014fb <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b7f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b85:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b8b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800b9c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800ba2:	89 c2                	mov    %eax,%edx
  800ba4:	c1 ea 1f             	shr    $0x1f,%edx
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	d1 f8                	sar    %eax
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
  800bb5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800bbb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  800bcc:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800bd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800be0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800beb:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf1:	6a 02                	push   $0x2
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 03                	push   $0x3
  800bf7:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	e8 37 1d 00 00       	call   80293a <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 78 35 80 00       	push   $0x803578
  800c1e:	e8 d8 08 00 00       	call   8014fb <cprintf>
  800c23:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c2a:	74 04                	je     800c30 <_main+0xbd7>
		{
			eval += 10;
  800c2c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800c30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800c37:	e8 a3 18 00 00       	call   8024df <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 e6 18 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c4a:	89 d0                	mov    %edx,%eax
  800c4c:	01 c0                	add    %eax,%eax
  800c4e:	01 d0                	add    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	e8 4c 16 00 00       	call   8022ab <malloc>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c68:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c6e:	89 c1                	mov    %eax,%ecx
  800c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c73:	89 d0                	mov    %edx,%eax
  800c75:	01 c0                	add    %eax,%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	c1 e0 02             	shl    $0x2,%eax
  800c7c:	01 d0                	add    %edx,%eax
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c83:	c1 e0 04             	shl    $0x4,%eax
  800c86:	01 c2                	add    %eax,%edx
  800c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	39 c1                	cmp    %eax,%ecx
  800c8f:	74 17                	je     800ca8 <_main+0xc4f>
  800c91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	68 9c 35 80 00       	push   $0x80359c
  800ca0:	e8 56 08 00 00       	call   8014fb <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 28 18 00 00       	call   8024df <sys_calculate_free_frames>
  800cb7:	29 c3                	sub    %eax,%ebx
  800cb9:	89 d8                	mov    %ebx,%eax
  800cbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800cbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800cc1:	83 c0 02             	add    $0x2,%eax
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	50                   	push   %eax
  800cc8:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ccb:	ff 75 c0             	pushl  -0x40(%ebp)
  800cce:	e8 65 f3 ff ff       	call   800038 <inRange>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	75 21                	jne    800cfb <_main+0xca2>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ce4:	83 c0 02             	add    $0x2,%eax
  800ce7:	ff 75 c0             	pushl  -0x40(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800cee:	68 d0 35 80 00       	push   $0x8035d0
  800cf3:	e8 03 08 00 00       	call   8014fb <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 2a 18 00 00       	call   80252a <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 40 36 80 00       	push   $0x803640
  800d14:	e8 e2 07 00 00       	call   8014fb <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 be 17 00 00       	call   8024df <sys_calculate_free_frames>
  800d21:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800d24:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800d2a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d33:	89 d0                	mov    %edx,%eax
  800d35:	01 c0                	add    %eax,%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	d1 e8                	shr    %eax
  800d41:	48                   	dec    %eax
  800d42:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800d48:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d51:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800d54:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	c1 ea 1f             	shr    $0x1f,%edx
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	d1 f8                	sar    %eax
  800d63:	01 c0                	add    %eax,%eax
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d70:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	66 c1 ea 0f          	shr    $0xf,%dx
  800d7a:	01 d0                	add    %edx,%eax
  800d7c:	66 d1 f8             	sar    %ax
  800d7f:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d82:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d88:	01 c0                	add    %eax,%eax
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d92:	01 c2                	add    %eax,%edx
  800d94:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d98:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d9b:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800da2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800da5:	e8 35 17 00 00       	call   8024df <sys_calculate_free_frames>
  800daa:	29 c3                	sub    %eax,%ebx
  800dac:	89 d8                	mov    %ebx,%eax
  800dae:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800db4:	83 c0 02             	add    $0x2,%eax
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	50                   	push   %eax
  800dbb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800dbe:	ff 75 c0             	pushl  -0x40(%ebp)
  800dc1:	e8 72 f2 ff ff       	call   800038 <inRange>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 1d                	jne    800dea <_main+0xd91>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800dcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	ff 75 c0             	pushl  -0x40(%ebp)
  800dda:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ddd:	68 74 36 80 00       	push   $0x803674
  800de2:	e8 14 07 00 00       	call   8014fb <cprintf>
  800de7:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800dea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800df0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800df6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  800e07:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 1f             	shr    $0x1f,%edx
  800e12:	01 d0                	add    %edx,%eax
  800e14:	d1 f8                	sar    %eax
  800e16:	01 c0                	add    %eax,%eax
  800e18:	89 c2                	mov    %eax,%edx
  800e1a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800e28:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800e2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e33:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  800e39:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e3f:	01 c0                	add    %eax,%eax
  800e41:	89 c2                	mov    %eax,%edx
  800e43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800e51:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800e62:	6a 02                	push   $0x2
  800e64:	6a 00                	push   $0x0
  800e66:	6a 03                	push   $0x3
  800e68:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800e6e:	50                   	push   %eax
  800e6f:	e8 c6 1a 00 00       	call   80293a <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 f4 36 80 00       	push   $0x8036f4
  800e8f:	e8 67 06 00 00       	call   8014fb <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct)
  800e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9b:	74 04                	je     800ea1 <_main+0xe48>
	{
		eval += 10;
  800e9d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  800ea1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Check that the values are successfully stored
	cprintf("\n%~[2] Check that the values are successfully stored [30%]\n");
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	68 18 37 80 00       	push   $0x803718
  800eb0:	e8 46 06 00 00       	call   8014fb <cprintf>
  800eb5:	83 c4 10             	add    $0x10,%esp
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) { is_correct = 0; cprintf("9 Wrong allocation: stored values are wrongly changed!\n");}
  800eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800ec0:	75 0f                	jne    800ed1 <_main+0xe78>
  800ec2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	01 d0                	add    %edx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800ecf:	74 17                	je     800ee8 <_main+0xe8f>
  800ed1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	68 54 37 80 00       	push   $0x803754
  800ee0:	e8 16 06 00 00       	call   8014fb <cprintf>
  800ee5:	83 c4 10             	add    $0x10,%esp
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) { is_correct = 0; cprintf("10 Wrong allocation: stored values are wrongly changed!\n");}
  800ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800eeb:	66 8b 00             	mov    (%eax),%ax
  800eee:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800ef2:	75 15                	jne    800f09 <_main+0xeb0>
  800ef4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	66 8b 00             	mov    (%eax),%ax
  800f03:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800f07:	74 17                	je     800f20 <_main+0xec7>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	68 8c 37 80 00       	push   $0x80378c
  800f18:	e8 de 05 00 00       	call   8014fb <cprintf>
  800f1d:	83 c4 10             	add    $0x10,%esp
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) { is_correct = 0; cprintf("11 Wrong allocation: stored values are wrongly changed!\n");}
  800f20:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f28:	75 16                	jne    800f40 <_main+0xee7>
  800f2a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f34:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f3e:	74 17                	je     800f57 <_main+0xefe>
  800f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	68 c8 37 80 00       	push   $0x8037c8
  800f4f:	e8 a7 05 00 00       	call   8014fb <cprintf>
  800f54:	83 c4 10             	add    $0x10,%esp

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	{ is_correct = 0; cprintf("12 Wrong allocation: stored values are wrongly changed!\n");}
  800f57:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800f5f:	75 16                	jne    800f77 <_main+0xf1e>
  800f61:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f64:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800f75:	74 17                	je     800f8e <_main+0xf35>
  800f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 04 38 80 00       	push   $0x803804
  800f86:	e8 70 05 00 00       	call   8014fb <cprintf>
  800f8b:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	{ is_correct = 0; cprintf("13 Wrong allocation: stored values are wrongly changed!\n");}
  800f8e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f91:	66 8b 40 02          	mov    0x2(%eax),%ax
  800f95:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800f99:	75 19                	jne    800fb4 <_main+0xf5b>
  800f9b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fa5:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	66 8b 40 02          	mov    0x2(%eax),%ax
  800fae:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800fb2:	74 17                	je     800fcb <_main+0xf72>
  800fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 40 38 80 00       	push   $0x803840
  800fc3:	e8 33 05 00 00       	call   8014fb <cprintf>
  800fc8:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	{ is_correct = 0; cprintf("14 Wrong allocation: stored values are wrongly changed!\n");}
  800fcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fce:	8b 40 04             	mov    0x4(%eax),%eax
  800fd1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800fd4:	75 17                	jne    800fed <_main+0xf94>
  800fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800fd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fe0:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	8b 40 04             	mov    0x4(%eax),%eax
  800fe8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800feb:	74 17                	je     801004 <_main+0xfab>
  800fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	68 7c 38 80 00       	push   $0x80387c
  800ffc:	e8 fa 04 00 00       	call   8014fb <cprintf>
  801001:	83 c4 10             	add    $0x10,%esp

		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) { is_correct = 0; cprintf("15 Wrong allocation: stored values are wrongly changed!\n");}
  801004:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  80100f:	75 40                	jne    801051 <_main+0xff8>
  801011:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 1f             	shr    $0x1f,%edx
  80101c:	01 d0                	add    %edx,%eax
  80101e:	d1 f8                	sar    %eax
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	8a 10                	mov    (%eax),%dl
  80102c:	8a 45 e2             	mov    -0x1e(%ebp),%al
  80102f:	88 c1                	mov    %al,%cl
  801031:	c0 e9 07             	shr    $0x7,%cl
  801034:	01 c8                	add    %ecx,%eax
  801036:	d0 f8                	sar    %al
  801038:	38 c2                	cmp    %al,%dl
  80103a:	75 15                	jne    801051 <_main+0xff8>
  80103c:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801042:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  80104f:	74 17                	je     801068 <_main+0x100f>
  801051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801058:	83 ec 0c             	sub    $0xc,%esp
  80105b:	68 b8 38 80 00       	push   $0x8038b8
  801060:	e8 96 04 00 00       	call   8014fb <cprintf>
  801065:	83 c4 10             	add    $0x10,%esp
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) { is_correct = 0; cprintf("16 Wrong allocation: stored values are wrongly changed!\n");}
  801068:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80106e:	66 8b 00             	mov    (%eax),%ax
  801071:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  801075:	75 4d                	jne    8010c4 <_main+0x106b>
  801077:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	c1 ea 1f             	shr    $0x1f,%edx
  801082:	01 d0                	add    %edx,%eax
  801084:	d1 f8                	sar    %eax
  801086:	01 c0                	add    %eax,%eax
  801088:	89 c2                	mov    %eax,%edx
  80108a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	66 8b 10             	mov    (%eax),%dx
  801095:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  801099:	89 c1                	mov    %eax,%ecx
  80109b:	66 c1 e9 0f          	shr    $0xf,%cx
  80109f:	01 c8                	add    %ecx,%eax
  8010a1:	66 d1 f8             	sar    %ax
  8010a4:	66 39 c2             	cmp    %ax,%dx
  8010a7:	75 1b                	jne    8010c4 <_main+0x106b>
  8010a9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	66 8b 00             	mov    (%eax),%ax
  8010be:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  8010c2:	74 17                	je     8010db <_main+0x1082>
  8010c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	68 f4 38 80 00       	push   $0x8038f4
  8010d3:	e8 23 04 00 00       	call   8014fb <cprintf>
  8010d8:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  8010db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010df:	74 04                	je     8010e5 <_main+0x108c>
	{
		eval += 30;
  8010e1:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}

	is_correct = 1;
  8010e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f2:	68 30 39 80 00       	push   $0x803930
  8010f7:	e8 ff 03 00 00       	call   8014fb <cprintf>
  8010fc:	83 c4 10             	add    $0x10,%esp

	return;
  8010ff:	90                   	nop
}
  801100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80110d:	e8 96 15 00 00       	call   8026a8 <sys_getenvindex>
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801118:	89 d0                	mov    %edx,%eax
  80111a:	c1 e0 02             	shl    $0x2,%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	01 c0                	add    %eax,%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	c1 e0 02             	shl    $0x2,%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	01 c0                	add    %eax,%eax
  80112a:	01 d0                	add    %edx,%eax
  80112c:	c1 e0 04             	shl    $0x4,%eax
  80112f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801134:	a3 04 50 80 00       	mov    %eax,0x805004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801139:	a1 04 50 80 00       	mov    0x805004,%eax
  80113e:	8a 40 20             	mov    0x20(%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	74 0d                	je     801152 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  801145:	a1 04 50 80 00       	mov    0x805004,%eax
  80114a:	83 c0 20             	add    $0x20,%eax
  80114d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801156:	7e 0a                	jle    801162 <libmain+0x5b>
		binaryname = argv[0];
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 00                	mov    (%eax),%eax
  80115d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	ff 75 0c             	pushl  0xc(%ebp)
  801168:	ff 75 08             	pushl  0x8(%ebp)
  80116b:	e8 e9 ee ff ff       	call   800059 <_main>
  801170:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  801173:	e8 b4 12 00 00       	call   80242c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  801178:	83 ec 0c             	sub    $0xc,%esp
  80117b:	68 84 39 80 00       	push   $0x803984
  801180:	e8 76 03 00 00       	call   8014fb <cprintf>
  801185:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801188:	a1 04 50 80 00       	mov    0x805004,%eax
  80118d:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801193:	a1 04 50 80 00       	mov    0x805004,%eax
  801198:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	52                   	push   %edx
  8011a2:	50                   	push   %eax
  8011a3:	68 ac 39 80 00       	push   $0x8039ac
  8011a8:	e8 4e 03 00 00       	call   8014fb <cprintf>
  8011ad:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8011b0:	a1 04 50 80 00       	mov    0x805004,%eax
  8011b5:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8011bb:	a1 04 50 80 00       	mov    0x805004,%eax
  8011c0:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8011c6:	a1 04 50 80 00       	mov    0x805004,%eax
  8011cb:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8011d1:	51                   	push   %ecx
  8011d2:	52                   	push   %edx
  8011d3:	50                   	push   %eax
  8011d4:	68 d4 39 80 00       	push   $0x8039d4
  8011d9:	e8 1d 03 00 00       	call   8014fb <cprintf>
  8011de:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8011e1:	a1 04 50 80 00       	mov    0x805004,%eax
  8011e6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	50                   	push   %eax
  8011f0:	68 2c 3a 80 00       	push   $0x803a2c
  8011f5:	e8 01 03 00 00       	call   8014fb <cprintf>
  8011fa:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8011fd:	83 ec 0c             	sub    $0xc,%esp
  801200:	68 84 39 80 00       	push   $0x803984
  801205:	e8 f1 02 00 00       	call   8014fb <cprintf>
  80120a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80120d:	e8 34 12 00 00       	call   802446 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  801212:	e8 19 00 00 00       	call   801230 <exit>
}
  801217:	90                   	nop
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	6a 00                	push   $0x0
  801225:	e8 4a 14 00 00       	call   802674 <sys_destroy_env>
  80122a:	83 c4 10             	add    $0x10,%esp
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <exit>:

void
exit(void)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801236:	e8 9f 14 00 00       	call   8026da <sys_exit_env>
}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801244:	8d 45 10             	lea    0x10(%ebp),%eax
  801247:	83 c0 04             	add    $0x4,%eax
  80124a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80124d:	a1 24 50 80 00       	mov    0x805024,%eax
  801252:	85 c0                	test   %eax,%eax
  801254:	74 16                	je     80126c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801256:	a1 24 50 80 00       	mov    0x805024,%eax
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	50                   	push   %eax
  80125f:	68 40 3a 80 00       	push   $0x803a40
  801264:	e8 92 02 00 00       	call   8014fb <cprintf>
  801269:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80126c:	a1 00 50 80 00       	mov    0x805000,%eax
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	ff 75 08             	pushl  0x8(%ebp)
  801277:	50                   	push   %eax
  801278:	68 45 3a 80 00       	push   $0x803a45
  80127d:	e8 79 02 00 00       	call   8014fb <cprintf>
  801282:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	ff 75 f4             	pushl  -0xc(%ebp)
  80128e:	50                   	push   %eax
  80128f:	e8 fc 01 00 00       	call   801490 <vcprintf>
  801294:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801297:	83 ec 08             	sub    $0x8,%esp
  80129a:	6a 00                	push   $0x0
  80129c:	68 61 3a 80 00       	push   $0x803a61
  8012a1:	e8 ea 01 00 00       	call   801490 <vcprintf>
  8012a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8012a9:	e8 82 ff ff ff       	call   801230 <exit>

	// should not return here
	while (1) ;
  8012ae:	eb fe                	jmp    8012ae <_panic+0x70>

008012b0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8012b6:	a1 04 50 80 00       	mov    0x805004,%eax
  8012bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 14                	je     8012dc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	68 64 3a 80 00       	push   $0x803a64
  8012d0:	6a 26                	push   $0x26
  8012d2:	68 b0 3a 80 00       	push   $0x803ab0
  8012d7:	e8 62 ff ff ff       	call   80123e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8012dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8012e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012ea:	e9 c5 00 00 00       	jmp    8013b4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8012ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	8b 00                	mov    (%eax),%eax
  801300:	85 c0                	test   %eax,%eax
  801302:	75 08                	jne    80130c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801304:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801307:	e9 a5 00 00 00       	jmp    8013b1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80130c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801313:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80131a:	eb 69                	jmp    801385 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80131c:	a1 04 50 80 00       	mov    0x805004,%eax
  801321:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801327:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80132a:	89 d0                	mov    %edx,%eax
  80132c:	01 c0                	add    %eax,%eax
  80132e:	01 d0                	add    %edx,%eax
  801330:	c1 e0 03             	shl    $0x3,%eax
  801333:	01 c8                	add    %ecx,%eax
  801335:	8a 40 04             	mov    0x4(%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 46                	jne    801382 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80133c:	a1 04 50 80 00       	mov    0x805004,%eax
  801341:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801347:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80134a:	89 d0                	mov    %edx,%eax
  80134c:	01 c0                	add    %eax,%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	c1 e0 03             	shl    $0x3,%eax
  801353:	01 c8                	add    %ecx,%eax
  801355:	8b 00                	mov    (%eax),%eax
  801357:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80135a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80135d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801362:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	01 c8                	add    %ecx,%eax
  801373:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801375:	39 c2                	cmp    %eax,%edx
  801377:	75 09                	jne    801382 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801379:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801380:	eb 15                	jmp    801397 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801382:	ff 45 e8             	incl   -0x18(%ebp)
  801385:	a1 04 50 80 00       	mov    0x805004,%eax
  80138a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801393:	39 c2                	cmp    %eax,%edx
  801395:	77 85                	ja     80131c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801397:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80139b:	75 14                	jne    8013b1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	68 bc 3a 80 00       	push   $0x803abc
  8013a5:	6a 3a                	push   $0x3a
  8013a7:	68 b0 3a 80 00       	push   $0x803ab0
  8013ac:	e8 8d fe ff ff       	call   80123e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8013b1:	ff 45 f0             	incl   -0x10(%ebp)
  8013b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8013ba:	0f 8c 2f ff ff ff    	jl     8012ef <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8013c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013ce:	eb 26                	jmp    8013f6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8013d0:	a1 04 50 80 00       	mov    0x805004,%eax
  8013d5:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8013db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013de:	89 d0                	mov    %edx,%eax
  8013e0:	01 c0                	add    %eax,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	c1 e0 03             	shl    $0x3,%eax
  8013e7:	01 c8                	add    %ecx,%eax
  8013e9:	8a 40 04             	mov    0x4(%eax),%al
  8013ec:	3c 01                	cmp    $0x1,%al
  8013ee:	75 03                	jne    8013f3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8013f0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013f3:	ff 45 e0             	incl   -0x20(%ebp)
  8013f6:	a1 04 50 80 00       	mov    0x805004,%eax
  8013fb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801401:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801404:	39 c2                	cmp    %eax,%edx
  801406:	77 c8                	ja     8013d0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80140e:	74 14                	je     801424 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 10 3b 80 00       	push   $0x803b10
  801418:	6a 44                	push   $0x44
  80141a:	68 b0 3a 80 00       	push   $0x803ab0
  80141f:	e8 1a fe ff ff       	call   80123e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801424:	90                   	nop
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	8d 48 01             	lea    0x1(%eax),%ecx
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	89 0a                	mov    %ecx,(%edx)
  80143a:	8b 55 08             	mov    0x8(%ebp),%edx
  80143d:	88 d1                	mov    %dl,%cl
  80143f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801442:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	8b 00                	mov    (%eax),%eax
  80144b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801450:	75 2c                	jne    80147e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801452:	a0 08 50 80 00       	mov    0x805008,%al
  801457:	0f b6 c0             	movzbl %al,%eax
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	8b 12                	mov    (%edx),%edx
  80145f:	89 d1                	mov    %edx,%ecx
  801461:	8b 55 0c             	mov    0xc(%ebp),%edx
  801464:	83 c2 08             	add    $0x8,%edx
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	50                   	push   %eax
  80146b:	51                   	push   %ecx
  80146c:	52                   	push   %edx
  80146d:	e8 78 0f 00 00       	call   8023ea <sys_cputs>
  801472:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	8b 40 04             	mov    0x4(%eax),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80148d:	90                   	nop
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801499:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014a0:	00 00 00 
	b.cnt = 0;
  8014a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8014aa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	ff 75 08             	pushl  0x8(%ebp)
  8014b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	68 27 14 80 00       	push   $0x801427
  8014bf:	e8 11 02 00 00       	call   8016d5 <vprintfmt>
  8014c4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8014c7:	a0 08 50 80 00       	mov    0x805008,%al
  8014cc:	0f b6 c0             	movzbl %al,%eax
  8014cf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	50                   	push   %eax
  8014d9:	52                   	push   %edx
  8014da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014e0:	83 c0 08             	add    $0x8,%eax
  8014e3:	50                   	push   %eax
  8014e4:	e8 01 0f 00 00       	call   8023ea <sys_cputs>
  8014e9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8014ec:	c6 05 08 50 80 00 00 	movb   $0x0,0x805008
	return b.cnt;
  8014f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801501:	c6 05 08 50 80 00 01 	movb   $0x1,0x805008
	va_start(ap, fmt);
  801508:	8d 45 0c             	lea    0xc(%ebp),%eax
  80150b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	ff 75 f4             	pushl  -0xc(%ebp)
  801517:	50                   	push   %eax
  801518:	e8 73 ff ff ff       	call   801490 <vcprintf>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80152e:	e8 f9 0e 00 00       	call   80242c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801533:	8d 45 0c             	lea    0xc(%ebp),%eax
  801536:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	ff 75 f4             	pushl  -0xc(%ebp)
  801542:	50                   	push   %eax
  801543:	e8 48 ff ff ff       	call   801490 <vcprintf>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80154e:	e8 f3 0e 00 00       	call   802446 <sys_unlock_cons>
	return cnt;
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	53                   	push   %ebx
  80155c:	83 ec 14             	sub    $0x14,%esp
  80155f:	8b 45 10             	mov    0x10(%ebp),%eax
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80156b:	8b 45 18             	mov    0x18(%ebp),%eax
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801576:	77 55                	ja     8015cd <printnum+0x75>
  801578:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80157b:	72 05                	jb     801582 <printnum+0x2a>
  80157d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801580:	77 4b                	ja     8015cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801582:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801585:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801588:	8b 45 18             	mov    0x18(%ebp),%eax
  80158b:	ba 00 00 00 00       	mov    $0x0,%edx
  801590:	52                   	push   %edx
  801591:	50                   	push   %eax
  801592:	ff 75 f4             	pushl  -0xc(%ebp)
  801595:	ff 75 f0             	pushl  -0x10(%ebp)
  801598:	e8 4b 14 00 00       	call   8029e8 <__udivdi3>
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	ff 75 20             	pushl  0x20(%ebp)
  8015a6:	53                   	push   %ebx
  8015a7:	ff 75 18             	pushl  0x18(%ebp)
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	e8 a1 ff ff ff       	call   801558 <printnum>
  8015b7:	83 c4 20             	add    $0x20,%esp
  8015ba:	eb 1a                	jmp    8015d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	ff 75 20             	pushl  0x20(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	ff d0                	call   *%eax
  8015ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8015d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8015d4:	7f e6                	jg     8015bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8015d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e4:	53                   	push   %ebx
  8015e5:	51                   	push   %ecx
  8015e6:	52                   	push   %edx
  8015e7:	50                   	push   %eax
  8015e8:	e8 0b 15 00 00       	call   802af8 <__umoddi3>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	05 74 3d 80 00       	add    $0x803d74,%eax
  8015f5:	8a 00                	mov    (%eax),%al
  8015f7:	0f be c0             	movsbl %al,%eax
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	50                   	push   %eax
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	ff d0                	call   *%eax
  801606:	83 c4 10             	add    $0x10,%esp
}
  801609:	90                   	nop
  80160a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801612:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801616:	7e 1c                	jle    801634 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	8d 50 08             	lea    0x8(%eax),%edx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 10                	mov    %edx,(%eax)
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	8b 00                	mov    (%eax),%eax
  80162a:	83 e8 08             	sub    $0x8,%eax
  80162d:	8b 50 04             	mov    0x4(%eax),%edx
  801630:	8b 00                	mov    (%eax),%eax
  801632:	eb 40                	jmp    801674 <getuint+0x65>
	else if (lflag)
  801634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801638:	74 1e                	je     801658 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	8d 50 04             	lea    0x4(%eax),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	89 10                	mov    %edx,(%eax)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 00                	mov    (%eax),%eax
  80164c:	83 e8 04             	sub    $0x4,%eax
  80164f:	8b 00                	mov    (%eax),%eax
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	eb 1c                	jmp    801674 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	8d 50 04             	lea    0x4(%eax),%edx
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 10                	mov    %edx,(%eax)
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	83 e8 04             	sub    $0x4,%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801679:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80167d:	7e 1c                	jle    80169b <getint+0x25>
		return va_arg(*ap, long long);
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	8d 50 08             	lea    0x8(%eax),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	89 10                	mov    %edx,(%eax)
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8b 00                	mov    (%eax),%eax
  801691:	83 e8 08             	sub    $0x8,%eax
  801694:	8b 50 04             	mov    0x4(%eax),%edx
  801697:	8b 00                	mov    (%eax),%eax
  801699:	eb 38                	jmp    8016d3 <getint+0x5d>
	else if (lflag)
  80169b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169f:	74 1a                	je     8016bb <getint+0x45>
		return va_arg(*ap, long);
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	8d 50 04             	lea    0x4(%eax),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	89 10                	mov    %edx,(%eax)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8b 00                	mov    (%eax),%eax
  8016b3:	83 e8 04             	sub    $0x4,%eax
  8016b6:	8b 00                	mov    (%eax),%eax
  8016b8:	99                   	cltd   
  8016b9:	eb 18                	jmp    8016d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	99                   	cltd   
}
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	56                   	push   %esi
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016dd:	eb 17                	jmp    8016f6 <vprintfmt+0x21>
			if (ch == '\0')
  8016df:	85 db                	test   %ebx,%ebx
  8016e1:	0f 84 c1 03 00 00    	je     801aa8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8016e7:	83 ec 08             	sub    $0x8,%esp
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	53                   	push   %ebx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	ff d0                	call   *%eax
  8016f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	8d 50 01             	lea    0x1(%eax),%edx
  8016fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ff:	8a 00                	mov    (%eax),%al
  801701:	0f b6 d8             	movzbl %al,%ebx
  801704:	83 fb 25             	cmp    $0x25,%ebx
  801707:	75 d6                	jne    8016df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801709:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80170d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801714:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80171b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801722:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	8d 50 01             	lea    0x1(%eax),%edx
  80172f:	89 55 10             	mov    %edx,0x10(%ebp)
  801732:	8a 00                	mov    (%eax),%al
  801734:	0f b6 d8             	movzbl %al,%ebx
  801737:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80173a:	83 f8 5b             	cmp    $0x5b,%eax
  80173d:	0f 87 3d 03 00 00    	ja     801a80 <vprintfmt+0x3ab>
  801743:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  80174a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80174c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801750:	eb d7                	jmp    801729 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801752:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801756:	eb d1                	jmp    801729 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801758:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80175f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801762:	89 d0                	mov    %edx,%eax
  801764:	c1 e0 02             	shl    $0x2,%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	01 c0                	add    %eax,%eax
  80176b:	01 d8                	add    %ebx,%eax
  80176d:	83 e8 30             	sub    $0x30,%eax
  801770:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80177b:	83 fb 2f             	cmp    $0x2f,%ebx
  80177e:	7e 3e                	jle    8017be <vprintfmt+0xe9>
  801780:	83 fb 39             	cmp    $0x39,%ebx
  801783:	7f 39                	jg     8017be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801785:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801788:	eb d5                	jmp    80175f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80178a:	8b 45 14             	mov    0x14(%ebp),%eax
  80178d:	83 c0 04             	add    $0x4,%eax
  801790:	89 45 14             	mov    %eax,0x14(%ebp)
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	83 e8 04             	sub    $0x4,%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80179e:	eb 1f                	jmp    8017bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8017a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017a4:	79 83                	jns    801729 <vprintfmt+0x54>
				width = 0;
  8017a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8017ad:	e9 77 ff ff ff       	jmp    801729 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8017b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8017b9:	e9 6b ff ff ff       	jmp    801729 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8017be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8017bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017c3:	0f 89 60 ff ff ff    	jns    801729 <vprintfmt+0x54>
				width = precision, precision = -1;
  8017c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8017d6:	e9 4e ff ff ff       	jmp    801729 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8017db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8017de:	e9 46 ff ff ff       	jmp    801729 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8017e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e6:	83 c0 04             	add    $0x4,%eax
  8017e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8017ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ef:	83 e8 04             	sub    $0x4,%eax
  8017f2:	8b 00                	mov    (%eax),%eax
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	50                   	push   %eax
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	ff d0                	call   *%eax
  801800:	83 c4 10             	add    $0x10,%esp
			break;
  801803:	e9 9b 02 00 00       	jmp    801aa3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801808:	8b 45 14             	mov    0x14(%ebp),%eax
  80180b:	83 c0 04             	add    $0x4,%eax
  80180e:	89 45 14             	mov    %eax,0x14(%ebp)
  801811:	8b 45 14             	mov    0x14(%ebp),%eax
  801814:	83 e8 04             	sub    $0x4,%eax
  801817:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801819:	85 db                	test   %ebx,%ebx
  80181b:	79 02                	jns    80181f <vprintfmt+0x14a>
				err = -err;
  80181d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80181f:	83 fb 64             	cmp    $0x64,%ebx
  801822:	7f 0b                	jg     80182f <vprintfmt+0x15a>
  801824:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  80182b:	85 f6                	test   %esi,%esi
  80182d:	75 19                	jne    801848 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80182f:	53                   	push   %ebx
  801830:	68 85 3d 80 00       	push   $0x803d85
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 70 02 00 00       	call   801ab0 <printfmt>
  801840:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801843:	e9 5b 02 00 00       	jmp    801aa3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801848:	56                   	push   %esi
  801849:	68 8e 3d 80 00       	push   $0x803d8e
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	e8 57 02 00 00       	call   801ab0 <printfmt>
  801859:	83 c4 10             	add    $0x10,%esp
			break;
  80185c:	e9 42 02 00 00       	jmp    801aa3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801861:	8b 45 14             	mov    0x14(%ebp),%eax
  801864:	83 c0 04             	add    $0x4,%eax
  801867:	89 45 14             	mov    %eax,0x14(%ebp)
  80186a:	8b 45 14             	mov    0x14(%ebp),%eax
  80186d:	83 e8 04             	sub    $0x4,%eax
  801870:	8b 30                	mov    (%eax),%esi
  801872:	85 f6                	test   %esi,%esi
  801874:	75 05                	jne    80187b <vprintfmt+0x1a6>
				p = "(null)";
  801876:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  80187b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80187f:	7e 6d                	jle    8018ee <vprintfmt+0x219>
  801881:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801885:	74 67                	je     8018ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	50                   	push   %eax
  80188e:	56                   	push   %esi
  80188f:	e8 1e 03 00 00       	call   801bb2 <strnlen>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80189a:	eb 16                	jmp    8018b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80189c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	50                   	push   %eax
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	ff d0                	call   *%eax
  8018ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8018af:	ff 4d e4             	decl   -0x1c(%ebp)
  8018b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b6:	7f e4                	jg     80189c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018b8:	eb 34                	jmp    8018ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8018ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018be:	74 1c                	je     8018dc <vprintfmt+0x207>
  8018c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8018c3:	7e 05                	jle    8018ca <vprintfmt+0x1f5>
  8018c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8018c8:	7e 12                	jle    8018dc <vprintfmt+0x207>
					putch('?', putdat);
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	6a 3f                	push   $0x3f
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	ff d0                	call   *%eax
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	eb 0f                	jmp    8018eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	53                   	push   %ebx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	ff d0                	call   *%eax
  8018e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8018ee:	89 f0                	mov    %esi,%eax
  8018f0:	8d 70 01             	lea    0x1(%eax),%esi
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be d8             	movsbl %al,%ebx
  8018f8:	85 db                	test   %ebx,%ebx
  8018fa:	74 24                	je     801920 <vprintfmt+0x24b>
  8018fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801900:	78 b8                	js     8018ba <vprintfmt+0x1e5>
  801902:	ff 4d e0             	decl   -0x20(%ebp)
  801905:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801909:	79 af                	jns    8018ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80190b:	eb 13                	jmp    801920 <vprintfmt+0x24b>
				putch(' ', putdat);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	6a 20                	push   $0x20
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	ff d0                	call   *%eax
  80191a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80191d:	ff 4d e4             	decl   -0x1c(%ebp)
  801920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801924:	7f e7                	jg     80190d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801926:	e9 78 01 00 00       	jmp    801aa3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	ff 75 e8             	pushl  -0x18(%ebp)
  801931:	8d 45 14             	lea    0x14(%ebp),%eax
  801934:	50                   	push   %eax
  801935:	e8 3c fd ff ff       	call   801676 <getint>
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801940:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801949:	85 d2                	test   %edx,%edx
  80194b:	79 23                	jns    801970 <vprintfmt+0x29b>
				putch('-', putdat);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	6a 2d                	push   $0x2d
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	ff d0                	call   *%eax
  80195a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801963:	f7 d8                	neg    %eax
  801965:	83 d2 00             	adc    $0x0,%edx
  801968:	f7 da                	neg    %edx
  80196a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80196d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801970:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801977:	e9 bc 00 00 00       	jmp    801a38 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	ff 75 e8             	pushl  -0x18(%ebp)
  801982:	8d 45 14             	lea    0x14(%ebp),%eax
  801985:	50                   	push   %eax
  801986:	e8 84 fc ff ff       	call   80160f <getuint>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801991:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801994:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80199b:	e9 98 00 00 00       	jmp    801a38 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8019a0:	83 ec 08             	sub    $0x8,%esp
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	6a 58                	push   $0x58
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	ff d0                	call   *%eax
  8019ad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 58                	push   $0x58
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	6a 58                	push   $0x58
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	ff d0                	call   *%eax
  8019cd:	83 c4 10             	add    $0x10,%esp
			break;
  8019d0:	e9 ce 00 00 00       	jmp    801aa3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	6a 30                	push   $0x30
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	6a 78                	push   $0x78
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	ff d0                	call   *%eax
  8019f2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f8:	83 c0 04             	add    $0x4,%eax
  8019fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801a01:	83 e8 04             	sub    $0x4,%eax
  801a04:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a17:	eb 1f                	jmp    801a38 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  801a22:	50                   	push   %eax
  801a23:	e8 e7 fb ff ff       	call   80160f <getuint>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a38:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	52                   	push   %edx
  801a43:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a46:	50                   	push   %eax
  801a47:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	e8 00 fb ff ff       	call   801558 <printnum>
  801a58:	83 c4 20             	add    $0x20,%esp
			break;
  801a5b:	eb 46                	jmp    801aa3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	53                   	push   %ebx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	ff d0                	call   *%eax
  801a69:	83 c4 10             	add    $0x10,%esp
			break;
  801a6c:	eb 35                	jmp    801aa3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a6e:	c6 05 08 50 80 00 00 	movb   $0x0,0x805008
			break;
  801a75:	eb 2c                	jmp    801aa3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a77:	c6 05 08 50 80 00 01 	movb   $0x1,0x805008
			break;
  801a7e:	eb 23                	jmp    801aa3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	6a 25                	push   $0x25
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	ff d0                	call   *%eax
  801a8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a90:	ff 4d 10             	decl   0x10(%ebp)
  801a93:	eb 03                	jmp    801a98 <vprintfmt+0x3c3>
  801a95:	ff 4d 10             	decl   0x10(%ebp)
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	48                   	dec    %eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	3c 25                	cmp    $0x25,%al
  801aa0:	75 f3                	jne    801a95 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801aa2:	90                   	nop
		}
	}
  801aa3:	e9 35 fc ff ff       	jmp    8016dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801aa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801aa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  801ab9:	83 c0 04             	add    $0x4,%eax
  801abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	e8 04 fc ff ff       	call   8016d5 <vprintfmt>
  801ad1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	8b 40 08             	mov    0x8(%eax),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aec:	8b 10                	mov    (%eax),%edx
  801aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af1:	8b 40 04             	mov    0x4(%eax),%eax
  801af4:	39 c2                	cmp    %eax,%edx
  801af6:	73 12                	jae    801b0a <sprintputch+0x33>
		*b->buf++ = ch;
  801af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afb:	8b 00                	mov    (%eax),%eax
  801afd:	8d 48 01             	lea    0x1(%eax),%ecx
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	89 0a                	mov    %ecx,(%edx)
  801b05:	8b 55 08             	mov    0x8(%ebp),%edx
  801b08:	88 10                	mov    %dl,(%eax)
}
  801b0a:	90                   	nop
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	01 d0                	add    %edx,%eax
  801b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b32:	74 06                	je     801b3a <vsnprintf+0x2d>
  801b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b38:	7f 07                	jg     801b41 <vsnprintf+0x34>
		return -E_INVAL;
  801b3a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b3f:	eb 20                	jmp    801b61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b41:	ff 75 14             	pushl  0x14(%ebp)
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b4a:	50                   	push   %eax
  801b4b:	68 d7 1a 80 00       	push   $0x801ad7
  801b50:	e8 80 fb ff ff       	call   8016d5 <vprintfmt>
  801b55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b69:	8d 45 10             	lea    0x10(%ebp),%eax
  801b6c:	83 c0 04             	add    $0x4,%eax
  801b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b72:	8b 45 10             	mov    0x10(%ebp),%eax
  801b75:	ff 75 f4             	pushl  -0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	e8 89 ff ff ff       	call   801b0d <vsnprintf>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801b95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b9c:	eb 06                	jmp    801ba4 <strlen+0x15>
		n++;
  801b9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ba1:	ff 45 08             	incl   0x8(%ebp)
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	8a 00                	mov    (%eax),%al
  801ba9:	84 c0                	test   %al,%al
  801bab:	75 f1                	jne    801b9e <strlen+0xf>
		n++;
	return n;
  801bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bbf:	eb 09                	jmp    801bca <strnlen+0x18>
		n++;
  801bc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bc4:	ff 45 08             	incl   0x8(%ebp)
  801bc7:	ff 4d 0c             	decl   0xc(%ebp)
  801bca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bce:	74 09                	je     801bd9 <strnlen+0x27>
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	8a 00                	mov    (%eax),%al
  801bd5:	84 c0                	test   %al,%al
  801bd7:	75 e8                	jne    801bc1 <strnlen+0xf>
		n++;
	return n;
  801bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801bea:	90                   	nop
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	8d 50 01             	lea    0x1(%eax),%edx
  801bf1:	89 55 08             	mov    %edx,0x8(%ebp)
  801bf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bfa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801bfd:	8a 12                	mov    (%edx),%dl
  801bff:	88 10                	mov    %dl,(%eax)
  801c01:	8a 00                	mov    (%eax),%al
  801c03:	84 c0                	test   %al,%al
  801c05:	75 e4                	jne    801beb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c1f:	eb 1f                	jmp    801c40 <strncpy+0x34>
		*dst++ = *src;
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8d 50 01             	lea    0x1(%eax),%edx
  801c27:	89 55 08             	mov    %edx,0x8(%ebp)
  801c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2d:	8a 12                	mov    (%edx),%dl
  801c2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c34:	8a 00                	mov    (%eax),%al
  801c36:	84 c0                	test   %al,%al
  801c38:	74 03                	je     801c3d <strncpy+0x31>
			src++;
  801c3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c3d:	ff 45 fc             	incl   -0x4(%ebp)
  801c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c43:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c46:	72 d9                	jb     801c21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c5d:	74 30                	je     801c8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801c5f:	eb 16                	jmp    801c77 <strlcpy+0x2a>
			*dst++ = *src++;
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8d 50 01             	lea    0x1(%eax),%edx
  801c67:	89 55 08             	mov    %edx,0x8(%ebp)
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c73:	8a 12                	mov    (%edx),%dl
  801c75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c77:	ff 4d 10             	decl   0x10(%ebp)
  801c7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7e:	74 09                	je     801c89 <strlcpy+0x3c>
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	75 d8                	jne    801c61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c95:	29 c2                	sub    %eax,%edx
  801c97:	89 d0                	mov    %edx,%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801c9e:	eb 06                	jmp    801ca6 <strcmp+0xb>
		p++, q++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
  801ca3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8a 00                	mov    (%eax),%al
  801cab:	84 c0                	test   %al,%al
  801cad:	74 0e                	je     801cbd <strcmp+0x22>
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8a 10                	mov    (%eax),%dl
  801cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb7:	8a 00                	mov    (%eax),%al
  801cb9:	38 c2                	cmp    %al,%dl
  801cbb:	74 e3                	je     801ca0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8a 00                	mov    (%eax),%al
  801cc2:	0f b6 d0             	movzbl %al,%edx
  801cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc8:	8a 00                	mov    (%eax),%al
  801cca:	0f b6 c0             	movzbl %al,%eax
  801ccd:	29 c2                	sub    %eax,%edx
  801ccf:	89 d0                	mov    %edx,%eax
}
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801cd6:	eb 09                	jmp    801ce1 <strncmp+0xe>
		n--, p++, q++;
  801cd8:	ff 4d 10             	decl   0x10(%ebp)
  801cdb:	ff 45 08             	incl   0x8(%ebp)
  801cde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801ce1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ce5:	74 17                	je     801cfe <strncmp+0x2b>
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8a 00                	mov    (%eax),%al
  801cec:	84 c0                	test   %al,%al
  801cee:	74 0e                	je     801cfe <strncmp+0x2b>
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8a 10                	mov    (%eax),%dl
  801cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf8:	8a 00                	mov    (%eax),%al
  801cfa:	38 c2                	cmp    %al,%dl
  801cfc:	74 da                	je     801cd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d02:	75 07                	jne    801d0b <strncmp+0x38>
		return 0;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
  801d09:	eb 14                	jmp    801d1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	8a 00                	mov    (%eax),%al
  801d10:	0f b6 d0             	movzbl %al,%edx
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	8a 00                	mov    (%eax),%al
  801d18:	0f b6 c0             	movzbl %al,%eax
  801d1b:	29 c2                	sub    %eax,%edx
  801d1d:	89 d0                	mov    %edx,%eax
}
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d2d:	eb 12                	jmp    801d41 <strchr+0x20>
		if (*s == c)
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8a 00                	mov    (%eax),%al
  801d34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d37:	75 05                	jne    801d3e <strchr+0x1d>
			return (char *) s;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	eb 11                	jmp    801d4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d3e:	ff 45 08             	incl   0x8(%ebp)
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	84 c0                	test   %al,%al
  801d48:	75 e5                	jne    801d2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d5d:	eb 0d                	jmp    801d6c <strfind+0x1b>
		if (*s == c)
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	8a 00                	mov    (%eax),%al
  801d64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d67:	74 0e                	je     801d77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d69:	ff 45 08             	incl   0x8(%ebp)
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	8a 00                	mov    (%eax),%al
  801d71:	84 c0                	test   %al,%al
  801d73:	75 ea                	jne    801d5f <strfind+0xe>
  801d75:	eb 01                	jmp    801d78 <strfind+0x27>
		if (*s == c)
			break;
  801d77:	90                   	nop
	return (char *) s;
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801d89:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801d8f:	eb 0e                	jmp    801d9f <memset+0x22>
		*p++ = c;
  801d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d94:	8d 50 01             	lea    0x1(%eax),%edx
  801d97:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801d9f:	ff 4d f8             	decl   -0x8(%ebp)
  801da2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801da6:	79 e9                	jns    801d91 <memset+0x14>
		*p++ = c;

	return v;
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801dbf:	eb 16                	jmp    801dd7 <memcpy+0x2a>
		*d++ = *s++;
  801dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc4:	8d 50 01             	lea    0x1(%eax),%edx
  801dc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dd0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801dd3:	8a 12                	mov    (%edx),%dl
  801dd5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dda:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ddd:	89 55 10             	mov    %edx,0x10(%ebp)
  801de0:	85 c0                	test   %eax,%eax
  801de2:	75 dd                	jne    801dc1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801def:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e01:	73 50                	jae    801e53 <memmove+0x6a>
  801e03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e06:	8b 45 10             	mov    0x10(%ebp),%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e0e:	76 43                	jbe    801e53 <memmove+0x6a>
		s += n;
  801e10:	8b 45 10             	mov    0x10(%ebp),%eax
  801e13:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e16:	8b 45 10             	mov    0x10(%ebp),%eax
  801e19:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e1c:	eb 10                	jmp    801e2e <memmove+0x45>
			*--d = *--s;
  801e1e:	ff 4d f8             	decl   -0x8(%ebp)
  801e21:	ff 4d fc             	decl   -0x4(%ebp)
  801e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e27:	8a 10                	mov    (%eax),%dl
  801e29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e2c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e31:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e34:	89 55 10             	mov    %edx,0x10(%ebp)
  801e37:	85 c0                	test   %eax,%eax
  801e39:	75 e3                	jne    801e1e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e3b:	eb 23                	jmp    801e60 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e40:	8d 50 01             	lea    0x1(%eax),%edx
  801e43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e49:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e4c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e4f:	8a 12                	mov    (%edx),%dl
  801e51:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801e53:	8b 45 10             	mov    0x10(%ebp),%eax
  801e56:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e59:	89 55 10             	mov    %edx,0x10(%ebp)
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	75 dd                	jne    801e3d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801e77:	eb 2a                	jmp    801ea3 <memcmp+0x3e>
		if (*s1 != *s2)
  801e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7c:	8a 10                	mov    (%eax),%dl
  801e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	38 c2                	cmp    %al,%dl
  801e85:	74 16                	je     801e9d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8a:	8a 00                	mov    (%eax),%al
  801e8c:	0f b6 d0             	movzbl %al,%edx
  801e8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e92:	8a 00                	mov    (%eax),%al
  801e94:	0f b6 c0             	movzbl %al,%eax
  801e97:	29 c2                	sub    %eax,%edx
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	eb 18                	jmp    801eb5 <memcmp+0x50>
		s1++, s2++;
  801e9d:	ff 45 fc             	incl   -0x4(%ebp)
  801ea0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  801eac:	85 c0                	test   %eax,%eax
  801eae:	75 c9                	jne    801e79 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec3:	01 d0                	add    %edx,%eax
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801ec8:	eb 15                	jmp    801edf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	8a 00                	mov    (%eax),%al
  801ecf:	0f b6 d0             	movzbl %al,%edx
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	0f b6 c0             	movzbl %al,%eax
  801ed8:	39 c2                	cmp    %eax,%edx
  801eda:	74 0d                	je     801ee9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801edc:	ff 45 08             	incl   0x8(%ebp)
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ee5:	72 e3                	jb     801eca <memfind+0x13>
  801ee7:	eb 01                	jmp    801eea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ee9:	90                   	nop
	return (void *) s;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801ef5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801efc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f03:	eb 03                	jmp    801f08 <strtol+0x19>
		s++;
  801f05:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	8a 00                	mov    (%eax),%al
  801f0d:	3c 20                	cmp    $0x20,%al
  801f0f:	74 f4                	je     801f05 <strtol+0x16>
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	3c 09                	cmp    $0x9,%al
  801f18:	74 eb                	je     801f05 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	8a 00                	mov    (%eax),%al
  801f1f:	3c 2b                	cmp    $0x2b,%al
  801f21:	75 05                	jne    801f28 <strtol+0x39>
		s++;
  801f23:	ff 45 08             	incl   0x8(%ebp)
  801f26:	eb 13                	jmp    801f3b <strtol+0x4c>
	else if (*s == '-')
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	8a 00                	mov    (%eax),%al
  801f2d:	3c 2d                	cmp    $0x2d,%al
  801f2f:	75 0a                	jne    801f3b <strtol+0x4c>
		s++, neg = 1;
  801f31:	ff 45 08             	incl   0x8(%ebp)
  801f34:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f3f:	74 06                	je     801f47 <strtol+0x58>
  801f41:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f45:	75 20                	jne    801f67 <strtol+0x78>
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	8a 00                	mov    (%eax),%al
  801f4c:	3c 30                	cmp    $0x30,%al
  801f4e:	75 17                	jne    801f67 <strtol+0x78>
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	40                   	inc    %eax
  801f54:	8a 00                	mov    (%eax),%al
  801f56:	3c 78                	cmp    $0x78,%al
  801f58:	75 0d                	jne    801f67 <strtol+0x78>
		s += 2, base = 16;
  801f5a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801f5e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801f65:	eb 28                	jmp    801f8f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f6b:	75 15                	jne    801f82 <strtol+0x93>
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	8a 00                	mov    (%eax),%al
  801f72:	3c 30                	cmp    $0x30,%al
  801f74:	75 0c                	jne    801f82 <strtol+0x93>
		s++, base = 8;
  801f76:	ff 45 08             	incl   0x8(%ebp)
  801f79:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801f80:	eb 0d                	jmp    801f8f <strtol+0xa0>
	else if (base == 0)
  801f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f86:	75 07                	jne    801f8f <strtol+0xa0>
		base = 10;
  801f88:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	8a 00                	mov    (%eax),%al
  801f94:	3c 2f                	cmp    $0x2f,%al
  801f96:	7e 19                	jle    801fb1 <strtol+0xc2>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 39                	cmp    $0x39,%al
  801f9f:	7f 10                	jg     801fb1 <strtol+0xc2>
			dig = *s - '0';
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8a 00                	mov    (%eax),%al
  801fa6:	0f be c0             	movsbl %al,%eax
  801fa9:	83 e8 30             	sub    $0x30,%eax
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801faf:	eb 42                	jmp    801ff3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	8a 00                	mov    (%eax),%al
  801fb6:	3c 60                	cmp    $0x60,%al
  801fb8:	7e 19                	jle    801fd3 <strtol+0xe4>
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	8a 00                	mov    (%eax),%al
  801fbf:	3c 7a                	cmp    $0x7a,%al
  801fc1:	7f 10                	jg     801fd3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	8a 00                	mov    (%eax),%al
  801fc8:	0f be c0             	movsbl %al,%eax
  801fcb:	83 e8 57             	sub    $0x57,%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	eb 20                	jmp    801ff3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	3c 40                	cmp    $0x40,%al
  801fda:	7e 39                	jle    802015 <strtol+0x126>
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	3c 5a                	cmp    $0x5a,%al
  801fe3:	7f 30                	jg     802015 <strtol+0x126>
			dig = *s - 'A' + 10;
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8a 00                	mov    (%eax),%al
  801fea:	0f be c0             	movsbl %al,%eax
  801fed:	83 e8 37             	sub    $0x37,%eax
  801ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ff9:	7d 19                	jge    802014 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ffb:	ff 45 08             	incl   0x8(%ebp)
  801ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802001:	0f af 45 10          	imul   0x10(%ebp),%eax
  802005:	89 c2                	mov    %eax,%edx
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80200f:	e9 7b ff ff ff       	jmp    801f8f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802014:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802015:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802019:	74 08                	je     802023 <strtol+0x134>
		*endptr = (char *) s;
  80201b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201e:	8b 55 08             	mov    0x8(%ebp),%edx
  802021:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802023:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802027:	74 07                	je     802030 <strtol+0x141>
  802029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80202c:	f7 d8                	neg    %eax
  80202e:	eb 03                	jmp    802033 <strtol+0x144>
  802030:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <ltostr>:

void
ltostr(long value, char *str)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80203b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802042:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204d:	79 13                	jns    802062 <ltostr+0x2d>
	{
		neg = 1;
  80204f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80205c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80205f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80206a:	99                   	cltd   
  80206b:	f7 f9                	idiv   %ecx
  80206d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802070:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802073:	8d 50 01             	lea    0x1(%eax),%edx
  802076:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802079:	89 c2                	mov    %eax,%edx
  80207b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207e:	01 d0                	add    %edx,%eax
  802080:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802083:	83 c2 30             	add    $0x30,%edx
  802086:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802088:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802090:	f7 e9                	imul   %ecx
  802092:	c1 fa 02             	sar    $0x2,%edx
  802095:	89 c8                	mov    %ecx,%eax
  802097:	c1 f8 1f             	sar    $0x1f,%eax
  80209a:	29 c2                	sub    %eax,%edx
  80209c:	89 d0                	mov    %edx,%eax
  80209e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8020a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a5:	75 bb                	jne    802062 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8020a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8020ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020b1:	48                   	dec    %eax
  8020b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8020b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b9:	74 3d                	je     8020f8 <ltostr+0xc3>
		start = 1 ;
  8020bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8020c2:	eb 34                	jmp    8020f8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8020c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	8a 00                	mov    (%eax),%al
  8020ce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8020d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	01 c2                	add    %eax,%edx
  8020d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	01 c8                	add    %ecx,%eax
  8020e1:	8a 00                	mov    (%eax),%al
  8020e3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8020e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020eb:	01 c2                	add    %eax,%edx
  8020ed:	8a 45 eb             	mov    -0x15(%ebp),%al
  8020f0:	88 02                	mov    %al,(%edx)
		start++ ;
  8020f2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8020f5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020fe:	7c c4                	jl     8020c4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802100:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802103:	8b 45 0c             	mov    0xc(%ebp),%eax
  802106:	01 d0                	add    %edx,%eax
  802108:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802114:	ff 75 08             	pushl  0x8(%ebp)
  802117:	e8 73 fa ff ff       	call   801b8f <strlen>
  80211c:	83 c4 04             	add    $0x4,%esp
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	e8 65 fa ff ff       	call   801b8f <strlen>
  80212a:	83 c4 04             	add    $0x4,%esp
  80212d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80213e:	eb 17                	jmp    802157 <strcconcat+0x49>
		final[s] = str1[s] ;
  802140:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802143:	8b 45 10             	mov    0x10(%ebp),%eax
  802146:	01 c2                	add    %eax,%edx
  802148:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	01 c8                	add    %ecx,%eax
  802150:	8a 00                	mov    (%eax),%al
  802152:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802154:	ff 45 fc             	incl   -0x4(%ebp)
  802157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80215d:	7c e1                	jl     802140 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80215f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802166:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80216d:	eb 1f                	jmp    80218e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802172:	8d 50 01             	lea    0x1(%eax),%edx
  802175:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802178:	89 c2                	mov    %eax,%edx
  80217a:	8b 45 10             	mov    0x10(%ebp),%eax
  80217d:	01 c2                	add    %eax,%edx
  80217f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802182:	8b 45 0c             	mov    0xc(%ebp),%eax
  802185:	01 c8                	add    %ecx,%eax
  802187:	8a 00                	mov    (%eax),%al
  802189:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80218b:	ff 45 f8             	incl   -0x8(%ebp)
  80218e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802191:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802194:	7c d9                	jl     80216f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	01 d0                	add    %edx,%eax
  80219e:	c6 00 00             	movb   $0x0,(%eax)
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8021a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8021b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b3:	8b 00                	mov    (%eax),%eax
  8021b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	01 d0                	add    %edx,%eax
  8021c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021c7:	eb 0c                	jmp    8021d5 <strsplit+0x31>
			*string++ = 0;
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8d 50 01             	lea    0x1(%eax),%edx
  8021cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8021d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8a 00                	mov    (%eax),%al
  8021da:	84 c0                	test   %al,%al
  8021dc:	74 18                	je     8021f6 <strsplit+0x52>
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8a 00                	mov    (%eax),%al
  8021e3:	0f be c0             	movsbl %al,%eax
  8021e6:	50                   	push   %eax
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	e8 32 fb ff ff       	call   801d21 <strchr>
  8021ef:	83 c4 08             	add    $0x8,%esp
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	75 d3                	jne    8021c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8a 00                	mov    (%eax),%al
  8021fb:	84 c0                	test   %al,%al
  8021fd:	74 5a                	je     802259 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8021ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	83 f8 0f             	cmp    $0xf,%eax
  802207:	75 07                	jne    802210 <strsplit+0x6c>
		{
			return 0;
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	eb 66                	jmp    802276 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802210:	8b 45 14             	mov    0x14(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	8d 48 01             	lea    0x1(%eax),%ecx
  802218:	8b 55 14             	mov    0x14(%ebp),%edx
  80221b:	89 0a                	mov    %ecx,(%edx)
  80221d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802224:	8b 45 10             	mov    0x10(%ebp),%eax
  802227:	01 c2                	add    %eax,%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80222e:	eb 03                	jmp    802233 <strsplit+0x8f>
			string++;
  802230:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	8a 00                	mov    (%eax),%al
  802238:	84 c0                	test   %al,%al
  80223a:	74 8b                	je     8021c7 <strsplit+0x23>
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	8a 00                	mov    (%eax),%al
  802241:	0f be c0             	movsbl %al,%eax
  802244:	50                   	push   %eax
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	e8 d4 fa ff ff       	call   801d21 <strchr>
  80224d:	83 c4 08             	add    $0x8,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	74 dc                	je     802230 <strsplit+0x8c>
			string++;
	}
  802254:	e9 6e ff ff ff       	jmp    8021c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802259:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80225a:	8b 45 14             	mov    0x14(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802266:	8b 45 10             	mov    0x10(%ebp),%eax
  802269:	01 d0                	add    %edx,%eax
  80226b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802271:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	68 08 3f 80 00       	push   $0x803f08
  802286:	68 3f 01 00 00       	push   $0x13f
  80228b:	68 2a 3f 80 00       	push   $0x803f2a
  802290:	e8 a9 ef ff ff       	call   80123e <_panic>

00802295 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	e8 ef 06 00 00       	call   802995 <sys_sbrk>
  8022a6:	83 c4 10             	add    $0x10,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8022b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b5:	75 07                	jne    8022be <malloc+0x13>
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	eb 14                	jmp    8022d2 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	68 38 3f 80 00       	push   $0x803f38
  8022c6:	6a 1b                	push   $0x1b
  8022c8:	68 5d 3f 80 00       	push   $0x803f5d
  8022cd:	e8 6c ef ff ff       	call   80123e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 6c 3f 80 00       	push   $0x803f6c
  8022e2:	6a 29                	push   $0x29
  8022e4:	68 5d 3f 80 00       	push   $0x803f5d
  8022e9:	e8 50 ef ff ff       	call   80123e <_panic>

008022ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 18             	sub    $0x18,%esp
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8022fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022fe:	75 07                	jne    802307 <smalloc+0x19>
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
  802305:	eb 14                	jmp    80231b <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802307:	83 ec 04             	sub    $0x4,%esp
  80230a:	68 90 3f 80 00       	push   $0x803f90
  80230f:	6a 38                	push   $0x38
  802311:	68 5d 3f 80 00       	push   $0x803f5d
  802316:	e8 23 ef ff ff       	call   80123e <_panic>
	return NULL;
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 b8 3f 80 00       	push   $0x803fb8
  80232b:	6a 43                	push   $0x43
  80232d:	68 5d 3f 80 00       	push   $0x803f5d
  802332:	e8 07 ef ff ff       	call   80123e <_panic>

00802337 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80233d:	83 ec 04             	sub    $0x4,%esp
  802340:	68 dc 3f 80 00       	push   $0x803fdc
  802345:	6a 5b                	push   $0x5b
  802347:	68 5d 3f 80 00       	push   $0x803f5d
  80234c:	e8 ed ee ff ff       	call   80123e <_panic>

00802351 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 00 40 80 00       	push   $0x804000
  80235f:	6a 72                	push   $0x72
  802361:	68 5d 3f 80 00       	push   $0x803f5d
  802366:	e8 d3 ee ff ff       	call   80123e <_panic>

0080236b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 26 40 80 00       	push   $0x804026
  802379:	6a 7e                	push   $0x7e
  80237b:	68 5d 3f 80 00       	push   $0x803f5d
  802380:	e8 b9 ee ff ff       	call   80123e <_panic>

00802385 <shrink>:

}
void shrink(uint32 newSize)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	68 26 40 80 00       	push   $0x804026
  802393:	68 83 00 00 00       	push   $0x83
  802398:	68 5d 3f 80 00       	push   $0x803f5d
  80239d:	e8 9c ee ff ff       	call   80123e <_panic>

008023a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 26 40 80 00       	push   $0x804026
  8023b0:	68 88 00 00 00       	push   $0x88
  8023b5:	68 5d 3f 80 00       	push   $0x803f5d
  8023ba:	e8 7f ee ff ff       	call   80123e <_panic>

008023bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	57                   	push   %edi
  8023c3:	56                   	push   %esi
  8023c4:	53                   	push   %ebx
  8023c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023da:	cd 30                	int    $0x30
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	5b                   	pop    %ebx
  8023e6:	5e                   	pop    %esi
  8023e7:	5f                   	pop    %edi
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    

008023ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	52                   	push   %edx
  802402:	ff 75 0c             	pushl  0xc(%ebp)
  802405:	50                   	push   %eax
  802406:	6a 00                	push   $0x0
  802408:	e8 b2 ff ff ff       	call   8023bf <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	90                   	nop
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_cgetc>:

int
sys_cgetc(void)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 02                	push   $0x2
  802422:	e8 98 ff ff ff       	call   8023bf <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 03                	push   $0x3
  80243b:	e8 7f ff ff ff       	call   8023bf <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	90                   	nop
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 04                	push   $0x4
  802455:	e8 65 ff ff ff       	call   8023bf <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	90                   	nop
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802463:	8b 55 0c             	mov    0xc(%ebp),%edx
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	52                   	push   %edx
  802470:	50                   	push   %eax
  802471:	6a 08                	push   $0x8
  802473:	e8 47 ff ff ff       	call   8023bf <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	56                   	push   %esi
  802481:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802482:	8b 75 18             	mov    0x18(%ebp),%esi
  802485:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80248b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	56                   	push   %esi
  802492:	53                   	push   %ebx
  802493:	51                   	push   %ecx
  802494:	52                   	push   %edx
  802495:	50                   	push   %eax
  802496:	6a 09                	push   $0x9
  802498:	e8 22 ff ff ff       	call   8023bf <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
}
  8024a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5d                   	pop    %ebp
  8024a6:	c3                   	ret    

008024a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	6a 0a                	push   $0xa
  8024ba:	e8 00 ff ff ff       	call   8023bf <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	ff 75 0c             	pushl  0xc(%ebp)
  8024d0:	ff 75 08             	pushl  0x8(%ebp)
  8024d3:	6a 0b                	push   $0xb
  8024d5:	e8 e5 fe ff ff       	call   8023bf <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 0c                	push   $0xc
  8024ee:	e8 cc fe ff ff       	call   8023bf <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 0d                	push   $0xd
  802507:	e8 b3 fe ff ff       	call   8023bf <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 0e                	push   $0xe
  802520:	e8 9a fe ff ff       	call   8023bf <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 0f                	push   $0xf
  802539:	e8 81 fe ff ff       	call   8023bf <syscall>
  80253e:	83 c4 18             	add    $0x18,%esp
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	ff 75 08             	pushl  0x8(%ebp)
  802551:	6a 10                	push   $0x10
  802553:	e8 67 fe ff ff       	call   8023bf <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 11                	push   $0x11
  80256c:	e8 4e fe ff ff       	call   8023bf <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	90                   	nop
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_cputc>:

void
sys_cputc(const char c)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802583:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	50                   	push   %eax
  802590:	6a 01                	push   $0x1
  802592:	e8 28 fe ff ff       	call   8023bf <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	90                   	nop
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 14                	push   $0x14
  8025ac:	e8 0e fe ff ff       	call   8023bf <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	90                   	nop
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 04             	sub    $0x4,%esp
  8025bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8025c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	6a 00                	push   $0x0
  8025cf:	51                   	push   %ecx
  8025d0:	52                   	push   %edx
  8025d1:	ff 75 0c             	pushl  0xc(%ebp)
  8025d4:	50                   	push   %eax
  8025d5:	6a 15                	push   $0x15
  8025d7:	e8 e3 fd ff ff       	call   8023bf <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8025e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	52                   	push   %edx
  8025f1:	50                   	push   %eax
  8025f2:	6a 16                	push   $0x16
  8025f4:	e8 c6 fd ff ff       	call   8023bf <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802601:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802604:	8b 55 0c             	mov    0xc(%ebp),%edx
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	51                   	push   %ecx
  80260f:	52                   	push   %edx
  802610:	50                   	push   %eax
  802611:	6a 17                	push   $0x17
  802613:	e8 a7 fd ff ff       	call   8023bf <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	52                   	push   %edx
  80262d:	50                   	push   %eax
  80262e:	6a 18                	push   $0x18
  802630:	e8 8a fd ff ff       	call   8023bf <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	6a 00                	push   $0x0
  802642:	ff 75 14             	pushl  0x14(%ebp)
  802645:	ff 75 10             	pushl  0x10(%ebp)
  802648:	ff 75 0c             	pushl  0xc(%ebp)
  80264b:	50                   	push   %eax
  80264c:	6a 19                	push   $0x19
  80264e:	e8 6c fd ff ff       	call   8023bf <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	50                   	push   %eax
  802667:	6a 1a                	push   $0x1a
  802669:	e8 51 fd ff ff       	call   8023bf <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	90                   	nop
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	50                   	push   %eax
  802683:	6a 1b                	push   $0x1b
  802685:	e8 35 fd ff ff       	call   8023bf <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 05                	push   $0x5
  80269e:	e8 1c fd ff ff       	call   8023bf <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 06                	push   $0x6
  8026b7:	e8 03 fd ff ff       	call   8023bf <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
}
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 07                	push   $0x7
  8026d0:	e8 ea fc ff ff       	call   8023bf <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <sys_exit_env>:


void sys_exit_env(void)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 1c                	push   $0x1c
  8026e9:	e8 d1 fc ff ff       	call   8023bf <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	90                   	nop
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026fd:	8d 50 04             	lea    0x4(%eax),%edx
  802700:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	52                   	push   %edx
  80270a:	50                   	push   %eax
  80270b:	6a 1d                	push   $0x1d
  80270d:	e8 ad fc ff ff       	call   8023bf <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
	return result;
  802715:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802718:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80271b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80271e:	89 01                	mov    %eax,(%ecx)
  802720:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	c9                   	leave  
  802727:	c2 04 00             	ret    $0x4

0080272a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	ff 75 10             	pushl  0x10(%ebp)
  802734:	ff 75 0c             	pushl  0xc(%ebp)
  802737:	ff 75 08             	pushl  0x8(%ebp)
  80273a:	6a 13                	push   $0x13
  80273c:	e8 7e fc ff ff       	call   8023bf <syscall>
  802741:	83 c4 18             	add    $0x18,%esp
	return ;
  802744:	90                   	nop
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <sys_rcr2>:
uint32 sys_rcr2()
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 1e                	push   $0x1e
  802756:	e8 64 fc ff ff       	call   8023bf <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80276c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	50                   	push   %eax
  802779:	6a 1f                	push   $0x1f
  80277b:	e8 3f fc ff ff       	call   8023bf <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
	return ;
  802783:	90                   	nop
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <rsttst>:
void rsttst()
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 21                	push   $0x21
  802795:	e8 25 fc ff ff       	call   8023bf <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
	return ;
  80279d:	90                   	nop
}
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8027a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8027af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027b3:	52                   	push   %edx
  8027b4:	50                   	push   %eax
  8027b5:	ff 75 10             	pushl  0x10(%ebp)
  8027b8:	ff 75 0c             	pushl  0xc(%ebp)
  8027bb:	ff 75 08             	pushl  0x8(%ebp)
  8027be:	6a 20                	push   $0x20
  8027c0:	e8 fa fb ff ff       	call   8023bf <syscall>
  8027c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c8:	90                   	nop
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <chktst>:
void chktst(uint32 n)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	ff 75 08             	pushl  0x8(%ebp)
  8027d9:	6a 22                	push   $0x22
  8027db:	e8 df fb ff ff       	call   8023bf <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e3:	90                   	nop
}
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <inctst>:

void inctst()
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 23                	push   $0x23
  8027f5:	e8 c5 fb ff ff       	call   8023bf <syscall>
  8027fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8027fd:	90                   	nop
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <gettst>:
uint32 gettst()
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 24                	push   $0x24
  80280f:	e8 ab fb ff ff       	call   8023bf <syscall>
  802814:	83 c4 18             	add    $0x18,%esp
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 25                	push   $0x25
  80282b:	e8 8f fb ff ff       	call   8023bf <syscall>
  802830:	83 c4 18             	add    $0x18,%esp
  802833:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802836:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80283a:	75 07                	jne    802843 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80283c:	b8 01 00 00 00       	mov    $0x1,%eax
  802841:	eb 05                	jmp    802848 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 25                	push   $0x25
  80285c:	e8 5e fb ff ff       	call   8023bf <syscall>
  802861:	83 c4 18             	add    $0x18,%esp
  802864:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802867:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80286b:	75 07                	jne    802874 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80286d:	b8 01 00 00 00       	mov    $0x1,%eax
  802872:	eb 05                	jmp    802879 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 25                	push   $0x25
  80288d:	e8 2d fb ff ff       	call   8023bf <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
  802895:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802898:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80289c:	75 07                	jne    8028a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80289e:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a3:	eb 05                	jmp    8028aa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 25                	push   $0x25
  8028be:	e8 fc fa ff ff       	call   8023bf <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
  8028c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028c9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028cd:	75 07                	jne    8028d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d4:	eb 05                	jmp    8028db <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	ff 75 08             	pushl  0x8(%ebp)
  8028eb:	6a 26                	push   $0x26
  8028ed:	e8 cd fa ff ff       	call   8023bf <syscall>
  8028f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f5:	90                   	nop
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802902:	8b 55 0c             	mov    0xc(%ebp),%edx
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	6a 00                	push   $0x0
  80290a:	53                   	push   %ebx
  80290b:	51                   	push   %ecx
  80290c:	52                   	push   %edx
  80290d:	50                   	push   %eax
  80290e:	6a 27                	push   $0x27
  802910:	e8 aa fa ff ff       	call   8023bf <syscall>
  802915:	83 c4 18             	add    $0x18,%esp
}
  802918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802920:	8b 55 0c             	mov    0xc(%ebp),%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	6a 00                	push   $0x0
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	52                   	push   %edx
  80292d:	50                   	push   %eax
  80292e:	6a 28                	push   $0x28
  802930:	e8 8a fa ff ff       	call   8023bf <syscall>
  802935:	83 c4 18             	add    $0x18,%esp
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80293d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802940:	8b 55 0c             	mov    0xc(%ebp),%edx
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	6a 00                	push   $0x0
  802948:	51                   	push   %ecx
  802949:	ff 75 10             	pushl  0x10(%ebp)
  80294c:	52                   	push   %edx
  80294d:	50                   	push   %eax
  80294e:	6a 29                	push   $0x29
  802950:	e8 6a fa ff ff       	call   8023bf <syscall>
  802955:	83 c4 18             	add    $0x18,%esp
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	ff 75 10             	pushl  0x10(%ebp)
  802964:	ff 75 0c             	pushl  0xc(%ebp)
  802967:	ff 75 08             	pushl  0x8(%ebp)
  80296a:	6a 12                	push   $0x12
  80296c:	e8 4e fa ff ff       	call   8023bf <syscall>
  802971:	83 c4 18             	add    $0x18,%esp
	return ;
  802974:	90                   	nop
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80297a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	52                   	push   %edx
  802987:	50                   	push   %eax
  802988:	6a 2a                	push   $0x2a
  80298a:	e8 30 fa ff ff       	call   8023bf <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
	return;
  802992:	90                   	nop
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	50                   	push   %eax
  8029a4:	6a 2b                	push   $0x2b
  8029a6:	e8 14 fa ff ff       	call   8023bf <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
}
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	ff 75 0c             	pushl  0xc(%ebp)
  8029bc:	ff 75 08             	pushl  0x8(%ebp)
  8029bf:	6a 2c                	push   $0x2c
  8029c1:	e8 f9 f9 ff ff       	call   8023bf <syscall>
  8029c6:	83 c4 18             	add    $0x18,%esp
	return;
  8029c9:	90                   	nop
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	ff 75 0c             	pushl  0xc(%ebp)
  8029d8:	ff 75 08             	pushl  0x8(%ebp)
  8029db:	6a 2d                	push   $0x2d
  8029dd:	e8 dd f9 ff ff       	call   8023bf <syscall>
  8029e2:	83 c4 18             	add    $0x18,%esp
	return;
  8029e5:	90                   	nop
}
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <__udivdi3>:
  8029e8:	55                   	push   %ebp
  8029e9:	57                   	push   %edi
  8029ea:	56                   	push   %esi
  8029eb:	53                   	push   %ebx
  8029ec:	83 ec 1c             	sub    $0x1c,%esp
  8029ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8029f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8029f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029ff:	89 ca                	mov    %ecx,%edx
  802a01:	89 f8                	mov    %edi,%eax
  802a03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a07:	85 f6                	test   %esi,%esi
  802a09:	75 2d                	jne    802a38 <__udivdi3+0x50>
  802a0b:	39 cf                	cmp    %ecx,%edi
  802a0d:	77 65                	ja     802a74 <__udivdi3+0x8c>
  802a0f:	89 fd                	mov    %edi,%ebp
  802a11:	85 ff                	test   %edi,%edi
  802a13:	75 0b                	jne    802a20 <__udivdi3+0x38>
  802a15:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1a:	31 d2                	xor    %edx,%edx
  802a1c:	f7 f7                	div    %edi
  802a1e:	89 c5                	mov    %eax,%ebp
  802a20:	31 d2                	xor    %edx,%edx
  802a22:	89 c8                	mov    %ecx,%eax
  802a24:	f7 f5                	div    %ebp
  802a26:	89 c1                	mov    %eax,%ecx
  802a28:	89 d8                	mov    %ebx,%eax
  802a2a:	f7 f5                	div    %ebp
  802a2c:	89 cf                	mov    %ecx,%edi
  802a2e:	89 fa                	mov    %edi,%edx
  802a30:	83 c4 1c             	add    $0x1c,%esp
  802a33:	5b                   	pop    %ebx
  802a34:	5e                   	pop    %esi
  802a35:	5f                   	pop    %edi
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    
  802a38:	39 ce                	cmp    %ecx,%esi
  802a3a:	77 28                	ja     802a64 <__udivdi3+0x7c>
  802a3c:	0f bd fe             	bsr    %esi,%edi
  802a3f:	83 f7 1f             	xor    $0x1f,%edi
  802a42:	75 40                	jne    802a84 <__udivdi3+0x9c>
  802a44:	39 ce                	cmp    %ecx,%esi
  802a46:	72 0a                	jb     802a52 <__udivdi3+0x6a>
  802a48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a4c:	0f 87 9e 00 00 00    	ja     802af0 <__udivdi3+0x108>
  802a52:	b8 01 00 00 00       	mov    $0x1,%eax
  802a57:	89 fa                	mov    %edi,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d 76 00             	lea    0x0(%esi),%esi
  802a64:	31 ff                	xor    %edi,%edi
  802a66:	31 c0                	xor    %eax,%eax
  802a68:	89 fa                	mov    %edi,%edx
  802a6a:	83 c4 1c             	add    $0x1c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    
  802a72:	66 90                	xchg   %ax,%ax
  802a74:	89 d8                	mov    %ebx,%eax
  802a76:	f7 f7                	div    %edi
  802a78:	31 ff                	xor    %edi,%edi
  802a7a:	89 fa                	mov    %edi,%edx
  802a7c:	83 c4 1c             	add    $0x1c,%esp
  802a7f:	5b                   	pop    %ebx
  802a80:	5e                   	pop    %esi
  802a81:	5f                   	pop    %edi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
  802a84:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a89:	89 eb                	mov    %ebp,%ebx
  802a8b:	29 fb                	sub    %edi,%ebx
  802a8d:	89 f9                	mov    %edi,%ecx
  802a8f:	d3 e6                	shl    %cl,%esi
  802a91:	89 c5                	mov    %eax,%ebp
  802a93:	88 d9                	mov    %bl,%cl
  802a95:	d3 ed                	shr    %cl,%ebp
  802a97:	89 e9                	mov    %ebp,%ecx
  802a99:	09 f1                	or     %esi,%ecx
  802a9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a9f:	89 f9                	mov    %edi,%ecx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 c5                	mov    %eax,%ebp
  802aa5:	89 d6                	mov    %edx,%esi
  802aa7:	88 d9                	mov    %bl,%cl
  802aa9:	d3 ee                	shr    %cl,%esi
  802aab:	89 f9                	mov    %edi,%ecx
  802aad:	d3 e2                	shl    %cl,%edx
  802aaf:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab3:	88 d9                	mov    %bl,%cl
  802ab5:	d3 e8                	shr    %cl,%eax
  802ab7:	09 c2                	or     %eax,%edx
  802ab9:	89 d0                	mov    %edx,%eax
  802abb:	89 f2                	mov    %esi,%edx
  802abd:	f7 74 24 0c          	divl   0xc(%esp)
  802ac1:	89 d6                	mov    %edx,%esi
  802ac3:	89 c3                	mov    %eax,%ebx
  802ac5:	f7 e5                	mul    %ebp
  802ac7:	39 d6                	cmp    %edx,%esi
  802ac9:	72 19                	jb     802ae4 <__udivdi3+0xfc>
  802acb:	74 0b                	je     802ad8 <__udivdi3+0xf0>
  802acd:	89 d8                	mov    %ebx,%eax
  802acf:	31 ff                	xor    %edi,%edi
  802ad1:	e9 58 ff ff ff       	jmp    802a2e <__udivdi3+0x46>
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802adc:	89 f9                	mov    %edi,%ecx
  802ade:	d3 e2                	shl    %cl,%edx
  802ae0:	39 c2                	cmp    %eax,%edx
  802ae2:	73 e9                	jae    802acd <__udivdi3+0xe5>
  802ae4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ae7:	31 ff                	xor    %edi,%edi
  802ae9:	e9 40 ff ff ff       	jmp    802a2e <__udivdi3+0x46>
  802aee:	66 90                	xchg   %ax,%ax
  802af0:	31 c0                	xor    %eax,%eax
  802af2:	e9 37 ff ff ff       	jmp    802a2e <__udivdi3+0x46>
  802af7:	90                   	nop

00802af8 <__umoddi3>:
  802af8:	55                   	push   %ebp
  802af9:	57                   	push   %edi
  802afa:	56                   	push   %esi
  802afb:	53                   	push   %ebx
  802afc:	83 ec 1c             	sub    $0x1c,%esp
  802aff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b03:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b17:	89 f3                	mov    %esi,%ebx
  802b19:	89 fa                	mov    %edi,%edx
  802b1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b1f:	89 34 24             	mov    %esi,(%esp)
  802b22:	85 c0                	test   %eax,%eax
  802b24:	75 1a                	jne    802b40 <__umoddi3+0x48>
  802b26:	39 f7                	cmp    %esi,%edi
  802b28:	0f 86 a2 00 00 00    	jbe    802bd0 <__umoddi3+0xd8>
  802b2e:	89 c8                	mov    %ecx,%eax
  802b30:	89 f2                	mov    %esi,%edx
  802b32:	f7 f7                	div    %edi
  802b34:	89 d0                	mov    %edx,%eax
  802b36:	31 d2                	xor    %edx,%edx
  802b38:	83 c4 1c             	add    $0x1c,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	39 f0                	cmp    %esi,%eax
  802b42:	0f 87 ac 00 00 00    	ja     802bf4 <__umoddi3+0xfc>
  802b48:	0f bd e8             	bsr    %eax,%ebp
  802b4b:	83 f5 1f             	xor    $0x1f,%ebp
  802b4e:	0f 84 ac 00 00 00    	je     802c00 <__umoddi3+0x108>
  802b54:	bf 20 00 00 00       	mov    $0x20,%edi
  802b59:	29 ef                	sub    %ebp,%edi
  802b5b:	89 fe                	mov    %edi,%esi
  802b5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e0                	shl    %cl,%eax
  802b65:	89 d7                	mov    %edx,%edi
  802b67:	89 f1                	mov    %esi,%ecx
  802b69:	d3 ef                	shr    %cl,%edi
  802b6b:	09 c7                	or     %eax,%edi
  802b6d:	89 e9                	mov    %ebp,%ecx
  802b6f:	d3 e2                	shl    %cl,%edx
  802b71:	89 14 24             	mov    %edx,(%esp)
  802b74:	89 d8                	mov    %ebx,%eax
  802b76:	d3 e0                	shl    %cl,%eax
  802b78:	89 c2                	mov    %eax,%edx
  802b7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b7e:	d3 e0                	shl    %cl,%eax
  802b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b84:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b88:	89 f1                	mov    %esi,%ecx
  802b8a:	d3 e8                	shr    %cl,%eax
  802b8c:	09 d0                	or     %edx,%eax
  802b8e:	d3 eb                	shr    %cl,%ebx
  802b90:	89 da                	mov    %ebx,%edx
  802b92:	f7 f7                	div    %edi
  802b94:	89 d3                	mov    %edx,%ebx
  802b96:	f7 24 24             	mull   (%esp)
  802b99:	89 c6                	mov    %eax,%esi
  802b9b:	89 d1                	mov    %edx,%ecx
  802b9d:	39 d3                	cmp    %edx,%ebx
  802b9f:	0f 82 87 00 00 00    	jb     802c2c <__umoddi3+0x134>
  802ba5:	0f 84 91 00 00 00    	je     802c3c <__umoddi3+0x144>
  802bab:	8b 54 24 04          	mov    0x4(%esp),%edx
  802baf:	29 f2                	sub    %esi,%edx
  802bb1:	19 cb                	sbb    %ecx,%ebx
  802bb3:	89 d8                	mov    %ebx,%eax
  802bb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802bb9:	d3 e0                	shl    %cl,%eax
  802bbb:	89 e9                	mov    %ebp,%ecx
  802bbd:	d3 ea                	shr    %cl,%edx
  802bbf:	09 d0                	or     %edx,%eax
  802bc1:	89 e9                	mov    %ebp,%ecx
  802bc3:	d3 eb                	shr    %cl,%ebx
  802bc5:	89 da                	mov    %ebx,%edx
  802bc7:	83 c4 1c             	add    $0x1c,%esp
  802bca:	5b                   	pop    %ebx
  802bcb:	5e                   	pop    %esi
  802bcc:	5f                   	pop    %edi
  802bcd:	5d                   	pop    %ebp
  802bce:	c3                   	ret    
  802bcf:	90                   	nop
  802bd0:	89 fd                	mov    %edi,%ebp
  802bd2:	85 ff                	test   %edi,%edi
  802bd4:	75 0b                	jne    802be1 <__umoddi3+0xe9>
  802bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	f7 f7                	div    %edi
  802bdf:	89 c5                	mov    %eax,%ebp
  802be1:	89 f0                	mov    %esi,%eax
  802be3:	31 d2                	xor    %edx,%edx
  802be5:	f7 f5                	div    %ebp
  802be7:	89 c8                	mov    %ecx,%eax
  802be9:	f7 f5                	div    %ebp
  802beb:	89 d0                	mov    %edx,%eax
  802bed:	e9 44 ff ff ff       	jmp    802b36 <__umoddi3+0x3e>
  802bf2:	66 90                	xchg   %ax,%ax
  802bf4:	89 c8                	mov    %ecx,%eax
  802bf6:	89 f2                	mov    %esi,%edx
  802bf8:	83 c4 1c             	add    $0x1c,%esp
  802bfb:	5b                   	pop    %ebx
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	3b 04 24             	cmp    (%esp),%eax
  802c03:	72 06                	jb     802c0b <__umoddi3+0x113>
  802c05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c09:	77 0f                	ja     802c1a <__umoddi3+0x122>
  802c0b:	89 f2                	mov    %esi,%edx
  802c0d:	29 f9                	sub    %edi,%ecx
  802c0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c13:	89 14 24             	mov    %edx,(%esp)
  802c16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c1e:	8b 14 24             	mov    (%esp),%edx
  802c21:	83 c4 1c             	add    $0x1c,%esp
  802c24:	5b                   	pop    %ebx
  802c25:	5e                   	pop    %esi
  802c26:	5f                   	pop    %edi
  802c27:	5d                   	pop    %ebp
  802c28:	c3                   	ret    
  802c29:	8d 76 00             	lea    0x0(%esi),%esi
  802c2c:	2b 04 24             	sub    (%esp),%eax
  802c2f:	19 fa                	sbb    %edi,%edx
  802c31:	89 d1                	mov    %edx,%ecx
  802c33:	89 c6                	mov    %eax,%esi
  802c35:	e9 71 ff ff ff       	jmp    802bab <__umoddi3+0xb3>
  802c3a:	66 90                	xchg   %ax,%ax
  802c3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c40:	72 ea                	jb     802c2c <__umoddi3+0x134>
  802c42:	89 d9                	mov    %ebx,%ecx
  802c44:	e9 62 ff ff ff       	jmp    802bab <__umoddi3+0xb3>
