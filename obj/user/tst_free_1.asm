
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 7e 16 00 00       	call   8016b4 <libmain>
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
  80005e:	81 ec b0 01 00 00    	sub    $0x1b0,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  800081:	68 60 51 80 00       	push   $0x805160
  800086:	6a 1e                	push   $0x1e
  800088:	68 7c 51 80 00       	push   $0x80517c
  80008d:	e8 61 17 00 00       	call   8017f3 <_panic>
	}
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800092:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int eval = 0;
  800099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	bool found;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 b0 2d 00 00       	call   802e8c <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 90 51 80 00       	push   $0x805190
  8000e7:	e8 c4 19 00 00       	call   801ab0 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 84 2d 00 00       	call   802e8c <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 c7 2d 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 3c 27 00 00       	call   802860 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 ec 51 80 00       	push   $0x8051ec
  800147:	e8 64 19 00 00       	call   801ab0 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 2e 2d 00 00       	call   802e8c <sys_calculate_free_frames>
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
  800195:	68 20 52 80 00       	push   $0x805220
  80019a:	e8 11 19 00 00       	call   801ab0 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 30 2d 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 90 52 80 00       	push   $0x805290
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 c4 2c 00 00       	call   802e8c <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
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
  8001ff:	e8 88 2c 00 00       	call   802e8c <sys_calculate_free_frames>
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
  800237:	68 c4 52 80 00       	push   $0x8052c4
  80023c:	e8 6f 18 00 00       	call   801ab0 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 64 30 00 00       	call   8032e7 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 44 53 80 00       	push   $0x805344
  80029e:	e8 0d 18 00 00       	call   801ab0 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 e1 2b 00 00       	call   802e8c <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 24 2c 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8002b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	e8 99 25 00 00       	call   802860 <malloc>
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002d0:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8002d6:	89 c2                	mov    %eax,%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	01 c0                	add    %eax,%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	01 c8                	add    %ecx,%eax
  8002e4:	39 c2                	cmp    %eax,%edx
  8002e6:	74 17                	je     8002ff <_main+0x2a6>
  8002e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 68 53 80 00       	push   $0x805368
  8002f7:	e8 b4 17 00 00       	call   801ab0 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 7e 2b 00 00       	call   802e8c <sys_calculate_free_frames>
  80030e:	29 c3                	sub    %eax,%ebx
  800310:	89 d8                	mov    %ebx,%eax
  800312:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800315:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800318:	83 c0 02             	add    $0x2,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	50                   	push   %eax
  80031f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800322:	ff 75 c0             	pushl  -0x40(%ebp)
  800325:	e8 0e fd ff ff       	call   800038 <inRange>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	75 21                	jne    800352 <_main+0x2f9>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80033b:	83 c0 02             	add    $0x2,%eax
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	50                   	push   %eax
  800342:	ff 75 c4             	pushl  -0x3c(%ebp)
  800345:	68 9c 53 80 00       	push   $0x80539c
  80034a:	e8 61 17 00 00       	call   801ab0 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 80 2b 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 0c 54 80 00       	push   $0x80540c
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 14 2b 00 00       	call   802e8c <sys_calculate_free_frames>
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80037b:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800381:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800387:	01 c0                	add    %eax,%eax
  800389:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80038c:	d1 e8                	shr    %eax
  80038e:	48                   	dec    %eax
  80038f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  800392:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  80039b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039e:	01 c0                	add    %eax,%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a5:	01 c2                	add    %eax,%edx
  8003a7:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003ab:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003ae:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003b5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003b8:	e8 cf 2a 00 00       	call   802e8c <sys_calculate_free_frames>
  8003bd:	29 c3                	sub    %eax,%ebx
  8003bf:	89 d8                	mov    %ebx,%eax
  8003c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c7:	83 c0 02             	add    $0x2,%eax
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <inRange>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	75 1d                	jne    8003fd <_main+0x3a4>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	ff 75 c0             	pushl  -0x40(%ebp)
  8003ed:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f0:	68 40 54 80 00       	push   $0x805440
  8003f5:	e8 b6 16 00 00       	call   801ab0 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8003fd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800400:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800403:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040b:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
  800411:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800414:	01 c0                	add    %eax,%eax
  800416:	89 c2                	mov    %eax,%edx
  800418:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800420:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800428:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80042e:	6a 02                	push   $0x2
  800430:	6a 00                	push   $0x0
  800432:	6a 02                	push   $0x2
  800434:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  80043a:	50                   	push   %eax
  80043b:	e8 a7 2e 00 00       	call   8032e7 <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 c0 54 80 00       	push   $0x8054c0
  80045b:	e8 50 16 00 00       	call   801ab0 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 6f 2a 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800468:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80046b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	01 d2                	add    %edx,%edx
  800472:	01 d0                	add    %edx,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	50                   	push   %eax
  800478:	e8 e3 23 00 00       	call   802860 <malloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  800486:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800491:	c1 e0 02             	shl    $0x2,%eax
  800494:	89 c1                	mov    %eax,%ecx
  800496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800499:	01 c8                	add    %ecx,%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 17                	je     8004b6 <_main+0x45d>
  80049f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 e4 54 80 00       	push   $0x8054e4
  8004ae:	e8 fd 15 00 00       	call   801ab0 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 c7 29 00 00       	call   802e8c <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004cf:	83 c0 02             	add    $0x2,%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004d9:	ff 75 c0             	pushl  -0x40(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <inRange>
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	75 21                	jne    800509 <_main+0x4b0>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f2:	83 c0 02             	add    $0x2,%eax
  8004f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fc:	68 18 55 80 00       	push   $0x805518
  800501:	e8 aa 15 00 00       	call   801ab0 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 c9 29 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 88 55 80 00       	push   $0x805588
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 5d 29 00 00       	call   802e8c <sys_calculate_free_frames>
  80052f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800532:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  800538:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80053b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	c1 e8 02             	shr    $0x2,%eax
  800543:	48                   	dec    %eax
  800544:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800547:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80054f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 45 98             	mov    -0x68(%ebp),%eax
  80055c:	01 c2                	add    %eax,%edx
  80055e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800561:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800563:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80056a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80056d:	e8 1a 29 00 00       	call   802e8c <sys_calculate_free_frames>
  800572:	29 c3                	sub    %eax,%ebx
  800574:	89 d8                	mov    %ebx,%eax
  800576:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800579:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80057c:	83 c0 02             	add    $0x2,%eax
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	50                   	push   %eax
  800583:	ff 75 c4             	pushl  -0x3c(%ebp)
  800586:	ff 75 c0             	pushl  -0x40(%ebp)
  800589:	e8 aa fa ff ff       	call   800038 <inRange>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	85 c0                	test   %eax,%eax
  800593:	75 1d                	jne    8005b2 <_main+0x559>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a2:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a5:	68 bc 55 80 00       	push   $0x8055bc
  8005aa:	e8 01 15 00 00       	call   801ab0 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005b2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b5:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005b8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
  8005c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005d8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e0:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8005e6:	6a 02                	push   $0x2
  8005e8:	6a 00                	push   $0x0
  8005ea:	6a 02                	push   $0x2
  8005ec:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  8005f2:	50                   	push   %eax
  8005f3:	e8 ef 2c 00 00       	call   8032e7 <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 3c 56 80 00       	push   $0x80563c
  800613:	e8 98 14 00 00       	call   801ab0 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 b7 28 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800620:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	01 d2                	add    %edx,%edx
  80062a:	01 d0                	add    %edx,%eax
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	50                   	push   %eax
  800630:	e8 2b 22 00 00       	call   802860 <malloc>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  80063e:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800644:	89 c2                	mov    %eax,%edx
  800646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800649:	c1 e0 02             	shl    $0x2,%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800651:	c1 e0 02             	shl    $0x2,%eax
  800654:	01 c1                	add    %eax,%ecx
  800656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	74 17                	je     800676 <_main+0x61d>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 60 56 80 00       	push   $0x805660
  80066e:	e8 3d 14 00 00       	call   801ab0 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 5c 28 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 94 56 80 00       	push   $0x805694
  80068f:	e8 1c 14 00 00       	call   801ab0 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 f0 27 00 00       	call   802e8c <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 33 28 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006aa:	89 d0                	mov    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d0                	add    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	50                   	push   %eax
  8006b8:	e8 a3 21 00 00       	call   802860 <malloc>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006c6:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8006cc:	89 c2                	mov    %eax,%edx
  8006ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d9:	c1 e0 03             	shl    $0x3,%eax
  8006dc:	01 c1                	add    %eax,%ecx
  8006de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e1:	01 c8                	add    %ecx,%eax
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	74 17                	je     8006fe <_main+0x6a5>
  8006e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 c8 56 80 00       	push   $0x8056c8
  8006f6:	e8 b5 13 00 00       	call   801ab0 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 7f 27 00 00       	call   802e8c <sys_calculate_free_frames>
  80070d:	29 c3                	sub    %eax,%ebx
  80070f:	89 d8                	mov    %ebx,%eax
  800711:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800714:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800717:	83 c0 02             	add    $0x2,%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800721:	ff 75 c0             	pushl  -0x40(%ebp)
  800724:	e8 0f f9 ff ff       	call   800038 <inRange>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	85 c0                	test   %eax,%eax
  80072e:	75 21                	jne    800751 <_main+0x6f8>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800737:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80073a:	83 c0 02             	add    $0x2,%eax
  80073d:	ff 75 c0             	pushl  -0x40(%ebp)
  800740:	50                   	push   %eax
  800741:	ff 75 c4             	pushl  -0x3c(%ebp)
  800744:	68 fc 56 80 00       	push   $0x8056fc
  800749:	e8 62 13 00 00       	call   801ab0 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 81 27 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 6c 57 80 00       	push   $0x80576c
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 15 27 00 00       	call   802e8c <sys_calculate_free_frames>
  800777:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80077a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800780:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800786:	89 d0                	mov    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	01 c0                	add    %eax,%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	c1 e8 03             	shr    $0x3,%eax
  800793:	48                   	dec    %eax
  800794:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800797:	8b 45 88             	mov    -0x78(%ebp),%eax
  80079a:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  80079d:	88 10                	mov    %dl,(%eax)
  80079f:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a5:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007b2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007c4:	88 02                	mov    %al,(%edx)
  8007c6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007d3:	01 c2                	add    %eax,%edx
  8007d5:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8007d9:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ea:	01 c2                	add    %eax,%edx
  8007ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ef:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  8007f2:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8007f9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8007fc:	e8 8b 26 00 00       	call   802e8c <sys_calculate_free_frames>
  800801:	29 c3                	sub    %eax,%ebx
  800803:	89 d8                	mov    %ebx,%eax
  800805:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800808:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80080b:	83 c0 02             	add    $0x2,%eax
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	50                   	push   %eax
  800812:	ff 75 c4             	pushl  -0x3c(%ebp)
  800815:	ff 75 c0             	pushl  -0x40(%ebp)
  800818:	e8 1b f8 ff ff       	call   800038 <inRange>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	75 1d                	jne    800841 <_main+0x7e8>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800824:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	ff 75 c0             	pushl  -0x40(%ebp)
  800831:	ff 75 c4             	pushl  -0x3c(%ebp)
  800834:	68 a0 57 80 00       	push   $0x8057a0
  800839:	e8 72 12 00 00       	call   801ab0 <cprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800841:	8b 45 88             	mov    -0x78(%ebp),%eax
  800844:	89 45 80             	mov    %eax,-0x80(%ebp)
  800847:	8b 45 80             	mov    -0x80(%ebp),%eax
  80084a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084f:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800855:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800858:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80085f:	8b 45 88             	mov    -0x78(%ebp),%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80087b:	6a 02                	push   $0x2
  80087d:	6a 00                	push   $0x0
  80087f:	6a 02                	push   $0x2
  800881:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 5a 2a 00 00       	call   8032e7 <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 20 58 80 00       	push   $0x805820
  8008a8:	e8 03 12 00 00       	call   801ab0 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 d7 25 00 00       	call   802e8c <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 1a 26 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 8b 1f 00 00       	call   802860 <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  8008de:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e9:	c1 e0 02             	shl    $0x2,%eax
  8008ec:	89 c1                	mov    %eax,%ecx
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	c1 e0 04             	shl    $0x4,%eax
  8008f4:	01 c1                	add    %eax,%ecx
  8008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f9:	01 c8                	add    %ecx,%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 17                	je     800916 <_main+0x8bd>
  8008ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	68 44 58 80 00       	push   $0x805844
  80090e:	e8 9d 11 00 00       	call   801ab0 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 67 25 00 00       	call   802e8c <sys_calculate_free_frames>
  800925:	29 c3                	sub    %eax,%ebx
  800927:	89 d8                	mov    %ebx,%eax
  800929:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80092c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80092f:	83 c0 02             	add    $0x2,%eax
  800932:	83 ec 04             	sub    $0x4,%esp
  800935:	50                   	push   %eax
  800936:	ff 75 c4             	pushl  -0x3c(%ebp)
  800939:	ff 75 c0             	pushl  -0x40(%ebp)
  80093c:	e8 f7 f6 ff ff       	call   800038 <inRange>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 21                	jne    800969 <_main+0x910>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800952:	83 c0 02             	add    $0x2,%eax
  800955:	ff 75 c0             	pushl  -0x40(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 c4             	pushl  -0x3c(%ebp)
  80095c:	68 78 58 80 00       	push   $0x805878
  800961:	e8 4a 11 00 00       	call   801ab0 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 69 25 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 e8 58 80 00       	push   $0x8058e8
  800982:	e8 29 11 00 00       	call   801ab0 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 fd 24 00 00       	call   802e8c <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 40 25 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800997:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80099a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	01 c0                	add    %eax,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	50                   	push   %eax
  8009ac:	e8 af 1e 00 00       	call   802860 <malloc>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  8009ba:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	01 c0                	add    %eax,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009d4:	c1 e0 04             	shl    $0x4,%eax
  8009d7:	01 c2                	add    %eax,%edx
  8009d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	39 c1                	cmp    %eax,%ecx
  8009e0:	74 17                	je     8009f9 <_main+0x9a0>
  8009e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	68 1c 59 80 00       	push   $0x80591c
  8009f1:	e8 ba 10 00 00       	call   801ab0 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 84 24 00 00       	call   802e8c <sys_calculate_free_frames>
  800a08:	29 c3                	sub    %eax,%ebx
  800a0a:	89 d8                	mov    %ebx,%eax
  800a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a12:	83 c0 02             	add    $0x2,%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	50                   	push   %eax
  800a19:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a1c:	ff 75 c0             	pushl  -0x40(%ebp)
  800a1f:	e8 14 f6 ff ff       	call   800038 <inRange>
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 21                	jne    800a4c <_main+0x9f3>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a35:	83 c0 02             	add    $0x2,%eax
  800a38:	ff 75 c0             	pushl  -0x40(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3f:	68 50 59 80 00       	push   $0x805950
  800a44:	e8 67 10 00 00       	call   801ab0 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 86 24 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 c0 59 80 00       	push   $0x8059c0
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 1a 24 00 00       	call   802e8c <sys_calculate_free_frames>
  800a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	01 c0                	add    %eax,%eax
  800a7c:	01 d0                	add    %edx,%eax
  800a7e:	01 c0                	add    %eax,%eax
  800a80:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800a83:	48                   	dec    %eax
  800a84:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800a8a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800a90:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800a96:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a9c:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800a9f:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800aa1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	c1 ea 1f             	shr    $0x1f,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	d1 f8                	sar    %eax
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ab8:	01 c2                	add    %eax,%edx
  800aba:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800abd:	88 c1                	mov    %al,%cl
  800abf:	c0 e9 07             	shr    $0x7,%cl
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	d0 f8                	sar    %al
  800ac6:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800ac8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800ace:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ad4:	01 c2                	add    %eax,%edx
  800ad6:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800ad9:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800adb:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800ae2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ae5:	e8 a2 23 00 00       	call   802e8c <sys_calculate_free_frames>
  800aea:	29 c3                	sub    %eax,%ebx
  800aec:	89 d8                	mov    %ebx,%eax
  800aee:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800af1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800af4:	83 c0 02             	add    $0x2,%eax
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800afe:	ff 75 c0             	pushl  -0x40(%ebp)
  800b01:	e8 32 f5 ff ff       	call   800038 <inRange>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	75 1d                	jne    800b2a <_main+0xad1>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	ff 75 c0             	pushl  -0x40(%ebp)
  800b1a:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b1d:	68 f4 59 80 00       	push   $0x8059f4
  800b22:	e8 89 0f 00 00       	call   801ab0 <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b2a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b30:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b36:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b41:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800b47:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	c1 ea 1f             	shr    $0x1f,%edx
  800b52:	01 d0                	add    %edx,%eax
  800b54:	d1 f8                	sar    %eax
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800b66:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b71:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800b77:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b7d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800b8b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800b9c:	6a 02                	push   $0x2
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 03                	push   $0x3
  800ba2:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 39 27 00 00       	call   8032e7 <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 74 5a 80 00       	push   $0x805a74
  800bc9:	e8 e2 0e 00 00       	call   801ab0 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 b6 22 00 00       	call   802e8c <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 f9 22 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	01 c0                	add    %eax,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	01 d0                	add    %edx,%eax
  800bee:	01 c0                	add    %eax,%eax
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	50                   	push   %eax
  800bf4:	e8 67 1c 00 00       	call   802860 <malloc>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c02:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800c08:	89 c1                	mov    %eax,%ecx
  800c0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c0d:	89 d0                	mov    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	01 d0                	add    %edx,%eax
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1d:	c1 e0 04             	shl    $0x4,%eax
  800c20:	01 c2                	add    %eax,%edx
  800c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
  800c27:	39 c1                	cmp    %eax,%ecx
  800c29:	74 17                	je     800c42 <_main+0xbe9>
  800c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	68 98 5a 80 00       	push   $0x805a98
  800c3a:	e8 71 0e 00 00       	call   801ab0 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 3b 22 00 00       	call   802e8c <sys_calculate_free_frames>
  800c51:	29 c3                	sub    %eax,%ebx
  800c53:	89 d8                	mov    %ebx,%eax
  800c55:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c5b:	83 c0 02             	add    $0x2,%eax
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	50                   	push   %eax
  800c62:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c65:	ff 75 c0             	pushl  -0x40(%ebp)
  800c68:	e8 cb f3 ff ff       	call   800038 <inRange>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	75 21                	jne    800c95 <_main+0xc3c>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c7e:	83 c0 02             	add    $0x2,%eax
  800c81:	ff 75 c0             	pushl  -0x40(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c88:	68 cc 5a 80 00       	push   $0x805acc
  800c8d:	e8 1e 0e 00 00       	call   801ab0 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 3d 22 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 3c 5b 80 00       	push   $0x805b3c
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 d1 21 00 00       	call   802e8c <sys_calculate_free_frames>
  800cbb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800cbe:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800cc4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ccd:	89 d0                	mov    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	01 d0                	add    %edx,%eax
  800cd7:	01 c0                	add    %eax,%eax
  800cd9:	d1 e8                	shr    %eax
  800cdb:	48                   	dec    %eax
  800cdc:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800ce2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ceb:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800cee:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800cf4:	89 c2                	mov    %eax,%edx
  800cf6:	c1 ea 1f             	shr    $0x1f,%edx
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	d1 f8                	sar    %eax
  800cfd:	01 c0                	add    %eax,%eax
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d0a:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	66 c1 ea 0f          	shr    $0xf,%dx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	66 d1 f8             	sar    %ax
  800d19:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d22:	01 c0                	add    %eax,%eax
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d2c:	01 c2                	add    %eax,%edx
  800d2e:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d32:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d35:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800d3c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800d3f:	e8 48 21 00 00       	call   802e8c <sys_calculate_free_frames>
  800d44:	29 c3                	sub    %eax,%ebx
  800d46:	89 d8                	mov    %ebx,%eax
  800d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d4e:	83 c0 02             	add    $0x2,%eax
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	50                   	push   %eax
  800d55:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d58:	ff 75 c0             	pushl  -0x40(%ebp)
  800d5b:	e8 d8 f2 ff ff       	call   800038 <inRange>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 1d                	jne    800d84 <_main+0xd2b>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	ff 75 c0             	pushl  -0x40(%ebp)
  800d74:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d77:	68 70 5b 80 00       	push   $0x805b70
  800d7c:	e8 2f 0d 00 00       	call   801ab0 <cprintf>
  800d81:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800d84:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d8a:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800d90:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9b:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  800da1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800da7:	89 c2                	mov    %eax,%edx
  800da9:	c1 ea 1f             	shr    $0x1f,%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	d1 f8                	sar    %eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
  800dbc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800dc2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcd:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800dd3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800dd9:	01 c0                	add    %eax,%eax
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800deb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800df1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800df6:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800dfc:	6a 02                	push   $0x2
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 03                	push   $0x3
  800e02:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 d9 24 00 00       	call   8032e7 <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 f0 5b 80 00       	push   $0x805bf0
  800e29:	e8 82 0c 00 00       	call   801ab0 <cprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e34:	89 d0                	mov    %edx,%eax
  800e36:	01 c0                	add    %eax,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	c1 e0 02             	shl    $0x2,%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e44:	c1 e0 05             	shl    $0x5,%eax
  800e47:	01 c2                	add    %eax,%edx
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)


	is_correct = 1;
  800e54:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//FREE ALL
	cprintf("\n%~[2] Free all the allocated spaces from PAGE ALLOCATOR \[70%]\n");
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	68 14 5c 80 00       	push   $0x805c14
  800e63:	e8 48 0c 00 00       	call   801ab0 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 1c 20 00 00       	call   802e8c <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 5f 20 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 45 20 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 54 5c 80 00       	push   $0x805c54
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 d9 1f 00 00       	call   802e8c <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 94 5c 80 00       	push   $0x805c94
  800ed0:	e8 db 0b 00 00       	call   801ab0 <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800edb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800ee1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eec:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
  800ef2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800f00:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0b:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800f11:	6a 03                	push   $0x3
  800f13:	6a 00                	push   $0x0
  800f15:	6a 02                	push   $0x2
  800f17:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 c4 23 00 00       	call   8032e7 <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 e4 5c 80 00       	push   $0x805ce4
  800f44:	e8 67 0b 00 00       	call   801ab0 <cprintf>
  800f49:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f50:	74 04                	je     800f56 <_main+0xefd>
		{
			eval += 10;
  800f52:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800f56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f5d:	e8 2a 1f 00 00       	call   802e8c <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 6d 1f 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 53 1f 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 0c 5d 80 00       	push   $0x805d0c
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 e7 1e 00 00       	call   802e8c <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 4c 5d 80 00       	push   $0x805d4c
  800fc2:	e8 e9 0a 00 00       	call   801ab0 <cprintf>
  800fc7:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800fca:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fcd:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800fd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fde:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800fe4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800fe7:	01 c0                	add    %eax,%eax
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ff6:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ffc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801001:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  801007:	6a 03                	push   $0x3
  801009:	6a 00                	push   $0x0
  80100b:	6a 02                	push   $0x2
  80100d:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  801013:	50                   	push   %eax
  801014:	e8 ce 22 00 00       	call   8032e7 <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 9c 5d 80 00       	push   $0x805d9c
  80103a:	e8 71 0a 00 00       	call   801ab0 <cprintf>
  80103f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801046:	74 04                	je     80104c <_main+0xff3>
		{
			eval += 10;
  801048:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80104c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801053:	e8 34 1e 00 00       	call   802e8c <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 77 1e 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 5d 1e 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 c4 5d 80 00       	push   $0x805dc4
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 f1 1d 00 00       	call   802e8c <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 04 5e 80 00       	push   $0x805e04
  8010b8:	e8 f3 09 00 00       	call   801ab0 <cprintf>
  8010bd:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  8010c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010c6:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8010cc:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8010d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
  8010dd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 1f             	shr    $0x1f,%edx
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	d1 f8                	sar    %eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  8010fc:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  801102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801107:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  80110d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801113:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  801121:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112c:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801132:	6a 03                	push   $0x3
  801134:	6a 00                	push   $0x0
  801136:	6a 03                	push   $0x3
  801138:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	e8 a3 21 00 00       	call   8032e7 <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 54 5e 80 00       	push   $0x805e54
  801165:	e8 46 09 00 00       	call   801ab0 <cprintf>
  80116a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  80116d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801171:	74 04                	je     801177 <_main+0x111e>
		{
			eval += 10;
  801173:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801177:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80117e:	e8 09 1d 00 00       	call   802e8c <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 4c 1d 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 32 1d 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 7c 5e 80 00       	push   $0x805e7c
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 c6 1c 00 00       	call   802e8c <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 bc 5e 80 00       	push   $0x805ebc
  8011e3:	e8 c8 08 00 00       	call   801ab0 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8011eb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8011ee:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  8011f4:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ff:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
  801205:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801208:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80120f:	8b 45 88             	mov    -0x78(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80121a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801225:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80122b:	6a 03                	push   $0x3
  80122d:	6a 00                	push   $0x0
  80122f:	6a 02                	push   $0x2
  801231:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	e8 aa 20 00 00       	call   8032e7 <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 0c 5f 80 00       	push   $0x805f0c
  80125e:	e8 4d 08 00 00       	call   801ab0 <cprintf>
  801263:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 04                	je     801270 <_main+0x1217>
		{
			eval += 10;
  80126c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801270:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801277:	e8 10 1c 00 00       	call   802e8c <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 53 1c 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 39 1c 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 34 5f 80 00       	push   $0x805f34
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 cd 1b 00 00       	call   802e8c <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 74 5f 80 00       	push   $0x805f74
  8012d7:	e8 d4 07 00 00       	call   801ab0 <cprintf>
  8012dc:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8012df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e3:	74 04                	je     8012e9 <_main+0x1290>
		{
			eval += 5;
  8012e5:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  8012e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8012f0:	e8 97 1b 00 00       	call   802e8c <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 da 1b 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 c0 1b 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 b8 5f 80 00       	push   $0x805fb8
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 54 1b 00 00       	call   802e8c <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 f8 5f 80 00       	push   $0x805ff8
  801355:	e8 56 07 00 00       	call   801ab0 <cprintf>
  80135a:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80135d:	8b 45 98             	mov    -0x68(%ebp),%eax
  801360:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801366:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80136c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801371:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801377:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80137a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801381:	8b 45 98             	mov    -0x68(%ebp),%eax
  801384:	01 d0                	add    %edx,%eax
  801386:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80138c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801397:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80139d:	6a 03                	push   $0x3
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 02                	push   $0x2
  8013a3:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	e8 38 1f 00 00       	call   8032e7 <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 48 60 80 00       	push   $0x806048
  8013d0:	e8 db 06 00 00       	call   801ab0 <cprintf>
  8013d5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8013d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013dc:	74 04                	je     8013e2 <_main+0x1389>
		{
			eval += 10;
  8013de:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8013e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8013e9:	e8 9e 1a 00 00       	call   802e8c <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 e1 1a 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 c7 1a 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 70 60 80 00       	push   $0x806070
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 5b 1a 00 00       	call   802e8c <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 b0 60 80 00       	push   $0x8060b0
  801449:	e8 62 06 00 00       	call   801ab0 <cprintf>
  80144e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 04                	je     80145b <_main+0x1402>
		{
			eval += 5;
  801457:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  80145b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801462:	e8 25 1a 00 00       	call   802e8c <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 68 1a 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 4e 1a 00 00       	call   802ed7 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 00 61 80 00       	push   $0x806100
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 e2 19 00 00       	call   802e8c <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 40 61 80 00       	push   $0x806140
  8014c7:	e8 e4 05 00 00       	call   801ab0 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  8014cf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8014d5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8014db:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  8014ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c1 ea 1f             	shr    $0x1f,%edx
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	d1 f8                	sar    %eax
  8014fb:	01 c0                	add    %eax,%eax
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  80150d:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
  80151e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801524:	01 c0                	add    %eax,%eax
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801536:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80153c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801541:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801547:	6a 03                	push   $0x3
  801549:	6a 00                	push   $0x0
  80154b:	6a 03                	push   $0x3
  80154d:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 8e 1d 00 00       	call   8032e7 <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 90 61 80 00       	push   $0x806190
  80157a:	e8 31 05 00 00       	call   801ab0 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801586:	74 04                	je     80158c <_main+0x1533>
		{
			eval += 10;
  801588:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80158c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  801593:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	cprintf("\n%~[3] Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	68 b8 61 80 00       	push   $0x8061b8
  8015a2:	e8 09 05 00 00       	call   801ab0 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 84 1b 00 00       	call   803133 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8015af:	a1 20 70 80 00       	mov    0x807020,%eax
  8015b4:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8015ba:	a1 20 70 80 00       	mov    0x807020,%eax
  8015bf:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	a1 20 70 80 00       	mov    0x807020,%eax
  8015cc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8015d2:	52                   	push   %edx
  8015d3:	51                   	push   %ecx
  8015d4:	50                   	push   %eax
  8015d5:	68 26 62 80 00       	push   $0x806226
  8015da:	e8 08 1a 00 00       	call   802fe7 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 0f 1a 00 00       	call   803005 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 ae 1b 00 00       	call   8031ad <gettst>
  8015ff:	83 f8 01             	cmp    $0x1,%eax
  801602:	75 f6                	jne    8015fa <_main+0x15a1>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801604:	a1 20 70 80 00       	mov    0x807020,%eax
  801609:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80160f:	a1 20 70 80 00       	mov    0x807020,%eax
  801614:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	a1 20 70 80 00       	mov    0x807020,%eax
  801621:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801627:	52                   	push   %edx
  801628:	51                   	push   %ecx
  801629:	50                   	push   %eax
  80162a:	68 31 62 80 00       	push   $0x806231
  80162f:	e8 b3 19 00 00       	call   802fe7 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 ba 19 00 00       	call   803005 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 59 1b 00 00       	call   8031ad <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 35 1b 00 00       	call   803193 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 c3 37 00 00       	call   804e2e <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 3a 1b 00 00       	call   8031ad <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 3c 62 80 00       	push   $0x80623c
  801687:	e8 24 04 00 00       	call   801ab0 <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80168f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801693:	74 04                	je     801699 <_main+0x1640>
	{
		eval += 30;
  801695:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 f4             	pushl  -0xc(%ebp)
  80169f:	68 cc 62 80 00       	push   $0x8062cc
  8016a4:	e8 07 04 00 00       	call   801ab0 <cprintf>
  8016a9:	83 c4 10             	add    $0x10,%esp

	return;
  8016ac:	90                   	nop
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5f                   	pop    %edi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8016ba:	e8 96 19 00 00       	call   803055 <sys_getenvindex>
  8016bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	89 d0                	mov    %edx,%eax
  8016c7:	c1 e0 03             	shl    $0x3,%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8016d3:	01 c8                	add    %ecx,%eax
  8016d5:	01 c0                	add    %eax,%eax
  8016d7:	01 d0                	add    %edx,%eax
  8016d9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8016e0:	01 c8                	add    %ecx,%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e9:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8016ee:	a1 20 70 80 00       	mov    0x807020,%eax
  8016f3:	8a 40 20             	mov    0x20(%eax),%al
  8016f6:	84 c0                	test   %al,%al
  8016f8:	74 0d                	je     801707 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8016fa:	a1 20 70 80 00       	mov    0x807020,%eax
  8016ff:	83 c0 20             	add    $0x20,%eax
  801702:	a3 00 70 80 00       	mov    %eax,0x807000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801707:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80170b:	7e 0a                	jle    801717 <libmain+0x63>
		binaryname = argv[0];
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	_main(argc, argv);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 34 e9 ff ff       	call   800059 <_main>
  801725:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  801728:	e8 ac 16 00 00       	call   802dd9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	68 20 63 80 00       	push   $0x806320
  801735:	e8 76 03 00 00       	call   801ab0 <cprintf>
  80173a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80173d:	a1 20 70 80 00       	mov    0x807020,%eax
  801742:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  801748:	a1 20 70 80 00       	mov    0x807020,%eax
  80174d:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	52                   	push   %edx
  801757:	50                   	push   %eax
  801758:	68 48 63 80 00       	push   $0x806348
  80175d:	e8 4e 03 00 00       	call   801ab0 <cprintf>
  801762:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801765:	a1 20 70 80 00       	mov    0x807020,%eax
  80176a:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  801770:	a1 20 70 80 00       	mov    0x807020,%eax
  801775:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80177b:	a1 20 70 80 00       	mov    0x807020,%eax
  801780:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801786:	51                   	push   %ecx
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	68 70 63 80 00       	push   $0x806370
  80178e:	e8 1d 03 00 00       	call   801ab0 <cprintf>
  801793:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801796:	a1 20 70 80 00       	mov    0x807020,%eax
  80179b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 c8 63 80 00       	push   $0x8063c8
  8017aa:	e8 01 03 00 00       	call   801ab0 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 20 63 80 00       	push   $0x806320
  8017ba:	e8 f1 02 00 00       	call   801ab0 <cprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017c2:	e8 2c 16 00 00       	call   802df3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8017c7:	e8 19 00 00 00       	call   8017e5 <exit>
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	6a 00                	push   $0x0
  8017da:	e8 42 18 00 00       	call   803021 <sys_destroy_env>
  8017df:	83 c4 10             	add    $0x10,%esp
}
  8017e2:	90                   	nop
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <exit>:

void
exit(void)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8017eb:	e8 97 18 00 00       	call   803087 <sys_exit_env>
}
  8017f0:	90                   	nop
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8017fc:	83 c0 04             	add    $0x4,%eax
  8017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801802:	a1 4c 70 80 00       	mov    0x80704c,%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	74 16                	je     801821 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80180b:	a1 4c 70 80 00       	mov    0x80704c,%eax
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	50                   	push   %eax
  801814:	68 dc 63 80 00       	push   $0x8063dc
  801819:	e8 92 02 00 00       	call   801ab0 <cprintf>
  80181e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801821:	a1 00 70 80 00       	mov    0x807000,%eax
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	68 e1 63 80 00       	push   $0x8063e1
  801832:	e8 79 02 00 00       	call   801ab0 <cprintf>
  801837:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80183a:	8b 45 10             	mov    0x10(%ebp),%eax
  80183d:	83 ec 08             	sub    $0x8,%esp
  801840:	ff 75 f4             	pushl  -0xc(%ebp)
  801843:	50                   	push   %eax
  801844:	e8 fc 01 00 00       	call   801a45 <vcprintf>
  801849:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	6a 00                	push   $0x0
  801851:	68 fd 63 80 00       	push   $0x8063fd
  801856:	e8 ea 01 00 00       	call   801a45 <vcprintf>
  80185b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80185e:	e8 82 ff ff ff       	call   8017e5 <exit>

	// should not return here
	while (1) ;
  801863:	eb fe                	jmp    801863 <_panic+0x70>

00801865 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80186b:	a1 20 70 80 00       	mov    0x807020,%eax
  801870:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801876:	8b 45 0c             	mov    0xc(%ebp),%eax
  801879:	39 c2                	cmp    %eax,%edx
  80187b:	74 14                	je     801891 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	68 00 64 80 00       	push   $0x806400
  801885:	6a 26                	push   $0x26
  801887:	68 4c 64 80 00       	push   $0x80644c
  80188c:	e8 62 ff ff ff       	call   8017f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801891:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801898:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80189f:	e9 c5 00 00 00       	jmp    801969 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	75 08                	jne    8018c1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018b9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018bc:	e9 a5 00 00 00       	jmp    801966 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018cf:	eb 69                	jmp    80193a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018d1:	a1 20 70 80 00       	mov    0x807020,%eax
  8018d6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8018dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018df:	89 d0                	mov    %edx,%eax
  8018e1:	01 c0                	add    %eax,%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	c1 e0 03             	shl    $0x3,%eax
  8018e8:	01 c8                	add    %ecx,%eax
  8018ea:	8a 40 04             	mov    0x4(%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	75 46                	jne    801937 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018f1:	a1 20 70 80 00       	mov    0x807020,%eax
  8018f6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8018fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	01 c0                	add    %eax,%eax
  801903:	01 d0                	add    %edx,%eax
  801905:	c1 e0 03             	shl    $0x3,%eax
  801908:	01 c8                	add    %ecx,%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80190f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801912:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801917:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	01 c8                	add    %ecx,%eax
  801928:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80192a:	39 c2                	cmp    %eax,%edx
  80192c:	75 09                	jne    801937 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80192e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801935:	eb 15                	jmp    80194c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801937:	ff 45 e8             	incl   -0x18(%ebp)
  80193a:	a1 20 70 80 00       	mov    0x807020,%eax
  80193f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801948:	39 c2                	cmp    %eax,%edx
  80194a:	77 85                	ja     8018d1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80194c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801950:	75 14                	jne    801966 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 58 64 80 00       	push   $0x806458
  80195a:	6a 3a                	push   $0x3a
  80195c:	68 4c 64 80 00       	push   $0x80644c
  801961:	e8 8d fe ff ff       	call   8017f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801966:	ff 45 f0             	incl   -0x10(%ebp)
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80196f:	0f 8c 2f ff ff ff    	jl     8018a4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801975:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80197c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801983:	eb 26                	jmp    8019ab <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801985:	a1 20 70 80 00       	mov    0x807020,%eax
  80198a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801990:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801993:	89 d0                	mov    %edx,%eax
  801995:	01 c0                	add    %eax,%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	c1 e0 03             	shl    $0x3,%eax
  80199c:	01 c8                	add    %ecx,%eax
  80199e:	8a 40 04             	mov    0x4(%eax),%al
  8019a1:	3c 01                	cmp    $0x1,%al
  8019a3:	75 03                	jne    8019a8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019a5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a8:	ff 45 e0             	incl   -0x20(%ebp)
  8019ab:	a1 20 70 80 00       	mov    0x807020,%eax
  8019b0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8019b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b9:	39 c2                	cmp    %eax,%edx
  8019bb:	77 c8                	ja     801985 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019c3:	74 14                	je     8019d9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	68 ac 64 80 00       	push   $0x8064ac
  8019cd:	6a 44                	push   $0x44
  8019cf:	68 4c 64 80 00       	push   $0x80644c
  8019d4:	e8 1a fe ff ff       	call   8017f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8019ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ed:	89 0a                	mov    %ecx,(%edx)
  8019ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f2:	88 d1                	mov    %dl,%cl
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a05:	75 2c                	jne    801a33 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801a07:	a0 28 70 80 00       	mov    0x807028,%al
  801a0c:	0f b6 c0             	movzbl %al,%eax
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 12                	mov    (%edx),%edx
  801a14:	89 d1                	mov    %edx,%ecx
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	83 c2 08             	add    $0x8,%edx
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	50                   	push   %eax
  801a20:	51                   	push   %ecx
  801a21:	52                   	push   %edx
  801a22:	e8 70 13 00 00       	call   802d97 <sys_cputs>
  801a27:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a36:	8b 40 04             	mov    0x4(%eax),%eax
  801a39:	8d 50 01             	lea    0x1(%eax),%edx
  801a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3f:	89 50 04             	mov    %edx,0x4(%eax)
}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a4e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a55:	00 00 00 
	b.cnt = 0;
  801a58:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a5f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a6e:	50                   	push   %eax
  801a6f:	68 dc 19 80 00       	push   $0x8019dc
  801a74:	e8 11 02 00 00       	call   801c8a <vprintfmt>
  801a79:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801a7c:	a0 28 70 80 00       	mov    0x807028,%al
  801a81:	0f b6 c0             	movzbl %al,%eax
  801a84:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	50                   	push   %eax
  801a8e:	52                   	push   %edx
  801a8f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a95:	83 c0 08             	add    $0x8,%eax
  801a98:	50                   	push   %eax
  801a99:	e8 f9 12 00 00       	call   802d97 <sys_cputs>
  801a9e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801aa1:	c6 05 28 70 80 00 00 	movb   $0x0,0x807028
	return b.cnt;
  801aa8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801ab6:	c6 05 28 70 80 00 01 	movb   $0x1,0x807028
	va_start(ap, fmt);
  801abd:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  801acc:	50                   	push   %eax
  801acd:	e8 73 ff ff ff       	call   801a45 <vcprintf>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801ae3:	e8 f1 12 00 00       	call   802dd9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801ae8:	8d 45 0c             	lea    0xc(%ebp),%eax
  801aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	ff 75 f4             	pushl  -0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	e8 48 ff ff ff       	call   801a45 <vcprintf>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801b03:	e8 eb 12 00 00       	call   802df3 <sys_unlock_cons>
	return cnt;
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 14             	sub    $0x14,%esp
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b20:	8b 45 18             	mov    0x18(%ebp),%eax
  801b23:	ba 00 00 00 00       	mov    $0x0,%edx
  801b28:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b2b:	77 55                	ja     801b82 <printnum+0x75>
  801b2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b30:	72 05                	jb     801b37 <printnum+0x2a>
  801b32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b35:	77 4b                	ja     801b82 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b37:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b3a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b3d:	8b 45 18             	mov    0x18(%ebp),%eax
  801b40:	ba 00 00 00 00       	mov    $0x0,%edx
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4d:	e8 92 33 00 00       	call   804ee4 <__udivdi3>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	ff 75 20             	pushl  0x20(%ebp)
  801b5b:	53                   	push   %ebx
  801b5c:	ff 75 18             	pushl  0x18(%ebp)
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	e8 a1 ff ff ff       	call   801b0d <printnum>
  801b6c:	83 c4 20             	add    $0x20,%esp
  801b6f:	eb 1a                	jmp    801b8b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b71:	83 ec 08             	sub    $0x8,%esp
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	ff 75 20             	pushl  0x20(%ebp)
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	ff d0                	call   *%eax
  801b7f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b82:	ff 4d 1c             	decl   0x1c(%ebp)
  801b85:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b89:	7f e6                	jg     801b71 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b8b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b99:	53                   	push   %ebx
  801b9a:	51                   	push   %ecx
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	e8 52 34 00 00       	call   804ff4 <__umoddi3>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	05 14 67 80 00       	add    $0x806714,%eax
  801baa:	8a 00                	mov    (%eax),%al
  801bac:	0f be c0             	movsbl %al,%eax
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	50                   	push   %eax
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	ff d0                	call   *%eax
  801bbb:	83 c4 10             	add    $0x10,%esp
}
  801bbe:	90                   	nop
  801bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bc7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bcb:	7e 1c                	jle    801be9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	8b 00                	mov    (%eax),%eax
  801bd2:	8d 50 08             	lea    0x8(%eax),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	89 10                	mov    %edx,(%eax)
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 00                	mov    (%eax),%eax
  801bdf:	83 e8 08             	sub    $0x8,%eax
  801be2:	8b 50 04             	mov    0x4(%eax),%edx
  801be5:	8b 00                	mov    (%eax),%eax
  801be7:	eb 40                	jmp    801c29 <getuint+0x65>
	else if (lflag)
  801be9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bed:	74 1e                	je     801c0d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 00                	mov    (%eax),%eax
  801bf4:	8d 50 04             	lea    0x4(%eax),%edx
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	89 10                	mov    %edx,(%eax)
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	8b 00                	mov    (%eax),%eax
  801c01:	83 e8 04             	sub    $0x4,%eax
  801c04:	8b 00                	mov    (%eax),%eax
  801c06:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0b:	eb 1c                	jmp    801c29 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	8b 00                	mov    (%eax),%eax
  801c12:	8d 50 04             	lea    0x4(%eax),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	89 10                	mov    %edx,(%eax)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	83 e8 04             	sub    $0x4,%eax
  801c22:	8b 00                	mov    (%eax),%eax
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c32:	7e 1c                	jle    801c50 <getint+0x25>
		return va_arg(*ap, long long);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	8b 00                	mov    (%eax),%eax
  801c39:	8d 50 08             	lea    0x8(%eax),%edx
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	89 10                	mov    %edx,(%eax)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8b 00                	mov    (%eax),%eax
  801c46:	83 e8 08             	sub    $0x8,%eax
  801c49:	8b 50 04             	mov    0x4(%eax),%edx
  801c4c:	8b 00                	mov    (%eax),%eax
  801c4e:	eb 38                	jmp    801c88 <getint+0x5d>
	else if (lflag)
  801c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c54:	74 1a                	je     801c70 <getint+0x45>
		return va_arg(*ap, long);
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	8d 50 04             	lea    0x4(%eax),%edx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	89 10                	mov    %edx,(%eax)
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	8b 00                	mov    (%eax),%eax
  801c68:	83 e8 04             	sub    $0x4,%eax
  801c6b:	8b 00                	mov    (%eax),%eax
  801c6d:	99                   	cltd   
  801c6e:	eb 18                	jmp    801c88 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	8b 00                	mov    (%eax),%eax
  801c75:	8d 50 04             	lea    0x4(%eax),%edx
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	89 10                	mov    %edx,(%eax)
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	8b 00                	mov    (%eax),%eax
  801c82:	83 e8 04             	sub    $0x4,%eax
  801c85:	8b 00                	mov    (%eax),%eax
  801c87:	99                   	cltd   
}
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	56                   	push   %esi
  801c8e:	53                   	push   %ebx
  801c8f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c92:	eb 17                	jmp    801cab <vprintfmt+0x21>
			if (ch == '\0')
  801c94:	85 db                	test   %ebx,%ebx
  801c96:	0f 84 c1 03 00 00    	je     80205d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	53                   	push   %ebx
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	ff d0                	call   *%eax
  801ca8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cab:	8b 45 10             	mov    0x10(%ebp),%eax
  801cae:	8d 50 01             	lea    0x1(%eax),%edx
  801cb1:	89 55 10             	mov    %edx,0x10(%ebp)
  801cb4:	8a 00                	mov    (%eax),%al
  801cb6:	0f b6 d8             	movzbl %al,%ebx
  801cb9:	83 fb 25             	cmp    $0x25,%ebx
  801cbc:	75 d6                	jne    801c94 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801cbe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801cc2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801cc9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801cd7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce1:	8d 50 01             	lea    0x1(%eax),%edx
  801ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	0f b6 d8             	movzbl %al,%ebx
  801cec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cef:	83 f8 5b             	cmp    $0x5b,%eax
  801cf2:	0f 87 3d 03 00 00    	ja     802035 <vprintfmt+0x3ab>
  801cf8:	8b 04 85 38 67 80 00 	mov    0x806738(,%eax,4),%eax
  801cff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801d01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801d05:	eb d7                	jmp    801cde <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d0b:	eb d1                	jmp    801cde <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d17:	89 d0                	mov    %edx,%eax
  801d19:	c1 e0 02             	shl    $0x2,%eax
  801d1c:	01 d0                	add    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d8                	add    %ebx,%eax
  801d22:	83 e8 30             	sub    $0x30,%eax
  801d25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d28:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2b:	8a 00                	mov    (%eax),%al
  801d2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d30:	83 fb 2f             	cmp    $0x2f,%ebx
  801d33:	7e 3e                	jle    801d73 <vprintfmt+0xe9>
  801d35:	83 fb 39             	cmp    $0x39,%ebx
  801d38:	7f 39                	jg     801d73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d3d:	eb d5                	jmp    801d14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d42:	83 c0 04             	add    $0x4,%eax
  801d45:	89 45 14             	mov    %eax,0x14(%ebp)
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	83 e8 04             	sub    $0x4,%eax
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d53:	eb 1f                	jmp    801d74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d59:	79 83                	jns    801cde <vprintfmt+0x54>
				width = 0;
  801d5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d62:	e9 77 ff ff ff       	jmp    801cde <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d6e:	e9 6b ff ff ff       	jmp    801cde <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d78:	0f 89 60 ff ff ff    	jns    801cde <vprintfmt+0x54>
				width = precision, precision = -1;
  801d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d8b:	e9 4e ff ff ff       	jmp    801cde <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d93:	e9 46 ff ff ff       	jmp    801cde <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d98:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9b:	83 c0 04             	add    $0x4,%eax
  801d9e:	89 45 14             	mov    %eax,0x14(%ebp)
  801da1:	8b 45 14             	mov    0x14(%ebp),%eax
  801da4:	83 e8 04             	sub    $0x4,%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	50                   	push   %eax
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	ff d0                	call   *%eax
  801db5:	83 c4 10             	add    $0x10,%esp
			break;
  801db8:	e9 9b 02 00 00       	jmp    802058 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc0:	83 c0 04             	add    $0x4,%eax
  801dc3:	89 45 14             	mov    %eax,0x14(%ebp)
  801dc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc9:	83 e8 04             	sub    $0x4,%eax
  801dcc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801dce:	85 db                	test   %ebx,%ebx
  801dd0:	79 02                	jns    801dd4 <vprintfmt+0x14a>
				err = -err;
  801dd2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801dd4:	83 fb 64             	cmp    $0x64,%ebx
  801dd7:	7f 0b                	jg     801de4 <vprintfmt+0x15a>
  801dd9:	8b 34 9d 80 65 80 00 	mov    0x806580(,%ebx,4),%esi
  801de0:	85 f6                	test   %esi,%esi
  801de2:	75 19                	jne    801dfd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de4:	53                   	push   %ebx
  801de5:	68 25 67 80 00       	push   $0x806725
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	ff 75 08             	pushl  0x8(%ebp)
  801df0:	e8 70 02 00 00       	call   802065 <printfmt>
  801df5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801df8:	e9 5b 02 00 00       	jmp    802058 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801dfd:	56                   	push   %esi
  801dfe:	68 2e 67 80 00       	push   $0x80672e
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	e8 57 02 00 00       	call   802065 <printfmt>
  801e0e:	83 c4 10             	add    $0x10,%esp
			break;
  801e11:	e9 42 02 00 00       	jmp    802058 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e16:	8b 45 14             	mov    0x14(%ebp),%eax
  801e19:	83 c0 04             	add    $0x4,%eax
  801e1c:	89 45 14             	mov    %eax,0x14(%ebp)
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	83 e8 04             	sub    $0x4,%eax
  801e25:	8b 30                	mov    (%eax),%esi
  801e27:	85 f6                	test   %esi,%esi
  801e29:	75 05                	jne    801e30 <vprintfmt+0x1a6>
				p = "(null)";
  801e2b:	be 31 67 80 00       	mov    $0x806731,%esi
			if (width > 0 && padc != '-')
  801e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e34:	7e 6d                	jle    801ea3 <vprintfmt+0x219>
  801e36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e3a:	74 67                	je     801ea3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3f:	83 ec 08             	sub    $0x8,%esp
  801e42:	50                   	push   %eax
  801e43:	56                   	push   %esi
  801e44:	e8 1e 03 00 00       	call   802167 <strnlen>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e4f:	eb 16                	jmp    801e67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	50                   	push   %eax
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	ff d0                	call   *%eax
  801e61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e64:	ff 4d e4             	decl   -0x1c(%ebp)
  801e67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e6b:	7f e4                	jg     801e51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e6d:	eb 34                	jmp    801ea3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e73:	74 1c                	je     801e91 <vprintfmt+0x207>
  801e75:	83 fb 1f             	cmp    $0x1f,%ebx
  801e78:	7e 05                	jle    801e7f <vprintfmt+0x1f5>
  801e7a:	83 fb 7e             	cmp    $0x7e,%ebx
  801e7d:	7e 12                	jle    801e91 <vprintfmt+0x207>
					putch('?', putdat);
  801e7f:	83 ec 08             	sub    $0x8,%esp
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	6a 3f                	push   $0x3f
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	ff d0                	call   *%eax
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	eb 0f                	jmp    801ea0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	53                   	push   %ebx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	ff d0                	call   *%eax
  801e9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ea0:	ff 4d e4             	decl   -0x1c(%ebp)
  801ea3:	89 f0                	mov    %esi,%eax
  801ea5:	8d 70 01             	lea    0x1(%eax),%esi
  801ea8:	8a 00                	mov    (%eax),%al
  801eaa:	0f be d8             	movsbl %al,%ebx
  801ead:	85 db                	test   %ebx,%ebx
  801eaf:	74 24                	je     801ed5 <vprintfmt+0x24b>
  801eb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eb5:	78 b8                	js     801e6f <vprintfmt+0x1e5>
  801eb7:	ff 4d e0             	decl   -0x20(%ebp)
  801eba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ebe:	79 af                	jns    801e6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ec0:	eb 13                	jmp    801ed5 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ec2:	83 ec 08             	sub    $0x8,%esp
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	6a 20                	push   $0x20
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	ff d0                	call   *%eax
  801ecf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ed2:	ff 4d e4             	decl   -0x1c(%ebp)
  801ed5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ed9:	7f e7                	jg     801ec2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801edb:	e9 78 01 00 00       	jmp    802058 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ee0:	83 ec 08             	sub    $0x8,%esp
  801ee3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee6:	8d 45 14             	lea    0x14(%ebp),%eax
  801ee9:	50                   	push   %eax
  801eea:	e8 3c fd ff ff       	call   801c2b <getint>
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ef5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efe:	85 d2                	test   %edx,%edx
  801f00:	79 23                	jns    801f25 <vprintfmt+0x29b>
				putch('-', putdat);
  801f02:	83 ec 08             	sub    $0x8,%esp
  801f05:	ff 75 0c             	pushl  0xc(%ebp)
  801f08:	6a 2d                	push   $0x2d
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	ff d0                	call   *%eax
  801f0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f18:	f7 d8                	neg    %eax
  801f1a:	83 d2 00             	adc    $0x0,%edx
  801f1d:	f7 da                	neg    %edx
  801f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f2c:	e9 bc 00 00 00       	jmp    801fed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	ff 75 e8             	pushl  -0x18(%ebp)
  801f37:	8d 45 14             	lea    0x14(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	e8 84 fc ff ff       	call   801bc4 <getuint>
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f50:	e9 98 00 00 00       	jmp    801fed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	6a 58                	push   $0x58
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	ff d0                	call   *%eax
  801f62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f65:	83 ec 08             	sub    $0x8,%esp
  801f68:	ff 75 0c             	pushl  0xc(%ebp)
  801f6b:	6a 58                	push   $0x58
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	ff d0                	call   *%eax
  801f72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	6a 58                	push   $0x58
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	ff d0                	call   *%eax
  801f82:	83 c4 10             	add    $0x10,%esp
			break;
  801f85:	e9 ce 00 00 00       	jmp    802058 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f8a:	83 ec 08             	sub    $0x8,%esp
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	6a 30                	push   $0x30
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	ff d0                	call   *%eax
  801f97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	6a 78                	push   $0x78
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	ff d0                	call   *%eax
  801fa7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801faa:	8b 45 14             	mov    0x14(%ebp),%eax
  801fad:	83 c0 04             	add    $0x4,%eax
  801fb0:	89 45 14             	mov    %eax,0x14(%ebp)
  801fb3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb6:	83 e8 04             	sub    $0x4,%eax
  801fb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801fc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801fcc:	eb 1f                	jmp    801fed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	ff 75 e8             	pushl  -0x18(%ebp)
  801fd4:	8d 45 14             	lea    0x14(%ebp),%eax
  801fd7:	50                   	push   %eax
  801fd8:	e8 e7 fb ff ff       	call   801bc4 <getuint>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801fe6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801fed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	52                   	push   %edx
  801ff8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ffb:	50                   	push   %eax
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	ff 75 f0             	pushl  -0x10(%ebp)
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	e8 00 fb ff ff       	call   801b0d <printnum>
  80200d:	83 c4 20             	add    $0x20,%esp
			break;
  802010:	eb 46                	jmp    802058 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	53                   	push   %ebx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	ff d0                	call   *%eax
  80201e:	83 c4 10             	add    $0x10,%esp
			break;
  802021:	eb 35                	jmp    802058 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  802023:	c6 05 28 70 80 00 00 	movb   $0x0,0x807028
			break;
  80202a:	eb 2c                	jmp    802058 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80202c:	c6 05 28 70 80 00 01 	movb   $0x1,0x807028
			break;
  802033:	eb 23                	jmp    802058 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	ff 75 0c             	pushl  0xc(%ebp)
  80203b:	6a 25                	push   $0x25
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	ff d0                	call   *%eax
  802042:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802045:	ff 4d 10             	decl   0x10(%ebp)
  802048:	eb 03                	jmp    80204d <vprintfmt+0x3c3>
  80204a:	ff 4d 10             	decl   0x10(%ebp)
  80204d:	8b 45 10             	mov    0x10(%ebp),%eax
  802050:	48                   	dec    %eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	3c 25                	cmp    $0x25,%al
  802055:	75 f3                	jne    80204a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802057:	90                   	nop
		}
	}
  802058:	e9 35 fc ff ff       	jmp    801c92 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80205d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80205e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    

00802065 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80206b:	8d 45 10             	lea    0x10(%ebp),%eax
  80206e:	83 c0 04             	add    $0x4,%eax
  802071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802074:	8b 45 10             	mov    0x10(%ebp),%eax
  802077:	ff 75 f4             	pushl  -0xc(%ebp)
  80207a:	50                   	push   %eax
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	e8 04 fc ff ff       	call   801c8a <vprintfmt>
  802086:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802089:	90                   	nop
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80208f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802092:	8b 40 08             	mov    0x8(%eax),%eax
  802095:	8d 50 01             	lea    0x1(%eax),%edx
  802098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	8b 10                	mov    (%eax),%edx
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	8b 40 04             	mov    0x4(%eax),%eax
  8020a9:	39 c2                	cmp    %eax,%edx
  8020ab:	73 12                	jae    8020bf <sprintputch+0x33>
		*b->buf++ = ch;
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	89 0a                	mov    %ecx,(%edx)
  8020ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bd:	88 10                	mov    %dl,(%eax)
}
  8020bf:	90                   	nop
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e7:	74 06                	je     8020ef <vsnprintf+0x2d>
  8020e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ed:	7f 07                	jg     8020f6 <vsnprintf+0x34>
		return -E_INVAL;
  8020ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8020f4:	eb 20                	jmp    802116 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020f6:	ff 75 14             	pushl  0x14(%ebp)
  8020f9:	ff 75 10             	pushl  0x10(%ebp)
  8020fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	68 8c 20 80 00       	push   $0x80208c
  802105:	e8 80 fb ff ff       	call   801c8a <vprintfmt>
  80210a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80210d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802110:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80211e:	8d 45 10             	lea    0x10(%ebp),%eax
  802121:	83 c0 04             	add    $0x4,%eax
  802124:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802127:	8b 45 10             	mov    0x10(%ebp),%eax
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	50                   	push   %eax
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	e8 89 ff ff ff       	call   8020c2 <vsnprintf>
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80214a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802151:	eb 06                	jmp    802159 <strlen+0x15>
		n++;
  802153:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802156:	ff 45 08             	incl   0x8(%ebp)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8a 00                	mov    (%eax),%al
  80215e:	84 c0                	test   %al,%al
  802160:	75 f1                	jne    802153 <strlen+0xf>
		n++;
	return n;
  802162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80216d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802174:	eb 09                	jmp    80217f <strnlen+0x18>
		n++;
  802176:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802179:	ff 45 08             	incl   0x8(%ebp)
  80217c:	ff 4d 0c             	decl   0xc(%ebp)
  80217f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802183:	74 09                	je     80218e <strnlen+0x27>
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8a 00                	mov    (%eax),%al
  80218a:	84 c0                	test   %al,%al
  80218c:	75 e8                	jne    802176 <strnlen+0xf>
		n++;
	return n;
  80218e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80219f:	90                   	nop
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8d 50 01             	lea    0x1(%eax),%edx
  8021a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021b2:	8a 12                	mov    (%edx),%dl
  8021b4:	88 10                	mov    %dl,(%eax)
  8021b6:	8a 00                	mov    (%eax),%al
  8021b8:	84 c0                	test   %al,%al
  8021ba:	75 e4                	jne    8021a0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8021bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8021cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021d4:	eb 1f                	jmp    8021f5 <strncpy+0x34>
		*dst++ = *src;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8d 50 01             	lea    0x1(%eax),%edx
  8021dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8021df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e2:	8a 12                	mov    (%edx),%dl
  8021e4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	8a 00                	mov    (%eax),%al
  8021eb:	84 c0                	test   %al,%al
  8021ed:	74 03                	je     8021f2 <strncpy+0x31>
			src++;
  8021ef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021f2:	ff 45 fc             	incl   -0x4(%ebp)
  8021f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021fb:	72 d9                	jb     8021d6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8021fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80220e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802212:	74 30                	je     802244 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802214:	eb 16                	jmp    80222c <strlcpy+0x2a>
			*dst++ = *src++;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8d 50 01             	lea    0x1(%eax),%edx
  80221c:	89 55 08             	mov    %edx,0x8(%ebp)
  80221f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802222:	8d 4a 01             	lea    0x1(%edx),%ecx
  802225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802228:	8a 12                	mov    (%edx),%dl
  80222a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80222c:	ff 4d 10             	decl   0x10(%ebp)
  80222f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802233:	74 09                	je     80223e <strlcpy+0x3c>
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	8a 00                	mov    (%eax),%al
  80223a:	84 c0                	test   %al,%al
  80223c:	75 d8                	jne    802216 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802244:	8b 55 08             	mov    0x8(%ebp),%edx
  802247:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224a:	29 c2                	sub    %eax,%edx
  80224c:	89 d0                	mov    %edx,%eax
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802253:	eb 06                	jmp    80225b <strcmp+0xb>
		p++, q++;
  802255:	ff 45 08             	incl   0x8(%ebp)
  802258:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8a 00                	mov    (%eax),%al
  802260:	84 c0                	test   %al,%al
  802262:	74 0e                	je     802272 <strcmp+0x22>
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8a 10                	mov    (%eax),%dl
  802269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226c:	8a 00                	mov    (%eax),%al
  80226e:	38 c2                	cmp    %al,%dl
  802270:	74 e3                	je     802255 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8a 00                	mov    (%eax),%al
  802277:	0f b6 d0             	movzbl %al,%edx
  80227a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227d:	8a 00                	mov    (%eax),%al
  80227f:	0f b6 c0             	movzbl %al,%eax
  802282:	29 c2                	sub    %eax,%edx
  802284:	89 d0                	mov    %edx,%eax
}
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    

00802288 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80228b:	eb 09                	jmp    802296 <strncmp+0xe>
		n--, p++, q++;
  80228d:	ff 4d 10             	decl   0x10(%ebp)
  802290:	ff 45 08             	incl   0x8(%ebp)
  802293:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80229a:	74 17                	je     8022b3 <strncmp+0x2b>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	8a 00                	mov    (%eax),%al
  8022a1:	84 c0                	test   %al,%al
  8022a3:	74 0e                	je     8022b3 <strncmp+0x2b>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8a 10                	mov    (%eax),%dl
  8022aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ad:	8a 00                	mov    (%eax),%al
  8022af:	38 c2                	cmp    %al,%dl
  8022b1:	74 da                	je     80228d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b7:	75 07                	jne    8022c0 <strncmp+0x38>
		return 0;
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	eb 14                	jmp    8022d4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8a 00                	mov    (%eax),%al
  8022c5:	0f b6 d0             	movzbl %al,%edx
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	8a 00                	mov    (%eax),%al
  8022cd:	0f b6 c0             	movzbl %al,%eax
  8022d0:	29 c2                	sub    %eax,%edx
  8022d2:	89 d0                	mov    %edx,%eax
}
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022e2:	eb 12                	jmp    8022f6 <strchr+0x20>
		if (*s == c)
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	8a 00                	mov    (%eax),%al
  8022e9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022ec:	75 05                	jne    8022f3 <strchr+0x1d>
			return (char *) s;
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	eb 11                	jmp    802304 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022f3:	ff 45 08             	incl   0x8(%ebp)
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	8a 00                	mov    (%eax),%al
  8022fb:	84 c0                	test   %al,%al
  8022fd:	75 e5                	jne    8022e4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802312:	eb 0d                	jmp    802321 <strfind+0x1b>
		if (*s == c)
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	8a 00                	mov    (%eax),%al
  802319:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80231c:	74 0e                	je     80232c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80231e:	ff 45 08             	incl   0x8(%ebp)
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	8a 00                	mov    (%eax),%al
  802326:	84 c0                	test   %al,%al
  802328:	75 ea                	jne    802314 <strfind+0xe>
  80232a:	eb 01                	jmp    80232d <strfind+0x27>
		if (*s == c)
			break;
  80232c:	90                   	nop
	return (char *) s;
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80233e:	8b 45 10             	mov    0x10(%ebp),%eax
  802341:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802344:	eb 0e                	jmp    802354 <memset+0x22>
		*p++ = c;
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	8d 50 01             	lea    0x1(%eax),%edx
  80234c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80234f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802352:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802354:	ff 4d f8             	decl   -0x8(%ebp)
  802357:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80235b:	79 e9                	jns    802346 <memset+0x14>
		*p++ = c;

	return v;
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802374:	eb 16                	jmp    80238c <memcpy+0x2a>
		*d++ = *s++;
  802376:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802379:	8d 50 01             	lea    0x1(%eax),%edx
  80237c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80237f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802382:	8d 4a 01             	lea    0x1(%edx),%ecx
  802385:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802388:	8a 12                	mov    (%edx),%dl
  80238a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80238c:	8b 45 10             	mov    0x10(%ebp),%eax
  80238f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802392:	89 55 10             	mov    %edx,0x10(%ebp)
  802395:	85 c0                	test   %eax,%eax
  802397:	75 dd                	jne    802376 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8023a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8023b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023b6:	73 50                	jae    802408 <memmove+0x6a>
  8023b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023be:	01 d0                	add    %edx,%eax
  8023c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023c3:	76 43                	jbe    802408 <memmove+0x6a>
		s += n;
  8023c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8023cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ce:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023d1:	eb 10                	jmp    8023e3 <memmove+0x45>
			*--d = *--s;
  8023d3:	ff 4d f8             	decl   -0x8(%ebp)
  8023d6:	ff 4d fc             	decl   -0x4(%ebp)
  8023d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023dc:	8a 10                	mov    (%eax),%dl
  8023de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8023e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	75 e3                	jne    8023d3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023f0:	eb 23                	jmp    802415 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8023f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f5:	8d 50 01             	lea    0x1(%eax),%edx
  8023f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  802401:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802404:	8a 12                	mov    (%edx),%dl
  802406:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80240e:	89 55 10             	mov    %edx,0x10(%ebp)
  802411:	85 c0                	test   %eax,%eax
  802413:	75 dd                	jne    8023f2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802426:	8b 45 0c             	mov    0xc(%ebp),%eax
  802429:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80242c:	eb 2a                	jmp    802458 <memcmp+0x3e>
		if (*s1 != *s2)
  80242e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802431:	8a 10                	mov    (%eax),%dl
  802433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802436:	8a 00                	mov    (%eax),%al
  802438:	38 c2                	cmp    %al,%dl
  80243a:	74 16                	je     802452 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80243c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80243f:	8a 00                	mov    (%eax),%al
  802441:	0f b6 d0             	movzbl %al,%edx
  802444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802447:	8a 00                	mov    (%eax),%al
  802449:	0f b6 c0             	movzbl %al,%eax
  80244c:	29 c2                	sub    %eax,%edx
  80244e:	89 d0                	mov    %edx,%eax
  802450:	eb 18                	jmp    80246a <memcmp+0x50>
		s1++, s2++;
  802452:	ff 45 fc             	incl   -0x4(%ebp)
  802455:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802458:	8b 45 10             	mov    0x10(%ebp),%eax
  80245b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80245e:	89 55 10             	mov    %edx,0x10(%ebp)
  802461:	85 c0                	test   %eax,%eax
  802463:	75 c9                	jne    80242e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802472:	8b 55 08             	mov    0x8(%ebp),%edx
  802475:	8b 45 10             	mov    0x10(%ebp),%eax
  802478:	01 d0                	add    %edx,%eax
  80247a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80247d:	eb 15                	jmp    802494 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8a 00                	mov    (%eax),%al
  802484:	0f b6 d0             	movzbl %al,%edx
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	0f b6 c0             	movzbl %al,%eax
  80248d:	39 c2                	cmp    %eax,%edx
  80248f:	74 0d                	je     80249e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802491:	ff 45 08             	incl   0x8(%ebp)
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80249a:	72 e3                	jb     80247f <memfind+0x13>
  80249c:	eb 01                	jmp    80249f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80249e:	90                   	nop
	return (void *) s;
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8024aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8024b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024b8:	eb 03                	jmp    8024bd <strtol+0x19>
		s++;
  8024ba:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	8a 00                	mov    (%eax),%al
  8024c2:	3c 20                	cmp    $0x20,%al
  8024c4:	74 f4                	je     8024ba <strtol+0x16>
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8a 00                	mov    (%eax),%al
  8024cb:	3c 09                	cmp    $0x9,%al
  8024cd:	74 eb                	je     8024ba <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8a 00                	mov    (%eax),%al
  8024d4:	3c 2b                	cmp    $0x2b,%al
  8024d6:	75 05                	jne    8024dd <strtol+0x39>
		s++;
  8024d8:	ff 45 08             	incl   0x8(%ebp)
  8024db:	eb 13                	jmp    8024f0 <strtol+0x4c>
	else if (*s == '-')
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	8a 00                	mov    (%eax),%al
  8024e2:	3c 2d                	cmp    $0x2d,%al
  8024e4:	75 0a                	jne    8024f0 <strtol+0x4c>
		s++, neg = 1;
  8024e6:	ff 45 08             	incl   0x8(%ebp)
  8024e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024f4:	74 06                	je     8024fc <strtol+0x58>
  8024f6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8024fa:	75 20                	jne    80251c <strtol+0x78>
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	8a 00                	mov    (%eax),%al
  802501:	3c 30                	cmp    $0x30,%al
  802503:	75 17                	jne    80251c <strtol+0x78>
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	40                   	inc    %eax
  802509:	8a 00                	mov    (%eax),%al
  80250b:	3c 78                	cmp    $0x78,%al
  80250d:	75 0d                	jne    80251c <strtol+0x78>
		s += 2, base = 16;
  80250f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802513:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80251a:	eb 28                	jmp    802544 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80251c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802520:	75 15                	jne    802537 <strtol+0x93>
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	8a 00                	mov    (%eax),%al
  802527:	3c 30                	cmp    $0x30,%al
  802529:	75 0c                	jne    802537 <strtol+0x93>
		s++, base = 8;
  80252b:	ff 45 08             	incl   0x8(%ebp)
  80252e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802535:	eb 0d                	jmp    802544 <strtol+0xa0>
	else if (base == 0)
  802537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80253b:	75 07                	jne    802544 <strtol+0xa0>
		base = 10;
  80253d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8a 00                	mov    (%eax),%al
  802549:	3c 2f                	cmp    $0x2f,%al
  80254b:	7e 19                	jle    802566 <strtol+0xc2>
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	8a 00                	mov    (%eax),%al
  802552:	3c 39                	cmp    $0x39,%al
  802554:	7f 10                	jg     802566 <strtol+0xc2>
			dig = *s - '0';
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	8a 00                	mov    (%eax),%al
  80255b:	0f be c0             	movsbl %al,%eax
  80255e:	83 e8 30             	sub    $0x30,%eax
  802561:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802564:	eb 42                	jmp    8025a8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	8a 00                	mov    (%eax),%al
  80256b:	3c 60                	cmp    $0x60,%al
  80256d:	7e 19                	jle    802588 <strtol+0xe4>
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	3c 7a                	cmp    $0x7a,%al
  802576:	7f 10                	jg     802588 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8a 00                	mov    (%eax),%al
  80257d:	0f be c0             	movsbl %al,%eax
  802580:	83 e8 57             	sub    $0x57,%eax
  802583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802586:	eb 20                	jmp    8025a8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	3c 40                	cmp    $0x40,%al
  80258f:	7e 39                	jle    8025ca <strtol+0x126>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	3c 5a                	cmp    $0x5a,%al
  802598:	7f 30                	jg     8025ca <strtol+0x126>
			dig = *s - 'A' + 10;
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	8a 00                	mov    (%eax),%al
  80259f:	0f be c0             	movsbl %al,%eax
  8025a2:	83 e8 37             	sub    $0x37,%eax
  8025a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	3b 45 10             	cmp    0x10(%ebp),%eax
  8025ae:	7d 19                	jge    8025c9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8025b0:	ff 45 08             	incl   0x8(%ebp)
  8025b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025b6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8025ba:	89 c2                	mov    %eax,%edx
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	01 d0                	add    %edx,%eax
  8025c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8025c4:	e9 7b ff ff ff       	jmp    802544 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8025c9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8025ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025ce:	74 08                	je     8025d8 <strtol+0x134>
		*endptr = (char *) s;
  8025d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8025d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025dc:	74 07                	je     8025e5 <strtol+0x141>
  8025de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e1:	f7 d8                	neg    %eax
  8025e3:	eb 03                	jmp    8025e8 <strtol+0x144>
  8025e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <ltostr>:

void
ltostr(long value, char *str)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8025f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8025f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8025fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802602:	79 13                	jns    802617 <ltostr+0x2d>
	{
		neg = 1;
  802604:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80260b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802611:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802614:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
  80261a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80261f:	99                   	cltd   
  802620:	f7 f9                	idiv   %ecx
  802622:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802628:	8d 50 01             	lea    0x1(%eax),%edx
  80262b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80262e:	89 c2                	mov    %eax,%edx
  802630:	8b 45 0c             	mov    0xc(%ebp),%eax
  802633:	01 d0                	add    %edx,%eax
  802635:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802638:	83 c2 30             	add    $0x30,%edx
  80263b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80263d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802640:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802645:	f7 e9                	imul   %ecx
  802647:	c1 fa 02             	sar    $0x2,%edx
  80264a:	89 c8                	mov    %ecx,%eax
  80264c:	c1 f8 1f             	sar    $0x1f,%eax
  80264f:	29 c2                	sub    %eax,%edx
  802651:	89 d0                	mov    %edx,%eax
  802653:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802656:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80265a:	75 bb                	jne    802617 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80265c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802663:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802666:	48                   	dec    %eax
  802667:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80266a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80266e:	74 3d                	je     8026ad <ltostr+0xc3>
		start = 1 ;
  802670:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802677:	eb 34                	jmp    8026ad <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	8a 00                	mov    (%eax),%al
  802683:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268c:	01 c2                	add    %eax,%edx
  80268e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802691:	8b 45 0c             	mov    0xc(%ebp),%eax
  802694:	01 c8                	add    %ecx,%eax
  802696:	8a 00                	mov    (%eax),%al
  802698:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80269a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a0:	01 c2                	add    %eax,%edx
  8026a2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8026a5:	88 02                	mov    %al,(%edx)
		start++ ;
  8026a7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8026aa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026b3:	7c c4                	jl     802679 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8026b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8026b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bb:	01 d0                	add    %edx,%eax
  8026bd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8026c0:	90                   	nop
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8026c9:	ff 75 08             	pushl  0x8(%ebp)
  8026cc:	e8 73 fa ff ff       	call   802144 <strlen>
  8026d1:	83 c4 04             	add    $0x4,%esp
  8026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8026d7:	ff 75 0c             	pushl  0xc(%ebp)
  8026da:	e8 65 fa ff ff       	call   802144 <strlen>
  8026df:	83 c4 04             	add    $0x4,%esp
  8026e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8026e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8026ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026f3:	eb 17                	jmp    80270c <strcconcat+0x49>
		final[s] = str1[s] ;
  8026f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026fb:	01 c2                	add    %eax,%edx
  8026fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	01 c8                	add    %ecx,%eax
  802705:	8a 00                	mov    (%eax),%al
  802707:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802709:	ff 45 fc             	incl   -0x4(%ebp)
  80270c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80270f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802712:	7c e1                	jl     8026f5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802714:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80271b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802722:	eb 1f                	jmp    802743 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802724:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802727:	8d 50 01             	lea    0x1(%eax),%edx
  80272a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80272d:	89 c2                	mov    %eax,%edx
  80272f:	8b 45 10             	mov    0x10(%ebp),%eax
  802732:	01 c2                	add    %eax,%edx
  802734:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273a:	01 c8                	add    %ecx,%eax
  80273c:	8a 00                	mov    (%eax),%al
  80273e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802740:	ff 45 f8             	incl   -0x8(%ebp)
  802743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802746:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802749:	7c d9                	jl     802724 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80274b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274e:	8b 45 10             	mov    0x10(%ebp),%eax
  802751:	01 d0                	add    %edx,%eax
  802753:	c6 00 00             	movb   $0x0,(%eax)
}
  802756:	90                   	nop
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80275c:	8b 45 14             	mov    0x14(%ebp),%eax
  80275f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802765:	8b 45 14             	mov    0x14(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802771:	8b 45 10             	mov    0x10(%ebp),%eax
  802774:	01 d0                	add    %edx,%eax
  802776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80277c:	eb 0c                	jmp    80278a <strsplit+0x31>
			*string++ = 0;
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	8d 50 01             	lea    0x1(%eax),%edx
  802784:	89 55 08             	mov    %edx,0x8(%ebp)
  802787:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	8a 00                	mov    (%eax),%al
  80278f:	84 c0                	test   %al,%al
  802791:	74 18                	je     8027ab <strsplit+0x52>
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	8a 00                	mov    (%eax),%al
  802798:	0f be c0             	movsbl %al,%eax
  80279b:	50                   	push   %eax
  80279c:	ff 75 0c             	pushl  0xc(%ebp)
  80279f:	e8 32 fb ff ff       	call   8022d6 <strchr>
  8027a4:	83 c4 08             	add    $0x8,%esp
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	75 d3                	jne    80277e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	8a 00                	mov    (%eax),%al
  8027b0:	84 c0                	test   %al,%al
  8027b2:	74 5a                	je     80280e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8027b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	83 f8 0f             	cmp    $0xf,%eax
  8027bc:	75 07                	jne    8027c5 <strsplit+0x6c>
		{
			return 0;
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c3:	eb 66                	jmp    80282b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8027c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8027cd:	8b 55 14             	mov    0x14(%ebp),%edx
  8027d0:	89 0a                	mov    %ecx,(%edx)
  8027d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8027d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8027dc:	01 c2                	add    %eax,%edx
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027e3:	eb 03                	jmp    8027e8 <strsplit+0x8f>
			string++;
  8027e5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	8a 00                	mov    (%eax),%al
  8027ed:	84 c0                	test   %al,%al
  8027ef:	74 8b                	je     80277c <strsplit+0x23>
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8a 00                	mov    (%eax),%al
  8027f6:	0f be c0             	movsbl %al,%eax
  8027f9:	50                   	push   %eax
  8027fa:	ff 75 0c             	pushl  0xc(%ebp)
  8027fd:	e8 d4 fa ff ff       	call   8022d6 <strchr>
  802802:	83 c4 08             	add    $0x8,%esp
  802805:	85 c0                	test   %eax,%eax
  802807:	74 dc                	je     8027e5 <strsplit+0x8c>
			string++;
	}
  802809:	e9 6e ff ff ff       	jmp    80277c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80280e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80280f:	8b 45 14             	mov    0x14(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80281b:	8b 45 10             	mov    0x10(%ebp),%eax
  80281e:	01 d0                	add    %edx,%eax
  802820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802826:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	68 a8 68 80 00       	push   $0x8068a8
  80283b:	68 3f 01 00 00       	push   $0x13f
  802840:	68 ca 68 80 00       	push   $0x8068ca
  802845:	e8 a9 ef ff ff       	call   8017f3 <_panic>

0080284a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802850:	83 ec 0c             	sub    $0xc,%esp
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	e8 e7 0a 00 00       	call   803342 <sys_sbrk>
  80285b:	83 c4 10             	add    $0x10,%esp
}
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286a:	75 0a                	jne    802876 <malloc+0x16>
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax
  802871:	e9 07 02 00 00       	jmp    802a7d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  802876:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80287d:	8b 55 08             	mov    0x8(%ebp),%edx
  802880:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802883:	01 d0                	add    %edx,%eax
  802885:	48                   	dec    %eax
  802886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802889:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80288c:	ba 00 00 00 00       	mov    $0x0,%edx
  802891:	f7 75 dc             	divl   -0x24(%ebp)
  802894:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802897:	29 d0                	sub    %edx,%eax
  802899:	c1 e8 0c             	shr    $0xc,%eax
  80289c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80289f:	a1 20 70 80 00       	mov    0x807020,%eax
  8028a4:	8b 40 78             	mov    0x78(%eax),%eax
  8028a7:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8028ac:	29 c2                	sub    %eax,%edx
  8028ae:	89 d0                	mov    %edx,%eax
  8028b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8028b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8028bb:	c1 e8 0c             	shr    $0xc,%eax
  8028be:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8028c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8028c8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8028cf:	77 42                	ja     802913 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8028d1:	e8 f0 08 00 00       	call   8031c6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 30 0e 00 00       	call   803715 <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 02 09 00 00       	call   8031f7 <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 c9 12 00 00       	call   803bd1 <alloc_block_BF>
  802908:	83 c4 10             	add    $0x10,%esp
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290e:	e9 67 01 00 00       	jmp    802a7a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  802913:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802916:	48                   	dec    %eax
  802917:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80291a:	0f 86 53 01 00 00    	jbe    802a73 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  802920:	a1 20 70 80 00       	mov    0x807020,%eax
  802925:	8b 40 78             	mov    0x78(%eax),%eax
  802928:	05 00 10 00 00       	add    $0x1000,%eax
  80292d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  802930:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  802937:	e9 de 00 00 00       	jmp    802a1a <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80293c:	a1 20 70 80 00       	mov    0x807020,%eax
  802941:	8b 40 78             	mov    0x78(%eax),%eax
  802944:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802947:	29 c2                	sub    %eax,%edx
  802949:	89 d0                	mov    %edx,%eax
  80294b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802950:	c1 e8 0c             	shr    $0xc,%eax
  802953:	8b 04 85 60 70 88 00 	mov    0x887060(,%eax,4),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	0f 85 ab 00 00 00    	jne    802a0d <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	05 00 10 00 00       	add    $0x1000,%eax
  80296a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80296d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  802974:	eb 47                	jmp    8029bd <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  802976:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80297d:	76 0a                	jbe    802989 <malloc+0x129>
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
  802984:	e9 f4 00 00 00       	jmp    802a7d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  802989:	a1 20 70 80 00       	mov    0x807020,%eax
  80298e:	8b 40 78             	mov    0x78(%eax),%eax
  802991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802994:	29 c2                	sub    %eax,%edx
  802996:	89 d0                	mov    %edx,%eax
  802998:	2d 00 10 00 00       	sub    $0x1000,%eax
  80299d:	c1 e8 0c             	shr    $0xc,%eax
  8029a0:	8b 04 85 60 70 88 00 	mov    0x887060(,%eax,4),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 08                	je     8029b3 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8029b1:	eb 5a                	jmp    802a0d <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8029b3:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8029ba:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8029bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029c0:	48                   	dec    %eax
  8029c1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029c4:	77 b0                	ja     802976 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8029c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8029cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029d4:	eb 2f                	jmp    802a05 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8029d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d9:	c1 e0 0c             	shl    $0xc,%eax
  8029dc:	89 c2                	mov    %eax,%edx
  8029de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e1:	01 c2                	add    %eax,%edx
  8029e3:	a1 20 70 80 00       	mov    0x807020,%eax
  8029e8:	8b 40 78             	mov    0x78(%eax),%eax
  8029eb:	29 c2                	sub    %eax,%edx
  8029ed:	89 d0                	mov    %edx,%eax
  8029ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029f4:	c1 e8 0c             	shr    $0xc,%eax
  8029f7:	c7 04 85 60 70 88 00 	movl   $0x1,0x887060(,%eax,4)
  8029fe:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  802a02:	ff 45 e0             	incl   -0x20(%ebp)
  802a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a08:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802a0b:	72 c9                	jb     8029d6 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  802a0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a11:	75 16                	jne    802a29 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  802a13:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  802a1a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802a21:	0f 86 15 ff ff ff    	jbe    80293c <malloc+0xdc>
  802a27:	eb 01                	jmp    802a2a <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  802a29:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  802a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2e:	75 07                	jne    802a37 <malloc+0x1d7>
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
  802a35:	eb 46                	jmp    802a7d <malloc+0x21d>
		ptr = (void*)i;
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  802a3d:	a1 20 70 80 00       	mov    0x807020,%eax
  802a42:	8b 40 78             	mov    0x78(%eax),%eax
  802a45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a48:	29 c2                	sub    %eax,%edx
  802a4a:	89 d0                	mov    %edx,%eax
  802a4c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a51:	c1 e8 0c             	shr    $0xc,%eax
  802a54:	89 c2                	mov    %eax,%edx
  802a56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a59:	89 04 95 60 70 90 00 	mov    %eax,0x907060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802a60:	83 ec 08             	sub    $0x8,%esp
  802a63:	ff 75 08             	pushl  0x8(%ebp)
  802a66:	ff 75 f0             	pushl  -0x10(%ebp)
  802a69:	e8 0b 09 00 00       	call   803379 <sys_allocate_user_mem>
  802a6e:	83 c4 10             	add    $0x10,%esp
  802a71:	eb 07                	jmp    802a7a <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	eb 03                	jmp    802a7d <malloc+0x21d>
	}
	return ptr;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
  802a82:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  802a85:	a1 20 70 80 00       	mov    0x807020,%eax
  802a8a:	8b 40 78             	mov    0x78(%eax),%eax
  802a8d:	05 00 10 00 00       	add    $0x1000,%eax
  802a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  802a95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  802a9c:	a1 20 70 80 00       	mov    0x807020,%eax
  802aa1:	8b 50 78             	mov    0x78(%eax),%edx
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	39 c2                	cmp    %eax,%edx
  802aa9:	76 24                	jbe    802acf <free+0x50>
		size = get_block_size(va);
  802aab:	83 ec 0c             	sub    $0xc,%esp
  802aae:	ff 75 08             	pushl  0x8(%ebp)
  802ab1:	e8 df 08 00 00       	call   803395 <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 12 1b 00 00       	call   8045d9 <free_block>
  802ac7:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802aca:	e9 ac 00 00 00       	jmp    802b7b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ad5:	0f 82 89 00 00 00    	jb     802b64 <free+0xe5>
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802ae3:	77 7f                	ja     802b64 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	a1 20 70 80 00       	mov    0x807020,%eax
  802aed:	8b 40 78             	mov    0x78(%eax),%eax
  802af0:	29 c2                	sub    %eax,%edx
  802af2:	89 d0                	mov    %edx,%eax
  802af4:	2d 00 10 00 00       	sub    $0x1000,%eax
  802af9:	c1 e8 0c             	shr    $0xc,%eax
  802afc:	8b 04 85 60 70 90 00 	mov    0x907060(,%eax,4),%eax
  802b03:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b09:	c1 e0 0c             	shl    $0xc,%eax
  802b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  802b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b16:	eb 2f                	jmp    802b47 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	c1 e0 0c             	shl    $0xc,%eax
  802b1e:	89 c2                	mov    %eax,%edx
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	01 c2                	add    %eax,%edx
  802b25:	a1 20 70 80 00       	mov    0x807020,%eax
  802b2a:	8b 40 78             	mov    0x78(%eax),%eax
  802b2d:	29 c2                	sub    %eax,%edx
  802b2f:	89 d0                	mov    %edx,%eax
  802b31:	2d 00 10 00 00       	sub    $0x1000,%eax
  802b36:	c1 e8 0c             	shr    $0xc,%eax
  802b39:	c7 04 85 60 70 88 00 	movl   $0x0,0x887060(,%eax,4)
  802b40:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  802b44:	ff 45 f4             	incl   -0xc(%ebp)
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b4d:	72 c9                	jb     802b18 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	83 ec 08             	sub    $0x8,%esp
  802b55:	ff 75 ec             	pushl  -0x14(%ebp)
  802b58:	50                   	push   %eax
  802b59:	e8 ff 07 00 00       	call   80335d <sys_free_user_mem>
  802b5e:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802b61:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802b62:	eb 17                	jmp    802b7b <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 d8 68 80 00       	push   $0x8068d8
  802b6c:	68 85 00 00 00       	push   $0x85
  802b71:	68 02 69 80 00       	push   $0x806902
  802b76:	e8 78 ec ff ff       	call   8017f3 <_panic>
	}
}
  802b7b:	c9                   	leave  
  802b7c:	c3                   	ret    

00802b7d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802b7d:	55                   	push   %ebp
  802b7e:	89 e5                	mov    %esp,%ebp
  802b80:	83 ec 28             	sub    $0x28,%esp
  802b83:	8b 45 10             	mov    0x10(%ebp),%eax
  802b86:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802b89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b8d:	75 0a                	jne    802b99 <smalloc+0x1c>
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	e9 9a 00 00 00       	jmp    802c33 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	39 d0                	cmp    %edx,%eax
  802bae:	73 02                	jae    802bb2 <smalloc+0x35>
  802bb0:	89 d0                	mov    %edx,%eax
  802bb2:	83 ec 0c             	sub    $0xc,%esp
  802bb5:	50                   	push   %eax
  802bb6:	e8 a5 fc ff ff       	call   802860 <malloc>
  802bbb:	83 c4 10             	add    $0x10,%esp
  802bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc5:	75 07                	jne    802bce <smalloc+0x51>
  802bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcc:	eb 65                	jmp    802c33 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802bce:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802bd2:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd5:	50                   	push   %eax
  802bd6:	ff 75 0c             	pushl  0xc(%ebp)
  802bd9:	ff 75 08             	pushl  0x8(%ebp)
  802bdc:	e8 83 03 00 00       	call   802f64 <sys_createSharedObject>
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802be7:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802beb:	74 06                	je     802bf3 <smalloc+0x76>
  802bed:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802bf1:	75 07                	jne    802bfa <smalloc+0x7d>
  802bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf8:	eb 39                	jmp    802c33 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  802bfa:	83 ec 08             	sub    $0x8,%esp
  802bfd:	ff 75 ec             	pushl  -0x14(%ebp)
  802c00:	68 0e 69 80 00       	push   $0x80690e
  802c05:	e8 a6 ee ff ff       	call   801ab0 <cprintf>
  802c0a:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802c0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c10:	a1 20 70 80 00       	mov    0x807020,%eax
  802c15:	8b 40 78             	mov    0x78(%eax),%eax
  802c18:	29 c2                	sub    %eax,%edx
  802c1a:	89 d0                	mov    %edx,%eax
  802c1c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802c21:	c1 e8 0c             	shr    $0xc,%eax
  802c24:	89 c2                	mov    %eax,%edx
  802c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c29:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	 return ptr;
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802c33:	c9                   	leave  
  802c34:	c3                   	ret    

00802c35 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c35:	55                   	push   %ebp
  802c36:	89 e5                	mov    %esp,%ebp
  802c38:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802c3b:	83 ec 08             	sub    $0x8,%esp
  802c3e:	ff 75 0c             	pushl  0xc(%ebp)
  802c41:	ff 75 08             	pushl  0x8(%ebp)
  802c44:	e8 45 03 00 00       	call   802f8e <sys_getSizeOfSharedObject>
  802c49:	83 c4 10             	add    $0x10,%esp
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802c4f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802c53:	75 07                	jne    802c5c <sget+0x27>
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5a:	eb 5c                	jmp    802cb8 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c62:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	39 d0                	cmp    %edx,%eax
  802c71:	7d 02                	jge    802c75 <sget+0x40>
  802c73:	89 d0                	mov    %edx,%eax
  802c75:	83 ec 0c             	sub    $0xc,%esp
  802c78:	50                   	push   %eax
  802c79:	e8 e2 fb ff ff       	call   802860 <malloc>
  802c7e:	83 c4 10             	add    $0x10,%esp
  802c81:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802c84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c88:	75 07                	jne    802c91 <sget+0x5c>
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	eb 27                	jmp    802cb8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	ff 75 e8             	pushl  -0x18(%ebp)
  802c97:	ff 75 0c             	pushl  0xc(%ebp)
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	e8 09 03 00 00       	call   802fab <sys_getSharedObject>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802ca8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802cac:	75 07                	jne    802cb5 <sget+0x80>
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	eb 03                	jmp    802cb8 <sget+0x83>
	return ptr;
  802cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
  802cbd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc3:	a1 20 70 80 00       	mov    0x807020,%eax
  802cc8:	8b 40 78             	mov    0x78(%eax),%eax
  802ccb:	29 c2                	sub    %eax,%edx
  802ccd:	89 d0                	mov    %edx,%eax
  802ccf:	2d 00 10 00 00       	sub    $0x1000,%eax
  802cd4:	c1 e8 0c             	shr    $0xc,%eax
  802cd7:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
  802cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802ce1:	83 ec 08             	sub    $0x8,%esp
  802ce4:	ff 75 08             	pushl  0x8(%ebp)
  802ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  802cea:	e8 db 02 00 00       	call   802fca <sys_freeSharedObject>
  802cef:	83 c4 10             	add    $0x10,%esp
  802cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802cf5:	90                   	nop
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	68 20 69 80 00       	push   $0x806920
  802d06:	68 dd 00 00 00       	push   $0xdd
  802d0b:	68 02 69 80 00       	push   $0x806902
  802d10:	e8 de ea ff ff       	call   8017f3 <_panic>

00802d15 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
  802d18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	68 46 69 80 00       	push   $0x806946
  802d23:	68 e9 00 00 00       	push   $0xe9
  802d28:	68 02 69 80 00       	push   $0x806902
  802d2d:	e8 c1 ea ff ff       	call   8017f3 <_panic>

00802d32 <shrink>:

}
void shrink(uint32 newSize)
{
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
  802d35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 46 69 80 00       	push   $0x806946
  802d40:	68 ee 00 00 00       	push   $0xee
  802d45:	68 02 69 80 00       	push   $0x806902
  802d4a:	e8 a4 ea ff ff       	call   8017f3 <_panic>

00802d4f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802d4f:	55                   	push   %ebp
  802d50:	89 e5                	mov    %esp,%ebp
  802d52:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	68 46 69 80 00       	push   $0x806946
  802d5d:	68 f3 00 00 00       	push   $0xf3
  802d62:	68 02 69 80 00       	push   $0x806902
  802d67:	e8 87 ea ff ff       	call   8017f3 <_panic>

00802d6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d6c:	55                   	push   %ebp
  802d6d:	89 e5                	mov    %esp,%ebp
  802d6f:	57                   	push   %edi
  802d70:	56                   	push   %esi
  802d71:	53                   	push   %ebx
  802d72:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d81:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d84:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d87:	cd 30                	int    $0x30
  802d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d8f:	83 c4 10             	add    $0x10,%esp
  802d92:	5b                   	pop    %ebx
  802d93:	5e                   	pop    %esi
  802d94:	5f                   	pop    %edi
  802d95:	5d                   	pop    %ebp
  802d96:	c3                   	ret    

00802d97 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  802da0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802da3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	6a 00                	push   $0x0
  802dac:	6a 00                	push   $0x0
  802dae:	52                   	push   %edx
  802daf:	ff 75 0c             	pushl  0xc(%ebp)
  802db2:	50                   	push   %eax
  802db3:	6a 00                	push   $0x0
  802db5:	e8 b2 ff ff ff       	call   802d6c <syscall>
  802dba:	83 c4 18             	add    $0x18,%esp
}
  802dbd:	90                   	nop
  802dbe:	c9                   	leave  
  802dbf:	c3                   	ret    

00802dc0 <sys_cgetc>:

int
sys_cgetc(void)
{
  802dc0:	55                   	push   %ebp
  802dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802dc3:	6a 00                	push   $0x0
  802dc5:	6a 00                	push   $0x0
  802dc7:	6a 00                	push   $0x0
  802dc9:	6a 00                	push   $0x0
  802dcb:	6a 00                	push   $0x0
  802dcd:	6a 02                	push   $0x2
  802dcf:	e8 98 ff ff ff       	call   802d6c <syscall>
  802dd4:	83 c4 18             	add    $0x18,%esp
}
  802dd7:	c9                   	leave  
  802dd8:	c3                   	ret    

00802dd9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	6a 03                	push   $0x3
  802de8:	e8 7f ff ff ff       	call   802d6c <syscall>
  802ded:	83 c4 18             	add    $0x18,%esp
}
  802df0:	90                   	nop
  802df1:	c9                   	leave  
  802df2:	c3                   	ret    

00802df3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 04                	push   $0x4
  802e02:	e8 65 ff ff ff       	call   802d6c <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	90                   	nop
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	52                   	push   %edx
  802e1d:	50                   	push   %eax
  802e1e:	6a 08                	push   $0x8
  802e20:	e8 47 ff ff ff       	call   802d6c <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
  802e2d:	56                   	push   %esi
  802e2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e2f:	8b 75 18             	mov    0x18(%ebp),%esi
  802e32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	56                   	push   %esi
  802e3f:	53                   	push   %ebx
  802e40:	51                   	push   %ecx
  802e41:	52                   	push   %edx
  802e42:	50                   	push   %eax
  802e43:	6a 09                	push   $0x9
  802e45:	e8 22 ff ff ff       	call   802d6c <syscall>
  802e4a:	83 c4 18             	add    $0x18,%esp
}
  802e4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e50:	5b                   	pop    %ebx
  802e51:	5e                   	pop    %esi
  802e52:	5d                   	pop    %ebp
  802e53:	c3                   	ret    

00802e54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	52                   	push   %edx
  802e64:	50                   	push   %eax
  802e65:	6a 0a                	push   $0xa
  802e67:	e8 00 ff ff ff       	call   802d6c <syscall>
  802e6c:	83 c4 18             	add    $0x18,%esp
}
  802e6f:	c9                   	leave  
  802e70:	c3                   	ret    

00802e71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e71:	55                   	push   %ebp
  802e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	ff 75 0c             	pushl  0xc(%ebp)
  802e7d:	ff 75 08             	pushl  0x8(%ebp)
  802e80:	6a 0b                	push   $0xb
  802e82:	e8 e5 fe ff ff       	call   802d6c <syscall>
  802e87:	83 c4 18             	add    $0x18,%esp
}
  802e8a:	c9                   	leave  
  802e8b:	c3                   	ret    

00802e8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e8c:	55                   	push   %ebp
  802e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 0c                	push   $0xc
  802e9b:	e8 cc fe ff ff       	call   802d6c <syscall>
  802ea0:	83 c4 18             	add    $0x18,%esp
}
  802ea3:	c9                   	leave  
  802ea4:	c3                   	ret    

00802ea5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802ea8:	6a 00                	push   $0x0
  802eaa:	6a 00                	push   $0x0
  802eac:	6a 00                	push   $0x0
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 0d                	push   $0xd
  802eb4:	e8 b3 fe ff ff       	call   802d6c <syscall>
  802eb9:	83 c4 18             	add    $0x18,%esp
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 0e                	push   $0xe
  802ecd:	e8 9a fe ff ff       	call   802d6c <syscall>
  802ed2:	83 c4 18             	add    $0x18,%esp
}
  802ed5:	c9                   	leave  
  802ed6:	c3                   	ret    

00802ed7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ed7:	55                   	push   %ebp
  802ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 0f                	push   $0xf
  802ee6:	e8 81 fe ff ff       	call   802d6c <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
}
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	ff 75 08             	pushl  0x8(%ebp)
  802efe:	6a 10                	push   $0x10
  802f00:	e8 67 fe ff ff       	call   802d6c <syscall>
  802f05:	83 c4 18             	add    $0x18,%esp
}
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	6a 11                	push   $0x11
  802f19:	e8 4e fe ff ff       	call   802d6c <syscall>
  802f1e:	83 c4 18             	add    $0x18,%esp
}
  802f21:	90                   	nop
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_cputc>:

void
sys_cputc(const char c)
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	50                   	push   %eax
  802f3d:	6a 01                	push   $0x1
  802f3f:	e8 28 fe ff ff       	call   802d6c <syscall>
  802f44:	83 c4 18             	add    $0x18,%esp
}
  802f47:	90                   	nop
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	6a 14                	push   $0x14
  802f59:	e8 0e fe ff ff       	call   802d6c <syscall>
  802f5e:	83 c4 18             	add    $0x18,%esp
}
  802f61:	90                   	nop
  802f62:	c9                   	leave  
  802f63:	c3                   	ret    

00802f64 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f64:	55                   	push   %ebp
  802f65:	89 e5                	mov    %esp,%ebp
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	6a 00                	push   $0x0
  802f7c:	51                   	push   %ecx
  802f7d:	52                   	push   %edx
  802f7e:	ff 75 0c             	pushl  0xc(%ebp)
  802f81:	50                   	push   %eax
  802f82:	6a 15                	push   $0x15
  802f84:	e8 e3 fd ff ff       	call   802d6c <syscall>
  802f89:	83 c4 18             	add    $0x18,%esp
}
  802f8c:	c9                   	leave  
  802f8d:	c3                   	ret    

00802f8e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	52                   	push   %edx
  802f9e:	50                   	push   %eax
  802f9f:	6a 16                	push   $0x16
  802fa1:	e8 c6 fd ff ff       	call   802d6c <syscall>
  802fa6:	83 c4 18             	add    $0x18,%esp
}
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802fae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	51                   	push   %ecx
  802fbc:	52                   	push   %edx
  802fbd:	50                   	push   %eax
  802fbe:	6a 17                	push   $0x17
  802fc0:	e8 a7 fd ff ff       	call   802d6c <syscall>
  802fc5:	83 c4 18             	add    $0x18,%esp
}
  802fc8:	c9                   	leave  
  802fc9:	c3                   	ret    

00802fca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802fca:	55                   	push   %ebp
  802fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	6a 00                	push   $0x0
  802fd5:	6a 00                	push   $0x0
  802fd7:	6a 00                	push   $0x0
  802fd9:	52                   	push   %edx
  802fda:	50                   	push   %eax
  802fdb:	6a 18                	push   $0x18
  802fdd:	e8 8a fd ff ff       	call   802d6c <syscall>
  802fe2:	83 c4 18             	add    $0x18,%esp
}
  802fe5:	c9                   	leave  
  802fe6:	c3                   	ret    

00802fe7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802fe7:	55                   	push   %ebp
  802fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	6a 00                	push   $0x0
  802fef:	ff 75 14             	pushl  0x14(%ebp)
  802ff2:	ff 75 10             	pushl  0x10(%ebp)
  802ff5:	ff 75 0c             	pushl  0xc(%ebp)
  802ff8:	50                   	push   %eax
  802ff9:	6a 19                	push   $0x19
  802ffb:	e8 6c fd ff ff       	call   802d6c <syscall>
  803000:	83 c4 18             	add    $0x18,%esp
}
  803003:	c9                   	leave  
  803004:	c3                   	ret    

00803005 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803005:	55                   	push   %ebp
  803006:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	50                   	push   %eax
  803014:	6a 1a                	push   $0x1a
  803016:	e8 51 fd ff ff       	call   802d6c <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	90                   	nop
  80301f:	c9                   	leave  
  803020:	c3                   	ret    

00803021 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	6a 00                	push   $0x0
  803029:	6a 00                	push   $0x0
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	50                   	push   %eax
  803030:	6a 1b                	push   $0x1b
  803032:	e8 35 fd ff ff       	call   802d6c <syscall>
  803037:	83 c4 18             	add    $0x18,%esp
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80303f:	6a 00                	push   $0x0
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	6a 05                	push   $0x5
  80304b:	e8 1c fd ff ff       	call   802d6c <syscall>
  803050:	83 c4 18             	add    $0x18,%esp
}
  803053:	c9                   	leave  
  803054:	c3                   	ret    

00803055 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803055:	55                   	push   %ebp
  803056:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 00                	push   $0x0
  803060:	6a 00                	push   $0x0
  803062:	6a 06                	push   $0x6
  803064:	e8 03 fd ff ff       	call   802d6c <syscall>
  803069:	83 c4 18             	add    $0x18,%esp
}
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 07                	push   $0x7
  80307d:	e8 ea fc ff ff       	call   802d6c <syscall>
  803082:	83 c4 18             	add    $0x18,%esp
}
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <sys_exit_env>:


void sys_exit_env(void)
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 1c                	push   $0x1c
  803096:	e8 d1 fc ff ff       	call   802d6c <syscall>
  80309b:	83 c4 18             	add    $0x18,%esp
}
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8030a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030aa:	8d 50 04             	lea    0x4(%eax),%edx
  8030ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030b0:	6a 00                	push   $0x0
  8030b2:	6a 00                	push   $0x0
  8030b4:	6a 00                	push   $0x0
  8030b6:	52                   	push   %edx
  8030b7:	50                   	push   %eax
  8030b8:	6a 1d                	push   $0x1d
  8030ba:	e8 ad fc ff ff       	call   802d6c <syscall>
  8030bf:	83 c4 18             	add    $0x18,%esp
	return result;
  8030c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030cb:	89 01                	mov    %eax,(%ecx)
  8030cd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	c9                   	leave  
  8030d4:	c2 04 00             	ret    $0x4

008030d7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	ff 75 10             	pushl  0x10(%ebp)
  8030e1:	ff 75 0c             	pushl  0xc(%ebp)
  8030e4:	ff 75 08             	pushl  0x8(%ebp)
  8030e7:	6a 13                	push   $0x13
  8030e9:	e8 7e fc ff ff       	call   802d6c <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f1:	90                   	nop
}
  8030f2:	c9                   	leave  
  8030f3:	c3                   	ret    

008030f4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 1e                	push   $0x1e
  803103:	e8 64 fc ff ff       	call   802d6c <syscall>
  803108:	83 c4 18             	add    $0x18,%esp
}
  80310b:	c9                   	leave  
  80310c:	c3                   	ret    

0080310d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80310d:	55                   	push   %ebp
  80310e:	89 e5                	mov    %esp,%ebp
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803119:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	50                   	push   %eax
  803126:	6a 1f                	push   $0x1f
  803128:	e8 3f fc ff ff       	call   802d6c <syscall>
  80312d:	83 c4 18             	add    $0x18,%esp
	return ;
  803130:	90                   	nop
}
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <rsttst>:
void rsttst()
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803136:	6a 00                	push   $0x0
  803138:	6a 00                	push   $0x0
  80313a:	6a 00                	push   $0x0
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	6a 21                	push   $0x21
  803142:	e8 25 fc ff ff       	call   802d6c <syscall>
  803147:	83 c4 18             	add    $0x18,%esp
	return ;
  80314a:	90                   	nop
}
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	8b 45 14             	mov    0x14(%ebp),%eax
  803156:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803159:	8b 55 18             	mov    0x18(%ebp),%edx
  80315c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803160:	52                   	push   %edx
  803161:	50                   	push   %eax
  803162:	ff 75 10             	pushl  0x10(%ebp)
  803165:	ff 75 0c             	pushl  0xc(%ebp)
  803168:	ff 75 08             	pushl  0x8(%ebp)
  80316b:	6a 20                	push   $0x20
  80316d:	e8 fa fb ff ff       	call   802d6c <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
	return ;
  803175:	90                   	nop
}
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <chktst>:
void chktst(uint32 n)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80317b:	6a 00                	push   $0x0
  80317d:	6a 00                	push   $0x0
  80317f:	6a 00                	push   $0x0
  803181:	6a 00                	push   $0x0
  803183:	ff 75 08             	pushl  0x8(%ebp)
  803186:	6a 22                	push   $0x22
  803188:	e8 df fb ff ff       	call   802d6c <syscall>
  80318d:	83 c4 18             	add    $0x18,%esp
	return ;
  803190:	90                   	nop
}
  803191:	c9                   	leave  
  803192:	c3                   	ret    

00803193 <inctst>:

void inctst()
{
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 23                	push   $0x23
  8031a2:	e8 c5 fb ff ff       	call   802d6c <syscall>
  8031a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8031aa:	90                   	nop
}
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <gettst>:
uint32 gettst()
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 24                	push   $0x24
  8031bc:	e8 ab fb ff ff       	call   802d6c <syscall>
  8031c1:	83 c4 18             	add    $0x18,%esp
}
  8031c4:	c9                   	leave  
  8031c5:	c3                   	ret    

008031c6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
  8031c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031cc:	6a 00                	push   $0x0
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 25                	push   $0x25
  8031d8:	e8 8f fb ff ff       	call   802d6c <syscall>
  8031dd:	83 c4 18             	add    $0x18,%esp
  8031e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8031e3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8031e7:	75 07                	jne    8031f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8031e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ee:	eb 05                	jmp    8031f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8031f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8031f7:	55                   	push   %ebp
  8031f8:	89 e5                	mov    %esp,%ebp
  8031fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 00                	push   $0x0
  803201:	6a 00                	push   $0x0
  803203:	6a 00                	push   $0x0
  803205:	6a 00                	push   $0x0
  803207:	6a 25                	push   $0x25
  803209:	e8 5e fb ff ff       	call   802d6c <syscall>
  80320e:	83 c4 18             	add    $0x18,%esp
  803211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803214:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803218:	75 07                	jne    803221 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80321a:	b8 01 00 00 00       	mov    $0x1,%eax
  80321f:	eb 05                	jmp    803226 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803226:	c9                   	leave  
  803227:	c3                   	ret    

00803228 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
  80322b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 25                	push   $0x25
  80323a:	e8 2d fb ff ff       	call   802d6c <syscall>
  80323f:	83 c4 18             	add    $0x18,%esp
  803242:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803245:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803249:	75 07                	jne    803252 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80324b:	b8 01 00 00 00       	mov    $0x1,%eax
  803250:	eb 05                	jmp    803257 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803257:	c9                   	leave  
  803258:	c3                   	ret    

00803259 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
  80325c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 25                	push   $0x25
  80326b:	e8 fc fa ff ff       	call   802d6c <syscall>
  803270:	83 c4 18             	add    $0x18,%esp
  803273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803276:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80327a:	75 07                	jne    803283 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80327c:	b8 01 00 00 00       	mov    $0x1,%eax
  803281:	eb 05                	jmp    803288 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80328d:	6a 00                	push   $0x0
  80328f:	6a 00                	push   $0x0
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	ff 75 08             	pushl  0x8(%ebp)
  803298:	6a 26                	push   $0x26
  80329a:	e8 cd fa ff ff       	call   802d6c <syscall>
  80329f:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a2:	90                   	nop
}
  8032a3:	c9                   	leave  
  8032a4:	c3                   	ret    

008032a5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032a5:	55                   	push   %ebp
  8032a6:	89 e5                	mov    %esp,%ebp
  8032a8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	6a 00                	push   $0x0
  8032b7:	53                   	push   %ebx
  8032b8:	51                   	push   %ecx
  8032b9:	52                   	push   %edx
  8032ba:	50                   	push   %eax
  8032bb:	6a 27                	push   $0x27
  8032bd:	e8 aa fa ff ff       	call   802d6c <syscall>
  8032c2:	83 c4 18             	add    $0x18,%esp
}
  8032c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032c8:	c9                   	leave  
  8032c9:	c3                   	ret    

008032ca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 00                	push   $0x0
  8032d9:	52                   	push   %edx
  8032da:	50                   	push   %eax
  8032db:	6a 28                	push   $0x28
  8032dd:	e8 8a fa ff ff       	call   802d6c <syscall>
  8032e2:	83 c4 18             	add    $0x18,%esp
}
  8032e5:	c9                   	leave  
  8032e6:	c3                   	ret    

008032e7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032e7:	55                   	push   %ebp
  8032e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	6a 00                	push   $0x0
  8032f5:	51                   	push   %ecx
  8032f6:	ff 75 10             	pushl  0x10(%ebp)
  8032f9:	52                   	push   %edx
  8032fa:	50                   	push   %eax
  8032fb:	6a 29                	push   $0x29
  8032fd:	e8 6a fa ff ff       	call   802d6c <syscall>
  803302:	83 c4 18             	add    $0x18,%esp
}
  803305:	c9                   	leave  
  803306:	c3                   	ret    

00803307 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803307:	55                   	push   %ebp
  803308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	ff 75 10             	pushl  0x10(%ebp)
  803311:	ff 75 0c             	pushl  0xc(%ebp)
  803314:	ff 75 08             	pushl  0x8(%ebp)
  803317:	6a 12                	push   $0x12
  803319:	e8 4e fa ff ff       	call   802d6c <syscall>
  80331e:	83 c4 18             	add    $0x18,%esp
	return ;
  803321:	90                   	nop
}
  803322:	c9                   	leave  
  803323:	c3                   	ret    

00803324 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803324:	55                   	push   %ebp
  803325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	6a 00                	push   $0x0
  803333:	52                   	push   %edx
  803334:	50                   	push   %eax
  803335:	6a 2a                	push   $0x2a
  803337:	e8 30 fa ff ff       	call   802d6c <syscall>
  80333c:	83 c4 18             	add    $0x18,%esp
	return;
  80333f:	90                   	nop
}
  803340:	c9                   	leave  
  803341:	c3                   	ret    

00803342 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803342:	55                   	push   %ebp
  803343:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	50                   	push   %eax
  803351:	6a 2b                	push   $0x2b
  803353:	e8 14 fa ff ff       	call   802d6c <syscall>
  803358:	83 c4 18             	add    $0x18,%esp
}
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	ff 75 0c             	pushl  0xc(%ebp)
  803369:	ff 75 08             	pushl  0x8(%ebp)
  80336c:	6a 2c                	push   $0x2c
  80336e:	e8 f9 f9 ff ff       	call   802d6c <syscall>
  803373:	83 c4 18             	add    $0x18,%esp
	return;
  803376:	90                   	nop
}
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	ff 75 0c             	pushl  0xc(%ebp)
  803385:	ff 75 08             	pushl  0x8(%ebp)
  803388:	6a 2d                	push   $0x2d
  80338a:	e8 dd f9 ff ff       	call   802d6c <syscall>
  80338f:	83 c4 18             	add    $0x18,%esp
	return;
  803392:	90                   	nop
}
  803393:	c9                   	leave  
  803394:	c3                   	ret    

00803395 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803395:	55                   	push   %ebp
  803396:	89 e5                	mov    %esp,%ebp
  803398:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	83 e8 04             	sub    $0x4,%eax
  8033a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8033a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8033ac:	c9                   	leave  
  8033ad:	c3                   	ret    

008033ae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8033ae:	55                   	push   %ebp
  8033af:	89 e5                	mov    %esp,%ebp
  8033b1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	83 e8 04             	sub    $0x4,%eax
  8033ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8033bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	83 e0 01             	and    $0x1,%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	0f 94 c0             	sete   %al
}
  8033ca:	c9                   	leave  
  8033cb:	c3                   	ret    

008033cc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8033cc:	55                   	push   %ebp
  8033cd:	89 e5                	mov    %esp,%ebp
  8033cf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8033d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8033d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dc:	83 f8 02             	cmp    $0x2,%eax
  8033df:	74 2b                	je     80340c <alloc_block+0x40>
  8033e1:	83 f8 02             	cmp    $0x2,%eax
  8033e4:	7f 07                	jg     8033ed <alloc_block+0x21>
  8033e6:	83 f8 01             	cmp    $0x1,%eax
  8033e9:	74 0e                	je     8033f9 <alloc_block+0x2d>
  8033eb:	eb 58                	jmp    803445 <alloc_block+0x79>
  8033ed:	83 f8 03             	cmp    $0x3,%eax
  8033f0:	74 2d                	je     80341f <alloc_block+0x53>
  8033f2:	83 f8 04             	cmp    $0x4,%eax
  8033f5:	74 3b                	je     803432 <alloc_block+0x66>
  8033f7:	eb 4c                	jmp    803445 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8033f9:	83 ec 0c             	sub    $0xc,%esp
  8033fc:	ff 75 08             	pushl  0x8(%ebp)
  8033ff:	e8 11 03 00 00       	call   803715 <alloc_block_FF>
  803404:	83 c4 10             	add    $0x10,%esp
  803407:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80340a:	eb 4a                	jmp    803456 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80340c:	83 ec 0c             	sub    $0xc,%esp
  80340f:	ff 75 08             	pushl  0x8(%ebp)
  803412:	e8 fa 19 00 00       	call   804e11 <alloc_block_NF>
  803417:	83 c4 10             	add    $0x10,%esp
  80341a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80341d:	eb 37                	jmp    803456 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80341f:	83 ec 0c             	sub    $0xc,%esp
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 a7 07 00 00       	call   803bd1 <alloc_block_BF>
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803430:	eb 24                	jmp    803456 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803432:	83 ec 0c             	sub    $0xc,%esp
  803435:	ff 75 08             	pushl  0x8(%ebp)
  803438:	e8 b7 19 00 00       	call   804df4 <alloc_block_WF>
  80343d:	83 c4 10             	add    $0x10,%esp
  803440:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803443:	eb 11                	jmp    803456 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803445:	83 ec 0c             	sub    $0xc,%esp
  803448:	68 58 69 80 00       	push   $0x806958
  80344d:	e8 5e e6 ff ff       	call   801ab0 <cprintf>
  803452:	83 c4 10             	add    $0x10,%esp
		break;
  803455:	90                   	nop
	}
	return va;
  803456:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803459:	c9                   	leave  
  80345a:	c3                   	ret    

0080345b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80345b:	55                   	push   %ebp
  80345c:	89 e5                	mov    %esp,%ebp
  80345e:	53                   	push   %ebx
  80345f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803462:	83 ec 0c             	sub    $0xc,%esp
  803465:	68 78 69 80 00       	push   $0x806978
  80346a:	e8 41 e6 ff ff       	call   801ab0 <cprintf>
  80346f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803472:	83 ec 0c             	sub    $0xc,%esp
  803475:	68 a3 69 80 00       	push   $0x8069a3
  80347a:	e8 31 e6 ff ff       	call   801ab0 <cprintf>
  80347f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803488:	eb 37                	jmp    8034c1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80348a:	83 ec 0c             	sub    $0xc,%esp
  80348d:	ff 75 f4             	pushl  -0xc(%ebp)
  803490:	e8 19 ff ff ff       	call   8033ae <is_free_block>
  803495:	83 c4 10             	add    $0x10,%esp
  803498:	0f be d8             	movsbl %al,%ebx
  80349b:	83 ec 0c             	sub    $0xc,%esp
  80349e:	ff 75 f4             	pushl  -0xc(%ebp)
  8034a1:	e8 ef fe ff ff       	call   803395 <get_block_size>
  8034a6:	83 c4 10             	add    $0x10,%esp
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	53                   	push   %ebx
  8034ad:	50                   	push   %eax
  8034ae:	68 bb 69 80 00       	push   $0x8069bb
  8034b3:	e8 f8 e5 ff ff       	call   801ab0 <cprintf>
  8034b8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8034bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	74 07                	je     8034ce <print_blocks_list+0x73>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	eb 05                	jmp    8034d3 <print_blocks_list+0x78>
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	89 45 10             	mov    %eax,0x10(%ebp)
  8034d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	75 ad                	jne    80348a <print_blocks_list+0x2f>
  8034dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e1:	75 a7                	jne    80348a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8034e3:	83 ec 0c             	sub    $0xc,%esp
  8034e6:	68 78 69 80 00       	push   $0x806978
  8034eb:	e8 c0 e5 ff ff       	call   801ab0 <cprintf>
  8034f0:	83 c4 10             	add    $0x10,%esp

}
  8034f3:	90                   	nop
  8034f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034f7:	c9                   	leave  
  8034f8:	c3                   	ret    

008034f9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8034f9:	55                   	push   %ebp
  8034fa:	89 e5                	mov    %esp,%ebp
  8034fc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8034ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803502:	83 e0 01             	and    $0x1,%eax
  803505:	85 c0                	test   %eax,%eax
  803507:	74 03                	je     80350c <initialize_dynamic_allocator+0x13>
  803509:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80350c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803510:	0f 84 c7 01 00 00    	je     8036dd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  803516:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  80351d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  803520:	8b 55 08             	mov    0x8(%ebp),%edx
  803523:	8b 45 0c             	mov    0xc(%ebp),%eax
  803526:	01 d0                	add    %edx,%eax
  803528:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80352d:	0f 87 ad 01 00 00    	ja     8036e0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	0f 89 a5 01 00 00    	jns    8036e3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	8b 45 0c             	mov    0xc(%ebp),%eax
  803544:	01 d0                	add    %edx,%eax
  803546:	83 e8 04             	sub    $0x4,%eax
  803549:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  80354e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  803555:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80355a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80355d:	e9 87 00 00 00       	jmp    8035e9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803566:	75 14                	jne    80357c <initialize_dynamic_allocator+0x83>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 d3 69 80 00       	push   $0x8069d3
  803570:	6a 79                	push   $0x79
  803572:	68 f1 69 80 00       	push   $0x8069f1
  803577:	e8 77 e2 ff ff       	call   8017f3 <_panic>
  80357c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	74 10                	je     803595 <initialize_dynamic_allocator+0x9c>
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 00                	mov    (%eax),%eax
  80358a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80358d:	8b 52 04             	mov    0x4(%edx),%edx
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	eb 0b                	jmp    8035a0 <initialize_dynamic_allocator+0xa7>
  803595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803598:	8b 40 04             	mov    0x4(%eax),%eax
  80359b:	a3 30 70 80 00       	mov    %eax,0x807030
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	74 0f                	je     8035b9 <initialize_dynamic_allocator+0xc0>
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 40 04             	mov    0x4(%eax),%eax
  8035b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b3:	8b 12                	mov    (%edx),%edx
  8035b5:	89 10                	mov    %edx,(%eax)
  8035b7:	eb 0a                	jmp    8035c3 <initialize_dynamic_allocator+0xca>
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d6:	a1 38 70 80 00       	mov    0x807038,%eax
  8035db:	48                   	dec    %eax
  8035dc:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8035e1:	a1 34 70 80 00       	mov    0x807034,%eax
  8035e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ed:	74 07                	je     8035f6 <initialize_dynamic_allocator+0xfd>
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	eb 05                	jmp    8035fb <initialize_dynamic_allocator+0x102>
  8035f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fb:	a3 34 70 80 00       	mov    %eax,0x807034
  803600:	a1 34 70 80 00       	mov    0x807034,%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	0f 85 55 ff ff ff    	jne    803562 <initialize_dynamic_allocator+0x69>
  80360d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803611:	0f 85 4b ff ff ff    	jne    803562 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80361d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803620:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803626:	a1 44 70 80 00       	mov    0x807044,%eax
  80362b:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  803630:	a1 40 70 80 00       	mov    0x807040,%eax
  803635:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	83 c0 08             	add    $0x8,%eax
  803641:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	83 c0 04             	add    $0x4,%eax
  80364a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80364d:	83 ea 08             	sub    $0x8,%edx
  803650:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803652:	8b 55 0c             	mov    0xc(%ebp),%edx
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	01 d0                	add    %edx,%eax
  80365a:	83 e8 08             	sub    $0x8,%eax
  80365d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803660:	83 ea 08             	sub    $0x8,%edx
  803663:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  803678:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80367c:	75 17                	jne    803695 <initialize_dynamic_allocator+0x19c>
  80367e:	83 ec 04             	sub    $0x4,%esp
  803681:	68 0c 6a 80 00       	push   $0x806a0c
  803686:	68 90 00 00 00       	push   $0x90
  80368b:	68 f1 69 80 00       	push   $0x8069f1
  803690:	e8 5e e1 ff ff       	call   8017f3 <_panic>
  803695:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  80369b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369e:	89 10                	mov    %edx,(%eax)
  8036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 0d                	je     8036b6 <initialize_dynamic_allocator+0x1bd>
  8036a9:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8036ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b1:	89 50 04             	mov    %edx,0x4(%eax)
  8036b4:	eb 08                	jmp    8036be <initialize_dynamic_allocator+0x1c5>
  8036b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b9:	a3 30 70 80 00       	mov    %eax,0x807030
  8036be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c1:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8036c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d0:	a1 38 70 80 00       	mov    0x807038,%eax
  8036d5:	40                   	inc    %eax
  8036d6:	a3 38 70 80 00       	mov    %eax,0x807038
  8036db:	eb 07                	jmp    8036e4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8036dd:	90                   	nop
  8036de:	eb 04                	jmp    8036e4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8036e0:	90                   	nop
  8036e1:	eb 01                	jmp    8036e4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8036e3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8036e4:	c9                   	leave  
  8036e5:	c3                   	ret    

008036e6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8036e6:	55                   	push   %ebp
  8036e7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8036e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ec:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8036f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	83 e8 04             	sub    $0x4,%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	83 e0 fe             	and    $0xfffffffe,%eax
  803705:	8d 50 f8             	lea    -0x8(%eax),%edx
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	01 c2                	add    %eax,%edx
  80370d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803710:	89 02                	mov    %eax,(%edx)
}
  803712:	90                   	nop
  803713:	5d                   	pop    %ebp
  803714:	c3                   	ret    

00803715 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803715:	55                   	push   %ebp
  803716:	89 e5                	mov    %esp,%ebp
  803718:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	83 e0 01             	and    $0x1,%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 03                	je     803728 <alloc_block_FF+0x13>
  803725:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803728:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80372c:	77 07                	ja     803735 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80372e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803735:	a1 24 70 80 00       	mov    0x807024,%eax
  80373a:	85 c0                	test   %eax,%eax
  80373c:	75 73                	jne    8037b1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	83 c0 10             	add    $0x10,%eax
  803744:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803747:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80374e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	01 d0                	add    %edx,%eax
  803756:	48                   	dec    %eax
  803757:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80375a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375d:	ba 00 00 00 00       	mov    $0x0,%edx
  803762:	f7 75 ec             	divl   -0x14(%ebp)
  803765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803768:	29 d0                	sub    %edx,%eax
  80376a:	c1 e8 0c             	shr    $0xc,%eax
  80376d:	83 ec 0c             	sub    $0xc,%esp
  803770:	50                   	push   %eax
  803771:	e8 d4 f0 ff ff       	call   80284a <sbrk>
  803776:	83 c4 10             	add    $0x10,%esp
  803779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80377c:	83 ec 0c             	sub    $0xc,%esp
  80377f:	6a 00                	push   $0x0
  803781:	e8 c4 f0 ff ff       	call   80284a <sbrk>
  803786:	83 c4 10             	add    $0x10,%esp
  803789:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80378c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80378f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803792:	83 ec 08             	sub    $0x8,%esp
  803795:	50                   	push   %eax
  803796:	ff 75 e4             	pushl  -0x1c(%ebp)
  803799:	e8 5b fd ff ff       	call   8034f9 <initialize_dynamic_allocator>
  80379e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8037a1:	83 ec 0c             	sub    $0xc,%esp
  8037a4:	68 2f 6a 80 00       	push   $0x806a2f
  8037a9:	e8 02 e3 ff ff       	call   801ab0 <cprintf>
  8037ae:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8037b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b5:	75 0a                	jne    8037c1 <alloc_block_FF+0xac>
	        return NULL;
  8037b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bc:	e9 0e 04 00 00       	jmp    803bcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8037c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8037c8:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8037cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d0:	e9 f3 02 00 00       	jmp    803ac8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8037d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8037db:	83 ec 0c             	sub    $0xc,%esp
  8037de:	ff 75 bc             	pushl  -0x44(%ebp)
  8037e1:	e8 af fb ff ff       	call   803395 <get_block_size>
  8037e6:	83 c4 10             	add    $0x10,%esp
  8037e9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	83 c0 08             	add    $0x8,%eax
  8037f2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8037f5:	0f 87 c5 02 00 00    	ja     803ac0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	83 c0 18             	add    $0x18,%eax
  803801:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803804:	0f 87 19 02 00 00    	ja     803a23 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80380a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80380d:	2b 45 08             	sub    0x8(%ebp),%eax
  803810:	83 e8 08             	sub    $0x8,%eax
  803813:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	8d 50 08             	lea    0x8(%eax),%edx
  80381c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80381f:	01 d0                	add    %edx,%eax
  803821:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	83 c0 08             	add    $0x8,%eax
  80382a:	83 ec 04             	sub    $0x4,%esp
  80382d:	6a 01                	push   $0x1
  80382f:	50                   	push   %eax
  803830:	ff 75 bc             	pushl  -0x44(%ebp)
  803833:	e8 ae fe ff ff       	call   8036e6 <set_block_data>
  803838:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	75 68                	jne    8038ad <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803845:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803849:	75 17                	jne    803862 <alloc_block_FF+0x14d>
  80384b:	83 ec 04             	sub    $0x4,%esp
  80384e:	68 0c 6a 80 00       	push   $0x806a0c
  803853:	68 d7 00 00 00       	push   $0xd7
  803858:	68 f1 69 80 00       	push   $0x8069f1
  80385d:	e8 91 df ff ff       	call   8017f3 <_panic>
  803862:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803868:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80386b:	89 10                	mov    %edx,(%eax)
  80386d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803870:	8b 00                	mov    (%eax),%eax
  803872:	85 c0                	test   %eax,%eax
  803874:	74 0d                	je     803883 <alloc_block_FF+0x16e>
  803876:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80387b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80387e:	89 50 04             	mov    %edx,0x4(%eax)
  803881:	eb 08                	jmp    80388b <alloc_block_FF+0x176>
  803883:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803886:	a3 30 70 80 00       	mov    %eax,0x807030
  80388b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80388e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803893:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389d:	a1 38 70 80 00       	mov    0x807038,%eax
  8038a2:	40                   	inc    %eax
  8038a3:	a3 38 70 80 00       	mov    %eax,0x807038
  8038a8:	e9 dc 00 00 00       	jmp    803989 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8038ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b0:	8b 00                	mov    (%eax),%eax
  8038b2:	85 c0                	test   %eax,%eax
  8038b4:	75 65                	jne    80391b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8038b6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8038ba:	75 17                	jne    8038d3 <alloc_block_FF+0x1be>
  8038bc:	83 ec 04             	sub    $0x4,%esp
  8038bf:	68 40 6a 80 00       	push   $0x806a40
  8038c4:	68 db 00 00 00       	push   $0xdb
  8038c9:	68 f1 69 80 00       	push   $0x8069f1
  8038ce:	e8 20 df ff ff       	call   8017f3 <_panic>
  8038d3:	8b 15 30 70 80 00    	mov    0x807030,%edx
  8038d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038e2:	8b 40 04             	mov    0x4(%eax),%eax
  8038e5:	85 c0                	test   %eax,%eax
  8038e7:	74 0c                	je     8038f5 <alloc_block_FF+0x1e0>
  8038e9:	a1 30 70 80 00       	mov    0x807030,%eax
  8038ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038f1:	89 10                	mov    %edx,(%eax)
  8038f3:	eb 08                	jmp    8038fd <alloc_block_FF+0x1e8>
  8038f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038f8:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8038fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803900:	a3 30 70 80 00       	mov    %eax,0x807030
  803905:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390e:	a1 38 70 80 00       	mov    0x807038,%eax
  803913:	40                   	inc    %eax
  803914:	a3 38 70 80 00       	mov    %eax,0x807038
  803919:	eb 6e                	jmp    803989 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80391b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80391f:	74 06                	je     803927 <alloc_block_FF+0x212>
  803921:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803925:	75 17                	jne    80393e <alloc_block_FF+0x229>
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	68 64 6a 80 00       	push   $0x806a64
  80392f:	68 df 00 00 00       	push   $0xdf
  803934:	68 f1 69 80 00       	push   $0x8069f1
  803939:	e8 b5 de ff ff       	call   8017f3 <_panic>
  80393e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803941:	8b 10                	mov    (%eax),%edx
  803943:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803946:	89 10                	mov    %edx,(%eax)
  803948:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80394b:	8b 00                	mov    (%eax),%eax
  80394d:	85 c0                	test   %eax,%eax
  80394f:	74 0b                	je     80395c <alloc_block_FF+0x247>
  803951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803959:	89 50 04             	mov    %edx,0x4(%eax)
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803962:	89 10                	mov    %edx,(%eax)
  803964:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80396a:	89 50 04             	mov    %edx,0x4(%eax)
  80396d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	75 08                	jne    80397e <alloc_block_FF+0x269>
  803976:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803979:	a3 30 70 80 00       	mov    %eax,0x807030
  80397e:	a1 38 70 80 00       	mov    0x807038,%eax
  803983:	40                   	inc    %eax
  803984:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398d:	75 17                	jne    8039a6 <alloc_block_FF+0x291>
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	68 d3 69 80 00       	push   $0x8069d3
  803997:	68 e1 00 00 00       	push   $0xe1
  80399c:	68 f1 69 80 00       	push   $0x8069f1
  8039a1:	e8 4d de ff ff       	call   8017f3 <_panic>
  8039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	74 10                	je     8039bf <alloc_block_FF+0x2aa>
  8039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b7:	8b 52 04             	mov    0x4(%edx),%edx
  8039ba:	89 50 04             	mov    %edx,0x4(%eax)
  8039bd:	eb 0b                	jmp    8039ca <alloc_block_FF+0x2b5>
  8039bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c2:	8b 40 04             	mov    0x4(%eax),%eax
  8039c5:	a3 30 70 80 00       	mov    %eax,0x807030
  8039ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	85 c0                	test   %eax,%eax
  8039d2:	74 0f                	je     8039e3 <alloc_block_FF+0x2ce>
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039dd:	8b 12                	mov    (%edx),%edx
  8039df:	89 10                	mov    %edx,(%eax)
  8039e1:	eb 0a                	jmp    8039ed <alloc_block_FF+0x2d8>
  8039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a00:	a1 38 70 80 00       	mov    0x807038,%eax
  803a05:	48                   	dec    %eax
  803a06:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	6a 00                	push   $0x0
  803a10:	ff 75 b4             	pushl  -0x4c(%ebp)
  803a13:	ff 75 b0             	pushl  -0x50(%ebp)
  803a16:	e8 cb fc ff ff       	call   8036e6 <set_block_data>
  803a1b:	83 c4 10             	add    $0x10,%esp
  803a1e:	e9 95 00 00 00       	jmp    803ab8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	6a 01                	push   $0x1
  803a28:	ff 75 b8             	pushl  -0x48(%ebp)
  803a2b:	ff 75 bc             	pushl  -0x44(%ebp)
  803a2e:	e8 b3 fc ff ff       	call   8036e6 <set_block_data>
  803a33:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3a:	75 17                	jne    803a53 <alloc_block_FF+0x33e>
  803a3c:	83 ec 04             	sub    $0x4,%esp
  803a3f:	68 d3 69 80 00       	push   $0x8069d3
  803a44:	68 e8 00 00 00       	push   $0xe8
  803a49:	68 f1 69 80 00       	push   $0x8069f1
  803a4e:	e8 a0 dd ff ff       	call   8017f3 <_panic>
  803a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a56:	8b 00                	mov    (%eax),%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	74 10                	je     803a6c <alloc_block_FF+0x357>
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a64:	8b 52 04             	mov    0x4(%edx),%edx
  803a67:	89 50 04             	mov    %edx,0x4(%eax)
  803a6a:	eb 0b                	jmp    803a77 <alloc_block_FF+0x362>
  803a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6f:	8b 40 04             	mov    0x4(%eax),%eax
  803a72:	a3 30 70 80 00       	mov    %eax,0x807030
  803a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7a:	8b 40 04             	mov    0x4(%eax),%eax
  803a7d:	85 c0                	test   %eax,%eax
  803a7f:	74 0f                	je     803a90 <alloc_block_FF+0x37b>
  803a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a84:	8b 40 04             	mov    0x4(%eax),%eax
  803a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a8a:	8b 12                	mov    (%edx),%edx
  803a8c:	89 10                	mov    %edx,(%eax)
  803a8e:	eb 0a                	jmp    803a9a <alloc_block_FF+0x385>
  803a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aad:	a1 38 70 80 00       	mov    0x807038,%eax
  803ab2:	48                   	dec    %eax
  803ab3:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  803ab8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803abb:	e9 0f 01 00 00       	jmp    803bcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803ac0:	a1 34 70 80 00       	mov    0x807034,%eax
  803ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803acc:	74 07                	je     803ad5 <alloc_block_FF+0x3c0>
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	eb 05                	jmp    803ada <alloc_block_FF+0x3c5>
  803ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  803ada:	a3 34 70 80 00       	mov    %eax,0x807034
  803adf:	a1 34 70 80 00       	mov    0x807034,%eax
  803ae4:	85 c0                	test   %eax,%eax
  803ae6:	0f 85 e9 fc ff ff    	jne    8037d5 <alloc_block_FF+0xc0>
  803aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af0:	0f 85 df fc ff ff    	jne    8037d5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	83 c0 08             	add    $0x8,%eax
  803afc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803aff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803b06:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b0c:	01 d0                	add    %edx,%eax
  803b0e:	48                   	dec    %eax
  803b0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803b12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b15:	ba 00 00 00 00       	mov    $0x0,%edx
  803b1a:	f7 75 d8             	divl   -0x28(%ebp)
  803b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b20:	29 d0                	sub    %edx,%eax
  803b22:	c1 e8 0c             	shr    $0xc,%eax
  803b25:	83 ec 0c             	sub    $0xc,%esp
  803b28:	50                   	push   %eax
  803b29:	e8 1c ed ff ff       	call   80284a <sbrk>
  803b2e:	83 c4 10             	add    $0x10,%esp
  803b31:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803b34:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803b38:	75 0a                	jne    803b44 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3f:	e9 8b 00 00 00       	jmp    803bcf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803b44:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803b4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b51:	01 d0                	add    %edx,%eax
  803b53:	48                   	dec    %eax
  803b54:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803b57:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b5f:	f7 75 cc             	divl   -0x34(%ebp)
  803b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b65:	29 d0                	sub    %edx,%eax
  803b67:	8d 50 fc             	lea    -0x4(%eax),%edx
  803b6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b6d:	01 d0                	add    %edx,%eax
  803b6f:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  803b74:	a1 40 70 80 00       	mov    0x807040,%eax
  803b79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803b7f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803b86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b8c:	01 d0                	add    %edx,%eax
  803b8e:	48                   	dec    %eax
  803b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803b92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b95:	ba 00 00 00 00       	mov    $0x0,%edx
  803b9a:	f7 75 c4             	divl   -0x3c(%ebp)
  803b9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ba0:	29 d0                	sub    %edx,%eax
  803ba2:	83 ec 04             	sub    $0x4,%esp
  803ba5:	6a 01                	push   $0x1
  803ba7:	50                   	push   %eax
  803ba8:	ff 75 d0             	pushl  -0x30(%ebp)
  803bab:	e8 36 fb ff ff       	call   8036e6 <set_block_data>
  803bb0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803bb3:	83 ec 0c             	sub    $0xc,%esp
  803bb6:	ff 75 d0             	pushl  -0x30(%ebp)
  803bb9:	e8 1b 0a 00 00       	call   8045d9 <free_block>
  803bbe:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803bc1:	83 ec 0c             	sub    $0xc,%esp
  803bc4:	ff 75 08             	pushl  0x8(%ebp)
  803bc7:	e8 49 fb ff ff       	call   803715 <alloc_block_FF>
  803bcc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803bcf:	c9                   	leave  
  803bd0:	c3                   	ret    

00803bd1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803bd1:	55                   	push   %ebp
  803bd2:	89 e5                	mov    %esp,%ebp
  803bd4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bda:	83 e0 01             	and    $0x1,%eax
  803bdd:	85 c0                	test   %eax,%eax
  803bdf:	74 03                	je     803be4 <alloc_block_BF+0x13>
  803be1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803be4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803be8:	77 07                	ja     803bf1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803bea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803bf1:	a1 24 70 80 00       	mov    0x807024,%eax
  803bf6:	85 c0                	test   %eax,%eax
  803bf8:	75 73                	jne    803c6d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfd:	83 c0 10             	add    $0x10,%eax
  803c00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803c03:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803c0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c10:	01 d0                	add    %edx,%eax
  803c12:	48                   	dec    %eax
  803c13:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c19:	ba 00 00 00 00       	mov    $0x0,%edx
  803c1e:	f7 75 e0             	divl   -0x20(%ebp)
  803c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c24:	29 d0                	sub    %edx,%eax
  803c26:	c1 e8 0c             	shr    $0xc,%eax
  803c29:	83 ec 0c             	sub    $0xc,%esp
  803c2c:	50                   	push   %eax
  803c2d:	e8 18 ec ff ff       	call   80284a <sbrk>
  803c32:	83 c4 10             	add    $0x10,%esp
  803c35:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803c38:	83 ec 0c             	sub    $0xc,%esp
  803c3b:	6a 00                	push   $0x0
  803c3d:	e8 08 ec ff ff       	call   80284a <sbrk>
  803c42:	83 c4 10             	add    $0x10,%esp
  803c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803c4e:	83 ec 08             	sub    $0x8,%esp
  803c51:	50                   	push   %eax
  803c52:	ff 75 d8             	pushl  -0x28(%ebp)
  803c55:	e8 9f f8 ff ff       	call   8034f9 <initialize_dynamic_allocator>
  803c5a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803c5d:	83 ec 0c             	sub    $0xc,%esp
  803c60:	68 2f 6a 80 00       	push   $0x806a2f
  803c65:	e8 46 de ff ff       	call   801ab0 <cprintf>
  803c6a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803c7b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803c82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803c89:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c91:	e9 1d 01 00 00       	jmp    803db3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c99:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803c9c:	83 ec 0c             	sub    $0xc,%esp
  803c9f:	ff 75 a8             	pushl  -0x58(%ebp)
  803ca2:	e8 ee f6 ff ff       	call   803395 <get_block_size>
  803ca7:	83 c4 10             	add    $0x10,%esp
  803caa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803cad:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb0:	83 c0 08             	add    $0x8,%eax
  803cb3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803cb6:	0f 87 ef 00 00 00    	ja     803dab <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbf:	83 c0 18             	add    $0x18,%eax
  803cc2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803cc5:	77 1d                	ja     803ce4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ccd:	0f 86 d8 00 00 00    	jbe    803dab <alloc_block_BF+0x1da>
				{
					best_va = va;
  803cd3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803cd9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803cdf:	e9 c7 00 00 00       	jmp    803dab <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce7:	83 c0 08             	add    $0x8,%eax
  803cea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ced:	0f 85 9d 00 00 00    	jne    803d90 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803cf3:	83 ec 04             	sub    $0x4,%esp
  803cf6:	6a 01                	push   $0x1
  803cf8:	ff 75 a4             	pushl  -0x5c(%ebp)
  803cfb:	ff 75 a8             	pushl  -0x58(%ebp)
  803cfe:	e8 e3 f9 ff ff       	call   8036e6 <set_block_data>
  803d03:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d0a:	75 17                	jne    803d23 <alloc_block_BF+0x152>
  803d0c:	83 ec 04             	sub    $0x4,%esp
  803d0f:	68 d3 69 80 00       	push   $0x8069d3
  803d14:	68 2c 01 00 00       	push   $0x12c
  803d19:	68 f1 69 80 00       	push   $0x8069f1
  803d1e:	e8 d0 da ff ff       	call   8017f3 <_panic>
  803d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 10                	je     803d3c <alloc_block_BF+0x16b>
  803d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d34:	8b 52 04             	mov    0x4(%edx),%edx
  803d37:	89 50 04             	mov    %edx,0x4(%eax)
  803d3a:	eb 0b                	jmp    803d47 <alloc_block_BF+0x176>
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	8b 40 04             	mov    0x4(%eax),%eax
  803d42:	a3 30 70 80 00       	mov    %eax,0x807030
  803d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4a:	8b 40 04             	mov    0x4(%eax),%eax
  803d4d:	85 c0                	test   %eax,%eax
  803d4f:	74 0f                	je     803d60 <alloc_block_BF+0x18f>
  803d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d54:	8b 40 04             	mov    0x4(%eax),%eax
  803d57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d5a:	8b 12                	mov    (%edx),%edx
  803d5c:	89 10                	mov    %edx,(%eax)
  803d5e:	eb 0a                	jmp    803d6a <alloc_block_BF+0x199>
  803d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d63:	8b 00                	mov    (%eax),%eax
  803d65:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d7d:	a1 38 70 80 00       	mov    0x807038,%eax
  803d82:	48                   	dec    %eax
  803d83:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  803d88:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d8b:	e9 24 04 00 00       	jmp    8041b4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d93:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803d96:	76 13                	jbe    803dab <alloc_block_BF+0x1da>
					{
						internal = 1;
  803d98:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803d9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803da5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803da8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803dab:	a1 34 70 80 00       	mov    0x807034,%eax
  803db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db7:	74 07                	je     803dc0 <alloc_block_BF+0x1ef>
  803db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbc:	8b 00                	mov    (%eax),%eax
  803dbe:	eb 05                	jmp    803dc5 <alloc_block_BF+0x1f4>
  803dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc5:	a3 34 70 80 00       	mov    %eax,0x807034
  803dca:	a1 34 70 80 00       	mov    0x807034,%eax
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	0f 85 bf fe ff ff    	jne    803c96 <alloc_block_BF+0xc5>
  803dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ddb:	0f 85 b5 fe ff ff    	jne    803c96 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803de5:	0f 84 26 02 00 00    	je     804011 <alloc_block_BF+0x440>
  803deb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803def:	0f 85 1c 02 00 00    	jne    804011 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df8:	2b 45 08             	sub    0x8(%ebp),%eax
  803dfb:	83 e8 08             	sub    $0x8,%eax
  803dfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803e01:	8b 45 08             	mov    0x8(%ebp),%eax
  803e04:	8d 50 08             	lea    0x8(%eax),%edx
  803e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0a:	01 d0                	add    %edx,%eax
  803e0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e12:	83 c0 08             	add    $0x8,%eax
  803e15:	83 ec 04             	sub    $0x4,%esp
  803e18:	6a 01                	push   $0x1
  803e1a:	50                   	push   %eax
  803e1b:	ff 75 f0             	pushl  -0x10(%ebp)
  803e1e:	e8 c3 f8 ff ff       	call   8036e6 <set_block_data>
  803e23:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e29:	8b 40 04             	mov    0x4(%eax),%eax
  803e2c:	85 c0                	test   %eax,%eax
  803e2e:	75 68                	jne    803e98 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803e30:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e34:	75 17                	jne    803e4d <alloc_block_BF+0x27c>
  803e36:	83 ec 04             	sub    $0x4,%esp
  803e39:	68 0c 6a 80 00       	push   $0x806a0c
  803e3e:	68 45 01 00 00       	push   $0x145
  803e43:	68 f1 69 80 00       	push   $0x8069f1
  803e48:	e8 a6 d9 ff ff       	call   8017f3 <_panic>
  803e4d:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803e53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e56:	89 10                	mov    %edx,(%eax)
  803e58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e5b:	8b 00                	mov    (%eax),%eax
  803e5d:	85 c0                	test   %eax,%eax
  803e5f:	74 0d                	je     803e6e <alloc_block_BF+0x29d>
  803e61:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803e66:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e69:	89 50 04             	mov    %edx,0x4(%eax)
  803e6c:	eb 08                	jmp    803e76 <alloc_block_BF+0x2a5>
  803e6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e71:	a3 30 70 80 00       	mov    %eax,0x807030
  803e76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e79:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e88:	a1 38 70 80 00       	mov    0x807038,%eax
  803e8d:	40                   	inc    %eax
  803e8e:	a3 38 70 80 00       	mov    %eax,0x807038
  803e93:	e9 dc 00 00 00       	jmp    803f74 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e9b:	8b 00                	mov    (%eax),%eax
  803e9d:	85 c0                	test   %eax,%eax
  803e9f:	75 65                	jne    803f06 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803ea1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803ea5:	75 17                	jne    803ebe <alloc_block_BF+0x2ed>
  803ea7:	83 ec 04             	sub    $0x4,%esp
  803eaa:	68 40 6a 80 00       	push   $0x806a40
  803eaf:	68 4a 01 00 00       	push   $0x14a
  803eb4:	68 f1 69 80 00       	push   $0x8069f1
  803eb9:	e8 35 d9 ff ff       	call   8017f3 <_panic>
  803ebe:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803ec4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ec7:	89 50 04             	mov    %edx,0x4(%eax)
  803eca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ecd:	8b 40 04             	mov    0x4(%eax),%eax
  803ed0:	85 c0                	test   %eax,%eax
  803ed2:	74 0c                	je     803ee0 <alloc_block_BF+0x30f>
  803ed4:	a1 30 70 80 00       	mov    0x807030,%eax
  803ed9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803edc:	89 10                	mov    %edx,(%eax)
  803ede:	eb 08                	jmp    803ee8 <alloc_block_BF+0x317>
  803ee0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ee3:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803ee8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803eeb:	a3 30 70 80 00       	mov    %eax,0x807030
  803ef0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef9:	a1 38 70 80 00       	mov    0x807038,%eax
  803efe:	40                   	inc    %eax
  803eff:	a3 38 70 80 00       	mov    %eax,0x807038
  803f04:	eb 6e                	jmp    803f74 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f0a:	74 06                	je     803f12 <alloc_block_BF+0x341>
  803f0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f10:	75 17                	jne    803f29 <alloc_block_BF+0x358>
  803f12:	83 ec 04             	sub    $0x4,%esp
  803f15:	68 64 6a 80 00       	push   $0x806a64
  803f1a:	68 4f 01 00 00       	push   $0x14f
  803f1f:	68 f1 69 80 00       	push   $0x8069f1
  803f24:	e8 ca d8 ff ff       	call   8017f3 <_panic>
  803f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2c:	8b 10                	mov    (%eax),%edx
  803f2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f31:	89 10                	mov    %edx,(%eax)
  803f33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f36:	8b 00                	mov    (%eax),%eax
  803f38:	85 c0                	test   %eax,%eax
  803f3a:	74 0b                	je     803f47 <alloc_block_BF+0x376>
  803f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3f:	8b 00                	mov    (%eax),%eax
  803f41:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f44:	89 50 04             	mov    %edx,0x4(%eax)
  803f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f4d:	89 10                	mov    %edx,(%eax)
  803f4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f55:	89 50 04             	mov    %edx,0x4(%eax)
  803f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	85 c0                	test   %eax,%eax
  803f5f:	75 08                	jne    803f69 <alloc_block_BF+0x398>
  803f61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f64:	a3 30 70 80 00       	mov    %eax,0x807030
  803f69:	a1 38 70 80 00       	mov    0x807038,%eax
  803f6e:	40                   	inc    %eax
  803f6f:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803f74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f78:	75 17                	jne    803f91 <alloc_block_BF+0x3c0>
  803f7a:	83 ec 04             	sub    $0x4,%esp
  803f7d:	68 d3 69 80 00       	push   $0x8069d3
  803f82:	68 51 01 00 00       	push   $0x151
  803f87:	68 f1 69 80 00       	push   $0x8069f1
  803f8c:	e8 62 d8 ff ff       	call   8017f3 <_panic>
  803f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f94:	8b 00                	mov    (%eax),%eax
  803f96:	85 c0                	test   %eax,%eax
  803f98:	74 10                	je     803faa <alloc_block_BF+0x3d9>
  803f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9d:	8b 00                	mov    (%eax),%eax
  803f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fa2:	8b 52 04             	mov    0x4(%edx),%edx
  803fa5:	89 50 04             	mov    %edx,0x4(%eax)
  803fa8:	eb 0b                	jmp    803fb5 <alloc_block_BF+0x3e4>
  803faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fad:	8b 40 04             	mov    0x4(%eax),%eax
  803fb0:	a3 30 70 80 00       	mov    %eax,0x807030
  803fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb8:	8b 40 04             	mov    0x4(%eax),%eax
  803fbb:	85 c0                	test   %eax,%eax
  803fbd:	74 0f                	je     803fce <alloc_block_BF+0x3fd>
  803fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc2:	8b 40 04             	mov    0x4(%eax),%eax
  803fc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc8:	8b 12                	mov    (%edx),%edx
  803fca:	89 10                	mov    %edx,(%eax)
  803fcc:	eb 0a                	jmp    803fd8 <alloc_block_BF+0x407>
  803fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd1:	8b 00                	mov    (%eax),%eax
  803fd3:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803feb:	a1 38 70 80 00       	mov    0x807038,%eax
  803ff0:	48                   	dec    %eax
  803ff1:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  803ff6:	83 ec 04             	sub    $0x4,%esp
  803ff9:	6a 00                	push   $0x0
  803ffb:	ff 75 d0             	pushl  -0x30(%ebp)
  803ffe:	ff 75 cc             	pushl  -0x34(%ebp)
  804001:	e8 e0 f6 ff ff       	call   8036e6 <set_block_data>
  804006:	83 c4 10             	add    $0x10,%esp
			return best_va;
  804009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400c:	e9 a3 01 00 00       	jmp    8041b4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  804011:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  804015:	0f 85 9d 00 00 00    	jne    8040b8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80401b:	83 ec 04             	sub    $0x4,%esp
  80401e:	6a 01                	push   $0x1
  804020:	ff 75 ec             	pushl  -0x14(%ebp)
  804023:	ff 75 f0             	pushl  -0x10(%ebp)
  804026:	e8 bb f6 ff ff       	call   8036e6 <set_block_data>
  80402b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80402e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804032:	75 17                	jne    80404b <alloc_block_BF+0x47a>
  804034:	83 ec 04             	sub    $0x4,%esp
  804037:	68 d3 69 80 00       	push   $0x8069d3
  80403c:	68 58 01 00 00       	push   $0x158
  804041:	68 f1 69 80 00       	push   $0x8069f1
  804046:	e8 a8 d7 ff ff       	call   8017f3 <_panic>
  80404b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404e:	8b 00                	mov    (%eax),%eax
  804050:	85 c0                	test   %eax,%eax
  804052:	74 10                	je     804064 <alloc_block_BF+0x493>
  804054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804057:	8b 00                	mov    (%eax),%eax
  804059:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80405c:	8b 52 04             	mov    0x4(%edx),%edx
  80405f:	89 50 04             	mov    %edx,0x4(%eax)
  804062:	eb 0b                	jmp    80406f <alloc_block_BF+0x49e>
  804064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804067:	8b 40 04             	mov    0x4(%eax),%eax
  80406a:	a3 30 70 80 00       	mov    %eax,0x807030
  80406f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804072:	8b 40 04             	mov    0x4(%eax),%eax
  804075:	85 c0                	test   %eax,%eax
  804077:	74 0f                	je     804088 <alloc_block_BF+0x4b7>
  804079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407c:	8b 40 04             	mov    0x4(%eax),%eax
  80407f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804082:	8b 12                	mov    (%edx),%edx
  804084:	89 10                	mov    %edx,(%eax)
  804086:	eb 0a                	jmp    804092 <alloc_block_BF+0x4c1>
  804088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80408b:	8b 00                	mov    (%eax),%eax
  80408d:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040a5:	a1 38 70 80 00       	mov    0x807038,%eax
  8040aa:	48                   	dec    %eax
  8040ab:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  8040b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b3:	e9 fc 00 00 00       	jmp    8041b4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8040b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bb:	83 c0 08             	add    $0x8,%eax
  8040be:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8040c1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8040c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040ce:	01 d0                	add    %edx,%eax
  8040d0:	48                   	dec    %eax
  8040d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8040d4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8040d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8040dc:	f7 75 c4             	divl   -0x3c(%ebp)
  8040df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8040e2:	29 d0                	sub    %edx,%eax
  8040e4:	c1 e8 0c             	shr    $0xc,%eax
  8040e7:	83 ec 0c             	sub    $0xc,%esp
  8040ea:	50                   	push   %eax
  8040eb:	e8 5a e7 ff ff       	call   80284a <sbrk>
  8040f0:	83 c4 10             	add    $0x10,%esp
  8040f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8040f6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8040fa:	75 0a                	jne    804106 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8040fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804101:	e9 ae 00 00 00       	jmp    8041b4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  804106:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80410d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804110:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804113:	01 d0                	add    %edx,%eax
  804115:	48                   	dec    %eax
  804116:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  804119:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80411c:	ba 00 00 00 00       	mov    $0x0,%edx
  804121:	f7 75 b8             	divl   -0x48(%ebp)
  804124:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  804127:	29 d0                	sub    %edx,%eax
  804129:	8d 50 fc             	lea    -0x4(%eax),%edx
  80412c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80412f:	01 d0                	add    %edx,%eax
  804131:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  804136:	a1 40 70 80 00       	mov    0x807040,%eax
  80413b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  804141:	83 ec 0c             	sub    $0xc,%esp
  804144:	68 98 6a 80 00       	push   $0x806a98
  804149:	e8 62 d9 ff ff       	call   801ab0 <cprintf>
  80414e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  804151:	83 ec 08             	sub    $0x8,%esp
  804154:	ff 75 bc             	pushl  -0x44(%ebp)
  804157:	68 9d 6a 80 00       	push   $0x806a9d
  80415c:	e8 4f d9 ff ff       	call   801ab0 <cprintf>
  804161:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  804164:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80416b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80416e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  804171:	01 d0                	add    %edx,%eax
  804173:	48                   	dec    %eax
  804174:	89 45 ac             	mov    %eax,-0x54(%ebp)
  804177:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80417a:	ba 00 00 00 00       	mov    $0x0,%edx
  80417f:	f7 75 b0             	divl   -0x50(%ebp)
  804182:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804185:	29 d0                	sub    %edx,%eax
  804187:	83 ec 04             	sub    $0x4,%esp
  80418a:	6a 01                	push   $0x1
  80418c:	50                   	push   %eax
  80418d:	ff 75 bc             	pushl  -0x44(%ebp)
  804190:	e8 51 f5 ff ff       	call   8036e6 <set_block_data>
  804195:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  804198:	83 ec 0c             	sub    $0xc,%esp
  80419b:	ff 75 bc             	pushl  -0x44(%ebp)
  80419e:	e8 36 04 00 00       	call   8045d9 <free_block>
  8041a3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8041a6:	83 ec 0c             	sub    $0xc,%esp
  8041a9:	ff 75 08             	pushl  0x8(%ebp)
  8041ac:	e8 20 fa ff ff       	call   803bd1 <alloc_block_BF>
  8041b1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8041b4:	c9                   	leave  
  8041b5:	c3                   	ret    

008041b6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8041b6:	55                   	push   %ebp
  8041b7:	89 e5                	mov    %esp,%ebp
  8041b9:	53                   	push   %ebx
  8041ba:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8041bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8041c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8041cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041cf:	74 1e                	je     8041ef <merging+0x39>
  8041d1:	ff 75 08             	pushl  0x8(%ebp)
  8041d4:	e8 bc f1 ff ff       	call   803395 <get_block_size>
  8041d9:	83 c4 04             	add    $0x4,%esp
  8041dc:	89 c2                	mov    %eax,%edx
  8041de:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e1:	01 d0                	add    %edx,%eax
  8041e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8041e6:	75 07                	jne    8041ef <merging+0x39>
		prev_is_free = 1;
  8041e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8041ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041f3:	74 1e                	je     804213 <merging+0x5d>
  8041f5:	ff 75 10             	pushl  0x10(%ebp)
  8041f8:	e8 98 f1 ff ff       	call   803395 <get_block_size>
  8041fd:	83 c4 04             	add    $0x4,%esp
  804200:	89 c2                	mov    %eax,%edx
  804202:	8b 45 10             	mov    0x10(%ebp),%eax
  804205:	01 d0                	add    %edx,%eax
  804207:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80420a:	75 07                	jne    804213 <merging+0x5d>
		next_is_free = 1;
  80420c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  804213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804217:	0f 84 cc 00 00 00    	je     8042e9 <merging+0x133>
  80421d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804221:	0f 84 c2 00 00 00    	je     8042e9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  804227:	ff 75 08             	pushl  0x8(%ebp)
  80422a:	e8 66 f1 ff ff       	call   803395 <get_block_size>
  80422f:	83 c4 04             	add    $0x4,%esp
  804232:	89 c3                	mov    %eax,%ebx
  804234:	ff 75 10             	pushl  0x10(%ebp)
  804237:	e8 59 f1 ff ff       	call   803395 <get_block_size>
  80423c:	83 c4 04             	add    $0x4,%esp
  80423f:	01 c3                	add    %eax,%ebx
  804241:	ff 75 0c             	pushl  0xc(%ebp)
  804244:	e8 4c f1 ff ff       	call   803395 <get_block_size>
  804249:	83 c4 04             	add    $0x4,%esp
  80424c:	01 d8                	add    %ebx,%eax
  80424e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804251:	6a 00                	push   $0x0
  804253:	ff 75 ec             	pushl  -0x14(%ebp)
  804256:	ff 75 08             	pushl  0x8(%ebp)
  804259:	e8 88 f4 ff ff       	call   8036e6 <set_block_data>
  80425e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  804261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804265:	75 17                	jne    80427e <merging+0xc8>
  804267:	83 ec 04             	sub    $0x4,%esp
  80426a:	68 d3 69 80 00       	push   $0x8069d3
  80426f:	68 7d 01 00 00       	push   $0x17d
  804274:	68 f1 69 80 00       	push   $0x8069f1
  804279:	e8 75 d5 ff ff       	call   8017f3 <_panic>
  80427e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804281:	8b 00                	mov    (%eax),%eax
  804283:	85 c0                	test   %eax,%eax
  804285:	74 10                	je     804297 <merging+0xe1>
  804287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80428a:	8b 00                	mov    (%eax),%eax
  80428c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80428f:	8b 52 04             	mov    0x4(%edx),%edx
  804292:	89 50 04             	mov    %edx,0x4(%eax)
  804295:	eb 0b                	jmp    8042a2 <merging+0xec>
  804297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80429a:	8b 40 04             	mov    0x4(%eax),%eax
  80429d:	a3 30 70 80 00       	mov    %eax,0x807030
  8042a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042a5:	8b 40 04             	mov    0x4(%eax),%eax
  8042a8:	85 c0                	test   %eax,%eax
  8042aa:	74 0f                	je     8042bb <merging+0x105>
  8042ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042af:	8b 40 04             	mov    0x4(%eax),%eax
  8042b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042b5:	8b 12                	mov    (%edx),%edx
  8042b7:	89 10                	mov    %edx,(%eax)
  8042b9:	eb 0a                	jmp    8042c5 <merging+0x10f>
  8042bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042be:	8b 00                	mov    (%eax),%eax
  8042c0:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8042c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042d8:	a1 38 70 80 00       	mov    0x807038,%eax
  8042dd:	48                   	dec    %eax
  8042de:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8042e3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8042e4:	e9 ea 02 00 00       	jmp    8045d3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8042e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ed:	74 3b                	je     80432a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8042ef:	83 ec 0c             	sub    $0xc,%esp
  8042f2:	ff 75 08             	pushl  0x8(%ebp)
  8042f5:	e8 9b f0 ff ff       	call   803395 <get_block_size>
  8042fa:	83 c4 10             	add    $0x10,%esp
  8042fd:	89 c3                	mov    %eax,%ebx
  8042ff:	83 ec 0c             	sub    $0xc,%esp
  804302:	ff 75 10             	pushl  0x10(%ebp)
  804305:	e8 8b f0 ff ff       	call   803395 <get_block_size>
  80430a:	83 c4 10             	add    $0x10,%esp
  80430d:	01 d8                	add    %ebx,%eax
  80430f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804312:	83 ec 04             	sub    $0x4,%esp
  804315:	6a 00                	push   $0x0
  804317:	ff 75 e8             	pushl  -0x18(%ebp)
  80431a:	ff 75 08             	pushl  0x8(%ebp)
  80431d:	e8 c4 f3 ff ff       	call   8036e6 <set_block_data>
  804322:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804325:	e9 a9 02 00 00       	jmp    8045d3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80432a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80432e:	0f 84 2d 01 00 00    	je     804461 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  804334:	83 ec 0c             	sub    $0xc,%esp
  804337:	ff 75 10             	pushl  0x10(%ebp)
  80433a:	e8 56 f0 ff ff       	call   803395 <get_block_size>
  80433f:	83 c4 10             	add    $0x10,%esp
  804342:	89 c3                	mov    %eax,%ebx
  804344:	83 ec 0c             	sub    $0xc,%esp
  804347:	ff 75 0c             	pushl  0xc(%ebp)
  80434a:	e8 46 f0 ff ff       	call   803395 <get_block_size>
  80434f:	83 c4 10             	add    $0x10,%esp
  804352:	01 d8                	add    %ebx,%eax
  804354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  804357:	83 ec 04             	sub    $0x4,%esp
  80435a:	6a 00                	push   $0x0
  80435c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80435f:	ff 75 10             	pushl  0x10(%ebp)
  804362:	e8 7f f3 ff ff       	call   8036e6 <set_block_data>
  804367:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80436a:	8b 45 10             	mov    0x10(%ebp),%eax
  80436d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  804370:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804374:	74 06                	je     80437c <merging+0x1c6>
  804376:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80437a:	75 17                	jne    804393 <merging+0x1dd>
  80437c:	83 ec 04             	sub    $0x4,%esp
  80437f:	68 ac 6a 80 00       	push   $0x806aac
  804384:	68 8d 01 00 00       	push   $0x18d
  804389:	68 f1 69 80 00       	push   $0x8069f1
  80438e:	e8 60 d4 ff ff       	call   8017f3 <_panic>
  804393:	8b 45 0c             	mov    0xc(%ebp),%eax
  804396:	8b 50 04             	mov    0x4(%eax),%edx
  804399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80439c:	89 50 04             	mov    %edx,0x4(%eax)
  80439f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043a5:	89 10                	mov    %edx,(%eax)
  8043a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043aa:	8b 40 04             	mov    0x4(%eax),%eax
  8043ad:	85 c0                	test   %eax,%eax
  8043af:	74 0d                	je     8043be <merging+0x208>
  8043b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043b4:	8b 40 04             	mov    0x4(%eax),%eax
  8043b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043ba:	89 10                	mov    %edx,(%eax)
  8043bc:	eb 08                	jmp    8043c6 <merging+0x210>
  8043be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c1:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8043c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043cc:	89 50 04             	mov    %edx,0x4(%eax)
  8043cf:	a1 38 70 80 00       	mov    0x807038,%eax
  8043d4:	40                   	inc    %eax
  8043d5:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  8043da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8043de:	75 17                	jne    8043f7 <merging+0x241>
  8043e0:	83 ec 04             	sub    $0x4,%esp
  8043e3:	68 d3 69 80 00       	push   $0x8069d3
  8043e8:	68 8e 01 00 00       	push   $0x18e
  8043ed:	68 f1 69 80 00       	push   $0x8069f1
  8043f2:	e8 fc d3 ff ff       	call   8017f3 <_panic>
  8043f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043fa:	8b 00                	mov    (%eax),%eax
  8043fc:	85 c0                	test   %eax,%eax
  8043fe:	74 10                	je     804410 <merging+0x25a>
  804400:	8b 45 0c             	mov    0xc(%ebp),%eax
  804403:	8b 00                	mov    (%eax),%eax
  804405:	8b 55 0c             	mov    0xc(%ebp),%edx
  804408:	8b 52 04             	mov    0x4(%edx),%edx
  80440b:	89 50 04             	mov    %edx,0x4(%eax)
  80440e:	eb 0b                	jmp    80441b <merging+0x265>
  804410:	8b 45 0c             	mov    0xc(%ebp),%eax
  804413:	8b 40 04             	mov    0x4(%eax),%eax
  804416:	a3 30 70 80 00       	mov    %eax,0x807030
  80441b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80441e:	8b 40 04             	mov    0x4(%eax),%eax
  804421:	85 c0                	test   %eax,%eax
  804423:	74 0f                	je     804434 <merging+0x27e>
  804425:	8b 45 0c             	mov    0xc(%ebp),%eax
  804428:	8b 40 04             	mov    0x4(%eax),%eax
  80442b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80442e:	8b 12                	mov    (%edx),%edx
  804430:	89 10                	mov    %edx,(%eax)
  804432:	eb 0a                	jmp    80443e <merging+0x288>
  804434:	8b 45 0c             	mov    0xc(%ebp),%eax
  804437:	8b 00                	mov    (%eax),%eax
  804439:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80443e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80444a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804451:	a1 38 70 80 00       	mov    0x807038,%eax
  804456:	48                   	dec    %eax
  804457:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80445c:	e9 72 01 00 00       	jmp    8045d3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  804461:	8b 45 10             	mov    0x10(%ebp),%eax
  804464:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  804467:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80446b:	74 79                	je     8044e6 <merging+0x330>
  80446d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804471:	74 73                	je     8044e6 <merging+0x330>
  804473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804477:	74 06                	je     80447f <merging+0x2c9>
  804479:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80447d:	75 17                	jne    804496 <merging+0x2e0>
  80447f:	83 ec 04             	sub    $0x4,%esp
  804482:	68 64 6a 80 00       	push   $0x806a64
  804487:	68 94 01 00 00       	push   $0x194
  80448c:	68 f1 69 80 00       	push   $0x8069f1
  804491:	e8 5d d3 ff ff       	call   8017f3 <_panic>
  804496:	8b 45 08             	mov    0x8(%ebp),%eax
  804499:	8b 10                	mov    (%eax),%edx
  80449b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80449e:	89 10                	mov    %edx,(%eax)
  8044a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044a3:	8b 00                	mov    (%eax),%eax
  8044a5:	85 c0                	test   %eax,%eax
  8044a7:	74 0b                	je     8044b4 <merging+0x2fe>
  8044a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ac:	8b 00                	mov    (%eax),%eax
  8044ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044b1:	89 50 04             	mov    %edx,0x4(%eax)
  8044b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044ba:	89 10                	mov    %edx,(%eax)
  8044bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8044c2:	89 50 04             	mov    %edx,0x4(%eax)
  8044c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c8:	8b 00                	mov    (%eax),%eax
  8044ca:	85 c0                	test   %eax,%eax
  8044cc:	75 08                	jne    8044d6 <merging+0x320>
  8044ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044d1:	a3 30 70 80 00       	mov    %eax,0x807030
  8044d6:	a1 38 70 80 00       	mov    0x807038,%eax
  8044db:	40                   	inc    %eax
  8044dc:	a3 38 70 80 00       	mov    %eax,0x807038
  8044e1:	e9 ce 00 00 00       	jmp    8045b4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8044e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044ea:	74 65                	je     804551 <merging+0x39b>
  8044ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8044f0:	75 17                	jne    804509 <merging+0x353>
  8044f2:	83 ec 04             	sub    $0x4,%esp
  8044f5:	68 40 6a 80 00       	push   $0x806a40
  8044fa:	68 95 01 00 00       	push   $0x195
  8044ff:	68 f1 69 80 00       	push   $0x8069f1
  804504:	e8 ea d2 ff ff       	call   8017f3 <_panic>
  804509:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80450f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804512:	89 50 04             	mov    %edx,0x4(%eax)
  804515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804518:	8b 40 04             	mov    0x4(%eax),%eax
  80451b:	85 c0                	test   %eax,%eax
  80451d:	74 0c                	je     80452b <merging+0x375>
  80451f:	a1 30 70 80 00       	mov    0x807030,%eax
  804524:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804527:	89 10                	mov    %edx,(%eax)
  804529:	eb 08                	jmp    804533 <merging+0x37d>
  80452b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80452e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804533:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804536:	a3 30 70 80 00       	mov    %eax,0x807030
  80453b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80453e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804544:	a1 38 70 80 00       	mov    0x807038,%eax
  804549:	40                   	inc    %eax
  80454a:	a3 38 70 80 00       	mov    %eax,0x807038
  80454f:	eb 63                	jmp    8045b4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  804551:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804555:	75 17                	jne    80456e <merging+0x3b8>
  804557:	83 ec 04             	sub    $0x4,%esp
  80455a:	68 0c 6a 80 00       	push   $0x806a0c
  80455f:	68 98 01 00 00       	push   $0x198
  804564:	68 f1 69 80 00       	push   $0x8069f1
  804569:	e8 85 d2 ff ff       	call   8017f3 <_panic>
  80456e:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  804574:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804577:	89 10                	mov    %edx,(%eax)
  804579:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80457c:	8b 00                	mov    (%eax),%eax
  80457e:	85 c0                	test   %eax,%eax
  804580:	74 0d                	je     80458f <merging+0x3d9>
  804582:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804587:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80458a:	89 50 04             	mov    %edx,0x4(%eax)
  80458d:	eb 08                	jmp    804597 <merging+0x3e1>
  80458f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804592:	a3 30 70 80 00       	mov    %eax,0x807030
  804597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80459a:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80459f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045a9:	a1 38 70 80 00       	mov    0x807038,%eax
  8045ae:	40                   	inc    %eax
  8045af:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  8045b4:	83 ec 0c             	sub    $0xc,%esp
  8045b7:	ff 75 10             	pushl  0x10(%ebp)
  8045ba:	e8 d6 ed ff ff       	call   803395 <get_block_size>
  8045bf:	83 c4 10             	add    $0x10,%esp
  8045c2:	83 ec 04             	sub    $0x4,%esp
  8045c5:	6a 00                	push   $0x0
  8045c7:	50                   	push   %eax
  8045c8:	ff 75 10             	pushl  0x10(%ebp)
  8045cb:	e8 16 f1 ff ff       	call   8036e6 <set_block_data>
  8045d0:	83 c4 10             	add    $0x10,%esp
	}
}
  8045d3:	90                   	nop
  8045d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8045d7:	c9                   	leave  
  8045d8:	c3                   	ret    

008045d9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8045d9:	55                   	push   %ebp
  8045da:	89 e5                	mov    %esp,%ebp
  8045dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8045df:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8045e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8045e7:	a1 30 70 80 00       	mov    0x807030,%eax
  8045ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8045ef:	73 1b                	jae    80460c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8045f1:	a1 30 70 80 00       	mov    0x807030,%eax
  8045f6:	83 ec 04             	sub    $0x4,%esp
  8045f9:	ff 75 08             	pushl  0x8(%ebp)
  8045fc:	6a 00                	push   $0x0
  8045fe:	50                   	push   %eax
  8045ff:	e8 b2 fb ff ff       	call   8041b6 <merging>
  804604:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804607:	e9 8b 00 00 00       	jmp    804697 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80460c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804611:	3b 45 08             	cmp    0x8(%ebp),%eax
  804614:	76 18                	jbe    80462e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804616:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80461b:	83 ec 04             	sub    $0x4,%esp
  80461e:	ff 75 08             	pushl  0x8(%ebp)
  804621:	50                   	push   %eax
  804622:	6a 00                	push   $0x0
  804624:	e8 8d fb ff ff       	call   8041b6 <merging>
  804629:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80462c:	eb 69                	jmp    804697 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80462e:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804636:	eb 39                	jmp    804671 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  804638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80463b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80463e:	73 29                	jae    804669 <free_block+0x90>
  804640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804643:	8b 00                	mov    (%eax),%eax
  804645:	3b 45 08             	cmp    0x8(%ebp),%eax
  804648:	76 1f                	jbe    804669 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80464a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80464d:	8b 00                	mov    (%eax),%eax
  80464f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804652:	83 ec 04             	sub    $0x4,%esp
  804655:	ff 75 08             	pushl  0x8(%ebp)
  804658:	ff 75 f0             	pushl  -0x10(%ebp)
  80465b:	ff 75 f4             	pushl  -0xc(%ebp)
  80465e:	e8 53 fb ff ff       	call   8041b6 <merging>
  804663:	83 c4 10             	add    $0x10,%esp
			break;
  804666:	90                   	nop
		}
	}
}
  804667:	eb 2e                	jmp    804697 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804669:	a1 34 70 80 00       	mov    0x807034,%eax
  80466e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804675:	74 07                	je     80467e <free_block+0xa5>
  804677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80467a:	8b 00                	mov    (%eax),%eax
  80467c:	eb 05                	jmp    804683 <free_block+0xaa>
  80467e:	b8 00 00 00 00       	mov    $0x0,%eax
  804683:	a3 34 70 80 00       	mov    %eax,0x807034
  804688:	a1 34 70 80 00       	mov    0x807034,%eax
  80468d:	85 c0                	test   %eax,%eax
  80468f:	75 a7                	jne    804638 <free_block+0x5f>
  804691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804695:	75 a1                	jne    804638 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804697:	90                   	nop
  804698:	c9                   	leave  
  804699:	c3                   	ret    

0080469a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80469a:	55                   	push   %ebp
  80469b:	89 e5                	mov    %esp,%ebp
  80469d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8046a0:	ff 75 08             	pushl  0x8(%ebp)
  8046a3:	e8 ed ec ff ff       	call   803395 <get_block_size>
  8046a8:	83 c4 04             	add    $0x4,%esp
  8046ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8046ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8046b5:	eb 17                	jmp    8046ce <copy_data+0x34>
  8046b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8046ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046bd:	01 c2                	add    %eax,%edx
  8046bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8046c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046c5:	01 c8                	add    %ecx,%eax
  8046c7:	8a 00                	mov    (%eax),%al
  8046c9:	88 02                	mov    %al,(%edx)
  8046cb:	ff 45 fc             	incl   -0x4(%ebp)
  8046ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8046d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8046d4:	72 e1                	jb     8046b7 <copy_data+0x1d>
}
  8046d6:	90                   	nop
  8046d7:	c9                   	leave  
  8046d8:	c3                   	ret    

008046d9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8046d9:	55                   	push   %ebp
  8046da:	89 e5                	mov    %esp,%ebp
  8046dc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8046df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8046e3:	75 23                	jne    804708 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8046e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8046e9:	74 13                	je     8046fe <realloc_block_FF+0x25>
  8046eb:	83 ec 0c             	sub    $0xc,%esp
  8046ee:	ff 75 0c             	pushl  0xc(%ebp)
  8046f1:	e8 1f f0 ff ff       	call   803715 <alloc_block_FF>
  8046f6:	83 c4 10             	add    $0x10,%esp
  8046f9:	e9 f4 06 00 00       	jmp    804df2 <realloc_block_FF+0x719>
		return NULL;
  8046fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804703:	e9 ea 06 00 00       	jmp    804df2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  804708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80470c:	75 18                	jne    804726 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80470e:	83 ec 0c             	sub    $0xc,%esp
  804711:	ff 75 08             	pushl  0x8(%ebp)
  804714:	e8 c0 fe ff ff       	call   8045d9 <free_block>
  804719:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80471c:	b8 00 00 00 00       	mov    $0x0,%eax
  804721:	e9 cc 06 00 00       	jmp    804df2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  804726:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80472a:	77 07                	ja     804733 <realloc_block_FF+0x5a>
  80472c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804733:	8b 45 0c             	mov    0xc(%ebp),%eax
  804736:	83 e0 01             	and    $0x1,%eax
  804739:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80473c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80473f:	83 c0 08             	add    $0x8,%eax
  804742:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804745:	83 ec 0c             	sub    $0xc,%esp
  804748:	ff 75 08             	pushl  0x8(%ebp)
  80474b:	e8 45 ec ff ff       	call   803395 <get_block_size>
  804750:	83 c4 10             	add    $0x10,%esp
  804753:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804759:	83 e8 08             	sub    $0x8,%eax
  80475c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80475f:	8b 45 08             	mov    0x8(%ebp),%eax
  804762:	83 e8 04             	sub    $0x4,%eax
  804765:	8b 00                	mov    (%eax),%eax
  804767:	83 e0 fe             	and    $0xfffffffe,%eax
  80476a:	89 c2                	mov    %eax,%edx
  80476c:	8b 45 08             	mov    0x8(%ebp),%eax
  80476f:	01 d0                	add    %edx,%eax
  804771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804774:	83 ec 0c             	sub    $0xc,%esp
  804777:	ff 75 e4             	pushl  -0x1c(%ebp)
  80477a:	e8 16 ec ff ff       	call   803395 <get_block_size>
  80477f:	83 c4 10             	add    $0x10,%esp
  804782:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804788:	83 e8 08             	sub    $0x8,%eax
  80478b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80478e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804791:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804794:	75 08                	jne    80479e <realloc_block_FF+0xc5>
	{
		 return va;
  804796:	8b 45 08             	mov    0x8(%ebp),%eax
  804799:	e9 54 06 00 00       	jmp    804df2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80479e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8047a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8047a4:	0f 83 e5 03 00 00    	jae    804b8f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8047aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8047b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8047b3:	83 ec 0c             	sub    $0xc,%esp
  8047b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8047b9:	e8 f0 eb ff ff       	call   8033ae <is_free_block>
  8047be:	83 c4 10             	add    $0x10,%esp
  8047c1:	84 c0                	test   %al,%al
  8047c3:	0f 84 3b 01 00 00    	je     804904 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8047c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8047cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8047cf:	01 d0                	add    %edx,%eax
  8047d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8047d4:	83 ec 04             	sub    $0x4,%esp
  8047d7:	6a 01                	push   $0x1
  8047d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8047dc:	ff 75 08             	pushl  0x8(%ebp)
  8047df:	e8 02 ef ff ff       	call   8036e6 <set_block_data>
  8047e4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8047e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ea:	83 e8 04             	sub    $0x4,%eax
  8047ed:	8b 00                	mov    (%eax),%eax
  8047ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8047f2:	89 c2                	mov    %eax,%edx
  8047f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8047f7:	01 d0                	add    %edx,%eax
  8047f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8047fc:	83 ec 04             	sub    $0x4,%esp
  8047ff:	6a 00                	push   $0x0
  804801:	ff 75 cc             	pushl  -0x34(%ebp)
  804804:	ff 75 c8             	pushl  -0x38(%ebp)
  804807:	e8 da ee ff ff       	call   8036e6 <set_block_data>
  80480c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80480f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804813:	74 06                	je     80481b <realloc_block_FF+0x142>
  804815:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804819:	75 17                	jne    804832 <realloc_block_FF+0x159>
  80481b:	83 ec 04             	sub    $0x4,%esp
  80481e:	68 64 6a 80 00       	push   $0x806a64
  804823:	68 f6 01 00 00       	push   $0x1f6
  804828:	68 f1 69 80 00       	push   $0x8069f1
  80482d:	e8 c1 cf ff ff       	call   8017f3 <_panic>
  804832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804835:	8b 10                	mov    (%eax),%edx
  804837:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80483a:	89 10                	mov    %edx,(%eax)
  80483c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80483f:	8b 00                	mov    (%eax),%eax
  804841:	85 c0                	test   %eax,%eax
  804843:	74 0b                	je     804850 <realloc_block_FF+0x177>
  804845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804848:	8b 00                	mov    (%eax),%eax
  80484a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80484d:	89 50 04             	mov    %edx,0x4(%eax)
  804850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804853:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804856:	89 10                	mov    %edx,(%eax)
  804858:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80485b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80485e:	89 50 04             	mov    %edx,0x4(%eax)
  804861:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804864:	8b 00                	mov    (%eax),%eax
  804866:	85 c0                	test   %eax,%eax
  804868:	75 08                	jne    804872 <realloc_block_FF+0x199>
  80486a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80486d:	a3 30 70 80 00       	mov    %eax,0x807030
  804872:	a1 38 70 80 00       	mov    0x807038,%eax
  804877:	40                   	inc    %eax
  804878:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80487d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804881:	75 17                	jne    80489a <realloc_block_FF+0x1c1>
  804883:	83 ec 04             	sub    $0x4,%esp
  804886:	68 d3 69 80 00       	push   $0x8069d3
  80488b:	68 f7 01 00 00       	push   $0x1f7
  804890:	68 f1 69 80 00       	push   $0x8069f1
  804895:	e8 59 cf ff ff       	call   8017f3 <_panic>
  80489a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80489d:	8b 00                	mov    (%eax),%eax
  80489f:	85 c0                	test   %eax,%eax
  8048a1:	74 10                	je     8048b3 <realloc_block_FF+0x1da>
  8048a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048a6:	8b 00                	mov    (%eax),%eax
  8048a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048ab:	8b 52 04             	mov    0x4(%edx),%edx
  8048ae:	89 50 04             	mov    %edx,0x4(%eax)
  8048b1:	eb 0b                	jmp    8048be <realloc_block_FF+0x1e5>
  8048b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048b6:	8b 40 04             	mov    0x4(%eax),%eax
  8048b9:	a3 30 70 80 00       	mov    %eax,0x807030
  8048be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048c1:	8b 40 04             	mov    0x4(%eax),%eax
  8048c4:	85 c0                	test   %eax,%eax
  8048c6:	74 0f                	je     8048d7 <realloc_block_FF+0x1fe>
  8048c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048cb:	8b 40 04             	mov    0x4(%eax),%eax
  8048ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048d1:	8b 12                	mov    (%edx),%edx
  8048d3:	89 10                	mov    %edx,(%eax)
  8048d5:	eb 0a                	jmp    8048e1 <realloc_block_FF+0x208>
  8048d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048da:	8b 00                	mov    (%eax),%eax
  8048dc:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8048e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048f4:	a1 38 70 80 00       	mov    0x807038,%eax
  8048f9:	48                   	dec    %eax
  8048fa:	a3 38 70 80 00       	mov    %eax,0x807038
  8048ff:	e9 83 02 00 00       	jmp    804b87 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804904:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804908:	0f 86 69 02 00 00    	jbe    804b77 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80490e:	83 ec 04             	sub    $0x4,%esp
  804911:	6a 01                	push   $0x1
  804913:	ff 75 f0             	pushl  -0x10(%ebp)
  804916:	ff 75 08             	pushl  0x8(%ebp)
  804919:	e8 c8 ed ff ff       	call   8036e6 <set_block_data>
  80491e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804921:	8b 45 08             	mov    0x8(%ebp),%eax
  804924:	83 e8 04             	sub    $0x4,%eax
  804927:	8b 00                	mov    (%eax),%eax
  804929:	83 e0 fe             	and    $0xfffffffe,%eax
  80492c:	89 c2                	mov    %eax,%edx
  80492e:	8b 45 08             	mov    0x8(%ebp),%eax
  804931:	01 d0                	add    %edx,%eax
  804933:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804936:	a1 38 70 80 00       	mov    0x807038,%eax
  80493b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80493e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804942:	75 68                	jne    8049ac <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804944:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804948:	75 17                	jne    804961 <realloc_block_FF+0x288>
  80494a:	83 ec 04             	sub    $0x4,%esp
  80494d:	68 0c 6a 80 00       	push   $0x806a0c
  804952:	68 06 02 00 00       	push   $0x206
  804957:	68 f1 69 80 00       	push   $0x8069f1
  80495c:	e8 92 ce ff ff       	call   8017f3 <_panic>
  804961:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  804967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80496a:	89 10                	mov    %edx,(%eax)
  80496c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80496f:	8b 00                	mov    (%eax),%eax
  804971:	85 c0                	test   %eax,%eax
  804973:	74 0d                	je     804982 <realloc_block_FF+0x2a9>
  804975:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80497a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80497d:	89 50 04             	mov    %edx,0x4(%eax)
  804980:	eb 08                	jmp    80498a <realloc_block_FF+0x2b1>
  804982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804985:	a3 30 70 80 00       	mov    %eax,0x807030
  80498a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80498d:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804995:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80499c:	a1 38 70 80 00       	mov    0x807038,%eax
  8049a1:	40                   	inc    %eax
  8049a2:	a3 38 70 80 00       	mov    %eax,0x807038
  8049a7:	e9 b0 01 00 00       	jmp    804b5c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8049ac:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049b1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8049b4:	76 68                	jbe    804a1e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8049b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8049ba:	75 17                	jne    8049d3 <realloc_block_FF+0x2fa>
  8049bc:	83 ec 04             	sub    $0x4,%esp
  8049bf:	68 0c 6a 80 00       	push   $0x806a0c
  8049c4:	68 0b 02 00 00       	push   $0x20b
  8049c9:	68 f1 69 80 00       	push   $0x8069f1
  8049ce:	e8 20 ce ff ff       	call   8017f3 <_panic>
  8049d3:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8049d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049dc:	89 10                	mov    %edx,(%eax)
  8049de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049e1:	8b 00                	mov    (%eax),%eax
  8049e3:	85 c0                	test   %eax,%eax
  8049e5:	74 0d                	je     8049f4 <realloc_block_FF+0x31b>
  8049e7:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049ef:	89 50 04             	mov    %edx,0x4(%eax)
  8049f2:	eb 08                	jmp    8049fc <realloc_block_FF+0x323>
  8049f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049f7:	a3 30 70 80 00       	mov    %eax,0x807030
  8049fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049ff:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a0e:	a1 38 70 80 00       	mov    0x807038,%eax
  804a13:	40                   	inc    %eax
  804a14:	a3 38 70 80 00       	mov    %eax,0x807038
  804a19:	e9 3e 01 00 00       	jmp    804b5c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804a1e:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a23:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a26:	73 68                	jae    804a90 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804a28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a2c:	75 17                	jne    804a45 <realloc_block_FF+0x36c>
  804a2e:	83 ec 04             	sub    $0x4,%esp
  804a31:	68 40 6a 80 00       	push   $0x806a40
  804a36:	68 10 02 00 00       	push   $0x210
  804a3b:	68 f1 69 80 00       	push   $0x8069f1
  804a40:	e8 ae cd ff ff       	call   8017f3 <_panic>
  804a45:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804a4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a4e:	89 50 04             	mov    %edx,0x4(%eax)
  804a51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a54:	8b 40 04             	mov    0x4(%eax),%eax
  804a57:	85 c0                	test   %eax,%eax
  804a59:	74 0c                	je     804a67 <realloc_block_FF+0x38e>
  804a5b:	a1 30 70 80 00       	mov    0x807030,%eax
  804a60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a63:	89 10                	mov    %edx,(%eax)
  804a65:	eb 08                	jmp    804a6f <realloc_block_FF+0x396>
  804a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a6a:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a72:	a3 30 70 80 00       	mov    %eax,0x807030
  804a77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a80:	a1 38 70 80 00       	mov    0x807038,%eax
  804a85:	40                   	inc    %eax
  804a86:	a3 38 70 80 00       	mov    %eax,0x807038
  804a8b:	e9 cc 00 00 00       	jmp    804b5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804a97:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a9f:	e9 8a 00 00 00       	jmp    804b2e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aa7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804aaa:	73 7a                	jae    804b26 <realloc_block_FF+0x44d>
  804aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aaf:	8b 00                	mov    (%eax),%eax
  804ab1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804ab4:	73 70                	jae    804b26 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804aba:	74 06                	je     804ac2 <realloc_block_FF+0x3e9>
  804abc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804ac0:	75 17                	jne    804ad9 <realloc_block_FF+0x400>
  804ac2:	83 ec 04             	sub    $0x4,%esp
  804ac5:	68 64 6a 80 00       	push   $0x806a64
  804aca:	68 1a 02 00 00       	push   $0x21a
  804acf:	68 f1 69 80 00       	push   $0x8069f1
  804ad4:	e8 1a cd ff ff       	call   8017f3 <_panic>
  804ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804adc:	8b 10                	mov    (%eax),%edx
  804ade:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ae1:	89 10                	mov    %edx,(%eax)
  804ae3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ae6:	8b 00                	mov    (%eax),%eax
  804ae8:	85 c0                	test   %eax,%eax
  804aea:	74 0b                	je     804af7 <realloc_block_FF+0x41e>
  804aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aef:	8b 00                	mov    (%eax),%eax
  804af1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804af4:	89 50 04             	mov    %edx,0x4(%eax)
  804af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804afa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804afd:	89 10                	mov    %edx,(%eax)
  804aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804b05:	89 50 04             	mov    %edx,0x4(%eax)
  804b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b0b:	8b 00                	mov    (%eax),%eax
  804b0d:	85 c0                	test   %eax,%eax
  804b0f:	75 08                	jne    804b19 <realloc_block_FF+0x440>
  804b11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b14:	a3 30 70 80 00       	mov    %eax,0x807030
  804b19:	a1 38 70 80 00       	mov    0x807038,%eax
  804b1e:	40                   	inc    %eax
  804b1f:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  804b24:	eb 36                	jmp    804b5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804b26:	a1 34 70 80 00       	mov    0x807034,%eax
  804b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b32:	74 07                	je     804b3b <realloc_block_FF+0x462>
  804b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b37:	8b 00                	mov    (%eax),%eax
  804b39:	eb 05                	jmp    804b40 <realloc_block_FF+0x467>
  804b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b40:	a3 34 70 80 00       	mov    %eax,0x807034
  804b45:	a1 34 70 80 00       	mov    0x807034,%eax
  804b4a:	85 c0                	test   %eax,%eax
  804b4c:	0f 85 52 ff ff ff    	jne    804aa4 <realloc_block_FF+0x3cb>
  804b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b56:	0f 85 48 ff ff ff    	jne    804aa4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804b5c:	83 ec 04             	sub    $0x4,%esp
  804b5f:	6a 00                	push   $0x0
  804b61:	ff 75 d8             	pushl  -0x28(%ebp)
  804b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  804b67:	e8 7a eb ff ff       	call   8036e6 <set_block_data>
  804b6c:	83 c4 10             	add    $0x10,%esp
				return va;
  804b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  804b72:	e9 7b 02 00 00       	jmp    804df2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804b77:	83 ec 0c             	sub    $0xc,%esp
  804b7a:	68 e1 6a 80 00       	push   $0x806ae1
  804b7f:	e8 2c cf ff ff       	call   801ab0 <cprintf>
  804b84:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804b87:	8b 45 08             	mov    0x8(%ebp),%eax
  804b8a:	e9 63 02 00 00       	jmp    804df2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804b95:	0f 86 4d 02 00 00    	jbe    804de8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804b9b:	83 ec 0c             	sub    $0xc,%esp
  804b9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  804ba1:	e8 08 e8 ff ff       	call   8033ae <is_free_block>
  804ba6:	83 c4 10             	add    $0x10,%esp
  804ba9:	84 c0                	test   %al,%al
  804bab:	0f 84 37 02 00 00    	je     804de8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  804bb4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804bb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804bba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804bbd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804bc0:	76 38                	jbe    804bfa <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804bc2:	83 ec 0c             	sub    $0xc,%esp
  804bc5:	ff 75 08             	pushl  0x8(%ebp)
  804bc8:	e8 0c fa ff ff       	call   8045d9 <free_block>
  804bcd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804bd0:	83 ec 0c             	sub    $0xc,%esp
  804bd3:	ff 75 0c             	pushl  0xc(%ebp)
  804bd6:	e8 3a eb ff ff       	call   803715 <alloc_block_FF>
  804bdb:	83 c4 10             	add    $0x10,%esp
  804bde:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804be1:	83 ec 08             	sub    $0x8,%esp
  804be4:	ff 75 c0             	pushl  -0x40(%ebp)
  804be7:	ff 75 08             	pushl  0x8(%ebp)
  804bea:	e8 ab fa ff ff       	call   80469a <copy_data>
  804bef:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804bf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804bf5:	e9 f8 01 00 00       	jmp    804df2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804bfd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804c00:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804c03:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804c07:	0f 87 a0 00 00 00    	ja     804cad <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804c0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c11:	75 17                	jne    804c2a <realloc_block_FF+0x551>
  804c13:	83 ec 04             	sub    $0x4,%esp
  804c16:	68 d3 69 80 00       	push   $0x8069d3
  804c1b:	68 38 02 00 00       	push   $0x238
  804c20:	68 f1 69 80 00       	push   $0x8069f1
  804c25:	e8 c9 cb ff ff       	call   8017f3 <_panic>
  804c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c2d:	8b 00                	mov    (%eax),%eax
  804c2f:	85 c0                	test   %eax,%eax
  804c31:	74 10                	je     804c43 <realloc_block_FF+0x56a>
  804c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c36:	8b 00                	mov    (%eax),%eax
  804c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c3b:	8b 52 04             	mov    0x4(%edx),%edx
  804c3e:	89 50 04             	mov    %edx,0x4(%eax)
  804c41:	eb 0b                	jmp    804c4e <realloc_block_FF+0x575>
  804c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c46:	8b 40 04             	mov    0x4(%eax),%eax
  804c49:	a3 30 70 80 00       	mov    %eax,0x807030
  804c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c51:	8b 40 04             	mov    0x4(%eax),%eax
  804c54:	85 c0                	test   %eax,%eax
  804c56:	74 0f                	je     804c67 <realloc_block_FF+0x58e>
  804c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c5b:	8b 40 04             	mov    0x4(%eax),%eax
  804c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c61:	8b 12                	mov    (%edx),%edx
  804c63:	89 10                	mov    %edx,(%eax)
  804c65:	eb 0a                	jmp    804c71 <realloc_block_FF+0x598>
  804c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c6a:	8b 00                	mov    (%eax),%eax
  804c6c:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c84:	a1 38 70 80 00       	mov    0x807038,%eax
  804c89:	48                   	dec    %eax
  804c8a:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804c95:	01 d0                	add    %edx,%eax
  804c97:	83 ec 04             	sub    $0x4,%esp
  804c9a:	6a 01                	push   $0x1
  804c9c:	50                   	push   %eax
  804c9d:	ff 75 08             	pushl  0x8(%ebp)
  804ca0:	e8 41 ea ff ff       	call   8036e6 <set_block_data>
  804ca5:	83 c4 10             	add    $0x10,%esp
  804ca8:	e9 36 01 00 00       	jmp    804de3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804cb3:	01 d0                	add    %edx,%eax
  804cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804cb8:	83 ec 04             	sub    $0x4,%esp
  804cbb:	6a 01                	push   $0x1
  804cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  804cc0:	ff 75 08             	pushl  0x8(%ebp)
  804cc3:	e8 1e ea ff ff       	call   8036e6 <set_block_data>
  804cc8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  804cce:	83 e8 04             	sub    $0x4,%eax
  804cd1:	8b 00                	mov    (%eax),%eax
  804cd3:	83 e0 fe             	and    $0xfffffffe,%eax
  804cd6:	89 c2                	mov    %eax,%edx
  804cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  804cdb:	01 d0                	add    %edx,%eax
  804cdd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804ce0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ce4:	74 06                	je     804cec <realloc_block_FF+0x613>
  804ce6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804cea:	75 17                	jne    804d03 <realloc_block_FF+0x62a>
  804cec:	83 ec 04             	sub    $0x4,%esp
  804cef:	68 64 6a 80 00       	push   $0x806a64
  804cf4:	68 44 02 00 00       	push   $0x244
  804cf9:	68 f1 69 80 00       	push   $0x8069f1
  804cfe:	e8 f0 ca ff ff       	call   8017f3 <_panic>
  804d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d06:	8b 10                	mov    (%eax),%edx
  804d08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d0b:	89 10                	mov    %edx,(%eax)
  804d0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d10:	8b 00                	mov    (%eax),%eax
  804d12:	85 c0                	test   %eax,%eax
  804d14:	74 0b                	je     804d21 <realloc_block_FF+0x648>
  804d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d19:	8b 00                	mov    (%eax),%eax
  804d1b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804d1e:	89 50 04             	mov    %edx,0x4(%eax)
  804d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d24:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804d27:	89 10                	mov    %edx,(%eax)
  804d29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d2f:	89 50 04             	mov    %edx,0x4(%eax)
  804d32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d35:	8b 00                	mov    (%eax),%eax
  804d37:	85 c0                	test   %eax,%eax
  804d39:	75 08                	jne    804d43 <realloc_block_FF+0x66a>
  804d3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804d3e:	a3 30 70 80 00       	mov    %eax,0x807030
  804d43:	a1 38 70 80 00       	mov    0x807038,%eax
  804d48:	40                   	inc    %eax
  804d49:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804d4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d52:	75 17                	jne    804d6b <realloc_block_FF+0x692>
  804d54:	83 ec 04             	sub    $0x4,%esp
  804d57:	68 d3 69 80 00       	push   $0x8069d3
  804d5c:	68 45 02 00 00       	push   $0x245
  804d61:	68 f1 69 80 00       	push   $0x8069f1
  804d66:	e8 88 ca ff ff       	call   8017f3 <_panic>
  804d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d6e:	8b 00                	mov    (%eax),%eax
  804d70:	85 c0                	test   %eax,%eax
  804d72:	74 10                	je     804d84 <realloc_block_FF+0x6ab>
  804d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d77:	8b 00                	mov    (%eax),%eax
  804d79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d7c:	8b 52 04             	mov    0x4(%edx),%edx
  804d7f:	89 50 04             	mov    %edx,0x4(%eax)
  804d82:	eb 0b                	jmp    804d8f <realloc_block_FF+0x6b6>
  804d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d87:	8b 40 04             	mov    0x4(%eax),%eax
  804d8a:	a3 30 70 80 00       	mov    %eax,0x807030
  804d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d92:	8b 40 04             	mov    0x4(%eax),%eax
  804d95:	85 c0                	test   %eax,%eax
  804d97:	74 0f                	je     804da8 <realloc_block_FF+0x6cf>
  804d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d9c:	8b 40 04             	mov    0x4(%eax),%eax
  804d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804da2:	8b 12                	mov    (%edx),%edx
  804da4:	89 10                	mov    %edx,(%eax)
  804da6:	eb 0a                	jmp    804db2 <realloc_block_FF+0x6d9>
  804da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dab:	8b 00                	mov    (%eax),%eax
  804dad:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804dc5:	a1 38 70 80 00       	mov    0x807038,%eax
  804dca:	48                   	dec    %eax
  804dcb:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804dd0:	83 ec 04             	sub    $0x4,%esp
  804dd3:	6a 00                	push   $0x0
  804dd5:	ff 75 bc             	pushl  -0x44(%ebp)
  804dd8:	ff 75 b8             	pushl  -0x48(%ebp)
  804ddb:	e8 06 e9 ff ff       	call   8036e6 <set_block_data>
  804de0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804de3:	8b 45 08             	mov    0x8(%ebp),%eax
  804de6:	eb 0a                	jmp    804df2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804de8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804df2:	c9                   	leave  
  804df3:	c3                   	ret    

00804df4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804df4:	55                   	push   %ebp
  804df5:	89 e5                	mov    %esp,%ebp
  804df7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804dfa:	83 ec 04             	sub    $0x4,%esp
  804dfd:	68 e8 6a 80 00       	push   $0x806ae8
  804e02:	68 58 02 00 00       	push   $0x258
  804e07:	68 f1 69 80 00       	push   $0x8069f1
  804e0c:	e8 e2 c9 ff ff       	call   8017f3 <_panic>

00804e11 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804e11:	55                   	push   %ebp
  804e12:	89 e5                	mov    %esp,%ebp
  804e14:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804e17:	83 ec 04             	sub    $0x4,%esp
  804e1a:	68 10 6b 80 00       	push   $0x806b10
  804e1f:	68 61 02 00 00       	push   $0x261
  804e24:	68 f1 69 80 00       	push   $0x8069f1
  804e29:	e8 c5 c9 ff ff       	call   8017f3 <_panic>

00804e2e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804e2e:	55                   	push   %ebp
  804e2f:	89 e5                	mov    %esp,%ebp
  804e31:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804e34:	8b 55 08             	mov    0x8(%ebp),%edx
  804e37:	89 d0                	mov    %edx,%eax
  804e39:	c1 e0 02             	shl    $0x2,%eax
  804e3c:	01 d0                	add    %edx,%eax
  804e3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e45:	01 d0                	add    %edx,%eax
  804e47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e4e:	01 d0                	add    %edx,%eax
  804e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e57:	01 d0                	add    %edx,%eax
  804e59:	c1 e0 04             	shl    $0x4,%eax
  804e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804e5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804e66:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804e69:	83 ec 0c             	sub    $0xc,%esp
  804e6c:	50                   	push   %eax
  804e6d:	e8 2f e2 ff ff       	call   8030a1 <sys_get_virtual_time>
  804e72:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804e75:	eb 41                	jmp    804eb8 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804e77:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804e7a:	83 ec 0c             	sub    $0xc,%esp
  804e7d:	50                   	push   %eax
  804e7e:	e8 1e e2 ff ff       	call   8030a1 <sys_get_virtual_time>
  804e83:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e8c:	29 c2                	sub    %eax,%edx
  804e8e:	89 d0                	mov    %edx,%eax
  804e90:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804e93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804e99:	89 d1                	mov    %edx,%ecx
  804e9b:	29 c1                	sub    %eax,%ecx
  804e9d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ea3:	39 c2                	cmp    %eax,%edx
  804ea5:	0f 97 c0             	seta   %al
  804ea8:	0f b6 c0             	movzbl %al,%eax
  804eab:	29 c1                	sub    %eax,%ecx
  804ead:	89 c8                	mov    %ecx,%eax
  804eaf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804eb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ebb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804ebe:	72 b7                	jb     804e77 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804ec0:	90                   	nop
  804ec1:	c9                   	leave  
  804ec2:	c3                   	ret    

00804ec3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804ec3:	55                   	push   %ebp
  804ec4:	89 e5                	mov    %esp,%ebp
  804ec6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804ec9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804ed0:	eb 03                	jmp    804ed5 <busy_wait+0x12>
  804ed2:	ff 45 fc             	incl   -0x4(%ebp)
  804ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804ed8:	3b 45 08             	cmp    0x8(%ebp),%eax
  804edb:	72 f5                	jb     804ed2 <busy_wait+0xf>
	return i;
  804edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804ee0:	c9                   	leave  
  804ee1:	c3                   	ret    
  804ee2:	66 90                	xchg   %ax,%ax

00804ee4 <__udivdi3>:
  804ee4:	55                   	push   %ebp
  804ee5:	57                   	push   %edi
  804ee6:	56                   	push   %esi
  804ee7:	53                   	push   %ebx
  804ee8:	83 ec 1c             	sub    $0x1c,%esp
  804eeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804eef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804ef3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ef7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804efb:	89 ca                	mov    %ecx,%edx
  804efd:	89 f8                	mov    %edi,%eax
  804eff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804f03:	85 f6                	test   %esi,%esi
  804f05:	75 2d                	jne    804f34 <__udivdi3+0x50>
  804f07:	39 cf                	cmp    %ecx,%edi
  804f09:	77 65                	ja     804f70 <__udivdi3+0x8c>
  804f0b:	89 fd                	mov    %edi,%ebp
  804f0d:	85 ff                	test   %edi,%edi
  804f0f:	75 0b                	jne    804f1c <__udivdi3+0x38>
  804f11:	b8 01 00 00 00       	mov    $0x1,%eax
  804f16:	31 d2                	xor    %edx,%edx
  804f18:	f7 f7                	div    %edi
  804f1a:	89 c5                	mov    %eax,%ebp
  804f1c:	31 d2                	xor    %edx,%edx
  804f1e:	89 c8                	mov    %ecx,%eax
  804f20:	f7 f5                	div    %ebp
  804f22:	89 c1                	mov    %eax,%ecx
  804f24:	89 d8                	mov    %ebx,%eax
  804f26:	f7 f5                	div    %ebp
  804f28:	89 cf                	mov    %ecx,%edi
  804f2a:	89 fa                	mov    %edi,%edx
  804f2c:	83 c4 1c             	add    $0x1c,%esp
  804f2f:	5b                   	pop    %ebx
  804f30:	5e                   	pop    %esi
  804f31:	5f                   	pop    %edi
  804f32:	5d                   	pop    %ebp
  804f33:	c3                   	ret    
  804f34:	39 ce                	cmp    %ecx,%esi
  804f36:	77 28                	ja     804f60 <__udivdi3+0x7c>
  804f38:	0f bd fe             	bsr    %esi,%edi
  804f3b:	83 f7 1f             	xor    $0x1f,%edi
  804f3e:	75 40                	jne    804f80 <__udivdi3+0x9c>
  804f40:	39 ce                	cmp    %ecx,%esi
  804f42:	72 0a                	jb     804f4e <__udivdi3+0x6a>
  804f44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804f48:	0f 87 9e 00 00 00    	ja     804fec <__udivdi3+0x108>
  804f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  804f53:	89 fa                	mov    %edi,%edx
  804f55:	83 c4 1c             	add    $0x1c,%esp
  804f58:	5b                   	pop    %ebx
  804f59:	5e                   	pop    %esi
  804f5a:	5f                   	pop    %edi
  804f5b:	5d                   	pop    %ebp
  804f5c:	c3                   	ret    
  804f5d:	8d 76 00             	lea    0x0(%esi),%esi
  804f60:	31 ff                	xor    %edi,%edi
  804f62:	31 c0                	xor    %eax,%eax
  804f64:	89 fa                	mov    %edi,%edx
  804f66:	83 c4 1c             	add    $0x1c,%esp
  804f69:	5b                   	pop    %ebx
  804f6a:	5e                   	pop    %esi
  804f6b:	5f                   	pop    %edi
  804f6c:	5d                   	pop    %ebp
  804f6d:	c3                   	ret    
  804f6e:	66 90                	xchg   %ax,%ax
  804f70:	89 d8                	mov    %ebx,%eax
  804f72:	f7 f7                	div    %edi
  804f74:	31 ff                	xor    %edi,%edi
  804f76:	89 fa                	mov    %edi,%edx
  804f78:	83 c4 1c             	add    $0x1c,%esp
  804f7b:	5b                   	pop    %ebx
  804f7c:	5e                   	pop    %esi
  804f7d:	5f                   	pop    %edi
  804f7e:	5d                   	pop    %ebp
  804f7f:	c3                   	ret    
  804f80:	bd 20 00 00 00       	mov    $0x20,%ebp
  804f85:	89 eb                	mov    %ebp,%ebx
  804f87:	29 fb                	sub    %edi,%ebx
  804f89:	89 f9                	mov    %edi,%ecx
  804f8b:	d3 e6                	shl    %cl,%esi
  804f8d:	89 c5                	mov    %eax,%ebp
  804f8f:	88 d9                	mov    %bl,%cl
  804f91:	d3 ed                	shr    %cl,%ebp
  804f93:	89 e9                	mov    %ebp,%ecx
  804f95:	09 f1                	or     %esi,%ecx
  804f97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804f9b:	89 f9                	mov    %edi,%ecx
  804f9d:	d3 e0                	shl    %cl,%eax
  804f9f:	89 c5                	mov    %eax,%ebp
  804fa1:	89 d6                	mov    %edx,%esi
  804fa3:	88 d9                	mov    %bl,%cl
  804fa5:	d3 ee                	shr    %cl,%esi
  804fa7:	89 f9                	mov    %edi,%ecx
  804fa9:	d3 e2                	shl    %cl,%edx
  804fab:	8b 44 24 08          	mov    0x8(%esp),%eax
  804faf:	88 d9                	mov    %bl,%cl
  804fb1:	d3 e8                	shr    %cl,%eax
  804fb3:	09 c2                	or     %eax,%edx
  804fb5:	89 d0                	mov    %edx,%eax
  804fb7:	89 f2                	mov    %esi,%edx
  804fb9:	f7 74 24 0c          	divl   0xc(%esp)
  804fbd:	89 d6                	mov    %edx,%esi
  804fbf:	89 c3                	mov    %eax,%ebx
  804fc1:	f7 e5                	mul    %ebp
  804fc3:	39 d6                	cmp    %edx,%esi
  804fc5:	72 19                	jb     804fe0 <__udivdi3+0xfc>
  804fc7:	74 0b                	je     804fd4 <__udivdi3+0xf0>
  804fc9:	89 d8                	mov    %ebx,%eax
  804fcb:	31 ff                	xor    %edi,%edi
  804fcd:	e9 58 ff ff ff       	jmp    804f2a <__udivdi3+0x46>
  804fd2:	66 90                	xchg   %ax,%ax
  804fd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  804fd8:	89 f9                	mov    %edi,%ecx
  804fda:	d3 e2                	shl    %cl,%edx
  804fdc:	39 c2                	cmp    %eax,%edx
  804fde:	73 e9                	jae    804fc9 <__udivdi3+0xe5>
  804fe0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804fe3:	31 ff                	xor    %edi,%edi
  804fe5:	e9 40 ff ff ff       	jmp    804f2a <__udivdi3+0x46>
  804fea:	66 90                	xchg   %ax,%ax
  804fec:	31 c0                	xor    %eax,%eax
  804fee:	e9 37 ff ff ff       	jmp    804f2a <__udivdi3+0x46>
  804ff3:	90                   	nop

00804ff4 <__umoddi3>:
  804ff4:	55                   	push   %ebp
  804ff5:	57                   	push   %edi
  804ff6:	56                   	push   %esi
  804ff7:	53                   	push   %ebx
  804ff8:	83 ec 1c             	sub    $0x1c,%esp
  804ffb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804fff:	8b 74 24 34          	mov    0x34(%esp),%esi
  805003:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805007:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80500b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80500f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  805013:	89 f3                	mov    %esi,%ebx
  805015:	89 fa                	mov    %edi,%edx
  805017:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80501b:	89 34 24             	mov    %esi,(%esp)
  80501e:	85 c0                	test   %eax,%eax
  805020:	75 1a                	jne    80503c <__umoddi3+0x48>
  805022:	39 f7                	cmp    %esi,%edi
  805024:	0f 86 a2 00 00 00    	jbe    8050cc <__umoddi3+0xd8>
  80502a:	89 c8                	mov    %ecx,%eax
  80502c:	89 f2                	mov    %esi,%edx
  80502e:	f7 f7                	div    %edi
  805030:	89 d0                	mov    %edx,%eax
  805032:	31 d2                	xor    %edx,%edx
  805034:	83 c4 1c             	add    $0x1c,%esp
  805037:	5b                   	pop    %ebx
  805038:	5e                   	pop    %esi
  805039:	5f                   	pop    %edi
  80503a:	5d                   	pop    %ebp
  80503b:	c3                   	ret    
  80503c:	39 f0                	cmp    %esi,%eax
  80503e:	0f 87 ac 00 00 00    	ja     8050f0 <__umoddi3+0xfc>
  805044:	0f bd e8             	bsr    %eax,%ebp
  805047:	83 f5 1f             	xor    $0x1f,%ebp
  80504a:	0f 84 ac 00 00 00    	je     8050fc <__umoddi3+0x108>
  805050:	bf 20 00 00 00       	mov    $0x20,%edi
  805055:	29 ef                	sub    %ebp,%edi
  805057:	89 fe                	mov    %edi,%esi
  805059:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80505d:	89 e9                	mov    %ebp,%ecx
  80505f:	d3 e0                	shl    %cl,%eax
  805061:	89 d7                	mov    %edx,%edi
  805063:	89 f1                	mov    %esi,%ecx
  805065:	d3 ef                	shr    %cl,%edi
  805067:	09 c7                	or     %eax,%edi
  805069:	89 e9                	mov    %ebp,%ecx
  80506b:	d3 e2                	shl    %cl,%edx
  80506d:	89 14 24             	mov    %edx,(%esp)
  805070:	89 d8                	mov    %ebx,%eax
  805072:	d3 e0                	shl    %cl,%eax
  805074:	89 c2                	mov    %eax,%edx
  805076:	8b 44 24 08          	mov    0x8(%esp),%eax
  80507a:	d3 e0                	shl    %cl,%eax
  80507c:	89 44 24 04          	mov    %eax,0x4(%esp)
  805080:	8b 44 24 08          	mov    0x8(%esp),%eax
  805084:	89 f1                	mov    %esi,%ecx
  805086:	d3 e8                	shr    %cl,%eax
  805088:	09 d0                	or     %edx,%eax
  80508a:	d3 eb                	shr    %cl,%ebx
  80508c:	89 da                	mov    %ebx,%edx
  80508e:	f7 f7                	div    %edi
  805090:	89 d3                	mov    %edx,%ebx
  805092:	f7 24 24             	mull   (%esp)
  805095:	89 c6                	mov    %eax,%esi
  805097:	89 d1                	mov    %edx,%ecx
  805099:	39 d3                	cmp    %edx,%ebx
  80509b:	0f 82 87 00 00 00    	jb     805128 <__umoddi3+0x134>
  8050a1:	0f 84 91 00 00 00    	je     805138 <__umoddi3+0x144>
  8050a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8050ab:	29 f2                	sub    %esi,%edx
  8050ad:	19 cb                	sbb    %ecx,%ebx
  8050af:	89 d8                	mov    %ebx,%eax
  8050b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8050b5:	d3 e0                	shl    %cl,%eax
  8050b7:	89 e9                	mov    %ebp,%ecx
  8050b9:	d3 ea                	shr    %cl,%edx
  8050bb:	09 d0                	or     %edx,%eax
  8050bd:	89 e9                	mov    %ebp,%ecx
  8050bf:	d3 eb                	shr    %cl,%ebx
  8050c1:	89 da                	mov    %ebx,%edx
  8050c3:	83 c4 1c             	add    $0x1c,%esp
  8050c6:	5b                   	pop    %ebx
  8050c7:	5e                   	pop    %esi
  8050c8:	5f                   	pop    %edi
  8050c9:	5d                   	pop    %ebp
  8050ca:	c3                   	ret    
  8050cb:	90                   	nop
  8050cc:	89 fd                	mov    %edi,%ebp
  8050ce:	85 ff                	test   %edi,%edi
  8050d0:	75 0b                	jne    8050dd <__umoddi3+0xe9>
  8050d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8050d7:	31 d2                	xor    %edx,%edx
  8050d9:	f7 f7                	div    %edi
  8050db:	89 c5                	mov    %eax,%ebp
  8050dd:	89 f0                	mov    %esi,%eax
  8050df:	31 d2                	xor    %edx,%edx
  8050e1:	f7 f5                	div    %ebp
  8050e3:	89 c8                	mov    %ecx,%eax
  8050e5:	f7 f5                	div    %ebp
  8050e7:	89 d0                	mov    %edx,%eax
  8050e9:	e9 44 ff ff ff       	jmp    805032 <__umoddi3+0x3e>
  8050ee:	66 90                	xchg   %ax,%ax
  8050f0:	89 c8                	mov    %ecx,%eax
  8050f2:	89 f2                	mov    %esi,%edx
  8050f4:	83 c4 1c             	add    $0x1c,%esp
  8050f7:	5b                   	pop    %ebx
  8050f8:	5e                   	pop    %esi
  8050f9:	5f                   	pop    %edi
  8050fa:	5d                   	pop    %ebp
  8050fb:	c3                   	ret    
  8050fc:	3b 04 24             	cmp    (%esp),%eax
  8050ff:	72 06                	jb     805107 <__umoddi3+0x113>
  805101:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805105:	77 0f                	ja     805116 <__umoddi3+0x122>
  805107:	89 f2                	mov    %esi,%edx
  805109:	29 f9                	sub    %edi,%ecx
  80510b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80510f:	89 14 24             	mov    %edx,(%esp)
  805112:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805116:	8b 44 24 04          	mov    0x4(%esp),%eax
  80511a:	8b 14 24             	mov    (%esp),%edx
  80511d:	83 c4 1c             	add    $0x1c,%esp
  805120:	5b                   	pop    %ebx
  805121:	5e                   	pop    %esi
  805122:	5f                   	pop    %edi
  805123:	5d                   	pop    %ebp
  805124:	c3                   	ret    
  805125:	8d 76 00             	lea    0x0(%esi),%esi
  805128:	2b 04 24             	sub    (%esp),%eax
  80512b:	19 fa                	sbb    %edi,%edx
  80512d:	89 d1                	mov    %edx,%ecx
  80512f:	89 c6                	mov    %eax,%esi
  805131:	e9 71 ff ff ff       	jmp    8050a7 <__umoddi3+0xb3>
  805136:	66 90                	xchg   %ax,%ax
  805138:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80513c:	72 ea                	jb     805128 <__umoddi3+0x134>
  80513e:	89 d9                	mov    %ebx,%ecx
  805140:	e9 62 ff ff ff       	jmp    8050a7 <__umoddi3+0xb3>
