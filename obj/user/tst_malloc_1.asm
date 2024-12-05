
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
  800064:	a1 20 60 80 00       	mov    0x806020,%eax
  800069:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80006f:	a1 20 60 80 00       	mov    0x806020,%eax
  800074:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 e0 4a 80 00       	push   $0x804ae0
  800086:	6a 1f                	push   $0x1f
  800088:	68 fc 4a 80 00       	push   $0x804afc
  80008d:	e8 b4 11 00 00       	call   801246 <_panic>
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
  8000d7:	e8 14 28 00 00       	call   8028f0 <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 10 4b 80 00       	push   $0x804b10
  8000e7:	e8 17 14 00 00       	call   801503 <cprintf>
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
  800103:	e8 e8 27 00 00       	call   8028f0 <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 2b 28 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 8f 21 00 00       	call   8022b3 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 70 4b 80 00       	push   $0x804b70
  800147:	e8 b7 13 00 00       	call   801503 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 92 27 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800195:	68 a4 4b 80 00       	push   $0x804ba4
  80019a:	e8 64 13 00 00       	call   801503 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 94 27 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 14 4c 80 00       	push   $0x804c14
  8001bb:	e8 43 13 00 00       	call   801503 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 28 27 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  8001ff:	e8 ec 26 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800237:	68 48 4c 80 00       	push   $0x804c48
  80023c:	e8 c2 12 00 00       	call   801503 <cprintf>
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
  80027e:	e8 c8 2a 00 00       	call   802d4b <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 c8 4c 80 00       	push   $0x804cc8
  80029e:	e8 60 12 00 00       	call   801503 <cprintf>
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
  8002b7:	e8 34 26 00 00       	call   8028f0 <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 77 26 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  8002c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	50                   	push   %eax
  8002d3:	e8 db 1f 00 00       	call   8022b3 <malloc>
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
  800303:	68 ec 4c 80 00       	push   $0x804cec
  800308:	e8 f6 11 00 00       	call   801503 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 d1 25 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800356:	68 20 4d 80 00       	push   $0x804d20
  80035b:	e8 a3 11 00 00       	call   801503 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 d3 25 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 90 4d 80 00       	push   $0x804d90
  80037c:	e8 82 11 00 00       	call   801503 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 67 25 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  8003c9:	e8 22 25 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800401:	68 c4 4d 80 00       	push   $0x804dc4
  800406:	e8 f8 10 00 00       	call   801503 <cprintf>
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
  80044c:	e8 fa 28 00 00       	call   802d4b <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 44 4e 80 00       	push   $0x804e44
  80046c:	e8 92 10 00 00       	call   801503 <cprintf>
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
  800485:	e8 b1 24 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  80048a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	89 c2                	mov    %eax,%edx
  800492:	01 d2                	add    %edx,%edx
  800494:	01 d0                	add    %edx,%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 14 1e 00 00       	call   8022b3 <malloc>
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
  8004cb:	68 68 4e 80 00       	push   $0x804e68
  8004d0:	e8 2e 10 00 00       	call   801503 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 09 24 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  80051e:	68 9c 4e 80 00       	push   $0x804e9c
  800523:	e8 db 0f 00 00       	call   801503 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 0b 24 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 0c 4f 80 00       	push   $0x804f0c
  800544:	e8 ba 0f 00 00       	call   801503 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 9f 23 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  80058f:	e8 5c 23 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  8005c7:	68 40 4f 80 00       	push   $0x804f40
  8005cc:	e8 32 0f 00 00       	call   801503 <cprintf>
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
  800615:	e8 31 27 00 00       	call   802d4b <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 c0 4f 80 00       	push   $0x804fc0
  800635:	e8 c9 0e 00 00       	call   801503 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 f9 22 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800648:	89 c2                	mov    %eax,%edx
  80064a:	01 d2                	add    %edx,%edx
  80064c:	01 d0                	add    %edx,%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 5c 1c 00 00       	call   8022b3 <malloc>
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
  80068b:	68 e4 4f 80 00       	push   $0x804fe4
  800690:	e8 6e 0e 00 00       	call   801503 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 9e 22 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 18 50 80 00       	push   $0x805018
  8006b1:	e8 4d 0e 00 00       	call   801503 <cprintf>
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
  8006ca:	e8 21 22 00 00       	call   8028f0 <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 64 22 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
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
  8006eb:	e8 c3 1b 00 00       	call   8022b3 <malloc>
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
  800724:	68 4c 50 80 00       	push   $0x80504c
  800729:	e8 d5 0d 00 00       	call   801503 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 b0 21 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800777:	68 80 50 80 00       	push   $0x805080
  80077c:	e8 82 0d 00 00       	call   801503 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 b2 21 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 f0 50 80 00       	push   $0x8050f0
  80079d:	e8 61 0d 00 00       	call   801503 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 46 21 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  80082f:	e8 bc 20 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800867:	68 24 51 80 00       	push   $0x805124
  80086c:	e8 92 0c 00 00       	call   801503 <cprintf>
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
  8008bb:	e8 8b 24 00 00       	call   802d4b <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 a4 51 80 00       	push   $0x8051a4
  8008db:	e8 23 0c 00 00       	call   801503 <cprintf>
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
  8008f4:	e8 f7 1f 00 00       	call   8028f0 <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 3a 20 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800907:	89 c2                	mov    %eax,%edx
  800909:	01 d2                	add    %edx,%edx
  80090b:	01 d0                	add    %edx,%eax
  80090d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	50                   	push   %eax
  800914:	e8 9a 19 00 00       	call   8022b3 <malloc>
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
  80094d:	68 c8 51 80 00       	push   $0x8051c8
  800952:	e8 ac 0b 00 00       	call   801503 <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 87 1f 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  8009a0:	68 fc 51 80 00       	push   $0x8051fc
  8009a5:	e8 59 0b 00 00       	call   801503 <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 89 1f 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 6c 52 80 00       	push   $0x80526c
  8009c6:	e8 38 0b 00 00       	call   801503 <cprintf>
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
  8009df:	e8 0c 1f 00 00       	call   8028f0 <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 4f 1f 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
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
  800a01:	e8 ad 18 00 00       	call   8022b3 <malloc>
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
  800a41:	68 a0 52 80 00       	push   $0x8052a0
  800a46:	e8 b8 0a 00 00       	call   801503 <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 93 1e 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800a94:	68 d4 52 80 00       	push   $0x8052d4
  800a99:	e8 65 0a 00 00       	call   801503 <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 95 1e 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 44 53 80 00       	push   $0x805344
  800aba:	e8 44 0a 00 00       	call   801503 <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 29 1e 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800b3a:	e8 b1 1d 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800b72:	68 78 53 80 00       	push   $0x805378
  800b77:	e8 87 09 00 00       	call   801503 <cprintf>
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
  800bfe:	e8 48 21 00 00       	call   802d4b <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 f8 53 80 00       	push   $0x8053f8
  800c1e:	e8 e0 08 00 00       	call   801503 <cprintf>
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
  800c37:	e8 b4 1c 00 00       	call   8028f0 <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 f7 1c 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
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
  800c5a:	e8 54 16 00 00       	call   8022b3 <malloc>
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
  800c9b:	68 1c 54 80 00       	push   $0x80541c
  800ca0:	e8 5e 08 00 00       	call   801503 <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 39 1c 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800cee:	68 50 54 80 00       	push   $0x805450
  800cf3:	e8 0b 08 00 00       	call   801503 <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 3b 1c 00 00       	call   80293b <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 c0 54 80 00       	push   $0x8054c0
  800d14:	e8 ea 07 00 00       	call   801503 <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 cf 1b 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800da5:	e8 46 1b 00 00       	call   8028f0 <sys_calculate_free_frames>
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
  800ddd:	68 f4 54 80 00       	push   $0x8054f4
  800de2:	e8 1c 07 00 00       	call   801503 <cprintf>
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
  800e6f:	e8 d7 1e 00 00       	call   802d4b <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 74 55 80 00       	push   $0x805574
  800e8f:	e8 6f 06 00 00       	call   801503 <cprintf>
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
  800eab:	68 98 55 80 00       	push   $0x805598
  800eb0:	e8 4e 06 00 00       	call   801503 <cprintf>
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
  800edb:	68 d4 55 80 00       	push   $0x8055d4
  800ee0:	e8 1e 06 00 00       	call   801503 <cprintf>
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
  800f13:	68 0c 56 80 00       	push   $0x80560c
  800f18:	e8 e6 05 00 00       	call   801503 <cprintf>
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
  800f4a:	68 48 56 80 00       	push   $0x805648
  800f4f:	e8 af 05 00 00       	call   801503 <cprintf>
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
  800f81:	68 84 56 80 00       	push   $0x805684
  800f86:	e8 78 05 00 00       	call   801503 <cprintf>
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
  800fbe:	68 c0 56 80 00       	push   $0x8056c0
  800fc3:	e8 3b 05 00 00       	call   801503 <cprintf>
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
  800ff7:	68 fc 56 80 00       	push   $0x8056fc
  800ffc:	e8 02 05 00 00       	call   801503 <cprintf>
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
  80105b:	68 38 57 80 00       	push   $0x805738
  801060:	e8 9e 04 00 00       	call   801503 <cprintf>
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
  8010ce:	68 74 57 80 00       	push   $0x805774
  8010d3:	e8 2b 04 00 00       	call   801503 <cprintf>
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
  8010f2:	68 b0 57 80 00       	push   $0x8057b0
  8010f7:	e8 07 04 00 00       	call   801503 <cprintf>
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
  80110d:	e8 a7 19 00 00       	call   802ab9 <sys_getenvindex>
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801118:	89 d0                	mov    %edx,%eax
  80111a:	c1 e0 03             	shl    $0x3,%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801126:	01 c8                	add    %ecx,%eax
  801128:	01 c0                	add    %eax,%eax
  80112a:	01 d0                	add    %edx,%eax
  80112c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801133:	01 c8                	add    %ecx,%eax
  801135:	01 d0                	add    %edx,%eax
  801137:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80113c:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801141:	a1 20 60 80 00       	mov    0x806020,%eax
  801146:	8a 40 20             	mov    0x20(%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	74 0d                	je     80115a <libmain+0x53>
		binaryname = myEnv->prog_name;
  80114d:	a1 20 60 80 00       	mov    0x806020,%eax
  801152:	83 c0 20             	add    $0x20,%eax
  801155:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	7e 0a                	jle    80116a <libmain+0x63>
		binaryname = argv[0];
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 e1 ee ff ff       	call   800059 <_main>
  801178:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80117b:	e8 bd 16 00 00       	call   80283d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	68 04 58 80 00       	push   $0x805804
  801188:	e8 76 03 00 00       	call   801503 <cprintf>
  80118d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801190:	a1 20 60 80 00       	mov    0x806020,%eax
  801195:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80119b:	a1 20 60 80 00       	mov    0x806020,%eax
  8011a0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	52                   	push   %edx
  8011aa:	50                   	push   %eax
  8011ab:	68 2c 58 80 00       	push   $0x80582c
  8011b0:	e8 4e 03 00 00       	call   801503 <cprintf>
  8011b5:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8011b8:	a1 20 60 80 00       	mov    0x806020,%eax
  8011bd:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8011c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8011c8:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8011ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8011d3:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8011d9:	51                   	push   %ecx
  8011da:	52                   	push   %edx
  8011db:	50                   	push   %eax
  8011dc:	68 54 58 80 00       	push   $0x805854
  8011e1:	e8 1d 03 00 00       	call   801503 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8011e9:	a1 20 60 80 00       	mov    0x806020,%eax
  8011ee:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	50                   	push   %eax
  8011f8:	68 ac 58 80 00       	push   $0x8058ac
  8011fd:	e8 01 03 00 00       	call   801503 <cprintf>
  801202:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	68 04 58 80 00       	push   $0x805804
  80120d:	e8 f1 02 00 00       	call   801503 <cprintf>
  801212:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801215:	e8 3d 16 00 00       	call   802857 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80121a:	e8 19 00 00 00       	call   801238 <exit>
}
  80121f:	90                   	nop
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	6a 00                	push   $0x0
  80122d:	e8 53 18 00 00       	call   802a85 <sys_destroy_env>
  801232:	83 c4 10             	add    $0x10,%esp
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <exit>:

void
exit(void)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80123e:	e8 a8 18 00 00       	call   802aeb <sys_exit_env>
}
  801243:	90                   	nop
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80124c:	8d 45 10             	lea    0x10(%ebp),%eax
  80124f:	83 c0 04             	add    $0x4,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801255:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 16                	je     801274 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80125e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  801263:	83 ec 08             	sub    $0x8,%esp
  801266:	50                   	push   %eax
  801267:	68 c0 58 80 00       	push   $0x8058c0
  80126c:	e8 92 02 00 00       	call   801503 <cprintf>
  801271:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801274:	a1 00 60 80 00       	mov    0x806000,%eax
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	ff 75 08             	pushl  0x8(%ebp)
  80127f:	50                   	push   %eax
  801280:	68 c5 58 80 00       	push   $0x8058c5
  801285:	e8 79 02 00 00       	call   801503 <cprintf>
  80128a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	83 ec 08             	sub    $0x8,%esp
  801293:	ff 75 f4             	pushl  -0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	e8 fc 01 00 00       	call   801498 <vcprintf>
  80129c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	6a 00                	push   $0x0
  8012a4:	68 e1 58 80 00       	push   $0x8058e1
  8012a9:	e8 ea 01 00 00       	call   801498 <vcprintf>
  8012ae:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8012b1:	e8 82 ff ff ff       	call   801238 <exit>

	// should not return here
	while (1) ;
  8012b6:	eb fe                	jmp    8012b6 <_panic+0x70>

008012b8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8012be:	a1 20 60 80 00       	mov    0x806020,%eax
  8012c3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	39 c2                	cmp    %eax,%edx
  8012ce:	74 14                	je     8012e4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 e4 58 80 00       	push   $0x8058e4
  8012d8:	6a 26                	push   $0x26
  8012da:	68 30 59 80 00       	push   $0x805930
  8012df:	e8 62 ff ff ff       	call   801246 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8012e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8012eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012f2:	e9 c5 00 00 00       	jmp    8013bc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8012f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	01 d0                	add    %edx,%eax
  801306:	8b 00                	mov    (%eax),%eax
  801308:	85 c0                	test   %eax,%eax
  80130a:	75 08                	jne    801314 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80130c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80130f:	e9 a5 00 00 00       	jmp    8013b9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801314:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80131b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801322:	eb 69                	jmp    80138d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801324:	a1 20 60 80 00       	mov    0x806020,%eax
  801329:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80132f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	01 c0                	add    %eax,%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	c1 e0 03             	shl    $0x3,%eax
  80133b:	01 c8                	add    %ecx,%eax
  80133d:	8a 40 04             	mov    0x4(%eax),%al
  801340:	84 c0                	test   %al,%al
  801342:	75 46                	jne    80138a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801344:	a1 20 60 80 00       	mov    0x806020,%eax
  801349:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80134f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801352:	89 d0                	mov    %edx,%eax
  801354:	01 c0                	add    %eax,%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c1 e0 03             	shl    $0x3,%eax
  80135b:	01 c8                	add    %ecx,%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801362:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	01 c8                	add    %ecx,%eax
  80137b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80137d:	39 c2                	cmp    %eax,%edx
  80137f:	75 09                	jne    80138a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801381:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801388:	eb 15                	jmp    80139f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80138a:	ff 45 e8             	incl   -0x18(%ebp)
  80138d:	a1 20 60 80 00       	mov    0x806020,%eax
  801392:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139b:	39 c2                	cmp    %eax,%edx
  80139d:	77 85                	ja     801324 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80139f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013a3:	75 14                	jne    8013b9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	68 3c 59 80 00       	push   $0x80593c
  8013ad:	6a 3a                	push   $0x3a
  8013af:	68 30 59 80 00       	push   $0x805930
  8013b4:	e8 8d fe ff ff       	call   801246 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8013b9:	ff 45 f0             	incl   -0x10(%ebp)
  8013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8013c2:	0f 8c 2f ff ff ff    	jl     8012f7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8013c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013d6:	eb 26                	jmp    8013fe <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8013d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8013dd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8013e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e6:	89 d0                	mov    %edx,%eax
  8013e8:	01 c0                	add    %eax,%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c1 e0 03             	shl    $0x3,%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 40 04             	mov    0x4(%eax),%al
  8013f4:	3c 01                	cmp    $0x1,%al
  8013f6:	75 03                	jne    8013fb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8013f8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013fb:	ff 45 e0             	incl   -0x20(%ebp)
  8013fe:	a1 20 60 80 00       	mov    0x806020,%eax
  801403:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	39 c2                	cmp    %eax,%edx
  80140e:	77 c8                	ja     8013d8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801413:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801416:	74 14                	je     80142c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	68 90 59 80 00       	push   $0x805990
  801420:	6a 44                	push   $0x44
  801422:	68 30 59 80 00       	push   $0x805930
  801427:	e8 1a fe ff ff       	call   801246 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80142c:	90                   	nop
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	8b 00                	mov    (%eax),%eax
  80143a:	8d 48 01             	lea    0x1(%eax),%ecx
  80143d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801440:	89 0a                	mov    %ecx,(%edx)
  801442:	8b 55 08             	mov    0x8(%ebp),%edx
  801445:	88 d1                	mov    %dl,%cl
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	3d ff 00 00 00       	cmp    $0xff,%eax
  801458:	75 2c                	jne    801486 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80145a:	a0 28 60 80 00       	mov    0x806028,%al
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	8b 55 0c             	mov    0xc(%ebp),%edx
  801465:	8b 12                	mov    (%edx),%edx
  801467:	89 d1                	mov    %edx,%ecx
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	83 c2 08             	add    $0x8,%edx
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	50                   	push   %eax
  801473:	51                   	push   %ecx
  801474:	52                   	push   %edx
  801475:	e8 81 13 00 00       	call   8027fb <sys_cputs>
  80147a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	8b 40 04             	mov    0x4(%eax),%eax
  80148c:	8d 50 01             	lea    0x1(%eax),%edx
  80148f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801492:	89 50 04             	mov    %edx,0x4(%eax)
}
  801495:	90                   	nop
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014a8:	00 00 00 
	b.cnt = 0;
  8014ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8014b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	68 2f 14 80 00       	push   $0x80142f
  8014c7:	e8 11 02 00 00       	call   8016dd <vprintfmt>
  8014cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8014cf:	a0 28 60 80 00       	mov    0x806028,%al
  8014d4:	0f b6 c0             	movzbl %al,%eax
  8014d7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	50                   	push   %eax
  8014e1:	52                   	push   %edx
  8014e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014e8:	83 c0 08             	add    $0x8,%eax
  8014eb:	50                   	push   %eax
  8014ec:	e8 0a 13 00 00       	call   8027fb <sys_cputs>
  8014f1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8014f4:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  8014fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801509:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  801510:	8d 45 0c             	lea    0xc(%ebp),%eax
  801513:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 f4             	pushl  -0xc(%ebp)
  80151f:	50                   	push   %eax
  801520:	e8 73 ff ff ff       	call   801498 <vcprintf>
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801536:	e8 02 13 00 00       	call   80283d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80153b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 f4             	pushl  -0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	e8 48 ff ff ff       	call   801498 <vcprintf>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801556:	e8 fc 12 00 00       	call   802857 <sys_unlock_cons>
	return cnt;
  80155b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	53                   	push   %ebx
  801564:	83 ec 14             	sub    $0x14,%esp
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80156d:	8b 45 14             	mov    0x14(%ebp),%eax
  801570:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801573:	8b 45 18             	mov    0x18(%ebp),%eax
  801576:	ba 00 00 00 00       	mov    $0x0,%edx
  80157b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80157e:	77 55                	ja     8015d5 <printnum+0x75>
  801580:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801583:	72 05                	jb     80158a <printnum+0x2a>
  801585:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801588:	77 4b                	ja     8015d5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80158a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80158d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801590:	8b 45 18             	mov    0x18(%ebp),%eax
  801593:	ba 00 00 00 00       	mov    $0x0,%edx
  801598:	52                   	push   %edx
  801599:	50                   	push   %eax
  80159a:	ff 75 f4             	pushl  -0xc(%ebp)
  80159d:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a0:	e8 bb 32 00 00       	call   804860 <__udivdi3>
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	ff 75 20             	pushl  0x20(%ebp)
  8015ae:	53                   	push   %ebx
  8015af:	ff 75 18             	pushl  0x18(%ebp)
  8015b2:	52                   	push   %edx
  8015b3:	50                   	push   %eax
  8015b4:	ff 75 0c             	pushl  0xc(%ebp)
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	e8 a1 ff ff ff       	call   801560 <printnum>
  8015bf:	83 c4 20             	add    $0x20,%esp
  8015c2:	eb 1a                	jmp    8015de <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	ff 75 20             	pushl  0x20(%ebp)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	ff d0                	call   *%eax
  8015d2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015d5:	ff 4d 1c             	decl   0x1c(%ebp)
  8015d8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8015dc:	7f e6                	jg     8015c4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015de:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8015e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ec:	53                   	push   %ebx
  8015ed:	51                   	push   %ecx
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	e8 7b 33 00 00       	call   804970 <__umoddi3>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	05 f4 5b 80 00       	add    $0x805bf4,%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	0f be c0             	movsbl %al,%eax
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	50                   	push   %eax
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	ff d0                	call   *%eax
  80160e:	83 c4 10             	add    $0x10,%esp
}
  801611:	90                   	nop
  801612:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80161a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80161e:	7e 1c                	jle    80163c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8b 00                	mov    (%eax),%eax
  801625:	8d 50 08             	lea    0x8(%eax),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 10                	mov    %edx,(%eax)
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	83 e8 08             	sub    $0x8,%eax
  801635:	8b 50 04             	mov    0x4(%eax),%edx
  801638:	8b 00                	mov    (%eax),%eax
  80163a:	eb 40                	jmp    80167c <getuint+0x65>
	else if (lflag)
  80163c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801640:	74 1e                	je     801660 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	8d 50 04             	lea    0x4(%eax),%edx
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	89 10                	mov    %edx,(%eax)
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 00                	mov    (%eax),%eax
  801654:	83 e8 04             	sub    $0x4,%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	ba 00 00 00 00       	mov    $0x0,%edx
  80165e:	eb 1c                	jmp    80167c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8b 00                	mov    (%eax),%eax
  801665:	8d 50 04             	lea    0x4(%eax),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	89 10                	mov    %edx,(%eax)
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	83 e8 04             	sub    $0x4,%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801685:	7e 1c                	jle    8016a3 <getint+0x25>
		return va_arg(*ap, long long);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	8d 50 08             	lea    0x8(%eax),%edx
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	89 10                	mov    %edx,(%eax)
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 e8 08             	sub    $0x8,%eax
  80169c:	8b 50 04             	mov    0x4(%eax),%edx
  80169f:	8b 00                	mov    (%eax),%eax
  8016a1:	eb 38                	jmp    8016db <getint+0x5d>
	else if (lflag)
  8016a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a7:	74 1a                	je     8016c3 <getint+0x45>
		return va_arg(*ap, long);
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	8d 50 04             	lea    0x4(%eax),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	89 10                	mov    %edx,(%eax)
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8b 00                	mov    (%eax),%eax
  8016bb:	83 e8 04             	sub    $0x4,%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	99                   	cltd   
  8016c1:	eb 18                	jmp    8016db <getint+0x5d>
	else
		return va_arg(*ap, int);
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8b 00                	mov    (%eax),%eax
  8016c8:	8d 50 04             	lea    0x4(%eax),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	89 10                	mov    %edx,(%eax)
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	8b 00                	mov    (%eax),%eax
  8016d5:	83 e8 04             	sub    $0x4,%eax
  8016d8:	8b 00                	mov    (%eax),%eax
  8016da:	99                   	cltd   
}
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    

008016dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016e5:	eb 17                	jmp    8016fe <vprintfmt+0x21>
			if (ch == '\0')
  8016e7:	85 db                	test   %ebx,%ebx
  8016e9:	0f 84 c1 03 00 00    	je     801ab0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	53                   	push   %ebx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	ff d0                	call   *%eax
  8016fb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801701:	8d 50 01             	lea    0x1(%eax),%edx
  801704:	89 55 10             	mov    %edx,0x10(%ebp)
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f b6 d8             	movzbl %al,%ebx
  80170c:	83 fb 25             	cmp    $0x25,%ebx
  80170f:	75 d6                	jne    8016e7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801711:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801715:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80171c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801723:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80172a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	8d 50 01             	lea    0x1(%eax),%edx
  801737:	89 55 10             	mov    %edx,0x10(%ebp)
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	0f b6 d8             	movzbl %al,%ebx
  80173f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801742:	83 f8 5b             	cmp    $0x5b,%eax
  801745:	0f 87 3d 03 00 00    	ja     801a88 <vprintfmt+0x3ab>
  80174b:	8b 04 85 18 5c 80 00 	mov    0x805c18(,%eax,4),%eax
  801752:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801754:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801758:	eb d7                	jmp    801731 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80175a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80175e:	eb d1                	jmp    801731 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801760:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801767:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80176a:	89 d0                	mov    %edx,%eax
  80176c:	c1 e0 02             	shl    $0x2,%eax
  80176f:	01 d0                	add    %edx,%eax
  801771:	01 c0                	add    %eax,%eax
  801773:	01 d8                	add    %ebx,%eax
  801775:	83 e8 30             	sub    $0x30,%eax
  801778:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	8a 00                	mov    (%eax),%al
  801780:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801783:	83 fb 2f             	cmp    $0x2f,%ebx
  801786:	7e 3e                	jle    8017c6 <vprintfmt+0xe9>
  801788:	83 fb 39             	cmp    $0x39,%ebx
  80178b:	7f 39                	jg     8017c6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80178d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801790:	eb d5                	jmp    801767 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	83 c0 04             	add    $0x4,%eax
  801798:	89 45 14             	mov    %eax,0x14(%ebp)
  80179b:	8b 45 14             	mov    0x14(%ebp),%eax
  80179e:	83 e8 04             	sub    $0x4,%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8017a6:	eb 1f                	jmp    8017c7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8017a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017ac:	79 83                	jns    801731 <vprintfmt+0x54>
				width = 0;
  8017ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8017b5:	e9 77 ff ff ff       	jmp    801731 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8017ba:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8017c1:	e9 6b ff ff ff       	jmp    801731 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8017c6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8017c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017cb:	0f 89 60 ff ff ff    	jns    801731 <vprintfmt+0x54>
				width = precision, precision = -1;
  8017d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8017de:	e9 4e ff ff ff       	jmp    801731 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8017e3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8017e6:	e9 46 ff ff ff       	jmp    801731 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8017eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ee:	83 c0 04             	add    $0x4,%eax
  8017f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f7:	83 e8 04             	sub    $0x4,%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	50                   	push   %eax
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	ff d0                	call   *%eax
  801808:	83 c4 10             	add    $0x10,%esp
			break;
  80180b:	e9 9b 02 00 00       	jmp    801aab <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801810:	8b 45 14             	mov    0x14(%ebp),%eax
  801813:	83 c0 04             	add    $0x4,%eax
  801816:	89 45 14             	mov    %eax,0x14(%ebp)
  801819:	8b 45 14             	mov    0x14(%ebp),%eax
  80181c:	83 e8 04             	sub    $0x4,%eax
  80181f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801821:	85 db                	test   %ebx,%ebx
  801823:	79 02                	jns    801827 <vprintfmt+0x14a>
				err = -err;
  801825:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801827:	83 fb 64             	cmp    $0x64,%ebx
  80182a:	7f 0b                	jg     801837 <vprintfmt+0x15a>
  80182c:	8b 34 9d 60 5a 80 00 	mov    0x805a60(,%ebx,4),%esi
  801833:	85 f6                	test   %esi,%esi
  801835:	75 19                	jne    801850 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801837:	53                   	push   %ebx
  801838:	68 05 5c 80 00       	push   $0x805c05
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	ff 75 08             	pushl  0x8(%ebp)
  801843:	e8 70 02 00 00       	call   801ab8 <printfmt>
  801848:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80184b:	e9 5b 02 00 00       	jmp    801aab <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801850:	56                   	push   %esi
  801851:	68 0e 5c 80 00       	push   $0x805c0e
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	e8 57 02 00 00       	call   801ab8 <printfmt>
  801861:	83 c4 10             	add    $0x10,%esp
			break;
  801864:	e9 42 02 00 00       	jmp    801aab <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	83 c0 04             	add    $0x4,%eax
  80186f:	89 45 14             	mov    %eax,0x14(%ebp)
  801872:	8b 45 14             	mov    0x14(%ebp),%eax
  801875:	83 e8 04             	sub    $0x4,%eax
  801878:	8b 30                	mov    (%eax),%esi
  80187a:	85 f6                	test   %esi,%esi
  80187c:	75 05                	jne    801883 <vprintfmt+0x1a6>
				p = "(null)";
  80187e:	be 11 5c 80 00       	mov    $0x805c11,%esi
			if (width > 0 && padc != '-')
  801883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801887:	7e 6d                	jle    8018f6 <vprintfmt+0x219>
  801889:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80188d:	74 67                	je     8018f6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80188f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	50                   	push   %eax
  801896:	56                   	push   %esi
  801897:	e8 1e 03 00 00       	call   801bba <strnlen>
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018a2:	eb 16                	jmp    8018ba <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018a4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	50                   	push   %eax
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	ff d0                	call   *%eax
  8018b4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8018b7:	ff 4d e4             	decl   -0x1c(%ebp)
  8018ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018be:	7f e4                	jg     8018a4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018c0:	eb 34                	jmp    8018f6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8018c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018c6:	74 1c                	je     8018e4 <vprintfmt+0x207>
  8018c8:	83 fb 1f             	cmp    $0x1f,%ebx
  8018cb:	7e 05                	jle    8018d2 <vprintfmt+0x1f5>
  8018cd:	83 fb 7e             	cmp    $0x7e,%ebx
  8018d0:	7e 12                	jle    8018e4 <vprintfmt+0x207>
					putch('?', putdat);
  8018d2:	83 ec 08             	sub    $0x8,%esp
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	6a 3f                	push   $0x3f
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	ff d0                	call   *%eax
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	eb 0f                	jmp    8018f3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	53                   	push   %ebx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	ff d0                	call   *%eax
  8018f0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8018f6:	89 f0                	mov    %esi,%eax
  8018f8:	8d 70 01             	lea    0x1(%eax),%esi
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f be d8             	movsbl %al,%ebx
  801900:	85 db                	test   %ebx,%ebx
  801902:	74 24                	je     801928 <vprintfmt+0x24b>
  801904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801908:	78 b8                	js     8018c2 <vprintfmt+0x1e5>
  80190a:	ff 4d e0             	decl   -0x20(%ebp)
  80190d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801911:	79 af                	jns    8018c2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801913:	eb 13                	jmp    801928 <vprintfmt+0x24b>
				putch(' ', putdat);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	6a 20                	push   $0x20
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	ff d0                	call   *%eax
  801922:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801925:	ff 4d e4             	decl   -0x1c(%ebp)
  801928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192c:	7f e7                	jg     801915 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80192e:	e9 78 01 00 00       	jmp    801aab <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	ff 75 e8             	pushl  -0x18(%ebp)
  801939:	8d 45 14             	lea    0x14(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	e8 3c fd ff ff       	call   80167e <getint>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801948:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801951:	85 d2                	test   %edx,%edx
  801953:	79 23                	jns    801978 <vprintfmt+0x29b>
				putch('-', putdat);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	6a 2d                	push   $0x2d
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	ff d0                	call   *%eax
  801962:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196b:	f7 d8                	neg    %eax
  80196d:	83 d2 00             	adc    $0x0,%edx
  801970:	f7 da                	neg    %edx
  801972:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801975:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801978:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80197f:	e9 bc 00 00 00       	jmp    801a40 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 e8             	pushl  -0x18(%ebp)
  80198a:	8d 45 14             	lea    0x14(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	e8 84 fc ff ff       	call   801617 <getuint>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801999:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80199c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019a3:	e9 98 00 00 00       	jmp    801a40 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	6a 58                	push   $0x58
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	ff d0                	call   *%eax
  8019b5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019b8:	83 ec 08             	sub    $0x8,%esp
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	6a 58                	push   $0x58
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	ff d0                	call   *%eax
  8019c5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	6a 58                	push   $0x58
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	ff d0                	call   *%eax
  8019d5:	83 c4 10             	add    $0x10,%esp
			break;
  8019d8:	e9 ce 00 00 00       	jmp    801aab <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	6a 30                	push   $0x30
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	ff d0                	call   *%eax
  8019ea:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8019ed:	83 ec 08             	sub    $0x8,%esp
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	6a 78                	push   $0x78
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	ff d0                	call   *%eax
  8019fa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	83 c0 04             	add    $0x4,%eax
  801a03:	89 45 14             	mov    %eax,0x14(%ebp)
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	83 e8 04             	sub    $0x4,%eax
  801a0c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a18:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a1f:	eb 1f                	jmp    801a40 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	ff 75 e8             	pushl  -0x18(%ebp)
  801a27:	8d 45 14             	lea    0x14(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	e8 e7 fb ff ff       	call   801617 <getuint>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a40:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	52                   	push   %edx
  801a4b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a4e:	50                   	push   %eax
  801a4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a52:	ff 75 f0             	pushl  -0x10(%ebp)
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	e8 00 fb ff ff       	call   801560 <printnum>
  801a60:	83 c4 20             	add    $0x20,%esp
			break;
  801a63:	eb 46                	jmp    801aab <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	53                   	push   %ebx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	ff d0                	call   *%eax
  801a71:	83 c4 10             	add    $0x10,%esp
			break;
  801a74:	eb 35                	jmp    801aab <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a76:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  801a7d:	eb 2c                	jmp    801aab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a7f:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  801a86:	eb 23                	jmp    801aab <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	6a 25                	push   $0x25
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	ff d0                	call   *%eax
  801a95:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a98:	ff 4d 10             	decl   0x10(%ebp)
  801a9b:	eb 03                	jmp    801aa0 <vprintfmt+0x3c3>
  801a9d:	ff 4d 10             	decl   0x10(%ebp)
  801aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa3:	48                   	dec    %eax
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	3c 25                	cmp    $0x25,%al
  801aa8:	75 f3                	jne    801a9d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801aaa:	90                   	nop
		}
	}
  801aab:	e9 35 fc ff ff       	jmp    8016e5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801ab0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ab1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    

00801ab8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801abe:	8d 45 10             	lea    0x10(%ebp),%eax
  801ac1:	83 c0 04             	add    $0x4,%eax
  801ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	ff 75 f4             	pushl  -0xc(%ebp)
  801acd:	50                   	push   %eax
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	e8 04 fc ff ff       	call   8016dd <vprintfmt>
  801ad9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae5:	8b 40 08             	mov    0x8(%eax),%eax
  801ae8:	8d 50 01             	lea    0x1(%eax),%edx
  801aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	8b 10                	mov    (%eax),%edx
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	8b 40 04             	mov    0x4(%eax),%eax
  801afc:	39 c2                	cmp    %eax,%edx
  801afe:	73 12                	jae    801b12 <sprintputch+0x33>
		*b->buf++ = ch;
  801b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	8d 48 01             	lea    0x1(%eax),%ecx
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	89 0a                	mov    %ecx,(%edx)
  801b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b10:	88 10                	mov    %dl,(%eax)
}
  801b12:	90                   	nop
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	01 d0                	add    %edx,%eax
  801b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3a:	74 06                	je     801b42 <vsnprintf+0x2d>
  801b3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b40:	7f 07                	jg     801b49 <vsnprintf+0x34>
		return -E_INVAL;
  801b42:	b8 03 00 00 00       	mov    $0x3,%eax
  801b47:	eb 20                	jmp    801b69 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b49:	ff 75 14             	pushl  0x14(%ebp)
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b52:	50                   	push   %eax
  801b53:	68 df 1a 80 00       	push   $0x801adf
  801b58:	e8 80 fb ff ff       	call   8016dd <vprintfmt>
  801b5d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b63:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b71:	8d 45 10             	lea    0x10(%ebp),%eax
  801b74:	83 c0 04             	add    $0x4,%eax
  801b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b80:	50                   	push   %eax
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 89 ff ff ff       	call   801b15 <vsnprintf>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801b9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ba4:	eb 06                	jmp    801bac <strlen+0x15>
		n++;
  801ba6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ba9:	ff 45 08             	incl   0x8(%ebp)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8a 00                	mov    (%eax),%al
  801bb1:	84 c0                	test   %al,%al
  801bb3:	75 f1                	jne    801ba6 <strlen+0xf>
		n++;
	return n;
  801bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bc7:	eb 09                	jmp    801bd2 <strnlen+0x18>
		n++;
  801bc9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bcc:	ff 45 08             	incl   0x8(%ebp)
  801bcf:	ff 4d 0c             	decl   0xc(%ebp)
  801bd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bd6:	74 09                	je     801be1 <strnlen+0x27>
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8a 00                	mov    (%eax),%al
  801bdd:	84 c0                	test   %al,%al
  801bdf:	75 e8                	jne    801bc9 <strnlen+0xf>
		n++;
	return n;
  801be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801bf2:	90                   	nop
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	8d 50 01             	lea    0x1(%eax),%edx
  801bf9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c02:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c05:	8a 12                	mov    (%edx),%dl
  801c07:	88 10                	mov    %dl,(%eax)
  801c09:	8a 00                	mov    (%eax),%al
  801c0b:	84 c0                	test   %al,%al
  801c0d:	75 e4                	jne    801bf3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c27:	eb 1f                	jmp    801c48 <strncpy+0x34>
		*dst++ = *src;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8d 50 01             	lea    0x1(%eax),%edx
  801c2f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8a 12                	mov    (%edx),%dl
  801c37:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3c:	8a 00                	mov    (%eax),%al
  801c3e:	84 c0                	test   %al,%al
  801c40:	74 03                	je     801c45 <strncpy+0x31>
			src++;
  801c42:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c45:	ff 45 fc             	incl   -0x4(%ebp)
  801c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c4e:	72 d9                	jb     801c29 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801c61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c65:	74 30                	je     801c97 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801c67:	eb 16                	jmp    801c7f <strlcpy+0x2a>
			*dst++ = *src++;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	8d 50 01             	lea    0x1(%eax),%edx
  801c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c7b:	8a 12                	mov    (%edx),%dl
  801c7d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c7f:	ff 4d 10             	decl   0x10(%ebp)
  801c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c86:	74 09                	je     801c91 <strlcpy+0x3c>
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	8a 00                	mov    (%eax),%al
  801c8d:	84 c0                	test   %al,%al
  801c8f:	75 d8                	jne    801c69 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c97:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c9d:	29 c2                	sub    %eax,%edx
  801c9f:	89 d0                	mov    %edx,%eax
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801ca6:	eb 06                	jmp    801cae <strcmp+0xb>
		p++, q++;
  801ca8:	ff 45 08             	incl   0x8(%ebp)
  801cab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	8a 00                	mov    (%eax),%al
  801cb3:	84 c0                	test   %al,%al
  801cb5:	74 0e                	je     801cc5 <strcmp+0x22>
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8a 10                	mov    (%eax),%dl
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	8a 00                	mov    (%eax),%al
  801cc1:	38 c2                	cmp    %al,%dl
  801cc3:	74 e3                	je     801ca8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8a 00                	mov    (%eax),%al
  801cca:	0f b6 d0             	movzbl %al,%edx
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd0:	8a 00                	mov    (%eax),%al
  801cd2:	0f b6 c0             	movzbl %al,%eax
  801cd5:	29 c2                	sub    %eax,%edx
  801cd7:	89 d0                	mov    %edx,%eax
}
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801cde:	eb 09                	jmp    801ce9 <strncmp+0xe>
		n--, p++, q++;
  801ce0:	ff 4d 10             	decl   0x10(%ebp)
  801ce3:	ff 45 08             	incl   0x8(%ebp)
  801ce6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ced:	74 17                	je     801d06 <strncmp+0x2b>
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	8a 00                	mov    (%eax),%al
  801cf4:	84 c0                	test   %al,%al
  801cf6:	74 0e                	je     801d06 <strncmp+0x2b>
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	8a 10                	mov    (%eax),%dl
  801cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d00:	8a 00                	mov    (%eax),%al
  801d02:	38 c2                	cmp    %al,%dl
  801d04:	74 da                	je     801ce0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d0a:	75 07                	jne    801d13 <strncmp+0x38>
		return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	eb 14                	jmp    801d27 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8a 00                	mov    (%eax),%al
  801d18:	0f b6 d0             	movzbl %al,%edx
  801d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1e:	8a 00                	mov    (%eax),%al
  801d20:	0f b6 c0             	movzbl %al,%eax
  801d23:	29 c2                	sub    %eax,%edx
  801d25:	89 d0                	mov    %edx,%eax
}
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d32:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d35:	eb 12                	jmp    801d49 <strchr+0x20>
		if (*s == c)
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8a 00                	mov    (%eax),%al
  801d3c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d3f:	75 05                	jne    801d46 <strchr+0x1d>
			return (char *) s;
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	eb 11                	jmp    801d57 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d46:	ff 45 08             	incl   0x8(%ebp)
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	8a 00                	mov    (%eax),%al
  801d4e:	84 c0                	test   %al,%al
  801d50:	75 e5                	jne    801d37 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d62:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d65:	eb 0d                	jmp    801d74 <strfind+0x1b>
		if (*s == c)
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8a 00                	mov    (%eax),%al
  801d6c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d6f:	74 0e                	je     801d7f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 ea                	jne    801d67 <strfind+0xe>
  801d7d:	eb 01                	jmp    801d80 <strfind+0x27>
		if (*s == c)
			break;
  801d7f:	90                   	nop
	return (char *) s;
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801d97:	eb 0e                	jmp    801da7 <memset+0x22>
		*p++ = c;
  801d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9c:	8d 50 01             	lea    0x1(%eax),%edx
  801d9f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801da7:	ff 4d f8             	decl   -0x8(%ebp)
  801daa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801dae:	79 e9                	jns    801d99 <memset+0x14>
		*p++ = c;

	return v;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801dc7:	eb 16                	jmp    801ddf <memcpy+0x2a>
		*d++ = *s++;
  801dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcc:	8d 50 01             	lea    0x1(%eax),%edx
  801dcf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dd8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ddb:	8a 12                	mov    (%edx),%dl
  801ddd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  801de2:	8d 50 ff             	lea    -0x1(%eax),%edx
  801de5:	89 55 10             	mov    %edx,0x10(%ebp)
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 dd                	jne    801dc9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e09:	73 50                	jae    801e5b <memmove+0x6a>
  801e0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e11:	01 d0                	add    %edx,%eax
  801e13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e16:	76 43                	jbe    801e5b <memmove+0x6a>
		s += n;
  801e18:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e21:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e24:	eb 10                	jmp    801e36 <memmove+0x45>
			*--d = *--s;
  801e26:	ff 4d f8             	decl   -0x8(%ebp)
  801e29:	ff 4d fc             	decl   -0x4(%ebp)
  801e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2f:	8a 10                	mov    (%eax),%dl
  801e31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e34:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e36:	8b 45 10             	mov    0x10(%ebp),%eax
  801e39:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e3c:	89 55 10             	mov    %edx,0x10(%ebp)
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	75 e3                	jne    801e26 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e43:	eb 23                	jmp    801e68 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e48:	8d 50 01             	lea    0x1(%eax),%edx
  801e4b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e51:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e54:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e57:	8a 12                	mov    (%edx),%dl
  801e59:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e61:	89 55 10             	mov    %edx,0x10(%ebp)
  801e64:	85 c0                	test   %eax,%eax
  801e66:	75 dd                	jne    801e45 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801e7f:	eb 2a                	jmp    801eab <memcmp+0x3e>
		if (*s1 != *s2)
  801e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e84:	8a 10                	mov    (%eax),%dl
  801e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e89:	8a 00                	mov    (%eax),%al
  801e8b:	38 c2                	cmp    %al,%dl
  801e8d:	74 16                	je     801ea5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e92:	8a 00                	mov    (%eax),%al
  801e94:	0f b6 d0             	movzbl %al,%edx
  801e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e9a:	8a 00                	mov    (%eax),%al
  801e9c:	0f b6 c0             	movzbl %al,%eax
  801e9f:	29 c2                	sub    %eax,%edx
  801ea1:	89 d0                	mov    %edx,%eax
  801ea3:	eb 18                	jmp    801ebd <memcmp+0x50>
		s1++, s2++;
  801ea5:	ff 45 fc             	incl   -0x4(%ebp)
  801ea8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801eab:	8b 45 10             	mov    0x10(%ebp),%eax
  801eae:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eb1:	89 55 10             	mov    %edx,0x10(%ebp)
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	75 c9                	jne    801e81 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecb:	01 d0                	add    %edx,%eax
  801ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801ed0:	eb 15                	jmp    801ee7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	8a 00                	mov    (%eax),%al
  801ed7:	0f b6 d0             	movzbl %al,%edx
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	0f b6 c0             	movzbl %al,%eax
  801ee0:	39 c2                	cmp    %eax,%edx
  801ee2:	74 0d                	je     801ef1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ee4:	ff 45 08             	incl   0x8(%ebp)
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801eed:	72 e3                	jb     801ed2 <memfind+0x13>
  801eef:	eb 01                	jmp    801ef2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ef1:	90                   	nop
	return (void *) s;
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801efd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f0b:	eb 03                	jmp    801f10 <strtol+0x19>
		s++;
  801f0d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	8a 00                	mov    (%eax),%al
  801f15:	3c 20                	cmp    $0x20,%al
  801f17:	74 f4                	je     801f0d <strtol+0x16>
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8a 00                	mov    (%eax),%al
  801f1e:	3c 09                	cmp    $0x9,%al
  801f20:	74 eb                	je     801f0d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8a 00                	mov    (%eax),%al
  801f27:	3c 2b                	cmp    $0x2b,%al
  801f29:	75 05                	jne    801f30 <strtol+0x39>
		s++;
  801f2b:	ff 45 08             	incl   0x8(%ebp)
  801f2e:	eb 13                	jmp    801f43 <strtol+0x4c>
	else if (*s == '-')
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8a 00                	mov    (%eax),%al
  801f35:	3c 2d                	cmp    $0x2d,%al
  801f37:	75 0a                	jne    801f43 <strtol+0x4c>
		s++, neg = 1;
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f47:	74 06                	je     801f4f <strtol+0x58>
  801f49:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f4d:	75 20                	jne    801f6f <strtol+0x78>
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	8a 00                	mov    (%eax),%al
  801f54:	3c 30                	cmp    $0x30,%al
  801f56:	75 17                	jne    801f6f <strtol+0x78>
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	40                   	inc    %eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 78                	cmp    $0x78,%al
  801f60:	75 0d                	jne    801f6f <strtol+0x78>
		s += 2, base = 16;
  801f62:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801f66:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801f6d:	eb 28                	jmp    801f97 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801f6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f73:	75 15                	jne    801f8a <strtol+0x93>
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8a 00                	mov    (%eax),%al
  801f7a:	3c 30                	cmp    $0x30,%al
  801f7c:	75 0c                	jne    801f8a <strtol+0x93>
		s++, base = 8;
  801f7e:	ff 45 08             	incl   0x8(%ebp)
  801f81:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801f88:	eb 0d                	jmp    801f97 <strtol+0xa0>
	else if (base == 0)
  801f8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8e:	75 07                	jne    801f97 <strtol+0xa0>
		base = 10;
  801f90:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8a 00                	mov    (%eax),%al
  801f9c:	3c 2f                	cmp    $0x2f,%al
  801f9e:	7e 19                	jle    801fb9 <strtol+0xc2>
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	8a 00                	mov    (%eax),%al
  801fa5:	3c 39                	cmp    $0x39,%al
  801fa7:	7f 10                	jg     801fb9 <strtol+0xc2>
			dig = *s - '0';
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	8a 00                	mov    (%eax),%al
  801fae:	0f be c0             	movsbl %al,%eax
  801fb1:	83 e8 30             	sub    $0x30,%eax
  801fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb7:	eb 42                	jmp    801ffb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	8a 00                	mov    (%eax),%al
  801fbe:	3c 60                	cmp    $0x60,%al
  801fc0:	7e 19                	jle    801fdb <strtol+0xe4>
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8a 00                	mov    (%eax),%al
  801fc7:	3c 7a                	cmp    $0x7a,%al
  801fc9:	7f 10                	jg     801fdb <strtol+0xe4>
			dig = *s - 'a' + 10;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8a 00                	mov    (%eax),%al
  801fd0:	0f be c0             	movsbl %al,%eax
  801fd3:	83 e8 57             	sub    $0x57,%eax
  801fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd9:	eb 20                	jmp    801ffb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	8a 00                	mov    (%eax),%al
  801fe0:	3c 40                	cmp    $0x40,%al
  801fe2:	7e 39                	jle    80201d <strtol+0x126>
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	8a 00                	mov    (%eax),%al
  801fe9:	3c 5a                	cmp    $0x5a,%al
  801feb:	7f 30                	jg     80201d <strtol+0x126>
			dig = *s - 'A' + 10;
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	8a 00                	mov    (%eax),%al
  801ff2:	0f be c0             	movsbl %al,%eax
  801ff5:	83 e8 37             	sub    $0x37,%eax
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	3b 45 10             	cmp    0x10(%ebp),%eax
  802001:	7d 19                	jge    80201c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802003:	ff 45 08             	incl   0x8(%ebp)
  802006:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802009:	0f af 45 10          	imul   0x10(%ebp),%eax
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	01 d0                	add    %edx,%eax
  802014:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802017:	e9 7b ff ff ff       	jmp    801f97 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80201c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80201d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802021:	74 08                	je     80202b <strtol+0x134>
		*endptr = (char *) s;
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	8b 55 08             	mov    0x8(%ebp),%edx
  802029:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80202b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202f:	74 07                	je     802038 <strtol+0x141>
  802031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802034:	f7 d8                	neg    %eax
  802036:	eb 03                	jmp    80203b <strtol+0x144>
  802038:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <ltostr>:

void
ltostr(long value, char *str)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80204a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802055:	79 13                	jns    80206a <ltostr+0x2d>
	{
		neg = 1;
  802057:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80205e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802061:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802064:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802067:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802072:	99                   	cltd   
  802073:	f7 f9                	idiv   %ecx
  802075:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207b:	8d 50 01             	lea    0x1(%eax),%edx
  80207e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802081:	89 c2                	mov    %eax,%edx
  802083:	8b 45 0c             	mov    0xc(%ebp),%eax
  802086:	01 d0                	add    %edx,%eax
  802088:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208b:	83 c2 30             	add    $0x30,%edx
  80208e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802090:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802093:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802098:	f7 e9                	imul   %ecx
  80209a:	c1 fa 02             	sar    $0x2,%edx
  80209d:	89 c8                	mov    %ecx,%eax
  80209f:	c1 f8 1f             	sar    $0x1f,%eax
  8020a2:	29 c2                	sub    %eax,%edx
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8020a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ad:	75 bb                	jne    80206a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8020af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8020b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020b9:	48                   	dec    %eax
  8020ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8020bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c1:	74 3d                	je     802100 <ltostr+0xc3>
		start = 1 ;
  8020c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8020ca:	eb 34                	jmp    802100 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8020cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	01 d0                	add    %edx,%eax
  8020d4:	8a 00                	mov    (%eax),%al
  8020d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	01 c2                	add    %eax,%edx
  8020e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	01 c8                	add    %ecx,%eax
  8020e9:	8a 00                	mov    (%eax),%al
  8020eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8020ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f3:	01 c2                	add    %eax,%edx
  8020f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8020f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8020fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8020fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802106:	7c c4                	jl     8020cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802108:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80210b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210e:	01 d0                	add    %edx,%eax
  802110:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802113:	90                   	nop
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80211c:	ff 75 08             	pushl  0x8(%ebp)
  80211f:	e8 73 fa ff ff       	call   801b97 <strlen>
  802124:	83 c4 04             	add    $0x4,%esp
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	e8 65 fa ff ff       	call   801b97 <strlen>
  802132:	83 c4 04             	add    $0x4,%esp
  802135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80213f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802146:	eb 17                	jmp    80215f <strcconcat+0x49>
		final[s] = str1[s] ;
  802148:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214b:	8b 45 10             	mov    0x10(%ebp),%eax
  80214e:	01 c2                	add    %eax,%edx
  802150:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	01 c8                	add    %ecx,%eax
  802158:	8a 00                	mov    (%eax),%al
  80215a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80215c:	ff 45 fc             	incl   -0x4(%ebp)
  80215f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802162:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802165:	7c e1                	jl     802148 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80216e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802175:	eb 1f                	jmp    802196 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217a:	8d 50 01             	lea    0x1(%eax),%edx
  80217d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802180:	89 c2                	mov    %eax,%edx
  802182:	8b 45 10             	mov    0x10(%ebp),%eax
  802185:	01 c2                	add    %eax,%edx
  802187:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	01 c8                	add    %ecx,%eax
  80218f:	8a 00                	mov    (%eax),%al
  802191:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802193:	ff 45 f8             	incl   -0x8(%ebp)
  802196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802199:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80219c:	7c d9                	jl     802177 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80219e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8021a9:	90                   	nop
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8021af:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8021b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	01 d0                	add    %edx,%eax
  8021c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021cf:	eb 0c                	jmp    8021dd <strsplit+0x31>
			*string++ = 0;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8d 50 01             	lea    0x1(%eax),%edx
  8021d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8021da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8a 00                	mov    (%eax),%al
  8021e2:	84 c0                	test   %al,%al
  8021e4:	74 18                	je     8021fe <strsplit+0x52>
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8a 00                	mov    (%eax),%al
  8021eb:	0f be c0             	movsbl %al,%eax
  8021ee:	50                   	push   %eax
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	e8 32 fb ff ff       	call   801d29 <strchr>
  8021f7:	83 c4 08             	add    $0x8,%esp
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	75 d3                	jne    8021d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	8a 00                	mov    (%eax),%al
  802203:	84 c0                	test   %al,%al
  802205:	74 5a                	je     802261 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802207:	8b 45 14             	mov    0x14(%ebp),%eax
  80220a:	8b 00                	mov    (%eax),%eax
  80220c:	83 f8 0f             	cmp    $0xf,%eax
  80220f:	75 07                	jne    802218 <strsplit+0x6c>
		{
			return 0;
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
  802216:	eb 66                	jmp    80227e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802218:	8b 45 14             	mov    0x14(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	8d 48 01             	lea    0x1(%eax),%ecx
  802220:	8b 55 14             	mov    0x14(%ebp),%edx
  802223:	89 0a                	mov    %ecx,(%edx)
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 c2                	add    %eax,%edx
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802236:	eb 03                	jmp    80223b <strsplit+0x8f>
			string++;
  802238:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8a 00                	mov    (%eax),%al
  802240:	84 c0                	test   %al,%al
  802242:	74 8b                	je     8021cf <strsplit+0x23>
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8a 00                	mov    (%eax),%al
  802249:	0f be c0             	movsbl %al,%eax
  80224c:	50                   	push   %eax
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	e8 d4 fa ff ff       	call   801d29 <strchr>
  802255:	83 c4 08             	add    $0x8,%esp
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 dc                	je     802238 <strsplit+0x8c>
			string++;
	}
  80225c:	e9 6e ff ff ff       	jmp    8021cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802261:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802262:	8b 45 14             	mov    0x14(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80226e:	8b 45 10             	mov    0x10(%ebp),%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 88 5d 80 00       	push   $0x805d88
  80228e:	68 3f 01 00 00       	push   $0x13f
  802293:	68 aa 5d 80 00       	push   $0x805daa
  802298:	e8 a9 ef ff ff       	call   801246 <_panic>

0080229d <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8022a3:	83 ec 0c             	sub    $0xc,%esp
  8022a6:	ff 75 08             	pushl  0x8(%ebp)
  8022a9:	e8 f8 0a 00 00       	call   802da6 <sys_sbrk>
  8022ae:	83 c4 10             	add    $0x10,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8022b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bd:	75 0a                	jne    8022c9 <malloc+0x16>
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	e9 07 02 00 00       	jmp    8024d0 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8022c9:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8022d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022d6:	01 d0                	add    %edx,%eax
  8022d8:	48                   	dec    %eax
  8022d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022df:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e4:	f7 75 dc             	divl   -0x24(%ebp)
  8022e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ea:	29 d0                	sub    %edx,%eax
  8022ec:	c1 e8 0c             	shr    $0xc,%eax
  8022ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8022f2:	a1 20 60 80 00       	mov    0x806020,%eax
  8022f7:	8b 40 78             	mov    0x78(%eax),%eax
  8022fa:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8022ff:	29 c2                	sub    %eax,%edx
  802301:	89 d0                	mov    %edx,%eax
  802303:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802306:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802309:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80230e:	c1 e8 0c             	shr    $0xc,%eax
  802311:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  802314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80231b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802322:	77 42                	ja     802366 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802324:	e8 01 09 00 00       	call   802c2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 16                	je     802343 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	e8 41 0e 00 00       	call   803179 <alloc_block_FF>
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	e9 8a 01 00 00       	jmp    8024cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802343:	e8 13 09 00 00       	call   802c5b <sys_isUHeapPlacementStrategyBESTFIT>
  802348:	85 c0                	test   %eax,%eax
  80234a:	0f 84 7d 01 00 00    	je     8024cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	e8 da 12 00 00       	call   803635 <alloc_block_BF>
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802361:	e9 67 01 00 00       	jmp    8024cd <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  802366:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802369:	48                   	dec    %eax
  80236a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80236d:	0f 86 53 01 00 00    	jbe    8024c6 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  802373:	a1 20 60 80 00       	mov    0x806020,%eax
  802378:	8b 40 78             	mov    0x78(%eax),%eax
  80237b:	05 00 10 00 00       	add    $0x1000,%eax
  802380:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  802383:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80238a:	e9 de 00 00 00       	jmp    80246d <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80238f:	a1 20 60 80 00       	mov    0x806020,%eax
  802394:	8b 40 78             	mov    0x78(%eax),%eax
  802397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239a:	29 c2                	sub    %eax,%edx
  80239c:	89 d0                	mov    %edx,%eax
  80239e:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023a3:	c1 e8 0c             	shr    $0xc,%eax
  8023a6:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	0f 85 ab 00 00 00    	jne    802460 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	05 00 10 00 00       	add    $0x1000,%eax
  8023bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8023c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  8023c7:	eb 47                	jmp    802410 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8023c9:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8023d0:	76 0a                	jbe    8023dc <malloc+0x129>
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d7:	e9 f4 00 00 00       	jmp    8024d0 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8023dc:	a1 20 60 80 00       	mov    0x806020,%eax
  8023e1:	8b 40 78             	mov    0x78(%eax),%eax
  8023e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e7:	29 c2                	sub    %eax,%edx
  8023e9:	89 d0                	mov    %edx,%eax
  8023eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023f0:	c1 e8 0c             	shr    $0xc,%eax
  8023f3:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 08                	je     802406 <malloc+0x153>
					{
						
						i = j;
  8023fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802401:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  802404:	eb 5a                	jmp    802460 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802406:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80240d:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  802410:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802413:	48                   	dec    %eax
  802414:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802417:	77 b0                	ja     8023c9 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  802419:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  802420:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802427:	eb 2f                	jmp    802458 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  802429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242c:	c1 e0 0c             	shl    $0xc,%eax
  80242f:	89 c2                	mov    %eax,%edx
  802431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802434:	01 c2                	add    %eax,%edx
  802436:	a1 20 60 80 00       	mov    0x806020,%eax
  80243b:	8b 40 78             	mov    0x78(%eax),%eax
  80243e:	29 c2                	sub    %eax,%edx
  802440:	89 d0                	mov    %edx,%eax
  802442:	2d 00 10 00 00       	sub    $0x1000,%eax
  802447:	c1 e8 0c             	shr    $0xc,%eax
  80244a:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
  802451:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  802455:	ff 45 e0             	incl   -0x20(%ebp)
  802458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80245e:	72 c9                	jb     802429 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  802460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802464:	75 16                	jne    80247c <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  802466:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80246d:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802474:	0f 86 15 ff ff ff    	jbe    80238f <malloc+0xdc>
  80247a:	eb 01                	jmp    80247d <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  80247c:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80247d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802481:	75 07                	jne    80248a <malloc+0x1d7>
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	eb 46                	jmp    8024d0 <malloc+0x21d>
		ptr = (void*)i;
  80248a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  802490:	a1 20 60 80 00       	mov    0x806020,%eax
  802495:	8b 40 78             	mov    0x78(%eax),%eax
  802498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249b:	29 c2                	sub    %eax,%edx
  80249d:	89 d0                	mov    %edx,%eax
  80249f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024a4:	c1 e8 0c             	shr    $0xc,%eax
  8024a7:	89 c2                	mov    %eax,%edx
  8024a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ac:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8024b3:	83 ec 08             	sub    $0x8,%esp
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8024bc:	e8 1c 09 00 00       	call   802ddd <sys_allocate_user_mem>
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	eb 07                	jmp    8024cd <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cb:	eb 03                	jmp    8024d0 <malloc+0x21d>
	}
	return ptr;
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8024d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8024dd:	8b 40 78             	mov    0x78(%eax),%eax
  8024e0:	05 00 10 00 00       	add    $0x1000,%eax
  8024e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8024e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8024ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8024f4:	8b 50 78             	mov    0x78(%eax),%edx
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	39 c2                	cmp    %eax,%edx
  8024fc:	76 24                	jbe    802522 <free+0x50>
		size = get_block_size(va);
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	ff 75 08             	pushl  0x8(%ebp)
  802504:	e8 f0 08 00 00       	call   802df9 <get_block_size>
  802509:	83 c4 10             	add    $0x10,%esp
  80250c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 00 1b 00 00       	call   80401a <free_block>
  80251a:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80251d:	e9 ac 00 00 00       	jmp    8025ce <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802528:	0f 82 89 00 00 00    	jb     8025b7 <free+0xe5>
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802536:	77 7f                	ja     8025b7 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  802538:	8b 55 08             	mov    0x8(%ebp),%edx
  80253b:	a1 20 60 80 00       	mov    0x806020,%eax
  802540:	8b 40 78             	mov    0x78(%eax),%eax
  802543:	29 c2                	sub    %eax,%edx
  802545:	89 d0                	mov    %edx,%eax
  802547:	2d 00 10 00 00       	sub    $0x1000,%eax
  80254c:	c1 e8 0c             	shr    $0xc,%eax
  80254f:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  802556:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255c:	c1 e0 0c             	shl    $0xc,%eax
  80255f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  802562:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802569:	eb 42                	jmp    8025ad <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c1 e0 0c             	shl    $0xc,%eax
  802571:	89 c2                	mov    %eax,%edx
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	01 c2                	add    %eax,%edx
  802578:	a1 20 60 80 00       	mov    0x806020,%eax
  80257d:	8b 40 78             	mov    0x78(%eax),%eax
  802580:	29 c2                	sub    %eax,%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	2d 00 10 00 00       	sub    $0x1000,%eax
  802589:	c1 e8 0c             	shr    $0xc,%eax
  80258c:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  802593:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  802597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	83 ec 08             	sub    $0x8,%esp
  8025a0:	52                   	push   %edx
  8025a1:	50                   	push   %eax
  8025a2:	e8 1a 08 00 00       	call   802dc1 <sys_free_user_mem>
  8025a7:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8025aa:	ff 45 f4             	incl   -0xc(%ebp)
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025b3:	72 b6                	jb     80256b <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8025b5:	eb 17                	jmp    8025ce <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 b8 5d 80 00       	push   $0x805db8
  8025bf:	68 87 00 00 00       	push   $0x87
  8025c4:	68 e2 5d 80 00       	push   $0x805de2
  8025c9:	e8 78 ec ff ff       	call   801246 <_panic>
	}
}
  8025ce:	90                   	nop
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 28             	sub    $0x28,%esp
  8025d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025da:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8025dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025e1:	75 0a                	jne    8025ed <smalloc+0x1c>
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	e9 87 00 00 00       	jmp    802674 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8025ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8025fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	39 d0                	cmp    %edx,%eax
  802602:	73 02                	jae    802606 <smalloc+0x35>
  802604:	89 d0                	mov    %edx,%eax
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	50                   	push   %eax
  80260a:	e8 a4 fc ff ff       	call   8022b3 <malloc>
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802615:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802619:	75 07                	jne    802622 <smalloc+0x51>
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
  802620:	eb 52                	jmp    802674 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802622:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802626:	ff 75 ec             	pushl  -0x14(%ebp)
  802629:	50                   	push   %eax
  80262a:	ff 75 0c             	pushl  0xc(%ebp)
  80262d:	ff 75 08             	pushl  0x8(%ebp)
  802630:	e8 93 03 00 00       	call   8029c8 <sys_createSharedObject>
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80263b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80263f:	74 06                	je     802647 <smalloc+0x76>
  802641:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802645:	75 07                	jne    80264e <smalloc+0x7d>
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	eb 26                	jmp    802674 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80264e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802651:	a1 20 60 80 00       	mov    0x806020,%eax
  802656:	8b 40 78             	mov    0x78(%eax),%eax
  802659:	29 c2                	sub    %eax,%edx
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802662:	c1 e8 0c             	shr    $0xc,%eax
  802665:	89 c2                	mov    %eax,%edx
  802667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266a:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  802671:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80267c:	83 ec 08             	sub    $0x8,%esp
  80267f:	ff 75 0c             	pushl  0xc(%ebp)
  802682:	ff 75 08             	pushl  0x8(%ebp)
  802685:	e8 68 03 00 00       	call   8029f2 <sys_getSizeOfSharedObject>
  80268a:	83 c4 10             	add    $0x10,%esp
  80268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802690:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802694:	75 07                	jne    80269d <sget+0x27>
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	eb 7f                	jmp    80271c <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b0:	39 d0                	cmp    %edx,%eax
  8026b2:	73 02                	jae    8026b6 <sget+0x40>
  8026b4:	89 d0                	mov    %edx,%eax
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	50                   	push   %eax
  8026ba:	e8 f4 fb ff ff       	call   8022b3 <malloc>
  8026bf:	83 c4 10             	add    $0x10,%esp
  8026c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8026c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c9:	75 07                	jne    8026d2 <sget+0x5c>
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	eb 4a                	jmp    80271c <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8026d8:	ff 75 0c             	pushl  0xc(%ebp)
  8026db:	ff 75 08             	pushl  0x8(%ebp)
  8026de:	e8 2c 03 00 00       	call   802a0f <sys_getSharedObject>
  8026e3:	83 c4 10             	add    $0x10,%esp
  8026e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8026e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8026f1:	8b 40 78             	mov    0x78(%eax),%eax
  8026f4:	29 c2                	sub    %eax,%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8026fd:	c1 e8 0c             	shr    $0xc,%eax
  802700:	89 c2                	mov    %eax,%edx
  802702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802705:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80270c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802710:	75 07                	jne    802719 <sget+0xa3>
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	eb 03                	jmp    80271c <sget+0xa6>
	return ptr;
  802719:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802724:	8b 55 08             	mov    0x8(%ebp),%edx
  802727:	a1 20 60 80 00       	mov    0x806020,%eax
  80272c:	8b 40 78             	mov    0x78(%eax),%eax
  80272f:	29 c2                	sub    %eax,%edx
  802731:	89 d0                	mov    %edx,%eax
  802733:	2d 00 10 00 00       	sub    $0x1000,%eax
  802738:	c1 e8 0c             	shr    $0xc,%eax
  80273b:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802745:	83 ec 08             	sub    $0x8,%esp
  802748:	ff 75 08             	pushl  0x8(%ebp)
  80274b:	ff 75 f4             	pushl  -0xc(%ebp)
  80274e:	e8 db 02 00 00       	call   802a2e <sys_freeSharedObject>
  802753:	83 c4 10             	add    $0x10,%esp
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802759:	90                   	nop
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 f0 5d 80 00       	push   $0x805df0
  80276a:	68 e4 00 00 00       	push   $0xe4
  80276f:	68 e2 5d 80 00       	push   $0x805de2
  802774:	e8 cd ea ff ff       	call   801246 <_panic>

00802779 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80277f:	83 ec 04             	sub    $0x4,%esp
  802782:	68 16 5e 80 00       	push   $0x805e16
  802787:	68 f0 00 00 00       	push   $0xf0
  80278c:	68 e2 5d 80 00       	push   $0x805de2
  802791:	e8 b0 ea ff ff       	call   801246 <_panic>

00802796 <shrink>:

}
void shrink(uint32 newSize)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	68 16 5e 80 00       	push   $0x805e16
  8027a4:	68 f5 00 00 00       	push   $0xf5
  8027a9:	68 e2 5d 80 00       	push   $0x805de2
  8027ae:	e8 93 ea ff ff       	call   801246 <_panic>

008027b3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	68 16 5e 80 00       	push   $0x805e16
  8027c1:	68 fa 00 00 00       	push   $0xfa
  8027c6:	68 e2 5d 80 00       	push   $0x805de2
  8027cb:	e8 76 ea ff ff       	call   801246 <_panic>

008027d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	57                   	push   %edi
  8027d4:	56                   	push   %esi
  8027d5:	53                   	push   %ebx
  8027d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027eb:	cd 30                	int    $0x30
  8027ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	5b                   	pop    %ebx
  8027f7:	5e                   	pop    %esi
  8027f8:	5f                   	pop    %edi
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    

008027fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	8b 45 10             	mov    0x10(%ebp),%eax
  802804:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802807:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	52                   	push   %edx
  802813:	ff 75 0c             	pushl  0xc(%ebp)
  802816:	50                   	push   %eax
  802817:	6a 00                	push   $0x0
  802819:	e8 b2 ff ff ff       	call   8027d0 <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	90                   	nop
  802822:	c9                   	leave  
  802823:	c3                   	ret    

00802824 <sys_cgetc>:

int
sys_cgetc(void)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 02                	push   $0x2
  802833:	e8 98 ff ff ff       	call   8027d0 <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 03                	push   $0x3
  80284c:	e8 7f ff ff ff       	call   8027d0 <syscall>
  802851:	83 c4 18             	add    $0x18,%esp
}
  802854:	90                   	nop
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 04                	push   $0x4
  802866:	e8 65 ff ff ff       	call   8027d0 <syscall>
  80286b:	83 c4 18             	add    $0x18,%esp
}
  80286e:	90                   	nop
  80286f:	c9                   	leave  
  802870:	c3                   	ret    

00802871 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802874:	8b 55 0c             	mov    0xc(%ebp),%edx
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	52                   	push   %edx
  802881:	50                   	push   %eax
  802882:	6a 08                	push   $0x8
  802884:	e8 47 ff ff ff       	call   8027d0 <syscall>
  802889:	83 c4 18             	add    $0x18,%esp
}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	56                   	push   %esi
  802892:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802893:	8b 75 18             	mov    0x18(%ebp),%esi
  802896:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802899:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80289c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	51                   	push   %ecx
  8028a5:	52                   	push   %edx
  8028a6:	50                   	push   %eax
  8028a7:	6a 09                	push   $0x9
  8028a9:	e8 22 ff ff ff       	call   8027d0 <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
}
  8028b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028b4:	5b                   	pop    %ebx
  8028b5:	5e                   	pop    %esi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    

008028b8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	6a 00                	push   $0x0
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	52                   	push   %edx
  8028c8:	50                   	push   %eax
  8028c9:	6a 0a                	push   $0xa
  8028cb:	e8 00 ff ff ff       	call   8027d0 <syscall>
  8028d0:	83 c4 18             	add    $0x18,%esp
}
  8028d3:	c9                   	leave  
  8028d4:	c3                   	ret    

008028d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	ff 75 0c             	pushl  0xc(%ebp)
  8028e1:	ff 75 08             	pushl  0x8(%ebp)
  8028e4:	6a 0b                	push   $0xb
  8028e6:	e8 e5 fe ff ff       	call   8027d0 <syscall>
  8028eb:	83 c4 18             	add    $0x18,%esp
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 0c                	push   $0xc
  8028ff:	e8 cc fe ff ff       	call   8027d0 <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	6a 00                	push   $0x0
  802916:	6a 0d                	push   $0xd
  802918:	e8 b3 fe ff ff       	call   8027d0 <syscall>
  80291d:	83 c4 18             	add    $0x18,%esp
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 0e                	push   $0xe
  802931:	e8 9a fe ff ff       	call   8027d0 <syscall>
  802936:	83 c4 18             	add    $0x18,%esp
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 0f                	push   $0xf
  80294a:	e8 81 fe ff ff       	call   8027d0 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	ff 75 08             	pushl  0x8(%ebp)
  802962:	6a 10                	push   $0x10
  802964:	e8 67 fe ff ff       	call   8027d0 <syscall>
  802969:	83 c4 18             	add    $0x18,%esp
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 11                	push   $0x11
  80297d:	e8 4e fe ff ff       	call   8027d0 <syscall>
  802982:	83 c4 18             	add    $0x18,%esp
}
  802985:	90                   	nop
  802986:	c9                   	leave  
  802987:	c3                   	ret    

00802988 <sys_cputc>:

void
sys_cputc(const char c)
{
  802988:	55                   	push   %ebp
  802989:	89 e5                	mov    %esp,%ebp
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802994:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	50                   	push   %eax
  8029a1:	6a 01                	push   $0x1
  8029a3:	e8 28 fe ff ff       	call   8027d0 <syscall>
  8029a8:	83 c4 18             	add    $0x18,%esp
}
  8029ab:	90                   	nop
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 14                	push   $0x14
  8029bd:	e8 0e fe ff ff       	call   8027d0 <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	90                   	nop
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8029d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	6a 00                	push   $0x0
  8029e0:	51                   	push   %ecx
  8029e1:	52                   	push   %edx
  8029e2:	ff 75 0c             	pushl  0xc(%ebp)
  8029e5:	50                   	push   %eax
  8029e6:	6a 15                	push   $0x15
  8029e8:	e8 e3 fd ff ff       	call   8027d0 <syscall>
  8029ed:	83 c4 18             	add    $0x18,%esp
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8029f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	52                   	push   %edx
  802a02:	50                   	push   %eax
  802a03:	6a 16                	push   $0x16
  802a05:	e8 c6 fd ff ff       	call   8027d0 <syscall>
  802a0a:	83 c4 18             	add    $0x18,%esp
}
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    

00802a0f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a0f:	55                   	push   %ebp
  802a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	51                   	push   %ecx
  802a20:	52                   	push   %edx
  802a21:	50                   	push   %eax
  802a22:	6a 17                	push   $0x17
  802a24:	e8 a7 fd ff ff       	call   8027d0 <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 00                	push   $0x0
  802a3d:	52                   	push   %edx
  802a3e:	50                   	push   %eax
  802a3f:	6a 18                	push   $0x18
  802a41:	e8 8a fd ff ff       	call   8027d0 <syscall>
  802a46:	83 c4 18             	add    $0x18,%esp
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	6a 00                	push   $0x0
  802a53:	ff 75 14             	pushl  0x14(%ebp)
  802a56:	ff 75 10             	pushl  0x10(%ebp)
  802a59:	ff 75 0c             	pushl  0xc(%ebp)
  802a5c:	50                   	push   %eax
  802a5d:	6a 19                	push   $0x19
  802a5f:	e8 6c fd ff ff       	call   8027d0 <syscall>
  802a64:	83 c4 18             	add    $0x18,%esp
}
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	50                   	push   %eax
  802a78:	6a 1a                	push   $0x1a
  802a7a:	e8 51 fd ff ff       	call   8027d0 <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
}
  802a82:	90                   	nop
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	50                   	push   %eax
  802a94:	6a 1b                	push   $0x1b
  802a96:	e8 35 fd ff ff       	call   8027d0 <syscall>
  802a9b:	83 c4 18             	add    $0x18,%esp
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 05                	push   $0x5
  802aaf:	e8 1c fd ff ff       	call   8027d0 <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
}
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 06                	push   $0x6
  802ac8:	e8 03 fd ff ff       	call   8027d0 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 07                	push   $0x7
  802ae1:	e8 ea fc ff ff       	call   8027d0 <syscall>
  802ae6:	83 c4 18             	add    $0x18,%esp
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    

00802aeb <sys_exit_env>:


void sys_exit_env(void)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 1c                	push   $0x1c
  802afa:	e8 d1 fc ff ff       	call   8027d0 <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
}
  802b02:	90                   	nop
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b0e:	8d 50 04             	lea    0x4(%eax),%edx
  802b11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	52                   	push   %edx
  802b1b:	50                   	push   %eax
  802b1c:	6a 1d                	push   $0x1d
  802b1e:	e8 ad fc ff ff       	call   8027d0 <syscall>
  802b23:	83 c4 18             	add    $0x18,%esp
	return result;
  802b26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b2f:	89 01                	mov    %eax,(%ecx)
  802b31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	c9                   	leave  
  802b38:	c2 04 00             	ret    $0x4

00802b3b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	ff 75 10             	pushl  0x10(%ebp)
  802b45:	ff 75 0c             	pushl  0xc(%ebp)
  802b48:	ff 75 08             	pushl  0x8(%ebp)
  802b4b:	6a 13                	push   $0x13
  802b4d:	e8 7e fc ff ff       	call   8027d0 <syscall>
  802b52:	83 c4 18             	add    $0x18,%esp
	return ;
  802b55:	90                   	nop
}
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

00802b58 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 1e                	push   $0x1e
  802b67:	e8 64 fc ff ff       	call   8027d0 <syscall>
  802b6c:	83 c4 18             	add    $0x18,%esp
}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
  802b74:	83 ec 04             	sub    $0x4,%esp
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b81:	6a 00                	push   $0x0
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	50                   	push   %eax
  802b8a:	6a 1f                	push   $0x1f
  802b8c:	e8 3f fc ff ff       	call   8027d0 <syscall>
  802b91:	83 c4 18             	add    $0x18,%esp
	return ;
  802b94:	90                   	nop
}
  802b95:	c9                   	leave  
  802b96:	c3                   	ret    

00802b97 <rsttst>:
void rsttst()
{
  802b97:	55                   	push   %ebp
  802b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b9a:	6a 00                	push   $0x0
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 00                	push   $0x0
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 21                	push   $0x21
  802ba6:	e8 25 fc ff ff       	call   8027d0 <syscall>
  802bab:	83 c4 18             	add    $0x18,%esp
	return ;
  802bae:	90                   	nop
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  802bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bbd:	8b 55 18             	mov    0x18(%ebp),%edx
  802bc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bc4:	52                   	push   %edx
  802bc5:	50                   	push   %eax
  802bc6:	ff 75 10             	pushl  0x10(%ebp)
  802bc9:	ff 75 0c             	pushl  0xc(%ebp)
  802bcc:	ff 75 08             	pushl  0x8(%ebp)
  802bcf:	6a 20                	push   $0x20
  802bd1:	e8 fa fb ff ff       	call   8027d0 <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd9:	90                   	nop
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <chktst>:
void chktst(uint32 n)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	ff 75 08             	pushl  0x8(%ebp)
  802bea:	6a 22                	push   $0x22
  802bec:	e8 df fb ff ff       	call   8027d0 <syscall>
  802bf1:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf4:	90                   	nop
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <inctst>:

void inctst()
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	6a 23                	push   $0x23
  802c06:	e8 c5 fb ff ff       	call   8027d0 <syscall>
  802c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c0e:	90                   	nop
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <gettst>:
uint32 gettst()
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 24                	push   $0x24
  802c20:	e8 ab fb ff ff       	call   8027d0 <syscall>
  802c25:	83 c4 18             	add    $0x18,%esp
}
  802c28:	c9                   	leave  
  802c29:	c3                   	ret    

00802c2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c2a:	55                   	push   %ebp
  802c2b:	89 e5                	mov    %esp,%ebp
  802c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 25                	push   $0x25
  802c3c:	e8 8f fb ff ff       	call   8027d0 <syscall>
  802c41:	83 c4 18             	add    $0x18,%esp
  802c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c4b:	75 07                	jne    802c54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c52:	eb 05                	jmp    802c59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    

00802c5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
  802c5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c61:	6a 00                	push   $0x0
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 25                	push   $0x25
  802c6d:	e8 5e fb ff ff       	call   8027d0 <syscall>
  802c72:	83 c4 18             	add    $0x18,%esp
  802c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c7c:	75 07                	jne    802c85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c83:	eb 05                	jmp    802c8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 25                	push   $0x25
  802c9e:	e8 2d fb ff ff       	call   8027d0 <syscall>
  802ca3:	83 c4 18             	add    $0x18,%esp
  802ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802ca9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802cad:	75 07                	jne    802cb6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802caf:	b8 01 00 00 00       	mov    $0x1,%eax
  802cb4:	eb 05                	jmp    802cbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
  802cc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 00                	push   $0x0
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 25                	push   $0x25
  802ccf:	e8 fc fa ff ff       	call   8027d0 <syscall>
  802cd4:	83 c4 18             	add    $0x18,%esp
  802cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802cda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802cde:	75 07                	jne    802ce7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ce0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce5:	eb 05                	jmp    802cec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	ff 75 08             	pushl  0x8(%ebp)
  802cfc:	6a 26                	push   $0x26
  802cfe:	e8 cd fa ff ff       	call   8027d0 <syscall>
  802d03:	83 c4 18             	add    $0x18,%esp
	return ;
  802d06:	90                   	nop
}
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
  802d0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	6a 00                	push   $0x0
  802d1b:	53                   	push   %ebx
  802d1c:	51                   	push   %ecx
  802d1d:	52                   	push   %edx
  802d1e:	50                   	push   %eax
  802d1f:	6a 27                	push   $0x27
  802d21:	e8 aa fa ff ff       	call   8027d0 <syscall>
  802d26:	83 c4 18             	add    $0x18,%esp
}
  802d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d2c:	c9                   	leave  
  802d2d:	c3                   	ret    

00802d2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	52                   	push   %edx
  802d3e:	50                   	push   %eax
  802d3f:	6a 28                	push   $0x28
  802d41:	e8 8a fa ff ff       	call   8027d0 <syscall>
  802d46:	83 c4 18             	add    $0x18,%esp
}
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	6a 00                	push   $0x0
  802d59:	51                   	push   %ecx
  802d5a:	ff 75 10             	pushl  0x10(%ebp)
  802d5d:	52                   	push   %edx
  802d5e:	50                   	push   %eax
  802d5f:	6a 29                	push   $0x29
  802d61:	e8 6a fa ff ff       	call   8027d0 <syscall>
  802d66:	83 c4 18             	add    $0x18,%esp
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	ff 75 10             	pushl  0x10(%ebp)
  802d75:	ff 75 0c             	pushl  0xc(%ebp)
  802d78:	ff 75 08             	pushl  0x8(%ebp)
  802d7b:	6a 12                	push   $0x12
  802d7d:	e8 4e fa ff ff       	call   8027d0 <syscall>
  802d82:	83 c4 18             	add    $0x18,%esp
	return ;
  802d85:	90                   	nop
}
  802d86:	c9                   	leave  
  802d87:	c3                   	ret    

00802d88 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d88:	55                   	push   %ebp
  802d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	52                   	push   %edx
  802d98:	50                   	push   %eax
  802d99:	6a 2a                	push   $0x2a
  802d9b:	e8 30 fa ff ff       	call   8027d0 <syscall>
  802da0:	83 c4 18             	add    $0x18,%esp
	return;
  802da3:	90                   	nop
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	50                   	push   %eax
  802db5:	6a 2b                	push   $0x2b
  802db7:	e8 14 fa ff ff       	call   8027d0 <syscall>
  802dbc:	83 c4 18             	add    $0x18,%esp
}
  802dbf:	c9                   	leave  
  802dc0:	c3                   	ret    

00802dc1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	ff 75 0c             	pushl  0xc(%ebp)
  802dcd:	ff 75 08             	pushl  0x8(%ebp)
  802dd0:	6a 2c                	push   $0x2c
  802dd2:	e8 f9 f9 ff ff       	call   8027d0 <syscall>
  802dd7:	83 c4 18             	add    $0x18,%esp
	return;
  802dda:	90                   	nop
}
  802ddb:	c9                   	leave  
  802ddc:	c3                   	ret    

00802ddd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ddd:	55                   	push   %ebp
  802dde:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	ff 75 0c             	pushl  0xc(%ebp)
  802de9:	ff 75 08             	pushl  0x8(%ebp)
  802dec:	6a 2d                	push   $0x2d
  802dee:	e8 dd f9 ff ff       	call   8027d0 <syscall>
  802df3:	83 c4 18             	add    $0x18,%esp
	return;
  802df6:	90                   	nop
}
  802df7:	c9                   	leave  
  802df8:	c3                   	ret    

00802df9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802df9:	55                   	push   %ebp
  802dfa:	89 e5                	mov    %esp,%ebp
  802dfc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	83 e8 04             	sub    $0x4,%eax
  802e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    

00802e12 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
  802e15:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	83 e8 04             	sub    $0x4,%eax
  802e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	83 e0 01             	and    $0x1,%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	0f 94 c0             	sete   %al
}
  802e2e:	c9                   	leave  
  802e2f:	c3                   	ret    

00802e30 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802e36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e40:	83 f8 02             	cmp    $0x2,%eax
  802e43:	74 2b                	je     802e70 <alloc_block+0x40>
  802e45:	83 f8 02             	cmp    $0x2,%eax
  802e48:	7f 07                	jg     802e51 <alloc_block+0x21>
  802e4a:	83 f8 01             	cmp    $0x1,%eax
  802e4d:	74 0e                	je     802e5d <alloc_block+0x2d>
  802e4f:	eb 58                	jmp    802ea9 <alloc_block+0x79>
  802e51:	83 f8 03             	cmp    $0x3,%eax
  802e54:	74 2d                	je     802e83 <alloc_block+0x53>
  802e56:	83 f8 04             	cmp    $0x4,%eax
  802e59:	74 3b                	je     802e96 <alloc_block+0x66>
  802e5b:	eb 4c                	jmp    802ea9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	ff 75 08             	pushl  0x8(%ebp)
  802e63:	e8 11 03 00 00       	call   803179 <alloc_block_FF>
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802e6e:	eb 4a                	jmp    802eba <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802e70:	83 ec 0c             	sub    $0xc,%esp
  802e73:	ff 75 08             	pushl  0x8(%ebp)
  802e76:	e8 c7 19 00 00       	call   804842 <alloc_block_NF>
  802e7b:	83 c4 10             	add    $0x10,%esp
  802e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802e81:	eb 37                	jmp    802eba <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	ff 75 08             	pushl  0x8(%ebp)
  802e89:	e8 a7 07 00 00       	call   803635 <alloc_block_BF>
  802e8e:	83 c4 10             	add    $0x10,%esp
  802e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802e94:	eb 24                	jmp    802eba <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802e96:	83 ec 0c             	sub    $0xc,%esp
  802e99:	ff 75 08             	pushl  0x8(%ebp)
  802e9c:	e8 84 19 00 00       	call   804825 <alloc_block_WF>
  802ea1:	83 c4 10             	add    $0x10,%esp
  802ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ea7:	eb 11                	jmp    802eba <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	68 28 5e 80 00       	push   $0x805e28
  802eb1:	e8 4d e6 ff ff       	call   801503 <cprintf>
  802eb6:	83 c4 10             	add    $0x10,%esp
		break;
  802eb9:	90                   	nop
	}
	return va;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ebd:	c9                   	leave  
  802ebe:	c3                   	ret    

00802ebf <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802ebf:	55                   	push   %ebp
  802ec0:	89 e5                	mov    %esp,%ebp
  802ec2:	53                   	push   %ebx
  802ec3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ec6:	83 ec 0c             	sub    $0xc,%esp
  802ec9:	68 48 5e 80 00       	push   $0x805e48
  802ece:	e8 30 e6 ff ff       	call   801503 <cprintf>
  802ed3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802ed6:	83 ec 0c             	sub    $0xc,%esp
  802ed9:	68 73 5e 80 00       	push   $0x805e73
  802ede:	e8 20 e6 ff ff       	call   801503 <cprintf>
  802ee3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eec:	eb 37                	jmp    802f25 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802eee:	83 ec 0c             	sub    $0xc,%esp
  802ef1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ef4:	e8 19 ff ff ff       	call   802e12 <is_free_block>
  802ef9:	83 c4 10             	add    $0x10,%esp
  802efc:	0f be d8             	movsbl %al,%ebx
  802eff:	83 ec 0c             	sub    $0xc,%esp
  802f02:	ff 75 f4             	pushl  -0xc(%ebp)
  802f05:	e8 ef fe ff ff       	call   802df9 <get_block_size>
  802f0a:	83 c4 10             	add    $0x10,%esp
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	53                   	push   %ebx
  802f11:	50                   	push   %eax
  802f12:	68 8b 5e 80 00       	push   $0x805e8b
  802f17:	e8 e7 e5 ff ff       	call   801503 <cprintf>
  802f1c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	74 07                	je     802f32 <print_blocks_list+0x73>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	eb 05                	jmp    802f37 <print_blocks_list+0x78>
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	89 45 10             	mov    %eax,0x10(%ebp)
  802f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	75 ad                	jne    802eee <print_blocks_list+0x2f>
  802f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f45:	75 a7                	jne    802eee <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802f47:	83 ec 0c             	sub    $0xc,%esp
  802f4a:	68 48 5e 80 00       	push   $0x805e48
  802f4f:	e8 af e5 ff ff       	call   801503 <cprintf>
  802f54:	83 c4 10             	add    $0x10,%esp

}
  802f57:	90                   	nop
  802f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    

00802f5d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
  802f60:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f66:	83 e0 01             	and    $0x1,%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 03                	je     802f70 <initialize_dynamic_allocator+0x13>
  802f6d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802f70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f74:	0f 84 c7 01 00 00    	je     803141 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802f7a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802f81:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802f84:	8b 55 08             	mov    0x8(%ebp),%edx
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	01 d0                	add    %edx,%eax
  802f8c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802f91:	0f 87 ad 01 00 00    	ja     803144 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	0f 89 a5 01 00 00    	jns    803147 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa8:	01 d0                	add    %edx,%eax
  802faa:	83 e8 04             	sub    $0x4,%eax
  802fad:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802fb9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc1:	e9 87 00 00 00       	jmp    80304d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fca:	75 14                	jne    802fe0 <initialize_dynamic_allocator+0x83>
  802fcc:	83 ec 04             	sub    $0x4,%esp
  802fcf:	68 a3 5e 80 00       	push   $0x805ea3
  802fd4:	6a 79                	push   $0x79
  802fd6:	68 c1 5e 80 00       	push   $0x805ec1
  802fdb:	e8 66 e2 ff ff       	call   801246 <_panic>
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 10                	je     802ff9 <initialize_dynamic_allocator+0x9c>
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff1:	8b 52 04             	mov    0x4(%edx),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 0b                	jmp    803004 <initialize_dynamic_allocator+0xa7>
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	a3 30 60 80 00       	mov    %eax,0x806030
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 0f                	je     80301d <initialize_dynamic_allocator+0xc0>
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803017:	8b 12                	mov    (%edx),%edx
  803019:	89 10                	mov    %edx,(%eax)
  80301b:	eb 0a                	jmp    803027 <initialize_dynamic_allocator+0xca>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303a:	a1 38 60 80 00       	mov    0x806038,%eax
  80303f:	48                   	dec    %eax
  803040:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803045:	a1 34 60 80 00       	mov    0x806034,%eax
  80304a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803051:	74 07                	je     80305a <initialize_dynamic_allocator+0xfd>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	eb 05                	jmp    80305f <initialize_dynamic_allocator+0x102>
  80305a:	b8 00 00 00 00       	mov    $0x0,%eax
  80305f:	a3 34 60 80 00       	mov    %eax,0x806034
  803064:	a1 34 60 80 00       	mov    0x806034,%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	0f 85 55 ff ff ff    	jne    802fc6 <initialize_dynamic_allocator+0x69>
  803071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803075:	0f 85 4b ff ff ff    	jne    802fc6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803084:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80308a:	a1 44 60 80 00       	mov    0x806044,%eax
  80308f:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  803094:	a1 40 60 80 00       	mov    0x806040,%eax
  803099:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	83 c0 08             	add    $0x8,%eax
  8030a5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	83 c0 04             	add    $0x4,%eax
  8030ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b1:	83 ea 08             	sub    $0x8,%edx
  8030b4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8030b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	01 d0                	add    %edx,%eax
  8030be:	83 e8 08             	sub    $0x8,%eax
  8030c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c4:	83 ea 08             	sub    $0x8,%edx
  8030c7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8030dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030e0:	75 17                	jne    8030f9 <initialize_dynamic_allocator+0x19c>
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	68 dc 5e 80 00       	push   $0x805edc
  8030ea:	68 90 00 00 00       	push   $0x90
  8030ef:	68 c1 5e 80 00       	push   $0x805ec1
  8030f4:	e8 4d e1 ff ff       	call   801246 <_panic>
  8030f9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8030ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803102:	89 10                	mov    %edx,(%eax)
  803104:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 0d                	je     80311a <initialize_dynamic_allocator+0x1bd>
  80310d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803115:	89 50 04             	mov    %edx,0x4(%eax)
  803118:	eb 08                	jmp    803122 <initialize_dynamic_allocator+0x1c5>
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	a3 30 60 80 00       	mov    %eax,0x806030
  803122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803125:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803134:	a1 38 60 80 00       	mov    0x806038,%eax
  803139:	40                   	inc    %eax
  80313a:	a3 38 60 80 00       	mov    %eax,0x806038
  80313f:	eb 07                	jmp    803148 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803141:	90                   	nop
  803142:	eb 04                	jmp    803148 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803144:	90                   	nop
  803145:	eb 01                	jmp    803148 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803147:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  803148:	c9                   	leave  
  803149:	c3                   	ret    

0080314a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80314a:	55                   	push   %ebp
  80314b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80314d:	8b 45 10             	mov    0x10(%ebp),%eax
  803150:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8d 50 fc             	lea    -0x4(%eax),%edx
  803159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	83 e8 04             	sub    $0x4,%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	83 e0 fe             	and    $0xfffffffe,%eax
  803169:	8d 50 f8             	lea    -0x8(%eax),%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	01 c2                	add    %eax,%edx
  803171:	8b 45 0c             	mov    0xc(%ebp),%eax
  803174:	89 02                	mov    %eax,(%edx)
}
  803176:	90                   	nop
  803177:	5d                   	pop    %ebp
  803178:	c3                   	ret    

00803179 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803179:	55                   	push   %ebp
  80317a:	89 e5                	mov    %esp,%ebp
  80317c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	83 e0 01             	and    $0x1,%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 03                	je     80318c <alloc_block_FF+0x13>
  803189:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80318c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803190:	77 07                	ja     803199 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803192:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803199:	a1 24 60 80 00       	mov    0x806024,%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	75 73                	jne    803215 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	83 c0 10             	add    $0x10,%eax
  8031a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8031ab:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8031b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b8:	01 d0                	add    %edx,%eax
  8031ba:	48                   	dec    %eax
  8031bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c6:	f7 75 ec             	divl   -0x14(%ebp)
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	29 d0                	sub    %edx,%eax
  8031ce:	c1 e8 0c             	shr    $0xc,%eax
  8031d1:	83 ec 0c             	sub    $0xc,%esp
  8031d4:	50                   	push   %eax
  8031d5:	e8 c3 f0 ff ff       	call   80229d <sbrk>
  8031da:	83 c4 10             	add    $0x10,%esp
  8031dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8031e0:	83 ec 0c             	sub    $0xc,%esp
  8031e3:	6a 00                	push   $0x0
  8031e5:	e8 b3 f0 ff ff       	call   80229d <sbrk>
  8031ea:	83 c4 10             	add    $0x10,%esp
  8031ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8031f6:	83 ec 08             	sub    $0x8,%esp
  8031f9:	50                   	push   %eax
  8031fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031fd:	e8 5b fd ff ff       	call   802f5d <initialize_dynamic_allocator>
  803202:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803205:	83 ec 0c             	sub    $0xc,%esp
  803208:	68 ff 5e 80 00       	push   $0x805eff
  80320d:	e8 f1 e2 ff ff       	call   801503 <cprintf>
  803212:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803219:	75 0a                	jne    803225 <alloc_block_FF+0xac>
	        return NULL;
  80321b:	b8 00 00 00 00       	mov    $0x0,%eax
  803220:	e9 0e 04 00 00       	jmp    803633 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803225:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80322c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803234:	e9 f3 02 00 00       	jmp    80352c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80323f:	83 ec 0c             	sub    $0xc,%esp
  803242:	ff 75 bc             	pushl  -0x44(%ebp)
  803245:	e8 af fb ff ff       	call   802df9 <get_block_size>
  80324a:	83 c4 10             	add    $0x10,%esp
  80324d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	83 c0 08             	add    $0x8,%eax
  803256:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803259:	0f 87 c5 02 00 00    	ja     803524 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	83 c0 18             	add    $0x18,%eax
  803265:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803268:	0f 87 19 02 00 00    	ja     803487 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80326e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803271:	2b 45 08             	sub    0x8(%ebp),%eax
  803274:	83 e8 08             	sub    $0x8,%eax
  803277:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8d 50 08             	lea    0x8(%eax),%edx
  803280:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803283:	01 d0                	add    %edx,%eax
  803285:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	83 c0 08             	add    $0x8,%eax
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	6a 01                	push   $0x1
  803293:	50                   	push   %eax
  803294:	ff 75 bc             	pushl  -0x44(%ebp)
  803297:	e8 ae fe ff ff       	call   80314a <set_block_data>
  80329c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a2:	8b 40 04             	mov    0x4(%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	75 68                	jne    803311 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032a9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032ad:	75 17                	jne    8032c6 <alloc_block_FF+0x14d>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 dc 5e 80 00       	push   $0x805edc
  8032b7:	68 d7 00 00 00       	push   $0xd7
  8032bc:	68 c1 5e 80 00       	push   $0x805ec1
  8032c1:	e8 80 df ff ff       	call   801246 <_panic>
  8032c6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8032cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032cf:	89 10                	mov    %edx,(%eax)
  8032d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0d                	je     8032e7 <alloc_block_FF+0x16e>
  8032da:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8032df:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032e2:	89 50 04             	mov    %edx,0x4(%eax)
  8032e5:	eb 08                	jmp    8032ef <alloc_block_FF+0x176>
  8032e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032ea:	a3 30 60 80 00       	mov    %eax,0x806030
  8032ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032f2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 38 60 80 00       	mov    0x806038,%eax
  803306:	40                   	inc    %eax
  803307:	a3 38 60 80 00       	mov    %eax,0x806038
  80330c:	e9 dc 00 00 00       	jmp    8033ed <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	75 65                	jne    80337f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80331a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80331e:	75 17                	jne    803337 <alloc_block_FF+0x1be>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 10 5f 80 00       	push   $0x805f10
  803328:	68 db 00 00 00       	push   $0xdb
  80332d:	68 c1 5e 80 00       	push   $0x805ec1
  803332:	e8 0f df ff ff       	call   801246 <_panic>
  803337:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80333d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0c                	je     803359 <alloc_block_FF+0x1e0>
  80334d:	a1 30 60 80 00       	mov    0x806030,%eax
  803352:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803355:	89 10                	mov    %edx,(%eax)
  803357:	eb 08                	jmp    803361 <alloc_block_FF+0x1e8>
  803359:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80335c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803361:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803364:	a3 30 60 80 00       	mov    %eax,0x806030
  803369:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80336c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803372:	a1 38 60 80 00       	mov    0x806038,%eax
  803377:	40                   	inc    %eax
  803378:	a3 38 60 80 00       	mov    %eax,0x806038
  80337d:	eb 6e                	jmp    8033ed <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80337f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803383:	74 06                	je     80338b <alloc_block_FF+0x212>
  803385:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803389:	75 17                	jne    8033a2 <alloc_block_FF+0x229>
  80338b:	83 ec 04             	sub    $0x4,%esp
  80338e:	68 34 5f 80 00       	push   $0x805f34
  803393:	68 df 00 00 00       	push   $0xdf
  803398:	68 c1 5e 80 00       	push   $0x805ec1
  80339d:	e8 a4 de ff ff       	call   801246 <_panic>
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	8b 10                	mov    (%eax),%edx
  8033a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033aa:	89 10                	mov    %edx,(%eax)
  8033ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	74 0b                	je     8033c0 <alloc_block_FF+0x247>
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%eax)
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8033c6:	89 10                	mov    %edx,(%eax)
  8033c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	75 08                	jne    8033e2 <alloc_block_FF+0x269>
  8033da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033dd:	a3 30 60 80 00       	mov    %eax,0x806030
  8033e2:	a1 38 60 80 00       	mov    0x806038,%eax
  8033e7:	40                   	inc    %eax
  8033e8:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8033ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f1:	75 17                	jne    80340a <alloc_block_FF+0x291>
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	68 a3 5e 80 00       	push   $0x805ea3
  8033fb:	68 e1 00 00 00       	push   $0xe1
  803400:	68 c1 5e 80 00       	push   $0x805ec1
  803405:	e8 3c de ff ff       	call   801246 <_panic>
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	8b 00                	mov    (%eax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 10                	je     803423 <alloc_block_FF+0x2aa>
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341b:	8b 52 04             	mov    0x4(%edx),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%eax)
  803421:	eb 0b                	jmp    80342e <alloc_block_FF+0x2b5>
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 40 04             	mov    0x4(%eax),%eax
  803429:	a3 30 60 80 00       	mov    %eax,0x806030
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 40 04             	mov    0x4(%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0f                	je     803447 <alloc_block_FF+0x2ce>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803441:	8b 12                	mov    (%edx),%edx
  803443:	89 10                	mov    %edx,(%eax)
  803445:	eb 0a                	jmp    803451 <alloc_block_FF+0x2d8>
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	8b 00                	mov    (%eax),%eax
  80344c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803464:	a1 38 60 80 00       	mov    0x806038,%eax
  803469:	48                   	dec    %eax
  80346a:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  80346f:	83 ec 04             	sub    $0x4,%esp
  803472:	6a 00                	push   $0x0
  803474:	ff 75 b4             	pushl  -0x4c(%ebp)
  803477:	ff 75 b0             	pushl  -0x50(%ebp)
  80347a:	e8 cb fc ff ff       	call   80314a <set_block_data>
  80347f:	83 c4 10             	add    $0x10,%esp
  803482:	e9 95 00 00 00       	jmp    80351c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	6a 01                	push   $0x1
  80348c:	ff 75 b8             	pushl  -0x48(%ebp)
  80348f:	ff 75 bc             	pushl  -0x44(%ebp)
  803492:	e8 b3 fc ff ff       	call   80314a <set_block_data>
  803497:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80349a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349e:	75 17                	jne    8034b7 <alloc_block_FF+0x33e>
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 a3 5e 80 00       	push   $0x805ea3
  8034a8:	68 e8 00 00 00       	push   $0xe8
  8034ad:	68 c1 5e 80 00       	push   $0x805ec1
  8034b2:	e8 8f dd ff ff       	call   801246 <_panic>
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 10                	je     8034d0 <alloc_block_FF+0x357>
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c8:	8b 52 04             	mov    0x4(%edx),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 0b                	jmp    8034db <alloc_block_FF+0x362>
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 40 04             	mov    0x4(%eax),%eax
  8034d6:	a3 30 60 80 00       	mov    %eax,0x806030
  8034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034de:	8b 40 04             	mov    0x4(%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 0f                	je     8034f4 <alloc_block_FF+0x37b>
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ee:	8b 12                	mov    (%edx),%edx
  8034f0:	89 10                	mov    %edx,(%eax)
  8034f2:	eb 0a                	jmp    8034fe <alloc_block_FF+0x385>
  8034f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 38 60 80 00       	mov    0x806038,%eax
  803516:	48                   	dec    %eax
  803517:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80351c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80351f:	e9 0f 01 00 00       	jmp    803633 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803524:	a1 34 60 80 00       	mov    0x806034,%eax
  803529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803530:	74 07                	je     803539 <alloc_block_FF+0x3c0>
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	eb 05                	jmp    80353e <alloc_block_FF+0x3c5>
  803539:	b8 00 00 00 00       	mov    $0x0,%eax
  80353e:	a3 34 60 80 00       	mov    %eax,0x806034
  803543:	a1 34 60 80 00       	mov    0x806034,%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	0f 85 e9 fc ff ff    	jne    803239 <alloc_block_FF+0xc0>
  803550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803554:	0f 85 df fc ff ff    	jne    803239 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	83 c0 08             	add    $0x8,%eax
  803560:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803563:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80356a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80356d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803570:	01 d0                	add    %edx,%eax
  803572:	48                   	dec    %eax
  803573:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803579:	ba 00 00 00 00       	mov    $0x0,%edx
  80357e:	f7 75 d8             	divl   -0x28(%ebp)
  803581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803584:	29 d0                	sub    %edx,%eax
  803586:	c1 e8 0c             	shr    $0xc,%eax
  803589:	83 ec 0c             	sub    $0xc,%esp
  80358c:	50                   	push   %eax
  80358d:	e8 0b ed ff ff       	call   80229d <sbrk>
  803592:	83 c4 10             	add    $0x10,%esp
  803595:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803598:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80359c:	75 0a                	jne    8035a8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80359e:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a3:	e9 8b 00 00 00       	jmp    803633 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035a8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8035af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	48                   	dec    %eax
  8035b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8035bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035be:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c3:	f7 75 cc             	divl   -0x34(%ebp)
  8035c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c9:	29 d0                	sub    %edx,%eax
  8035cb:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035d1:	01 d0                	add    %edx,%eax
  8035d3:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8035d8:	a1 40 60 80 00       	mov    0x806040,%eax
  8035dd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035e3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8035ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	48                   	dec    %eax
  8035f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8035f6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8035fe:	f7 75 c4             	divl   -0x3c(%ebp)
  803601:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803604:	29 d0                	sub    %edx,%eax
  803606:	83 ec 04             	sub    $0x4,%esp
  803609:	6a 01                	push   $0x1
  80360b:	50                   	push   %eax
  80360c:	ff 75 d0             	pushl  -0x30(%ebp)
  80360f:	e8 36 fb ff ff       	call   80314a <set_block_data>
  803614:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803617:	83 ec 0c             	sub    $0xc,%esp
  80361a:	ff 75 d0             	pushl  -0x30(%ebp)
  80361d:	e8 f8 09 00 00       	call   80401a <free_block>
  803622:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803625:	83 ec 0c             	sub    $0xc,%esp
  803628:	ff 75 08             	pushl  0x8(%ebp)
  80362b:	e8 49 fb ff ff       	call   803179 <alloc_block_FF>
  803630:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803633:	c9                   	leave  
  803634:	c3                   	ret    

00803635 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803635:	55                   	push   %ebp
  803636:	89 e5                	mov    %esp,%ebp
  803638:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	83 e0 01             	and    $0x1,%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 03                	je     803648 <alloc_block_BF+0x13>
  803645:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803648:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80364c:	77 07                	ja     803655 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80364e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803655:	a1 24 60 80 00       	mov    0x806024,%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	75 73                	jne    8036d1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	83 c0 10             	add    $0x10,%eax
  803664:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803667:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80366e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803674:	01 d0                	add    %edx,%eax
  803676:	48                   	dec    %eax
  803677:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80367a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367d:	ba 00 00 00 00       	mov    $0x0,%edx
  803682:	f7 75 e0             	divl   -0x20(%ebp)
  803685:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803688:	29 d0                	sub    %edx,%eax
  80368a:	c1 e8 0c             	shr    $0xc,%eax
  80368d:	83 ec 0c             	sub    $0xc,%esp
  803690:	50                   	push   %eax
  803691:	e8 07 ec ff ff       	call   80229d <sbrk>
  803696:	83 c4 10             	add    $0x10,%esp
  803699:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80369c:	83 ec 0c             	sub    $0xc,%esp
  80369f:	6a 00                	push   $0x0
  8036a1:	e8 f7 eb ff ff       	call   80229d <sbrk>
  8036a6:	83 c4 10             	add    $0x10,%esp
  8036a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8036ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036af:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8036b2:	83 ec 08             	sub    $0x8,%esp
  8036b5:	50                   	push   %eax
  8036b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8036b9:	e8 9f f8 ff ff       	call   802f5d <initialize_dynamic_allocator>
  8036be:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8036c1:	83 ec 0c             	sub    $0xc,%esp
  8036c4:	68 ff 5e 80 00       	push   $0x805eff
  8036c9:	e8 35 de ff ff       	call   801503 <cprintf>
  8036ce:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8036d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8036d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8036df:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8036e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8036ed:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8036f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f5:	e9 1d 01 00 00       	jmp    803817 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803700:	83 ec 0c             	sub    $0xc,%esp
  803703:	ff 75 a8             	pushl  -0x58(%ebp)
  803706:	e8 ee f6 ff ff       	call   802df9 <get_block_size>
  80370b:	83 c4 10             	add    $0x10,%esp
  80370e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	83 c0 08             	add    $0x8,%eax
  803717:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80371a:	0f 87 ef 00 00 00    	ja     80380f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	83 c0 18             	add    $0x18,%eax
  803726:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803729:	77 1d                	ja     803748 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80372b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803731:	0f 86 d8 00 00 00    	jbe    80380f <alloc_block_BF+0x1da>
				{
					best_va = va;
  803737:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80373a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80373d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803740:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803743:	e9 c7 00 00 00       	jmp    80380f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	83 c0 08             	add    $0x8,%eax
  80374e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803751:	0f 85 9d 00 00 00    	jne    8037f4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	6a 01                	push   $0x1
  80375c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80375f:	ff 75 a8             	pushl  -0x58(%ebp)
  803762:	e8 e3 f9 ff ff       	call   80314a <set_block_data>
  803767:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80376a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376e:	75 17                	jne    803787 <alloc_block_BF+0x152>
  803770:	83 ec 04             	sub    $0x4,%esp
  803773:	68 a3 5e 80 00       	push   $0x805ea3
  803778:	68 2c 01 00 00       	push   $0x12c
  80377d:	68 c1 5e 80 00       	push   $0x805ec1
  803782:	e8 bf da ff ff       	call   801246 <_panic>
  803787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	74 10                	je     8037a0 <alloc_block_BF+0x16b>
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803798:	8b 52 04             	mov    0x4(%edx),%edx
  80379b:	89 50 04             	mov    %edx,0x4(%eax)
  80379e:	eb 0b                	jmp    8037ab <alloc_block_BF+0x176>
  8037a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a3:	8b 40 04             	mov    0x4(%eax),%eax
  8037a6:	a3 30 60 80 00       	mov    %eax,0x806030
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 40 04             	mov    0x4(%eax),%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	74 0f                	je     8037c4 <alloc_block_BF+0x18f>
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	8b 40 04             	mov    0x4(%eax),%eax
  8037bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037be:	8b 12                	mov    (%edx),%edx
  8037c0:	89 10                	mov    %edx,(%eax)
  8037c2:	eb 0a                	jmp    8037ce <alloc_block_BF+0x199>
  8037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e1:	a1 38 60 80 00       	mov    0x806038,%eax
  8037e6:	48                   	dec    %eax
  8037e7:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  8037ec:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8037ef:	e9 01 04 00 00       	jmp    803bf5 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8037f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8037fa:	76 13                	jbe    80380f <alloc_block_BF+0x1da>
					{
						internal = 1;
  8037fc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803803:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803806:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803809:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80380c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80380f:	a1 34 60 80 00       	mov    0x806034,%eax
  803814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381b:	74 07                	je     803824 <alloc_block_BF+0x1ef>
  80381d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	eb 05                	jmp    803829 <alloc_block_BF+0x1f4>
  803824:	b8 00 00 00 00       	mov    $0x0,%eax
  803829:	a3 34 60 80 00       	mov    %eax,0x806034
  80382e:	a1 34 60 80 00       	mov    0x806034,%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	0f 85 bf fe ff ff    	jne    8036fa <alloc_block_BF+0xc5>
  80383b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383f:	0f 85 b5 fe ff ff    	jne    8036fa <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803849:	0f 84 26 02 00 00    	je     803a75 <alloc_block_BF+0x440>
  80384f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803853:	0f 85 1c 02 00 00    	jne    803a75 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385c:	2b 45 08             	sub    0x8(%ebp),%eax
  80385f:	83 e8 08             	sub    $0x8,%eax
  803862:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	8d 50 08             	lea    0x8(%eax),%edx
  80386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386e:	01 d0                	add    %edx,%eax
  803870:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	83 c0 08             	add    $0x8,%eax
  803879:	83 ec 04             	sub    $0x4,%esp
  80387c:	6a 01                	push   $0x1
  80387e:	50                   	push   %eax
  80387f:	ff 75 f0             	pushl  -0x10(%ebp)
  803882:	e8 c3 f8 ff ff       	call   80314a <set_block_data>
  803887:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80388a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388d:	8b 40 04             	mov    0x4(%eax),%eax
  803890:	85 c0                	test   %eax,%eax
  803892:	75 68                	jne    8038fc <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803894:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803898:	75 17                	jne    8038b1 <alloc_block_BF+0x27c>
  80389a:	83 ec 04             	sub    $0x4,%esp
  80389d:	68 dc 5e 80 00       	push   $0x805edc
  8038a2:	68 45 01 00 00       	push   $0x145
  8038a7:	68 c1 5e 80 00       	push   $0x805ec1
  8038ac:	e8 95 d9 ff ff       	call   801246 <_panic>
  8038b1:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8038b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038ba:	89 10                	mov    %edx,(%eax)
  8038bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	85 c0                	test   %eax,%eax
  8038c3:	74 0d                	je     8038d2 <alloc_block_BF+0x29d>
  8038c5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8038ca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038cd:	89 50 04             	mov    %edx,0x4(%eax)
  8038d0:	eb 08                	jmp    8038da <alloc_block_BF+0x2a5>
  8038d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038d5:	a3 30 60 80 00       	mov    %eax,0x806030
  8038da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038dd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ec:	a1 38 60 80 00       	mov    0x806038,%eax
  8038f1:	40                   	inc    %eax
  8038f2:	a3 38 60 80 00       	mov    %eax,0x806038
  8038f7:	e9 dc 00 00 00       	jmp    8039d8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ff:	8b 00                	mov    (%eax),%eax
  803901:	85 c0                	test   %eax,%eax
  803903:	75 65                	jne    80396a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803905:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803909:	75 17                	jne    803922 <alloc_block_BF+0x2ed>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 10 5f 80 00       	push   $0x805f10
  803913:	68 4a 01 00 00       	push   $0x14a
  803918:	68 c1 5e 80 00       	push   $0x805ec1
  80391d:	e8 24 d9 ff ff       	call   801246 <_panic>
  803922:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803928:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803931:	8b 40 04             	mov    0x4(%eax),%eax
  803934:	85 c0                	test   %eax,%eax
  803936:	74 0c                	je     803944 <alloc_block_BF+0x30f>
  803938:	a1 30 60 80 00       	mov    0x806030,%eax
  80393d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803940:	89 10                	mov    %edx,(%eax)
  803942:	eb 08                	jmp    80394c <alloc_block_BF+0x317>
  803944:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803947:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80394c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80394f:	a3 30 60 80 00       	mov    %eax,0x806030
  803954:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395d:	a1 38 60 80 00       	mov    0x806038,%eax
  803962:	40                   	inc    %eax
  803963:	a3 38 60 80 00       	mov    %eax,0x806038
  803968:	eb 6e                	jmp    8039d8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80396a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80396e:	74 06                	je     803976 <alloc_block_BF+0x341>
  803970:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803974:	75 17                	jne    80398d <alloc_block_BF+0x358>
  803976:	83 ec 04             	sub    $0x4,%esp
  803979:	68 34 5f 80 00       	push   $0x805f34
  80397e:	68 4f 01 00 00       	push   $0x14f
  803983:	68 c1 5e 80 00       	push   $0x805ec1
  803988:	e8 b9 d8 ff ff       	call   801246 <_panic>
  80398d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803990:	8b 10                	mov    (%eax),%edx
  803992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803995:	89 10                	mov    %edx,(%eax)
  803997:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80399a:	8b 00                	mov    (%eax),%eax
  80399c:	85 c0                	test   %eax,%eax
  80399e:	74 0b                	je     8039ab <alloc_block_BF+0x376>
  8039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a3:	8b 00                	mov    (%eax),%eax
  8039a5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039a8:	89 50 04             	mov    %edx,0x4(%eax)
  8039ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039b1:	89 10                	mov    %edx,(%eax)
  8039b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039b9:	89 50 04             	mov    %edx,0x4(%eax)
  8039bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039bf:	8b 00                	mov    (%eax),%eax
  8039c1:	85 c0                	test   %eax,%eax
  8039c3:	75 08                	jne    8039cd <alloc_block_BF+0x398>
  8039c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039c8:	a3 30 60 80 00       	mov    %eax,0x806030
  8039cd:	a1 38 60 80 00       	mov    0x806038,%eax
  8039d2:	40                   	inc    %eax
  8039d3:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8039d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039dc:	75 17                	jne    8039f5 <alloc_block_BF+0x3c0>
  8039de:	83 ec 04             	sub    $0x4,%esp
  8039e1:	68 a3 5e 80 00       	push   $0x805ea3
  8039e6:	68 51 01 00 00       	push   $0x151
  8039eb:	68 c1 5e 80 00       	push   $0x805ec1
  8039f0:	e8 51 d8 ff ff       	call   801246 <_panic>
  8039f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	74 10                	je     803a0e <alloc_block_BF+0x3d9>
  8039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a06:	8b 52 04             	mov    0x4(%edx),%edx
  803a09:	89 50 04             	mov    %edx,0x4(%eax)
  803a0c:	eb 0b                	jmp    803a19 <alloc_block_BF+0x3e4>
  803a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a11:	8b 40 04             	mov    0x4(%eax),%eax
  803a14:	a3 30 60 80 00       	mov    %eax,0x806030
  803a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1c:	8b 40 04             	mov    0x4(%eax),%eax
  803a1f:	85 c0                	test   %eax,%eax
  803a21:	74 0f                	je     803a32 <alloc_block_BF+0x3fd>
  803a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a26:	8b 40 04             	mov    0x4(%eax),%eax
  803a29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2c:	8b 12                	mov    (%edx),%edx
  803a2e:	89 10                	mov    %edx,(%eax)
  803a30:	eb 0a                	jmp    803a3c <alloc_block_BF+0x407>
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	8b 00                	mov    (%eax),%eax
  803a37:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a4f:	a1 38 60 80 00       	mov    0x806038,%eax
  803a54:	48                   	dec    %eax
  803a55:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	6a 00                	push   $0x0
  803a5f:	ff 75 d0             	pushl  -0x30(%ebp)
  803a62:	ff 75 cc             	pushl  -0x34(%ebp)
  803a65:	e8 e0 f6 ff ff       	call   80314a <set_block_data>
  803a6a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a70:	e9 80 01 00 00       	jmp    803bf5 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803a75:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803a79:	0f 85 9d 00 00 00    	jne    803b1c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803a7f:	83 ec 04             	sub    $0x4,%esp
  803a82:	6a 01                	push   $0x1
  803a84:	ff 75 ec             	pushl  -0x14(%ebp)
  803a87:	ff 75 f0             	pushl  -0x10(%ebp)
  803a8a:	e8 bb f6 ff ff       	call   80314a <set_block_data>
  803a8f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803a92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a96:	75 17                	jne    803aaf <alloc_block_BF+0x47a>
  803a98:	83 ec 04             	sub    $0x4,%esp
  803a9b:	68 a3 5e 80 00       	push   $0x805ea3
  803aa0:	68 58 01 00 00       	push   $0x158
  803aa5:	68 c1 5e 80 00       	push   $0x805ec1
  803aaa:	e8 97 d7 ff ff       	call   801246 <_panic>
  803aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	85 c0                	test   %eax,%eax
  803ab6:	74 10                	je     803ac8 <alloc_block_BF+0x493>
  803ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ac0:	8b 52 04             	mov    0x4(%edx),%edx
  803ac3:	89 50 04             	mov    %edx,0x4(%eax)
  803ac6:	eb 0b                	jmp    803ad3 <alloc_block_BF+0x49e>
  803ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803acb:	8b 40 04             	mov    0x4(%eax),%eax
  803ace:	a3 30 60 80 00       	mov    %eax,0x806030
  803ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad6:	8b 40 04             	mov    0x4(%eax),%eax
  803ad9:	85 c0                	test   %eax,%eax
  803adb:	74 0f                	je     803aec <alloc_block_BF+0x4b7>
  803add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae0:	8b 40 04             	mov    0x4(%eax),%eax
  803ae3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae6:	8b 12                	mov    (%edx),%edx
  803ae8:	89 10                	mov    %edx,(%eax)
  803aea:	eb 0a                	jmp    803af6 <alloc_block_BF+0x4c1>
  803aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aef:	8b 00                	mov    (%eax),%eax
  803af1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b09:	a1 38 60 80 00       	mov    0x806038,%eax
  803b0e:	48                   	dec    %eax
  803b0f:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b17:	e9 d9 00 00 00       	jmp    803bf5 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	83 c0 08             	add    $0x8,%eax
  803b22:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803b25:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803b2c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b32:	01 d0                	add    %edx,%eax
  803b34:	48                   	dec    %eax
  803b35:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803b38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  803b40:	f7 75 c4             	divl   -0x3c(%ebp)
  803b43:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b46:	29 d0                	sub    %edx,%eax
  803b48:	c1 e8 0c             	shr    $0xc,%eax
  803b4b:	83 ec 0c             	sub    $0xc,%esp
  803b4e:	50                   	push   %eax
  803b4f:	e8 49 e7 ff ff       	call   80229d <sbrk>
  803b54:	83 c4 10             	add    $0x10,%esp
  803b57:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803b5a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803b5e:	75 0a                	jne    803b6a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803b60:	b8 00 00 00 00       	mov    $0x0,%eax
  803b65:	e9 8b 00 00 00       	jmp    803bf5 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803b6a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803b71:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b74:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b77:	01 d0                	add    %edx,%eax
  803b79:	48                   	dec    %eax
  803b7a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803b7d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803b80:	ba 00 00 00 00       	mov    $0x0,%edx
  803b85:	f7 75 b8             	divl   -0x48(%ebp)
  803b88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803b8b:	29 d0                	sub    %edx,%eax
  803b8d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803b90:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803b93:	01 d0                	add    %edx,%eax
  803b95:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803b9a:	a1 40 60 80 00       	mov    0x806040,%eax
  803b9f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803ba5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803bac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803baf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803bb2:	01 d0                	add    %edx,%eax
  803bb4:	48                   	dec    %eax
  803bb5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803bb8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc0:	f7 75 b0             	divl   -0x50(%ebp)
  803bc3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803bc6:	29 d0                	sub    %edx,%eax
  803bc8:	83 ec 04             	sub    $0x4,%esp
  803bcb:	6a 01                	push   $0x1
  803bcd:	50                   	push   %eax
  803bce:	ff 75 bc             	pushl  -0x44(%ebp)
  803bd1:	e8 74 f5 ff ff       	call   80314a <set_block_data>
  803bd6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803bd9:	83 ec 0c             	sub    $0xc,%esp
  803bdc:	ff 75 bc             	pushl  -0x44(%ebp)
  803bdf:	e8 36 04 00 00       	call   80401a <free_block>
  803be4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803be7:	83 ec 0c             	sub    $0xc,%esp
  803bea:	ff 75 08             	pushl  0x8(%ebp)
  803bed:	e8 43 fa ff ff       	call   803635 <alloc_block_BF>
  803bf2:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803bf5:	c9                   	leave  
  803bf6:	c3                   	ret    

00803bf7 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803bf7:	55                   	push   %ebp
  803bf8:	89 e5                	mov    %esp,%ebp
  803bfa:	53                   	push   %ebx
  803bfb:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c10:	74 1e                	je     803c30 <merging+0x39>
  803c12:	ff 75 08             	pushl  0x8(%ebp)
  803c15:	e8 df f1 ff ff       	call   802df9 <get_block_size>
  803c1a:	83 c4 04             	add    $0x4,%esp
  803c1d:	89 c2                	mov    %eax,%edx
  803c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c22:	01 d0                	add    %edx,%eax
  803c24:	3b 45 10             	cmp    0x10(%ebp),%eax
  803c27:	75 07                	jne    803c30 <merging+0x39>
		prev_is_free = 1;
  803c29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803c30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c34:	74 1e                	je     803c54 <merging+0x5d>
  803c36:	ff 75 10             	pushl  0x10(%ebp)
  803c39:	e8 bb f1 ff ff       	call   802df9 <get_block_size>
  803c3e:	83 c4 04             	add    $0x4,%esp
  803c41:	89 c2                	mov    %eax,%edx
  803c43:	8b 45 10             	mov    0x10(%ebp),%eax
  803c46:	01 d0                	add    %edx,%eax
  803c48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c4b:	75 07                	jne    803c54 <merging+0x5d>
		next_is_free = 1;
  803c4d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803c54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c58:	0f 84 cc 00 00 00    	je     803d2a <merging+0x133>
  803c5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c62:	0f 84 c2 00 00 00    	je     803d2a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803c68:	ff 75 08             	pushl  0x8(%ebp)
  803c6b:	e8 89 f1 ff ff       	call   802df9 <get_block_size>
  803c70:	83 c4 04             	add    $0x4,%esp
  803c73:	89 c3                	mov    %eax,%ebx
  803c75:	ff 75 10             	pushl  0x10(%ebp)
  803c78:	e8 7c f1 ff ff       	call   802df9 <get_block_size>
  803c7d:	83 c4 04             	add    $0x4,%esp
  803c80:	01 c3                	add    %eax,%ebx
  803c82:	ff 75 0c             	pushl  0xc(%ebp)
  803c85:	e8 6f f1 ff ff       	call   802df9 <get_block_size>
  803c8a:	83 c4 04             	add    $0x4,%esp
  803c8d:	01 d8                	add    %ebx,%eax
  803c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803c92:	6a 00                	push   $0x0
  803c94:	ff 75 ec             	pushl  -0x14(%ebp)
  803c97:	ff 75 08             	pushl  0x8(%ebp)
  803c9a:	e8 ab f4 ff ff       	call   80314a <set_block_data>
  803c9f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803ca2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ca6:	75 17                	jne    803cbf <merging+0xc8>
  803ca8:	83 ec 04             	sub    $0x4,%esp
  803cab:	68 a3 5e 80 00       	push   $0x805ea3
  803cb0:	68 7d 01 00 00       	push   $0x17d
  803cb5:	68 c1 5e 80 00       	push   $0x805ec1
  803cba:	e8 87 d5 ff ff       	call   801246 <_panic>
  803cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	85 c0                	test   %eax,%eax
  803cc6:	74 10                	je     803cd8 <merging+0xe1>
  803cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cd0:	8b 52 04             	mov    0x4(%edx),%edx
  803cd3:	89 50 04             	mov    %edx,0x4(%eax)
  803cd6:	eb 0b                	jmp    803ce3 <merging+0xec>
  803cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdb:	8b 40 04             	mov    0x4(%eax),%eax
  803cde:	a3 30 60 80 00       	mov    %eax,0x806030
  803ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 0f                	je     803cfc <merging+0x105>
  803ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf0:	8b 40 04             	mov    0x4(%eax),%eax
  803cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cf6:	8b 12                	mov    (%edx),%edx
  803cf8:	89 10                	mov    %edx,(%eax)
  803cfa:	eb 0a                	jmp    803d06 <merging+0x10f>
  803cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d19:	a1 38 60 80 00       	mov    0x806038,%eax
  803d1e:	48                   	dec    %eax
  803d1f:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803d24:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d25:	e9 ea 02 00 00       	jmp    804014 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803d2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2e:	74 3b                	je     803d6b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803d30:	83 ec 0c             	sub    $0xc,%esp
  803d33:	ff 75 08             	pushl  0x8(%ebp)
  803d36:	e8 be f0 ff ff       	call   802df9 <get_block_size>
  803d3b:	83 c4 10             	add    $0x10,%esp
  803d3e:	89 c3                	mov    %eax,%ebx
  803d40:	83 ec 0c             	sub    $0xc,%esp
  803d43:	ff 75 10             	pushl  0x10(%ebp)
  803d46:	e8 ae f0 ff ff       	call   802df9 <get_block_size>
  803d4b:	83 c4 10             	add    $0x10,%esp
  803d4e:	01 d8                	add    %ebx,%eax
  803d50:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803d53:	83 ec 04             	sub    $0x4,%esp
  803d56:	6a 00                	push   $0x0
  803d58:	ff 75 e8             	pushl  -0x18(%ebp)
  803d5b:	ff 75 08             	pushl  0x8(%ebp)
  803d5e:	e8 e7 f3 ff ff       	call   80314a <set_block_data>
  803d63:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d66:	e9 a9 02 00 00       	jmp    804014 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803d6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d6f:	0f 84 2d 01 00 00    	je     803ea2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803d75:	83 ec 0c             	sub    $0xc,%esp
  803d78:	ff 75 10             	pushl  0x10(%ebp)
  803d7b:	e8 79 f0 ff ff       	call   802df9 <get_block_size>
  803d80:	83 c4 10             	add    $0x10,%esp
  803d83:	89 c3                	mov    %eax,%ebx
  803d85:	83 ec 0c             	sub    $0xc,%esp
  803d88:	ff 75 0c             	pushl  0xc(%ebp)
  803d8b:	e8 69 f0 ff ff       	call   802df9 <get_block_size>
  803d90:	83 c4 10             	add    $0x10,%esp
  803d93:	01 d8                	add    %ebx,%eax
  803d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803d98:	83 ec 04             	sub    $0x4,%esp
  803d9b:	6a 00                	push   $0x0
  803d9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803da0:	ff 75 10             	pushl  0x10(%ebp)
  803da3:	e8 a2 f3 ff ff       	call   80314a <set_block_data>
  803da8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803dab:	8b 45 10             	mov    0x10(%ebp),%eax
  803dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803db5:	74 06                	je     803dbd <merging+0x1c6>
  803db7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803dbb:	75 17                	jne    803dd4 <merging+0x1dd>
  803dbd:	83 ec 04             	sub    $0x4,%esp
  803dc0:	68 68 5f 80 00       	push   $0x805f68
  803dc5:	68 8d 01 00 00       	push   $0x18d
  803dca:	68 c1 5e 80 00       	push   $0x805ec1
  803dcf:	e8 72 d4 ff ff       	call   801246 <_panic>
  803dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd7:	8b 50 04             	mov    0x4(%eax),%edx
  803dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ddd:	89 50 04             	mov    %edx,0x4(%eax)
  803de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803de6:	89 10                	mov    %edx,(%eax)
  803de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803deb:	8b 40 04             	mov    0x4(%eax),%eax
  803dee:	85 c0                	test   %eax,%eax
  803df0:	74 0d                	je     803dff <merging+0x208>
  803df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df5:	8b 40 04             	mov    0x4(%eax),%eax
  803df8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803dfb:	89 10                	mov    %edx,(%eax)
  803dfd:	eb 08                	jmp    803e07 <merging+0x210>
  803dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e02:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e0d:	89 50 04             	mov    %edx,0x4(%eax)
  803e10:	a1 38 60 80 00       	mov    0x806038,%eax
  803e15:	40                   	inc    %eax
  803e16:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803e1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e1f:	75 17                	jne    803e38 <merging+0x241>
  803e21:	83 ec 04             	sub    $0x4,%esp
  803e24:	68 a3 5e 80 00       	push   $0x805ea3
  803e29:	68 8e 01 00 00       	push   $0x18e
  803e2e:	68 c1 5e 80 00       	push   $0x805ec1
  803e33:	e8 0e d4 ff ff       	call   801246 <_panic>
  803e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e3b:	8b 00                	mov    (%eax),%eax
  803e3d:	85 c0                	test   %eax,%eax
  803e3f:	74 10                	je     803e51 <merging+0x25a>
  803e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e44:	8b 00                	mov    (%eax),%eax
  803e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e49:	8b 52 04             	mov    0x4(%edx),%edx
  803e4c:	89 50 04             	mov    %edx,0x4(%eax)
  803e4f:	eb 0b                	jmp    803e5c <merging+0x265>
  803e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e54:	8b 40 04             	mov    0x4(%eax),%eax
  803e57:	a3 30 60 80 00       	mov    %eax,0x806030
  803e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e5f:	8b 40 04             	mov    0x4(%eax),%eax
  803e62:	85 c0                	test   %eax,%eax
  803e64:	74 0f                	je     803e75 <merging+0x27e>
  803e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e69:	8b 40 04             	mov    0x4(%eax),%eax
  803e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e6f:	8b 12                	mov    (%edx),%edx
  803e71:	89 10                	mov    %edx,(%eax)
  803e73:	eb 0a                	jmp    803e7f <merging+0x288>
  803e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e78:	8b 00                	mov    (%eax),%eax
  803e7a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e92:	a1 38 60 80 00       	mov    0x806038,%eax
  803e97:	48                   	dec    %eax
  803e98:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803e9d:	e9 72 01 00 00       	jmp    804014 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  803ea5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eac:	74 79                	je     803f27 <merging+0x330>
  803eae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803eb2:	74 73                	je     803f27 <merging+0x330>
  803eb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eb8:	74 06                	je     803ec0 <merging+0x2c9>
  803eba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ebe:	75 17                	jne    803ed7 <merging+0x2e0>
  803ec0:	83 ec 04             	sub    $0x4,%esp
  803ec3:	68 34 5f 80 00       	push   $0x805f34
  803ec8:	68 94 01 00 00       	push   $0x194
  803ecd:	68 c1 5e 80 00       	push   $0x805ec1
  803ed2:	e8 6f d3 ff ff       	call   801246 <_panic>
  803ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eda:	8b 10                	mov    (%eax),%edx
  803edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803edf:	89 10                	mov    %edx,(%eax)
  803ee1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee4:	8b 00                	mov    (%eax),%eax
  803ee6:	85 c0                	test   %eax,%eax
  803ee8:	74 0b                	je     803ef5 <merging+0x2fe>
  803eea:	8b 45 08             	mov    0x8(%ebp),%eax
  803eed:	8b 00                	mov    (%eax),%eax
  803eef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ef2:	89 50 04             	mov    %edx,0x4(%eax)
  803ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803efb:	89 10                	mov    %edx,(%eax)
  803efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f00:	8b 55 08             	mov    0x8(%ebp),%edx
  803f03:	89 50 04             	mov    %edx,0x4(%eax)
  803f06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f09:	8b 00                	mov    (%eax),%eax
  803f0b:	85 c0                	test   %eax,%eax
  803f0d:	75 08                	jne    803f17 <merging+0x320>
  803f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f12:	a3 30 60 80 00       	mov    %eax,0x806030
  803f17:	a1 38 60 80 00       	mov    0x806038,%eax
  803f1c:	40                   	inc    %eax
  803f1d:	a3 38 60 80 00       	mov    %eax,0x806038
  803f22:	e9 ce 00 00 00       	jmp    803ff5 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803f27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f2b:	74 65                	je     803f92 <merging+0x39b>
  803f2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f31:	75 17                	jne    803f4a <merging+0x353>
  803f33:	83 ec 04             	sub    $0x4,%esp
  803f36:	68 10 5f 80 00       	push   $0x805f10
  803f3b:	68 95 01 00 00       	push   $0x195
  803f40:	68 c1 5e 80 00       	push   $0x805ec1
  803f45:	e8 fc d2 ff ff       	call   801246 <_panic>
  803f4a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f53:	89 50 04             	mov    %edx,0x4(%eax)
  803f56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f59:	8b 40 04             	mov    0x4(%eax),%eax
  803f5c:	85 c0                	test   %eax,%eax
  803f5e:	74 0c                	je     803f6c <merging+0x375>
  803f60:	a1 30 60 80 00       	mov    0x806030,%eax
  803f65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f68:	89 10                	mov    %edx,(%eax)
  803f6a:	eb 08                	jmp    803f74 <merging+0x37d>
  803f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f6f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f77:	a3 30 60 80 00       	mov    %eax,0x806030
  803f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f85:	a1 38 60 80 00       	mov    0x806038,%eax
  803f8a:	40                   	inc    %eax
  803f8b:	a3 38 60 80 00       	mov    %eax,0x806038
  803f90:	eb 63                	jmp    803ff5 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803f92:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f96:	75 17                	jne    803faf <merging+0x3b8>
  803f98:	83 ec 04             	sub    $0x4,%esp
  803f9b:	68 dc 5e 80 00       	push   $0x805edc
  803fa0:	68 98 01 00 00       	push   $0x198
  803fa5:	68 c1 5e 80 00       	push   $0x805ec1
  803faa:	e8 97 d2 ff ff       	call   801246 <_panic>
  803faf:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803fb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fb8:	89 10                	mov    %edx,(%eax)
  803fba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fbd:	8b 00                	mov    (%eax),%eax
  803fbf:	85 c0                	test   %eax,%eax
  803fc1:	74 0d                	je     803fd0 <merging+0x3d9>
  803fc3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fcb:	89 50 04             	mov    %edx,0x4(%eax)
  803fce:	eb 08                	jmp    803fd8 <merging+0x3e1>
  803fd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fd3:	a3 30 60 80 00       	mov    %eax,0x806030
  803fd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fdb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fe3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fea:	a1 38 60 80 00       	mov    0x806038,%eax
  803fef:	40                   	inc    %eax
  803ff0:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803ff5:	83 ec 0c             	sub    $0xc,%esp
  803ff8:	ff 75 10             	pushl  0x10(%ebp)
  803ffb:	e8 f9 ed ff ff       	call   802df9 <get_block_size>
  804000:	83 c4 10             	add    $0x10,%esp
  804003:	83 ec 04             	sub    $0x4,%esp
  804006:	6a 00                	push   $0x0
  804008:	50                   	push   %eax
  804009:	ff 75 10             	pushl  0x10(%ebp)
  80400c:	e8 39 f1 ff ff       	call   80314a <set_block_data>
  804011:	83 c4 10             	add    $0x10,%esp
	}
}
  804014:	90                   	nop
  804015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804018:	c9                   	leave  
  804019:	c3                   	ret    

0080401a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80401a:	55                   	push   %ebp
  80401b:	89 e5                	mov    %esp,%ebp
  80401d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804020:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804025:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  804028:	a1 30 60 80 00       	mov    0x806030,%eax
  80402d:	3b 45 08             	cmp    0x8(%ebp),%eax
  804030:	73 1b                	jae    80404d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804032:	a1 30 60 80 00       	mov    0x806030,%eax
  804037:	83 ec 04             	sub    $0x4,%esp
  80403a:	ff 75 08             	pushl  0x8(%ebp)
  80403d:	6a 00                	push   $0x0
  80403f:	50                   	push   %eax
  804040:	e8 b2 fb ff ff       	call   803bf7 <merging>
  804045:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804048:	e9 8b 00 00 00       	jmp    8040d8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80404d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804052:	3b 45 08             	cmp    0x8(%ebp),%eax
  804055:	76 18                	jbe    80406f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804057:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80405c:	83 ec 04             	sub    $0x4,%esp
  80405f:	ff 75 08             	pushl  0x8(%ebp)
  804062:	50                   	push   %eax
  804063:	6a 00                	push   $0x0
  804065:	e8 8d fb ff ff       	call   803bf7 <merging>
  80406a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80406d:	eb 69                	jmp    8040d8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80406f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804074:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804077:	eb 39                	jmp    8040b2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  804079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80407c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80407f:	73 29                	jae    8040aa <free_block+0x90>
  804081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804084:	8b 00                	mov    (%eax),%eax
  804086:	3b 45 08             	cmp    0x8(%ebp),%eax
  804089:	76 1f                	jbe    8040aa <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80408e:	8b 00                	mov    (%eax),%eax
  804090:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804093:	83 ec 04             	sub    $0x4,%esp
  804096:	ff 75 08             	pushl  0x8(%ebp)
  804099:	ff 75 f0             	pushl  -0x10(%ebp)
  80409c:	ff 75 f4             	pushl  -0xc(%ebp)
  80409f:	e8 53 fb ff ff       	call   803bf7 <merging>
  8040a4:	83 c4 10             	add    $0x10,%esp
			break;
  8040a7:	90                   	nop
		}
	}
}
  8040a8:	eb 2e                	jmp    8040d8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8040aa:	a1 34 60 80 00       	mov    0x806034,%eax
  8040af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040b6:	74 07                	je     8040bf <free_block+0xa5>
  8040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bb:	8b 00                	mov    (%eax),%eax
  8040bd:	eb 05                	jmp    8040c4 <free_block+0xaa>
  8040bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c4:	a3 34 60 80 00       	mov    %eax,0x806034
  8040c9:	a1 34 60 80 00       	mov    0x806034,%eax
  8040ce:	85 c0                	test   %eax,%eax
  8040d0:	75 a7                	jne    804079 <free_block+0x5f>
  8040d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040d6:	75 a1                	jne    804079 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8040d8:	90                   	nop
  8040d9:	c9                   	leave  
  8040da:	c3                   	ret    

008040db <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8040db:	55                   	push   %ebp
  8040dc:	89 e5                	mov    %esp,%ebp
  8040de:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8040e1:	ff 75 08             	pushl  0x8(%ebp)
  8040e4:	e8 10 ed ff ff       	call   802df9 <get_block_size>
  8040e9:	83 c4 04             	add    $0x4,%esp
  8040ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8040ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8040f6:	eb 17                	jmp    80410f <copy_data+0x34>
  8040f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8040fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040fe:	01 c2                	add    %eax,%edx
  804100:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804103:	8b 45 08             	mov    0x8(%ebp),%eax
  804106:	01 c8                	add    %ecx,%eax
  804108:	8a 00                	mov    (%eax),%al
  80410a:	88 02                	mov    %al,(%edx)
  80410c:	ff 45 fc             	incl   -0x4(%ebp)
  80410f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804112:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804115:	72 e1                	jb     8040f8 <copy_data+0x1d>
}
  804117:	90                   	nop
  804118:	c9                   	leave  
  804119:	c3                   	ret    

0080411a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80411a:	55                   	push   %ebp
  80411b:	89 e5                	mov    %esp,%ebp
  80411d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804124:	75 23                	jne    804149 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  804126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80412a:	74 13                	je     80413f <realloc_block_FF+0x25>
  80412c:	83 ec 0c             	sub    $0xc,%esp
  80412f:	ff 75 0c             	pushl  0xc(%ebp)
  804132:	e8 42 f0 ff ff       	call   803179 <alloc_block_FF>
  804137:	83 c4 10             	add    $0x10,%esp
  80413a:	e9 e4 06 00 00       	jmp    804823 <realloc_block_FF+0x709>
		return NULL;
  80413f:	b8 00 00 00 00       	mov    $0x0,%eax
  804144:	e9 da 06 00 00       	jmp    804823 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  804149:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80414d:	75 18                	jne    804167 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80414f:	83 ec 0c             	sub    $0xc,%esp
  804152:	ff 75 08             	pushl  0x8(%ebp)
  804155:	e8 c0 fe ff ff       	call   80401a <free_block>
  80415a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80415d:	b8 00 00 00 00       	mov    $0x0,%eax
  804162:	e9 bc 06 00 00       	jmp    804823 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  804167:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80416b:	77 07                	ja     804174 <realloc_block_FF+0x5a>
  80416d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804174:	8b 45 0c             	mov    0xc(%ebp),%eax
  804177:	83 e0 01             	and    $0x1,%eax
  80417a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80417d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804180:	83 c0 08             	add    $0x8,%eax
  804183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804186:	83 ec 0c             	sub    $0xc,%esp
  804189:	ff 75 08             	pushl  0x8(%ebp)
  80418c:	e8 68 ec ff ff       	call   802df9 <get_block_size>
  804191:	83 c4 10             	add    $0x10,%esp
  804194:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80419a:	83 e8 08             	sub    $0x8,%eax
  80419d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8041a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a3:	83 e8 04             	sub    $0x4,%eax
  8041a6:	8b 00                	mov    (%eax),%eax
  8041a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8041ab:	89 c2                	mov    %eax,%edx
  8041ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b0:	01 d0                	add    %edx,%eax
  8041b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8041b5:	83 ec 0c             	sub    $0xc,%esp
  8041b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8041bb:	e8 39 ec ff ff       	call   802df9 <get_block_size>
  8041c0:	83 c4 10             	add    $0x10,%esp
  8041c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8041c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041c9:	83 e8 08             	sub    $0x8,%eax
  8041cc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8041cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041d2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8041d5:	75 08                	jne    8041df <realloc_block_FF+0xc5>
	{
		 return va;
  8041d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041da:	e9 44 06 00 00       	jmp    804823 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8041df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8041e5:	0f 83 d5 03 00 00    	jae    8045c0 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8041eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ee:	2b 45 0c             	sub    0xc(%ebp),%eax
  8041f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8041f4:	83 ec 0c             	sub    $0xc,%esp
  8041f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8041fa:	e8 13 ec ff ff       	call   802e12 <is_free_block>
  8041ff:	83 c4 10             	add    $0x10,%esp
  804202:	84 c0                	test   %al,%al
  804204:	0f 84 3b 01 00 00    	je     804345 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80420a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80420d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804210:	01 d0                	add    %edx,%eax
  804212:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804215:	83 ec 04             	sub    $0x4,%esp
  804218:	6a 01                	push   $0x1
  80421a:	ff 75 f0             	pushl  -0x10(%ebp)
  80421d:	ff 75 08             	pushl  0x8(%ebp)
  804220:	e8 25 ef ff ff       	call   80314a <set_block_data>
  804225:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804228:	8b 45 08             	mov    0x8(%ebp),%eax
  80422b:	83 e8 04             	sub    $0x4,%eax
  80422e:	8b 00                	mov    (%eax),%eax
  804230:	83 e0 fe             	and    $0xfffffffe,%eax
  804233:	89 c2                	mov    %eax,%edx
  804235:	8b 45 08             	mov    0x8(%ebp),%eax
  804238:	01 d0                	add    %edx,%eax
  80423a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80423d:	83 ec 04             	sub    $0x4,%esp
  804240:	6a 00                	push   $0x0
  804242:	ff 75 cc             	pushl  -0x34(%ebp)
  804245:	ff 75 c8             	pushl  -0x38(%ebp)
  804248:	e8 fd ee ff ff       	call   80314a <set_block_data>
  80424d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804250:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804254:	74 06                	je     80425c <realloc_block_FF+0x142>
  804256:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80425a:	75 17                	jne    804273 <realloc_block_FF+0x159>
  80425c:	83 ec 04             	sub    $0x4,%esp
  80425f:	68 34 5f 80 00       	push   $0x805f34
  804264:	68 f6 01 00 00       	push   $0x1f6
  804269:	68 c1 5e 80 00       	push   $0x805ec1
  80426e:	e8 d3 cf ff ff       	call   801246 <_panic>
  804273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804276:	8b 10                	mov    (%eax),%edx
  804278:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80427b:	89 10                	mov    %edx,(%eax)
  80427d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804280:	8b 00                	mov    (%eax),%eax
  804282:	85 c0                	test   %eax,%eax
  804284:	74 0b                	je     804291 <realloc_block_FF+0x177>
  804286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804289:	8b 00                	mov    (%eax),%eax
  80428b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80428e:	89 50 04             	mov    %edx,0x4(%eax)
  804291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804294:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804297:	89 10                	mov    %edx,(%eax)
  804299:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80429c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80429f:	89 50 04             	mov    %edx,0x4(%eax)
  8042a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042a5:	8b 00                	mov    (%eax),%eax
  8042a7:	85 c0                	test   %eax,%eax
  8042a9:	75 08                	jne    8042b3 <realloc_block_FF+0x199>
  8042ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042ae:	a3 30 60 80 00       	mov    %eax,0x806030
  8042b3:	a1 38 60 80 00       	mov    0x806038,%eax
  8042b8:	40                   	inc    %eax
  8042b9:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8042be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042c2:	75 17                	jne    8042db <realloc_block_FF+0x1c1>
  8042c4:	83 ec 04             	sub    $0x4,%esp
  8042c7:	68 a3 5e 80 00       	push   $0x805ea3
  8042cc:	68 f7 01 00 00       	push   $0x1f7
  8042d1:	68 c1 5e 80 00       	push   $0x805ec1
  8042d6:	e8 6b cf ff ff       	call   801246 <_panic>
  8042db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042de:	8b 00                	mov    (%eax),%eax
  8042e0:	85 c0                	test   %eax,%eax
  8042e2:	74 10                	je     8042f4 <realloc_block_FF+0x1da>
  8042e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e7:	8b 00                	mov    (%eax),%eax
  8042e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042ec:	8b 52 04             	mov    0x4(%edx),%edx
  8042ef:	89 50 04             	mov    %edx,0x4(%eax)
  8042f2:	eb 0b                	jmp    8042ff <realloc_block_FF+0x1e5>
  8042f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042f7:	8b 40 04             	mov    0x4(%eax),%eax
  8042fa:	a3 30 60 80 00       	mov    %eax,0x806030
  8042ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804302:	8b 40 04             	mov    0x4(%eax),%eax
  804305:	85 c0                	test   %eax,%eax
  804307:	74 0f                	je     804318 <realloc_block_FF+0x1fe>
  804309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430c:	8b 40 04             	mov    0x4(%eax),%eax
  80430f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804312:	8b 12                	mov    (%edx),%edx
  804314:	89 10                	mov    %edx,(%eax)
  804316:	eb 0a                	jmp    804322 <realloc_block_FF+0x208>
  804318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80431b:	8b 00                	mov    (%eax),%eax
  80431d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804325:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80432b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804335:	a1 38 60 80 00       	mov    0x806038,%eax
  80433a:	48                   	dec    %eax
  80433b:	a3 38 60 80 00       	mov    %eax,0x806038
  804340:	e9 73 02 00 00       	jmp    8045b8 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  804345:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804349:	0f 86 69 02 00 00    	jbe    8045b8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80434f:	83 ec 04             	sub    $0x4,%esp
  804352:	6a 01                	push   $0x1
  804354:	ff 75 f0             	pushl  -0x10(%ebp)
  804357:	ff 75 08             	pushl  0x8(%ebp)
  80435a:	e8 eb ed ff ff       	call   80314a <set_block_data>
  80435f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804362:	8b 45 08             	mov    0x8(%ebp),%eax
  804365:	83 e8 04             	sub    $0x4,%eax
  804368:	8b 00                	mov    (%eax),%eax
  80436a:	83 e0 fe             	and    $0xfffffffe,%eax
  80436d:	89 c2                	mov    %eax,%edx
  80436f:	8b 45 08             	mov    0x8(%ebp),%eax
  804372:	01 d0                	add    %edx,%eax
  804374:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804377:	a1 38 60 80 00       	mov    0x806038,%eax
  80437c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80437f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804383:	75 68                	jne    8043ed <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804385:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804389:	75 17                	jne    8043a2 <realloc_block_FF+0x288>
  80438b:	83 ec 04             	sub    $0x4,%esp
  80438e:	68 dc 5e 80 00       	push   $0x805edc
  804393:	68 06 02 00 00       	push   $0x206
  804398:	68 c1 5e 80 00       	push   $0x805ec1
  80439d:	e8 a4 ce ff ff       	call   801246 <_panic>
  8043a2:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8043a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043ab:	89 10                	mov    %edx,(%eax)
  8043ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043b0:	8b 00                	mov    (%eax),%eax
  8043b2:	85 c0                	test   %eax,%eax
  8043b4:	74 0d                	je     8043c3 <realloc_block_FF+0x2a9>
  8043b6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043be:	89 50 04             	mov    %edx,0x4(%eax)
  8043c1:	eb 08                	jmp    8043cb <realloc_block_FF+0x2b1>
  8043c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043c6:	a3 30 60 80 00       	mov    %eax,0x806030
  8043cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043ce:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043dd:	a1 38 60 80 00       	mov    0x806038,%eax
  8043e2:	40                   	inc    %eax
  8043e3:	a3 38 60 80 00       	mov    %eax,0x806038
  8043e8:	e9 b0 01 00 00       	jmp    80459d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8043ed:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043f5:	76 68                	jbe    80445f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8043f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043fb:	75 17                	jne    804414 <realloc_block_FF+0x2fa>
  8043fd:	83 ec 04             	sub    $0x4,%esp
  804400:	68 dc 5e 80 00       	push   $0x805edc
  804405:	68 0b 02 00 00       	push   $0x20b
  80440a:	68 c1 5e 80 00       	push   $0x805ec1
  80440f:	e8 32 ce ff ff       	call   801246 <_panic>
  804414:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80441a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80441d:	89 10                	mov    %edx,(%eax)
  80441f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804422:	8b 00                	mov    (%eax),%eax
  804424:	85 c0                	test   %eax,%eax
  804426:	74 0d                	je     804435 <realloc_block_FF+0x31b>
  804428:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80442d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804430:	89 50 04             	mov    %edx,0x4(%eax)
  804433:	eb 08                	jmp    80443d <realloc_block_FF+0x323>
  804435:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804438:	a3 30 60 80 00       	mov    %eax,0x806030
  80443d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804440:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80444f:	a1 38 60 80 00       	mov    0x806038,%eax
  804454:	40                   	inc    %eax
  804455:	a3 38 60 80 00       	mov    %eax,0x806038
  80445a:	e9 3e 01 00 00       	jmp    80459d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80445f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804464:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804467:	73 68                	jae    8044d1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804469:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80446d:	75 17                	jne    804486 <realloc_block_FF+0x36c>
  80446f:	83 ec 04             	sub    $0x4,%esp
  804472:	68 10 5f 80 00       	push   $0x805f10
  804477:	68 10 02 00 00       	push   $0x210
  80447c:	68 c1 5e 80 00       	push   $0x805ec1
  804481:	e8 c0 cd ff ff       	call   801246 <_panic>
  804486:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80448c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80448f:	89 50 04             	mov    %edx,0x4(%eax)
  804492:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804495:	8b 40 04             	mov    0x4(%eax),%eax
  804498:	85 c0                	test   %eax,%eax
  80449a:	74 0c                	je     8044a8 <realloc_block_FF+0x38e>
  80449c:	a1 30 60 80 00       	mov    0x806030,%eax
  8044a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8044a4:	89 10                	mov    %edx,(%eax)
  8044a6:	eb 08                	jmp    8044b0 <realloc_block_FF+0x396>
  8044a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044ab:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8044b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044b3:	a3 30 60 80 00       	mov    %eax,0x806030
  8044b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044c1:	a1 38 60 80 00       	mov    0x806038,%eax
  8044c6:	40                   	inc    %eax
  8044c7:	a3 38 60 80 00       	mov    %eax,0x806038
  8044cc:	e9 cc 00 00 00       	jmp    80459d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8044d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8044d8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8044dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044e0:	e9 8a 00 00 00       	jmp    80456f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8044eb:	73 7a                	jae    804567 <realloc_block_FF+0x44d>
  8044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044f0:	8b 00                	mov    (%eax),%eax
  8044f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8044f5:	73 70                	jae    804567 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8044f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044fb:	74 06                	je     804503 <realloc_block_FF+0x3e9>
  8044fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804501:	75 17                	jne    80451a <realloc_block_FF+0x400>
  804503:	83 ec 04             	sub    $0x4,%esp
  804506:	68 34 5f 80 00       	push   $0x805f34
  80450b:	68 1a 02 00 00       	push   $0x21a
  804510:	68 c1 5e 80 00       	push   $0x805ec1
  804515:	e8 2c cd ff ff       	call   801246 <_panic>
  80451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80451d:	8b 10                	mov    (%eax),%edx
  80451f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804522:	89 10                	mov    %edx,(%eax)
  804524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804527:	8b 00                	mov    (%eax),%eax
  804529:	85 c0                	test   %eax,%eax
  80452b:	74 0b                	je     804538 <realloc_block_FF+0x41e>
  80452d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804530:	8b 00                	mov    (%eax),%eax
  804532:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804535:	89 50 04             	mov    %edx,0x4(%eax)
  804538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80453b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80453e:	89 10                	mov    %edx,(%eax)
  804540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804546:	89 50 04             	mov    %edx,0x4(%eax)
  804549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80454c:	8b 00                	mov    (%eax),%eax
  80454e:	85 c0                	test   %eax,%eax
  804550:	75 08                	jne    80455a <realloc_block_FF+0x440>
  804552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804555:	a3 30 60 80 00       	mov    %eax,0x806030
  80455a:	a1 38 60 80 00       	mov    0x806038,%eax
  80455f:	40                   	inc    %eax
  804560:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  804565:	eb 36                	jmp    80459d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804567:	a1 34 60 80 00       	mov    0x806034,%eax
  80456c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80456f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804573:	74 07                	je     80457c <realloc_block_FF+0x462>
  804575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804578:	8b 00                	mov    (%eax),%eax
  80457a:	eb 05                	jmp    804581 <realloc_block_FF+0x467>
  80457c:	b8 00 00 00 00       	mov    $0x0,%eax
  804581:	a3 34 60 80 00       	mov    %eax,0x806034
  804586:	a1 34 60 80 00       	mov    0x806034,%eax
  80458b:	85 c0                	test   %eax,%eax
  80458d:	0f 85 52 ff ff ff    	jne    8044e5 <realloc_block_FF+0x3cb>
  804593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804597:	0f 85 48 ff ff ff    	jne    8044e5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80459d:	83 ec 04             	sub    $0x4,%esp
  8045a0:	6a 00                	push   $0x0
  8045a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8045a5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8045a8:	e8 9d eb ff ff       	call   80314a <set_block_data>
  8045ad:	83 c4 10             	add    $0x10,%esp
				return va;
  8045b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b3:	e9 6b 02 00 00       	jmp    804823 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8045b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bb:	e9 63 02 00 00       	jmp    804823 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8045c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045c3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8045c6:	0f 86 4d 02 00 00    	jbe    804819 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8045cc:	83 ec 0c             	sub    $0xc,%esp
  8045cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8045d2:	e8 3b e8 ff ff       	call   802e12 <is_free_block>
  8045d7:	83 c4 10             	add    $0x10,%esp
  8045da:	84 c0                	test   %al,%al
  8045dc:	0f 84 37 02 00 00    	je     804819 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8045e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8045e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8045eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8045ee:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8045f1:	76 38                	jbe    80462b <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8045f3:	83 ec 0c             	sub    $0xc,%esp
  8045f6:	ff 75 0c             	pushl  0xc(%ebp)
  8045f9:	e8 7b eb ff ff       	call   803179 <alloc_block_FF>
  8045fe:	83 c4 10             	add    $0x10,%esp
  804601:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804604:	83 ec 08             	sub    $0x8,%esp
  804607:	ff 75 c0             	pushl  -0x40(%ebp)
  80460a:	ff 75 08             	pushl  0x8(%ebp)
  80460d:	e8 c9 fa ff ff       	call   8040db <copy_data>
  804612:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804615:	83 ec 0c             	sub    $0xc,%esp
  804618:	ff 75 08             	pushl  0x8(%ebp)
  80461b:	e8 fa f9 ff ff       	call   80401a <free_block>
  804620:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804623:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804626:	e9 f8 01 00 00       	jmp    804823 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80462b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80462e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804631:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804634:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804638:	0f 87 a0 00 00 00    	ja     8046de <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80463e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804642:	75 17                	jne    80465b <realloc_block_FF+0x541>
  804644:	83 ec 04             	sub    $0x4,%esp
  804647:	68 a3 5e 80 00       	push   $0x805ea3
  80464c:	68 38 02 00 00       	push   $0x238
  804651:	68 c1 5e 80 00       	push   $0x805ec1
  804656:	e8 eb cb ff ff       	call   801246 <_panic>
  80465b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80465e:	8b 00                	mov    (%eax),%eax
  804660:	85 c0                	test   %eax,%eax
  804662:	74 10                	je     804674 <realloc_block_FF+0x55a>
  804664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804667:	8b 00                	mov    (%eax),%eax
  804669:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80466c:	8b 52 04             	mov    0x4(%edx),%edx
  80466f:	89 50 04             	mov    %edx,0x4(%eax)
  804672:	eb 0b                	jmp    80467f <realloc_block_FF+0x565>
  804674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804677:	8b 40 04             	mov    0x4(%eax),%eax
  80467a:	a3 30 60 80 00       	mov    %eax,0x806030
  80467f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804682:	8b 40 04             	mov    0x4(%eax),%eax
  804685:	85 c0                	test   %eax,%eax
  804687:	74 0f                	je     804698 <realloc_block_FF+0x57e>
  804689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80468c:	8b 40 04             	mov    0x4(%eax),%eax
  80468f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804692:	8b 12                	mov    (%edx),%edx
  804694:	89 10                	mov    %edx,(%eax)
  804696:	eb 0a                	jmp    8046a2 <realloc_block_FF+0x588>
  804698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80469b:	8b 00                	mov    (%eax),%eax
  80469d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8046a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046b5:	a1 38 60 80 00       	mov    0x806038,%eax
  8046ba:	48                   	dec    %eax
  8046bb:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8046c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8046c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8046c6:	01 d0                	add    %edx,%eax
  8046c8:	83 ec 04             	sub    $0x4,%esp
  8046cb:	6a 01                	push   $0x1
  8046cd:	50                   	push   %eax
  8046ce:	ff 75 08             	pushl  0x8(%ebp)
  8046d1:	e8 74 ea ff ff       	call   80314a <set_block_data>
  8046d6:	83 c4 10             	add    $0x10,%esp
  8046d9:	e9 36 01 00 00       	jmp    804814 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8046de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8046e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8046e4:	01 d0                	add    %edx,%eax
  8046e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8046e9:	83 ec 04             	sub    $0x4,%esp
  8046ec:	6a 01                	push   $0x1
  8046ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8046f1:	ff 75 08             	pushl  0x8(%ebp)
  8046f4:	e8 51 ea ff ff       	call   80314a <set_block_data>
  8046f9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8046fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ff:	83 e8 04             	sub    $0x4,%eax
  804702:	8b 00                	mov    (%eax),%eax
  804704:	83 e0 fe             	and    $0xfffffffe,%eax
  804707:	89 c2                	mov    %eax,%edx
  804709:	8b 45 08             	mov    0x8(%ebp),%eax
  80470c:	01 d0                	add    %edx,%eax
  80470e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804711:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804715:	74 06                	je     80471d <realloc_block_FF+0x603>
  804717:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80471b:	75 17                	jne    804734 <realloc_block_FF+0x61a>
  80471d:	83 ec 04             	sub    $0x4,%esp
  804720:	68 34 5f 80 00       	push   $0x805f34
  804725:	68 44 02 00 00       	push   $0x244
  80472a:	68 c1 5e 80 00       	push   $0x805ec1
  80472f:	e8 12 cb ff ff       	call   801246 <_panic>
  804734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804737:	8b 10                	mov    (%eax),%edx
  804739:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80473c:	89 10                	mov    %edx,(%eax)
  80473e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804741:	8b 00                	mov    (%eax),%eax
  804743:	85 c0                	test   %eax,%eax
  804745:	74 0b                	je     804752 <realloc_block_FF+0x638>
  804747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80474a:	8b 00                	mov    (%eax),%eax
  80474c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80474f:	89 50 04             	mov    %edx,0x4(%eax)
  804752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804755:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804758:	89 10                	mov    %edx,(%eax)
  80475a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80475d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804760:	89 50 04             	mov    %edx,0x4(%eax)
  804763:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804766:	8b 00                	mov    (%eax),%eax
  804768:	85 c0                	test   %eax,%eax
  80476a:	75 08                	jne    804774 <realloc_block_FF+0x65a>
  80476c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80476f:	a3 30 60 80 00       	mov    %eax,0x806030
  804774:	a1 38 60 80 00       	mov    0x806038,%eax
  804779:	40                   	inc    %eax
  80477a:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80477f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804783:	75 17                	jne    80479c <realloc_block_FF+0x682>
  804785:	83 ec 04             	sub    $0x4,%esp
  804788:	68 a3 5e 80 00       	push   $0x805ea3
  80478d:	68 45 02 00 00       	push   $0x245
  804792:	68 c1 5e 80 00       	push   $0x805ec1
  804797:	e8 aa ca ff ff       	call   801246 <_panic>
  80479c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80479f:	8b 00                	mov    (%eax),%eax
  8047a1:	85 c0                	test   %eax,%eax
  8047a3:	74 10                	je     8047b5 <realloc_block_FF+0x69b>
  8047a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047a8:	8b 00                	mov    (%eax),%eax
  8047aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047ad:	8b 52 04             	mov    0x4(%edx),%edx
  8047b0:	89 50 04             	mov    %edx,0x4(%eax)
  8047b3:	eb 0b                	jmp    8047c0 <realloc_block_FF+0x6a6>
  8047b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047b8:	8b 40 04             	mov    0x4(%eax),%eax
  8047bb:	a3 30 60 80 00       	mov    %eax,0x806030
  8047c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047c3:	8b 40 04             	mov    0x4(%eax),%eax
  8047c6:	85 c0                	test   %eax,%eax
  8047c8:	74 0f                	je     8047d9 <realloc_block_FF+0x6bf>
  8047ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047cd:	8b 40 04             	mov    0x4(%eax),%eax
  8047d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047d3:	8b 12                	mov    (%edx),%edx
  8047d5:	89 10                	mov    %edx,(%eax)
  8047d7:	eb 0a                	jmp    8047e3 <realloc_block_FF+0x6c9>
  8047d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047dc:	8b 00                	mov    (%eax),%eax
  8047de:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8047e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047f6:	a1 38 60 80 00       	mov    0x806038,%eax
  8047fb:	48                   	dec    %eax
  8047fc:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804801:	83 ec 04             	sub    $0x4,%esp
  804804:	6a 00                	push   $0x0
  804806:	ff 75 bc             	pushl  -0x44(%ebp)
  804809:	ff 75 b8             	pushl  -0x48(%ebp)
  80480c:	e8 39 e9 ff ff       	call   80314a <set_block_data>
  804811:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804814:	8b 45 08             	mov    0x8(%ebp),%eax
  804817:	eb 0a                	jmp    804823 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804819:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804820:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804823:	c9                   	leave  
  804824:	c3                   	ret    

00804825 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804825:	55                   	push   %ebp
  804826:	89 e5                	mov    %esp,%ebp
  804828:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80482b:	83 ec 04             	sub    $0x4,%esp
  80482e:	68 a0 5f 80 00       	push   $0x805fa0
  804833:	68 58 02 00 00       	push   $0x258
  804838:	68 c1 5e 80 00       	push   $0x805ec1
  80483d:	e8 04 ca ff ff       	call   801246 <_panic>

00804842 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804842:	55                   	push   %ebp
  804843:	89 e5                	mov    %esp,%ebp
  804845:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804848:	83 ec 04             	sub    $0x4,%esp
  80484b:	68 c8 5f 80 00       	push   $0x805fc8
  804850:	68 61 02 00 00       	push   $0x261
  804855:	68 c1 5e 80 00       	push   $0x805ec1
  80485a:	e8 e7 c9 ff ff       	call   801246 <_panic>
  80485f:	90                   	nop

00804860 <__udivdi3>:
  804860:	55                   	push   %ebp
  804861:	57                   	push   %edi
  804862:	56                   	push   %esi
  804863:	53                   	push   %ebx
  804864:	83 ec 1c             	sub    $0x1c,%esp
  804867:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80486b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80486f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804873:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804877:	89 ca                	mov    %ecx,%edx
  804879:	89 f8                	mov    %edi,%eax
  80487b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80487f:	85 f6                	test   %esi,%esi
  804881:	75 2d                	jne    8048b0 <__udivdi3+0x50>
  804883:	39 cf                	cmp    %ecx,%edi
  804885:	77 65                	ja     8048ec <__udivdi3+0x8c>
  804887:	89 fd                	mov    %edi,%ebp
  804889:	85 ff                	test   %edi,%edi
  80488b:	75 0b                	jne    804898 <__udivdi3+0x38>
  80488d:	b8 01 00 00 00       	mov    $0x1,%eax
  804892:	31 d2                	xor    %edx,%edx
  804894:	f7 f7                	div    %edi
  804896:	89 c5                	mov    %eax,%ebp
  804898:	31 d2                	xor    %edx,%edx
  80489a:	89 c8                	mov    %ecx,%eax
  80489c:	f7 f5                	div    %ebp
  80489e:	89 c1                	mov    %eax,%ecx
  8048a0:	89 d8                	mov    %ebx,%eax
  8048a2:	f7 f5                	div    %ebp
  8048a4:	89 cf                	mov    %ecx,%edi
  8048a6:	89 fa                	mov    %edi,%edx
  8048a8:	83 c4 1c             	add    $0x1c,%esp
  8048ab:	5b                   	pop    %ebx
  8048ac:	5e                   	pop    %esi
  8048ad:	5f                   	pop    %edi
  8048ae:	5d                   	pop    %ebp
  8048af:	c3                   	ret    
  8048b0:	39 ce                	cmp    %ecx,%esi
  8048b2:	77 28                	ja     8048dc <__udivdi3+0x7c>
  8048b4:	0f bd fe             	bsr    %esi,%edi
  8048b7:	83 f7 1f             	xor    $0x1f,%edi
  8048ba:	75 40                	jne    8048fc <__udivdi3+0x9c>
  8048bc:	39 ce                	cmp    %ecx,%esi
  8048be:	72 0a                	jb     8048ca <__udivdi3+0x6a>
  8048c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8048c4:	0f 87 9e 00 00 00    	ja     804968 <__udivdi3+0x108>
  8048ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8048cf:	89 fa                	mov    %edi,%edx
  8048d1:	83 c4 1c             	add    $0x1c,%esp
  8048d4:	5b                   	pop    %ebx
  8048d5:	5e                   	pop    %esi
  8048d6:	5f                   	pop    %edi
  8048d7:	5d                   	pop    %ebp
  8048d8:	c3                   	ret    
  8048d9:	8d 76 00             	lea    0x0(%esi),%esi
  8048dc:	31 ff                	xor    %edi,%edi
  8048de:	31 c0                	xor    %eax,%eax
  8048e0:	89 fa                	mov    %edi,%edx
  8048e2:	83 c4 1c             	add    $0x1c,%esp
  8048e5:	5b                   	pop    %ebx
  8048e6:	5e                   	pop    %esi
  8048e7:	5f                   	pop    %edi
  8048e8:	5d                   	pop    %ebp
  8048e9:	c3                   	ret    
  8048ea:	66 90                	xchg   %ax,%ax
  8048ec:	89 d8                	mov    %ebx,%eax
  8048ee:	f7 f7                	div    %edi
  8048f0:	31 ff                	xor    %edi,%edi
  8048f2:	89 fa                	mov    %edi,%edx
  8048f4:	83 c4 1c             	add    $0x1c,%esp
  8048f7:	5b                   	pop    %ebx
  8048f8:	5e                   	pop    %esi
  8048f9:	5f                   	pop    %edi
  8048fa:	5d                   	pop    %ebp
  8048fb:	c3                   	ret    
  8048fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  804901:	89 eb                	mov    %ebp,%ebx
  804903:	29 fb                	sub    %edi,%ebx
  804905:	89 f9                	mov    %edi,%ecx
  804907:	d3 e6                	shl    %cl,%esi
  804909:	89 c5                	mov    %eax,%ebp
  80490b:	88 d9                	mov    %bl,%cl
  80490d:	d3 ed                	shr    %cl,%ebp
  80490f:	89 e9                	mov    %ebp,%ecx
  804911:	09 f1                	or     %esi,%ecx
  804913:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804917:	89 f9                	mov    %edi,%ecx
  804919:	d3 e0                	shl    %cl,%eax
  80491b:	89 c5                	mov    %eax,%ebp
  80491d:	89 d6                	mov    %edx,%esi
  80491f:	88 d9                	mov    %bl,%cl
  804921:	d3 ee                	shr    %cl,%esi
  804923:	89 f9                	mov    %edi,%ecx
  804925:	d3 e2                	shl    %cl,%edx
  804927:	8b 44 24 08          	mov    0x8(%esp),%eax
  80492b:	88 d9                	mov    %bl,%cl
  80492d:	d3 e8                	shr    %cl,%eax
  80492f:	09 c2                	or     %eax,%edx
  804931:	89 d0                	mov    %edx,%eax
  804933:	89 f2                	mov    %esi,%edx
  804935:	f7 74 24 0c          	divl   0xc(%esp)
  804939:	89 d6                	mov    %edx,%esi
  80493b:	89 c3                	mov    %eax,%ebx
  80493d:	f7 e5                	mul    %ebp
  80493f:	39 d6                	cmp    %edx,%esi
  804941:	72 19                	jb     80495c <__udivdi3+0xfc>
  804943:	74 0b                	je     804950 <__udivdi3+0xf0>
  804945:	89 d8                	mov    %ebx,%eax
  804947:	31 ff                	xor    %edi,%edi
  804949:	e9 58 ff ff ff       	jmp    8048a6 <__udivdi3+0x46>
  80494e:	66 90                	xchg   %ax,%ax
  804950:	8b 54 24 08          	mov    0x8(%esp),%edx
  804954:	89 f9                	mov    %edi,%ecx
  804956:	d3 e2                	shl    %cl,%edx
  804958:	39 c2                	cmp    %eax,%edx
  80495a:	73 e9                	jae    804945 <__udivdi3+0xe5>
  80495c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80495f:	31 ff                	xor    %edi,%edi
  804961:	e9 40 ff ff ff       	jmp    8048a6 <__udivdi3+0x46>
  804966:	66 90                	xchg   %ax,%ax
  804968:	31 c0                	xor    %eax,%eax
  80496a:	e9 37 ff ff ff       	jmp    8048a6 <__udivdi3+0x46>
  80496f:	90                   	nop

00804970 <__umoddi3>:
  804970:	55                   	push   %ebp
  804971:	57                   	push   %edi
  804972:	56                   	push   %esi
  804973:	53                   	push   %ebx
  804974:	83 ec 1c             	sub    $0x1c,%esp
  804977:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80497b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80497f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804983:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804987:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80498b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80498f:	89 f3                	mov    %esi,%ebx
  804991:	89 fa                	mov    %edi,%edx
  804993:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804997:	89 34 24             	mov    %esi,(%esp)
  80499a:	85 c0                	test   %eax,%eax
  80499c:	75 1a                	jne    8049b8 <__umoddi3+0x48>
  80499e:	39 f7                	cmp    %esi,%edi
  8049a0:	0f 86 a2 00 00 00    	jbe    804a48 <__umoddi3+0xd8>
  8049a6:	89 c8                	mov    %ecx,%eax
  8049a8:	89 f2                	mov    %esi,%edx
  8049aa:	f7 f7                	div    %edi
  8049ac:	89 d0                	mov    %edx,%eax
  8049ae:	31 d2                	xor    %edx,%edx
  8049b0:	83 c4 1c             	add    $0x1c,%esp
  8049b3:	5b                   	pop    %ebx
  8049b4:	5e                   	pop    %esi
  8049b5:	5f                   	pop    %edi
  8049b6:	5d                   	pop    %ebp
  8049b7:	c3                   	ret    
  8049b8:	39 f0                	cmp    %esi,%eax
  8049ba:	0f 87 ac 00 00 00    	ja     804a6c <__umoddi3+0xfc>
  8049c0:	0f bd e8             	bsr    %eax,%ebp
  8049c3:	83 f5 1f             	xor    $0x1f,%ebp
  8049c6:	0f 84 ac 00 00 00    	je     804a78 <__umoddi3+0x108>
  8049cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8049d1:	29 ef                	sub    %ebp,%edi
  8049d3:	89 fe                	mov    %edi,%esi
  8049d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8049d9:	89 e9                	mov    %ebp,%ecx
  8049db:	d3 e0                	shl    %cl,%eax
  8049dd:	89 d7                	mov    %edx,%edi
  8049df:	89 f1                	mov    %esi,%ecx
  8049e1:	d3 ef                	shr    %cl,%edi
  8049e3:	09 c7                	or     %eax,%edi
  8049e5:	89 e9                	mov    %ebp,%ecx
  8049e7:	d3 e2                	shl    %cl,%edx
  8049e9:	89 14 24             	mov    %edx,(%esp)
  8049ec:	89 d8                	mov    %ebx,%eax
  8049ee:	d3 e0                	shl    %cl,%eax
  8049f0:	89 c2                	mov    %eax,%edx
  8049f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049f6:	d3 e0                	shl    %cl,%eax
  8049f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8049fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a00:	89 f1                	mov    %esi,%ecx
  804a02:	d3 e8                	shr    %cl,%eax
  804a04:	09 d0                	or     %edx,%eax
  804a06:	d3 eb                	shr    %cl,%ebx
  804a08:	89 da                	mov    %ebx,%edx
  804a0a:	f7 f7                	div    %edi
  804a0c:	89 d3                	mov    %edx,%ebx
  804a0e:	f7 24 24             	mull   (%esp)
  804a11:	89 c6                	mov    %eax,%esi
  804a13:	89 d1                	mov    %edx,%ecx
  804a15:	39 d3                	cmp    %edx,%ebx
  804a17:	0f 82 87 00 00 00    	jb     804aa4 <__umoddi3+0x134>
  804a1d:	0f 84 91 00 00 00    	je     804ab4 <__umoddi3+0x144>
  804a23:	8b 54 24 04          	mov    0x4(%esp),%edx
  804a27:	29 f2                	sub    %esi,%edx
  804a29:	19 cb                	sbb    %ecx,%ebx
  804a2b:	89 d8                	mov    %ebx,%eax
  804a2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804a31:	d3 e0                	shl    %cl,%eax
  804a33:	89 e9                	mov    %ebp,%ecx
  804a35:	d3 ea                	shr    %cl,%edx
  804a37:	09 d0                	or     %edx,%eax
  804a39:	89 e9                	mov    %ebp,%ecx
  804a3b:	d3 eb                	shr    %cl,%ebx
  804a3d:	89 da                	mov    %ebx,%edx
  804a3f:	83 c4 1c             	add    $0x1c,%esp
  804a42:	5b                   	pop    %ebx
  804a43:	5e                   	pop    %esi
  804a44:	5f                   	pop    %edi
  804a45:	5d                   	pop    %ebp
  804a46:	c3                   	ret    
  804a47:	90                   	nop
  804a48:	89 fd                	mov    %edi,%ebp
  804a4a:	85 ff                	test   %edi,%edi
  804a4c:	75 0b                	jne    804a59 <__umoddi3+0xe9>
  804a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  804a53:	31 d2                	xor    %edx,%edx
  804a55:	f7 f7                	div    %edi
  804a57:	89 c5                	mov    %eax,%ebp
  804a59:	89 f0                	mov    %esi,%eax
  804a5b:	31 d2                	xor    %edx,%edx
  804a5d:	f7 f5                	div    %ebp
  804a5f:	89 c8                	mov    %ecx,%eax
  804a61:	f7 f5                	div    %ebp
  804a63:	89 d0                	mov    %edx,%eax
  804a65:	e9 44 ff ff ff       	jmp    8049ae <__umoddi3+0x3e>
  804a6a:	66 90                	xchg   %ax,%ax
  804a6c:	89 c8                	mov    %ecx,%eax
  804a6e:	89 f2                	mov    %esi,%edx
  804a70:	83 c4 1c             	add    $0x1c,%esp
  804a73:	5b                   	pop    %ebx
  804a74:	5e                   	pop    %esi
  804a75:	5f                   	pop    %edi
  804a76:	5d                   	pop    %ebp
  804a77:	c3                   	ret    
  804a78:	3b 04 24             	cmp    (%esp),%eax
  804a7b:	72 06                	jb     804a83 <__umoddi3+0x113>
  804a7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804a81:	77 0f                	ja     804a92 <__umoddi3+0x122>
  804a83:	89 f2                	mov    %esi,%edx
  804a85:	29 f9                	sub    %edi,%ecx
  804a87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804a8b:	89 14 24             	mov    %edx,(%esp)
  804a8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a92:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a96:	8b 14 24             	mov    (%esp),%edx
  804a99:	83 c4 1c             	add    $0x1c,%esp
  804a9c:	5b                   	pop    %ebx
  804a9d:	5e                   	pop    %esi
  804a9e:	5f                   	pop    %edi
  804a9f:	5d                   	pop    %ebp
  804aa0:	c3                   	ret    
  804aa1:	8d 76 00             	lea    0x0(%esi),%esi
  804aa4:	2b 04 24             	sub    (%esp),%eax
  804aa7:	19 fa                	sbb    %edi,%edx
  804aa9:	89 d1                	mov    %edx,%ecx
  804aab:	89 c6                	mov    %eax,%esi
  804aad:	e9 71 ff ff ff       	jmp    804a23 <__umoddi3+0xb3>
  804ab2:	66 90                	xchg   %ax,%ax
  804ab4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804ab8:	72 ea                	jb     804aa4 <__umoddi3+0x134>
  804aba:	89 d9                	mov    %ebx,%ecx
  804abc:	e9 62 ff ff ff       	jmp    804a23 <__umoddi3+0xb3>
