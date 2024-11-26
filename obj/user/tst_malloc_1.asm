
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
  800064:	a1 20 70 80 00       	mov    0x807020,%eax
  800069:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80006f:	a1 20 70 80 00       	mov    0x807020,%eax
  800074:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 20 4b 80 00       	push   $0x804b20
  800086:	6a 1f                	push   $0x1f
  800088:	68 3c 4b 80 00       	push   $0x804b3c
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
  8000d7:	e8 26 28 00 00       	call   802902 <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 50 4b 80 00       	push   $0x804b50
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
  800103:	e8 fa 27 00 00       	call   802902 <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 3d 28 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  800142:	68 b0 4b 80 00       	push   $0x804bb0
  800147:	e8 b7 13 00 00       	call   801503 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 a4 27 00 00       	call   802902 <sys_calculate_free_frames>
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
  800195:	68 e4 4b 80 00       	push   $0x804be4
  80019a:	e8 64 13 00 00       	call   801503 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 a6 27 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 54 4c 80 00       	push   $0x804c54
  8001bb:	e8 43 13 00 00       	call   801503 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 3a 27 00 00       	call   802902 <sys_calculate_free_frames>
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
  8001ff:	e8 fe 26 00 00       	call   802902 <sys_calculate_free_frames>
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
  800237:	68 88 4c 80 00       	push   $0x804c88
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
  80027e:	e8 da 2a 00 00       	call   802d5d <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 08 4d 80 00       	push   $0x804d08
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
  8002b7:	e8 46 26 00 00       	call   802902 <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 89 26 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  800303:	68 2c 4d 80 00       	push   $0x804d2c
  800308:	e8 f6 11 00 00       	call   801503 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 e3 25 00 00       	call   802902 <sys_calculate_free_frames>
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
  800356:	68 60 4d 80 00       	push   $0x804d60
  80035b:	e8 a3 11 00 00       	call   801503 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 e5 25 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 d0 4d 80 00       	push   $0x804dd0
  80037c:	e8 82 11 00 00       	call   801503 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 79 25 00 00       	call   802902 <sys_calculate_free_frames>
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
  8003c9:	e8 34 25 00 00       	call   802902 <sys_calculate_free_frames>
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
  800401:	68 04 4e 80 00       	push   $0x804e04
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
  80044c:	e8 0c 29 00 00       	call   802d5d <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 84 4e 80 00       	push   $0x804e84
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
  800485:	e8 c3 24 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  8004cb:	68 a8 4e 80 00       	push   $0x804ea8
  8004d0:	e8 2e 10 00 00       	call   801503 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 1b 24 00 00       	call   802902 <sys_calculate_free_frames>
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
  80051e:	68 dc 4e 80 00       	push   $0x804edc
  800523:	e8 db 0f 00 00       	call   801503 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 1d 24 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 4c 4f 80 00       	push   $0x804f4c
  800544:	e8 ba 0f 00 00       	call   801503 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 b1 23 00 00       	call   802902 <sys_calculate_free_frames>
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
  80058f:	e8 6e 23 00 00       	call   802902 <sys_calculate_free_frames>
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
  8005c7:	68 80 4f 80 00       	push   $0x804f80
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
  800615:	e8 43 27 00 00       	call   802d5d <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 00 50 80 00       	push   $0x805000
  800635:	e8 c9 0e 00 00       	call   801503 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 0b 23 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  80068b:	68 24 50 80 00       	push   $0x805024
  800690:	e8 6e 0e 00 00       	call   801503 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 b0 22 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 58 50 80 00       	push   $0x805058
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
  8006ca:	e8 33 22 00 00       	call   802902 <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 76 22 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  800724:	68 8c 50 80 00       	push   $0x80508c
  800729:	e8 d5 0d 00 00       	call   801503 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 c2 21 00 00       	call   802902 <sys_calculate_free_frames>
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
  800777:	68 c0 50 80 00       	push   $0x8050c0
  80077c:	e8 82 0d 00 00       	call   801503 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 c4 21 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 30 51 80 00       	push   $0x805130
  80079d:	e8 61 0d 00 00       	call   801503 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 58 21 00 00       	call   802902 <sys_calculate_free_frames>
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
  80082f:	e8 ce 20 00 00       	call   802902 <sys_calculate_free_frames>
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
  800867:	68 64 51 80 00       	push   $0x805164
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
  8008bb:	e8 9d 24 00 00       	call   802d5d <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 e4 51 80 00       	push   $0x8051e4
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
  8008f4:	e8 09 20 00 00       	call   802902 <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 4c 20 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  80094d:	68 08 52 80 00       	push   $0x805208
  800952:	e8 ac 0b 00 00       	call   801503 <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 99 1f 00 00       	call   802902 <sys_calculate_free_frames>
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
  8009a0:	68 3c 52 80 00       	push   $0x80523c
  8009a5:	e8 59 0b 00 00       	call   801503 <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 9b 1f 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 ac 52 80 00       	push   $0x8052ac
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
  8009df:	e8 1e 1f 00 00       	call   802902 <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 61 1f 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  800a41:	68 e0 52 80 00       	push   $0x8052e0
  800a46:	e8 b8 0a 00 00       	call   801503 <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 a5 1e 00 00       	call   802902 <sys_calculate_free_frames>
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
  800a94:	68 14 53 80 00       	push   $0x805314
  800a99:	e8 65 0a 00 00       	call   801503 <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 a7 1e 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 84 53 80 00       	push   $0x805384
  800aba:	e8 44 0a 00 00       	call   801503 <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 3b 1e 00 00       	call   802902 <sys_calculate_free_frames>
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
  800b3a:	e8 c3 1d 00 00       	call   802902 <sys_calculate_free_frames>
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
  800b72:	68 b8 53 80 00       	push   $0x8053b8
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
  800bfe:	e8 5a 21 00 00       	call   802d5d <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 38 54 80 00       	push   $0x805438
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
  800c37:	e8 c6 1c 00 00       	call   802902 <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 09 1d 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
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
  800c9b:	68 5c 54 80 00       	push   $0x80545c
  800ca0:	e8 5e 08 00 00       	call   801503 <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 4b 1c 00 00       	call   802902 <sys_calculate_free_frames>
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
  800cee:	68 90 54 80 00       	push   $0x805490
  800cf3:	e8 0b 08 00 00       	call   801503 <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 4d 1c 00 00       	call   80294d <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 00 55 80 00       	push   $0x805500
  800d14:	e8 ea 07 00 00       	call   801503 <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 e1 1b 00 00       	call   802902 <sys_calculate_free_frames>
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
  800da5:	e8 58 1b 00 00       	call   802902 <sys_calculate_free_frames>
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
  800ddd:	68 34 55 80 00       	push   $0x805534
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
  800e6f:	e8 e9 1e 00 00       	call   802d5d <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 b4 55 80 00       	push   $0x8055b4
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
  800eab:	68 d8 55 80 00       	push   $0x8055d8
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
  800edb:	68 14 56 80 00       	push   $0x805614
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
  800f13:	68 4c 56 80 00       	push   $0x80564c
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
  800f4a:	68 88 56 80 00       	push   $0x805688
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
  800f81:	68 c4 56 80 00       	push   $0x8056c4
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
  800fbe:	68 00 57 80 00       	push   $0x805700
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
  800ff7:	68 3c 57 80 00       	push   $0x80573c
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
  80105b:	68 78 57 80 00       	push   $0x805778
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
  8010ce:	68 b4 57 80 00       	push   $0x8057b4
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
  8010f2:	68 f0 57 80 00       	push   $0x8057f0
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
  80110d:	e8 b9 19 00 00       	call   802acb <sys_getenvindex>
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
  80113c:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801141:	a1 20 70 80 00       	mov    0x807020,%eax
  801146:	8a 40 20             	mov    0x20(%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	74 0d                	je     80115a <libmain+0x53>
		binaryname = myEnv->prog_name;
  80114d:	a1 20 70 80 00       	mov    0x807020,%eax
  801152:	83 c0 20             	add    $0x20,%eax
  801155:	a3 00 70 80 00       	mov    %eax,0x807000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	7e 0a                	jle    80116a <libmain+0x63>
		binaryname = argv[0];
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	_main(argc, argv);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 e1 ee ff ff       	call   800059 <_main>
  801178:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80117b:	e8 cf 16 00 00       	call   80284f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	68 44 58 80 00       	push   $0x805844
  801188:	e8 76 03 00 00       	call   801503 <cprintf>
  80118d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801190:	a1 20 70 80 00       	mov    0x807020,%eax
  801195:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80119b:	a1 20 70 80 00       	mov    0x807020,%eax
  8011a0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	52                   	push   %edx
  8011aa:	50                   	push   %eax
  8011ab:	68 6c 58 80 00       	push   $0x80586c
  8011b0:	e8 4e 03 00 00       	call   801503 <cprintf>
  8011b5:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8011b8:	a1 20 70 80 00       	mov    0x807020,%eax
  8011bd:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8011c3:	a1 20 70 80 00       	mov    0x807020,%eax
  8011c8:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8011ce:	a1 20 70 80 00       	mov    0x807020,%eax
  8011d3:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8011d9:	51                   	push   %ecx
  8011da:	52                   	push   %edx
  8011db:	50                   	push   %eax
  8011dc:	68 94 58 80 00       	push   $0x805894
  8011e1:	e8 1d 03 00 00       	call   801503 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8011e9:	a1 20 70 80 00       	mov    0x807020,%eax
  8011ee:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	50                   	push   %eax
  8011f8:	68 ec 58 80 00       	push   $0x8058ec
  8011fd:	e8 01 03 00 00       	call   801503 <cprintf>
  801202:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	68 44 58 80 00       	push   $0x805844
  80120d:	e8 f1 02 00 00       	call   801503 <cprintf>
  801212:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801215:	e8 4f 16 00 00       	call   802869 <sys_unlock_cons>
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
  80122d:	e8 65 18 00 00       	call   802a97 <sys_destroy_env>
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
  80123e:	e8 ba 18 00 00       	call   802afd <sys_exit_env>
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
  801255:	a1 4c 70 80 00       	mov    0x80704c,%eax
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 16                	je     801274 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80125e:	a1 4c 70 80 00       	mov    0x80704c,%eax
  801263:	83 ec 08             	sub    $0x8,%esp
  801266:	50                   	push   %eax
  801267:	68 00 59 80 00       	push   $0x805900
  80126c:	e8 92 02 00 00       	call   801503 <cprintf>
  801271:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801274:	a1 00 70 80 00       	mov    0x807000,%eax
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	ff 75 08             	pushl  0x8(%ebp)
  80127f:	50                   	push   %eax
  801280:	68 05 59 80 00       	push   $0x805905
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
  8012a4:	68 21 59 80 00       	push   $0x805921
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
  8012be:	a1 20 70 80 00       	mov    0x807020,%eax
  8012c3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	39 c2                	cmp    %eax,%edx
  8012ce:	74 14                	je     8012e4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 24 59 80 00       	push   $0x805924
  8012d8:	6a 26                	push   $0x26
  8012da:	68 70 59 80 00       	push   $0x805970
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
  801324:	a1 20 70 80 00       	mov    0x807020,%eax
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
  801344:	a1 20 70 80 00       	mov    0x807020,%eax
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
  80138d:	a1 20 70 80 00       	mov    0x807020,%eax
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
  8013a8:	68 7c 59 80 00       	push   $0x80597c
  8013ad:	6a 3a                	push   $0x3a
  8013af:	68 70 59 80 00       	push   $0x805970
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
  8013d8:	a1 20 70 80 00       	mov    0x807020,%eax
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
  8013fe:	a1 20 70 80 00       	mov    0x807020,%eax
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
  80141b:	68 d0 59 80 00       	push   $0x8059d0
  801420:	6a 44                	push   $0x44
  801422:	68 70 59 80 00       	push   $0x805970
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
  80145a:	a0 28 70 80 00       	mov    0x807028,%al
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
  801475:	e8 93 13 00 00       	call   80280d <sys_cputs>
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
  8014cf:	a0 28 70 80 00       	mov    0x807028,%al
  8014d4:	0f b6 c0             	movzbl %al,%eax
  8014d7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	50                   	push   %eax
  8014e1:	52                   	push   %edx
  8014e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014e8:	83 c0 08             	add    $0x8,%eax
  8014eb:	50                   	push   %eax
  8014ec:	e8 1c 13 00 00       	call   80280d <sys_cputs>
  8014f1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8014f4:	c6 05 28 70 80 00 00 	movb   $0x0,0x807028
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
  801509:	c6 05 28 70 80 00 01 	movb   $0x1,0x807028
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
  801536:	e8 14 13 00 00       	call   80284f <sys_lock_cons>
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
  801556:	e8 0e 13 00 00       	call   802869 <sys_unlock_cons>
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
  8015a0:	e8 ff 32 00 00       	call   8048a4 <__udivdi3>
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
  8015f0:	e8 bf 33 00 00       	call   8049b4 <__umoddi3>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	05 34 5c 80 00       	add    $0x805c34,%eax
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
  80174b:	8b 04 85 58 5c 80 00 	mov    0x805c58(,%eax,4),%eax
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
  80182c:	8b 34 9d a0 5a 80 00 	mov    0x805aa0(,%ebx,4),%esi
  801833:	85 f6                	test   %esi,%esi
  801835:	75 19                	jne    801850 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801837:	53                   	push   %ebx
  801838:	68 45 5c 80 00       	push   $0x805c45
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
  801851:	68 4e 5c 80 00       	push   $0x805c4e
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
  80187e:	be 51 5c 80 00       	mov    $0x805c51,%esi
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
  801a76:	c6 05 28 70 80 00 00 	movb   $0x0,0x807028
			break;
  801a7d:	eb 2c                	jmp    801aab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a7f:	c6 05 28 70 80 00 01 	movb   $0x1,0x807028
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
  802289:	68 c8 5d 80 00       	push   $0x805dc8
  80228e:	68 3f 01 00 00       	push   $0x13f
  802293:	68 ea 5d 80 00       	push   $0x805dea
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
  8022a9:	e8 0a 0b 00 00       	call   802db8 <sys_sbrk>
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
  8022f2:	a1 20 70 80 00       	mov    0x807020,%eax
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
  802324:	e8 13 09 00 00       	call   802c3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 16                	je     802343 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	e8 53 0e 00 00       	call   80318b <alloc_block_FF>
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	e9 8a 01 00 00       	jmp    8024cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802343:	e8 25 09 00 00       	call   802c6d <sys_isUHeapPlacementStrategyBESTFIT>
  802348:	85 c0                	test   %eax,%eax
  80234a:	0f 84 7d 01 00 00    	je     8024cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	e8 ec 12 00 00       	call   803647 <alloc_block_BF>
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
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  802373:	a1 20 70 80 00       	mov    0x807020,%eax
  802378:	8b 40 78             	mov    0x78(%eax),%eax
  80237b:	05 00 10 00 00       	add    $0x1000,%eax
  802380:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  802383:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80238a:	e9 de 00 00 00       	jmp    80246d <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80238f:	a1 20 70 80 00       	mov    0x807020,%eax
  802394:	8b 40 78             	mov    0x78(%eax),%eax
  802397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239a:	29 c2                	sub    %eax,%edx
  80239c:	89 d0                	mov    %edx,%eax
  80239e:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023a3:	c1 e8 0c             	shr    $0xc,%eax
  8023a6:	8b 04 85 60 70 88 00 	mov    0x887060(,%eax,4),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	0f 85 ab 00 00 00    	jne    802460 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	05 00 10 00 00       	add    $0x1000,%eax
  8023bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8023c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8023c7:	eb 47                	jmp    802410 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8023c9:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8023d0:	76 0a                	jbe    8023dc <malloc+0x129>
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d7:	e9 f4 00 00 00       	jmp    8024d0 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8023dc:	a1 20 70 80 00       	mov    0x807020,%eax
  8023e1:	8b 40 78             	mov    0x78(%eax),%eax
  8023e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e7:	29 c2                	sub    %eax,%edx
  8023e9:	89 d0                	mov    %edx,%eax
  8023eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023f0:	c1 e8 0c             	shr    $0xc,%eax
  8023f3:	8b 04 85 60 70 88 00 	mov    0x887060(,%eax,4),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 08                	je     802406 <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  802436:	a1 20 70 80 00       	mov    0x807020,%eax
  80243b:	8b 40 78             	mov    0x78(%eax),%eax
  80243e:	29 c2                	sub    %eax,%edx
  802440:	89 d0                	mov    %edx,%eax
  802442:	2d 00 10 00 00       	sub    $0x1000,%eax
  802447:	c1 e8 0c             	shr    $0xc,%eax
  80244a:	c7 04 85 60 70 88 00 	movl   $0x1,0x887060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  802460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802464:	75 16                	jne    80247c <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  802466:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80246d:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802474:	0f 86 15 ff ff ff    	jbe    80238f <malloc+0xdc>
  80247a:	eb 01                	jmp    80247d <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  802490:	a1 20 70 80 00       	mov    0x807020,%eax
  802495:	8b 40 78             	mov    0x78(%eax),%eax
  802498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249b:	29 c2                	sub    %eax,%edx
  80249d:	89 d0                	mov    %edx,%eax
  80249f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024a4:	c1 e8 0c             	shr    $0xc,%eax
  8024a7:	89 c2                	mov    %eax,%edx
  8024a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ac:	89 04 95 60 70 90 00 	mov    %eax,0x907060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8024b3:	83 ec 08             	sub    $0x8,%esp
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8024bc:	e8 2e 09 00 00       	call   802def <sys_allocate_user_mem>
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	eb 07                	jmp    8024cd <malloc+0x21a>
		//cprintf("91\n");
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
  8024d8:	a1 20 70 80 00       	mov    0x807020,%eax
  8024dd:	8b 40 78             	mov    0x78(%eax),%eax
  8024e0:	05 00 10 00 00       	add    $0x1000,%eax
  8024e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8024e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8024ef:	a1 20 70 80 00       	mov    0x807020,%eax
  8024f4:	8b 50 78             	mov    0x78(%eax),%edx
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	39 c2                	cmp    %eax,%edx
  8024fc:	76 24                	jbe    802522 <free+0x50>
		size = get_block_size(va);
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	ff 75 08             	pushl  0x8(%ebp)
  802504:	e8 02 09 00 00       	call   802e0b <get_block_size>
  802509:	83 c4 10             	add    $0x10,%esp
  80250c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 35 1b 00 00       	call   80404f <free_block>
  80251a:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  80253b:	a1 20 70 80 00       	mov    0x807020,%eax
  802540:	8b 40 78             	mov    0x78(%eax),%eax
  802543:	29 c2                	sub    %eax,%edx
  802545:	89 d0                	mov    %edx,%eax
  802547:	2d 00 10 00 00       	sub    $0x1000,%eax
  80254c:	c1 e8 0c             	shr    $0xc,%eax
  80254f:	8b 04 85 60 70 90 00 	mov    0x907060(,%eax,4),%eax
  802556:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255c:	c1 e0 0c             	shl    $0xc,%eax
  80255f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  802562:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802569:	eb 2f                	jmp    80259a <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c1 e0 0c             	shl    $0xc,%eax
  802571:	89 c2                	mov    %eax,%edx
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	01 c2                	add    %eax,%edx
  802578:	a1 20 70 80 00       	mov    0x807020,%eax
  80257d:	8b 40 78             	mov    0x78(%eax),%eax
  802580:	29 c2                	sub    %eax,%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	2d 00 10 00 00       	sub    $0x1000,%eax
  802589:	c1 e8 0c             	shr    $0xc,%eax
  80258c:	c7 04 85 60 70 88 00 	movl   $0x0,0x887060(,%eax,4)
  802593:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  802597:	ff 45 f4             	incl   -0xc(%ebp)
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025a0:	72 c9                	jb     80256b <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	83 ec 08             	sub    $0x8,%esp
  8025a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8025ab:	50                   	push   %eax
  8025ac:	e8 22 08 00 00       	call   802dd3 <sys_free_user_mem>
  8025b1:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8025b4:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8025b5:	eb 17                	jmp    8025ce <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 f8 5d 80 00       	push   $0x805df8
  8025bf:	68 85 00 00 00       	push   $0x85
  8025c4:	68 22 5e 80 00       	push   $0x805e22
  8025c9:	e8 78 ec ff ff       	call   801246 <_panic>
	}
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 28             	sub    $0x28,%esp
  8025d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8025dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025e0:	75 0a                	jne    8025ec <smalloc+0x1c>
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e7:	e9 9a 00 00 00       	jmp    802686 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8025ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8025f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	39 d0                	cmp    %edx,%eax
  802601:	73 02                	jae    802605 <smalloc+0x35>
  802603:	89 d0                	mov    %edx,%eax
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	50                   	push   %eax
  802609:	e8 a5 fc ff ff       	call   8022b3 <malloc>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802614:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802618:	75 07                	jne    802621 <smalloc+0x51>
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	eb 65                	jmp    802686 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802621:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802625:	ff 75 ec             	pushl  -0x14(%ebp)
  802628:	50                   	push   %eax
  802629:	ff 75 0c             	pushl  0xc(%ebp)
  80262c:	ff 75 08             	pushl  0x8(%ebp)
  80262f:	e8 a6 03 00 00       	call   8029da <sys_createSharedObject>
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80263a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80263e:	74 06                	je     802646 <smalloc+0x76>
  802640:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802644:	75 07                	jne    80264d <smalloc+0x7d>
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
  80264b:	eb 39                	jmp    802686 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80264d:	83 ec 08             	sub    $0x8,%esp
  802650:	ff 75 ec             	pushl  -0x14(%ebp)
  802653:	68 2e 5e 80 00       	push   $0x805e2e
  802658:	e8 a6 ee ff ff       	call   801503 <cprintf>
  80265d:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802660:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802663:	a1 20 70 80 00       	mov    0x807020,%eax
  802668:	8b 40 78             	mov    0x78(%eax),%eax
  80266b:	29 c2                	sub    %eax,%edx
  80266d:	89 d0                	mov    %edx,%eax
  80266f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802674:	c1 e8 0c             	shr    $0xc,%eax
  802677:	89 c2                	mov    %eax,%edx
  802679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267c:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	 return ptr;
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80268e:	83 ec 08             	sub    $0x8,%esp
  802691:	ff 75 0c             	pushl  0xc(%ebp)
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	e8 68 03 00 00       	call   802a04 <sys_getSizeOfSharedObject>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8026a2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8026a6:	75 07                	jne    8026af <sget+0x27>
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ad:	eb 7f                	jmp    80272e <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	39 d0                	cmp    %edx,%eax
  8026c4:	7d 02                	jge    8026c8 <sget+0x40>
  8026c6:	89 d0                	mov    %edx,%eax
  8026c8:	83 ec 0c             	sub    $0xc,%esp
  8026cb:	50                   	push   %eax
  8026cc:	e8 e2 fb ff ff       	call   8022b3 <malloc>
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8026d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026db:	75 07                	jne    8026e4 <sget+0x5c>
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	eb 4a                	jmp    80272e <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	ff 75 08             	pushl  0x8(%ebp)
  8026f0:	e8 2c 03 00 00       	call   802a21 <sys_getSharedObject>
  8026f5:	83 c4 10             	add    $0x10,%esp
  8026f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8026fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026fe:	a1 20 70 80 00       	mov    0x807020,%eax
  802703:	8b 40 78             	mov    0x78(%eax),%eax
  802706:	29 c2                	sub    %eax,%edx
  802708:	89 d0                	mov    %edx,%eax
  80270a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80270f:	c1 e8 0c             	shr    $0xc,%eax
  802712:	89 c2                	mov    %eax,%edx
  802714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802717:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80271e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802722:	75 07                	jne    80272b <sget+0xa3>
  802724:	b8 00 00 00 00       	mov    $0x0,%eax
  802729:	eb 03                	jmp    80272e <sget+0xa6>
	return ptr;
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802736:	8b 55 08             	mov    0x8(%ebp),%edx
  802739:	a1 20 70 80 00       	mov    0x807020,%eax
  80273e:	8b 40 78             	mov    0x78(%eax),%eax
  802741:	29 c2                	sub    %eax,%edx
  802743:	89 d0                	mov    %edx,%eax
  802745:	2d 00 10 00 00       	sub    $0x1000,%eax
  80274a:	c1 e8 0c             	shr    $0xc,%eax
  80274d:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
  802754:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802757:	83 ec 08             	sub    $0x8,%esp
  80275a:	ff 75 08             	pushl  0x8(%ebp)
  80275d:	ff 75 f4             	pushl  -0xc(%ebp)
  802760:	e8 db 02 00 00       	call   802a40 <sys_freeSharedObject>
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80276b:	90                   	nop
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802774:	83 ec 04             	sub    $0x4,%esp
  802777:	68 40 5e 80 00       	push   $0x805e40
  80277c:	68 de 00 00 00       	push   $0xde
  802781:	68 22 5e 80 00       	push   $0x805e22
  802786:	e8 bb ea ff ff       	call   801246 <_panic>

0080278b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 66 5e 80 00       	push   $0x805e66
  802799:	68 ea 00 00 00       	push   $0xea
  80279e:	68 22 5e 80 00       	push   $0x805e22
  8027a3:	e8 9e ea ff ff       	call   801246 <_panic>

008027a8 <shrink>:

}
void shrink(uint32 newSize)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	68 66 5e 80 00       	push   $0x805e66
  8027b6:	68 ef 00 00 00       	push   $0xef
  8027bb:	68 22 5e 80 00       	push   $0x805e22
  8027c0:	e8 81 ea ff ff       	call   801246 <_panic>

008027c5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 66 5e 80 00       	push   $0x805e66
  8027d3:	68 f4 00 00 00       	push   $0xf4
  8027d8:	68 22 5e 80 00       	push   $0x805e22
  8027dd:	e8 64 ea ff ff       	call   801246 <_panic>

008027e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	57                   	push   %edi
  8027e6:	56                   	push   %esi
  8027e7:	53                   	push   %ebx
  8027e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027fd:	cd 30                	int    $0x30
  8027ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802805:	83 c4 10             	add    $0x10,%esp
  802808:	5b                   	pop    %ebx
  802809:	5e                   	pop    %esi
  80280a:	5f                   	pop    %edi
  80280b:	5d                   	pop    %ebp
  80280c:	c3                   	ret    

0080280d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	83 ec 04             	sub    $0x4,%esp
  802813:	8b 45 10             	mov    0x10(%ebp),%eax
  802816:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802819:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	52                   	push   %edx
  802825:	ff 75 0c             	pushl  0xc(%ebp)
  802828:	50                   	push   %eax
  802829:	6a 00                	push   $0x0
  80282b:	e8 b2 ff ff ff       	call   8027e2 <syscall>
  802830:	83 c4 18             	add    $0x18,%esp
}
  802833:	90                   	nop
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_cgetc>:

int
sys_cgetc(void)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 02                	push   $0x2
  802845:	e8 98 ff ff ff       	call   8027e2 <syscall>
  80284a:	83 c4 18             	add    $0x18,%esp
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 03                	push   $0x3
  80285e:	e8 7f ff ff ff       	call   8027e2 <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
}
  802866:	90                   	nop
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 04                	push   $0x4
  802878:	e8 65 ff ff ff       	call   8027e2 <syscall>
  80287d:	83 c4 18             	add    $0x18,%esp
}
  802880:	90                   	nop
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802886:	8b 55 0c             	mov    0xc(%ebp),%edx
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	52                   	push   %edx
  802893:	50                   	push   %eax
  802894:	6a 08                	push   $0x8
  802896:	e8 47 ff ff ff       	call   8027e2 <syscall>
  80289b:	83 c4 18             	add    $0x18,%esp
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	56                   	push   %esi
  8028a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8028a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	56                   	push   %esi
  8028b5:	53                   	push   %ebx
  8028b6:	51                   	push   %ecx
  8028b7:	52                   	push   %edx
  8028b8:	50                   	push   %eax
  8028b9:	6a 09                	push   $0x9
  8028bb:	e8 22 ff ff ff       	call   8027e2 <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
}
  8028c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c6:	5b                   	pop    %ebx
  8028c7:	5e                   	pop    %esi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    

008028ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	52                   	push   %edx
  8028da:	50                   	push   %eax
  8028db:	6a 0a                	push   $0xa
  8028dd:	e8 00 ff ff ff       	call   8027e2 <syscall>
  8028e2:	83 c4 18             	add    $0x18,%esp
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	ff 75 0c             	pushl  0xc(%ebp)
  8028f3:	ff 75 08             	pushl  0x8(%ebp)
  8028f6:	6a 0b                	push   $0xb
  8028f8:	e8 e5 fe ff ff       	call   8027e2 <syscall>
  8028fd:	83 c4 18             	add    $0x18,%esp
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 0c                	push   $0xc
  802911:	e8 cc fe ff ff       	call   8027e2 <syscall>
  802916:	83 c4 18             	add    $0x18,%esp
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	6a 0d                	push   $0xd
  80292a:	e8 b3 fe ff ff       	call   8027e2 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 0e                	push   $0xe
  802943:	e8 9a fe ff ff       	call   8027e2 <syscall>
  802948:	83 c4 18             	add    $0x18,%esp
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 0f                	push   $0xf
  80295c:	e8 81 fe ff ff       	call   8027e2 <syscall>
  802961:	83 c4 18             	add    $0x18,%esp
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	ff 75 08             	pushl  0x8(%ebp)
  802974:	6a 10                	push   $0x10
  802976:	e8 67 fe ff ff       	call   8027e2 <syscall>
  80297b:	83 c4 18             	add    $0x18,%esp
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 11                	push   $0x11
  80298f:	e8 4e fe ff ff       	call   8027e2 <syscall>
  802994:	83 c4 18             	add    $0x18,%esp
}
  802997:	90                   	nop
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <sys_cputc>:

void
sys_cputc(const char c)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	50                   	push   %eax
  8029b3:	6a 01                	push   $0x1
  8029b5:	e8 28 fe ff ff       	call   8027e2 <syscall>
  8029ba:	83 c4 18             	add    $0x18,%esp
}
  8029bd:	90                   	nop
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 14                	push   $0x14
  8029cf:	e8 0e fe ff ff       	call   8027e2 <syscall>
  8029d4:	83 c4 18             	add    $0x18,%esp
}
  8029d7:	90                   	nop
  8029d8:	c9                   	leave  
  8029d9:	c3                   	ret    

008029da <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8029e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8029e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	6a 00                	push   $0x0
  8029f2:	51                   	push   %ecx
  8029f3:	52                   	push   %edx
  8029f4:	ff 75 0c             	pushl  0xc(%ebp)
  8029f7:	50                   	push   %eax
  8029f8:	6a 15                	push   $0x15
  8029fa:	e8 e3 fd ff ff       	call   8027e2 <syscall>
  8029ff:	83 c4 18             	add    $0x18,%esp
}
  802a02:	c9                   	leave  
  802a03:	c3                   	ret    

00802a04 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	52                   	push   %edx
  802a14:	50                   	push   %eax
  802a15:	6a 16                	push   $0x16
  802a17:	e8 c6 fd ff ff       	call   8027e2 <syscall>
  802a1c:	83 c4 18             	add    $0x18,%esp
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	51                   	push   %ecx
  802a32:	52                   	push   %edx
  802a33:	50                   	push   %eax
  802a34:	6a 17                	push   $0x17
  802a36:	e8 a7 fd ff ff       	call   8027e2 <syscall>
  802a3b:	83 c4 18             	add    $0x18,%esp
}
  802a3e:	c9                   	leave  
  802a3f:	c3                   	ret    

00802a40 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	52                   	push   %edx
  802a50:	50                   	push   %eax
  802a51:	6a 18                	push   $0x18
  802a53:	e8 8a fd ff ff       	call   8027e2 <syscall>
  802a58:	83 c4 18             	add    $0x18,%esp
}
  802a5b:	c9                   	leave  
  802a5c:	c3                   	ret    

00802a5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	6a 00                	push   $0x0
  802a65:	ff 75 14             	pushl  0x14(%ebp)
  802a68:	ff 75 10             	pushl  0x10(%ebp)
  802a6b:	ff 75 0c             	pushl  0xc(%ebp)
  802a6e:	50                   	push   %eax
  802a6f:	6a 19                	push   $0x19
  802a71:	e8 6c fd ff ff       	call   8027e2 <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <sys_run_env>:

void sys_run_env(int32 envId)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	50                   	push   %eax
  802a8a:	6a 1a                	push   $0x1a
  802a8c:	e8 51 fd ff ff       	call   8027e2 <syscall>
  802a91:	83 c4 18             	add    $0x18,%esp
}
  802a94:	90                   	nop
  802a95:	c9                   	leave  
  802a96:	c3                   	ret    

00802a97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802a97:	55                   	push   %ebp
  802a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	50                   	push   %eax
  802aa6:	6a 1b                	push   $0x1b
  802aa8:	e8 35 fd ff ff       	call   8027e2 <syscall>
  802aad:	83 c4 18             	add    $0x18,%esp
}
  802ab0:	c9                   	leave  
  802ab1:	c3                   	ret    

00802ab2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 05                	push   $0x5
  802ac1:	e8 1c fd ff ff       	call   8027e2 <syscall>
  802ac6:	83 c4 18             	add    $0x18,%esp
}
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 06                	push   $0x6
  802ada:	e8 03 fd ff ff       	call   8027e2 <syscall>
  802adf:	83 c4 18             	add    $0x18,%esp
}
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

00802ae4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 00                	push   $0x0
  802aed:	6a 00                	push   $0x0
  802aef:	6a 00                	push   $0x0
  802af1:	6a 07                	push   $0x7
  802af3:	e8 ea fc ff ff       	call   8027e2 <syscall>
  802af8:	83 c4 18             	add    $0x18,%esp
}
  802afb:	c9                   	leave  
  802afc:	c3                   	ret    

00802afd <sys_exit_env>:


void sys_exit_env(void)
{
  802afd:	55                   	push   %ebp
  802afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b00:	6a 00                	push   $0x0
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 1c                	push   $0x1c
  802b0c:	e8 d1 fc ff ff       	call   8027e2 <syscall>
  802b11:	83 c4 18             	add    $0x18,%esp
}
  802b14:	90                   	nop
  802b15:	c9                   	leave  
  802b16:	c3                   	ret    

00802b17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
  802b1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b20:	8d 50 04             	lea    0x4(%eax),%edx
  802b23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 00                	push   $0x0
  802b2c:	52                   	push   %edx
  802b2d:	50                   	push   %eax
  802b2e:	6a 1d                	push   $0x1d
  802b30:	e8 ad fc ff ff       	call   8027e2 <syscall>
  802b35:	83 c4 18             	add    $0x18,%esp
	return result;
  802b38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b41:	89 01                	mov    %eax,(%ecx)
  802b43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	c9                   	leave  
  802b4a:	c2 04 00             	ret    $0x4

00802b4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b4d:	55                   	push   %ebp
  802b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	ff 75 10             	pushl  0x10(%ebp)
  802b57:	ff 75 0c             	pushl  0xc(%ebp)
  802b5a:	ff 75 08             	pushl  0x8(%ebp)
  802b5d:	6a 13                	push   $0x13
  802b5f:	e8 7e fc ff ff       	call   8027e2 <syscall>
  802b64:	83 c4 18             	add    $0x18,%esp
	return ;
  802b67:	90                   	nop
}
  802b68:	c9                   	leave  
  802b69:	c3                   	ret    

00802b6a <sys_rcr2>:
uint32 sys_rcr2()
{
  802b6a:	55                   	push   %ebp
  802b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	6a 1e                	push   $0x1e
  802b79:	e8 64 fc ff ff       	call   8027e2 <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
}
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    

00802b83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	50                   	push   %eax
  802b9c:	6a 1f                	push   $0x1f
  802b9e:	e8 3f fc ff ff       	call   8027e2 <syscall>
  802ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ba6:	90                   	nop
}
  802ba7:	c9                   	leave  
  802ba8:	c3                   	ret    

00802ba9 <rsttst>:
void rsttst()
{
  802ba9:	55                   	push   %ebp
  802baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 21                	push   $0x21
  802bb8:	e8 25 fc ff ff       	call   8027e2 <syscall>
  802bbd:	83 c4 18             	add    $0x18,%esp
	return ;
  802bc0:	90                   	nop
}
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  802bcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bcf:	8b 55 18             	mov    0x18(%ebp),%edx
  802bd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bd6:	52                   	push   %edx
  802bd7:	50                   	push   %eax
  802bd8:	ff 75 10             	pushl  0x10(%ebp)
  802bdb:	ff 75 0c             	pushl  0xc(%ebp)
  802bde:	ff 75 08             	pushl  0x8(%ebp)
  802be1:	6a 20                	push   $0x20
  802be3:	e8 fa fb ff ff       	call   8027e2 <syscall>
  802be8:	83 c4 18             	add    $0x18,%esp
	return ;
  802beb:	90                   	nop
}
  802bec:	c9                   	leave  
  802bed:	c3                   	ret    

00802bee <chktst>:
void chktst(uint32 n)
{
  802bee:	55                   	push   %ebp
  802bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	ff 75 08             	pushl  0x8(%ebp)
  802bfc:	6a 22                	push   $0x22
  802bfe:	e8 df fb ff ff       	call   8027e2 <syscall>
  802c03:	83 c4 18             	add    $0x18,%esp
	return ;
  802c06:	90                   	nop
}
  802c07:	c9                   	leave  
  802c08:	c3                   	ret    

00802c09 <inctst>:

void inctst()
{
  802c09:	55                   	push   %ebp
  802c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 23                	push   $0x23
  802c18:	e8 c5 fb ff ff       	call   8027e2 <syscall>
  802c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802c20:	90                   	nop
}
  802c21:	c9                   	leave  
  802c22:	c3                   	ret    

00802c23 <gettst>:
uint32 gettst()
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 24                	push   $0x24
  802c32:	e8 ab fb ff ff       	call   8027e2 <syscall>
  802c37:	83 c4 18             	add    $0x18,%esp
}
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
  802c3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	6a 00                	push   $0x0
  802c4c:	6a 25                	push   $0x25
  802c4e:	e8 8f fb ff ff       	call   8027e2 <syscall>
  802c53:	83 c4 18             	add    $0x18,%esp
  802c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c5d:	75 07                	jne    802c66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  802c64:	eb 05                	jmp    802c6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6b:	c9                   	leave  
  802c6c:	c3                   	ret    

00802c6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802c6d:	55                   	push   %ebp
  802c6e:	89 e5                	mov    %esp,%ebp
  802c70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 25                	push   $0x25
  802c7f:	e8 5e fb ff ff       	call   8027e2 <syscall>
  802c84:	83 c4 18             	add    $0x18,%esp
  802c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c8e:	75 07                	jne    802c97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c90:	b8 01 00 00 00       	mov    $0x1,%eax
  802c95:	eb 05                	jmp    802c9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 25                	push   $0x25
  802cb0:	e8 2d fb ff ff       	call   8027e2 <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
  802cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802cbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802cbf:	75 07                	jne    802cc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc6:	eb 05                	jmp    802ccd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccd:	c9                   	leave  
  802cce:	c3                   	ret    

00802ccf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ccf:	55                   	push   %ebp
  802cd0:	89 e5                	mov    %esp,%ebp
  802cd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 25                	push   $0x25
  802ce1:	e8 fc fa ff ff       	call   8027e2 <syscall>
  802ce6:	83 c4 18             	add    $0x18,%esp
  802ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802cec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802cf0:	75 07                	jne    802cf9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  802cf7:	eb 05                	jmp    802cfe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cfe:	c9                   	leave  
  802cff:	c3                   	ret    

00802d00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d03:	6a 00                	push   $0x0
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	ff 75 08             	pushl  0x8(%ebp)
  802d0e:	6a 26                	push   $0x26
  802d10:	e8 cd fa ff ff       	call   8027e2 <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
	return ;
  802d18:	90                   	nop
}
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
  802d1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	6a 00                	push   $0x0
  802d2d:	53                   	push   %ebx
  802d2e:	51                   	push   %ecx
  802d2f:	52                   	push   %edx
  802d30:	50                   	push   %eax
  802d31:	6a 27                	push   $0x27
  802d33:	e8 aa fa ff ff       	call   8027e2 <syscall>
  802d38:	83 c4 18             	add    $0x18,%esp
}
  802d3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	52                   	push   %edx
  802d50:	50                   	push   %eax
  802d51:	6a 28                	push   $0x28
  802d53:	e8 8a fa ff ff       	call   8027e2 <syscall>
  802d58:	83 c4 18             	add    $0x18,%esp
}
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d60:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	6a 00                	push   $0x0
  802d6b:	51                   	push   %ecx
  802d6c:	ff 75 10             	pushl  0x10(%ebp)
  802d6f:	52                   	push   %edx
  802d70:	50                   	push   %eax
  802d71:	6a 29                	push   $0x29
  802d73:	e8 6a fa ff ff       	call   8027e2 <syscall>
  802d78:	83 c4 18             	add    $0x18,%esp
}
  802d7b:	c9                   	leave  
  802d7c:	c3                   	ret    

00802d7d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d7d:	55                   	push   %ebp
  802d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d80:	6a 00                	push   $0x0
  802d82:	6a 00                	push   $0x0
  802d84:	ff 75 10             	pushl  0x10(%ebp)
  802d87:	ff 75 0c             	pushl  0xc(%ebp)
  802d8a:	ff 75 08             	pushl  0x8(%ebp)
  802d8d:	6a 12                	push   $0x12
  802d8f:	e8 4e fa ff ff       	call   8027e2 <syscall>
  802d94:	83 c4 18             	add    $0x18,%esp
	return ;
  802d97:	90                   	nop
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    

00802d9a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 00                	push   $0x0
  802da9:	52                   	push   %edx
  802daa:	50                   	push   %eax
  802dab:	6a 2a                	push   $0x2a
  802dad:	e8 30 fa ff ff       	call   8027e2 <syscall>
  802db2:	83 c4 18             	add    $0x18,%esp
	return;
  802db5:	90                   	nop
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	50                   	push   %eax
  802dc7:	6a 2b                	push   $0x2b
  802dc9:	e8 14 fa ff ff       	call   8027e2 <syscall>
  802dce:	83 c4 18             	add    $0x18,%esp
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	6a 00                	push   $0x0
  802ddc:	ff 75 0c             	pushl  0xc(%ebp)
  802ddf:	ff 75 08             	pushl  0x8(%ebp)
  802de2:	6a 2c                	push   $0x2c
  802de4:	e8 f9 f9 ff ff       	call   8027e2 <syscall>
  802de9:	83 c4 18             	add    $0x18,%esp
	return;
  802dec:	90                   	nop
}
  802ded:	c9                   	leave  
  802dee:	c3                   	ret    

00802def <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802def:	55                   	push   %ebp
  802df0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	ff 75 0c             	pushl  0xc(%ebp)
  802dfb:	ff 75 08             	pushl  0x8(%ebp)
  802dfe:	6a 2d                	push   $0x2d
  802e00:	e8 dd f9 ff ff       	call   8027e2 <syscall>
  802e05:	83 c4 18             	add    $0x18,%esp
	return;
  802e08:	90                   	nop
}
  802e09:	c9                   	leave  
  802e0a:	c3                   	ret    

00802e0b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802e0b:	55                   	push   %ebp
  802e0c:	89 e5                	mov    %esp,%ebp
  802e0e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	83 e8 04             	sub    $0x4,%eax
  802e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802e22:	c9                   	leave  
  802e23:	c3                   	ret    

00802e24 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802e24:	55                   	push   %ebp
  802e25:	89 e5                	mov    %esp,%ebp
  802e27:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	83 e8 04             	sub    $0x4,%eax
  802e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	83 e0 01             	and    $0x1,%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	0f 94 c0             	sete   %al
}
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    

00802e42 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802e42:	55                   	push   %ebp
  802e43:	89 e5                	mov    %esp,%ebp
  802e45:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802e48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e52:	83 f8 02             	cmp    $0x2,%eax
  802e55:	74 2b                	je     802e82 <alloc_block+0x40>
  802e57:	83 f8 02             	cmp    $0x2,%eax
  802e5a:	7f 07                	jg     802e63 <alloc_block+0x21>
  802e5c:	83 f8 01             	cmp    $0x1,%eax
  802e5f:	74 0e                	je     802e6f <alloc_block+0x2d>
  802e61:	eb 58                	jmp    802ebb <alloc_block+0x79>
  802e63:	83 f8 03             	cmp    $0x3,%eax
  802e66:	74 2d                	je     802e95 <alloc_block+0x53>
  802e68:	83 f8 04             	cmp    $0x4,%eax
  802e6b:	74 3b                	je     802ea8 <alloc_block+0x66>
  802e6d:	eb 4c                	jmp    802ebb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802e6f:	83 ec 0c             	sub    $0xc,%esp
  802e72:	ff 75 08             	pushl  0x8(%ebp)
  802e75:	e8 11 03 00 00       	call   80318b <alloc_block_FF>
  802e7a:	83 c4 10             	add    $0x10,%esp
  802e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802e80:	eb 4a                	jmp    802ecc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802e82:	83 ec 0c             	sub    $0xc,%esp
  802e85:	ff 75 08             	pushl  0x8(%ebp)
  802e88:	e8 fa 19 00 00       	call   804887 <alloc_block_NF>
  802e8d:	83 c4 10             	add    $0x10,%esp
  802e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802e93:	eb 37                	jmp    802ecc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	ff 75 08             	pushl  0x8(%ebp)
  802e9b:	e8 a7 07 00 00       	call   803647 <alloc_block_BF>
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ea6:	eb 24                	jmp    802ecc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802ea8:	83 ec 0c             	sub    $0xc,%esp
  802eab:	ff 75 08             	pushl  0x8(%ebp)
  802eae:	e8 b7 19 00 00       	call   80486a <alloc_block_WF>
  802eb3:	83 c4 10             	add    $0x10,%esp
  802eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802eb9:	eb 11                	jmp    802ecc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802ebb:	83 ec 0c             	sub    $0xc,%esp
  802ebe:	68 78 5e 80 00       	push   $0x805e78
  802ec3:	e8 3b e6 ff ff       	call   801503 <cprintf>
  802ec8:	83 c4 10             	add    $0x10,%esp
		break;
  802ecb:	90                   	nop
	}
	return va;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    

00802ed1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802ed1:	55                   	push   %ebp
  802ed2:	89 e5                	mov    %esp,%ebp
  802ed4:	53                   	push   %ebx
  802ed5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ed8:	83 ec 0c             	sub    $0xc,%esp
  802edb:	68 98 5e 80 00       	push   $0x805e98
  802ee0:	e8 1e e6 ff ff       	call   801503 <cprintf>
  802ee5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	68 c3 5e 80 00       	push   $0x805ec3
  802ef0:	e8 0e e6 ff ff       	call   801503 <cprintf>
  802ef5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efe:	eb 37                	jmp    802f37 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802f00:	83 ec 0c             	sub    $0xc,%esp
  802f03:	ff 75 f4             	pushl  -0xc(%ebp)
  802f06:	e8 19 ff ff ff       	call   802e24 <is_free_block>
  802f0b:	83 c4 10             	add    $0x10,%esp
  802f0e:	0f be d8             	movsbl %al,%ebx
  802f11:	83 ec 0c             	sub    $0xc,%esp
  802f14:	ff 75 f4             	pushl  -0xc(%ebp)
  802f17:	e8 ef fe ff ff       	call   802e0b <get_block_size>
  802f1c:	83 c4 10             	add    $0x10,%esp
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	53                   	push   %ebx
  802f23:	50                   	push   %eax
  802f24:	68 db 5e 80 00       	push   $0x805edb
  802f29:	e8 d5 e5 ff ff       	call   801503 <cprintf>
  802f2e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802f31:	8b 45 10             	mov    0x10(%ebp),%eax
  802f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	74 07                	je     802f44 <print_blocks_list+0x73>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	eb 05                	jmp    802f49 <print_blocks_list+0x78>
  802f44:	b8 00 00 00 00       	mov    $0x0,%eax
  802f49:	89 45 10             	mov    %eax,0x10(%ebp)
  802f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	75 ad                	jne    802f00 <print_blocks_list+0x2f>
  802f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f57:	75 a7                	jne    802f00 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802f59:	83 ec 0c             	sub    $0xc,%esp
  802f5c:	68 98 5e 80 00       	push   $0x805e98
  802f61:	e8 9d e5 ff ff       	call   801503 <cprintf>
  802f66:	83 c4 10             	add    $0x10,%esp

}
  802f69:	90                   	nop
  802f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
  802f72:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f78:	83 e0 01             	and    $0x1,%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 03                	je     802f82 <initialize_dynamic_allocator+0x13>
  802f7f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802f82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f86:	0f 84 c7 01 00 00    	je     803153 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802f8c:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  802f93:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802f96:	8b 55 08             	mov    0x8(%ebp),%edx
  802f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9c:	01 d0                	add    %edx,%eax
  802f9e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802fa3:	0f 87 ad 01 00 00    	ja     803156 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	0f 89 a5 01 00 00    	jns    803159 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	83 e8 04             	sub    $0x4,%eax
  802fbf:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  802fc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802fcb:	a1 2c 70 80 00       	mov    0x80702c,%eax
  802fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd3:	e9 87 00 00 00       	jmp    80305f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdc:	75 14                	jne    802ff2 <initialize_dynamic_allocator+0x83>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 f3 5e 80 00       	push   $0x805ef3
  802fe6:	6a 79                	push   $0x79
  802fe8:	68 11 5f 80 00       	push   $0x805f11
  802fed:	e8 54 e2 ff ff       	call   801246 <_panic>
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 10                	je     80300b <initialize_dynamic_allocator+0x9c>
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803003:	8b 52 04             	mov    0x4(%edx),%edx
  803006:	89 50 04             	mov    %edx,0x4(%eax)
  803009:	eb 0b                	jmp    803016 <initialize_dynamic_allocator+0xa7>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 40 04             	mov    0x4(%eax),%eax
  803011:	a3 30 70 80 00       	mov    %eax,0x807030
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	8b 40 04             	mov    0x4(%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 0f                	je     80302f <initialize_dynamic_allocator+0xc0>
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 04             	mov    0x4(%eax),%eax
  803026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803029:	8b 12                	mov    (%edx),%edx
  80302b:	89 10                	mov    %edx,(%eax)
  80302d:	eb 0a                	jmp    803039 <initialize_dynamic_allocator+0xca>
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 38 70 80 00       	mov    0x807038,%eax
  803051:	48                   	dec    %eax
  803052:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803057:	a1 34 70 80 00       	mov    0x807034,%eax
  80305c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803063:	74 07                	je     80306c <initialize_dynamic_allocator+0xfd>
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	eb 05                	jmp    803071 <initialize_dynamic_allocator+0x102>
  80306c:	b8 00 00 00 00       	mov    $0x0,%eax
  803071:	a3 34 70 80 00       	mov    %eax,0x807034
  803076:	a1 34 70 80 00       	mov    0x807034,%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	0f 85 55 ff ff ff    	jne    802fd8 <initialize_dynamic_allocator+0x69>
  803083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803087:	0f 85 4b ff ff ff    	jne    802fd8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80309c:	a1 44 70 80 00       	mov    0x807044,%eax
  8030a1:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  8030a6:	a1 40 70 80 00       	mov    0x807040,%eax
  8030ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	83 c0 08             	add    $0x8,%eax
  8030b7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	83 c0 04             	add    $0x4,%eax
  8030c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c3:	83 ea 08             	sub    $0x8,%edx
  8030c6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8030c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	01 d0                	add    %edx,%eax
  8030d0:	83 e8 08             	sub    $0x8,%eax
  8030d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d6:	83 ea 08             	sub    $0x8,%edx
  8030d9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8030e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8030ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030f2:	75 17                	jne    80310b <initialize_dynamic_allocator+0x19c>
  8030f4:	83 ec 04             	sub    $0x4,%esp
  8030f7:	68 2c 5f 80 00       	push   $0x805f2c
  8030fc:	68 90 00 00 00       	push   $0x90
  803101:	68 11 5f 80 00       	push   $0x805f11
  803106:	e8 3b e1 ff ff       	call   801246 <_panic>
  80310b:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803111:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803114:	89 10                	mov    %edx,(%eax)
  803116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 0d                	je     80312c <initialize_dynamic_allocator+0x1bd>
  80311f:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803124:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803127:	89 50 04             	mov    %edx,0x4(%eax)
  80312a:	eb 08                	jmp    803134 <initialize_dynamic_allocator+0x1c5>
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	a3 30 70 80 00       	mov    %eax,0x807030
  803134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803137:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803146:	a1 38 70 80 00       	mov    0x807038,%eax
  80314b:	40                   	inc    %eax
  80314c:	a3 38 70 80 00       	mov    %eax,0x807038
  803151:	eb 07                	jmp    80315a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803153:	90                   	nop
  803154:	eb 04                	jmp    80315a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803156:	90                   	nop
  803157:	eb 01                	jmp    80315a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803159:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80315f:	8b 45 10             	mov    0x10(%ebp),%eax
  803162:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8d 50 fc             	lea    -0x4(%eax),%edx
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	83 e8 04             	sub    $0x4,%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	83 e0 fe             	and    $0xfffffffe,%eax
  80317b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	01 c2                	add    %eax,%edx
  803183:	8b 45 0c             	mov    0xc(%ebp),%eax
  803186:	89 02                	mov    %eax,(%edx)
}
  803188:	90                   	nop
  803189:	5d                   	pop    %ebp
  80318a:	c3                   	ret    

0080318b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	83 e0 01             	and    $0x1,%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 03                	je     80319e <alloc_block_FF+0x13>
  80319b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80319e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8031a2:	77 07                	ja     8031ab <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8031a4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8031ab:	a1 24 70 80 00       	mov    0x807024,%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	75 73                	jne    803227 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	83 c0 10             	add    $0x10,%eax
  8031ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8031bd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8031c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ca:	01 d0                	add    %edx,%eax
  8031cc:	48                   	dec    %eax
  8031cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d8:	f7 75 ec             	divl   -0x14(%ebp)
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	29 d0                	sub    %edx,%eax
  8031e0:	c1 e8 0c             	shr    $0xc,%eax
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	50                   	push   %eax
  8031e7:	e8 b1 f0 ff ff       	call   80229d <sbrk>
  8031ec:	83 c4 10             	add    $0x10,%esp
  8031ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8031f2:	83 ec 0c             	sub    $0xc,%esp
  8031f5:	6a 00                	push   $0x0
  8031f7:	e8 a1 f0 ff ff       	call   80229d <sbrk>
  8031fc:	83 c4 10             	add    $0x10,%esp
  8031ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803202:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803205:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803208:	83 ec 08             	sub    $0x8,%esp
  80320b:	50                   	push   %eax
  80320c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80320f:	e8 5b fd ff ff       	call   802f6f <initialize_dynamic_allocator>
  803214:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803217:	83 ec 0c             	sub    $0xc,%esp
  80321a:	68 4f 5f 80 00       	push   $0x805f4f
  80321f:	e8 df e2 ff ff       	call   801503 <cprintf>
  803224:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322b:	75 0a                	jne    803237 <alloc_block_FF+0xac>
	        return NULL;
  80322d:	b8 00 00 00 00       	mov    $0x0,%eax
  803232:	e9 0e 04 00 00       	jmp    803645 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803237:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80323e:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803246:	e9 f3 02 00 00       	jmp    80353e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803251:	83 ec 0c             	sub    $0xc,%esp
  803254:	ff 75 bc             	pushl  -0x44(%ebp)
  803257:	e8 af fb ff ff       	call   802e0b <get_block_size>
  80325c:	83 c4 10             	add    $0x10,%esp
  80325f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	83 c0 08             	add    $0x8,%eax
  803268:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80326b:	0f 87 c5 02 00 00    	ja     803536 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	83 c0 18             	add    $0x18,%eax
  803277:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80327a:	0f 87 19 02 00 00    	ja     803499 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803280:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803283:	2b 45 08             	sub    0x8(%ebp),%eax
  803286:	83 e8 08             	sub    $0x8,%eax
  803289:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8d 50 08             	lea    0x8(%eax),%edx
  803292:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803295:	01 d0                	add    %edx,%eax
  803297:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	83 c0 08             	add    $0x8,%eax
  8032a0:	83 ec 04             	sub    $0x4,%esp
  8032a3:	6a 01                	push   $0x1
  8032a5:	50                   	push   %eax
  8032a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8032a9:	e8 ae fe ff ff       	call   80315c <set_block_data>
  8032ae:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	75 68                	jne    803323 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032bb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032bf:	75 17                	jne    8032d8 <alloc_block_FF+0x14d>
  8032c1:	83 ec 04             	sub    $0x4,%esp
  8032c4:	68 2c 5f 80 00       	push   $0x805f2c
  8032c9:	68 d7 00 00 00       	push   $0xd7
  8032ce:	68 11 5f 80 00       	push   $0x805f11
  8032d3:	e8 6e df ff ff       	call   801246 <_panic>
  8032d8:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8032de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e1:	89 10                	mov    %edx,(%eax)
  8032e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0d                	je     8032f9 <alloc_block_FF+0x16e>
  8032ec:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8032f1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032f4:	89 50 04             	mov    %edx,0x4(%eax)
  8032f7:	eb 08                	jmp    803301 <alloc_block_FF+0x176>
  8032f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032fc:	a3 30 70 80 00       	mov    %eax,0x807030
  803301:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803304:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803309:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80330c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803313:	a1 38 70 80 00       	mov    0x807038,%eax
  803318:	40                   	inc    %eax
  803319:	a3 38 70 80 00       	mov    %eax,0x807038
  80331e:	e9 dc 00 00 00       	jmp    8033ff <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	75 65                	jne    803391 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80332c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803330:	75 17                	jne    803349 <alloc_block_FF+0x1be>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 60 5f 80 00       	push   $0x805f60
  80333a:	68 db 00 00 00       	push   $0xdb
  80333f:	68 11 5f 80 00       	push   $0x805f11
  803344:	e8 fd de ff ff       	call   801246 <_panic>
  803349:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80334f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 0c                	je     80336b <alloc_block_FF+0x1e0>
  80335f:	a1 30 70 80 00       	mov    0x807030,%eax
  803364:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803367:	89 10                	mov    %edx,(%eax)
  803369:	eb 08                	jmp    803373 <alloc_block_FF+0x1e8>
  80336b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80336e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803373:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803376:	a3 30 70 80 00       	mov    %eax,0x807030
  80337b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80337e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803384:	a1 38 70 80 00       	mov    0x807038,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 38 70 80 00       	mov    %eax,0x807038
  80338f:	eb 6e                	jmp    8033ff <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803395:	74 06                	je     80339d <alloc_block_FF+0x212>
  803397:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80339b:	75 17                	jne    8033b4 <alloc_block_FF+0x229>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 84 5f 80 00       	push   $0x805f84
  8033a5:	68 df 00 00 00       	push   $0xdf
  8033aa:	68 11 5f 80 00       	push   $0x805f11
  8033af:	e8 92 de ff ff       	call   801246 <_panic>
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 10                	mov    (%eax),%edx
  8033b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033bc:	89 10                	mov    %edx,(%eax)
  8033be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 0b                	je     8033d2 <alloc_block_FF+0x247>
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8033cf:	89 50 04             	mov    %edx,0x4(%eax)
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	75 08                	jne    8033f4 <alloc_block_FF+0x269>
  8033ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033ef:	a3 30 70 80 00       	mov    %eax,0x807030
  8033f4:	a1 38 70 80 00       	mov    0x807038,%eax
  8033f9:	40                   	inc    %eax
  8033fa:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	75 17                	jne    80341c <alloc_block_FF+0x291>
  803405:	83 ec 04             	sub    $0x4,%esp
  803408:	68 f3 5e 80 00       	push   $0x805ef3
  80340d:	68 e1 00 00 00       	push   $0xe1
  803412:	68 11 5f 80 00       	push   $0x805f11
  803417:	e8 2a de ff ff       	call   801246 <_panic>
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 10                	je     803435 <alloc_block_FF+0x2aa>
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342d:	8b 52 04             	mov    0x4(%edx),%edx
  803430:	89 50 04             	mov    %edx,0x4(%eax)
  803433:	eb 0b                	jmp    803440 <alloc_block_FF+0x2b5>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	a3 30 70 80 00       	mov    %eax,0x807030
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 40 04             	mov    0x4(%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0f                	je     803459 <alloc_block_FF+0x2ce>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803453:	8b 12                	mov    (%edx),%edx
  803455:	89 10                	mov    %edx,(%eax)
  803457:	eb 0a                	jmp    803463 <alloc_block_FF+0x2d8>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803476:	a1 38 70 80 00       	mov    0x807038,%eax
  80347b:	48                   	dec    %eax
  80347c:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	6a 00                	push   $0x0
  803486:	ff 75 b4             	pushl  -0x4c(%ebp)
  803489:	ff 75 b0             	pushl  -0x50(%ebp)
  80348c:	e8 cb fc ff ff       	call   80315c <set_block_data>
  803491:	83 c4 10             	add    $0x10,%esp
  803494:	e9 95 00 00 00       	jmp    80352e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	6a 01                	push   $0x1
  80349e:	ff 75 b8             	pushl  -0x48(%ebp)
  8034a1:	ff 75 bc             	pushl  -0x44(%ebp)
  8034a4:	e8 b3 fc ff ff       	call   80315c <set_block_data>
  8034a9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8034ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b0:	75 17                	jne    8034c9 <alloc_block_FF+0x33e>
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 f3 5e 80 00       	push   $0x805ef3
  8034ba:	68 e8 00 00 00       	push   $0xe8
  8034bf:	68 11 5f 80 00       	push   $0x805f11
  8034c4:	e8 7d dd ff ff       	call   801246 <_panic>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	74 10                	je     8034e2 <alloc_block_FF+0x357>
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034da:	8b 52 04             	mov    0x4(%edx),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	eb 0b                	jmp    8034ed <alloc_block_FF+0x362>
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 40 04             	mov    0x4(%eax),%eax
  8034e8:	a3 30 70 80 00       	mov    %eax,0x807030
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 0f                	je     803506 <alloc_block_FF+0x37b>
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	8b 40 04             	mov    0x4(%eax),%eax
  8034fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803500:	8b 12                	mov    (%edx),%edx
  803502:	89 10                	mov    %edx,(%eax)
  803504:	eb 0a                	jmp    803510 <alloc_block_FF+0x385>
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803523:	a1 38 70 80 00       	mov    0x807038,%eax
  803528:	48                   	dec    %eax
  803529:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  80352e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803531:	e9 0f 01 00 00       	jmp    803645 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803536:	a1 34 70 80 00       	mov    0x807034,%eax
  80353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803542:	74 07                	je     80354b <alloc_block_FF+0x3c0>
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	eb 05                	jmp    803550 <alloc_block_FF+0x3c5>
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
  803550:	a3 34 70 80 00       	mov    %eax,0x807034
  803555:	a1 34 70 80 00       	mov    0x807034,%eax
  80355a:	85 c0                	test   %eax,%eax
  80355c:	0f 85 e9 fc ff ff    	jne    80324b <alloc_block_FF+0xc0>
  803562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803566:	0f 85 df fc ff ff    	jne    80324b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	83 c0 08             	add    $0x8,%eax
  803572:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803575:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80357c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80357f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803582:	01 d0                	add    %edx,%eax
  803584:	48                   	dec    %eax
  803585:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	ba 00 00 00 00       	mov    $0x0,%edx
  803590:	f7 75 d8             	divl   -0x28(%ebp)
  803593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803596:	29 d0                	sub    %edx,%eax
  803598:	c1 e8 0c             	shr    $0xc,%eax
  80359b:	83 ec 0c             	sub    $0xc,%esp
  80359e:	50                   	push   %eax
  80359f:	e8 f9 ec ff ff       	call   80229d <sbrk>
  8035a4:	83 c4 10             	add    $0x10,%esp
  8035a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8035aa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8035ae:	75 0a                	jne    8035ba <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8035b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b5:	e9 8b 00 00 00       	jmp    803645 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035ba:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8035c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c7:	01 d0                	add    %edx,%eax
  8035c9:	48                   	dec    %eax
  8035ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8035cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d5:	f7 75 cc             	divl   -0x34(%ebp)
  8035d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035db:	29 d0                	sub    %edx,%eax
  8035dd:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035e3:	01 d0                	add    %edx,%eax
  8035e5:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  8035ea:	a1 40 70 80 00       	mov    0x807040,%eax
  8035ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035f5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8035fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803602:	01 d0                	add    %edx,%eax
  803604:	48                   	dec    %eax
  803605:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803608:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80360b:	ba 00 00 00 00       	mov    $0x0,%edx
  803610:	f7 75 c4             	divl   -0x3c(%ebp)
  803613:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803616:	29 d0                	sub    %edx,%eax
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	6a 01                	push   $0x1
  80361d:	50                   	push   %eax
  80361e:	ff 75 d0             	pushl  -0x30(%ebp)
  803621:	e8 36 fb ff ff       	call   80315c <set_block_data>
  803626:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803629:	83 ec 0c             	sub    $0xc,%esp
  80362c:	ff 75 d0             	pushl  -0x30(%ebp)
  80362f:	e8 1b 0a 00 00       	call   80404f <free_block>
  803634:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803637:	83 ec 0c             	sub    $0xc,%esp
  80363a:	ff 75 08             	pushl  0x8(%ebp)
  80363d:	e8 49 fb ff ff       	call   80318b <alloc_block_FF>
  803642:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803645:	c9                   	leave  
  803646:	c3                   	ret    

00803647 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803647:	55                   	push   %ebp
  803648:	89 e5                	mov    %esp,%ebp
  80364a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	83 e0 01             	and    $0x1,%eax
  803653:	85 c0                	test   %eax,%eax
  803655:	74 03                	je     80365a <alloc_block_BF+0x13>
  803657:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80365a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80365e:	77 07                	ja     803667 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803660:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803667:	a1 24 70 80 00       	mov    0x807024,%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	75 73                	jne    8036e3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	83 c0 10             	add    $0x10,%eax
  803676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803679:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803686:	01 d0                	add    %edx,%eax
  803688:	48                   	dec    %eax
  803689:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80368c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368f:	ba 00 00 00 00       	mov    $0x0,%edx
  803694:	f7 75 e0             	divl   -0x20(%ebp)
  803697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369a:	29 d0                	sub    %edx,%eax
  80369c:	c1 e8 0c             	shr    $0xc,%eax
  80369f:	83 ec 0c             	sub    $0xc,%esp
  8036a2:	50                   	push   %eax
  8036a3:	e8 f5 eb ff ff       	call   80229d <sbrk>
  8036a8:	83 c4 10             	add    $0x10,%esp
  8036ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8036ae:	83 ec 0c             	sub    $0xc,%esp
  8036b1:	6a 00                	push   $0x0
  8036b3:	e8 e5 eb ff ff       	call   80229d <sbrk>
  8036b8:	83 c4 10             	add    $0x10,%esp
  8036bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8036be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8036c4:	83 ec 08             	sub    $0x8,%esp
  8036c7:	50                   	push   %eax
  8036c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8036cb:	e8 9f f8 ff ff       	call   802f6f <initialize_dynamic_allocator>
  8036d0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8036d3:	83 ec 0c             	sub    $0xc,%esp
  8036d6:	68 4f 5f 80 00       	push   $0x805f4f
  8036db:	e8 23 de ff ff       	call   801503 <cprintf>
  8036e0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8036e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8036ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8036f1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8036f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8036ff:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803704:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803707:	e9 1d 01 00 00       	jmp    803829 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803712:	83 ec 0c             	sub    $0xc,%esp
  803715:	ff 75 a8             	pushl  -0x58(%ebp)
  803718:	e8 ee f6 ff ff       	call   802e0b <get_block_size>
  80371d:	83 c4 10             	add    $0x10,%esp
  803720:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	83 c0 08             	add    $0x8,%eax
  803729:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80372c:	0f 87 ef 00 00 00    	ja     803821 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	83 c0 18             	add    $0x18,%eax
  803738:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80373b:	77 1d                	ja     80375a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80373d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803740:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803743:	0f 86 d8 00 00 00    	jbe    803821 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803749:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80374c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80374f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803752:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803755:	e9 c7 00 00 00       	jmp    803821 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	83 c0 08             	add    $0x8,%eax
  803760:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803763:	0f 85 9d 00 00 00    	jne    803806 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	6a 01                	push   $0x1
  80376e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803771:	ff 75 a8             	pushl  -0x58(%ebp)
  803774:	e8 e3 f9 ff ff       	call   80315c <set_block_data>
  803779:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80377c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803780:	75 17                	jne    803799 <alloc_block_BF+0x152>
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	68 f3 5e 80 00       	push   $0x805ef3
  80378a:	68 2c 01 00 00       	push   $0x12c
  80378f:	68 11 5f 80 00       	push   $0x805f11
  803794:	e8 ad da ff ff       	call   801246 <_panic>
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 10                	je     8037b2 <alloc_block_BF+0x16b>
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037aa:	8b 52 04             	mov    0x4(%edx),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	eb 0b                	jmp    8037bd <alloc_block_BF+0x176>
  8037b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	a3 30 70 80 00       	mov    %eax,0x807030
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	8b 40 04             	mov    0x4(%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0f                	je     8037d6 <alloc_block_BF+0x18f>
  8037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ca:	8b 40 04             	mov    0x4(%eax),%eax
  8037cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037d0:	8b 12                	mov    (%edx),%edx
  8037d2:	89 10                	mov    %edx,(%eax)
  8037d4:	eb 0a                	jmp    8037e0 <alloc_block_BF+0x199>
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8037e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	a1 38 70 80 00       	mov    0x807038,%eax
  8037f8:	48                   	dec    %eax
  8037f9:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  8037fe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803801:	e9 24 04 00 00       	jmp    803c2a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803809:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80380c:	76 13                	jbe    803821 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80380e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803815:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803818:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80381b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80381e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803821:	a1 34 70 80 00       	mov    0x807034,%eax
  803826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382d:	74 07                	je     803836 <alloc_block_BF+0x1ef>
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	eb 05                	jmp    80383b <alloc_block_BF+0x1f4>
  803836:	b8 00 00 00 00       	mov    $0x0,%eax
  80383b:	a3 34 70 80 00       	mov    %eax,0x807034
  803840:	a1 34 70 80 00       	mov    0x807034,%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	0f 85 bf fe ff ff    	jne    80370c <alloc_block_BF+0xc5>
  80384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803851:	0f 85 b5 fe ff ff    	jne    80370c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80385b:	0f 84 26 02 00 00    	je     803a87 <alloc_block_BF+0x440>
  803861:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803865:	0f 85 1c 02 00 00    	jne    803a87 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80386b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386e:	2b 45 08             	sub    0x8(%ebp),%eax
  803871:	83 e8 08             	sub    $0x8,%eax
  803874:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	8d 50 08             	lea    0x8(%eax),%edx
  80387d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803880:	01 d0                	add    %edx,%eax
  803882:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	83 c0 08             	add    $0x8,%eax
  80388b:	83 ec 04             	sub    $0x4,%esp
  80388e:	6a 01                	push   $0x1
  803890:	50                   	push   %eax
  803891:	ff 75 f0             	pushl  -0x10(%ebp)
  803894:	e8 c3 f8 ff ff       	call   80315c <set_block_data>
  803899:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	75 68                	jne    80390e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8038a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038aa:	75 17                	jne    8038c3 <alloc_block_BF+0x27c>
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	68 2c 5f 80 00       	push   $0x805f2c
  8038b4:	68 45 01 00 00       	push   $0x145
  8038b9:	68 11 5f 80 00       	push   $0x805f11
  8038be:	e8 83 d9 ff ff       	call   801246 <_panic>
  8038c3:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8038c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038cc:	89 10                	mov    %edx,(%eax)
  8038ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038d1:	8b 00                	mov    (%eax),%eax
  8038d3:	85 c0                	test   %eax,%eax
  8038d5:	74 0d                	je     8038e4 <alloc_block_BF+0x29d>
  8038d7:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8038dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038df:	89 50 04             	mov    %edx,0x4(%eax)
  8038e2:	eb 08                	jmp    8038ec <alloc_block_BF+0x2a5>
  8038e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e7:	a3 30 70 80 00       	mov    %eax,0x807030
  8038ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038ef:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8038f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fe:	a1 38 70 80 00       	mov    0x807038,%eax
  803903:	40                   	inc    %eax
  803904:	a3 38 70 80 00       	mov    %eax,0x807038
  803909:	e9 dc 00 00 00       	jmp    8039ea <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	75 65                	jne    80397c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803917:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80391b:	75 17                	jne    803934 <alloc_block_BF+0x2ed>
  80391d:	83 ec 04             	sub    $0x4,%esp
  803920:	68 60 5f 80 00       	push   $0x805f60
  803925:	68 4a 01 00 00       	push   $0x14a
  80392a:	68 11 5f 80 00       	push   $0x805f11
  80392f:	e8 12 d9 ff ff       	call   801246 <_panic>
  803934:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80393a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803943:	8b 40 04             	mov    0x4(%eax),%eax
  803946:	85 c0                	test   %eax,%eax
  803948:	74 0c                	je     803956 <alloc_block_BF+0x30f>
  80394a:	a1 30 70 80 00       	mov    0x807030,%eax
  80394f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803952:	89 10                	mov    %edx,(%eax)
  803954:	eb 08                	jmp    80395e <alloc_block_BF+0x317>
  803956:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803959:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80395e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803961:	a3 30 70 80 00       	mov    %eax,0x807030
  803966:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396f:	a1 38 70 80 00       	mov    0x807038,%eax
  803974:	40                   	inc    %eax
  803975:	a3 38 70 80 00       	mov    %eax,0x807038
  80397a:	eb 6e                	jmp    8039ea <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80397c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803980:	74 06                	je     803988 <alloc_block_BF+0x341>
  803982:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803986:	75 17                	jne    80399f <alloc_block_BF+0x358>
  803988:	83 ec 04             	sub    $0x4,%esp
  80398b:	68 84 5f 80 00       	push   $0x805f84
  803990:	68 4f 01 00 00       	push   $0x14f
  803995:	68 11 5f 80 00       	push   $0x805f11
  80399a:	e8 a7 d8 ff ff       	call   801246 <_panic>
  80399f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a2:	8b 10                	mov    (%eax),%edx
  8039a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039a7:	89 10                	mov    %edx,(%eax)
  8039a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	85 c0                	test   %eax,%eax
  8039b0:	74 0b                	je     8039bd <alloc_block_BF+0x376>
  8039b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b5:	8b 00                	mov    (%eax),%eax
  8039b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039ba:	89 50 04             	mov    %edx,0x4(%eax)
  8039bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039c3:	89 10                	mov    %edx,(%eax)
  8039c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039cb:	89 50 04             	mov    %edx,0x4(%eax)
  8039ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039d1:	8b 00                	mov    (%eax),%eax
  8039d3:	85 c0                	test   %eax,%eax
  8039d5:	75 08                	jne    8039df <alloc_block_BF+0x398>
  8039d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039da:	a3 30 70 80 00       	mov    %eax,0x807030
  8039df:	a1 38 70 80 00       	mov    0x807038,%eax
  8039e4:	40                   	inc    %eax
  8039e5:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8039ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039ee:	75 17                	jne    803a07 <alloc_block_BF+0x3c0>
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	68 f3 5e 80 00       	push   $0x805ef3
  8039f8:	68 51 01 00 00       	push   $0x151
  8039fd:	68 11 5f 80 00       	push   $0x805f11
  803a02:	e8 3f d8 ff ff       	call   801246 <_panic>
  803a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0a:	8b 00                	mov    (%eax),%eax
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	74 10                	je     803a20 <alloc_block_BF+0x3d9>
  803a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a18:	8b 52 04             	mov    0x4(%edx),%edx
  803a1b:	89 50 04             	mov    %edx,0x4(%eax)
  803a1e:	eb 0b                	jmp    803a2b <alloc_block_BF+0x3e4>
  803a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a23:	8b 40 04             	mov    0x4(%eax),%eax
  803a26:	a3 30 70 80 00       	mov    %eax,0x807030
  803a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2e:	8b 40 04             	mov    0x4(%eax),%eax
  803a31:	85 c0                	test   %eax,%eax
  803a33:	74 0f                	je     803a44 <alloc_block_BF+0x3fd>
  803a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a38:	8b 40 04             	mov    0x4(%eax),%eax
  803a3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a3e:	8b 12                	mov    (%edx),%edx
  803a40:	89 10                	mov    %edx,(%eax)
  803a42:	eb 0a                	jmp    803a4e <alloc_block_BF+0x407>
  803a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a61:	a1 38 70 80 00       	mov    0x807038,%eax
  803a66:	48                   	dec    %eax
  803a67:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  803a6c:	83 ec 04             	sub    $0x4,%esp
  803a6f:	6a 00                	push   $0x0
  803a71:	ff 75 d0             	pushl  -0x30(%ebp)
  803a74:	ff 75 cc             	pushl  -0x34(%ebp)
  803a77:	e8 e0 f6 ff ff       	call   80315c <set_block_data>
  803a7c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a82:	e9 a3 01 00 00       	jmp    803c2a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803a87:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803a8b:	0f 85 9d 00 00 00    	jne    803b2e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803a91:	83 ec 04             	sub    $0x4,%esp
  803a94:	6a 01                	push   $0x1
  803a96:	ff 75 ec             	pushl  -0x14(%ebp)
  803a99:	ff 75 f0             	pushl  -0x10(%ebp)
  803a9c:	e8 bb f6 ff ff       	call   80315c <set_block_data>
  803aa1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803aa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aa8:	75 17                	jne    803ac1 <alloc_block_BF+0x47a>
  803aaa:	83 ec 04             	sub    $0x4,%esp
  803aad:	68 f3 5e 80 00       	push   $0x805ef3
  803ab2:	68 58 01 00 00       	push   $0x158
  803ab7:	68 11 5f 80 00       	push   $0x805f11
  803abc:	e8 85 d7 ff ff       	call   801246 <_panic>
  803ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	74 10                	je     803ada <alloc_block_BF+0x493>
  803aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803acd:	8b 00                	mov    (%eax),%eax
  803acf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad2:	8b 52 04             	mov    0x4(%edx),%edx
  803ad5:	89 50 04             	mov    %edx,0x4(%eax)
  803ad8:	eb 0b                	jmp    803ae5 <alloc_block_BF+0x49e>
  803ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803add:	8b 40 04             	mov    0x4(%eax),%eax
  803ae0:	a3 30 70 80 00       	mov    %eax,0x807030
  803ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 0f                	je     803afe <alloc_block_BF+0x4b7>
  803aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af2:	8b 40 04             	mov    0x4(%eax),%eax
  803af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803af8:	8b 12                	mov    (%edx),%edx
  803afa:	89 10                	mov    %edx,(%eax)
  803afc:	eb 0a                	jmp    803b08 <alloc_block_BF+0x4c1>
  803afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1b:	a1 38 70 80 00       	mov    0x807038,%eax
  803b20:	48                   	dec    %eax
  803b21:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  803b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b29:	e9 fc 00 00 00       	jmp    803c2a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	83 c0 08             	add    $0x8,%eax
  803b34:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803b37:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803b3e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b44:	01 d0                	add    %edx,%eax
  803b46:	48                   	dec    %eax
  803b47:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803b4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803b52:	f7 75 c4             	divl   -0x3c(%ebp)
  803b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b58:	29 d0                	sub    %edx,%eax
  803b5a:	c1 e8 0c             	shr    $0xc,%eax
  803b5d:	83 ec 0c             	sub    $0xc,%esp
  803b60:	50                   	push   %eax
  803b61:	e8 37 e7 ff ff       	call   80229d <sbrk>
  803b66:	83 c4 10             	add    $0x10,%esp
  803b69:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803b6c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803b70:	75 0a                	jne    803b7c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803b72:	b8 00 00 00 00       	mov    $0x0,%eax
  803b77:	e9 ae 00 00 00       	jmp    803c2a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803b7c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803b83:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b89:	01 d0                	add    %edx,%eax
  803b8b:	48                   	dec    %eax
  803b8c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803b8f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803b92:	ba 00 00 00 00       	mov    $0x0,%edx
  803b97:	f7 75 b8             	divl   -0x48(%ebp)
  803b9a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803b9d:	29 d0                	sub    %edx,%eax
  803b9f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ba2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ba5:	01 d0                	add    %edx,%eax
  803ba7:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  803bac:	a1 40 70 80 00       	mov    0x807040,%eax
  803bb1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803bb7:	83 ec 0c             	sub    $0xc,%esp
  803bba:	68 b8 5f 80 00       	push   $0x805fb8
  803bbf:	e8 3f d9 ff ff       	call   801503 <cprintf>
  803bc4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803bc7:	83 ec 08             	sub    $0x8,%esp
  803bca:	ff 75 bc             	pushl  -0x44(%ebp)
  803bcd:	68 bd 5f 80 00       	push   $0x805fbd
  803bd2:	e8 2c d9 ff ff       	call   801503 <cprintf>
  803bd7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803bda:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803be1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803be7:	01 d0                	add    %edx,%eax
  803be9:	48                   	dec    %eax
  803bea:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803bed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  803bf5:	f7 75 b0             	divl   -0x50(%ebp)
  803bf8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803bfb:	29 d0                	sub    %edx,%eax
  803bfd:	83 ec 04             	sub    $0x4,%esp
  803c00:	6a 01                	push   $0x1
  803c02:	50                   	push   %eax
  803c03:	ff 75 bc             	pushl  -0x44(%ebp)
  803c06:	e8 51 f5 ff ff       	call   80315c <set_block_data>
  803c0b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803c0e:	83 ec 0c             	sub    $0xc,%esp
  803c11:	ff 75 bc             	pushl  -0x44(%ebp)
  803c14:	e8 36 04 00 00       	call   80404f <free_block>
  803c19:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803c1c:	83 ec 0c             	sub    $0xc,%esp
  803c1f:	ff 75 08             	pushl  0x8(%ebp)
  803c22:	e8 20 fa ff ff       	call   803647 <alloc_block_BF>
  803c27:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803c2a:	c9                   	leave  
  803c2b:	c3                   	ret    

00803c2c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803c2c:	55                   	push   %ebp
  803c2d:	89 e5                	mov    %esp,%ebp
  803c2f:	53                   	push   %ebx
  803c30:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c45:	74 1e                	je     803c65 <merging+0x39>
  803c47:	ff 75 08             	pushl  0x8(%ebp)
  803c4a:	e8 bc f1 ff ff       	call   802e0b <get_block_size>
  803c4f:	83 c4 04             	add    $0x4,%esp
  803c52:	89 c2                	mov    %eax,%edx
  803c54:	8b 45 08             	mov    0x8(%ebp),%eax
  803c57:	01 d0                	add    %edx,%eax
  803c59:	3b 45 10             	cmp    0x10(%ebp),%eax
  803c5c:	75 07                	jne    803c65 <merging+0x39>
		prev_is_free = 1;
  803c5e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c69:	74 1e                	je     803c89 <merging+0x5d>
  803c6b:	ff 75 10             	pushl  0x10(%ebp)
  803c6e:	e8 98 f1 ff ff       	call   802e0b <get_block_size>
  803c73:	83 c4 04             	add    $0x4,%esp
  803c76:	89 c2                	mov    %eax,%edx
  803c78:	8b 45 10             	mov    0x10(%ebp),%eax
  803c7b:	01 d0                	add    %edx,%eax
  803c7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c80:	75 07                	jne    803c89 <merging+0x5d>
		next_is_free = 1;
  803c82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803c89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c8d:	0f 84 cc 00 00 00    	je     803d5f <merging+0x133>
  803c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c97:	0f 84 c2 00 00 00    	je     803d5f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803c9d:	ff 75 08             	pushl  0x8(%ebp)
  803ca0:	e8 66 f1 ff ff       	call   802e0b <get_block_size>
  803ca5:	83 c4 04             	add    $0x4,%esp
  803ca8:	89 c3                	mov    %eax,%ebx
  803caa:	ff 75 10             	pushl  0x10(%ebp)
  803cad:	e8 59 f1 ff ff       	call   802e0b <get_block_size>
  803cb2:	83 c4 04             	add    $0x4,%esp
  803cb5:	01 c3                	add    %eax,%ebx
  803cb7:	ff 75 0c             	pushl  0xc(%ebp)
  803cba:	e8 4c f1 ff ff       	call   802e0b <get_block_size>
  803cbf:	83 c4 04             	add    $0x4,%esp
  803cc2:	01 d8                	add    %ebx,%eax
  803cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803cc7:	6a 00                	push   $0x0
  803cc9:	ff 75 ec             	pushl  -0x14(%ebp)
  803ccc:	ff 75 08             	pushl  0x8(%ebp)
  803ccf:	e8 88 f4 ff ff       	call   80315c <set_block_data>
  803cd4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cdb:	75 17                	jne    803cf4 <merging+0xc8>
  803cdd:	83 ec 04             	sub    $0x4,%esp
  803ce0:	68 f3 5e 80 00       	push   $0x805ef3
  803ce5:	68 7d 01 00 00       	push   $0x17d
  803cea:	68 11 5f 80 00       	push   $0x805f11
  803cef:	e8 52 d5 ff ff       	call   801246 <_panic>
  803cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	85 c0                	test   %eax,%eax
  803cfb:	74 10                	je     803d0d <merging+0xe1>
  803cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d05:	8b 52 04             	mov    0x4(%edx),%edx
  803d08:	89 50 04             	mov    %edx,0x4(%eax)
  803d0b:	eb 0b                	jmp    803d18 <merging+0xec>
  803d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d10:	8b 40 04             	mov    0x4(%eax),%eax
  803d13:	a3 30 70 80 00       	mov    %eax,0x807030
  803d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1b:	8b 40 04             	mov    0x4(%eax),%eax
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	74 0f                	je     803d31 <merging+0x105>
  803d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d25:	8b 40 04             	mov    0x4(%eax),%eax
  803d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d2b:	8b 12                	mov    (%edx),%edx
  803d2d:	89 10                	mov    %edx,(%eax)
  803d2f:	eb 0a                	jmp    803d3b <merging+0x10f>
  803d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d34:	8b 00                	mov    (%eax),%eax
  803d36:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d4e:	a1 38 70 80 00       	mov    0x807038,%eax
  803d53:	48                   	dec    %eax
  803d54:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803d59:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d5a:	e9 ea 02 00 00       	jmp    804049 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d63:	74 3b                	je     803da0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803d65:	83 ec 0c             	sub    $0xc,%esp
  803d68:	ff 75 08             	pushl  0x8(%ebp)
  803d6b:	e8 9b f0 ff ff       	call   802e0b <get_block_size>
  803d70:	83 c4 10             	add    $0x10,%esp
  803d73:	89 c3                	mov    %eax,%ebx
  803d75:	83 ec 0c             	sub    $0xc,%esp
  803d78:	ff 75 10             	pushl  0x10(%ebp)
  803d7b:	e8 8b f0 ff ff       	call   802e0b <get_block_size>
  803d80:	83 c4 10             	add    $0x10,%esp
  803d83:	01 d8                	add    %ebx,%eax
  803d85:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	6a 00                	push   $0x0
  803d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  803d90:	ff 75 08             	pushl  0x8(%ebp)
  803d93:	e8 c4 f3 ff ff       	call   80315c <set_block_data>
  803d98:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d9b:	e9 a9 02 00 00       	jmp    804049 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803da0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803da4:	0f 84 2d 01 00 00    	je     803ed7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803daa:	83 ec 0c             	sub    $0xc,%esp
  803dad:	ff 75 10             	pushl  0x10(%ebp)
  803db0:	e8 56 f0 ff ff       	call   802e0b <get_block_size>
  803db5:	83 c4 10             	add    $0x10,%esp
  803db8:	89 c3                	mov    %eax,%ebx
  803dba:	83 ec 0c             	sub    $0xc,%esp
  803dbd:	ff 75 0c             	pushl  0xc(%ebp)
  803dc0:	e8 46 f0 ff ff       	call   802e0b <get_block_size>
  803dc5:	83 c4 10             	add    $0x10,%esp
  803dc8:	01 d8                	add    %ebx,%eax
  803dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803dcd:	83 ec 04             	sub    $0x4,%esp
  803dd0:	6a 00                	push   $0x0
  803dd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803dd5:	ff 75 10             	pushl  0x10(%ebp)
  803dd8:	e8 7f f3 ff ff       	call   80315c <set_block_data>
  803ddd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803de0:	8b 45 10             	mov    0x10(%ebp),%eax
  803de3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803de6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803dea:	74 06                	je     803df2 <merging+0x1c6>
  803dec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803df0:	75 17                	jne    803e09 <merging+0x1dd>
  803df2:	83 ec 04             	sub    $0x4,%esp
  803df5:	68 cc 5f 80 00       	push   $0x805fcc
  803dfa:	68 8d 01 00 00       	push   $0x18d
  803dff:	68 11 5f 80 00       	push   $0x805f11
  803e04:	e8 3d d4 ff ff       	call   801246 <_panic>
  803e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e0c:	8b 50 04             	mov    0x4(%eax),%edx
  803e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e12:	89 50 04             	mov    %edx,0x4(%eax)
  803e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e1b:	89 10                	mov    %edx,(%eax)
  803e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e20:	8b 40 04             	mov    0x4(%eax),%eax
  803e23:	85 c0                	test   %eax,%eax
  803e25:	74 0d                	je     803e34 <merging+0x208>
  803e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e2a:	8b 40 04             	mov    0x4(%eax),%eax
  803e2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e30:	89 10                	mov    %edx,(%eax)
  803e32:	eb 08                	jmp    803e3c <merging+0x210>
  803e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e37:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e42:	89 50 04             	mov    %edx,0x4(%eax)
  803e45:	a1 38 70 80 00       	mov    0x807038,%eax
  803e4a:	40                   	inc    %eax
  803e4b:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  803e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e54:	75 17                	jne    803e6d <merging+0x241>
  803e56:	83 ec 04             	sub    $0x4,%esp
  803e59:	68 f3 5e 80 00       	push   $0x805ef3
  803e5e:	68 8e 01 00 00       	push   $0x18e
  803e63:	68 11 5f 80 00       	push   $0x805f11
  803e68:	e8 d9 d3 ff ff       	call   801246 <_panic>
  803e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e70:	8b 00                	mov    (%eax),%eax
  803e72:	85 c0                	test   %eax,%eax
  803e74:	74 10                	je     803e86 <merging+0x25a>
  803e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e79:	8b 00                	mov    (%eax),%eax
  803e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e7e:	8b 52 04             	mov    0x4(%edx),%edx
  803e81:	89 50 04             	mov    %edx,0x4(%eax)
  803e84:	eb 0b                	jmp    803e91 <merging+0x265>
  803e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e89:	8b 40 04             	mov    0x4(%eax),%eax
  803e8c:	a3 30 70 80 00       	mov    %eax,0x807030
  803e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e94:	8b 40 04             	mov    0x4(%eax),%eax
  803e97:	85 c0                	test   %eax,%eax
  803e99:	74 0f                	je     803eaa <merging+0x27e>
  803e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ea4:	8b 12                	mov    (%edx),%edx
  803ea6:	89 10                	mov    %edx,(%eax)
  803ea8:	eb 0a                	jmp    803eb4 <merging+0x288>
  803eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ead:	8b 00                	mov    (%eax),%eax
  803eaf:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ec0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec7:	a1 38 70 80 00       	mov    0x807038,%eax
  803ecc:	48                   	dec    %eax
  803ecd:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803ed2:	e9 72 01 00 00       	jmp    804049 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  803eda:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803edd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ee1:	74 79                	je     803f5c <merging+0x330>
  803ee3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ee7:	74 73                	je     803f5c <merging+0x330>
  803ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eed:	74 06                	je     803ef5 <merging+0x2c9>
  803eef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ef3:	75 17                	jne    803f0c <merging+0x2e0>
  803ef5:	83 ec 04             	sub    $0x4,%esp
  803ef8:	68 84 5f 80 00       	push   $0x805f84
  803efd:	68 94 01 00 00       	push   $0x194
  803f02:	68 11 5f 80 00       	push   $0x805f11
  803f07:	e8 3a d3 ff ff       	call   801246 <_panic>
  803f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0f:	8b 10                	mov    (%eax),%edx
  803f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f14:	89 10                	mov    %edx,(%eax)
  803f16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f19:	8b 00                	mov    (%eax),%eax
  803f1b:	85 c0                	test   %eax,%eax
  803f1d:	74 0b                	je     803f2a <merging+0x2fe>
  803f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f22:	8b 00                	mov    (%eax),%eax
  803f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f27:	89 50 04             	mov    %edx,0x4(%eax)
  803f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f30:	89 10                	mov    %edx,(%eax)
  803f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f35:	8b 55 08             	mov    0x8(%ebp),%edx
  803f38:	89 50 04             	mov    %edx,0x4(%eax)
  803f3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f3e:	8b 00                	mov    (%eax),%eax
  803f40:	85 c0                	test   %eax,%eax
  803f42:	75 08                	jne    803f4c <merging+0x320>
  803f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f47:	a3 30 70 80 00       	mov    %eax,0x807030
  803f4c:	a1 38 70 80 00       	mov    0x807038,%eax
  803f51:	40                   	inc    %eax
  803f52:	a3 38 70 80 00       	mov    %eax,0x807038
  803f57:	e9 ce 00 00 00       	jmp    80402a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f60:	74 65                	je     803fc7 <merging+0x39b>
  803f62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f66:	75 17                	jne    803f7f <merging+0x353>
  803f68:	83 ec 04             	sub    $0x4,%esp
  803f6b:	68 60 5f 80 00       	push   $0x805f60
  803f70:	68 95 01 00 00       	push   $0x195
  803f75:	68 11 5f 80 00       	push   $0x805f11
  803f7a:	e8 c7 d2 ff ff       	call   801246 <_panic>
  803f7f:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803f85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f88:	89 50 04             	mov    %edx,0x4(%eax)
  803f8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f8e:	8b 40 04             	mov    0x4(%eax),%eax
  803f91:	85 c0                	test   %eax,%eax
  803f93:	74 0c                	je     803fa1 <merging+0x375>
  803f95:	a1 30 70 80 00       	mov    0x807030,%eax
  803f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f9d:	89 10                	mov    %edx,(%eax)
  803f9f:	eb 08                	jmp    803fa9 <merging+0x37d>
  803fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fa4:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fac:	a3 30 70 80 00       	mov    %eax,0x807030
  803fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fba:	a1 38 70 80 00       	mov    0x807038,%eax
  803fbf:	40                   	inc    %eax
  803fc0:	a3 38 70 80 00       	mov    %eax,0x807038
  803fc5:	eb 63                	jmp    80402a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803fc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803fcb:	75 17                	jne    803fe4 <merging+0x3b8>
  803fcd:	83 ec 04             	sub    $0x4,%esp
  803fd0:	68 2c 5f 80 00       	push   $0x805f2c
  803fd5:	68 98 01 00 00       	push   $0x198
  803fda:	68 11 5f 80 00       	push   $0x805f11
  803fdf:	e8 62 d2 ff ff       	call   801246 <_panic>
  803fe4:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fed:	89 10                	mov    %edx,(%eax)
  803fef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ff2:	8b 00                	mov    (%eax),%eax
  803ff4:	85 c0                	test   %eax,%eax
  803ff6:	74 0d                	je     804005 <merging+0x3d9>
  803ff8:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803ffd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804000:	89 50 04             	mov    %edx,0x4(%eax)
  804003:	eb 08                	jmp    80400d <merging+0x3e1>
  804005:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804008:	a3 30 70 80 00       	mov    %eax,0x807030
  80400d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804010:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804015:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80401f:	a1 38 70 80 00       	mov    0x807038,%eax
  804024:	40                   	inc    %eax
  804025:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  80402a:	83 ec 0c             	sub    $0xc,%esp
  80402d:	ff 75 10             	pushl  0x10(%ebp)
  804030:	e8 d6 ed ff ff       	call   802e0b <get_block_size>
  804035:	83 c4 10             	add    $0x10,%esp
  804038:	83 ec 04             	sub    $0x4,%esp
  80403b:	6a 00                	push   $0x0
  80403d:	50                   	push   %eax
  80403e:	ff 75 10             	pushl  0x10(%ebp)
  804041:	e8 16 f1 ff ff       	call   80315c <set_block_data>
  804046:	83 c4 10             	add    $0x10,%esp
	}
}
  804049:	90                   	nop
  80404a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80404d:	c9                   	leave  
  80404e:	c3                   	ret    

0080404f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80404f:	55                   	push   %ebp
  804050:	89 e5                	mov    %esp,%ebp
  804052:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804055:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80405a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80405d:	a1 30 70 80 00       	mov    0x807030,%eax
  804062:	3b 45 08             	cmp    0x8(%ebp),%eax
  804065:	73 1b                	jae    804082 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804067:	a1 30 70 80 00       	mov    0x807030,%eax
  80406c:	83 ec 04             	sub    $0x4,%esp
  80406f:	ff 75 08             	pushl  0x8(%ebp)
  804072:	6a 00                	push   $0x0
  804074:	50                   	push   %eax
  804075:	e8 b2 fb ff ff       	call   803c2c <merging>
  80407a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80407d:	e9 8b 00 00 00       	jmp    80410d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  804082:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804087:	3b 45 08             	cmp    0x8(%ebp),%eax
  80408a:	76 18                	jbe    8040a4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80408c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804091:	83 ec 04             	sub    $0x4,%esp
  804094:	ff 75 08             	pushl  0x8(%ebp)
  804097:	50                   	push   %eax
  804098:	6a 00                	push   $0x0
  80409a:	e8 8d fb ff ff       	call   803c2c <merging>
  80409f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8040a2:	eb 69                	jmp    80410d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8040a4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8040a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040ac:	eb 39                	jmp    8040e7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8040ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040b4:	73 29                	jae    8040df <free_block+0x90>
  8040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b9:	8b 00                	mov    (%eax),%eax
  8040bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040be:	76 1f                	jbe    8040df <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8040c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040c3:	8b 00                	mov    (%eax),%eax
  8040c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8040c8:	83 ec 04             	sub    $0x4,%esp
  8040cb:	ff 75 08             	pushl  0x8(%ebp)
  8040ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8040d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8040d4:	e8 53 fb ff ff       	call   803c2c <merging>
  8040d9:	83 c4 10             	add    $0x10,%esp
			break;
  8040dc:	90                   	nop
		}
	}
}
  8040dd:	eb 2e                	jmp    80410d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8040df:	a1 34 70 80 00       	mov    0x807034,%eax
  8040e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040eb:	74 07                	je     8040f4 <free_block+0xa5>
  8040ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f0:	8b 00                	mov    (%eax),%eax
  8040f2:	eb 05                	jmp    8040f9 <free_block+0xaa>
  8040f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f9:	a3 34 70 80 00       	mov    %eax,0x807034
  8040fe:	a1 34 70 80 00       	mov    0x807034,%eax
  804103:	85 c0                	test   %eax,%eax
  804105:	75 a7                	jne    8040ae <free_block+0x5f>
  804107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80410b:	75 a1                	jne    8040ae <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80410d:	90                   	nop
  80410e:	c9                   	leave  
  80410f:	c3                   	ret    

00804110 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804110:	55                   	push   %ebp
  804111:	89 e5                	mov    %esp,%ebp
  804113:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804116:	ff 75 08             	pushl  0x8(%ebp)
  804119:	e8 ed ec ff ff       	call   802e0b <get_block_size>
  80411e:	83 c4 04             	add    $0x4,%esp
  804121:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80412b:	eb 17                	jmp    804144 <copy_data+0x34>
  80412d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804130:	8b 45 0c             	mov    0xc(%ebp),%eax
  804133:	01 c2                	add    %eax,%edx
  804135:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804138:	8b 45 08             	mov    0x8(%ebp),%eax
  80413b:	01 c8                	add    %ecx,%eax
  80413d:	8a 00                	mov    (%eax),%al
  80413f:	88 02                	mov    %al,(%edx)
  804141:	ff 45 fc             	incl   -0x4(%ebp)
  804144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804147:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80414a:	72 e1                	jb     80412d <copy_data+0x1d>
}
  80414c:	90                   	nop
  80414d:	c9                   	leave  
  80414e:	c3                   	ret    

0080414f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80414f:	55                   	push   %ebp
  804150:	89 e5                	mov    %esp,%ebp
  804152:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804159:	75 23                	jne    80417e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80415b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80415f:	74 13                	je     804174 <realloc_block_FF+0x25>
  804161:	83 ec 0c             	sub    $0xc,%esp
  804164:	ff 75 0c             	pushl  0xc(%ebp)
  804167:	e8 1f f0 ff ff       	call   80318b <alloc_block_FF>
  80416c:	83 c4 10             	add    $0x10,%esp
  80416f:	e9 f4 06 00 00       	jmp    804868 <realloc_block_FF+0x719>
		return NULL;
  804174:	b8 00 00 00 00       	mov    $0x0,%eax
  804179:	e9 ea 06 00 00       	jmp    804868 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80417e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804182:	75 18                	jne    80419c <realloc_block_FF+0x4d>
	{
		free_block(va);
  804184:	83 ec 0c             	sub    $0xc,%esp
  804187:	ff 75 08             	pushl  0x8(%ebp)
  80418a:	e8 c0 fe ff ff       	call   80404f <free_block>
  80418f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804192:	b8 00 00 00 00       	mov    $0x0,%eax
  804197:	e9 cc 06 00 00       	jmp    804868 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80419c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8041a0:	77 07                	ja     8041a9 <realloc_block_FF+0x5a>
  8041a2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8041a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041ac:	83 e0 01             	and    $0x1,%eax
  8041af:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8041b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041b5:	83 c0 08             	add    $0x8,%eax
  8041b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8041bb:	83 ec 0c             	sub    $0xc,%esp
  8041be:	ff 75 08             	pushl  0x8(%ebp)
  8041c1:	e8 45 ec ff ff       	call   802e0b <get_block_size>
  8041c6:	83 c4 10             	add    $0x10,%esp
  8041c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8041cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041cf:	83 e8 08             	sub    $0x8,%eax
  8041d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8041d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d8:	83 e8 04             	sub    $0x4,%eax
  8041db:	8b 00                	mov    (%eax),%eax
  8041dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8041e0:	89 c2                	mov    %eax,%edx
  8041e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e5:	01 d0                	add    %edx,%eax
  8041e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8041ea:	83 ec 0c             	sub    $0xc,%esp
  8041ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8041f0:	e8 16 ec ff ff       	call   802e0b <get_block_size>
  8041f5:	83 c4 10             	add    $0x10,%esp
  8041f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8041fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041fe:	83 e8 08             	sub    $0x8,%eax
  804201:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804204:	8b 45 0c             	mov    0xc(%ebp),%eax
  804207:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80420a:	75 08                	jne    804214 <realloc_block_FF+0xc5>
	{
		 return va;
  80420c:	8b 45 08             	mov    0x8(%ebp),%eax
  80420f:	e9 54 06 00 00       	jmp    804868 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804214:	8b 45 0c             	mov    0xc(%ebp),%eax
  804217:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80421a:	0f 83 e5 03 00 00    	jae    804605 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804223:	2b 45 0c             	sub    0xc(%ebp),%eax
  804226:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804229:	83 ec 0c             	sub    $0xc,%esp
  80422c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80422f:	e8 f0 eb ff ff       	call   802e24 <is_free_block>
  804234:	83 c4 10             	add    $0x10,%esp
  804237:	84 c0                	test   %al,%al
  804239:	0f 84 3b 01 00 00    	je     80437a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80423f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804242:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804245:	01 d0                	add    %edx,%eax
  804247:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80424a:	83 ec 04             	sub    $0x4,%esp
  80424d:	6a 01                	push   $0x1
  80424f:	ff 75 f0             	pushl  -0x10(%ebp)
  804252:	ff 75 08             	pushl  0x8(%ebp)
  804255:	e8 02 ef ff ff       	call   80315c <set_block_data>
  80425a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80425d:	8b 45 08             	mov    0x8(%ebp),%eax
  804260:	83 e8 04             	sub    $0x4,%eax
  804263:	8b 00                	mov    (%eax),%eax
  804265:	83 e0 fe             	and    $0xfffffffe,%eax
  804268:	89 c2                	mov    %eax,%edx
  80426a:	8b 45 08             	mov    0x8(%ebp),%eax
  80426d:	01 d0                	add    %edx,%eax
  80426f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804272:	83 ec 04             	sub    $0x4,%esp
  804275:	6a 00                	push   $0x0
  804277:	ff 75 cc             	pushl  -0x34(%ebp)
  80427a:	ff 75 c8             	pushl  -0x38(%ebp)
  80427d:	e8 da ee ff ff       	call   80315c <set_block_data>
  804282:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804285:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804289:	74 06                	je     804291 <realloc_block_FF+0x142>
  80428b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80428f:	75 17                	jne    8042a8 <realloc_block_FF+0x159>
  804291:	83 ec 04             	sub    $0x4,%esp
  804294:	68 84 5f 80 00       	push   $0x805f84
  804299:	68 f6 01 00 00       	push   $0x1f6
  80429e:	68 11 5f 80 00       	push   $0x805f11
  8042a3:	e8 9e cf ff ff       	call   801246 <_panic>
  8042a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ab:	8b 10                	mov    (%eax),%edx
  8042ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042b0:	89 10                	mov    %edx,(%eax)
  8042b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042b5:	8b 00                	mov    (%eax),%eax
  8042b7:	85 c0                	test   %eax,%eax
  8042b9:	74 0b                	je     8042c6 <realloc_block_FF+0x177>
  8042bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042be:	8b 00                	mov    (%eax),%eax
  8042c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8042c3:	89 50 04             	mov    %edx,0x4(%eax)
  8042c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8042cc:	89 10                	mov    %edx,(%eax)
  8042ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042d4:	89 50 04             	mov    %edx,0x4(%eax)
  8042d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042da:	8b 00                	mov    (%eax),%eax
  8042dc:	85 c0                	test   %eax,%eax
  8042de:	75 08                	jne    8042e8 <realloc_block_FF+0x199>
  8042e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042e3:	a3 30 70 80 00       	mov    %eax,0x807030
  8042e8:	a1 38 70 80 00       	mov    0x807038,%eax
  8042ed:	40                   	inc    %eax
  8042ee:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8042f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042f7:	75 17                	jne    804310 <realloc_block_FF+0x1c1>
  8042f9:	83 ec 04             	sub    $0x4,%esp
  8042fc:	68 f3 5e 80 00       	push   $0x805ef3
  804301:	68 f7 01 00 00       	push   $0x1f7
  804306:	68 11 5f 80 00       	push   $0x805f11
  80430b:	e8 36 cf ff ff       	call   801246 <_panic>
  804310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804313:	8b 00                	mov    (%eax),%eax
  804315:	85 c0                	test   %eax,%eax
  804317:	74 10                	je     804329 <realloc_block_FF+0x1da>
  804319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80431c:	8b 00                	mov    (%eax),%eax
  80431e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804321:	8b 52 04             	mov    0x4(%edx),%edx
  804324:	89 50 04             	mov    %edx,0x4(%eax)
  804327:	eb 0b                	jmp    804334 <realloc_block_FF+0x1e5>
  804329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432c:	8b 40 04             	mov    0x4(%eax),%eax
  80432f:	a3 30 70 80 00       	mov    %eax,0x807030
  804334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804337:	8b 40 04             	mov    0x4(%eax),%eax
  80433a:	85 c0                	test   %eax,%eax
  80433c:	74 0f                	je     80434d <realloc_block_FF+0x1fe>
  80433e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804341:	8b 40 04             	mov    0x4(%eax),%eax
  804344:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804347:	8b 12                	mov    (%edx),%edx
  804349:	89 10                	mov    %edx,(%eax)
  80434b:	eb 0a                	jmp    804357 <realloc_block_FF+0x208>
  80434d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804350:	8b 00                	mov    (%eax),%eax
  804352:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80435a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804363:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80436a:	a1 38 70 80 00       	mov    0x807038,%eax
  80436f:	48                   	dec    %eax
  804370:	a3 38 70 80 00       	mov    %eax,0x807038
  804375:	e9 83 02 00 00       	jmp    8045fd <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80437a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80437e:	0f 86 69 02 00 00    	jbe    8045ed <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804384:	83 ec 04             	sub    $0x4,%esp
  804387:	6a 01                	push   $0x1
  804389:	ff 75 f0             	pushl  -0x10(%ebp)
  80438c:	ff 75 08             	pushl  0x8(%ebp)
  80438f:	e8 c8 ed ff ff       	call   80315c <set_block_data>
  804394:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804397:	8b 45 08             	mov    0x8(%ebp),%eax
  80439a:	83 e8 04             	sub    $0x4,%eax
  80439d:	8b 00                	mov    (%eax),%eax
  80439f:	83 e0 fe             	and    $0xfffffffe,%eax
  8043a2:	89 c2                	mov    %eax,%edx
  8043a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a7:	01 d0                	add    %edx,%eax
  8043a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8043ac:	a1 38 70 80 00       	mov    0x807038,%eax
  8043b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8043b4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8043b8:	75 68                	jne    804422 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8043ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043be:	75 17                	jne    8043d7 <realloc_block_FF+0x288>
  8043c0:	83 ec 04             	sub    $0x4,%esp
  8043c3:	68 2c 5f 80 00       	push   $0x805f2c
  8043c8:	68 06 02 00 00       	push   $0x206
  8043cd:	68 11 5f 80 00       	push   $0x805f11
  8043d2:	e8 6f ce ff ff       	call   801246 <_panic>
  8043d7:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8043dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043e0:	89 10                	mov    %edx,(%eax)
  8043e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043e5:	8b 00                	mov    (%eax),%eax
  8043e7:	85 c0                	test   %eax,%eax
  8043e9:	74 0d                	je     8043f8 <realloc_block_FF+0x2a9>
  8043eb:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8043f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043f3:	89 50 04             	mov    %edx,0x4(%eax)
  8043f6:	eb 08                	jmp    804400 <realloc_block_FF+0x2b1>
  8043f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043fb:	a3 30 70 80 00       	mov    %eax,0x807030
  804400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804403:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80440b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804412:	a1 38 70 80 00       	mov    0x807038,%eax
  804417:	40                   	inc    %eax
  804418:	a3 38 70 80 00       	mov    %eax,0x807038
  80441d:	e9 b0 01 00 00       	jmp    8045d2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804422:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804427:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80442a:	76 68                	jbe    804494 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80442c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804430:	75 17                	jne    804449 <realloc_block_FF+0x2fa>
  804432:	83 ec 04             	sub    $0x4,%esp
  804435:	68 2c 5f 80 00       	push   $0x805f2c
  80443a:	68 0b 02 00 00       	push   $0x20b
  80443f:	68 11 5f 80 00       	push   $0x805f11
  804444:	e8 fd cd ff ff       	call   801246 <_panic>
  804449:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80444f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804452:	89 10                	mov    %edx,(%eax)
  804454:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804457:	8b 00                	mov    (%eax),%eax
  804459:	85 c0                	test   %eax,%eax
  80445b:	74 0d                	je     80446a <realloc_block_FF+0x31b>
  80445d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804462:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804465:	89 50 04             	mov    %edx,0x4(%eax)
  804468:	eb 08                	jmp    804472 <realloc_block_FF+0x323>
  80446a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80446d:	a3 30 70 80 00       	mov    %eax,0x807030
  804472:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804475:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80447a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80447d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804484:	a1 38 70 80 00       	mov    0x807038,%eax
  804489:	40                   	inc    %eax
  80448a:	a3 38 70 80 00       	mov    %eax,0x807038
  80448f:	e9 3e 01 00 00       	jmp    8045d2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804494:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804499:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80449c:	73 68                	jae    804506 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80449e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8044a2:	75 17                	jne    8044bb <realloc_block_FF+0x36c>
  8044a4:	83 ec 04             	sub    $0x4,%esp
  8044a7:	68 60 5f 80 00       	push   $0x805f60
  8044ac:	68 10 02 00 00       	push   $0x210
  8044b1:	68 11 5f 80 00       	push   $0x805f11
  8044b6:	e8 8b cd ff ff       	call   801246 <_panic>
  8044bb:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8044c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044c4:	89 50 04             	mov    %edx,0x4(%eax)
  8044c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044ca:	8b 40 04             	mov    0x4(%eax),%eax
  8044cd:	85 c0                	test   %eax,%eax
  8044cf:	74 0c                	je     8044dd <realloc_block_FF+0x38e>
  8044d1:	a1 30 70 80 00       	mov    0x807030,%eax
  8044d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8044d9:	89 10                	mov    %edx,(%eax)
  8044db:	eb 08                	jmp    8044e5 <realloc_block_FF+0x396>
  8044dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044e0:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8044e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044e8:	a3 30 70 80 00       	mov    %eax,0x807030
  8044ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044f6:	a1 38 70 80 00       	mov    0x807038,%eax
  8044fb:	40                   	inc    %eax
  8044fc:	a3 38 70 80 00       	mov    %eax,0x807038
  804501:	e9 cc 00 00 00       	jmp    8045d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804506:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80450d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804515:	e9 8a 00 00 00       	jmp    8045a4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80451d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804520:	73 7a                	jae    80459c <realloc_block_FF+0x44d>
  804522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804525:	8b 00                	mov    (%eax),%eax
  804527:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80452a:	73 70                	jae    80459c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80452c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804530:	74 06                	je     804538 <realloc_block_FF+0x3e9>
  804532:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804536:	75 17                	jne    80454f <realloc_block_FF+0x400>
  804538:	83 ec 04             	sub    $0x4,%esp
  80453b:	68 84 5f 80 00       	push   $0x805f84
  804540:	68 1a 02 00 00       	push   $0x21a
  804545:	68 11 5f 80 00       	push   $0x805f11
  80454a:	e8 f7 cc ff ff       	call   801246 <_panic>
  80454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804552:	8b 10                	mov    (%eax),%edx
  804554:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804557:	89 10                	mov    %edx,(%eax)
  804559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80455c:	8b 00                	mov    (%eax),%eax
  80455e:	85 c0                	test   %eax,%eax
  804560:	74 0b                	je     80456d <realloc_block_FF+0x41e>
  804562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804565:	8b 00                	mov    (%eax),%eax
  804567:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80456a:	89 50 04             	mov    %edx,0x4(%eax)
  80456d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804570:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804573:	89 10                	mov    %edx,(%eax)
  804575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80457b:	89 50 04             	mov    %edx,0x4(%eax)
  80457e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804581:	8b 00                	mov    (%eax),%eax
  804583:	85 c0                	test   %eax,%eax
  804585:	75 08                	jne    80458f <realloc_block_FF+0x440>
  804587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80458a:	a3 30 70 80 00       	mov    %eax,0x807030
  80458f:	a1 38 70 80 00       	mov    0x807038,%eax
  804594:	40                   	inc    %eax
  804595:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  80459a:	eb 36                	jmp    8045d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80459c:	a1 34 70 80 00       	mov    0x807034,%eax
  8045a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045a8:	74 07                	je     8045b1 <realloc_block_FF+0x462>
  8045aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ad:	8b 00                	mov    (%eax),%eax
  8045af:	eb 05                	jmp    8045b6 <realloc_block_FF+0x467>
  8045b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b6:	a3 34 70 80 00       	mov    %eax,0x807034
  8045bb:	a1 34 70 80 00       	mov    0x807034,%eax
  8045c0:	85 c0                	test   %eax,%eax
  8045c2:	0f 85 52 ff ff ff    	jne    80451a <realloc_block_FF+0x3cb>
  8045c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045cc:	0f 85 48 ff ff ff    	jne    80451a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8045d2:	83 ec 04             	sub    $0x4,%esp
  8045d5:	6a 00                	push   $0x0
  8045d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8045da:	ff 75 d4             	pushl  -0x2c(%ebp)
  8045dd:	e8 7a eb ff ff       	call   80315c <set_block_data>
  8045e2:	83 c4 10             	add    $0x10,%esp
				return va;
  8045e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e8:	e9 7b 02 00 00       	jmp    804868 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8045ed:	83 ec 0c             	sub    $0xc,%esp
  8045f0:	68 01 60 80 00       	push   $0x806001
  8045f5:	e8 09 cf ff ff       	call   801503 <cprintf>
  8045fa:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8045fd:	8b 45 08             	mov    0x8(%ebp),%eax
  804600:	e9 63 02 00 00       	jmp    804868 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804605:	8b 45 0c             	mov    0xc(%ebp),%eax
  804608:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80460b:	0f 86 4d 02 00 00    	jbe    80485e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804611:	83 ec 0c             	sub    $0xc,%esp
  804614:	ff 75 e4             	pushl  -0x1c(%ebp)
  804617:	e8 08 e8 ff ff       	call   802e24 <is_free_block>
  80461c:	83 c4 10             	add    $0x10,%esp
  80461f:	84 c0                	test   %al,%al
  804621:	0f 84 37 02 00 00    	je     80485e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80462a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80462d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804630:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804636:	76 38                	jbe    804670 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804638:	83 ec 0c             	sub    $0xc,%esp
  80463b:	ff 75 08             	pushl  0x8(%ebp)
  80463e:	e8 0c fa ff ff       	call   80404f <free_block>
  804643:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804646:	83 ec 0c             	sub    $0xc,%esp
  804649:	ff 75 0c             	pushl  0xc(%ebp)
  80464c:	e8 3a eb ff ff       	call   80318b <alloc_block_FF>
  804651:	83 c4 10             	add    $0x10,%esp
  804654:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804657:	83 ec 08             	sub    $0x8,%esp
  80465a:	ff 75 c0             	pushl  -0x40(%ebp)
  80465d:	ff 75 08             	pushl  0x8(%ebp)
  804660:	e8 ab fa ff ff       	call   804110 <copy_data>
  804665:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804668:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80466b:	e9 f8 01 00 00       	jmp    804868 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804673:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804676:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804679:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80467d:	0f 87 a0 00 00 00    	ja     804723 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804687:	75 17                	jne    8046a0 <realloc_block_FF+0x551>
  804689:	83 ec 04             	sub    $0x4,%esp
  80468c:	68 f3 5e 80 00       	push   $0x805ef3
  804691:	68 38 02 00 00       	push   $0x238
  804696:	68 11 5f 80 00       	push   $0x805f11
  80469b:	e8 a6 cb ff ff       	call   801246 <_panic>
  8046a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046a3:	8b 00                	mov    (%eax),%eax
  8046a5:	85 c0                	test   %eax,%eax
  8046a7:	74 10                	je     8046b9 <realloc_block_FF+0x56a>
  8046a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ac:	8b 00                	mov    (%eax),%eax
  8046ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046b1:	8b 52 04             	mov    0x4(%edx),%edx
  8046b4:	89 50 04             	mov    %edx,0x4(%eax)
  8046b7:	eb 0b                	jmp    8046c4 <realloc_block_FF+0x575>
  8046b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046bc:	8b 40 04             	mov    0x4(%eax),%eax
  8046bf:	a3 30 70 80 00       	mov    %eax,0x807030
  8046c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046c7:	8b 40 04             	mov    0x4(%eax),%eax
  8046ca:	85 c0                	test   %eax,%eax
  8046cc:	74 0f                	je     8046dd <realloc_block_FF+0x58e>
  8046ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046d1:	8b 40 04             	mov    0x4(%eax),%eax
  8046d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046d7:	8b 12                	mov    (%edx),%edx
  8046d9:	89 10                	mov    %edx,(%eax)
  8046db:	eb 0a                	jmp    8046e7 <realloc_block_FF+0x598>
  8046dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046e0:	8b 00                	mov    (%eax),%eax
  8046e2:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8046e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046fa:	a1 38 70 80 00       	mov    0x807038,%eax
  8046ff:	48                   	dec    %eax
  804700:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804705:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80470b:	01 d0                	add    %edx,%eax
  80470d:	83 ec 04             	sub    $0x4,%esp
  804710:	6a 01                	push   $0x1
  804712:	50                   	push   %eax
  804713:	ff 75 08             	pushl  0x8(%ebp)
  804716:	e8 41 ea ff ff       	call   80315c <set_block_data>
  80471b:	83 c4 10             	add    $0x10,%esp
  80471e:	e9 36 01 00 00       	jmp    804859 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804723:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804726:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804729:	01 d0                	add    %edx,%eax
  80472b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80472e:	83 ec 04             	sub    $0x4,%esp
  804731:	6a 01                	push   $0x1
  804733:	ff 75 f0             	pushl  -0x10(%ebp)
  804736:	ff 75 08             	pushl  0x8(%ebp)
  804739:	e8 1e ea ff ff       	call   80315c <set_block_data>
  80473e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804741:	8b 45 08             	mov    0x8(%ebp),%eax
  804744:	83 e8 04             	sub    $0x4,%eax
  804747:	8b 00                	mov    (%eax),%eax
  804749:	83 e0 fe             	and    $0xfffffffe,%eax
  80474c:	89 c2                	mov    %eax,%edx
  80474e:	8b 45 08             	mov    0x8(%ebp),%eax
  804751:	01 d0                	add    %edx,%eax
  804753:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804756:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80475a:	74 06                	je     804762 <realloc_block_FF+0x613>
  80475c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804760:	75 17                	jne    804779 <realloc_block_FF+0x62a>
  804762:	83 ec 04             	sub    $0x4,%esp
  804765:	68 84 5f 80 00       	push   $0x805f84
  80476a:	68 44 02 00 00       	push   $0x244
  80476f:	68 11 5f 80 00       	push   $0x805f11
  804774:	e8 cd ca ff ff       	call   801246 <_panic>
  804779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80477c:	8b 10                	mov    (%eax),%edx
  80477e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804781:	89 10                	mov    %edx,(%eax)
  804783:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804786:	8b 00                	mov    (%eax),%eax
  804788:	85 c0                	test   %eax,%eax
  80478a:	74 0b                	je     804797 <realloc_block_FF+0x648>
  80478c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80478f:	8b 00                	mov    (%eax),%eax
  804791:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804794:	89 50 04             	mov    %edx,0x4(%eax)
  804797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80479a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80479d:	89 10                	mov    %edx,(%eax)
  80479f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8047a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047a5:	89 50 04             	mov    %edx,0x4(%eax)
  8047a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8047ab:	8b 00                	mov    (%eax),%eax
  8047ad:	85 c0                	test   %eax,%eax
  8047af:	75 08                	jne    8047b9 <realloc_block_FF+0x66a>
  8047b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8047b4:	a3 30 70 80 00       	mov    %eax,0x807030
  8047b9:	a1 38 70 80 00       	mov    0x807038,%eax
  8047be:	40                   	inc    %eax
  8047bf:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8047c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8047c8:	75 17                	jne    8047e1 <realloc_block_FF+0x692>
  8047ca:	83 ec 04             	sub    $0x4,%esp
  8047cd:	68 f3 5e 80 00       	push   $0x805ef3
  8047d2:	68 45 02 00 00       	push   $0x245
  8047d7:	68 11 5f 80 00       	push   $0x805f11
  8047dc:	e8 65 ca ff ff       	call   801246 <_panic>
  8047e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047e4:	8b 00                	mov    (%eax),%eax
  8047e6:	85 c0                	test   %eax,%eax
  8047e8:	74 10                	je     8047fa <realloc_block_FF+0x6ab>
  8047ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ed:	8b 00                	mov    (%eax),%eax
  8047ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047f2:	8b 52 04             	mov    0x4(%edx),%edx
  8047f5:	89 50 04             	mov    %edx,0x4(%eax)
  8047f8:	eb 0b                	jmp    804805 <realloc_block_FF+0x6b6>
  8047fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047fd:	8b 40 04             	mov    0x4(%eax),%eax
  804800:	a3 30 70 80 00       	mov    %eax,0x807030
  804805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804808:	8b 40 04             	mov    0x4(%eax),%eax
  80480b:	85 c0                	test   %eax,%eax
  80480d:	74 0f                	je     80481e <realloc_block_FF+0x6cf>
  80480f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804812:	8b 40 04             	mov    0x4(%eax),%eax
  804815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804818:	8b 12                	mov    (%edx),%edx
  80481a:	89 10                	mov    %edx,(%eax)
  80481c:	eb 0a                	jmp    804828 <realloc_block_FF+0x6d9>
  80481e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804821:	8b 00                	mov    (%eax),%eax
  804823:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80482b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80483b:	a1 38 70 80 00       	mov    0x807038,%eax
  804840:	48                   	dec    %eax
  804841:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804846:	83 ec 04             	sub    $0x4,%esp
  804849:	6a 00                	push   $0x0
  80484b:	ff 75 bc             	pushl  -0x44(%ebp)
  80484e:	ff 75 b8             	pushl  -0x48(%ebp)
  804851:	e8 06 e9 ff ff       	call   80315c <set_block_data>
  804856:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804859:	8b 45 08             	mov    0x8(%ebp),%eax
  80485c:	eb 0a                	jmp    804868 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80485e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804865:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804868:	c9                   	leave  
  804869:	c3                   	ret    

0080486a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80486a:	55                   	push   %ebp
  80486b:	89 e5                	mov    %esp,%ebp
  80486d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804870:	83 ec 04             	sub    $0x4,%esp
  804873:	68 08 60 80 00       	push   $0x806008
  804878:	68 58 02 00 00       	push   $0x258
  80487d:	68 11 5f 80 00       	push   $0x805f11
  804882:	e8 bf c9 ff ff       	call   801246 <_panic>

00804887 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804887:	55                   	push   %ebp
  804888:	89 e5                	mov    %esp,%ebp
  80488a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80488d:	83 ec 04             	sub    $0x4,%esp
  804890:	68 30 60 80 00       	push   $0x806030
  804895:	68 61 02 00 00       	push   $0x261
  80489a:	68 11 5f 80 00       	push   $0x805f11
  80489f:	e8 a2 c9 ff ff       	call   801246 <_panic>

008048a4 <__udivdi3>:
  8048a4:	55                   	push   %ebp
  8048a5:	57                   	push   %edi
  8048a6:	56                   	push   %esi
  8048a7:	53                   	push   %ebx
  8048a8:	83 ec 1c             	sub    $0x1c,%esp
  8048ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8048af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8048b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8048bb:	89 ca                	mov    %ecx,%edx
  8048bd:	89 f8                	mov    %edi,%eax
  8048bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8048c3:	85 f6                	test   %esi,%esi
  8048c5:	75 2d                	jne    8048f4 <__udivdi3+0x50>
  8048c7:	39 cf                	cmp    %ecx,%edi
  8048c9:	77 65                	ja     804930 <__udivdi3+0x8c>
  8048cb:	89 fd                	mov    %edi,%ebp
  8048cd:	85 ff                	test   %edi,%edi
  8048cf:	75 0b                	jne    8048dc <__udivdi3+0x38>
  8048d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8048d6:	31 d2                	xor    %edx,%edx
  8048d8:	f7 f7                	div    %edi
  8048da:	89 c5                	mov    %eax,%ebp
  8048dc:	31 d2                	xor    %edx,%edx
  8048de:	89 c8                	mov    %ecx,%eax
  8048e0:	f7 f5                	div    %ebp
  8048e2:	89 c1                	mov    %eax,%ecx
  8048e4:	89 d8                	mov    %ebx,%eax
  8048e6:	f7 f5                	div    %ebp
  8048e8:	89 cf                	mov    %ecx,%edi
  8048ea:	89 fa                	mov    %edi,%edx
  8048ec:	83 c4 1c             	add    $0x1c,%esp
  8048ef:	5b                   	pop    %ebx
  8048f0:	5e                   	pop    %esi
  8048f1:	5f                   	pop    %edi
  8048f2:	5d                   	pop    %ebp
  8048f3:	c3                   	ret    
  8048f4:	39 ce                	cmp    %ecx,%esi
  8048f6:	77 28                	ja     804920 <__udivdi3+0x7c>
  8048f8:	0f bd fe             	bsr    %esi,%edi
  8048fb:	83 f7 1f             	xor    $0x1f,%edi
  8048fe:	75 40                	jne    804940 <__udivdi3+0x9c>
  804900:	39 ce                	cmp    %ecx,%esi
  804902:	72 0a                	jb     80490e <__udivdi3+0x6a>
  804904:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804908:	0f 87 9e 00 00 00    	ja     8049ac <__udivdi3+0x108>
  80490e:	b8 01 00 00 00       	mov    $0x1,%eax
  804913:	89 fa                	mov    %edi,%edx
  804915:	83 c4 1c             	add    $0x1c,%esp
  804918:	5b                   	pop    %ebx
  804919:	5e                   	pop    %esi
  80491a:	5f                   	pop    %edi
  80491b:	5d                   	pop    %ebp
  80491c:	c3                   	ret    
  80491d:	8d 76 00             	lea    0x0(%esi),%esi
  804920:	31 ff                	xor    %edi,%edi
  804922:	31 c0                	xor    %eax,%eax
  804924:	89 fa                	mov    %edi,%edx
  804926:	83 c4 1c             	add    $0x1c,%esp
  804929:	5b                   	pop    %ebx
  80492a:	5e                   	pop    %esi
  80492b:	5f                   	pop    %edi
  80492c:	5d                   	pop    %ebp
  80492d:	c3                   	ret    
  80492e:	66 90                	xchg   %ax,%ax
  804930:	89 d8                	mov    %ebx,%eax
  804932:	f7 f7                	div    %edi
  804934:	31 ff                	xor    %edi,%edi
  804936:	89 fa                	mov    %edi,%edx
  804938:	83 c4 1c             	add    $0x1c,%esp
  80493b:	5b                   	pop    %ebx
  80493c:	5e                   	pop    %esi
  80493d:	5f                   	pop    %edi
  80493e:	5d                   	pop    %ebp
  80493f:	c3                   	ret    
  804940:	bd 20 00 00 00       	mov    $0x20,%ebp
  804945:	89 eb                	mov    %ebp,%ebx
  804947:	29 fb                	sub    %edi,%ebx
  804949:	89 f9                	mov    %edi,%ecx
  80494b:	d3 e6                	shl    %cl,%esi
  80494d:	89 c5                	mov    %eax,%ebp
  80494f:	88 d9                	mov    %bl,%cl
  804951:	d3 ed                	shr    %cl,%ebp
  804953:	89 e9                	mov    %ebp,%ecx
  804955:	09 f1                	or     %esi,%ecx
  804957:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80495b:	89 f9                	mov    %edi,%ecx
  80495d:	d3 e0                	shl    %cl,%eax
  80495f:	89 c5                	mov    %eax,%ebp
  804961:	89 d6                	mov    %edx,%esi
  804963:	88 d9                	mov    %bl,%cl
  804965:	d3 ee                	shr    %cl,%esi
  804967:	89 f9                	mov    %edi,%ecx
  804969:	d3 e2                	shl    %cl,%edx
  80496b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80496f:	88 d9                	mov    %bl,%cl
  804971:	d3 e8                	shr    %cl,%eax
  804973:	09 c2                	or     %eax,%edx
  804975:	89 d0                	mov    %edx,%eax
  804977:	89 f2                	mov    %esi,%edx
  804979:	f7 74 24 0c          	divl   0xc(%esp)
  80497d:	89 d6                	mov    %edx,%esi
  80497f:	89 c3                	mov    %eax,%ebx
  804981:	f7 e5                	mul    %ebp
  804983:	39 d6                	cmp    %edx,%esi
  804985:	72 19                	jb     8049a0 <__udivdi3+0xfc>
  804987:	74 0b                	je     804994 <__udivdi3+0xf0>
  804989:	89 d8                	mov    %ebx,%eax
  80498b:	31 ff                	xor    %edi,%edi
  80498d:	e9 58 ff ff ff       	jmp    8048ea <__udivdi3+0x46>
  804992:	66 90                	xchg   %ax,%ax
  804994:	8b 54 24 08          	mov    0x8(%esp),%edx
  804998:	89 f9                	mov    %edi,%ecx
  80499a:	d3 e2                	shl    %cl,%edx
  80499c:	39 c2                	cmp    %eax,%edx
  80499e:	73 e9                	jae    804989 <__udivdi3+0xe5>
  8049a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8049a3:	31 ff                	xor    %edi,%edi
  8049a5:	e9 40 ff ff ff       	jmp    8048ea <__udivdi3+0x46>
  8049aa:	66 90                	xchg   %ax,%ax
  8049ac:	31 c0                	xor    %eax,%eax
  8049ae:	e9 37 ff ff ff       	jmp    8048ea <__udivdi3+0x46>
  8049b3:	90                   	nop

008049b4 <__umoddi3>:
  8049b4:	55                   	push   %ebp
  8049b5:	57                   	push   %edi
  8049b6:	56                   	push   %esi
  8049b7:	53                   	push   %ebx
  8049b8:	83 ec 1c             	sub    $0x1c,%esp
  8049bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8049bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8049c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8049c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8049cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8049cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8049d3:	89 f3                	mov    %esi,%ebx
  8049d5:	89 fa                	mov    %edi,%edx
  8049d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8049db:	89 34 24             	mov    %esi,(%esp)
  8049de:	85 c0                	test   %eax,%eax
  8049e0:	75 1a                	jne    8049fc <__umoddi3+0x48>
  8049e2:	39 f7                	cmp    %esi,%edi
  8049e4:	0f 86 a2 00 00 00    	jbe    804a8c <__umoddi3+0xd8>
  8049ea:	89 c8                	mov    %ecx,%eax
  8049ec:	89 f2                	mov    %esi,%edx
  8049ee:	f7 f7                	div    %edi
  8049f0:	89 d0                	mov    %edx,%eax
  8049f2:	31 d2                	xor    %edx,%edx
  8049f4:	83 c4 1c             	add    $0x1c,%esp
  8049f7:	5b                   	pop    %ebx
  8049f8:	5e                   	pop    %esi
  8049f9:	5f                   	pop    %edi
  8049fa:	5d                   	pop    %ebp
  8049fb:	c3                   	ret    
  8049fc:	39 f0                	cmp    %esi,%eax
  8049fe:	0f 87 ac 00 00 00    	ja     804ab0 <__umoddi3+0xfc>
  804a04:	0f bd e8             	bsr    %eax,%ebp
  804a07:	83 f5 1f             	xor    $0x1f,%ebp
  804a0a:	0f 84 ac 00 00 00    	je     804abc <__umoddi3+0x108>
  804a10:	bf 20 00 00 00       	mov    $0x20,%edi
  804a15:	29 ef                	sub    %ebp,%edi
  804a17:	89 fe                	mov    %edi,%esi
  804a19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804a1d:	89 e9                	mov    %ebp,%ecx
  804a1f:	d3 e0                	shl    %cl,%eax
  804a21:	89 d7                	mov    %edx,%edi
  804a23:	89 f1                	mov    %esi,%ecx
  804a25:	d3 ef                	shr    %cl,%edi
  804a27:	09 c7                	or     %eax,%edi
  804a29:	89 e9                	mov    %ebp,%ecx
  804a2b:	d3 e2                	shl    %cl,%edx
  804a2d:	89 14 24             	mov    %edx,(%esp)
  804a30:	89 d8                	mov    %ebx,%eax
  804a32:	d3 e0                	shl    %cl,%eax
  804a34:	89 c2                	mov    %eax,%edx
  804a36:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a3a:	d3 e0                	shl    %cl,%eax
  804a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804a40:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a44:	89 f1                	mov    %esi,%ecx
  804a46:	d3 e8                	shr    %cl,%eax
  804a48:	09 d0                	or     %edx,%eax
  804a4a:	d3 eb                	shr    %cl,%ebx
  804a4c:	89 da                	mov    %ebx,%edx
  804a4e:	f7 f7                	div    %edi
  804a50:	89 d3                	mov    %edx,%ebx
  804a52:	f7 24 24             	mull   (%esp)
  804a55:	89 c6                	mov    %eax,%esi
  804a57:	89 d1                	mov    %edx,%ecx
  804a59:	39 d3                	cmp    %edx,%ebx
  804a5b:	0f 82 87 00 00 00    	jb     804ae8 <__umoddi3+0x134>
  804a61:	0f 84 91 00 00 00    	je     804af8 <__umoddi3+0x144>
  804a67:	8b 54 24 04          	mov    0x4(%esp),%edx
  804a6b:	29 f2                	sub    %esi,%edx
  804a6d:	19 cb                	sbb    %ecx,%ebx
  804a6f:	89 d8                	mov    %ebx,%eax
  804a71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804a75:	d3 e0                	shl    %cl,%eax
  804a77:	89 e9                	mov    %ebp,%ecx
  804a79:	d3 ea                	shr    %cl,%edx
  804a7b:	09 d0                	or     %edx,%eax
  804a7d:	89 e9                	mov    %ebp,%ecx
  804a7f:	d3 eb                	shr    %cl,%ebx
  804a81:	89 da                	mov    %ebx,%edx
  804a83:	83 c4 1c             	add    $0x1c,%esp
  804a86:	5b                   	pop    %ebx
  804a87:	5e                   	pop    %esi
  804a88:	5f                   	pop    %edi
  804a89:	5d                   	pop    %ebp
  804a8a:	c3                   	ret    
  804a8b:	90                   	nop
  804a8c:	89 fd                	mov    %edi,%ebp
  804a8e:	85 ff                	test   %edi,%edi
  804a90:	75 0b                	jne    804a9d <__umoddi3+0xe9>
  804a92:	b8 01 00 00 00       	mov    $0x1,%eax
  804a97:	31 d2                	xor    %edx,%edx
  804a99:	f7 f7                	div    %edi
  804a9b:	89 c5                	mov    %eax,%ebp
  804a9d:	89 f0                	mov    %esi,%eax
  804a9f:	31 d2                	xor    %edx,%edx
  804aa1:	f7 f5                	div    %ebp
  804aa3:	89 c8                	mov    %ecx,%eax
  804aa5:	f7 f5                	div    %ebp
  804aa7:	89 d0                	mov    %edx,%eax
  804aa9:	e9 44 ff ff ff       	jmp    8049f2 <__umoddi3+0x3e>
  804aae:	66 90                	xchg   %ax,%ax
  804ab0:	89 c8                	mov    %ecx,%eax
  804ab2:	89 f2                	mov    %esi,%edx
  804ab4:	83 c4 1c             	add    $0x1c,%esp
  804ab7:	5b                   	pop    %ebx
  804ab8:	5e                   	pop    %esi
  804ab9:	5f                   	pop    %edi
  804aba:	5d                   	pop    %ebp
  804abb:	c3                   	ret    
  804abc:	3b 04 24             	cmp    (%esp),%eax
  804abf:	72 06                	jb     804ac7 <__umoddi3+0x113>
  804ac1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804ac5:	77 0f                	ja     804ad6 <__umoddi3+0x122>
  804ac7:	89 f2                	mov    %esi,%edx
  804ac9:	29 f9                	sub    %edi,%ecx
  804acb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804acf:	89 14 24             	mov    %edx,(%esp)
  804ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804ad6:	8b 44 24 04          	mov    0x4(%esp),%eax
  804ada:	8b 14 24             	mov    (%esp),%edx
  804add:	83 c4 1c             	add    $0x1c,%esp
  804ae0:	5b                   	pop    %ebx
  804ae1:	5e                   	pop    %esi
  804ae2:	5f                   	pop    %edi
  804ae3:	5d                   	pop    %ebp
  804ae4:	c3                   	ret    
  804ae5:	8d 76 00             	lea    0x0(%esi),%esi
  804ae8:	2b 04 24             	sub    (%esp),%eax
  804aeb:	19 fa                	sbb    %edi,%edx
  804aed:	89 d1                	mov    %edx,%ecx
  804aef:	89 c6                	mov    %eax,%esi
  804af1:	e9 71 ff ff ff       	jmp    804a67 <__umoddi3+0xb3>
  804af6:	66 90                	xchg   %ax,%ax
  804af8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804afc:	72 ea                	jb     804ae8 <__umoddi3+0x134>
  804afe:	89 d9                	mov    %ebx,%ecx
  804b00:	e9 62 ff ff ff       	jmp    804a67 <__umoddi3+0xb3>
