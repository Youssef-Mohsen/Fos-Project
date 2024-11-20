
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
  800064:	a1 04 50 80 00       	mov    0x805004,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 04 50 80 00       	mov    0x805004,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 c0 32 80 00       	push   $0x8032c0
  800086:	6a 1e                	push   $0x1e
  800088:	68 dc 32 80 00       	push   $0x8032dc
  80008d:	e8 59 17 00 00       	call   8017eb <_panic>
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
  8000d7:	e8 b0 29 00 00       	call   802a8c <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 f0 32 80 00       	push   $0x8032f0
  8000e7:	e8 bc 19 00 00       	call   801aa8 <cprintf>
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
  800103:	e8 84 29 00 00       	call   802a8c <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 c7 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 34 27 00 00       	call   802858 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 4c 33 80 00       	push   $0x80334c
  800147:	e8 5c 19 00 00       	call   801aa8 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 2e 29 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800195:	68 80 33 80 00       	push   $0x803380
  80019a:	e8 09 19 00 00       	call   801aa8 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 30 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 f0 33 80 00       	push   $0x8033f0
  8001bb:	e8 e8 18 00 00       	call   801aa8 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 c4 28 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8001ff:	e8 88 28 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800237:	68 24 34 80 00       	push   $0x803424
  80023c:	e8 67 18 00 00       	call   801aa8 <cprintf>
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
  80027e:	e8 64 2c 00 00       	call   802ee7 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 a4 34 80 00       	push   $0x8034a4
  80029e:	e8 05 18 00 00       	call   801aa8 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 e1 27 00 00       	call   802a8c <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 24 28 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8002b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	e8 91 25 00 00       	call   802858 <malloc>
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
  8002f2:	68 c8 34 80 00       	push   $0x8034c8
  8002f7:	e8 ac 17 00 00       	call   801aa8 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 7e 27 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800345:	68 fc 34 80 00       	push   $0x8034fc
  80034a:	e8 59 17 00 00       	call   801aa8 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 80 27 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 6c 35 80 00       	push   $0x80356c
  80036b:	e8 38 17 00 00       	call   801aa8 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 14 27 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8003b8:	e8 cf 26 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8003f0:	68 a0 35 80 00       	push   $0x8035a0
  8003f5:	e8 ae 16 00 00       	call   801aa8 <cprintf>
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
  80043b:	e8 a7 2a 00 00       	call   802ee7 <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 20 36 80 00       	push   $0x803620
  80045b:	e8 48 16 00 00       	call   801aa8 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 6f 26 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800468:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80046b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	01 d2                	add    %edx,%edx
  800472:	01 d0                	add    %edx,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	50                   	push   %eax
  800478:	e8 db 23 00 00       	call   802858 <malloc>
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
  8004a9:	68 44 36 80 00       	push   $0x803644
  8004ae:	e8 f5 15 00 00       	call   801aa8 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 c7 25 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8004fc:	68 78 36 80 00       	push   $0x803678
  800501:	e8 a2 15 00 00       	call   801aa8 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 c9 25 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 e8 36 80 00       	push   $0x8036e8
  800522:	e8 81 15 00 00       	call   801aa8 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 5d 25 00 00       	call   802a8c <sys_calculate_free_frames>
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
  80056d:	e8 1a 25 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8005a5:	68 1c 37 80 00       	push   $0x80371c
  8005aa:	e8 f9 14 00 00       	call   801aa8 <cprintf>
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
  8005f3:	e8 ef 28 00 00       	call   802ee7 <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 9c 37 80 00       	push   $0x80379c
  800613:	e8 90 14 00 00       	call   801aa8 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 b7 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800620:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	01 d2                	add    %edx,%edx
  80062a:	01 d0                	add    %edx,%eax
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	50                   	push   %eax
  800630:	e8 23 22 00 00       	call   802858 <malloc>
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
  800669:	68 c0 37 80 00       	push   $0x8037c0
  80066e:	e8 35 14 00 00       	call   801aa8 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 5c 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 f4 37 80 00       	push   $0x8037f4
  80068f:	e8 14 14 00 00       	call   801aa8 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 f0 23 00 00       	call   802a8c <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 33 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
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
  8006b8:	e8 9b 21 00 00       	call   802858 <malloc>
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
  8006f1:	68 28 38 80 00       	push   $0x803828
  8006f6:	e8 ad 13 00 00       	call   801aa8 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 7f 23 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800744:	68 5c 38 80 00       	push   $0x80385c
  800749:	e8 5a 13 00 00       	call   801aa8 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 81 23 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 cc 38 80 00       	push   $0x8038cc
  80076a:	e8 39 13 00 00       	call   801aa8 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 15 23 00 00       	call   802a8c <sys_calculate_free_frames>
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
  8007fc:	e8 8b 22 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800834:	68 00 39 80 00       	push   $0x803900
  800839:	e8 6a 12 00 00       	call   801aa8 <cprintf>
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
  800888:	e8 5a 26 00 00       	call   802ee7 <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 80 39 80 00       	push   $0x803980
  8008a8:	e8 fb 11 00 00       	call   801aa8 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 d7 21 00 00       	call   802a8c <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 1a 22 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 83 1f 00 00       	call   802858 <malloc>
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
  800909:	68 a4 39 80 00       	push   $0x8039a4
  80090e:	e8 95 11 00 00       	call   801aa8 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 67 21 00 00       	call   802a8c <sys_calculate_free_frames>
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
  80095c:	68 d8 39 80 00       	push   $0x8039d8
  800961:	e8 42 11 00 00       	call   801aa8 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 69 21 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 48 3a 80 00       	push   $0x803a48
  800982:	e8 21 11 00 00       	call   801aa8 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 fd 20 00 00       	call   802a8c <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 40 21 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
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
  8009ac:	e8 a7 1e 00 00       	call   802858 <malloc>
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
  8009ec:	68 7c 3a 80 00       	push   $0x803a7c
  8009f1:	e8 b2 10 00 00       	call   801aa8 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 84 20 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800a3f:	68 b0 3a 80 00       	push   $0x803ab0
  800a44:	e8 5f 10 00 00       	call   801aa8 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 86 20 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 20 3b 80 00       	push   $0x803b20
  800a65:	e8 3e 10 00 00       	call   801aa8 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 1a 20 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800ae5:	e8 a2 1f 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800b1d:	68 54 3b 80 00       	push   $0x803b54
  800b22:	e8 81 0f 00 00       	call   801aa8 <cprintf>
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
  800ba9:	e8 39 23 00 00       	call   802ee7 <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 d4 3b 80 00       	push   $0x803bd4
  800bc9:	e8 da 0e 00 00       	call   801aa8 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 b6 1e 00 00       	call   802a8c <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 f9 1e 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
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
  800bf4:	e8 5f 1c 00 00       	call   802858 <malloc>
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
  800c35:	68 f8 3b 80 00       	push   $0x803bf8
  800c3a:	e8 69 0e 00 00       	call   801aa8 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 3b 1e 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800c88:	68 2c 3c 80 00       	push   $0x803c2c
  800c8d:	e8 16 0e 00 00       	call   801aa8 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 3d 1e 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 9c 3c 80 00       	push   $0x803c9c
  800cae:	e8 f5 0d 00 00       	call   801aa8 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 d1 1d 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800d3f:	e8 48 1d 00 00       	call   802a8c <sys_calculate_free_frames>
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
  800d77:	68 d0 3c 80 00       	push   $0x803cd0
  800d7c:	e8 27 0d 00 00       	call   801aa8 <cprintf>
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
  800e09:	e8 d9 20 00 00       	call   802ee7 <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 50 3d 80 00       	push   $0x803d50
  800e29:	e8 7a 0c 00 00       	call   801aa8 <cprintf>
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
  800e5e:	68 74 3d 80 00       	push   $0x803d74
  800e63:	e8 40 0c 00 00       	call   801aa8 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 1c 1c 00 00       	call   802a8c <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 5f 1c 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f7 19 00 00       	call   802881 <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 45 1c 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 b4 3d 80 00       	push   $0x803db4
  800ea6:	e8 fd 0b 00 00       	call   801aa8 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 d9 1b 00 00       	call   802a8c <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 f4 3d 80 00       	push   $0x803df4
  800ed0:	e8 d3 0b 00 00       	call   801aa8 <cprintf>
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
  800f1e:	e8 c4 1f 00 00       	call   802ee7 <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 44 3e 80 00       	push   $0x803e44
  800f44:	e8 5f 0b 00 00       	call   801aa8 <cprintf>
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
  800f5d:	e8 2a 1b 00 00       	call   802a8c <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 6d 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 05 19 00 00       	call   802881 <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 53 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 6c 3e 80 00       	push   $0x803e6c
  800f98:	e8 0b 0b 00 00       	call   801aa8 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 e7 1a 00 00       	call   802a8c <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 ac 3e 80 00       	push   $0x803eac
  800fc2:	e8 e1 0a 00 00       	call   801aa8 <cprintf>
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
  801014:	e8 ce 1e 00 00       	call   802ee7 <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 fc 3e 80 00       	push   $0x803efc
  80103a:	e8 69 0a 00 00       	call   801aa8 <cprintf>
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
  801053:	e8 34 1a 00 00       	call   802a8c <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 77 1a 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0f 18 00 00       	call   802881 <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 5d 1a 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 24 3f 80 00       	push   $0x803f24
  80108e:	e8 15 0a 00 00       	call   801aa8 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 f1 19 00 00       	call   802a8c <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 64 3f 80 00       	push   $0x803f64
  8010b8:	e8 eb 09 00 00       	call   801aa8 <cprintf>
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
  80113f:	e8 a3 1d 00 00       	call   802ee7 <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 b4 3f 80 00       	push   $0x803fb4
  801165:	e8 3e 09 00 00       	call   801aa8 <cprintf>
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
  80117e:	e8 09 19 00 00       	call   802a8c <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 4c 19 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e4 16 00 00       	call   802881 <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 32 19 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 dc 3f 80 00       	push   $0x803fdc
  8011b9:	e8 ea 08 00 00       	call   801aa8 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 c6 18 00 00       	call   802a8c <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 1c 40 80 00       	push   $0x80401c
  8011e3:	e8 c0 08 00 00       	call   801aa8 <cprintf>
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
  801238:	e8 aa 1c 00 00       	call   802ee7 <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 6c 40 80 00       	push   $0x80406c
  80125e:	e8 45 08 00 00       	call   801aa8 <cprintf>
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
  801277:	e8 10 18 00 00       	call   802a8c <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 53 18 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 eb 15 00 00       	call   802881 <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 39 18 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 94 40 80 00       	push   $0x804094
  8012b2:	e8 f1 07 00 00       	call   801aa8 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 cd 17 00 00       	call   802a8c <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 d4 40 80 00       	push   $0x8040d4
  8012d7:	e8 cc 07 00 00       	call   801aa8 <cprintf>
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
  8012f0:	e8 97 17 00 00       	call   802a8c <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 da 17 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 72 15 00 00       	call   802881 <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 c0 17 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 18 41 80 00       	push   $0x804118
  80132b:	e8 78 07 00 00       	call   801aa8 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 54 17 00 00       	call   802a8c <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 58 41 80 00       	push   $0x804158
  801355:	e8 4e 07 00 00       	call   801aa8 <cprintf>
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
  8013aa:	e8 38 1b 00 00       	call   802ee7 <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 a8 41 80 00       	push   $0x8041a8
  8013d0:	e8 d3 06 00 00       	call   801aa8 <cprintf>
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
  8013e9:	e8 9e 16 00 00       	call   802a8c <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 e1 16 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 79 14 00 00       	call   802881 <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 c7 16 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 d0 41 80 00       	push   $0x8041d0
  801424:	e8 7f 06 00 00       	call   801aa8 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 5b 16 00 00       	call   802a8c <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 10 42 80 00       	push   $0x804210
  801449:	e8 5a 06 00 00       	call   801aa8 <cprintf>
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
  801462:	e8 25 16 00 00       	call   802a8c <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 68 16 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 00 14 00 00       	call   802881 <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 4e 16 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 60 42 80 00       	push   $0x804260
  80149d:	e8 06 06 00 00       	call   801aa8 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 e2 15 00 00       	call   802a8c <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 a0 42 80 00       	push   $0x8042a0
  8014c7:	e8 dc 05 00 00       	call   801aa8 <cprintf>
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
  801554:	e8 8e 19 00 00       	call   802ee7 <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 f0 42 80 00       	push   $0x8042f0
  80157a:	e8 29 05 00 00       	call   801aa8 <cprintf>
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
  80159d:	68 18 43 80 00       	push   $0x804318
  8015a2:	e8 01 05 00 00       	call   801aa8 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 84 17 00 00       	call   802d33 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8015af:	a1 04 50 80 00       	mov    0x805004,%eax
  8015b4:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8015ba:	a1 04 50 80 00       	mov    0x805004,%eax
  8015bf:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	a1 04 50 80 00       	mov    0x805004,%eax
  8015cc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8015d2:	52                   	push   %edx
  8015d3:	51                   	push   %ecx
  8015d4:	50                   	push   %eax
  8015d5:	68 86 43 80 00       	push   $0x804386
  8015da:	e8 08 16 00 00       	call   802be7 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 0f 16 00 00       	call   802c05 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 ae 17 00 00       	call   802dad <gettst>
  8015ff:	83 f8 01             	cmp    $0x1,%eax
  801602:	75 f6                	jne    8015fa <_main+0x15a1>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801604:	a1 04 50 80 00       	mov    0x805004,%eax
  801609:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80160f:	a1 04 50 80 00       	mov    0x805004,%eax
  801614:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	a1 04 50 80 00       	mov    0x805004,%eax
  801621:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801627:	52                   	push   %edx
  801628:	51                   	push   %ecx
  801629:	50                   	push   %eax
  80162a:	68 91 43 80 00       	push   $0x804391
  80162f:	e8 b3 15 00 00       	call   802be7 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 ba 15 00 00       	call   802c05 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 59 17 00 00       	call   802dad <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 35 17 00 00       	call   802d93 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 2a 19 00 00       	call   802f95 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 3a 17 00 00       	call   802dad <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 9c 43 80 00       	push   $0x80439c
  801687:	e8 1c 04 00 00       	call   801aa8 <cprintf>
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
  80169f:	68 2c 44 80 00       	push   $0x80442c
  8016a4:	e8 ff 03 00 00       	call   801aa8 <cprintf>
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
  8016ba:	e8 96 15 00 00       	call   802c55 <sys_getenvindex>
  8016bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	89 d0                	mov    %edx,%eax
  8016c7:	c1 e0 02             	shl    $0x2,%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	01 c0                	add    %eax,%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	c1 e0 02             	shl    $0x2,%eax
  8016d3:	01 d0                	add    %edx,%eax
  8016d5:	01 c0                	add    %eax,%eax
  8016d7:	01 d0                	add    %edx,%eax
  8016d9:	c1 e0 04             	shl    $0x4,%eax
  8016dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e1:	a3 04 50 80 00       	mov    %eax,0x805004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8016e6:	a1 04 50 80 00       	mov    0x805004,%eax
  8016eb:	8a 40 20             	mov    0x20(%eax),%al
  8016ee:	84 c0                	test   %al,%al
  8016f0:	74 0d                	je     8016ff <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8016f2:	a1 04 50 80 00       	mov    0x805004,%eax
  8016f7:	83 c0 20             	add    $0x20,%eax
  8016fa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8016ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801703:	7e 0a                	jle    80170f <libmain+0x5b>
		binaryname = argv[0];
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8b 00                	mov    (%eax),%eax
  80170a:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	ff 75 08             	pushl  0x8(%ebp)
  801718:	e8 3c e9 ff ff       	call   800059 <_main>
  80171d:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  801720:	e8 b4 12 00 00       	call   8029d9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	68 80 44 80 00       	push   $0x804480
  80172d:	e8 76 03 00 00       	call   801aa8 <cprintf>
  801732:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801735:	a1 04 50 80 00       	mov    0x805004,%eax
  80173a:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801740:	a1 04 50 80 00       	mov    0x805004,%eax
  801745:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	52                   	push   %edx
  80174f:	50                   	push   %eax
  801750:	68 a8 44 80 00       	push   $0x8044a8
  801755:	e8 4e 03 00 00       	call   801aa8 <cprintf>
  80175a:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80175d:	a1 04 50 80 00       	mov    0x805004,%eax
  801762:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  801768:	a1 04 50 80 00       	mov    0x805004,%eax
  80176d:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  801773:	a1 04 50 80 00       	mov    0x805004,%eax
  801778:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80177e:	51                   	push   %ecx
  80177f:	52                   	push   %edx
  801780:	50                   	push   %eax
  801781:	68 d0 44 80 00       	push   $0x8044d0
  801786:	e8 1d 03 00 00       	call   801aa8 <cprintf>
  80178b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80178e:	a1 04 50 80 00       	mov    0x805004,%eax
  801793:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	50                   	push   %eax
  80179d:	68 28 45 80 00       	push   $0x804528
  8017a2:	e8 01 03 00 00       	call   801aa8 <cprintf>
  8017a7:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	68 80 44 80 00       	push   $0x804480
  8017b2:	e8 f1 02 00 00       	call   801aa8 <cprintf>
  8017b7:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017ba:	e8 34 12 00 00       	call   8029f3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8017bf:	e8 19 00 00 00       	call   8017dd <exit>
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	6a 00                	push   $0x0
  8017d2:	e8 4a 14 00 00       	call   802c21 <sys_destroy_env>
  8017d7:	83 c4 10             	add    $0x10,%esp
}
  8017da:	90                   	nop
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <exit>:

void
exit(void)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8017e3:	e8 9f 14 00 00       	call   802c87 <sys_exit_env>
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f4:	83 c0 04             	add    $0x4,%eax
  8017f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017ff:	85 c0                	test   %eax,%eax
  801801:	74 16                	je     801819 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801803:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	50                   	push   %eax
  80180c:	68 3c 45 80 00       	push   $0x80453c
  801811:	e8 92 02 00 00       	call   801aa8 <cprintf>
  801816:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801819:	a1 00 50 80 00       	mov    0x805000,%eax
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	50                   	push   %eax
  801825:	68 41 45 80 00       	push   $0x804541
  80182a:	e8 79 02 00 00       	call   801aa8 <cprintf>
  80182f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801832:	8b 45 10             	mov    0x10(%ebp),%eax
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	ff 75 f4             	pushl  -0xc(%ebp)
  80183b:	50                   	push   %eax
  80183c:	e8 fc 01 00 00       	call   801a3d <vcprintf>
  801841:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	6a 00                	push   $0x0
  801849:	68 5d 45 80 00       	push   $0x80455d
  80184e:	e8 ea 01 00 00       	call   801a3d <vcprintf>
  801853:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801856:	e8 82 ff ff ff       	call   8017dd <exit>

	// should not return here
	while (1) ;
  80185b:	eb fe                	jmp    80185b <_panic+0x70>

0080185d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801863:	a1 04 50 80 00       	mov    0x805004,%eax
  801868:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	39 c2                	cmp    %eax,%edx
  801873:	74 14                	je     801889 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 60 45 80 00       	push   $0x804560
  80187d:	6a 26                	push   $0x26
  80187f:	68 ac 45 80 00       	push   $0x8045ac
  801884:	e8 62 ff ff ff       	call   8017eb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801890:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801897:	e9 c5 00 00 00       	jmp    801961 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 08                	jne    8018b9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018b1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018b4:	e9 a5 00 00 00       	jmp    80195e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018c7:	eb 69                	jmp    801932 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018c9:	a1 04 50 80 00       	mov    0x805004,%eax
  8018ce:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8018d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018d7:	89 d0                	mov    %edx,%eax
  8018d9:	01 c0                	add    %eax,%eax
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	c1 e0 03             	shl    $0x3,%eax
  8018e0:	01 c8                	add    %ecx,%eax
  8018e2:	8a 40 04             	mov    0x4(%eax),%al
  8018e5:	84 c0                	test   %al,%al
  8018e7:	75 46                	jne    80192f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018e9:	a1 04 50 80 00       	mov    0x805004,%eax
  8018ee:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8018f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f7:	89 d0                	mov    %edx,%eax
  8018f9:	01 c0                	add    %eax,%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c1 e0 03             	shl    $0x3,%eax
  801900:	01 c8                	add    %ecx,%eax
  801902:	8b 00                	mov    (%eax),%eax
  801904:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80190a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80190f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801914:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	01 c8                	add    %ecx,%eax
  801920:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801922:	39 c2                	cmp    %eax,%edx
  801924:	75 09                	jne    80192f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801926:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80192d:	eb 15                	jmp    801944 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80192f:	ff 45 e8             	incl   -0x18(%ebp)
  801932:	a1 04 50 80 00       	mov    0x805004,%eax
  801937:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80193d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801940:	39 c2                	cmp    %eax,%edx
  801942:	77 85                	ja     8018c9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801944:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801948:	75 14                	jne    80195e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 b8 45 80 00       	push   $0x8045b8
  801952:	6a 3a                	push   $0x3a
  801954:	68 ac 45 80 00       	push   $0x8045ac
  801959:	e8 8d fe ff ff       	call   8017eb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80195e:	ff 45 f0             	incl   -0x10(%ebp)
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801967:	0f 8c 2f ff ff ff    	jl     80189c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80196d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801974:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80197b:	eb 26                	jmp    8019a3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80197d:	a1 04 50 80 00       	mov    0x805004,%eax
  801982:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801988:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80198b:	89 d0                	mov    %edx,%eax
  80198d:	01 c0                	add    %eax,%eax
  80198f:	01 d0                	add    %edx,%eax
  801991:	c1 e0 03             	shl    $0x3,%eax
  801994:	01 c8                	add    %ecx,%eax
  801996:	8a 40 04             	mov    0x4(%eax),%al
  801999:	3c 01                	cmp    $0x1,%al
  80199b:	75 03                	jne    8019a0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80199d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a0:	ff 45 e0             	incl   -0x20(%ebp)
  8019a3:	a1 04 50 80 00       	mov    0x805004,%eax
  8019a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b1:	39 c2                	cmp    %eax,%edx
  8019b3:	77 c8                	ja     80197d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019bb:	74 14                	je     8019d1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 0c 46 80 00       	push   $0x80460c
  8019c5:	6a 44                	push   $0x44
  8019c7:	68 ac 45 80 00       	push   $0x8045ac
  8019cc:	e8 1a fe ff ff       	call   8017eb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dd:	8b 00                	mov    (%eax),%eax
  8019df:	8d 48 01             	lea    0x1(%eax),%ecx
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	89 0a                	mov    %ecx,(%edx)
  8019e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ea:	88 d1                	mov    %dl,%cl
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	8b 00                	mov    (%eax),%eax
  8019f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8019fd:	75 2c                	jne    801a2b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8019ff:	a0 08 50 80 00       	mov    0x805008,%al
  801a04:	0f b6 c0             	movzbl %al,%eax
  801a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0a:	8b 12                	mov    (%edx),%edx
  801a0c:	89 d1                	mov    %edx,%ecx
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	83 c2 08             	add    $0x8,%edx
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	50                   	push   %eax
  801a18:	51                   	push   %ecx
  801a19:	52                   	push   %edx
  801a1a:	e8 78 0f 00 00       	call   802997 <sys_cputs>
  801a1f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2e:	8b 40 04             	mov    0x4(%eax),%eax
  801a31:	8d 50 01             	lea    0x1(%eax),%edx
  801a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a37:	89 50 04             	mov    %edx,0x4(%eax)
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a46:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a4d:	00 00 00 
	b.cnt = 0;
  801a50:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a57:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	68 d4 19 80 00       	push   $0x8019d4
  801a6c:	e8 11 02 00 00       	call   801c82 <vprintfmt>
  801a71:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801a74:	a0 08 50 80 00       	mov    0x805008,%al
  801a79:	0f b6 c0             	movzbl %al,%eax
  801a7c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	50                   	push   %eax
  801a86:	52                   	push   %edx
  801a87:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a8d:	83 c0 08             	add    $0x8,%eax
  801a90:	50                   	push   %eax
  801a91:	e8 01 0f 00 00       	call   802997 <sys_cputs>
  801a96:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a99:	c6 05 08 50 80 00 00 	movb   $0x0,0x805008
	return b.cnt;
  801aa0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801aae:	c6 05 08 50 80 00 01 	movb   $0x1,0x805008
	va_start(ap, fmt);
  801ab5:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	e8 73 ff ff ff       	call   801a3d <vcprintf>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801adb:	e8 f9 0e 00 00       	call   8029d9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801ae0:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	ff 75 f4             	pushl  -0xc(%ebp)
  801aef:	50                   	push   %eax
  801af0:	e8 48 ff ff ff       	call   801a3d <vcprintf>
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801afb:	e8 f3 0e 00 00       	call   8029f3 <sys_unlock_cons>
	return cnt;
  801b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 14             	sub    $0x14,%esp
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b12:	8b 45 14             	mov    0x14(%ebp),%eax
  801b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b18:	8b 45 18             	mov    0x18(%ebp),%eax
  801b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b20:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b23:	77 55                	ja     801b7a <printnum+0x75>
  801b25:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b28:	72 05                	jb     801b2f <printnum+0x2a>
  801b2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b2d:	77 4b                	ja     801b7a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b2f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b32:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b35:	8b 45 18             	mov    0x18(%ebp),%eax
  801b38:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b42:	ff 75 f0             	pushl  -0x10(%ebp)
  801b45:	e8 02 15 00 00       	call   80304c <__udivdi3>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	83 ec 04             	sub    $0x4,%esp
  801b50:	ff 75 20             	pushl  0x20(%ebp)
  801b53:	53                   	push   %ebx
  801b54:	ff 75 18             	pushl  0x18(%ebp)
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	e8 a1 ff ff ff       	call   801b05 <printnum>
  801b64:	83 c4 20             	add    $0x20,%esp
  801b67:	eb 1a                	jmp    801b83 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 20             	pushl  0x20(%ebp)
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	ff d0                	call   *%eax
  801b77:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b7a:	ff 4d 1c             	decl   0x1c(%ebp)
  801b7d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b81:	7f e6                	jg     801b69 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b83:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b86:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b91:	53                   	push   %ebx
  801b92:	51                   	push   %ecx
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	e8 c2 15 00 00       	call   80315c <__umoddi3>
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	05 74 48 80 00       	add    $0x804874,%eax
  801ba2:	8a 00                	mov    (%eax),%al
  801ba4:	0f be c0             	movsbl %al,%eax
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	50                   	push   %eax
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	ff d0                	call   *%eax
  801bb3:	83 c4 10             	add    $0x10,%esp
}
  801bb6:	90                   	nop
  801bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bbf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bc3:	7e 1c                	jle    801be1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	8d 50 08             	lea    0x8(%eax),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	89 10                	mov    %edx,(%eax)
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	8b 00                	mov    (%eax),%eax
  801bd7:	83 e8 08             	sub    $0x8,%eax
  801bda:	8b 50 04             	mov    0x4(%eax),%edx
  801bdd:	8b 00                	mov    (%eax),%eax
  801bdf:	eb 40                	jmp    801c21 <getuint+0x65>
	else if (lflag)
  801be1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801be5:	74 1e                	je     801c05 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	8b 00                	mov    (%eax),%eax
  801bec:	8d 50 04             	lea    0x4(%eax),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	89 10                	mov    %edx,(%eax)
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	8b 00                	mov    (%eax),%eax
  801bf9:	83 e8 04             	sub    $0x4,%eax
  801bfc:	8b 00                	mov    (%eax),%eax
  801bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801c03:	eb 1c                	jmp    801c21 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	8b 00                	mov    (%eax),%eax
  801c0a:	8d 50 04             	lea    0x4(%eax),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	89 10                	mov    %edx,(%eax)
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8b 00                	mov    (%eax),%eax
  801c17:	83 e8 04             	sub    $0x4,%eax
  801c1a:	8b 00                	mov    (%eax),%eax
  801c1c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    

00801c23 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c26:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c2a:	7e 1c                	jle    801c48 <getint+0x25>
		return va_arg(*ap, long long);
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8b 00                	mov    (%eax),%eax
  801c31:	8d 50 08             	lea    0x8(%eax),%edx
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	89 10                	mov    %edx,(%eax)
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8b 00                	mov    (%eax),%eax
  801c3e:	83 e8 08             	sub    $0x8,%eax
  801c41:	8b 50 04             	mov    0x4(%eax),%edx
  801c44:	8b 00                	mov    (%eax),%eax
  801c46:	eb 38                	jmp    801c80 <getint+0x5d>
	else if (lflag)
  801c48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c4c:	74 1a                	je     801c68 <getint+0x45>
		return va_arg(*ap, long);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8b 00                	mov    (%eax),%eax
  801c53:	8d 50 04             	lea    0x4(%eax),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	89 10                	mov    %edx,(%eax)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	8b 00                	mov    (%eax),%eax
  801c60:	83 e8 04             	sub    $0x4,%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	99                   	cltd   
  801c66:	eb 18                	jmp    801c80 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	8b 00                	mov    (%eax),%eax
  801c6d:	8d 50 04             	lea    0x4(%eax),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	89 10                	mov    %edx,(%eax)
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	8b 00                	mov    (%eax),%eax
  801c7a:	83 e8 04             	sub    $0x4,%eax
  801c7d:	8b 00                	mov    (%eax),%eax
  801c7f:	99                   	cltd   
}
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	56                   	push   %esi
  801c86:	53                   	push   %ebx
  801c87:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c8a:	eb 17                	jmp    801ca3 <vprintfmt+0x21>
			if (ch == '\0')
  801c8c:	85 db                	test   %ebx,%ebx
  801c8e:	0f 84 c1 03 00 00    	je     802055 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	53                   	push   %ebx
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	ff d0                	call   *%eax
  801ca0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca6:	8d 50 01             	lea    0x1(%eax),%edx
  801ca9:	89 55 10             	mov    %edx,0x10(%ebp)
  801cac:	8a 00                	mov    (%eax),%al
  801cae:	0f b6 d8             	movzbl %al,%ebx
  801cb1:	83 fb 25             	cmp    $0x25,%ebx
  801cb4:	75 d6                	jne    801c8c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801cb6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801cba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801cc1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cc8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ccf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	8d 50 01             	lea    0x1(%eax),%edx
  801cdc:	89 55 10             	mov    %edx,0x10(%ebp)
  801cdf:	8a 00                	mov    (%eax),%al
  801ce1:	0f b6 d8             	movzbl %al,%ebx
  801ce4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ce7:	83 f8 5b             	cmp    $0x5b,%eax
  801cea:	0f 87 3d 03 00 00    	ja     80202d <vprintfmt+0x3ab>
  801cf0:	8b 04 85 98 48 80 00 	mov    0x804898(,%eax,4),%eax
  801cf7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801cf9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801cfd:	eb d7                	jmp    801cd6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801cff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d03:	eb d1                	jmp    801cd6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	c1 e0 02             	shl    $0x2,%eax
  801d14:	01 d0                	add    %edx,%eax
  801d16:	01 c0                	add    %eax,%eax
  801d18:	01 d8                	add    %ebx,%eax
  801d1a:	83 e8 30             	sub    $0x30,%eax
  801d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d20:	8b 45 10             	mov    0x10(%ebp),%eax
  801d23:	8a 00                	mov    (%eax),%al
  801d25:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d28:	83 fb 2f             	cmp    $0x2f,%ebx
  801d2b:	7e 3e                	jle    801d6b <vprintfmt+0xe9>
  801d2d:	83 fb 39             	cmp    $0x39,%ebx
  801d30:	7f 39                	jg     801d6b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d32:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d35:	eb d5                	jmp    801d0c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d37:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3a:	83 c0 04             	add    $0x4,%eax
  801d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  801d40:	8b 45 14             	mov    0x14(%ebp),%eax
  801d43:	83 e8 04             	sub    $0x4,%eax
  801d46:	8b 00                	mov    (%eax),%eax
  801d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d4b:	eb 1f                	jmp    801d6c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d51:	79 83                	jns    801cd6 <vprintfmt+0x54>
				width = 0;
  801d53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d5a:	e9 77 ff ff ff       	jmp    801cd6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d5f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d66:	e9 6b ff ff ff       	jmp    801cd6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d6b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d70:	0f 89 60 ff ff ff    	jns    801cd6 <vprintfmt+0x54>
				width = precision, precision = -1;
  801d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d83:	e9 4e ff ff ff       	jmp    801cd6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d88:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d8b:	e9 46 ff ff ff       	jmp    801cd6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d90:	8b 45 14             	mov    0x14(%ebp),%eax
  801d93:	83 c0 04             	add    $0x4,%eax
  801d96:	89 45 14             	mov    %eax,0x14(%ebp)
  801d99:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9c:	83 e8 04             	sub    $0x4,%eax
  801d9f:	8b 00                	mov    (%eax),%eax
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	50                   	push   %eax
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	ff d0                	call   *%eax
  801dad:	83 c4 10             	add    $0x10,%esp
			break;
  801db0:	e9 9b 02 00 00       	jmp    802050 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801db5:	8b 45 14             	mov    0x14(%ebp),%eax
  801db8:	83 c0 04             	add    $0x4,%eax
  801dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  801dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc1:	83 e8 04             	sub    $0x4,%eax
  801dc4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801dc6:	85 db                	test   %ebx,%ebx
  801dc8:	79 02                	jns    801dcc <vprintfmt+0x14a>
				err = -err;
  801dca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801dcc:	83 fb 64             	cmp    $0x64,%ebx
  801dcf:	7f 0b                	jg     801ddc <vprintfmt+0x15a>
  801dd1:	8b 34 9d e0 46 80 00 	mov    0x8046e0(,%ebx,4),%esi
  801dd8:	85 f6                	test   %esi,%esi
  801dda:	75 19                	jne    801df5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ddc:	53                   	push   %ebx
  801ddd:	68 85 48 80 00       	push   $0x804885
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	e8 70 02 00 00       	call   80205d <printfmt>
  801ded:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801df0:	e9 5b 02 00 00       	jmp    802050 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801df5:	56                   	push   %esi
  801df6:	68 8e 48 80 00       	push   $0x80488e
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	e8 57 02 00 00       	call   80205d <printfmt>
  801e06:	83 c4 10             	add    $0x10,%esp
			break;
  801e09:	e9 42 02 00 00       	jmp    802050 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e11:	83 c0 04             	add    $0x4,%eax
  801e14:	89 45 14             	mov    %eax,0x14(%ebp)
  801e17:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1a:	83 e8 04             	sub    $0x4,%eax
  801e1d:	8b 30                	mov    (%eax),%esi
  801e1f:	85 f6                	test   %esi,%esi
  801e21:	75 05                	jne    801e28 <vprintfmt+0x1a6>
				p = "(null)";
  801e23:	be 91 48 80 00       	mov    $0x804891,%esi
			if (width > 0 && padc != '-')
  801e28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e2c:	7e 6d                	jle    801e9b <vprintfmt+0x219>
  801e2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e32:	74 67                	je     801e9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	50                   	push   %eax
  801e3b:	56                   	push   %esi
  801e3c:	e8 1e 03 00 00       	call   80215f <strnlen>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e47:	eb 16                	jmp    801e5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e4d:	83 ec 08             	sub    $0x8,%esp
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	50                   	push   %eax
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	ff d0                	call   *%eax
  801e59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e5c:	ff 4d e4             	decl   -0x1c(%ebp)
  801e5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e63:	7f e4                	jg     801e49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e65:	eb 34                	jmp    801e9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e6b:	74 1c                	je     801e89 <vprintfmt+0x207>
  801e6d:	83 fb 1f             	cmp    $0x1f,%ebx
  801e70:	7e 05                	jle    801e77 <vprintfmt+0x1f5>
  801e72:	83 fb 7e             	cmp    $0x7e,%ebx
  801e75:	7e 12                	jle    801e89 <vprintfmt+0x207>
					putch('?', putdat);
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	6a 3f                	push   $0x3f
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	ff d0                	call   *%eax
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	eb 0f                	jmp    801e98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e89:	83 ec 08             	sub    $0x8,%esp
  801e8c:	ff 75 0c             	pushl  0xc(%ebp)
  801e8f:	53                   	push   %ebx
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	ff d0                	call   *%eax
  801e95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e98:	ff 4d e4             	decl   -0x1c(%ebp)
  801e9b:	89 f0                	mov    %esi,%eax
  801e9d:	8d 70 01             	lea    0x1(%eax),%esi
  801ea0:	8a 00                	mov    (%eax),%al
  801ea2:	0f be d8             	movsbl %al,%ebx
  801ea5:	85 db                	test   %ebx,%ebx
  801ea7:	74 24                	je     801ecd <vprintfmt+0x24b>
  801ea9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ead:	78 b8                	js     801e67 <vprintfmt+0x1e5>
  801eaf:	ff 4d e0             	decl   -0x20(%ebp)
  801eb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eb6:	79 af                	jns    801e67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801eb8:	eb 13                	jmp    801ecd <vprintfmt+0x24b>
				putch(' ', putdat);
  801eba:	83 ec 08             	sub    $0x8,%esp
  801ebd:	ff 75 0c             	pushl  0xc(%ebp)
  801ec0:	6a 20                	push   $0x20
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	ff d0                	call   *%eax
  801ec7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801eca:	ff 4d e4             	decl   -0x1c(%ebp)
  801ecd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ed1:	7f e7                	jg     801eba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ed3:	e9 78 01 00 00       	jmp    802050 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	ff 75 e8             	pushl  -0x18(%ebp)
  801ede:	8d 45 14             	lea    0x14(%ebp),%eax
  801ee1:	50                   	push   %eax
  801ee2:	e8 3c fd ff ff       	call   801c23 <getint>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef6:	85 d2                	test   %edx,%edx
  801ef8:	79 23                	jns    801f1d <vprintfmt+0x29b>
				putch('-', putdat);
  801efa:	83 ec 08             	sub    $0x8,%esp
  801efd:	ff 75 0c             	pushl  0xc(%ebp)
  801f00:	6a 2d                	push   $0x2d
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	ff d0                	call   *%eax
  801f07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f10:	f7 d8                	neg    %eax
  801f12:	83 d2 00             	adc    $0x0,%edx
  801f15:	f7 da                	neg    %edx
  801f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f24:	e9 bc 00 00 00       	jmp    801fe5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f29:	83 ec 08             	sub    $0x8,%esp
  801f2c:	ff 75 e8             	pushl  -0x18(%ebp)
  801f2f:	8d 45 14             	lea    0x14(%ebp),%eax
  801f32:	50                   	push   %eax
  801f33:	e8 84 fc ff ff       	call   801bbc <getuint>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f48:	e9 98 00 00 00       	jmp    801fe5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f4d:	83 ec 08             	sub    $0x8,%esp
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	6a 58                	push   $0x58
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	ff d0                	call   *%eax
  801f5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f5d:	83 ec 08             	sub    $0x8,%esp
  801f60:	ff 75 0c             	pushl  0xc(%ebp)
  801f63:	6a 58                	push   $0x58
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	ff d0                	call   *%eax
  801f6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f6d:	83 ec 08             	sub    $0x8,%esp
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	6a 58                	push   $0x58
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	ff d0                	call   *%eax
  801f7a:	83 c4 10             	add    $0x10,%esp
			break;
  801f7d:	e9 ce 00 00 00       	jmp    802050 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	6a 30                	push   $0x30
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	ff d0                	call   *%eax
  801f8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	6a 78                	push   $0x78
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	ff d0                	call   *%eax
  801f9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa5:	83 c0 04             	add    $0x4,%eax
  801fa8:	89 45 14             	mov    %eax,0x14(%ebp)
  801fab:	8b 45 14             	mov    0x14(%ebp),%eax
  801fae:	83 e8 04             	sub    $0x4,%eax
  801fb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801fbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801fc4:	eb 1f                	jmp    801fe5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	ff 75 e8             	pushl  -0x18(%ebp)
  801fcc:	8d 45 14             	lea    0x14(%ebp),%eax
  801fcf:	50                   	push   %eax
  801fd0:	e8 e7 fb ff ff       	call   801bbc <getuint>
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801fde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801fe5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	52                   	push   %edx
  801ff0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff7:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffa:	ff 75 0c             	pushl  0xc(%ebp)
  801ffd:	ff 75 08             	pushl  0x8(%ebp)
  802000:	e8 00 fb ff ff       	call   801b05 <printnum>
  802005:	83 c4 20             	add    $0x20,%esp
			break;
  802008:	eb 46                	jmp    802050 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80200a:	83 ec 08             	sub    $0x8,%esp
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	53                   	push   %ebx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	ff d0                	call   *%eax
  802016:	83 c4 10             	add    $0x10,%esp
			break;
  802019:	eb 35                	jmp    802050 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80201b:	c6 05 08 50 80 00 00 	movb   $0x0,0x805008
			break;
  802022:	eb 2c                	jmp    802050 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802024:	c6 05 08 50 80 00 01 	movb   $0x1,0x805008
			break;
  80202b:	eb 23                	jmp    802050 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	6a 25                	push   $0x25
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	ff d0                	call   *%eax
  80203a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80203d:	ff 4d 10             	decl   0x10(%ebp)
  802040:	eb 03                	jmp    802045 <vprintfmt+0x3c3>
  802042:	ff 4d 10             	decl   0x10(%ebp)
  802045:	8b 45 10             	mov    0x10(%ebp),%eax
  802048:	48                   	dec    %eax
  802049:	8a 00                	mov    (%eax),%al
  80204b:	3c 25                	cmp    $0x25,%al
  80204d:	75 f3                	jne    802042 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80204f:	90                   	nop
		}
	}
  802050:	e9 35 fc ff ff       	jmp    801c8a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802055:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802056:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802063:	8d 45 10             	lea    0x10(%ebp),%eax
  802066:	83 c0 04             	add    $0x4,%eax
  802069:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80206c:	8b 45 10             	mov    0x10(%ebp),%eax
  80206f:	ff 75 f4             	pushl  -0xc(%ebp)
  802072:	50                   	push   %eax
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	e8 04 fc ff ff       	call   801c82 <vprintfmt>
  80207e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802081:	90                   	nop
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	8b 40 08             	mov    0x8(%eax),%eax
  80208d:	8d 50 01             	lea    0x1(%eax),%edx
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	8b 10                	mov    (%eax),%edx
  80209b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209e:	8b 40 04             	mov    0x4(%eax),%eax
  8020a1:	39 c2                	cmp    %eax,%edx
  8020a3:	73 12                	jae    8020b7 <sprintputch+0x33>
		*b->buf++ = ch;
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	8b 00                	mov    (%eax),%eax
  8020aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8020ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b0:	89 0a                	mov    %ecx,(%edx)
  8020b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b5:	88 10                	mov    %dl,(%eax)
}
  8020b7:	90                   	nop
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020df:	74 06                	je     8020e7 <vsnprintf+0x2d>
  8020e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e5:	7f 07                	jg     8020ee <vsnprintf+0x34>
		return -E_INVAL;
  8020e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8020ec:	eb 20                	jmp    80210e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020ee:	ff 75 14             	pushl  0x14(%ebp)
  8020f1:	ff 75 10             	pushl  0x10(%ebp)
  8020f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020f7:	50                   	push   %eax
  8020f8:	68 84 20 80 00       	push   $0x802084
  8020fd:	e8 80 fb ff ff       	call   801c82 <vprintfmt>
  802102:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802108:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802116:	8d 45 10             	lea    0x10(%ebp),%eax
  802119:	83 c0 04             	add    $0x4,%eax
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80211f:	8b 45 10             	mov    0x10(%ebp),%eax
  802122:	ff 75 f4             	pushl  -0xc(%ebp)
  802125:	50                   	push   %eax
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	e8 89 ff ff ff       	call   8020ba <vsnprintf>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802137:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802149:	eb 06                	jmp    802151 <strlen+0x15>
		n++;
  80214b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80214e:	ff 45 08             	incl   0x8(%ebp)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8a 00                	mov    (%eax),%al
  802156:	84 c0                	test   %al,%al
  802158:	75 f1                	jne    80214b <strlen+0xf>
		n++;
	return n;
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80216c:	eb 09                	jmp    802177 <strnlen+0x18>
		n++;
  80216e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802171:	ff 45 08             	incl   0x8(%ebp)
  802174:	ff 4d 0c             	decl   0xc(%ebp)
  802177:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80217b:	74 09                	je     802186 <strnlen+0x27>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8a 00                	mov    (%eax),%al
  802182:	84 c0                	test   %al,%al
  802184:	75 e8                	jne    80216e <strnlen+0xf>
		n++;
	return n;
  802186:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802197:	90                   	nop
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	8d 50 01             	lea    0x1(%eax),%edx
  80219e:	89 55 08             	mov    %edx,0x8(%ebp)
  8021a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021aa:	8a 12                	mov    (%edx),%dl
  8021ac:	88 10                	mov    %dl,(%eax)
  8021ae:	8a 00                	mov    (%eax),%al
  8021b0:	84 c0                	test   %al,%al
  8021b2:	75 e4                	jne    802198 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8021b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8021c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021cc:	eb 1f                	jmp    8021ed <strncpy+0x34>
		*dst++ = *src;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8d 50 01             	lea    0x1(%eax),%edx
  8021d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	8a 12                	mov    (%edx),%dl
  8021dc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e1:	8a 00                	mov    (%eax),%al
  8021e3:	84 c0                	test   %al,%al
  8021e5:	74 03                	je     8021ea <strncpy+0x31>
			src++;
  8021e7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021ea:	ff 45 fc             	incl   -0x4(%ebp)
  8021ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021f3:	72 d9                	jb     8021ce <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8021f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802206:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220a:	74 30                	je     80223c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80220c:	eb 16                	jmp    802224 <strlcpy+0x2a>
			*dst++ = *src++;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	8d 50 01             	lea    0x1(%eax),%edx
  802214:	89 55 08             	mov    %edx,0x8(%ebp)
  802217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80221d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802220:	8a 12                	mov    (%edx),%dl
  802222:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802224:	ff 4d 10             	decl   0x10(%ebp)
  802227:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80222b:	74 09                	je     802236 <strlcpy+0x3c>
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	8a 00                	mov    (%eax),%al
  802232:	84 c0                	test   %al,%al
  802234:	75 d8                	jne    80220e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80223c:	8b 55 08             	mov    0x8(%ebp),%edx
  80223f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802242:	29 c2                	sub    %eax,%edx
  802244:	89 d0                	mov    %edx,%eax
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80224b:	eb 06                	jmp    802253 <strcmp+0xb>
		p++, q++;
  80224d:	ff 45 08             	incl   0x8(%ebp)
  802250:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8a 00                	mov    (%eax),%al
  802258:	84 c0                	test   %al,%al
  80225a:	74 0e                	je     80226a <strcmp+0x22>
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8a 10                	mov    (%eax),%dl
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	8a 00                	mov    (%eax),%al
  802266:	38 c2                	cmp    %al,%dl
  802268:	74 e3                	je     80224d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8a 00                	mov    (%eax),%al
  80226f:	0f b6 d0             	movzbl %al,%edx
  802272:	8b 45 0c             	mov    0xc(%ebp),%eax
  802275:	8a 00                	mov    (%eax),%al
  802277:	0f b6 c0             	movzbl %al,%eax
  80227a:	29 c2                	sub    %eax,%edx
  80227c:	89 d0                	mov    %edx,%eax
}
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    

00802280 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802283:	eb 09                	jmp    80228e <strncmp+0xe>
		n--, p++, q++;
  802285:	ff 4d 10             	decl   0x10(%ebp)
  802288:	ff 45 08             	incl   0x8(%ebp)
  80228b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80228e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802292:	74 17                	je     8022ab <strncmp+0x2b>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8a 00                	mov    (%eax),%al
  802299:	84 c0                	test   %al,%al
  80229b:	74 0e                	je     8022ab <strncmp+0x2b>
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8a 10                	mov    (%eax),%dl
  8022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a5:	8a 00                	mov    (%eax),%al
  8022a7:	38 c2                	cmp    %al,%dl
  8022a9:	74 da                	je     802285 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022af:	75 07                	jne    8022b8 <strncmp+0x38>
		return 0;
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b6:	eb 14                	jmp    8022cc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	0f b6 d0             	movzbl %al,%edx
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	8a 00                	mov    (%eax),%al
  8022c5:	0f b6 c0             	movzbl %al,%eax
  8022c8:	29 c2                	sub    %eax,%edx
  8022ca:	89 d0                	mov    %edx,%eax
}
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    

008022ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022da:	eb 12                	jmp    8022ee <strchr+0x20>
		if (*s == c)
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	8a 00                	mov    (%eax),%al
  8022e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022e4:	75 05                	jne    8022eb <strchr+0x1d>
			return (char *) s;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	eb 11                	jmp    8022fc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022eb:	ff 45 08             	incl   0x8(%ebp)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8a 00                	mov    (%eax),%al
  8022f3:	84 c0                	test   %al,%al
  8022f5:	75 e5                	jne    8022dc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80230a:	eb 0d                	jmp    802319 <strfind+0x1b>
		if (*s == c)
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8a 00                	mov    (%eax),%al
  802311:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802314:	74 0e                	je     802324 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802316:	ff 45 08             	incl   0x8(%ebp)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8a 00                	mov    (%eax),%al
  80231e:	84 c0                	test   %al,%al
  802320:	75 ea                	jne    80230c <strfind+0xe>
  802322:	eb 01                	jmp    802325 <strfind+0x27>
		if (*s == c)
			break;
  802324:	90                   	nop
	return (char *) s;
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802336:	8b 45 10             	mov    0x10(%ebp),%eax
  802339:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80233c:	eb 0e                	jmp    80234c <memset+0x22>
		*p++ = c;
  80233e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802341:	8d 50 01             	lea    0x1(%eax),%edx
  802344:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80234c:	ff 4d f8             	decl   -0x8(%ebp)
  80234f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802353:	79 e9                	jns    80233e <memset+0x14>
		*p++ = c;

	return v;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802360:	8b 45 0c             	mov    0xc(%ebp),%eax
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80236c:	eb 16                	jmp    802384 <memcpy+0x2a>
		*d++ = *s++;
  80236e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802371:	8d 50 01             	lea    0x1(%eax),%edx
  802374:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802377:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80237a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80237d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802380:	8a 12                	mov    (%edx),%dl
  802382:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802384:	8b 45 10             	mov    0x10(%ebp),%eax
  802387:	8d 50 ff             	lea    -0x1(%eax),%edx
  80238a:	89 55 10             	mov    %edx,0x10(%ebp)
  80238d:	85 c0                	test   %eax,%eax
  80238f:	75 dd                	jne    80236e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80239c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8023a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023ae:	73 50                	jae    802400 <memmove+0x6a>
  8023b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023bb:	76 43                	jbe    802400 <memmove+0x6a>
		s += n;
  8023bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8023c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023c9:	eb 10                	jmp    8023db <memmove+0x45>
			*--d = *--s;
  8023cb:	ff 4d f8             	decl   -0x8(%ebp)
  8023ce:	ff 4d fc             	decl   -0x4(%ebp)
  8023d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d4:	8a 10                	mov    (%eax),%dl
  8023d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023d9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8023db:	8b 45 10             	mov    0x10(%ebp),%eax
  8023de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 e3                	jne    8023cb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023e8:	eb 23                	jmp    80240d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8023ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ed:	8d 50 01             	lea    0x1(%eax),%edx
  8023f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8023f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8023fc:	8a 12                	mov    (%edx),%dl
  8023fe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802400:	8b 45 10             	mov    0x10(%ebp),%eax
  802403:	8d 50 ff             	lea    -0x1(%eax),%edx
  802406:	89 55 10             	mov    %edx,0x10(%ebp)
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 dd                	jne    8023ea <memmove+0x54>
			*d++ = *s++;

	return dst;
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80241e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802421:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802424:	eb 2a                	jmp    802450 <memcmp+0x3e>
		if (*s1 != *s2)
  802426:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802429:	8a 10                	mov    (%eax),%dl
  80242b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	38 c2                	cmp    %al,%dl
  802432:	74 16                	je     80244a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802434:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802437:	8a 00                	mov    (%eax),%al
  802439:	0f b6 d0             	movzbl %al,%edx
  80243c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80243f:	8a 00                	mov    (%eax),%al
  802441:	0f b6 c0             	movzbl %al,%eax
  802444:	29 c2                	sub    %eax,%edx
  802446:	89 d0                	mov    %edx,%eax
  802448:	eb 18                	jmp    802462 <memcmp+0x50>
		s1++, s2++;
  80244a:	ff 45 fc             	incl   -0x4(%ebp)
  80244d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802450:	8b 45 10             	mov    0x10(%ebp),%eax
  802453:	8d 50 ff             	lea    -0x1(%eax),%edx
  802456:	89 55 10             	mov    %edx,0x10(%ebp)
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 c9                	jne    802426 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
  80246d:	8b 45 10             	mov    0x10(%ebp),%eax
  802470:	01 d0                	add    %edx,%eax
  802472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802475:	eb 15                	jmp    80248c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	8a 00                	mov    (%eax),%al
  80247c:	0f b6 d0             	movzbl %al,%edx
  80247f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802482:	0f b6 c0             	movzbl %al,%eax
  802485:	39 c2                	cmp    %eax,%edx
  802487:	74 0d                	je     802496 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802489:	ff 45 08             	incl   0x8(%ebp)
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802492:	72 e3                	jb     802477 <memfind+0x13>
  802494:	eb 01                	jmp    802497 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802496:	90                   	nop
	return (void *) s;
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8024a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8024a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024b0:	eb 03                	jmp    8024b5 <strtol+0x19>
		s++;
  8024b2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8a 00                	mov    (%eax),%al
  8024ba:	3c 20                	cmp    $0x20,%al
  8024bc:	74 f4                	je     8024b2 <strtol+0x16>
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	8a 00                	mov    (%eax),%al
  8024c3:	3c 09                	cmp    $0x9,%al
  8024c5:	74 eb                	je     8024b2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	8a 00                	mov    (%eax),%al
  8024cc:	3c 2b                	cmp    $0x2b,%al
  8024ce:	75 05                	jne    8024d5 <strtol+0x39>
		s++;
  8024d0:	ff 45 08             	incl   0x8(%ebp)
  8024d3:	eb 13                	jmp    8024e8 <strtol+0x4c>
	else if (*s == '-')
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	8a 00                	mov    (%eax),%al
  8024da:	3c 2d                	cmp    $0x2d,%al
  8024dc:	75 0a                	jne    8024e8 <strtol+0x4c>
		s++, neg = 1;
  8024de:	ff 45 08             	incl   0x8(%ebp)
  8024e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024ec:	74 06                	je     8024f4 <strtol+0x58>
  8024ee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8024f2:	75 20                	jne    802514 <strtol+0x78>
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8a 00                	mov    (%eax),%al
  8024f9:	3c 30                	cmp    $0x30,%al
  8024fb:	75 17                	jne    802514 <strtol+0x78>
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	40                   	inc    %eax
  802501:	8a 00                	mov    (%eax),%al
  802503:	3c 78                	cmp    $0x78,%al
  802505:	75 0d                	jne    802514 <strtol+0x78>
		s += 2, base = 16;
  802507:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80250b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802512:	eb 28                	jmp    80253c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802514:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802518:	75 15                	jne    80252f <strtol+0x93>
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	8a 00                	mov    (%eax),%al
  80251f:	3c 30                	cmp    $0x30,%al
  802521:	75 0c                	jne    80252f <strtol+0x93>
		s++, base = 8;
  802523:	ff 45 08             	incl   0x8(%ebp)
  802526:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80252d:	eb 0d                	jmp    80253c <strtol+0xa0>
	else if (base == 0)
  80252f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802533:	75 07                	jne    80253c <strtol+0xa0>
		base = 10;
  802535:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	8a 00                	mov    (%eax),%al
  802541:	3c 2f                	cmp    $0x2f,%al
  802543:	7e 19                	jle    80255e <strtol+0xc2>
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	8a 00                	mov    (%eax),%al
  80254a:	3c 39                	cmp    $0x39,%al
  80254c:	7f 10                	jg     80255e <strtol+0xc2>
			dig = *s - '0';
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	8a 00                	mov    (%eax),%al
  802553:	0f be c0             	movsbl %al,%eax
  802556:	83 e8 30             	sub    $0x30,%eax
  802559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255c:	eb 42                	jmp    8025a0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8a 00                	mov    (%eax),%al
  802563:	3c 60                	cmp    $0x60,%al
  802565:	7e 19                	jle    802580 <strtol+0xe4>
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	8a 00                	mov    (%eax),%al
  80256c:	3c 7a                	cmp    $0x7a,%al
  80256e:	7f 10                	jg     802580 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	8a 00                	mov    (%eax),%al
  802575:	0f be c0             	movsbl %al,%eax
  802578:	83 e8 57             	sub    $0x57,%eax
  80257b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257e:	eb 20                	jmp    8025a0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	8a 00                	mov    (%eax),%al
  802585:	3c 40                	cmp    $0x40,%al
  802587:	7e 39                	jle    8025c2 <strtol+0x126>
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	8a 00                	mov    (%eax),%al
  80258e:	3c 5a                	cmp    $0x5a,%al
  802590:	7f 30                	jg     8025c2 <strtol+0x126>
			dig = *s - 'A' + 10;
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	8a 00                	mov    (%eax),%al
  802597:	0f be c0             	movsbl %al,%eax
  80259a:	83 e8 37             	sub    $0x37,%eax
  80259d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8025a6:	7d 19                	jge    8025c1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8025a8:	ff 45 08             	incl   0x8(%ebp)
  8025ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ae:	0f af 45 10          	imul   0x10(%ebp),%eax
  8025b2:	89 c2                	mov    %eax,%edx
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	01 d0                	add    %edx,%eax
  8025b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8025bc:	e9 7b ff ff ff       	jmp    80253c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8025c1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8025c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025c6:	74 08                	je     8025d0 <strtol+0x134>
		*endptr = (char *) s;
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8025d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025d4:	74 07                	je     8025dd <strtol+0x141>
  8025d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025d9:	f7 d8                	neg    %eax
  8025db:	eb 03                	jmp    8025e0 <strtol+0x144>
  8025dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <ltostr>:

void
ltostr(long value, char *str)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8025e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8025ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8025f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025fa:	79 13                	jns    80260f <ltostr+0x2d>
	{
		neg = 1;
  8025fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802603:	8b 45 0c             	mov    0xc(%ebp),%eax
  802606:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802609:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80260c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802617:	99                   	cltd   
  802618:	f7 f9                	idiv   %ecx
  80261a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80261d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802620:	8d 50 01             	lea    0x1(%eax),%edx
  802623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802626:	89 c2                	mov    %eax,%edx
  802628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262b:	01 d0                	add    %edx,%eax
  80262d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802630:	83 c2 30             	add    $0x30,%edx
  802633:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802635:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802638:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80263d:	f7 e9                	imul   %ecx
  80263f:	c1 fa 02             	sar    $0x2,%edx
  802642:	89 c8                	mov    %ecx,%eax
  802644:	c1 f8 1f             	sar    $0x1f,%eax
  802647:	29 c2                	sub    %eax,%edx
  802649:	89 d0                	mov    %edx,%eax
  80264b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80264e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802652:	75 bb                	jne    80260f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802654:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80265b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80265e:	48                   	dec    %eax
  80265f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802662:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802666:	74 3d                	je     8026a5 <ltostr+0xc3>
		start = 1 ;
  802668:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80266f:	eb 34                	jmp    8026a5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802674:	8b 45 0c             	mov    0xc(%ebp),%eax
  802677:	01 d0                	add    %edx,%eax
  802679:	8a 00                	mov    (%eax),%al
  80267b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	8b 45 0c             	mov    0xc(%ebp),%eax
  802684:	01 c2                	add    %eax,%edx
  802686:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268c:	01 c8                	add    %ecx,%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802692:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802695:	8b 45 0c             	mov    0xc(%ebp),%eax
  802698:	01 c2                	add    %eax,%edx
  80269a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80269d:	88 02                	mov    %al,(%edx)
		start++ ;
  80269f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8026a2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ab:	7c c4                	jl     802671 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8026ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8026b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b3:	01 d0                	add    %edx,%eax
  8026b5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8026b8:	90                   	nop
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8026c1:	ff 75 08             	pushl  0x8(%ebp)
  8026c4:	e8 73 fa ff ff       	call   80213c <strlen>
  8026c9:	83 c4 04             	add    $0x4,%esp
  8026cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8026cf:	ff 75 0c             	pushl  0xc(%ebp)
  8026d2:	e8 65 fa ff ff       	call   80213c <strlen>
  8026d7:	83 c4 04             	add    $0x4,%esp
  8026da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8026dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8026e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026eb:	eb 17                	jmp    802704 <strcconcat+0x49>
		final[s] = str1[s] ;
  8026ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f3:	01 c2                	add    %eax,%edx
  8026f5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	01 c8                	add    %ecx,%eax
  8026fd:	8a 00                	mov    (%eax),%al
  8026ff:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802701:	ff 45 fc             	incl   -0x4(%ebp)
  802704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802707:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80270a:	7c e1                	jl     8026ed <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80270c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802713:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80271a:	eb 1f                	jmp    80273b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80271c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80271f:	8d 50 01             	lea    0x1(%eax),%edx
  802722:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802725:	89 c2                	mov    %eax,%edx
  802727:	8b 45 10             	mov    0x10(%ebp),%eax
  80272a:	01 c2                	add    %eax,%edx
  80272c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80272f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802732:	01 c8                	add    %ecx,%eax
  802734:	8a 00                	mov    (%eax),%al
  802736:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802738:	ff 45 f8             	incl   -0x8(%ebp)
  80273b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80273e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802741:	7c d9                	jl     80271c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802743:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802746:	8b 45 10             	mov    0x10(%ebp),%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	c6 00 00             	movb   $0x0,(%eax)
}
  80274e:	90                   	nop
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802754:	8b 45 14             	mov    0x14(%ebp),%eax
  802757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80275d:	8b 45 14             	mov    0x14(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802769:	8b 45 10             	mov    0x10(%ebp),%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802774:	eb 0c                	jmp    802782 <strsplit+0x31>
			*string++ = 0;
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	8d 50 01             	lea    0x1(%eax),%edx
  80277c:	89 55 08             	mov    %edx,0x8(%ebp)
  80277f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	8a 00                	mov    (%eax),%al
  802787:	84 c0                	test   %al,%al
  802789:	74 18                	je     8027a3 <strsplit+0x52>
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	8a 00                	mov    (%eax),%al
  802790:	0f be c0             	movsbl %al,%eax
  802793:	50                   	push   %eax
  802794:	ff 75 0c             	pushl  0xc(%ebp)
  802797:	e8 32 fb ff ff       	call   8022ce <strchr>
  80279c:	83 c4 08             	add    $0x8,%esp
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	75 d3                	jne    802776 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	8a 00                	mov    (%eax),%al
  8027a8:	84 c0                	test   %al,%al
  8027aa:	74 5a                	je     802806 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8027ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	83 f8 0f             	cmp    $0xf,%eax
  8027b4:	75 07                	jne    8027bd <strsplit+0x6c>
		{
			return 0;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	eb 66                	jmp    802823 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8027bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	8d 48 01             	lea    0x1(%eax),%ecx
  8027c5:	8b 55 14             	mov    0x14(%ebp),%edx
  8027c8:	89 0a                	mov    %ecx,(%edx)
  8027ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8027d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8027d4:	01 c2                	add    %eax,%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027db:	eb 03                	jmp    8027e0 <strsplit+0x8f>
			string++;
  8027dd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	8a 00                	mov    (%eax),%al
  8027e5:	84 c0                	test   %al,%al
  8027e7:	74 8b                	je     802774 <strsplit+0x23>
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	8a 00                	mov    (%eax),%al
  8027ee:	0f be c0             	movsbl %al,%eax
  8027f1:	50                   	push   %eax
  8027f2:	ff 75 0c             	pushl  0xc(%ebp)
  8027f5:	e8 d4 fa ff ff       	call   8022ce <strchr>
  8027fa:	83 c4 08             	add    $0x8,%esp
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 dc                	je     8027dd <strsplit+0x8c>
			string++;
	}
  802801:	e9 6e ff ff ff       	jmp    802774 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802806:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802807:	8b 45 14             	mov    0x14(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802813:	8b 45 10             	mov    0x10(%ebp),%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	68 08 4a 80 00       	push   $0x804a08
  802833:	68 3f 01 00 00       	push   $0x13f
  802838:	68 2a 4a 80 00       	push   $0x804a2a
  80283d:	e8 a9 ef ff ff       	call   8017eb <_panic>

00802842 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802848:	83 ec 0c             	sub    $0xc,%esp
  80284b:	ff 75 08             	pushl  0x8(%ebp)
  80284e:	e8 ef 06 00 00       	call   802f42 <sys_sbrk>
  802853:	83 c4 10             	add    $0x10,%esp
}
  802856:	c9                   	leave  
  802857:	c3                   	ret    

00802858 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80285e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802862:	75 07                	jne    80286b <malloc+0x13>
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	eb 14                	jmp    80287f <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 38 4a 80 00       	push   $0x804a38
  802873:	6a 1b                	push   $0x1b
  802875:	68 5d 4a 80 00       	push   $0x804a5d
  80287a:	e8 6c ef ff ff       	call   8017eb <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
  802884:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 6c 4a 80 00       	push   $0x804a6c
  80288f:	6a 29                	push   $0x29
  802891:	68 5d 4a 80 00       	push   $0x804a5d
  802896:	e8 50 ef ff ff       	call   8017eb <_panic>

0080289b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 18             	sub    $0x18,%esp
  8028a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8028a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028ab:	75 07                	jne    8028b4 <smalloc+0x19>
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b2:	eb 14                	jmp    8028c8 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 90 4a 80 00       	push   $0x804a90
  8028bc:	6a 38                	push   $0x38
  8028be:	68 5d 4a 80 00       	push   $0x804a5d
  8028c3:	e8 23 ef ff ff       	call   8017eb <_panic>
	return NULL;
}
  8028c8:	c9                   	leave  
  8028c9:	c3                   	ret    

008028ca <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
  8028cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	68 b8 4a 80 00       	push   $0x804ab8
  8028d8:	6a 43                	push   $0x43
  8028da:	68 5d 4a 80 00       	push   $0x804a5d
  8028df:	e8 07 ef ff ff       	call   8017eb <_panic>

008028e4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	68 dc 4a 80 00       	push   $0x804adc
  8028f2:	6a 5b                	push   $0x5b
  8028f4:	68 5d 4a 80 00       	push   $0x804a5d
  8028f9:	e8 ed ee ff ff       	call   8017eb <_panic>

008028fe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 00 4b 80 00       	push   $0x804b00
  80290c:	6a 72                	push   $0x72
  80290e:	68 5d 4a 80 00       	push   $0x804a5d
  802913:	e8 d3 ee ff ff       	call   8017eb <_panic>

00802918 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	68 26 4b 80 00       	push   $0x804b26
  802926:	6a 7e                	push   $0x7e
  802928:	68 5d 4a 80 00       	push   $0x804a5d
  80292d:	e8 b9 ee ff ff       	call   8017eb <_panic>

00802932 <shrink>:

}
void shrink(uint32 newSize)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802938:	83 ec 04             	sub    $0x4,%esp
  80293b:	68 26 4b 80 00       	push   $0x804b26
  802940:	68 83 00 00 00       	push   $0x83
  802945:	68 5d 4a 80 00       	push   $0x804a5d
  80294a:	e8 9c ee ff ff       	call   8017eb <_panic>

0080294f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
  802952:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	68 26 4b 80 00       	push   $0x804b26
  80295d:	68 88 00 00 00       	push   $0x88
  802962:	68 5d 4a 80 00       	push   $0x804a5d
  802967:	e8 7f ee ff ff       	call   8017eb <_panic>

0080296c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	57                   	push   %edi
  802970:	56                   	push   %esi
  802971:	53                   	push   %ebx
  802972:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80297e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802981:	8b 7d 18             	mov    0x18(%ebp),%edi
  802984:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802987:	cd 30                	int    $0x30
  802989:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80298f:	83 c4 10             	add    $0x10,%esp
  802992:	5b                   	pop    %ebx
  802993:	5e                   	pop    %esi
  802994:	5f                   	pop    %edi
  802995:	5d                   	pop    %ebp
  802996:	c3                   	ret    

00802997 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	52                   	push   %edx
  8029af:	ff 75 0c             	pushl  0xc(%ebp)
  8029b2:	50                   	push   %eax
  8029b3:	6a 00                	push   $0x0
  8029b5:	e8 b2 ff ff ff       	call   80296c <syscall>
  8029ba:	83 c4 18             	add    $0x18,%esp
}
  8029bd:	90                   	nop
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 02                	push   $0x2
  8029cf:	e8 98 ff ff ff       	call   80296c <syscall>
  8029d4:	83 c4 18             	add    $0x18,%esp
}
  8029d7:	c9                   	leave  
  8029d8:	c3                   	ret    

008029d9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 03                	push   $0x3
  8029e8:	e8 7f ff ff ff       	call   80296c <syscall>
  8029ed:	83 c4 18             	add    $0x18,%esp
}
  8029f0:	90                   	nop
  8029f1:	c9                   	leave  
  8029f2:	c3                   	ret    

008029f3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 04                	push   $0x4
  802a02:	e8 65 ff ff ff       	call   80296c <syscall>
  802a07:	83 c4 18             	add    $0x18,%esp
}
  802a0a:	90                   	nop
  802a0b:	c9                   	leave  
  802a0c:	c3                   	ret    

00802a0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	52                   	push   %edx
  802a1d:	50                   	push   %eax
  802a1e:	6a 08                	push   $0x8
  802a20:	e8 47 ff ff ff       	call   80296c <syscall>
  802a25:	83 c4 18             	add    $0x18,%esp
}
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	56                   	push   %esi
  802a2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a2f:	8b 75 18             	mov    0x18(%ebp),%esi
  802a32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	56                   	push   %esi
  802a3f:	53                   	push   %ebx
  802a40:	51                   	push   %ecx
  802a41:	52                   	push   %edx
  802a42:	50                   	push   %eax
  802a43:	6a 09                	push   $0x9
  802a45:	e8 22 ff ff ff       	call   80296c <syscall>
  802a4a:	83 c4 18             	add    $0x18,%esp
}
  802a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a50:	5b                   	pop    %ebx
  802a51:	5e                   	pop    %esi
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    

00802a54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	52                   	push   %edx
  802a64:	50                   	push   %eax
  802a65:	6a 0a                	push   $0xa
  802a67:	e8 00 ff ff ff       	call   80296c <syscall>
  802a6c:	83 c4 18             	add    $0x18,%esp
}
  802a6f:	c9                   	leave  
  802a70:	c3                   	ret    

00802a71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	ff 75 0c             	pushl  0xc(%ebp)
  802a7d:	ff 75 08             	pushl  0x8(%ebp)
  802a80:	6a 0b                	push   $0xb
  802a82:	e8 e5 fe ff ff       	call   80296c <syscall>
  802a87:	83 c4 18             	add    $0x18,%esp
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 0c                	push   $0xc
  802a9b:	e8 cc fe ff ff       	call   80296c <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
}
  802aa3:	c9                   	leave  
  802aa4:	c3                   	ret    

00802aa5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 0d                	push   $0xd
  802ab4:	e8 b3 fe ff ff       	call   80296c <syscall>
  802ab9:	83 c4 18             	add    $0x18,%esp
}
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 00                	push   $0x0
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 0e                	push   $0xe
  802acd:	e8 9a fe ff ff       	call   80296c <syscall>
  802ad2:	83 c4 18             	add    $0x18,%esp
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 0f                	push   $0xf
  802ae6:	e8 81 fe ff ff       	call   80296c <syscall>
  802aeb:	83 c4 18             	add    $0x18,%esp
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	ff 75 08             	pushl  0x8(%ebp)
  802afe:	6a 10                	push   $0x10
  802b00:	e8 67 fe ff ff       	call   80296c <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 11                	push   $0x11
  802b19:	e8 4e fe ff ff       	call   80296c <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
}
  802b21:	90                   	nop
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <sys_cputc>:

void
sys_cputc(const char c)
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	50                   	push   %eax
  802b3d:	6a 01                	push   $0x1
  802b3f:	e8 28 fe ff ff       	call   80296c <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
}
  802b47:	90                   	nop
  802b48:	c9                   	leave  
  802b49:	c3                   	ret    

00802b4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 14                	push   $0x14
  802b59:	e8 0e fe ff ff       	call   80296c <syscall>
  802b5e:	83 c4 18             	add    $0x18,%esp
}
  802b61:	90                   	nop
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	83 ec 04             	sub    $0x4,%esp
  802b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802b70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	6a 00                	push   $0x0
  802b7c:	51                   	push   %ecx
  802b7d:	52                   	push   %edx
  802b7e:	ff 75 0c             	pushl  0xc(%ebp)
  802b81:	50                   	push   %eax
  802b82:	6a 15                	push   $0x15
  802b84:	e8 e3 fd ff ff       	call   80296c <syscall>
  802b89:	83 c4 18             	add    $0x18,%esp
}
  802b8c:	c9                   	leave  
  802b8d:	c3                   	ret    

00802b8e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	52                   	push   %edx
  802b9e:	50                   	push   %eax
  802b9f:	6a 16                	push   $0x16
  802ba1:	e8 c6 fd ff ff       	call   80296c <syscall>
  802ba6:	83 c4 18             	add    $0x18,%esp
}
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    

00802bab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802bab:	55                   	push   %ebp
  802bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	6a 00                	push   $0x0
  802bb9:	6a 00                	push   $0x0
  802bbb:	51                   	push   %ecx
  802bbc:	52                   	push   %edx
  802bbd:	50                   	push   %eax
  802bbe:	6a 17                	push   $0x17
  802bc0:	e8 a7 fd ff ff       	call   80296c <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
}
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	52                   	push   %edx
  802bda:	50                   	push   %eax
  802bdb:	6a 18                	push   $0x18
  802bdd:	e8 8a fd ff ff       	call   80296c <syscall>
  802be2:	83 c4 18             	add    $0x18,%esp
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	6a 00                	push   $0x0
  802bef:	ff 75 14             	pushl  0x14(%ebp)
  802bf2:	ff 75 10             	pushl  0x10(%ebp)
  802bf5:	ff 75 0c             	pushl  0xc(%ebp)
  802bf8:	50                   	push   %eax
  802bf9:	6a 19                	push   $0x19
  802bfb:	e8 6c fd ff ff       	call   80296c <syscall>
  802c00:	83 c4 18             	add    $0x18,%esp
}
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    

00802c05 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	50                   	push   %eax
  802c14:	6a 1a                	push   $0x1a
  802c16:	e8 51 fd ff ff       	call   80296c <syscall>
  802c1b:	83 c4 18             	add    $0x18,%esp
}
  802c1e:	90                   	nop
  802c1f:	c9                   	leave  
  802c20:	c3                   	ret    

00802c21 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c21:	55                   	push   %ebp
  802c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	50                   	push   %eax
  802c30:	6a 1b                	push   $0x1b
  802c32:	e8 35 fd ff ff       	call   80296c <syscall>
  802c37:	83 c4 18             	add    $0x18,%esp
}
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 05                	push   $0x5
  802c4b:	e8 1c fd ff ff       	call   80296c <syscall>
  802c50:	83 c4 18             	add    $0x18,%esp
}
  802c53:	c9                   	leave  
  802c54:	c3                   	ret    

00802c55 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802c55:	55                   	push   %ebp
  802c56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 06                	push   $0x6
  802c64:	e8 03 fd ff ff       	call   80296c <syscall>
  802c69:	83 c4 18             	add    $0x18,%esp
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 07                	push   $0x7
  802c7d:	e8 ea fc ff ff       	call   80296c <syscall>
  802c82:	83 c4 18             	add    $0x18,%esp
}
  802c85:	c9                   	leave  
  802c86:	c3                   	ret    

00802c87 <sys_exit_env>:


void sys_exit_env(void)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	6a 00                	push   $0x0
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 1c                	push   $0x1c
  802c96:	e8 d1 fc ff ff       	call   80296c <syscall>
  802c9b:	83 c4 18             	add    $0x18,%esp
}
  802c9e:	90                   	nop
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ca7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802caa:	8d 50 04             	lea    0x4(%eax),%edx
  802cad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802cb0:	6a 00                	push   $0x0
  802cb2:	6a 00                	push   $0x0
  802cb4:	6a 00                	push   $0x0
  802cb6:	52                   	push   %edx
  802cb7:	50                   	push   %eax
  802cb8:	6a 1d                	push   $0x1d
  802cba:	e8 ad fc ff ff       	call   80296c <syscall>
  802cbf:	83 c4 18             	add    $0x18,%esp
	return result;
  802cc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ccb:	89 01                	mov    %eax,(%ecx)
  802ccd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c9                   	leave  
  802cd4:	c2 04 00             	ret    $0x4

00802cd7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	ff 75 10             	pushl  0x10(%ebp)
  802ce1:	ff 75 0c             	pushl  0xc(%ebp)
  802ce4:	ff 75 08             	pushl  0x8(%ebp)
  802ce7:	6a 13                	push   $0x13
  802ce9:	e8 7e fc ff ff       	call   80296c <syscall>
  802cee:	83 c4 18             	add    $0x18,%esp
	return ;
  802cf1:	90                   	nop
}
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <sys_rcr2>:
uint32 sys_rcr2()
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 1e                	push   $0x1e
  802d03:	e8 64 fc ff ff       	call   80296c <syscall>
  802d08:	83 c4 18             	add    $0x18,%esp
}
  802d0b:	c9                   	leave  
  802d0c:	c3                   	ret    

00802d0d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802d0d:	55                   	push   %ebp
  802d0e:	89 e5                	mov    %esp,%ebp
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d19:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	50                   	push   %eax
  802d26:	6a 1f                	push   $0x1f
  802d28:	e8 3f fc ff ff       	call   80296c <syscall>
  802d2d:	83 c4 18             	add    $0x18,%esp
	return ;
  802d30:	90                   	nop
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <rsttst>:
void rsttst()
{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 21                	push   $0x21
  802d42:	e8 25 fc ff ff       	call   80296c <syscall>
  802d47:	83 c4 18             	add    $0x18,%esp
	return ;
  802d4a:	90                   	nop
}
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	8b 45 14             	mov    0x14(%ebp),%eax
  802d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802d59:	8b 55 18             	mov    0x18(%ebp),%edx
  802d5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d60:	52                   	push   %edx
  802d61:	50                   	push   %eax
  802d62:	ff 75 10             	pushl  0x10(%ebp)
  802d65:	ff 75 0c             	pushl  0xc(%ebp)
  802d68:	ff 75 08             	pushl  0x8(%ebp)
  802d6b:	6a 20                	push   $0x20
  802d6d:	e8 fa fb ff ff       	call   80296c <syscall>
  802d72:	83 c4 18             	add    $0x18,%esp
	return ;
  802d75:	90                   	nop
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <chktst>:
void chktst(uint32 n)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	ff 75 08             	pushl  0x8(%ebp)
  802d86:	6a 22                	push   $0x22
  802d88:	e8 df fb ff ff       	call   80296c <syscall>
  802d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  802d90:	90                   	nop
}
  802d91:	c9                   	leave  
  802d92:	c3                   	ret    

00802d93 <inctst>:

void inctst()
{
  802d93:	55                   	push   %ebp
  802d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 23                	push   $0x23
  802da2:	e8 c5 fb ff ff       	call   80296c <syscall>
  802da7:	83 c4 18             	add    $0x18,%esp
	return ;
  802daa:	90                   	nop
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <gettst>:
uint32 gettst()
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 24                	push   $0x24
  802dbc:	e8 ab fb ff ff       	call   80296c <syscall>
  802dc1:	83 c4 18             	add    $0x18,%esp
}
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 25                	push   $0x25
  802dd8:	e8 8f fb ff ff       	call   80296c <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
  802de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802de3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802de7:	75 07                	jne    802df0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802de9:	b8 01 00 00 00       	mov    $0x1,%eax
  802dee:	eb 05                	jmp    802df5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df5:	c9                   	leave  
  802df6:	c3                   	ret    

00802df7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802df7:	55                   	push   %ebp
  802df8:	89 e5                	mov    %esp,%ebp
  802dfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 25                	push   $0x25
  802e09:	e8 5e fb ff ff       	call   80296c <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
  802e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802e14:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802e18:	75 07                	jne    802e21 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802e1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e1f:	eb 05                	jmp    802e26 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e26:	c9                   	leave  
  802e27:	c3                   	ret    

00802e28 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802e28:	55                   	push   %ebp
  802e29:	89 e5                	mov    %esp,%ebp
  802e2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 25                	push   $0x25
  802e3a:	e8 2d fb ff ff       	call   80296c <syscall>
  802e3f:	83 c4 18             	add    $0x18,%esp
  802e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802e45:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802e49:	75 07                	jne    802e52 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802e4b:	b8 01 00 00 00       	mov    $0x1,%eax
  802e50:	eb 05                	jmp    802e57 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
  802e5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 00                	push   $0x0
  802e69:	6a 25                	push   $0x25
  802e6b:	e8 fc fa ff ff       	call   80296c <syscall>
  802e70:	83 c4 18             	add    $0x18,%esp
  802e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e76:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e7a:	75 07                	jne    802e83 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e7c:	b8 01 00 00 00       	mov    $0x1,%eax
  802e81:	eb 05                	jmp    802e88 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e88:	c9                   	leave  
  802e89:	c3                   	ret    

00802e8a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e8a:	55                   	push   %ebp
  802e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e8d:	6a 00                	push   $0x0
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	ff 75 08             	pushl  0x8(%ebp)
  802e98:	6a 26                	push   $0x26
  802e9a:	e8 cd fa ff ff       	call   80296c <syscall>
  802e9f:	83 c4 18             	add    $0x18,%esp
	return ;
  802ea2:	90                   	nop
}
  802ea3:	c9                   	leave  
  802ea4:	c3                   	ret    

00802ea5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
  802ea8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ea9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	6a 00                	push   $0x0
  802eb7:	53                   	push   %ebx
  802eb8:	51                   	push   %ecx
  802eb9:	52                   	push   %edx
  802eba:	50                   	push   %eax
  802ebb:	6a 27                	push   $0x27
  802ebd:	e8 aa fa ff ff       	call   80296c <syscall>
  802ec2:	83 c4 18             	add    $0x18,%esp
}
  802ec5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	52                   	push   %edx
  802eda:	50                   	push   %eax
  802edb:	6a 28                	push   $0x28
  802edd:	e8 8a fa ff ff       	call   80296c <syscall>
  802ee2:	83 c4 18             	add    $0x18,%esp
}
  802ee5:	c9                   	leave  
  802ee6:	c3                   	ret    

00802ee7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ee7:	55                   	push   %ebp
  802ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802eea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	6a 00                	push   $0x0
  802ef5:	51                   	push   %ecx
  802ef6:	ff 75 10             	pushl  0x10(%ebp)
  802ef9:	52                   	push   %edx
  802efa:	50                   	push   %eax
  802efb:	6a 29                	push   $0x29
  802efd:	e8 6a fa ff ff       	call   80296c <syscall>
  802f02:	83 c4 18             	add    $0x18,%esp
}
  802f05:	c9                   	leave  
  802f06:	c3                   	ret    

00802f07 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802f07:	55                   	push   %ebp
  802f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802f0a:	6a 00                	push   $0x0
  802f0c:	6a 00                	push   $0x0
  802f0e:	ff 75 10             	pushl  0x10(%ebp)
  802f11:	ff 75 0c             	pushl  0xc(%ebp)
  802f14:	ff 75 08             	pushl  0x8(%ebp)
  802f17:	6a 12                	push   $0x12
  802f19:	e8 4e fa ff ff       	call   80296c <syscall>
  802f1e:	83 c4 18             	add    $0x18,%esp
	return ;
  802f21:	90                   	nop
}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	52                   	push   %edx
  802f34:	50                   	push   %eax
  802f35:	6a 2a                	push   $0x2a
  802f37:	e8 30 fa ff ff       	call   80296c <syscall>
  802f3c:	83 c4 18             	add    $0x18,%esp
	return;
  802f3f:	90                   	nop
}
  802f40:	c9                   	leave  
  802f41:	c3                   	ret    

00802f42 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802f42:	55                   	push   %ebp
  802f43:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	50                   	push   %eax
  802f51:	6a 2b                	push   $0x2b
  802f53:	e8 14 fa ff ff       	call   80296c <syscall>
  802f58:	83 c4 18             	add    $0x18,%esp
}
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    

00802f5d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	ff 75 0c             	pushl  0xc(%ebp)
  802f69:	ff 75 08             	pushl  0x8(%ebp)
  802f6c:	6a 2c                	push   $0x2c
  802f6e:	e8 f9 f9 ff ff       	call   80296c <syscall>
  802f73:	83 c4 18             	add    $0x18,%esp
	return;
  802f76:	90                   	nop
}
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	ff 75 0c             	pushl  0xc(%ebp)
  802f85:	ff 75 08             	pushl  0x8(%ebp)
  802f88:	6a 2d                	push   $0x2d
  802f8a:	e8 dd f9 ff ff       	call   80296c <syscall>
  802f8f:	83 c4 18             	add    $0x18,%esp
	return;
  802f92:	90                   	nop
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
  802f98:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9e:	89 d0                	mov    %edx,%eax
  802fa0:	c1 e0 02             	shl    $0x2,%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fac:	01 d0                	add    %edx,%eax
  802fae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fb5:	01 d0                	add    %edx,%eax
  802fb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fbe:	01 d0                	add    %edx,%eax
  802fc0:	c1 e0 04             	shl    $0x4,%eax
  802fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802fcd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802fd0:	83 ec 0c             	sub    $0xc,%esp
  802fd3:	50                   	push   %eax
  802fd4:	e8 c8 fc ff ff       	call   802ca1 <sys_get_virtual_time>
  802fd9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802fdc:	eb 41                	jmp    80301f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802fde:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	50                   	push   %eax
  802fe5:	e8 b7 fc ff ff       	call   802ca1 <sys_get_virtual_time>
  802fea:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802fed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	29 c2                	sub    %eax,%edx
  802ff5:	89 d0                	mov    %edx,%eax
  802ff7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ffa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803000:	89 d1                	mov    %edx,%ecx
  803002:	29 c1                	sub    %eax,%ecx
  803004:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300a:	39 c2                	cmp    %eax,%edx
  80300c:	0f 97 c0             	seta   %al
  80300f:	0f b6 c0             	movzbl %al,%eax
  803012:	29 c1                	sub    %eax,%ecx
  803014:	89 c8                	mov    %ecx,%eax
  803016:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803019:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80301c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803025:	72 b7                	jb     802fde <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803027:	90                   	nop
  803028:	c9                   	leave  
  803029:	c3                   	ret    

0080302a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
  80302d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803037:	eb 03                	jmp    80303c <busy_wait+0x12>
  803039:	ff 45 fc             	incl   -0x4(%ebp)
  80303c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80303f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803042:	72 f5                	jb     803039 <busy_wait+0xf>
	return i;
  803044:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803047:	c9                   	leave  
  803048:	c3                   	ret    
  803049:	66 90                	xchg   %ax,%ax
  80304b:	90                   	nop

0080304c <__udivdi3>:
  80304c:	55                   	push   %ebp
  80304d:	57                   	push   %edi
  80304e:	56                   	push   %esi
  80304f:	53                   	push   %ebx
  803050:	83 ec 1c             	sub    $0x1c,%esp
  803053:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803057:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80305b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80305f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803063:	89 ca                	mov    %ecx,%edx
  803065:	89 f8                	mov    %edi,%eax
  803067:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80306b:	85 f6                	test   %esi,%esi
  80306d:	75 2d                	jne    80309c <__udivdi3+0x50>
  80306f:	39 cf                	cmp    %ecx,%edi
  803071:	77 65                	ja     8030d8 <__udivdi3+0x8c>
  803073:	89 fd                	mov    %edi,%ebp
  803075:	85 ff                	test   %edi,%edi
  803077:	75 0b                	jne    803084 <__udivdi3+0x38>
  803079:	b8 01 00 00 00       	mov    $0x1,%eax
  80307e:	31 d2                	xor    %edx,%edx
  803080:	f7 f7                	div    %edi
  803082:	89 c5                	mov    %eax,%ebp
  803084:	31 d2                	xor    %edx,%edx
  803086:	89 c8                	mov    %ecx,%eax
  803088:	f7 f5                	div    %ebp
  80308a:	89 c1                	mov    %eax,%ecx
  80308c:	89 d8                	mov    %ebx,%eax
  80308e:	f7 f5                	div    %ebp
  803090:	89 cf                	mov    %ecx,%edi
  803092:	89 fa                	mov    %edi,%edx
  803094:	83 c4 1c             	add    $0x1c,%esp
  803097:	5b                   	pop    %ebx
  803098:	5e                   	pop    %esi
  803099:	5f                   	pop    %edi
  80309a:	5d                   	pop    %ebp
  80309b:	c3                   	ret    
  80309c:	39 ce                	cmp    %ecx,%esi
  80309e:	77 28                	ja     8030c8 <__udivdi3+0x7c>
  8030a0:	0f bd fe             	bsr    %esi,%edi
  8030a3:	83 f7 1f             	xor    $0x1f,%edi
  8030a6:	75 40                	jne    8030e8 <__udivdi3+0x9c>
  8030a8:	39 ce                	cmp    %ecx,%esi
  8030aa:	72 0a                	jb     8030b6 <__udivdi3+0x6a>
  8030ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b0:	0f 87 9e 00 00 00    	ja     803154 <__udivdi3+0x108>
  8030b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bb:	89 fa                	mov    %edi,%edx
  8030bd:	83 c4 1c             	add    $0x1c,%esp
  8030c0:	5b                   	pop    %ebx
  8030c1:	5e                   	pop    %esi
  8030c2:	5f                   	pop    %edi
  8030c3:	5d                   	pop    %ebp
  8030c4:	c3                   	ret    
  8030c5:	8d 76 00             	lea    0x0(%esi),%esi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	31 c0                	xor    %eax,%eax
  8030cc:	89 fa                	mov    %edi,%edx
  8030ce:	83 c4 1c             	add    $0x1c,%esp
  8030d1:	5b                   	pop    %ebx
  8030d2:	5e                   	pop    %esi
  8030d3:	5f                   	pop    %edi
  8030d4:	5d                   	pop    %ebp
  8030d5:	c3                   	ret    
  8030d6:	66 90                	xchg   %ax,%ax
  8030d8:	89 d8                	mov    %ebx,%eax
  8030da:	f7 f7                	div    %edi
  8030dc:	31 ff                	xor    %edi,%edi
  8030de:	89 fa                	mov    %edi,%edx
  8030e0:	83 c4 1c             	add    $0x1c,%esp
  8030e3:	5b                   	pop    %ebx
  8030e4:	5e                   	pop    %esi
  8030e5:	5f                   	pop    %edi
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    
  8030e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030ed:	89 eb                	mov    %ebp,%ebx
  8030ef:	29 fb                	sub    %edi,%ebx
  8030f1:	89 f9                	mov    %edi,%ecx
  8030f3:	d3 e6                	shl    %cl,%esi
  8030f5:	89 c5                	mov    %eax,%ebp
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 ed                	shr    %cl,%ebp
  8030fb:	89 e9                	mov    %ebp,%ecx
  8030fd:	09 f1                	or     %esi,%ecx
  8030ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803103:	89 f9                	mov    %edi,%ecx
  803105:	d3 e0                	shl    %cl,%eax
  803107:	89 c5                	mov    %eax,%ebp
  803109:	89 d6                	mov    %edx,%esi
  80310b:	88 d9                	mov    %bl,%cl
  80310d:	d3 ee                	shr    %cl,%esi
  80310f:	89 f9                	mov    %edi,%ecx
  803111:	d3 e2                	shl    %cl,%edx
  803113:	8b 44 24 08          	mov    0x8(%esp),%eax
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 e8                	shr    %cl,%eax
  80311b:	09 c2                	or     %eax,%edx
  80311d:	89 d0                	mov    %edx,%eax
  80311f:	89 f2                	mov    %esi,%edx
  803121:	f7 74 24 0c          	divl   0xc(%esp)
  803125:	89 d6                	mov    %edx,%esi
  803127:	89 c3                	mov    %eax,%ebx
  803129:	f7 e5                	mul    %ebp
  80312b:	39 d6                	cmp    %edx,%esi
  80312d:	72 19                	jb     803148 <__udivdi3+0xfc>
  80312f:	74 0b                	je     80313c <__udivdi3+0xf0>
  803131:	89 d8                	mov    %ebx,%eax
  803133:	31 ff                	xor    %edi,%edi
  803135:	e9 58 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803140:	89 f9                	mov    %edi,%ecx
  803142:	d3 e2                	shl    %cl,%edx
  803144:	39 c2                	cmp    %eax,%edx
  803146:	73 e9                	jae    803131 <__udivdi3+0xe5>
  803148:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80314b:	31 ff                	xor    %edi,%edi
  80314d:	e9 40 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  803152:	66 90                	xchg   %ax,%ax
  803154:	31 c0                	xor    %eax,%eax
  803156:	e9 37 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80315b:	90                   	nop

0080315c <__umoddi3>:
  80315c:	55                   	push   %ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 1c             	sub    $0x1c,%esp
  803163:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803167:	8b 74 24 34          	mov    0x34(%esp),%esi
  80316b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803177:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80317b:	89 f3                	mov    %esi,%ebx
  80317d:	89 fa                	mov    %edi,%edx
  80317f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803183:	89 34 24             	mov    %esi,(%esp)
  803186:	85 c0                	test   %eax,%eax
  803188:	75 1a                	jne    8031a4 <__umoddi3+0x48>
  80318a:	39 f7                	cmp    %esi,%edi
  80318c:	0f 86 a2 00 00 00    	jbe    803234 <__umoddi3+0xd8>
  803192:	89 c8                	mov    %ecx,%eax
  803194:	89 f2                	mov    %esi,%edx
  803196:	f7 f7                	div    %edi
  803198:	89 d0                	mov    %edx,%eax
  80319a:	31 d2                	xor    %edx,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	39 f0                	cmp    %esi,%eax
  8031a6:	0f 87 ac 00 00 00    	ja     803258 <__umoddi3+0xfc>
  8031ac:	0f bd e8             	bsr    %eax,%ebp
  8031af:	83 f5 1f             	xor    $0x1f,%ebp
  8031b2:	0f 84 ac 00 00 00    	je     803264 <__umoddi3+0x108>
  8031b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031bd:	29 ef                	sub    %ebp,%edi
  8031bf:	89 fe                	mov    %edi,%esi
  8031c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c5:	89 e9                	mov    %ebp,%ecx
  8031c7:	d3 e0                	shl    %cl,%eax
  8031c9:	89 d7                	mov    %edx,%edi
  8031cb:	89 f1                	mov    %esi,%ecx
  8031cd:	d3 ef                	shr    %cl,%edi
  8031cf:	09 c7                	or     %eax,%edi
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e2                	shl    %cl,%edx
  8031d5:	89 14 24             	mov    %edx,(%esp)
  8031d8:	89 d8                	mov    %ebx,%eax
  8031da:	d3 e0                	shl    %cl,%eax
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e2:	d3 e0                	shl    %cl,%eax
  8031e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ec:	89 f1                	mov    %esi,%ecx
  8031ee:	d3 e8                	shr    %cl,%eax
  8031f0:	09 d0                	or     %edx,%eax
  8031f2:	d3 eb                	shr    %cl,%ebx
  8031f4:	89 da                	mov    %ebx,%edx
  8031f6:	f7 f7                	div    %edi
  8031f8:	89 d3                	mov    %edx,%ebx
  8031fa:	f7 24 24             	mull   (%esp)
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	89 d1                	mov    %edx,%ecx
  803201:	39 d3                	cmp    %edx,%ebx
  803203:	0f 82 87 00 00 00    	jb     803290 <__umoddi3+0x134>
  803209:	0f 84 91 00 00 00    	je     8032a0 <__umoddi3+0x144>
  80320f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803213:	29 f2                	sub    %esi,%edx
  803215:	19 cb                	sbb    %ecx,%ebx
  803217:	89 d8                	mov    %ebx,%eax
  803219:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80321d:	d3 e0                	shl    %cl,%eax
  80321f:	89 e9                	mov    %ebp,%ecx
  803221:	d3 ea                	shr    %cl,%edx
  803223:	09 d0                	or     %edx,%eax
  803225:	89 e9                	mov    %ebp,%ecx
  803227:	d3 eb                	shr    %cl,%ebx
  803229:	89 da                	mov    %ebx,%edx
  80322b:	83 c4 1c             	add    $0x1c,%esp
  80322e:	5b                   	pop    %ebx
  80322f:	5e                   	pop    %esi
  803230:	5f                   	pop    %edi
  803231:	5d                   	pop    %ebp
  803232:	c3                   	ret    
  803233:	90                   	nop
  803234:	89 fd                	mov    %edi,%ebp
  803236:	85 ff                	test   %edi,%edi
  803238:	75 0b                	jne    803245 <__umoddi3+0xe9>
  80323a:	b8 01 00 00 00       	mov    $0x1,%eax
  80323f:	31 d2                	xor    %edx,%edx
  803241:	f7 f7                	div    %edi
  803243:	89 c5                	mov    %eax,%ebp
  803245:	89 f0                	mov    %esi,%eax
  803247:	31 d2                	xor    %edx,%edx
  803249:	f7 f5                	div    %ebp
  80324b:	89 c8                	mov    %ecx,%eax
  80324d:	f7 f5                	div    %ebp
  80324f:	89 d0                	mov    %edx,%eax
  803251:	e9 44 ff ff ff       	jmp    80319a <__umoddi3+0x3e>
  803256:	66 90                	xchg   %ax,%ax
  803258:	89 c8                	mov    %ecx,%eax
  80325a:	89 f2                	mov    %esi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	3b 04 24             	cmp    (%esp),%eax
  803267:	72 06                	jb     80326f <__umoddi3+0x113>
  803269:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80326d:	77 0f                	ja     80327e <__umoddi3+0x122>
  80326f:	89 f2                	mov    %esi,%edx
  803271:	29 f9                	sub    %edi,%ecx
  803273:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803277:	89 14 24             	mov    %edx,(%esp)
  80327a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803282:	8b 14 24             	mov    (%esp),%edx
  803285:	83 c4 1c             	add    $0x1c,%esp
  803288:	5b                   	pop    %ebx
  803289:	5e                   	pop    %esi
  80328a:	5f                   	pop    %edi
  80328b:	5d                   	pop    %ebp
  80328c:	c3                   	ret    
  80328d:	8d 76 00             	lea    0x0(%esi),%esi
  803290:	2b 04 24             	sub    (%esp),%eax
  803293:	19 fa                	sbb    %edi,%edx
  803295:	89 d1                	mov    %edx,%ecx
  803297:	89 c6                	mov    %eax,%esi
  803299:	e9 71 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a4:	72 ea                	jb     803290 <__umoddi3+0x134>
  8032a6:	89 d9                	mov    %ebx,%ecx
  8032a8:	e9 62 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
