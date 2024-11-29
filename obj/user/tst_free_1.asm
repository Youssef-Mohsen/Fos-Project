
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
  800081:	68 60 52 80 00       	push   $0x805260
  800086:	6a 1e                	push   $0x1e
  800088:	68 7c 52 80 00       	push   $0x80527c
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
  8000d7:	e8 ae 2e 00 00       	call   802f8a <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 90 52 80 00       	push   $0x805290
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
  800103:	e8 82 2e 00 00       	call   802f8a <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 c5 2e 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  800142:	68 ec 52 80 00       	push   $0x8052ec
  800147:	e8 64 19 00 00       	call   801ab0 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 2c 2e 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800195:	68 20 53 80 00       	push   $0x805320
  80019a:	e8 11 19 00 00       	call   801ab0 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 2e 2e 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 90 53 80 00       	push   $0x805390
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 c2 2d 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8001ff:	e8 86 2d 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800237:	68 c4 53 80 00       	push   $0x8053c4
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
  80027e:	e8 62 31 00 00       	call   8033e5 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 44 54 80 00       	push   $0x805444
  80029e:	e8 0d 18 00 00       	call   801ab0 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 df 2c 00 00       	call   802f8a <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 22 2d 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  8002f2:	68 68 54 80 00       	push   $0x805468
  8002f7:	e8 b4 17 00 00       	call   801ab0 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 7c 2c 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800345:	68 9c 54 80 00       	push   $0x80549c
  80034a:	e8 61 17 00 00       	call   801ab0 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 7e 2c 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 0c 55 80 00       	push   $0x80550c
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 12 2c 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8003b8:	e8 cd 2b 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8003f0:	68 40 55 80 00       	push   $0x805540
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
  80043b:	e8 a5 2f 00 00       	call   8033e5 <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 c0 55 80 00       	push   $0x8055c0
  80045b:	e8 50 16 00 00       	call   801ab0 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 6d 2b 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  8004a9:	68 e4 55 80 00       	push   $0x8055e4
  8004ae:	e8 fd 15 00 00       	call   801ab0 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 c5 2a 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8004fc:	68 18 56 80 00       	push   $0x805618
  800501:	e8 aa 15 00 00       	call   801ab0 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 c7 2a 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 88 56 80 00       	push   $0x805688
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 5b 2a 00 00       	call   802f8a <sys_calculate_free_frames>
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
  80056d:	e8 18 2a 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8005a5:	68 bc 56 80 00       	push   $0x8056bc
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
  8005f3:	e8 ed 2d 00 00       	call   8033e5 <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 3c 57 80 00       	push   $0x80573c
  800613:	e8 98 14 00 00       	call   801ab0 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 b5 29 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  800669:	68 60 57 80 00       	push   $0x805760
  80066e:	e8 3d 14 00 00       	call   801ab0 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 5a 29 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 94 57 80 00       	push   $0x805794
  80068f:	e8 1c 14 00 00       	call   801ab0 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 ee 28 00 00       	call   802f8a <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 31 29 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  8006f1:	68 c8 57 80 00       	push   $0x8057c8
  8006f6:	e8 b5 13 00 00       	call   801ab0 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 7d 28 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800744:	68 fc 57 80 00       	push   $0x8057fc
  800749:	e8 62 13 00 00       	call   801ab0 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 7f 28 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 6c 58 80 00       	push   $0x80586c
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 13 28 00 00       	call   802f8a <sys_calculate_free_frames>
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
  8007fc:	e8 89 27 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800834:	68 a0 58 80 00       	push   $0x8058a0
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
  800888:	e8 58 2b 00 00       	call   8033e5 <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 20 59 80 00       	push   $0x805920
  8008a8:	e8 03 12 00 00       	call   801ab0 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 d5 26 00 00       	call   802f8a <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 18 27 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  800909:	68 44 59 80 00       	push   $0x805944
  80090e:	e8 9d 11 00 00       	call   801ab0 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 65 26 00 00       	call   802f8a <sys_calculate_free_frames>
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
  80095c:	68 78 59 80 00       	push   $0x805978
  800961:	e8 4a 11 00 00       	call   801ab0 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 67 26 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 e8 59 80 00       	push   $0x8059e8
  800982:	e8 29 11 00 00       	call   801ab0 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 fb 25 00 00       	call   802f8a <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 3e 26 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 1c 5a 80 00       	push   $0x805a1c
  8009f1:	e8 ba 10 00 00       	call   801ab0 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 82 25 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800a3f:	68 50 5a 80 00       	push   $0x805a50
  800a44:	e8 67 10 00 00       	call   801ab0 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 84 25 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 c0 5a 80 00       	push   $0x805ac0
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 18 25 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800ae5:	e8 a0 24 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800b1d:	68 f4 5a 80 00       	push   $0x805af4
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
  800ba9:	e8 37 28 00 00       	call   8033e5 <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 74 5b 80 00       	push   $0x805b74
  800bc9:	e8 e2 0e 00 00       	call   801ab0 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 b4 23 00 00       	call   802f8a <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 f7 23 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
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
  800c35:	68 98 5b 80 00       	push   $0x805b98
  800c3a:	e8 71 0e 00 00       	call   801ab0 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 39 23 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800c88:	68 cc 5b 80 00       	push   $0x805bcc
  800c8d:	e8 1e 0e 00 00       	call   801ab0 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 3b 23 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 3c 5c 80 00       	push   $0x805c3c
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 cf 22 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800d3f:	e8 46 22 00 00       	call   802f8a <sys_calculate_free_frames>
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
  800d77:	68 70 5c 80 00       	push   $0x805c70
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
  800e09:	e8 d7 25 00 00       	call   8033e5 <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 f0 5c 80 00       	push   $0x805cf0
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
  800e5e:	68 14 5d 80 00       	push   $0x805d14
  800e63:	e8 48 0c 00 00       	call   801ab0 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 1a 21 00 00       	call   802f8a <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 5d 21 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 43 21 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 54 5d 80 00       	push   $0x805d54
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 d7 20 00 00       	call   802f8a <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 94 5d 80 00       	push   $0x805d94
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
  800f1e:	e8 c2 24 00 00       	call   8033e5 <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 e4 5d 80 00       	push   $0x805de4
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
  800f5d:	e8 28 20 00 00       	call   802f8a <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 6b 20 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 51 20 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 0c 5e 80 00       	push   $0x805e0c
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 e5 1f 00 00       	call   802f8a <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 4c 5e 80 00       	push   $0x805e4c
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
  801014:	e8 cc 23 00 00       	call   8033e5 <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 9c 5e 80 00       	push   $0x805e9c
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
  801053:	e8 32 1f 00 00       	call   802f8a <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 75 1f 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 5b 1f 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 c4 5e 80 00       	push   $0x805ec4
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 ef 1e 00 00       	call   802f8a <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 04 5f 80 00       	push   $0x805f04
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
  80113f:	e8 a1 22 00 00       	call   8033e5 <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 54 5f 80 00       	push   $0x805f54
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
  80117e:	e8 07 1e 00 00       	call   802f8a <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 4a 1e 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 30 1e 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 7c 5f 80 00       	push   $0x805f7c
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 c4 1d 00 00       	call   802f8a <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 bc 5f 80 00       	push   $0x805fbc
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
  801238:	e8 a8 21 00 00       	call   8033e5 <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 0c 60 80 00       	push   $0x80600c
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
  801277:	e8 0e 1d 00 00       	call   802f8a <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 51 1d 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 37 1d 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 34 60 80 00       	push   $0x806034
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 cb 1c 00 00       	call   802f8a <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 74 60 80 00       	push   $0x806074
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
  8012f0:	e8 95 1c 00 00       	call   802f8a <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 d8 1c 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 be 1c 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 b8 60 80 00       	push   $0x8060b8
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 52 1c 00 00       	call   802f8a <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 f8 60 80 00       	push   $0x8060f8
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
  8013aa:	e8 36 20 00 00       	call   8033e5 <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 48 61 80 00       	push   $0x806148
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
  8013e9:	e8 9c 1b 00 00       	call   802f8a <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 df 1b 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 c5 1b 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 70 61 80 00       	push   $0x806170
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 59 1b 00 00       	call   802f8a <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 b0 61 80 00       	push   $0x8061b0
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
  801462:	e8 23 1b 00 00       	call   802f8a <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 66 1b 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 4c 1b 00 00       	call   802fd5 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 00 62 80 00       	push   $0x806200
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 e0 1a 00 00       	call   802f8a <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 40 62 80 00       	push   $0x806240
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
  801554:	e8 8c 1e 00 00       	call   8033e5 <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 90 62 80 00       	push   $0x806290
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
  80159d:	68 b8 62 80 00       	push   $0x8062b8
  8015a2:	e8 09 05 00 00       	call   801ab0 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 82 1c 00 00       	call   803231 <rsttst>
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
  8015d5:	68 26 63 80 00       	push   $0x806326
  8015da:	e8 06 1b 00 00       	call   8030e5 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 0d 1b 00 00       	call   803103 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 ac 1c 00 00       	call   8032ab <gettst>
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
  80162a:	68 31 63 80 00       	push   $0x806331
  80162f:	e8 b1 1a 00 00       	call   8030e5 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 b8 1a 00 00       	call   803103 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 57 1c 00 00       	call   8032ab <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 33 1c 00 00       	call   803291 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 c1 38 00 00       	call   804f2c <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 38 1c 00 00       	call   8032ab <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 3c 63 80 00       	push   $0x80633c
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
  80169f:	68 cc 63 80 00       	push   $0x8063cc
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
  8016ba:	e8 94 1a 00 00       	call   803153 <sys_getenvindex>
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
  801728:	e8 aa 17 00 00       	call   802ed7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	68 20 64 80 00       	push   $0x806420
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
  801758:	68 48 64 80 00       	push   $0x806448
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
  801789:	68 70 64 80 00       	push   $0x806470
  80178e:	e8 1d 03 00 00       	call   801ab0 <cprintf>
  801793:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801796:	a1 20 70 80 00       	mov    0x807020,%eax
  80179b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 c8 64 80 00       	push   $0x8064c8
  8017aa:	e8 01 03 00 00       	call   801ab0 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 20 64 80 00       	push   $0x806420
  8017ba:	e8 f1 02 00 00       	call   801ab0 <cprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017c2:	e8 2a 17 00 00       	call   802ef1 <sys_unlock_cons>
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
  8017da:	e8 40 19 00 00       	call   80311f <sys_destroy_env>
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
  8017eb:	e8 95 19 00 00       	call   803185 <sys_exit_env>
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
  801802:	a1 50 70 80 00       	mov    0x807050,%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	74 16                	je     801821 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80180b:	a1 50 70 80 00       	mov    0x807050,%eax
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	50                   	push   %eax
  801814:	68 dc 64 80 00       	push   $0x8064dc
  801819:	e8 92 02 00 00       	call   801ab0 <cprintf>
  80181e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801821:	a1 00 70 80 00       	mov    0x807000,%eax
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	68 e1 64 80 00       	push   $0x8064e1
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
  801851:	68 fd 64 80 00       	push   $0x8064fd
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
  801880:	68 00 65 80 00       	push   $0x806500
  801885:	6a 26                	push   $0x26
  801887:	68 4c 65 80 00       	push   $0x80654c
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
  801955:	68 58 65 80 00       	push   $0x806558
  80195a:	6a 3a                	push   $0x3a
  80195c:	68 4c 65 80 00       	push   $0x80654c
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
  8019c8:	68 ac 65 80 00       	push   $0x8065ac
  8019cd:	6a 44                	push   $0x44
  8019cf:	68 4c 65 80 00       	push   $0x80654c
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
  801a07:	a0 2c 70 80 00       	mov    0x80702c,%al
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
  801a22:	e8 6e 14 00 00       	call   802e95 <sys_cputs>
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
  801a7c:	a0 2c 70 80 00       	mov    0x80702c,%al
  801a81:	0f b6 c0             	movzbl %al,%eax
  801a84:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	50                   	push   %eax
  801a8e:	52                   	push   %edx
  801a8f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a95:	83 c0 08             	add    $0x8,%eax
  801a98:	50                   	push   %eax
  801a99:	e8 f7 13 00 00       	call   802e95 <sys_cputs>
  801a9e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801aa1:	c6 05 2c 70 80 00 00 	movb   $0x0,0x80702c
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
  801ab6:	c6 05 2c 70 80 00 01 	movb   $0x1,0x80702c
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
  801ae3:	e8 ef 13 00 00       	call   802ed7 <sys_lock_cons>
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
  801b03:	e8 e9 13 00 00       	call   802ef1 <sys_unlock_cons>
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
  801b4d:	e8 8e 34 00 00       	call   804fe0 <__udivdi3>
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
  801b9d:	e8 4e 35 00 00       	call   8050f0 <__umoddi3>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	05 14 68 80 00       	add    $0x806814,%eax
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
  801cf8:	8b 04 85 38 68 80 00 	mov    0x806838(,%eax,4),%eax
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
  801dd9:	8b 34 9d 80 66 80 00 	mov    0x806680(,%ebx,4),%esi
  801de0:	85 f6                	test   %esi,%esi
  801de2:	75 19                	jne    801dfd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de4:	53                   	push   %ebx
  801de5:	68 25 68 80 00       	push   $0x806825
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
  801dfe:	68 2e 68 80 00       	push   $0x80682e
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
  801e2b:	be 31 68 80 00       	mov    $0x806831,%esi
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
  802023:	c6 05 2c 70 80 00 00 	movb   $0x0,0x80702c
			break;
  80202a:	eb 2c                	jmp    802058 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80202c:	c6 05 2c 70 80 00 01 	movb   $0x1,0x80702c
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
  802836:	68 a8 69 80 00       	push   $0x8069a8
  80283b:	68 3f 01 00 00       	push   $0x13f
  802840:	68 ca 69 80 00       	push   $0x8069ca
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
  802856:	e8 e5 0b 00 00       	call   803440 <sys_sbrk>
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
  8028d1:	e8 ee 09 00 00       	call   8032c4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 2e 0f 00 00       	call   803813 <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 00 0a 00 00       	call   8032f5 <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 c7 13 00 00       	call   803ccf <alloc_block_BF>
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
  802953:	8b 04 85 60 b0 08 01 	mov    0x108b060(,%eax,4),%eax
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
  8029a0:	8b 04 85 60 b0 08 01 	mov    0x108b060(,%eax,4),%eax
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
  8029f7:	c7 04 85 60 b0 08 01 	movl   $0x1,0x108b060(,%eax,4)
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
  802a59:	89 04 95 60 b0 10 01 	mov    %eax,0x110b060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802a60:	83 ec 08             	sub    $0x8,%esp
  802a63:	ff 75 08             	pushl  0x8(%ebp)
  802a66:	ff 75 f0             	pushl  -0x10(%ebp)
  802a69:	e8 09 0a 00 00       	call   803477 <sys_allocate_user_mem>
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
  802ab1:	e8 dd 09 00 00       	call   803493 <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 10 1c 00 00       	call   8046d7 <free_block>
  802ac7:	83 c4 10             	add    $0x10,%esp
		}

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
  802afc:	8b 04 85 60 b0 10 01 	mov    0x110b060(,%eax,4),%eax
  802b03:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  802b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b09:	c1 e0 0c             	shl    $0xc,%eax
  802b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  802b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b16:	eb 42                	jmp    802b5a <free+0xdb>
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
  802b39:	c7 04 85 60 b0 08 01 	movl   $0x0,0x108b060(,%eax,4)
  802b40:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  802b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	83 ec 08             	sub    $0x8,%esp
  802b4d:	52                   	push   %edx
  802b4e:	50                   	push   %eax
  802b4f:	e8 07 09 00 00       	call   80345b <sys_free_user_mem>
  802b54:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  802b57:	ff 45 f4             	incl   -0xc(%ebp)
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b60:	72 b6                	jb     802b18 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802b62:	eb 17                	jmp    802b7b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 d8 69 80 00       	push   $0x8069d8
  802b6c:	68 88 00 00 00       	push   $0x88
  802b71:	68 02 6a 80 00       	push   $0x806a02
  802b76:	e8 78 ec ff ff       	call   8017f3 <_panic>
	}
}
  802b7b:	90                   	nop
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
  802b81:	83 ec 28             	sub    $0x28,%esp
  802b84:	8b 45 10             	mov    0x10(%ebp),%eax
  802b87:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802b8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b8e:	75 0a                	jne    802b9a <smalloc+0x1c>
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
  802b95:	e9 ec 00 00 00       	jmp    802c86 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	39 d0                	cmp    %edx,%eax
  802baf:	73 02                	jae    802bb3 <smalloc+0x35>
  802bb1:	89 d0                	mov    %edx,%eax
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	50                   	push   %eax
  802bb7:	e8 a4 fc ff ff       	call   802860 <malloc>
  802bbc:	83 c4 10             	add    $0x10,%esp
  802bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc6:	75 0a                	jne    802bd2 <smalloc+0x54>
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	e9 b4 00 00 00       	jmp    802c86 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802bd2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802bd6:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd9:	50                   	push   %eax
  802bda:	ff 75 0c             	pushl  0xc(%ebp)
  802bdd:	ff 75 08             	pushl  0x8(%ebp)
  802be0:	e8 7d 04 00 00       	call   803062 <sys_createSharedObject>
  802be5:	83 c4 10             	add    $0x10,%esp
  802be8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802beb:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802bef:	74 06                	je     802bf7 <smalloc+0x79>
  802bf1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802bf5:	75 0a                	jne    802c01 <smalloc+0x83>
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfc:	e9 85 00 00 00       	jmp    802c86 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  802c01:	83 ec 08             	sub    $0x8,%esp
  802c04:	ff 75 ec             	pushl  -0x14(%ebp)
  802c07:	68 0e 6a 80 00       	push   $0x806a0e
  802c0c:	e8 9f ee ff ff       	call   801ab0 <cprintf>
  802c11:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  802c14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c17:	a1 20 70 80 00       	mov    0x807020,%eax
  802c1c:	8b 40 78             	mov    0x78(%eax),%eax
  802c1f:	29 c2                	sub    %eax,%edx
  802c21:	89 d0                	mov    %edx,%eax
  802c23:	2d 00 10 00 00       	sub    $0x1000,%eax
  802c28:	c1 e8 0c             	shr    $0xc,%eax
  802c2b:	8b 15 24 70 80 00    	mov    0x807024,%edx
  802c31:	42                   	inc    %edx
  802c32:	89 15 24 70 80 00    	mov    %edx,0x807024
  802c38:	8b 15 24 70 80 00    	mov    0x807024,%edx
  802c3e:	89 14 85 60 b0 00 01 	mov    %edx,0x100b060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  802c45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c48:	a1 20 70 80 00       	mov    0x807020,%eax
  802c4d:	8b 40 78             	mov    0x78(%eax),%eax
  802c50:	29 c2                	sub    %eax,%edx
  802c52:	89 d0                	mov    %edx,%eax
  802c54:	2d 00 10 00 00       	sub    $0x1000,%eax
  802c59:	c1 e8 0c             	shr    $0xc,%eax
  802c5c:	8b 0c 85 60 b0 00 01 	mov    0x100b060(,%eax,4),%ecx
  802c63:	a1 20 70 80 00       	mov    0x807020,%eax
  802c68:	8b 50 10             	mov    0x10(%eax),%edx
  802c6b:	89 c8                	mov    %ecx,%eax
  802c6d:	c1 e0 02             	shl    $0x2,%eax
  802c70:	89 c1                	mov    %eax,%ecx
  802c72:	c1 e1 09             	shl    $0x9,%ecx
  802c75:	01 c8                	add    %ecx,%eax
  802c77:	01 c2                	add    %eax,%edx
  802c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7c:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	 return ptr;
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802c86:	c9                   	leave  
  802c87:	c3                   	ret    

00802c88 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
  802c8b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802c8e:	83 ec 08             	sub    $0x8,%esp
  802c91:	ff 75 0c             	pushl  0xc(%ebp)
  802c94:	ff 75 08             	pushl  0x8(%ebp)
  802c97:	e8 f0 03 00 00       	call   80308c <sys_getSizeOfSharedObject>
  802c9c:	83 c4 10             	add    $0x10,%esp
  802c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802ca2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802ca6:	75 0a                	jne    802cb2 <sget+0x2a>
  802ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cad:	e9 e7 00 00 00       	jmp    802d99 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802cb8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	39 d0                	cmp    %edx,%eax
  802cc7:	73 02                	jae    802ccb <sget+0x43>
  802cc9:	89 d0                	mov    %edx,%eax
  802ccb:	83 ec 0c             	sub    $0xc,%esp
  802cce:	50                   	push   %eax
  802ccf:	e8 8c fb ff ff       	call   802860 <malloc>
  802cd4:	83 c4 10             	add    $0x10,%esp
  802cd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802cda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cde:	75 0a                	jne    802cea <sget+0x62>
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce5:	e9 af 00 00 00       	jmp    802d99 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf0:	ff 75 0c             	pushl  0xc(%ebp)
  802cf3:	ff 75 08             	pushl  0x8(%ebp)
  802cf6:	e8 ae 03 00 00       	call   8030a9 <sys_getSharedObject>
  802cfb:	83 c4 10             	add    $0x10,%esp
  802cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  802d01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d04:	a1 20 70 80 00       	mov    0x807020,%eax
  802d09:	8b 40 78             	mov    0x78(%eax),%eax
  802d0c:	29 c2                	sub    %eax,%edx
  802d0e:	89 d0                	mov    %edx,%eax
  802d10:	2d 00 10 00 00       	sub    $0x1000,%eax
  802d15:	c1 e8 0c             	shr    $0xc,%eax
  802d18:	8b 15 24 70 80 00    	mov    0x807024,%edx
  802d1e:	42                   	inc    %edx
  802d1f:	89 15 24 70 80 00    	mov    %edx,0x807024
  802d25:	8b 15 24 70 80 00    	mov    0x807024,%edx
  802d2b:	89 14 85 60 b0 00 01 	mov    %edx,0x100b060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  802d32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d35:	a1 20 70 80 00       	mov    0x807020,%eax
  802d3a:	8b 40 78             	mov    0x78(%eax),%eax
  802d3d:	29 c2                	sub    %eax,%edx
  802d3f:	89 d0                	mov    %edx,%eax
  802d41:	2d 00 10 00 00       	sub    $0x1000,%eax
  802d46:	c1 e8 0c             	shr    $0xc,%eax
  802d49:	8b 0c 85 60 b0 00 01 	mov    0x100b060(,%eax,4),%ecx
  802d50:	a1 20 70 80 00       	mov    0x807020,%eax
  802d55:	8b 50 10             	mov    0x10(%eax),%edx
  802d58:	89 c8                	mov    %ecx,%eax
  802d5a:	c1 e0 02             	shl    $0x2,%eax
  802d5d:	89 c1                	mov    %eax,%ecx
  802d5f:	c1 e1 09             	shl    $0x9,%ecx
  802d62:	01 c8                	add    %ecx,%eax
  802d64:	01 c2                	add    %eax,%edx
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	89 04 95 60 70 80 00 	mov    %eax,0x807060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  802d70:	a1 20 70 80 00       	mov    0x807020,%eax
  802d75:	8b 40 10             	mov    0x10(%eax),%eax
  802d78:	83 ec 08             	sub    $0x8,%esp
  802d7b:	50                   	push   %eax
  802d7c:	68 1d 6a 80 00       	push   $0x806a1d
  802d81:	e8 2a ed ff ff       	call   801ab0 <cprintf>
  802d86:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802d89:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802d8d:	75 07                	jne    802d96 <sget+0x10e>
  802d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d94:	eb 03                	jmp    802d99 <sget+0x111>
	return ptr;
  802d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  802da1:	8b 55 08             	mov    0x8(%ebp),%edx
  802da4:	a1 20 70 80 00       	mov    0x807020,%eax
  802da9:	8b 40 78             	mov    0x78(%eax),%eax
  802dac:	29 c2                	sub    %eax,%edx
  802dae:	89 d0                	mov    %edx,%eax
  802db0:	2d 00 10 00 00       	sub    $0x1000,%eax
  802db5:	c1 e8 0c             	shr    $0xc,%eax
  802db8:	8b 0c 85 60 b0 00 01 	mov    0x100b060(,%eax,4),%ecx
  802dbf:	a1 20 70 80 00       	mov    0x807020,%eax
  802dc4:	8b 50 10             	mov    0x10(%eax),%edx
  802dc7:	89 c8                	mov    %ecx,%eax
  802dc9:	c1 e0 02             	shl    $0x2,%eax
  802dcc:	89 c1                	mov    %eax,%ecx
  802dce:	c1 e1 09             	shl    $0x9,%ecx
  802dd1:	01 c8                	add    %ecx,%eax
  802dd3:	01 d0                	add    %edx,%eax
  802dd5:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
  802ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802ddf:	83 ec 08             	sub    $0x8,%esp
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	ff 75 f4             	pushl  -0xc(%ebp)
  802de8:	e8 db 02 00 00       	call   8030c8 <sys_freeSharedObject>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802df3:	90                   	nop
  802df4:	c9                   	leave  
  802df5:	c3                   	ret    

00802df6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802df6:	55                   	push   %ebp
  802df7:	89 e5                	mov    %esp,%ebp
  802df9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 2c 6a 80 00       	push   $0x806a2c
  802e04:	68 e5 00 00 00       	push   $0xe5
  802e09:	68 02 6a 80 00       	push   $0x806a02
  802e0e:	e8 e0 e9 ff ff       	call   8017f3 <_panic>

00802e13 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 52 6a 80 00       	push   $0x806a52
  802e21:	68 f1 00 00 00       	push   $0xf1
  802e26:	68 02 6a 80 00       	push   $0x806a02
  802e2b:	e8 c3 e9 ff ff       	call   8017f3 <_panic>

00802e30 <shrink>:

}
void shrink(uint32 newSize)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 52 6a 80 00       	push   $0x806a52
  802e3e:	68 f6 00 00 00       	push   $0xf6
  802e43:	68 02 6a 80 00       	push   $0x806a02
  802e48:	e8 a6 e9 ff ff       	call   8017f3 <_panic>

00802e4d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
  802e50:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 52 6a 80 00       	push   $0x806a52
  802e5b:	68 fb 00 00 00       	push   $0xfb
  802e60:	68 02 6a 80 00       	push   $0x806a02
  802e65:	e8 89 e9 ff ff       	call   8017f3 <_panic>

00802e6a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
  802e6d:	57                   	push   %edi
  802e6e:	56                   	push   %esi
  802e6f:	53                   	push   %ebx
  802e70:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e7f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e82:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e85:	cd 30                	int    $0x30
  802e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e8d:	83 c4 10             	add    $0x10,%esp
  802e90:	5b                   	pop    %ebx
  802e91:	5e                   	pop    %esi
  802e92:	5f                   	pop    %edi
  802e93:	5d                   	pop    %ebp
  802e94:	c3                   	ret    

00802e95 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802e95:	55                   	push   %ebp
  802e96:	89 e5                	mov    %esp,%ebp
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ea1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	6a 00                	push   $0x0
  802eaa:	6a 00                	push   $0x0
  802eac:	52                   	push   %edx
  802ead:	ff 75 0c             	pushl  0xc(%ebp)
  802eb0:	50                   	push   %eax
  802eb1:	6a 00                	push   $0x0
  802eb3:	e8 b2 ff ff ff       	call   802e6a <syscall>
  802eb8:	83 c4 18             	add    $0x18,%esp
}
  802ebb:	90                   	nop
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <sys_cgetc>:

int
sys_cgetc(void)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 02                	push   $0x2
  802ecd:	e8 98 ff ff ff       	call   802e6a <syscall>
  802ed2:	83 c4 18             	add    $0x18,%esp
}
  802ed5:	c9                   	leave  
  802ed6:	c3                   	ret    

00802ed7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802ed7:	55                   	push   %ebp
  802ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 03                	push   $0x3
  802ee6:	e8 7f ff ff ff       	call   802e6a <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
}
  802eee:	90                   	nop
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 04                	push   $0x4
  802f00:	e8 65 ff ff ff       	call   802e6a <syscall>
  802f05:	83 c4 18             	add    $0x18,%esp
}
  802f08:	90                   	nop
  802f09:	c9                   	leave  
  802f0a:	c3                   	ret    

00802f0b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	52                   	push   %edx
  802f1b:	50                   	push   %eax
  802f1c:	6a 08                	push   $0x8
  802f1e:	e8 47 ff ff ff       	call   802e6a <syscall>
  802f23:	83 c4 18             	add    $0x18,%esp
}
  802f26:	c9                   	leave  
  802f27:	c3                   	ret    

00802f28 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
  802f2b:	56                   	push   %esi
  802f2c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f2d:	8b 75 18             	mov    0x18(%ebp),%esi
  802f30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	56                   	push   %esi
  802f3d:	53                   	push   %ebx
  802f3e:	51                   	push   %ecx
  802f3f:	52                   	push   %edx
  802f40:	50                   	push   %eax
  802f41:	6a 09                	push   $0x9
  802f43:	e8 22 ff ff ff       	call   802e6a <syscall>
  802f48:	83 c4 18             	add    $0x18,%esp
}
  802f4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f4e:	5b                   	pop    %ebx
  802f4f:	5e                   	pop    %esi
  802f50:	5d                   	pop    %ebp
  802f51:	c3                   	ret    

00802f52 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f52:	55                   	push   %ebp
  802f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	52                   	push   %edx
  802f62:	50                   	push   %eax
  802f63:	6a 0a                	push   $0xa
  802f65:	e8 00 ff ff ff       	call   802e6a <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
}
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	ff 75 0c             	pushl  0xc(%ebp)
  802f7b:	ff 75 08             	pushl  0x8(%ebp)
  802f7e:	6a 0b                	push   $0xb
  802f80:	e8 e5 fe ff ff       	call   802e6a <syscall>
  802f85:	83 c4 18             	add    $0x18,%esp
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 0c                	push   $0xc
  802f99:	e8 cc fe ff ff       	call   802e6a <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 0d                	push   $0xd
  802fb2:	e8 b3 fe ff ff       	call   802e6a <syscall>
  802fb7:	83 c4 18             	add    $0x18,%esp
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 0e                	push   $0xe
  802fcb:	e8 9a fe ff ff       	call   802e6a <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 0f                	push   $0xf
  802fe4:	e8 81 fe ff ff       	call   802e6a <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	ff 75 08             	pushl  0x8(%ebp)
  802ffc:	6a 10                	push   $0x10
  802ffe:	e8 67 fe ff ff       	call   802e6a <syscall>
  803003:	83 c4 18             	add    $0x18,%esp
}
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 11                	push   $0x11
  803017:	e8 4e fe ff ff       	call   802e6a <syscall>
  80301c:	83 c4 18             	add    $0x18,%esp
}
  80301f:	90                   	nop
  803020:	c9                   	leave  
  803021:	c3                   	ret    

00803022 <sys_cputc>:

void
sys_cputc(const char c)
{
  803022:	55                   	push   %ebp
  803023:	89 e5                	mov    %esp,%ebp
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80302e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	50                   	push   %eax
  80303b:	6a 01                	push   $0x1
  80303d:	e8 28 fe ff ff       	call   802e6a <syscall>
  803042:	83 c4 18             	add    $0x18,%esp
}
  803045:	90                   	nop
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	6a 00                	push   $0x0
  803051:	6a 00                	push   $0x0
  803053:	6a 00                	push   $0x0
  803055:	6a 14                	push   $0x14
  803057:	e8 0e fe ff ff       	call   802e6a <syscall>
  80305c:	83 c4 18             	add    $0x18,%esp
}
  80305f:	90                   	nop
  803060:	c9                   	leave  
  803061:	c3                   	ret    

00803062 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803062:	55                   	push   %ebp
  803063:	89 e5                	mov    %esp,%ebp
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	8b 45 10             	mov    0x10(%ebp),%eax
  80306b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80306e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803071:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	6a 00                	push   $0x0
  80307a:	51                   	push   %ecx
  80307b:	52                   	push   %edx
  80307c:	ff 75 0c             	pushl  0xc(%ebp)
  80307f:	50                   	push   %eax
  803080:	6a 15                	push   $0x15
  803082:	e8 e3 fd ff ff       	call   802e6a <syscall>
  803087:	83 c4 18             	add    $0x18,%esp
}
  80308a:	c9                   	leave  
  80308b:	c3                   	ret    

0080308c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80308c:	55                   	push   %ebp
  80308d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80308f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	52                   	push   %edx
  80309c:	50                   	push   %eax
  80309d:	6a 16                	push   $0x16
  80309f:	e8 c6 fd ff ff       	call   802e6a <syscall>
  8030a4:	83 c4 18             	add    $0x18,%esp
}
  8030a7:	c9                   	leave  
  8030a8:	c3                   	ret    

008030a9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	51                   	push   %ecx
  8030ba:	52                   	push   %edx
  8030bb:	50                   	push   %eax
  8030bc:	6a 17                	push   $0x17
  8030be:	e8 a7 fd ff ff       	call   802e6a <syscall>
  8030c3:	83 c4 18             	add    $0x18,%esp
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	6a 00                	push   $0x0
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 00                	push   $0x0
  8030d7:	52                   	push   %edx
  8030d8:	50                   	push   %eax
  8030d9:	6a 18                	push   $0x18
  8030db:	e8 8a fd ff ff       	call   802e6a <syscall>
  8030e0:	83 c4 18             	add    $0x18,%esp
}
  8030e3:	c9                   	leave  
  8030e4:	c3                   	ret    

008030e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030e5:	55                   	push   %ebp
  8030e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	6a 00                	push   $0x0
  8030ed:	ff 75 14             	pushl  0x14(%ebp)
  8030f0:	ff 75 10             	pushl  0x10(%ebp)
  8030f3:	ff 75 0c             	pushl  0xc(%ebp)
  8030f6:	50                   	push   %eax
  8030f7:	6a 19                	push   $0x19
  8030f9:	e8 6c fd ff ff       	call   802e6a <syscall>
  8030fe:	83 c4 18             	add    $0x18,%esp
}
  803101:	c9                   	leave  
  803102:	c3                   	ret    

00803103 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	50                   	push   %eax
  803112:	6a 1a                	push   $0x1a
  803114:	e8 51 fd ff ff       	call   802e6a <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
}
  80311c:	90                   	nop
  80311d:	c9                   	leave  
  80311e:	c3                   	ret    

0080311f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80311f:	55                   	push   %ebp
  803120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	50                   	push   %eax
  80312e:	6a 1b                	push   $0x1b
  803130:	e8 35 fd ff ff       	call   802e6a <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    

0080313a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 05                	push   $0x5
  803149:	e8 1c fd ff ff       	call   802e6a <syscall>
  80314e:	83 c4 18             	add    $0x18,%esp
}
  803151:	c9                   	leave  
  803152:	c3                   	ret    

00803153 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803153:	55                   	push   %ebp
  803154:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 06                	push   $0x6
  803162:	e8 03 fd ff ff       	call   802e6a <syscall>
  803167:	83 c4 18             	add    $0x18,%esp
}
  80316a:	c9                   	leave  
  80316b:	c3                   	ret    

0080316c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 00                	push   $0x0
  803179:	6a 07                	push   $0x7
  80317b:	e8 ea fc ff ff       	call   802e6a <syscall>
  803180:	83 c4 18             	add    $0x18,%esp
}
  803183:	c9                   	leave  
  803184:	c3                   	ret    

00803185 <sys_exit_env>:


void sys_exit_env(void)
{
  803185:	55                   	push   %ebp
  803186:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 1c                	push   $0x1c
  803194:	e8 d1 fc ff ff       	call   802e6a <syscall>
  803199:	83 c4 18             	add    $0x18,%esp
}
  80319c:	90                   	nop
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
  8031a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031a8:	8d 50 04             	lea    0x4(%eax),%edx
  8031ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	52                   	push   %edx
  8031b5:	50                   	push   %eax
  8031b6:	6a 1d                	push   $0x1d
  8031b8:	e8 ad fc ff ff       	call   802e6a <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8031c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031c9:	89 01                	mov    %eax,(%ecx)
  8031cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	c9                   	leave  
  8031d2:	c2 04 00             	ret    $0x4

008031d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031d5:	55                   	push   %ebp
  8031d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	ff 75 10             	pushl  0x10(%ebp)
  8031df:	ff 75 0c             	pushl  0xc(%ebp)
  8031e2:	ff 75 08             	pushl  0x8(%ebp)
  8031e5:	6a 13                	push   $0x13
  8031e7:	e8 7e fc ff ff       	call   802e6a <syscall>
  8031ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ef:	90                   	nop
}
  8031f0:	c9                   	leave  
  8031f1:	c3                   	ret    

008031f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8031f2:	55                   	push   %ebp
  8031f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031f5:	6a 00                	push   $0x0
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 00                	push   $0x0
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 1e                	push   $0x1e
  803201:	e8 64 fc ff ff       	call   802e6a <syscall>
  803206:	83 c4 18             	add    $0x18,%esp
}
  803209:	c9                   	leave  
  80320a:	c3                   	ret    

0080320b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80320b:	55                   	push   %ebp
  80320c:	89 e5                	mov    %esp,%ebp
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803217:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	50                   	push   %eax
  803224:	6a 1f                	push   $0x1f
  803226:	e8 3f fc ff ff       	call   802e6a <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
	return ;
  80322e:	90                   	nop
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <rsttst>:
void rsttst()
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 21                	push   $0x21
  803240:	e8 25 fc ff ff       	call   802e6a <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
	return ;
  803248:	90                   	nop
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	8b 45 14             	mov    0x14(%ebp),%eax
  803254:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803257:	8b 55 18             	mov    0x18(%ebp),%edx
  80325a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80325e:	52                   	push   %edx
  80325f:	50                   	push   %eax
  803260:	ff 75 10             	pushl  0x10(%ebp)
  803263:	ff 75 0c             	pushl  0xc(%ebp)
  803266:	ff 75 08             	pushl  0x8(%ebp)
  803269:	6a 20                	push   $0x20
  80326b:	e8 fa fb ff ff       	call   802e6a <syscall>
  803270:	83 c4 18             	add    $0x18,%esp
	return ;
  803273:	90                   	nop
}
  803274:	c9                   	leave  
  803275:	c3                   	ret    

00803276 <chktst>:
void chktst(uint32 n)
{
  803276:	55                   	push   %ebp
  803277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	6a 00                	push   $0x0
  803281:	ff 75 08             	pushl  0x8(%ebp)
  803284:	6a 22                	push   $0x22
  803286:	e8 df fb ff ff       	call   802e6a <syscall>
  80328b:	83 c4 18             	add    $0x18,%esp
	return ;
  80328e:	90                   	nop
}
  80328f:	c9                   	leave  
  803290:	c3                   	ret    

00803291 <inctst>:

void inctst()
{
  803291:	55                   	push   %ebp
  803292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	6a 23                	push   $0x23
  8032a0:	e8 c5 fb ff ff       	call   802e6a <syscall>
  8032a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a8:	90                   	nop
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <gettst>:
uint32 gettst()
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	6a 24                	push   $0x24
  8032ba:	e8 ab fb ff ff       	call   802e6a <syscall>
  8032bf:	83 c4 18             	add    $0x18,%esp
}
  8032c2:	c9                   	leave  
  8032c3:	c3                   	ret    

008032c4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8032c4:	55                   	push   %ebp
  8032c5:	89 e5                	mov    %esp,%ebp
  8032c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	6a 25                	push   $0x25
  8032d6:	e8 8f fb ff ff       	call   802e6a <syscall>
  8032db:	83 c4 18             	add    $0x18,%esp
  8032de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8032e1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8032e5:	75 07                	jne    8032ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8032e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ec:	eb 05                	jmp    8032f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8032ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f3:	c9                   	leave  
  8032f4:	c3                   	ret    

008032f5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8032f5:	55                   	push   %ebp
  8032f6:	89 e5                	mov    %esp,%ebp
  8032f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 25                	push   $0x25
  803307:	e8 5e fb ff ff       	call   802e6a <syscall>
  80330c:	83 c4 18             	add    $0x18,%esp
  80330f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803312:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803316:	75 07                	jne    80331f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803318:	b8 01 00 00 00       	mov    $0x1,%eax
  80331d:	eb 05                	jmp    803324 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80331f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803324:	c9                   	leave  
  803325:	c3                   	ret    

00803326 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803326:	55                   	push   %ebp
  803327:	89 e5                	mov    %esp,%ebp
  803329:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80332c:	6a 00                	push   $0x0
  80332e:	6a 00                	push   $0x0
  803330:	6a 00                	push   $0x0
  803332:	6a 00                	push   $0x0
  803334:	6a 00                	push   $0x0
  803336:	6a 25                	push   $0x25
  803338:	e8 2d fb ff ff       	call   802e6a <syscall>
  80333d:	83 c4 18             	add    $0x18,%esp
  803340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803343:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803347:	75 07                	jne    803350 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803349:	b8 01 00 00 00       	mov    $0x1,%eax
  80334e:	eb 05                	jmp    803355 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803355:	c9                   	leave  
  803356:	c3                   	ret    

00803357 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803357:	55                   	push   %ebp
  803358:	89 e5                	mov    %esp,%ebp
  80335a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80335d:	6a 00                	push   $0x0
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 25                	push   $0x25
  803369:	e8 fc fa ff ff       	call   802e6a <syscall>
  80336e:	83 c4 18             	add    $0x18,%esp
  803371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803374:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803378:	75 07                	jne    803381 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80337a:	b8 01 00 00 00       	mov    $0x1,%eax
  80337f:	eb 05                	jmp    803386 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803381:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803386:	c9                   	leave  
  803387:	c3                   	ret    

00803388 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803388:	55                   	push   %ebp
  803389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80338b:	6a 00                	push   $0x0
  80338d:	6a 00                	push   $0x0
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	6a 26                	push   $0x26
  803398:	e8 cd fa ff ff       	call   802e6a <syscall>
  80339d:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a0:	90                   	nop
}
  8033a1:	c9                   	leave  
  8033a2:	c3                   	ret    

008033a3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8033a3:	55                   	push   %ebp
  8033a4:	89 e5                	mov    %esp,%ebp
  8033a6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8033a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	6a 00                	push   $0x0
  8033b5:	53                   	push   %ebx
  8033b6:	51                   	push   %ecx
  8033b7:	52                   	push   %edx
  8033b8:	50                   	push   %eax
  8033b9:	6a 27                	push   $0x27
  8033bb:	e8 aa fa ff ff       	call   802e6a <syscall>
  8033c0:	83 c4 18             	add    $0x18,%esp
}
  8033c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033c6:	c9                   	leave  
  8033c7:	c3                   	ret    

008033c8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8033c8:	55                   	push   %ebp
  8033c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8033cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	6a 00                	push   $0x0
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	52                   	push   %edx
  8033d8:	50                   	push   %eax
  8033d9:	6a 28                	push   $0x28
  8033db:	e8 8a fa ff ff       	call   802e6a <syscall>
  8033e0:	83 c4 18             	add    $0x18,%esp
}
  8033e3:	c9                   	leave  
  8033e4:	c3                   	ret    

008033e5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8033e5:	55                   	push   %ebp
  8033e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8033e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8033eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	6a 00                	push   $0x0
  8033f3:	51                   	push   %ecx
  8033f4:	ff 75 10             	pushl  0x10(%ebp)
  8033f7:	52                   	push   %edx
  8033f8:	50                   	push   %eax
  8033f9:	6a 29                	push   $0x29
  8033fb:	e8 6a fa ff ff       	call   802e6a <syscall>
  803400:	83 c4 18             	add    $0x18,%esp
}
  803403:	c9                   	leave  
  803404:	c3                   	ret    

00803405 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803405:	55                   	push   %ebp
  803406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	ff 75 10             	pushl  0x10(%ebp)
  80340f:	ff 75 0c             	pushl  0xc(%ebp)
  803412:	ff 75 08             	pushl  0x8(%ebp)
  803415:	6a 12                	push   $0x12
  803417:	e8 4e fa ff ff       	call   802e6a <syscall>
  80341c:	83 c4 18             	add    $0x18,%esp
	return ;
  80341f:	90                   	nop
}
  803420:	c9                   	leave  
  803421:	c3                   	ret    

00803422 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803422:	55                   	push   %ebp
  803423:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803425:	8b 55 0c             	mov    0xc(%ebp),%edx
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	6a 00                	push   $0x0
  80342d:	6a 00                	push   $0x0
  80342f:	6a 00                	push   $0x0
  803431:	52                   	push   %edx
  803432:	50                   	push   %eax
  803433:	6a 2a                	push   $0x2a
  803435:	e8 30 fa ff ff       	call   802e6a <syscall>
  80343a:	83 c4 18             	add    $0x18,%esp
	return;
  80343d:	90                   	nop
}
  80343e:	c9                   	leave  
  80343f:	c3                   	ret    

00803440 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803440:	55                   	push   %ebp
  803441:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	6a 00                	push   $0x0
  803448:	6a 00                	push   $0x0
  80344a:	6a 00                	push   $0x0
  80344c:	6a 00                	push   $0x0
  80344e:	50                   	push   %eax
  80344f:	6a 2b                	push   $0x2b
  803451:	e8 14 fa ff ff       	call   802e6a <syscall>
  803456:	83 c4 18             	add    $0x18,%esp
}
  803459:	c9                   	leave  
  80345a:	c3                   	ret    

0080345b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80345b:	55                   	push   %ebp
  80345c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80345e:	6a 00                	push   $0x0
  803460:	6a 00                	push   $0x0
  803462:	6a 00                	push   $0x0
  803464:	ff 75 0c             	pushl  0xc(%ebp)
  803467:	ff 75 08             	pushl  0x8(%ebp)
  80346a:	6a 2c                	push   $0x2c
  80346c:	e8 f9 f9 ff ff       	call   802e6a <syscall>
  803471:	83 c4 18             	add    $0x18,%esp
	return;
  803474:	90                   	nop
}
  803475:	c9                   	leave  
  803476:	c3                   	ret    

00803477 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803477:	55                   	push   %ebp
  803478:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	ff 75 0c             	pushl  0xc(%ebp)
  803483:	ff 75 08             	pushl  0x8(%ebp)
  803486:	6a 2d                	push   $0x2d
  803488:	e8 dd f9 ff ff       	call   802e6a <syscall>
  80348d:	83 c4 18             	add    $0x18,%esp
	return;
  803490:	90                   	nop
}
  803491:	c9                   	leave  
  803492:	c3                   	ret    

00803493 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803493:	55                   	push   %ebp
  803494:	89 e5                	mov    %esp,%ebp
  803496:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	83 e8 04             	sub    $0x4,%eax
  80349f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8034a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8034aa:	c9                   	leave  
  8034ab:	c3                   	ret    

008034ac <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	83 e8 04             	sub    $0x4,%eax
  8034b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8034bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	83 e0 01             	and    $0x1,%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	0f 94 c0             	sete   %al
}
  8034c8:	c9                   	leave  
  8034c9:	c3                   	ret    

008034ca <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8034ca:	55                   	push   %ebp
  8034cb:	89 e5                	mov    %esp,%ebp
  8034cd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8034d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8034d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034da:	83 f8 02             	cmp    $0x2,%eax
  8034dd:	74 2b                	je     80350a <alloc_block+0x40>
  8034df:	83 f8 02             	cmp    $0x2,%eax
  8034e2:	7f 07                	jg     8034eb <alloc_block+0x21>
  8034e4:	83 f8 01             	cmp    $0x1,%eax
  8034e7:	74 0e                	je     8034f7 <alloc_block+0x2d>
  8034e9:	eb 58                	jmp    803543 <alloc_block+0x79>
  8034eb:	83 f8 03             	cmp    $0x3,%eax
  8034ee:	74 2d                	je     80351d <alloc_block+0x53>
  8034f0:	83 f8 04             	cmp    $0x4,%eax
  8034f3:	74 3b                	je     803530 <alloc_block+0x66>
  8034f5:	eb 4c                	jmp    803543 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8034f7:	83 ec 0c             	sub    $0xc,%esp
  8034fa:	ff 75 08             	pushl  0x8(%ebp)
  8034fd:	e8 11 03 00 00       	call   803813 <alloc_block_FF>
  803502:	83 c4 10             	add    $0x10,%esp
  803505:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803508:	eb 4a                	jmp    803554 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80350a:	83 ec 0c             	sub    $0xc,%esp
  80350d:	ff 75 08             	pushl  0x8(%ebp)
  803510:	e8 fa 19 00 00       	call   804f0f <alloc_block_NF>
  803515:	83 c4 10             	add    $0x10,%esp
  803518:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80351b:	eb 37                	jmp    803554 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80351d:	83 ec 0c             	sub    $0xc,%esp
  803520:	ff 75 08             	pushl  0x8(%ebp)
  803523:	e8 a7 07 00 00       	call   803ccf <alloc_block_BF>
  803528:	83 c4 10             	add    $0x10,%esp
  80352b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80352e:	eb 24                	jmp    803554 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803530:	83 ec 0c             	sub    $0xc,%esp
  803533:	ff 75 08             	pushl  0x8(%ebp)
  803536:	e8 b7 19 00 00       	call   804ef2 <alloc_block_WF>
  80353b:	83 c4 10             	add    $0x10,%esp
  80353e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803541:	eb 11                	jmp    803554 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803543:	83 ec 0c             	sub    $0xc,%esp
  803546:	68 64 6a 80 00       	push   $0x806a64
  80354b:	e8 60 e5 ff ff       	call   801ab0 <cprintf>
  803550:	83 c4 10             	add    $0x10,%esp
		break;
  803553:	90                   	nop
	}
	return va;
  803554:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803557:	c9                   	leave  
  803558:	c3                   	ret    

00803559 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  803559:	55                   	push   %ebp
  80355a:	89 e5                	mov    %esp,%ebp
  80355c:	53                   	push   %ebx
  80355d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803560:	83 ec 0c             	sub    $0xc,%esp
  803563:	68 84 6a 80 00       	push   $0x806a84
  803568:	e8 43 e5 ff ff       	call   801ab0 <cprintf>
  80356d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803570:	83 ec 0c             	sub    $0xc,%esp
  803573:	68 af 6a 80 00       	push   $0x806aaf
  803578:	e8 33 e5 ff ff       	call   801ab0 <cprintf>
  80357d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803586:	eb 37                	jmp    8035bf <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803588:	83 ec 0c             	sub    $0xc,%esp
  80358b:	ff 75 f4             	pushl  -0xc(%ebp)
  80358e:	e8 19 ff ff ff       	call   8034ac <is_free_block>
  803593:	83 c4 10             	add    $0x10,%esp
  803596:	0f be d8             	movsbl %al,%ebx
  803599:	83 ec 0c             	sub    $0xc,%esp
  80359c:	ff 75 f4             	pushl  -0xc(%ebp)
  80359f:	e8 ef fe ff ff       	call   803493 <get_block_size>
  8035a4:	83 c4 10             	add    $0x10,%esp
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	53                   	push   %ebx
  8035ab:	50                   	push   %eax
  8035ac:	68 c7 6a 80 00       	push   $0x806ac7
  8035b1:	e8 fa e4 ff ff       	call   801ab0 <cprintf>
  8035b6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8035b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8035bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c3:	74 07                	je     8035cc <print_blocks_list+0x73>
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	eb 05                	jmp    8035d1 <print_blocks_list+0x78>
  8035cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d1:	89 45 10             	mov    %eax,0x10(%ebp)
  8035d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	75 ad                	jne    803588 <print_blocks_list+0x2f>
  8035db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035df:	75 a7                	jne    803588 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8035e1:	83 ec 0c             	sub    $0xc,%esp
  8035e4:	68 84 6a 80 00       	push   $0x806a84
  8035e9:	e8 c2 e4 ff ff       	call   801ab0 <cprintf>
  8035ee:	83 c4 10             	add    $0x10,%esp

}
  8035f1:	90                   	nop
  8035f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035f5:	c9                   	leave  
  8035f6:	c3                   	ret    

008035f7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8035f7:	55                   	push   %ebp
  8035f8:	89 e5                	mov    %esp,%ebp
  8035fa:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803600:	83 e0 01             	and    $0x1,%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 03                	je     80360a <initialize_dynamic_allocator+0x13>
  803607:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80360a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360e:	0f 84 c7 01 00 00    	je     8037db <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  803614:	c7 05 28 70 80 00 01 	movl   $0x1,0x807028
  80361b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80361e:	8b 55 08             	mov    0x8(%ebp),%edx
  803621:	8b 45 0c             	mov    0xc(%ebp),%eax
  803624:	01 d0                	add    %edx,%eax
  803626:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80362b:	0f 87 ad 01 00 00    	ja     8037de <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	0f 89 a5 01 00 00    	jns    8037e1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80363c:	8b 55 08             	mov    0x8(%ebp),%edx
  80363f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803642:	01 d0                	add    %edx,%eax
  803644:	83 e8 04             	sub    $0x4,%eax
  803647:	a3 48 70 80 00       	mov    %eax,0x807048
     struct BlockElement * element = NULL;
  80364c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  803653:	a1 30 70 80 00       	mov    0x807030,%eax
  803658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365b:	e9 87 00 00 00       	jmp    8036e7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803664:	75 14                	jne    80367a <initialize_dynamic_allocator+0x83>
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	68 df 6a 80 00       	push   $0x806adf
  80366e:	6a 79                	push   $0x79
  803670:	68 fd 6a 80 00       	push   $0x806afd
  803675:	e8 79 e1 ff ff       	call   8017f3 <_panic>
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 00                	mov    (%eax),%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	74 10                	je     803693 <initialize_dynamic_allocator+0x9c>
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80368b:	8b 52 04             	mov    0x4(%edx),%edx
  80368e:	89 50 04             	mov    %edx,0x4(%eax)
  803691:	eb 0b                	jmp    80369e <initialize_dynamic_allocator+0xa7>
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	8b 40 04             	mov    0x4(%eax),%eax
  803699:	a3 34 70 80 00       	mov    %eax,0x807034
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 40 04             	mov    0x4(%eax),%eax
  8036a4:	85 c0                	test   %eax,%eax
  8036a6:	74 0f                	je     8036b7 <initialize_dynamic_allocator+0xc0>
  8036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ab:	8b 40 04             	mov    0x4(%eax),%eax
  8036ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b1:	8b 12                	mov    (%edx),%edx
  8036b3:	89 10                	mov    %edx,(%eax)
  8036b5:	eb 0a                	jmp    8036c1 <initialize_dynamic_allocator+0xca>
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	a3 30 70 80 00       	mov    %eax,0x807030
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d4:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8036d9:	48                   	dec    %eax
  8036da:	a3 3c 70 80 00       	mov    %eax,0x80703c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8036df:	a1 38 70 80 00       	mov    0x807038,%eax
  8036e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036eb:	74 07                	je     8036f4 <initialize_dynamic_allocator+0xfd>
  8036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f0:	8b 00                	mov    (%eax),%eax
  8036f2:	eb 05                	jmp    8036f9 <initialize_dynamic_allocator+0x102>
  8036f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f9:	a3 38 70 80 00       	mov    %eax,0x807038
  8036fe:	a1 38 70 80 00       	mov    0x807038,%eax
  803703:	85 c0                	test   %eax,%eax
  803705:	0f 85 55 ff ff ff    	jne    803660 <initialize_dynamic_allocator+0x69>
  80370b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370f:	0f 85 4b ff ff ff    	jne    803660 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803724:	a1 48 70 80 00       	mov    0x807048,%eax
  803729:	a3 44 70 80 00       	mov    %eax,0x807044
    end_block->info = 1;
  80372e:	a1 44 70 80 00       	mov    0x807044,%eax
  803733:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  803739:	8b 45 08             	mov    0x8(%ebp),%eax
  80373c:	83 c0 08             	add    $0x8,%eax
  80373f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	83 c0 04             	add    $0x4,%eax
  803748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374b:	83 ea 08             	sub    $0x8,%edx
  80374e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803750:	8b 55 0c             	mov    0xc(%ebp),%edx
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	01 d0                	add    %edx,%eax
  803758:	83 e8 08             	sub    $0x8,%eax
  80375b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80375e:	83 ea 08             	sub    $0x8,%edx
  803761:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80376c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  803776:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80377a:	75 17                	jne    803793 <initialize_dynamic_allocator+0x19c>
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	68 18 6b 80 00       	push   $0x806b18
  803784:	68 90 00 00 00       	push   $0x90
  803789:	68 fd 6a 80 00       	push   $0x806afd
  80378e:	e8 60 e0 ff ff       	call   8017f3 <_panic>
  803793:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379c:	89 10                	mov    %edx,(%eax)
  80379e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	74 0d                	je     8037b4 <initialize_dynamic_allocator+0x1bd>
  8037a7:	a1 30 70 80 00       	mov    0x807030,%eax
  8037ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%eax)
  8037b2:	eb 08                	jmp    8037bc <initialize_dynamic_allocator+0x1c5>
  8037b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b7:	a3 34 70 80 00       	mov    %eax,0x807034
  8037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bf:	a3 30 70 80 00       	mov    %eax,0x807030
  8037c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ce:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8037d3:	40                   	inc    %eax
  8037d4:	a3 3c 70 80 00       	mov    %eax,0x80703c
  8037d9:	eb 07                	jmp    8037e2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8037db:	90                   	nop
  8037dc:	eb 04                	jmp    8037e2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8037de:	90                   	nop
  8037df:	eb 01                	jmp    8037e2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8037e1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8037e2:	c9                   	leave  
  8037e3:	c3                   	ret    

008037e4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8037e4:	55                   	push   %ebp
  8037e5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8037e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8037ea:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8037f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	83 e8 04             	sub    $0x4,%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	83 e0 fe             	and    $0xfffffffe,%eax
  803803:	8d 50 f8             	lea    -0x8(%eax),%edx
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	01 c2                	add    %eax,%edx
  80380b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380e:	89 02                	mov    %eax,(%edx)
}
  803810:	90                   	nop
  803811:	5d                   	pop    %ebp
  803812:	c3                   	ret    

00803813 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803813:	55                   	push   %ebp
  803814:	89 e5                	mov    %esp,%ebp
  803816:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
  80381c:	83 e0 01             	and    $0x1,%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 03                	je     803826 <alloc_block_FF+0x13>
  803823:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803826:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80382a:	77 07                	ja     803833 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80382c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803833:	a1 28 70 80 00       	mov    0x807028,%eax
  803838:	85 c0                	test   %eax,%eax
  80383a:	75 73                	jne    8038af <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80383c:	8b 45 08             	mov    0x8(%ebp),%eax
  80383f:	83 c0 10             	add    $0x10,%eax
  803842:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803845:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80384c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80384f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803852:	01 d0                	add    %edx,%eax
  803854:	48                   	dec    %eax
  803855:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	ba 00 00 00 00       	mov    $0x0,%edx
  803860:	f7 75 ec             	divl   -0x14(%ebp)
  803863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803866:	29 d0                	sub    %edx,%eax
  803868:	c1 e8 0c             	shr    $0xc,%eax
  80386b:	83 ec 0c             	sub    $0xc,%esp
  80386e:	50                   	push   %eax
  80386f:	e8 d6 ef ff ff       	call   80284a <sbrk>
  803874:	83 c4 10             	add    $0x10,%esp
  803877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80387a:	83 ec 0c             	sub    $0xc,%esp
  80387d:	6a 00                	push   $0x0
  80387f:	e8 c6 ef ff ff       	call   80284a <sbrk>
  803884:	83 c4 10             	add    $0x10,%esp
  803887:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80388a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803890:	83 ec 08             	sub    $0x8,%esp
  803893:	50                   	push   %eax
  803894:	ff 75 e4             	pushl  -0x1c(%ebp)
  803897:	e8 5b fd ff ff       	call   8035f7 <initialize_dynamic_allocator>
  80389c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80389f:	83 ec 0c             	sub    $0xc,%esp
  8038a2:	68 3b 6b 80 00       	push   $0x806b3b
  8038a7:	e8 04 e2 ff ff       	call   801ab0 <cprintf>
  8038ac:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8038af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b3:	75 0a                	jne    8038bf <alloc_block_FF+0xac>
	        return NULL;
  8038b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ba:	e9 0e 04 00 00       	jmp    803ccd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8038bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8038c6:	a1 30 70 80 00       	mov    0x807030,%eax
  8038cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ce:	e9 f3 02 00 00       	jmp    803bc6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8038d9:	83 ec 0c             	sub    $0xc,%esp
  8038dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8038df:	e8 af fb ff ff       	call   803493 <get_block_size>
  8038e4:	83 c4 10             	add    $0x10,%esp
  8038e7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	83 c0 08             	add    $0x8,%eax
  8038f0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8038f3:	0f 87 c5 02 00 00    	ja     803bbe <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8038f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fc:	83 c0 18             	add    $0x18,%eax
  8038ff:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803902:	0f 87 19 02 00 00    	ja     803b21 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803908:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390b:	2b 45 08             	sub    0x8(%ebp),%eax
  80390e:	83 e8 08             	sub    $0x8,%eax
  803911:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	8d 50 08             	lea    0x8(%eax),%edx
  80391a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80391d:	01 d0                	add    %edx,%eax
  80391f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	83 c0 08             	add    $0x8,%eax
  803928:	83 ec 04             	sub    $0x4,%esp
  80392b:	6a 01                	push   $0x1
  80392d:	50                   	push   %eax
  80392e:	ff 75 bc             	pushl  -0x44(%ebp)
  803931:	e8 ae fe ff ff       	call   8037e4 <set_block_data>
  803936:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  803939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393c:	8b 40 04             	mov    0x4(%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	75 68                	jne    8039ab <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803943:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803947:	75 17                	jne    803960 <alloc_block_FF+0x14d>
  803949:	83 ec 04             	sub    $0x4,%esp
  80394c:	68 18 6b 80 00       	push   $0x806b18
  803951:	68 d7 00 00 00       	push   $0xd7
  803956:	68 fd 6a 80 00       	push   $0x806afd
  80395b:	e8 93 de ff ff       	call   8017f3 <_panic>
  803960:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803966:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0d                	je     803981 <alloc_block_FF+0x16e>
  803974:	a1 30 70 80 00       	mov    0x807030,%eax
  803979:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80397c:	89 50 04             	mov    %edx,0x4(%eax)
  80397f:	eb 08                	jmp    803989 <alloc_block_FF+0x176>
  803981:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803984:	a3 34 70 80 00       	mov    %eax,0x807034
  803989:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80398c:	a3 30 70 80 00       	mov    %eax,0x807030
  803991:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399b:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8039a0:	40                   	inc    %eax
  8039a1:	a3 3c 70 80 00       	mov    %eax,0x80703c
  8039a6:	e9 dc 00 00 00       	jmp    803a87 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	85 c0                	test   %eax,%eax
  8039b2:	75 65                	jne    803a19 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8039b4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8039b8:	75 17                	jne    8039d1 <alloc_block_FF+0x1be>
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	68 4c 6b 80 00       	push   $0x806b4c
  8039c2:	68 db 00 00 00       	push   $0xdb
  8039c7:	68 fd 6a 80 00       	push   $0x806afd
  8039cc:	e8 22 de ff ff       	call   8017f3 <_panic>
  8039d1:	8b 15 34 70 80 00    	mov    0x807034,%edx
  8039d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039da:	89 50 04             	mov    %edx,0x4(%eax)
  8039dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039e0:	8b 40 04             	mov    0x4(%eax),%eax
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	74 0c                	je     8039f3 <alloc_block_FF+0x1e0>
  8039e7:	a1 34 70 80 00       	mov    0x807034,%eax
  8039ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8039ef:	89 10                	mov    %edx,(%eax)
  8039f1:	eb 08                	jmp    8039fb <alloc_block_FF+0x1e8>
  8039f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039f6:	a3 30 70 80 00       	mov    %eax,0x807030
  8039fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8039fe:	a3 34 70 80 00       	mov    %eax,0x807034
  803a03:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a0c:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803a11:	40                   	inc    %eax
  803a12:	a3 3c 70 80 00       	mov    %eax,0x80703c
  803a17:	eb 6e                	jmp    803a87 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1d:	74 06                	je     803a25 <alloc_block_FF+0x212>
  803a1f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803a23:	75 17                	jne    803a3c <alloc_block_FF+0x229>
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 70 6b 80 00       	push   $0x806b70
  803a2d:	68 df 00 00 00       	push   $0xdf
  803a32:	68 fd 6a 80 00       	push   $0x806afd
  803a37:	e8 b7 dd ff ff       	call   8017f3 <_panic>
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	8b 10                	mov    (%eax),%edx
  803a41:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a44:	89 10                	mov    %edx,(%eax)
  803a46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a49:	8b 00                	mov    (%eax),%eax
  803a4b:	85 c0                	test   %eax,%eax
  803a4d:	74 0b                	je     803a5a <alloc_block_FF+0x247>
  803a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a52:	8b 00                	mov    (%eax),%eax
  803a54:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803a57:	89 50 04             	mov    %edx,0x4(%eax)
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803a60:	89 10                	mov    %edx,(%eax)
  803a62:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a68:	89 50 04             	mov    %edx,0x4(%eax)
  803a6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a6e:	8b 00                	mov    (%eax),%eax
  803a70:	85 c0                	test   %eax,%eax
  803a72:	75 08                	jne    803a7c <alloc_block_FF+0x269>
  803a74:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a77:	a3 34 70 80 00       	mov    %eax,0x807034
  803a7c:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803a81:	40                   	inc    %eax
  803a82:	a3 3c 70 80 00       	mov    %eax,0x80703c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a8b:	75 17                	jne    803aa4 <alloc_block_FF+0x291>
  803a8d:	83 ec 04             	sub    $0x4,%esp
  803a90:	68 df 6a 80 00       	push   $0x806adf
  803a95:	68 e1 00 00 00       	push   $0xe1
  803a9a:	68 fd 6a 80 00       	push   $0x806afd
  803a9f:	e8 4f dd ff ff       	call   8017f3 <_panic>
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	85 c0                	test   %eax,%eax
  803aab:	74 10                	je     803abd <alloc_block_FF+0x2aa>
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	8b 00                	mov    (%eax),%eax
  803ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ab5:	8b 52 04             	mov    0x4(%edx),%edx
  803ab8:	89 50 04             	mov    %edx,0x4(%eax)
  803abb:	eb 0b                	jmp    803ac8 <alloc_block_FF+0x2b5>
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	8b 40 04             	mov    0x4(%eax),%eax
  803ac3:	a3 34 70 80 00       	mov    %eax,0x807034
  803ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acb:	8b 40 04             	mov    0x4(%eax),%eax
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	74 0f                	je     803ae1 <alloc_block_FF+0x2ce>
  803ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad5:	8b 40 04             	mov    0x4(%eax),%eax
  803ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803adb:	8b 12                	mov    (%edx),%edx
  803add:	89 10                	mov    %edx,(%eax)
  803adf:	eb 0a                	jmp    803aeb <alloc_block_FF+0x2d8>
  803ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	a3 30 70 80 00       	mov    %eax,0x807030
  803aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afe:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803b03:	48                   	dec    %eax
  803b04:	a3 3c 70 80 00       	mov    %eax,0x80703c
				set_block_data(new_block_va, remaining_size, 0);
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	6a 00                	push   $0x0
  803b0e:	ff 75 b4             	pushl  -0x4c(%ebp)
  803b11:	ff 75 b0             	pushl  -0x50(%ebp)
  803b14:	e8 cb fc ff ff       	call   8037e4 <set_block_data>
  803b19:	83 c4 10             	add    $0x10,%esp
  803b1c:	e9 95 00 00 00       	jmp    803bb6 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803b21:	83 ec 04             	sub    $0x4,%esp
  803b24:	6a 01                	push   $0x1
  803b26:	ff 75 b8             	pushl  -0x48(%ebp)
  803b29:	ff 75 bc             	pushl  -0x44(%ebp)
  803b2c:	e8 b3 fc ff ff       	call   8037e4 <set_block_data>
  803b31:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b38:	75 17                	jne    803b51 <alloc_block_FF+0x33e>
  803b3a:	83 ec 04             	sub    $0x4,%esp
  803b3d:	68 df 6a 80 00       	push   $0x806adf
  803b42:	68 e8 00 00 00       	push   $0xe8
  803b47:	68 fd 6a 80 00       	push   $0x806afd
  803b4c:	e8 a2 dc ff ff       	call   8017f3 <_panic>
  803b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b54:	8b 00                	mov    (%eax),%eax
  803b56:	85 c0                	test   %eax,%eax
  803b58:	74 10                	je     803b6a <alloc_block_FF+0x357>
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b62:	8b 52 04             	mov    0x4(%edx),%edx
  803b65:	89 50 04             	mov    %edx,0x4(%eax)
  803b68:	eb 0b                	jmp    803b75 <alloc_block_FF+0x362>
  803b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6d:	8b 40 04             	mov    0x4(%eax),%eax
  803b70:	a3 34 70 80 00       	mov    %eax,0x807034
  803b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b78:	8b 40 04             	mov    0x4(%eax),%eax
  803b7b:	85 c0                	test   %eax,%eax
  803b7d:	74 0f                	je     803b8e <alloc_block_FF+0x37b>
  803b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b82:	8b 40 04             	mov    0x4(%eax),%eax
  803b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b88:	8b 12                	mov    (%edx),%edx
  803b8a:	89 10                	mov    %edx,(%eax)
  803b8c:	eb 0a                	jmp    803b98 <alloc_block_FF+0x385>
  803b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b91:	8b 00                	mov    (%eax),%eax
  803b93:	a3 30 70 80 00       	mov    %eax,0x807030
  803b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bab:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803bb0:	48                   	dec    %eax
  803bb1:	a3 3c 70 80 00       	mov    %eax,0x80703c
	            }
	            return va;
  803bb6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803bb9:	e9 0f 01 00 00       	jmp    803ccd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803bbe:	a1 38 70 80 00       	mov    0x807038,%eax
  803bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bca:	74 07                	je     803bd3 <alloc_block_FF+0x3c0>
  803bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcf:	8b 00                	mov    (%eax),%eax
  803bd1:	eb 05                	jmp    803bd8 <alloc_block_FF+0x3c5>
  803bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd8:	a3 38 70 80 00       	mov    %eax,0x807038
  803bdd:	a1 38 70 80 00       	mov    0x807038,%eax
  803be2:	85 c0                	test   %eax,%eax
  803be4:	0f 85 e9 fc ff ff    	jne    8038d3 <alloc_block_FF+0xc0>
  803bea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bee:	0f 85 df fc ff ff    	jne    8038d3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf7:	83 c0 08             	add    $0x8,%eax
  803bfa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803bfd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c07:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c0a:	01 d0                	add    %edx,%eax
  803c0c:	48                   	dec    %eax
  803c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803c10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c13:	ba 00 00 00 00       	mov    $0x0,%edx
  803c18:	f7 75 d8             	divl   -0x28(%ebp)
  803c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1e:	29 d0                	sub    %edx,%eax
  803c20:	c1 e8 0c             	shr    $0xc,%eax
  803c23:	83 ec 0c             	sub    $0xc,%esp
  803c26:	50                   	push   %eax
  803c27:	e8 1e ec ff ff       	call   80284a <sbrk>
  803c2c:	83 c4 10             	add    $0x10,%esp
  803c2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803c32:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803c36:	75 0a                	jne    803c42 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803c38:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3d:	e9 8b 00 00 00       	jmp    803ccd <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803c42:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803c49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c4f:	01 d0                	add    %edx,%eax
  803c51:	48                   	dec    %eax
  803c52:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803c55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c58:	ba 00 00 00 00       	mov    $0x0,%edx
  803c5d:	f7 75 cc             	divl   -0x34(%ebp)
  803c60:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c63:	29 d0                	sub    %edx,%eax
  803c65:	8d 50 fc             	lea    -0x4(%eax),%edx
  803c68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c6b:	01 d0                	add    %edx,%eax
  803c6d:	a3 44 70 80 00       	mov    %eax,0x807044
			end_block->info = 1;
  803c72:	a1 44 70 80 00       	mov    0x807044,%eax
  803c77:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803c7d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803c84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c8a:	01 d0                	add    %edx,%eax
  803c8c:	48                   	dec    %eax
  803c8d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803c90:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c93:	ba 00 00 00 00       	mov    $0x0,%edx
  803c98:	f7 75 c4             	divl   -0x3c(%ebp)
  803c9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c9e:	29 d0                	sub    %edx,%eax
  803ca0:	83 ec 04             	sub    $0x4,%esp
  803ca3:	6a 01                	push   $0x1
  803ca5:	50                   	push   %eax
  803ca6:	ff 75 d0             	pushl  -0x30(%ebp)
  803ca9:	e8 36 fb ff ff       	call   8037e4 <set_block_data>
  803cae:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803cb1:	83 ec 0c             	sub    $0xc,%esp
  803cb4:	ff 75 d0             	pushl  -0x30(%ebp)
  803cb7:	e8 1b 0a 00 00       	call   8046d7 <free_block>
  803cbc:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803cbf:	83 ec 0c             	sub    $0xc,%esp
  803cc2:	ff 75 08             	pushl  0x8(%ebp)
  803cc5:	e8 49 fb ff ff       	call   803813 <alloc_block_FF>
  803cca:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803ccd:	c9                   	leave  
  803cce:	c3                   	ret    

00803ccf <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803ccf:	55                   	push   %ebp
  803cd0:	89 e5                	mov    %esp,%ebp
  803cd2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd8:	83 e0 01             	and    $0x1,%eax
  803cdb:	85 c0                	test   %eax,%eax
  803cdd:	74 03                	je     803ce2 <alloc_block_BF+0x13>
  803cdf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803ce2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803ce6:	77 07                	ja     803cef <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803ce8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803cef:	a1 28 70 80 00       	mov    0x807028,%eax
  803cf4:	85 c0                	test   %eax,%eax
  803cf6:	75 73                	jne    803d6b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	83 c0 10             	add    $0x10,%eax
  803cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803d01:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803d08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d0e:	01 d0                	add    %edx,%eax
  803d10:	48                   	dec    %eax
  803d11:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d17:	ba 00 00 00 00       	mov    $0x0,%edx
  803d1c:	f7 75 e0             	divl   -0x20(%ebp)
  803d1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d22:	29 d0                	sub    %edx,%eax
  803d24:	c1 e8 0c             	shr    $0xc,%eax
  803d27:	83 ec 0c             	sub    $0xc,%esp
  803d2a:	50                   	push   %eax
  803d2b:	e8 1a eb ff ff       	call   80284a <sbrk>
  803d30:	83 c4 10             	add    $0x10,%esp
  803d33:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803d36:	83 ec 0c             	sub    $0xc,%esp
  803d39:	6a 00                	push   $0x0
  803d3b:	e8 0a eb ff ff       	call   80284a <sbrk>
  803d40:	83 c4 10             	add    $0x10,%esp
  803d43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803d46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d49:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803d4c:	83 ec 08             	sub    $0x8,%esp
  803d4f:	50                   	push   %eax
  803d50:	ff 75 d8             	pushl  -0x28(%ebp)
  803d53:	e8 9f f8 ff ff       	call   8035f7 <initialize_dynamic_allocator>
  803d58:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803d5b:	83 ec 0c             	sub    $0xc,%esp
  803d5e:	68 3b 6b 80 00       	push   $0x806b3b
  803d63:	e8 48 dd ff ff       	call   801ab0 <cprintf>
  803d68:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803d72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803d79:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803d80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803d87:	a1 30 70 80 00       	mov    0x807030,%eax
  803d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d8f:	e9 1d 01 00 00       	jmp    803eb1 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d97:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803d9a:	83 ec 0c             	sub    $0xc,%esp
  803d9d:	ff 75 a8             	pushl  -0x58(%ebp)
  803da0:	e8 ee f6 ff ff       	call   803493 <get_block_size>
  803da5:	83 c4 10             	add    $0x10,%esp
  803da8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803dab:	8b 45 08             	mov    0x8(%ebp),%eax
  803dae:	83 c0 08             	add    $0x8,%eax
  803db1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803db4:	0f 87 ef 00 00 00    	ja     803ea9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803dba:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbd:	83 c0 18             	add    $0x18,%eax
  803dc0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803dc3:	77 1d                	ja     803de2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803dcb:	0f 86 d8 00 00 00    	jbe    803ea9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803dd1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803dd7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803dda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ddd:	e9 c7 00 00 00       	jmp    803ea9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803de2:	8b 45 08             	mov    0x8(%ebp),%eax
  803de5:	83 c0 08             	add    $0x8,%eax
  803de8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803deb:	0f 85 9d 00 00 00    	jne    803e8e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803df1:	83 ec 04             	sub    $0x4,%esp
  803df4:	6a 01                	push   $0x1
  803df6:	ff 75 a4             	pushl  -0x5c(%ebp)
  803df9:	ff 75 a8             	pushl  -0x58(%ebp)
  803dfc:	e8 e3 f9 ff ff       	call   8037e4 <set_block_data>
  803e01:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e08:	75 17                	jne    803e21 <alloc_block_BF+0x152>
  803e0a:	83 ec 04             	sub    $0x4,%esp
  803e0d:	68 df 6a 80 00       	push   $0x806adf
  803e12:	68 2c 01 00 00       	push   $0x12c
  803e17:	68 fd 6a 80 00       	push   $0x806afd
  803e1c:	e8 d2 d9 ff ff       	call   8017f3 <_panic>
  803e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e24:	8b 00                	mov    (%eax),%eax
  803e26:	85 c0                	test   %eax,%eax
  803e28:	74 10                	je     803e3a <alloc_block_BF+0x16b>
  803e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2d:	8b 00                	mov    (%eax),%eax
  803e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e32:	8b 52 04             	mov    0x4(%edx),%edx
  803e35:	89 50 04             	mov    %edx,0x4(%eax)
  803e38:	eb 0b                	jmp    803e45 <alloc_block_BF+0x176>
  803e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3d:	8b 40 04             	mov    0x4(%eax),%eax
  803e40:	a3 34 70 80 00       	mov    %eax,0x807034
  803e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e48:	8b 40 04             	mov    0x4(%eax),%eax
  803e4b:	85 c0                	test   %eax,%eax
  803e4d:	74 0f                	je     803e5e <alloc_block_BF+0x18f>
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	8b 40 04             	mov    0x4(%eax),%eax
  803e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e58:	8b 12                	mov    (%edx),%edx
  803e5a:	89 10                	mov    %edx,(%eax)
  803e5c:	eb 0a                	jmp    803e68 <alloc_block_BF+0x199>
  803e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e61:	8b 00                	mov    (%eax),%eax
  803e63:	a3 30 70 80 00       	mov    %eax,0x807030
  803e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e7b:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803e80:	48                   	dec    %eax
  803e81:	a3 3c 70 80 00       	mov    %eax,0x80703c
					return va;
  803e86:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803e89:	e9 24 04 00 00       	jmp    8042b2 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e91:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803e94:	76 13                	jbe    803ea9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803e96:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803e9d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803ea3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803ea6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803ea9:	a1 38 70 80 00       	mov    0x807038,%eax
  803eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eb5:	74 07                	je     803ebe <alloc_block_BF+0x1ef>
  803eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eba:	8b 00                	mov    (%eax),%eax
  803ebc:	eb 05                	jmp    803ec3 <alloc_block_BF+0x1f4>
  803ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec3:	a3 38 70 80 00       	mov    %eax,0x807038
  803ec8:	a1 38 70 80 00       	mov    0x807038,%eax
  803ecd:	85 c0                	test   %eax,%eax
  803ecf:	0f 85 bf fe ff ff    	jne    803d94 <alloc_block_BF+0xc5>
  803ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ed9:	0f 85 b5 fe ff ff    	jne    803d94 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ee3:	0f 84 26 02 00 00    	je     80410f <alloc_block_BF+0x440>
  803ee9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803eed:	0f 85 1c 02 00 00    	jne    80410f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef6:	2b 45 08             	sub    0x8(%ebp),%eax
  803ef9:	83 e8 08             	sub    $0x8,%eax
  803efc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803eff:	8b 45 08             	mov    0x8(%ebp),%eax
  803f02:	8d 50 08             	lea    0x8(%eax),%edx
  803f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f08:	01 d0                	add    %edx,%eax
  803f0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f10:	83 c0 08             	add    $0x8,%eax
  803f13:	83 ec 04             	sub    $0x4,%esp
  803f16:	6a 01                	push   $0x1
  803f18:	50                   	push   %eax
  803f19:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1c:	e8 c3 f8 ff ff       	call   8037e4 <set_block_data>
  803f21:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f27:	8b 40 04             	mov    0x4(%eax),%eax
  803f2a:	85 c0                	test   %eax,%eax
  803f2c:	75 68                	jne    803f96 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803f2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f32:	75 17                	jne    803f4b <alloc_block_BF+0x27c>
  803f34:	83 ec 04             	sub    $0x4,%esp
  803f37:	68 18 6b 80 00       	push   $0x806b18
  803f3c:	68 45 01 00 00       	push   $0x145
  803f41:	68 fd 6a 80 00       	push   $0x806afd
  803f46:	e8 a8 d8 ff ff       	call   8017f3 <_panic>
  803f4b:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f54:	89 10                	mov    %edx,(%eax)
  803f56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f59:	8b 00                	mov    (%eax),%eax
  803f5b:	85 c0                	test   %eax,%eax
  803f5d:	74 0d                	je     803f6c <alloc_block_BF+0x29d>
  803f5f:	a1 30 70 80 00       	mov    0x807030,%eax
  803f64:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f67:	89 50 04             	mov    %edx,0x4(%eax)
  803f6a:	eb 08                	jmp    803f74 <alloc_block_BF+0x2a5>
  803f6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f6f:	a3 34 70 80 00       	mov    %eax,0x807034
  803f74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f77:	a3 30 70 80 00       	mov    %eax,0x807030
  803f7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f86:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803f8b:	40                   	inc    %eax
  803f8c:	a3 3c 70 80 00       	mov    %eax,0x80703c
  803f91:	e9 dc 00 00 00       	jmp    804072 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f99:	8b 00                	mov    (%eax),%eax
  803f9b:	85 c0                	test   %eax,%eax
  803f9d:	75 65                	jne    804004 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803f9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803fa3:	75 17                	jne    803fbc <alloc_block_BF+0x2ed>
  803fa5:	83 ec 04             	sub    $0x4,%esp
  803fa8:	68 4c 6b 80 00       	push   $0x806b4c
  803fad:	68 4a 01 00 00       	push   $0x14a
  803fb2:	68 fd 6a 80 00       	push   $0x806afd
  803fb7:	e8 37 d8 ff ff       	call   8017f3 <_panic>
  803fbc:	8b 15 34 70 80 00    	mov    0x807034,%edx
  803fc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fc5:	89 50 04             	mov    %edx,0x4(%eax)
  803fc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fcb:	8b 40 04             	mov    0x4(%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 0c                	je     803fde <alloc_block_BF+0x30f>
  803fd2:	a1 34 70 80 00       	mov    0x807034,%eax
  803fd7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803fda:	89 10                	mov    %edx,(%eax)
  803fdc:	eb 08                	jmp    803fe6 <alloc_block_BF+0x317>
  803fde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fe1:	a3 30 70 80 00       	mov    %eax,0x807030
  803fe6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fe9:	a3 34 70 80 00       	mov    %eax,0x807034
  803fee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff7:	a1 3c 70 80 00       	mov    0x80703c,%eax
  803ffc:	40                   	inc    %eax
  803ffd:	a3 3c 70 80 00       	mov    %eax,0x80703c
  804002:	eb 6e                	jmp    804072 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  804004:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804008:	74 06                	je     804010 <alloc_block_BF+0x341>
  80400a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80400e:	75 17                	jne    804027 <alloc_block_BF+0x358>
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	68 70 6b 80 00       	push   $0x806b70
  804018:	68 4f 01 00 00       	push   $0x14f
  80401d:	68 fd 6a 80 00       	push   $0x806afd
  804022:	e8 cc d7 ff ff       	call   8017f3 <_panic>
  804027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402a:	8b 10                	mov    (%eax),%edx
  80402c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80402f:	89 10                	mov    %edx,(%eax)
  804031:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804034:	8b 00                	mov    (%eax),%eax
  804036:	85 c0                	test   %eax,%eax
  804038:	74 0b                	je     804045 <alloc_block_BF+0x376>
  80403a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403d:	8b 00                	mov    (%eax),%eax
  80403f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804042:	89 50 04             	mov    %edx,0x4(%eax)
  804045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804048:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80404b:	89 10                	mov    %edx,(%eax)
  80404d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804050:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804053:	89 50 04             	mov    %edx,0x4(%eax)
  804056:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804059:	8b 00                	mov    (%eax),%eax
  80405b:	85 c0                	test   %eax,%eax
  80405d:	75 08                	jne    804067 <alloc_block_BF+0x398>
  80405f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804062:	a3 34 70 80 00       	mov    %eax,0x807034
  804067:	a1 3c 70 80 00       	mov    0x80703c,%eax
  80406c:	40                   	inc    %eax
  80406d:	a3 3c 70 80 00       	mov    %eax,0x80703c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  804072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804076:	75 17                	jne    80408f <alloc_block_BF+0x3c0>
  804078:	83 ec 04             	sub    $0x4,%esp
  80407b:	68 df 6a 80 00       	push   $0x806adf
  804080:	68 51 01 00 00       	push   $0x151
  804085:	68 fd 6a 80 00       	push   $0x806afd
  80408a:	e8 64 d7 ff ff       	call   8017f3 <_panic>
  80408f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804092:	8b 00                	mov    (%eax),%eax
  804094:	85 c0                	test   %eax,%eax
  804096:	74 10                	je     8040a8 <alloc_block_BF+0x3d9>
  804098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409b:	8b 00                	mov    (%eax),%eax
  80409d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040a0:	8b 52 04             	mov    0x4(%edx),%edx
  8040a3:	89 50 04             	mov    %edx,0x4(%eax)
  8040a6:	eb 0b                	jmp    8040b3 <alloc_block_BF+0x3e4>
  8040a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ab:	8b 40 04             	mov    0x4(%eax),%eax
  8040ae:	a3 34 70 80 00       	mov    %eax,0x807034
  8040b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b6:	8b 40 04             	mov    0x4(%eax),%eax
  8040b9:	85 c0                	test   %eax,%eax
  8040bb:	74 0f                	je     8040cc <alloc_block_BF+0x3fd>
  8040bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c0:	8b 40 04             	mov    0x4(%eax),%eax
  8040c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040c6:	8b 12                	mov    (%edx),%edx
  8040c8:	89 10                	mov    %edx,(%eax)
  8040ca:	eb 0a                	jmp    8040d6 <alloc_block_BF+0x407>
  8040cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040cf:	8b 00                	mov    (%eax),%eax
  8040d1:	a3 30 70 80 00       	mov    %eax,0x807030
  8040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e9:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8040ee:	48                   	dec    %eax
  8040ef:	a3 3c 70 80 00       	mov    %eax,0x80703c
			set_block_data(new_block_va, remaining_size, 0);
  8040f4:	83 ec 04             	sub    $0x4,%esp
  8040f7:	6a 00                	push   $0x0
  8040f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8040fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8040ff:	e8 e0 f6 ff ff       	call   8037e4 <set_block_data>
  804104:	83 c4 10             	add    $0x10,%esp
			return best_va;
  804107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80410a:	e9 a3 01 00 00       	jmp    8042b2 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80410f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  804113:	0f 85 9d 00 00 00    	jne    8041b6 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  804119:	83 ec 04             	sub    $0x4,%esp
  80411c:	6a 01                	push   $0x1
  80411e:	ff 75 ec             	pushl  -0x14(%ebp)
  804121:	ff 75 f0             	pushl  -0x10(%ebp)
  804124:	e8 bb f6 ff ff       	call   8037e4 <set_block_data>
  804129:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80412c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804130:	75 17                	jne    804149 <alloc_block_BF+0x47a>
  804132:	83 ec 04             	sub    $0x4,%esp
  804135:	68 df 6a 80 00       	push   $0x806adf
  80413a:	68 58 01 00 00       	push   $0x158
  80413f:	68 fd 6a 80 00       	push   $0x806afd
  804144:	e8 aa d6 ff ff       	call   8017f3 <_panic>
  804149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80414c:	8b 00                	mov    (%eax),%eax
  80414e:	85 c0                	test   %eax,%eax
  804150:	74 10                	je     804162 <alloc_block_BF+0x493>
  804152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804155:	8b 00                	mov    (%eax),%eax
  804157:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80415a:	8b 52 04             	mov    0x4(%edx),%edx
  80415d:	89 50 04             	mov    %edx,0x4(%eax)
  804160:	eb 0b                	jmp    80416d <alloc_block_BF+0x49e>
  804162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804165:	8b 40 04             	mov    0x4(%eax),%eax
  804168:	a3 34 70 80 00       	mov    %eax,0x807034
  80416d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804170:	8b 40 04             	mov    0x4(%eax),%eax
  804173:	85 c0                	test   %eax,%eax
  804175:	74 0f                	je     804186 <alloc_block_BF+0x4b7>
  804177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80417a:	8b 40 04             	mov    0x4(%eax),%eax
  80417d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804180:	8b 12                	mov    (%edx),%edx
  804182:	89 10                	mov    %edx,(%eax)
  804184:	eb 0a                	jmp    804190 <alloc_block_BF+0x4c1>
  804186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804189:	8b 00                	mov    (%eax),%eax
  80418b:	a3 30 70 80 00       	mov    %eax,0x807030
  804190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80419c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041a3:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8041a8:	48                   	dec    %eax
  8041a9:	a3 3c 70 80 00       	mov    %eax,0x80703c
		return best_va;
  8041ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041b1:	e9 fc 00 00 00       	jmp    8042b2 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8041b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b9:	83 c0 08             	add    $0x8,%eax
  8041bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8041bf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8041c6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8041cc:	01 d0                	add    %edx,%eax
  8041ce:	48                   	dec    %eax
  8041cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8041d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8041d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8041da:	f7 75 c4             	divl   -0x3c(%ebp)
  8041dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8041e0:	29 d0                	sub    %edx,%eax
  8041e2:	c1 e8 0c             	shr    $0xc,%eax
  8041e5:	83 ec 0c             	sub    $0xc,%esp
  8041e8:	50                   	push   %eax
  8041e9:	e8 5c e6 ff ff       	call   80284a <sbrk>
  8041ee:	83 c4 10             	add    $0x10,%esp
  8041f1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8041f4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8041f8:	75 0a                	jne    804204 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8041fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ff:	e9 ae 00 00 00       	jmp    8042b2 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  804204:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80420b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80420e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804211:	01 d0                	add    %edx,%eax
  804213:	48                   	dec    %eax
  804214:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  804217:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80421a:	ba 00 00 00 00       	mov    $0x0,%edx
  80421f:	f7 75 b8             	divl   -0x48(%ebp)
  804222:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  804225:	29 d0                	sub    %edx,%eax
  804227:	8d 50 fc             	lea    -0x4(%eax),%edx
  80422a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80422d:	01 d0                	add    %edx,%eax
  80422f:	a3 44 70 80 00       	mov    %eax,0x807044
				end_block->info = 1;
  804234:	a1 44 70 80 00       	mov    0x807044,%eax
  804239:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80423f:	83 ec 0c             	sub    $0xc,%esp
  804242:	68 a4 6b 80 00       	push   $0x806ba4
  804247:	e8 64 d8 ff ff       	call   801ab0 <cprintf>
  80424c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80424f:	83 ec 08             	sub    $0x8,%esp
  804252:	ff 75 bc             	pushl  -0x44(%ebp)
  804255:	68 a9 6b 80 00       	push   $0x806ba9
  80425a:	e8 51 d8 ff ff       	call   801ab0 <cprintf>
  80425f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  804262:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  804269:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80426c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80426f:	01 d0                	add    %edx,%eax
  804271:	48                   	dec    %eax
  804272:	89 45 ac             	mov    %eax,-0x54(%ebp)
  804275:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804278:	ba 00 00 00 00       	mov    $0x0,%edx
  80427d:	f7 75 b0             	divl   -0x50(%ebp)
  804280:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804283:	29 d0                	sub    %edx,%eax
  804285:	83 ec 04             	sub    $0x4,%esp
  804288:	6a 01                	push   $0x1
  80428a:	50                   	push   %eax
  80428b:	ff 75 bc             	pushl  -0x44(%ebp)
  80428e:	e8 51 f5 ff ff       	call   8037e4 <set_block_data>
  804293:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  804296:	83 ec 0c             	sub    $0xc,%esp
  804299:	ff 75 bc             	pushl  -0x44(%ebp)
  80429c:	e8 36 04 00 00       	call   8046d7 <free_block>
  8042a1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8042a4:	83 ec 0c             	sub    $0xc,%esp
  8042a7:	ff 75 08             	pushl  0x8(%ebp)
  8042aa:	e8 20 fa ff ff       	call   803ccf <alloc_block_BF>
  8042af:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8042b2:	c9                   	leave  
  8042b3:	c3                   	ret    

008042b4 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8042b4:	55                   	push   %ebp
  8042b5:	89 e5                	mov    %esp,%ebp
  8042b7:	53                   	push   %ebx
  8042b8:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8042bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8042c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8042c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042cd:	74 1e                	je     8042ed <merging+0x39>
  8042cf:	ff 75 08             	pushl  0x8(%ebp)
  8042d2:	e8 bc f1 ff ff       	call   803493 <get_block_size>
  8042d7:	83 c4 04             	add    $0x4,%esp
  8042da:	89 c2                	mov    %eax,%edx
  8042dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8042df:	01 d0                	add    %edx,%eax
  8042e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8042e4:	75 07                	jne    8042ed <merging+0x39>
		prev_is_free = 1;
  8042e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8042ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8042f1:	74 1e                	je     804311 <merging+0x5d>
  8042f3:	ff 75 10             	pushl  0x10(%ebp)
  8042f6:	e8 98 f1 ff ff       	call   803493 <get_block_size>
  8042fb:	83 c4 04             	add    $0x4,%esp
  8042fe:	89 c2                	mov    %eax,%edx
  804300:	8b 45 10             	mov    0x10(%ebp),%eax
  804303:	01 d0                	add    %edx,%eax
  804305:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804308:	75 07                	jne    804311 <merging+0x5d>
		next_is_free = 1;
  80430a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  804311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804315:	0f 84 cc 00 00 00    	je     8043e7 <merging+0x133>
  80431b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80431f:	0f 84 c2 00 00 00    	je     8043e7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  804325:	ff 75 08             	pushl  0x8(%ebp)
  804328:	e8 66 f1 ff ff       	call   803493 <get_block_size>
  80432d:	83 c4 04             	add    $0x4,%esp
  804330:	89 c3                	mov    %eax,%ebx
  804332:	ff 75 10             	pushl  0x10(%ebp)
  804335:	e8 59 f1 ff ff       	call   803493 <get_block_size>
  80433a:	83 c4 04             	add    $0x4,%esp
  80433d:	01 c3                	add    %eax,%ebx
  80433f:	ff 75 0c             	pushl  0xc(%ebp)
  804342:	e8 4c f1 ff ff       	call   803493 <get_block_size>
  804347:	83 c4 04             	add    $0x4,%esp
  80434a:	01 d8                	add    %ebx,%eax
  80434c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80434f:	6a 00                	push   $0x0
  804351:	ff 75 ec             	pushl  -0x14(%ebp)
  804354:	ff 75 08             	pushl  0x8(%ebp)
  804357:	e8 88 f4 ff ff       	call   8037e4 <set_block_data>
  80435c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80435f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804363:	75 17                	jne    80437c <merging+0xc8>
  804365:	83 ec 04             	sub    $0x4,%esp
  804368:	68 df 6a 80 00       	push   $0x806adf
  80436d:	68 7d 01 00 00       	push   $0x17d
  804372:	68 fd 6a 80 00       	push   $0x806afd
  804377:	e8 77 d4 ff ff       	call   8017f3 <_panic>
  80437c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80437f:	8b 00                	mov    (%eax),%eax
  804381:	85 c0                	test   %eax,%eax
  804383:	74 10                	je     804395 <merging+0xe1>
  804385:	8b 45 0c             	mov    0xc(%ebp),%eax
  804388:	8b 00                	mov    (%eax),%eax
  80438a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80438d:	8b 52 04             	mov    0x4(%edx),%edx
  804390:	89 50 04             	mov    %edx,0x4(%eax)
  804393:	eb 0b                	jmp    8043a0 <merging+0xec>
  804395:	8b 45 0c             	mov    0xc(%ebp),%eax
  804398:	8b 40 04             	mov    0x4(%eax),%eax
  80439b:	a3 34 70 80 00       	mov    %eax,0x807034
  8043a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043a3:	8b 40 04             	mov    0x4(%eax),%eax
  8043a6:	85 c0                	test   %eax,%eax
  8043a8:	74 0f                	je     8043b9 <merging+0x105>
  8043aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043ad:	8b 40 04             	mov    0x4(%eax),%eax
  8043b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043b3:	8b 12                	mov    (%edx),%edx
  8043b5:	89 10                	mov    %edx,(%eax)
  8043b7:	eb 0a                	jmp    8043c3 <merging+0x10f>
  8043b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043bc:	8b 00                	mov    (%eax),%eax
  8043be:	a3 30 70 80 00       	mov    %eax,0x807030
  8043c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043d6:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8043db:	48                   	dec    %eax
  8043dc:	a3 3c 70 80 00       	mov    %eax,0x80703c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8043e1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8043e2:	e9 ea 02 00 00       	jmp    8046d1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8043e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043eb:	74 3b                	je     804428 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8043ed:	83 ec 0c             	sub    $0xc,%esp
  8043f0:	ff 75 08             	pushl  0x8(%ebp)
  8043f3:	e8 9b f0 ff ff       	call   803493 <get_block_size>
  8043f8:	83 c4 10             	add    $0x10,%esp
  8043fb:	89 c3                	mov    %eax,%ebx
  8043fd:	83 ec 0c             	sub    $0xc,%esp
  804400:	ff 75 10             	pushl  0x10(%ebp)
  804403:	e8 8b f0 ff ff       	call   803493 <get_block_size>
  804408:	83 c4 10             	add    $0x10,%esp
  80440b:	01 d8                	add    %ebx,%eax
  80440d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804410:	83 ec 04             	sub    $0x4,%esp
  804413:	6a 00                	push   $0x0
  804415:	ff 75 e8             	pushl  -0x18(%ebp)
  804418:	ff 75 08             	pushl  0x8(%ebp)
  80441b:	e8 c4 f3 ff ff       	call   8037e4 <set_block_data>
  804420:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804423:	e9 a9 02 00 00       	jmp    8046d1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  804428:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80442c:	0f 84 2d 01 00 00    	je     80455f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  804432:	83 ec 0c             	sub    $0xc,%esp
  804435:	ff 75 10             	pushl  0x10(%ebp)
  804438:	e8 56 f0 ff ff       	call   803493 <get_block_size>
  80443d:	83 c4 10             	add    $0x10,%esp
  804440:	89 c3                	mov    %eax,%ebx
  804442:	83 ec 0c             	sub    $0xc,%esp
  804445:	ff 75 0c             	pushl  0xc(%ebp)
  804448:	e8 46 f0 ff ff       	call   803493 <get_block_size>
  80444d:	83 c4 10             	add    $0x10,%esp
  804450:	01 d8                	add    %ebx,%eax
  804452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  804455:	83 ec 04             	sub    $0x4,%esp
  804458:	6a 00                	push   $0x0
  80445a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80445d:	ff 75 10             	pushl  0x10(%ebp)
  804460:	e8 7f f3 ff ff       	call   8037e4 <set_block_data>
  804465:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  804468:	8b 45 10             	mov    0x10(%ebp),%eax
  80446b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80446e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804472:	74 06                	je     80447a <merging+0x1c6>
  804474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804478:	75 17                	jne    804491 <merging+0x1dd>
  80447a:	83 ec 04             	sub    $0x4,%esp
  80447d:	68 b8 6b 80 00       	push   $0x806bb8
  804482:	68 8d 01 00 00       	push   $0x18d
  804487:	68 fd 6a 80 00       	push   $0x806afd
  80448c:	e8 62 d3 ff ff       	call   8017f3 <_panic>
  804491:	8b 45 0c             	mov    0xc(%ebp),%eax
  804494:	8b 50 04             	mov    0x4(%eax),%edx
  804497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80449a:	89 50 04             	mov    %edx,0x4(%eax)
  80449d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044a3:	89 10                	mov    %edx,(%eax)
  8044a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044a8:	8b 40 04             	mov    0x4(%eax),%eax
  8044ab:	85 c0                	test   %eax,%eax
  8044ad:	74 0d                	je     8044bc <merging+0x208>
  8044af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044b2:	8b 40 04             	mov    0x4(%eax),%eax
  8044b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8044b8:	89 10                	mov    %edx,(%eax)
  8044ba:	eb 08                	jmp    8044c4 <merging+0x210>
  8044bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044bf:	a3 30 70 80 00       	mov    %eax,0x807030
  8044c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8044ca:	89 50 04             	mov    %edx,0x4(%eax)
  8044cd:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8044d2:	40                   	inc    %eax
  8044d3:	a3 3c 70 80 00       	mov    %eax,0x80703c
		LIST_REMOVE(&freeBlocksList, next_block);
  8044d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8044dc:	75 17                	jne    8044f5 <merging+0x241>
  8044de:	83 ec 04             	sub    $0x4,%esp
  8044e1:	68 df 6a 80 00       	push   $0x806adf
  8044e6:	68 8e 01 00 00       	push   $0x18e
  8044eb:	68 fd 6a 80 00       	push   $0x806afd
  8044f0:	e8 fe d2 ff ff       	call   8017f3 <_panic>
  8044f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044f8:	8b 00                	mov    (%eax),%eax
  8044fa:	85 c0                	test   %eax,%eax
  8044fc:	74 10                	je     80450e <merging+0x25a>
  8044fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  804501:	8b 00                	mov    (%eax),%eax
  804503:	8b 55 0c             	mov    0xc(%ebp),%edx
  804506:	8b 52 04             	mov    0x4(%edx),%edx
  804509:	89 50 04             	mov    %edx,0x4(%eax)
  80450c:	eb 0b                	jmp    804519 <merging+0x265>
  80450e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804511:	8b 40 04             	mov    0x4(%eax),%eax
  804514:	a3 34 70 80 00       	mov    %eax,0x807034
  804519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80451c:	8b 40 04             	mov    0x4(%eax),%eax
  80451f:	85 c0                	test   %eax,%eax
  804521:	74 0f                	je     804532 <merging+0x27e>
  804523:	8b 45 0c             	mov    0xc(%ebp),%eax
  804526:	8b 40 04             	mov    0x4(%eax),%eax
  804529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80452c:	8b 12                	mov    (%edx),%edx
  80452e:	89 10                	mov    %edx,(%eax)
  804530:	eb 0a                	jmp    80453c <merging+0x288>
  804532:	8b 45 0c             	mov    0xc(%ebp),%eax
  804535:	8b 00                	mov    (%eax),%eax
  804537:	a3 30 70 80 00       	mov    %eax,0x807030
  80453c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80453f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804545:	8b 45 0c             	mov    0xc(%ebp),%eax
  804548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80454f:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804554:	48                   	dec    %eax
  804555:	a3 3c 70 80 00       	mov    %eax,0x80703c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80455a:	e9 72 01 00 00       	jmp    8046d1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80455f:	8b 45 10             	mov    0x10(%ebp),%eax
  804562:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  804565:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804569:	74 79                	je     8045e4 <merging+0x330>
  80456b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80456f:	74 73                	je     8045e4 <merging+0x330>
  804571:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804575:	74 06                	je     80457d <merging+0x2c9>
  804577:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80457b:	75 17                	jne    804594 <merging+0x2e0>
  80457d:	83 ec 04             	sub    $0x4,%esp
  804580:	68 70 6b 80 00       	push   $0x806b70
  804585:	68 94 01 00 00       	push   $0x194
  80458a:	68 fd 6a 80 00       	push   $0x806afd
  80458f:	e8 5f d2 ff ff       	call   8017f3 <_panic>
  804594:	8b 45 08             	mov    0x8(%ebp),%eax
  804597:	8b 10                	mov    (%eax),%edx
  804599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80459c:	89 10                	mov    %edx,(%eax)
  80459e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045a1:	8b 00                	mov    (%eax),%eax
  8045a3:	85 c0                	test   %eax,%eax
  8045a5:	74 0b                	je     8045b2 <merging+0x2fe>
  8045a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8045aa:	8b 00                	mov    (%eax),%eax
  8045ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8045af:	89 50 04             	mov    %edx,0x4(%eax)
  8045b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8045b8:	89 10                	mov    %edx,(%eax)
  8045ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8045c0:	89 50 04             	mov    %edx,0x4(%eax)
  8045c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045c6:	8b 00                	mov    (%eax),%eax
  8045c8:	85 c0                	test   %eax,%eax
  8045ca:	75 08                	jne    8045d4 <merging+0x320>
  8045cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8045cf:	a3 34 70 80 00       	mov    %eax,0x807034
  8045d4:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8045d9:	40                   	inc    %eax
  8045da:	a3 3c 70 80 00       	mov    %eax,0x80703c
  8045df:	e9 ce 00 00 00       	jmp    8046b2 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8045e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045e8:	74 65                	je     80464f <merging+0x39b>
  8045ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8045ee:	75 17                	jne    804607 <merging+0x353>
  8045f0:	83 ec 04             	sub    $0x4,%esp
  8045f3:	68 4c 6b 80 00       	push   $0x806b4c
  8045f8:	68 95 01 00 00       	push   $0x195
  8045fd:	68 fd 6a 80 00       	push   $0x806afd
  804602:	e8 ec d1 ff ff       	call   8017f3 <_panic>
  804607:	8b 15 34 70 80 00    	mov    0x807034,%edx
  80460d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804610:	89 50 04             	mov    %edx,0x4(%eax)
  804613:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804616:	8b 40 04             	mov    0x4(%eax),%eax
  804619:	85 c0                	test   %eax,%eax
  80461b:	74 0c                	je     804629 <merging+0x375>
  80461d:	a1 34 70 80 00       	mov    0x807034,%eax
  804622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804625:	89 10                	mov    %edx,(%eax)
  804627:	eb 08                	jmp    804631 <merging+0x37d>
  804629:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80462c:	a3 30 70 80 00       	mov    %eax,0x807030
  804631:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804634:	a3 34 70 80 00       	mov    %eax,0x807034
  804639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80463c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804642:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804647:	40                   	inc    %eax
  804648:	a3 3c 70 80 00       	mov    %eax,0x80703c
  80464d:	eb 63                	jmp    8046b2 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80464f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804653:	75 17                	jne    80466c <merging+0x3b8>
  804655:	83 ec 04             	sub    $0x4,%esp
  804658:	68 18 6b 80 00       	push   $0x806b18
  80465d:	68 98 01 00 00       	push   $0x198
  804662:	68 fd 6a 80 00       	push   $0x806afd
  804667:	e8 87 d1 ff ff       	call   8017f3 <_panic>
  80466c:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804675:	89 10                	mov    %edx,(%eax)
  804677:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80467a:	8b 00                	mov    (%eax),%eax
  80467c:	85 c0                	test   %eax,%eax
  80467e:	74 0d                	je     80468d <merging+0x3d9>
  804680:	a1 30 70 80 00       	mov    0x807030,%eax
  804685:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804688:	89 50 04             	mov    %edx,0x4(%eax)
  80468b:	eb 08                	jmp    804695 <merging+0x3e1>
  80468d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804690:	a3 34 70 80 00       	mov    %eax,0x807034
  804695:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804698:	a3 30 70 80 00       	mov    %eax,0x807030
  80469d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8046a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046a7:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8046ac:	40                   	inc    %eax
  8046ad:	a3 3c 70 80 00       	mov    %eax,0x80703c
		}
		set_block_data(va, get_block_size(va), 0);
  8046b2:	83 ec 0c             	sub    $0xc,%esp
  8046b5:	ff 75 10             	pushl  0x10(%ebp)
  8046b8:	e8 d6 ed ff ff       	call   803493 <get_block_size>
  8046bd:	83 c4 10             	add    $0x10,%esp
  8046c0:	83 ec 04             	sub    $0x4,%esp
  8046c3:	6a 00                	push   $0x0
  8046c5:	50                   	push   %eax
  8046c6:	ff 75 10             	pushl  0x10(%ebp)
  8046c9:	e8 16 f1 ff ff       	call   8037e4 <set_block_data>
  8046ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8046d1:	90                   	nop
  8046d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8046d5:	c9                   	leave  
  8046d6:	c3                   	ret    

008046d7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8046d7:	55                   	push   %ebp
  8046d8:	89 e5                	mov    %esp,%ebp
  8046da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8046dd:	a1 30 70 80 00       	mov    0x807030,%eax
  8046e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8046e5:	a1 34 70 80 00       	mov    0x807034,%eax
  8046ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8046ed:	73 1b                	jae    80470a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8046ef:	a1 34 70 80 00       	mov    0x807034,%eax
  8046f4:	83 ec 04             	sub    $0x4,%esp
  8046f7:	ff 75 08             	pushl  0x8(%ebp)
  8046fa:	6a 00                	push   $0x0
  8046fc:	50                   	push   %eax
  8046fd:	e8 b2 fb ff ff       	call   8042b4 <merging>
  804702:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804705:	e9 8b 00 00 00       	jmp    804795 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80470a:	a1 30 70 80 00       	mov    0x807030,%eax
  80470f:	3b 45 08             	cmp    0x8(%ebp),%eax
  804712:	76 18                	jbe    80472c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804714:	a1 30 70 80 00       	mov    0x807030,%eax
  804719:	83 ec 04             	sub    $0x4,%esp
  80471c:	ff 75 08             	pushl  0x8(%ebp)
  80471f:	50                   	push   %eax
  804720:	6a 00                	push   $0x0
  804722:	e8 8d fb ff ff       	call   8042b4 <merging>
  804727:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80472a:	eb 69                	jmp    804795 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80472c:	a1 30 70 80 00       	mov    0x807030,%eax
  804731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804734:	eb 39                	jmp    80476f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  804736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804739:	3b 45 08             	cmp    0x8(%ebp),%eax
  80473c:	73 29                	jae    804767 <free_block+0x90>
  80473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804741:	8b 00                	mov    (%eax),%eax
  804743:	3b 45 08             	cmp    0x8(%ebp),%eax
  804746:	76 1f                	jbe    804767 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  804748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80474b:	8b 00                	mov    (%eax),%eax
  80474d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804750:	83 ec 04             	sub    $0x4,%esp
  804753:	ff 75 08             	pushl  0x8(%ebp)
  804756:	ff 75 f0             	pushl  -0x10(%ebp)
  804759:	ff 75 f4             	pushl  -0xc(%ebp)
  80475c:	e8 53 fb ff ff       	call   8042b4 <merging>
  804761:	83 c4 10             	add    $0x10,%esp
			break;
  804764:	90                   	nop
		}
	}
}
  804765:	eb 2e                	jmp    804795 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804767:	a1 38 70 80 00       	mov    0x807038,%eax
  80476c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80476f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804773:	74 07                	je     80477c <free_block+0xa5>
  804775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804778:	8b 00                	mov    (%eax),%eax
  80477a:	eb 05                	jmp    804781 <free_block+0xaa>
  80477c:	b8 00 00 00 00       	mov    $0x0,%eax
  804781:	a3 38 70 80 00       	mov    %eax,0x807038
  804786:	a1 38 70 80 00       	mov    0x807038,%eax
  80478b:	85 c0                	test   %eax,%eax
  80478d:	75 a7                	jne    804736 <free_block+0x5f>
  80478f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804793:	75 a1                	jne    804736 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804795:	90                   	nop
  804796:	c9                   	leave  
  804797:	c3                   	ret    

00804798 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804798:	55                   	push   %ebp
  804799:	89 e5                	mov    %esp,%ebp
  80479b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80479e:	ff 75 08             	pushl  0x8(%ebp)
  8047a1:	e8 ed ec ff ff       	call   803493 <get_block_size>
  8047a6:	83 c4 04             	add    $0x4,%esp
  8047a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8047ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8047b3:	eb 17                	jmp    8047cc <copy_data+0x34>
  8047b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8047b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8047bb:	01 c2                	add    %eax,%edx
  8047bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8047c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c3:	01 c8                	add    %ecx,%eax
  8047c5:	8a 00                	mov    (%eax),%al
  8047c7:	88 02                	mov    %al,(%edx)
  8047c9:	ff 45 fc             	incl   -0x4(%ebp)
  8047cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8047cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8047d2:	72 e1                	jb     8047b5 <copy_data+0x1d>
}
  8047d4:	90                   	nop
  8047d5:	c9                   	leave  
  8047d6:	c3                   	ret    

008047d7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8047d7:	55                   	push   %ebp
  8047d8:	89 e5                	mov    %esp,%ebp
  8047da:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8047dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8047e1:	75 23                	jne    804806 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8047e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8047e7:	74 13                	je     8047fc <realloc_block_FF+0x25>
  8047e9:	83 ec 0c             	sub    $0xc,%esp
  8047ec:	ff 75 0c             	pushl  0xc(%ebp)
  8047ef:	e8 1f f0 ff ff       	call   803813 <alloc_block_FF>
  8047f4:	83 c4 10             	add    $0x10,%esp
  8047f7:	e9 f4 06 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
		return NULL;
  8047fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804801:	e9 ea 06 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  804806:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80480a:	75 18                	jne    804824 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80480c:	83 ec 0c             	sub    $0xc,%esp
  80480f:	ff 75 08             	pushl  0x8(%ebp)
  804812:	e8 c0 fe ff ff       	call   8046d7 <free_block>
  804817:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80481a:	b8 00 00 00 00       	mov    $0x0,%eax
  80481f:	e9 cc 06 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  804824:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804828:	77 07                	ja     804831 <realloc_block_FF+0x5a>
  80482a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804831:	8b 45 0c             	mov    0xc(%ebp),%eax
  804834:	83 e0 01             	and    $0x1,%eax
  804837:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80483a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80483d:	83 c0 08             	add    $0x8,%eax
  804840:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804843:	83 ec 0c             	sub    $0xc,%esp
  804846:	ff 75 08             	pushl  0x8(%ebp)
  804849:	e8 45 ec ff ff       	call   803493 <get_block_size>
  80484e:	83 c4 10             	add    $0x10,%esp
  804851:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804857:	83 e8 08             	sub    $0x8,%eax
  80485a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80485d:	8b 45 08             	mov    0x8(%ebp),%eax
  804860:	83 e8 04             	sub    $0x4,%eax
  804863:	8b 00                	mov    (%eax),%eax
  804865:	83 e0 fe             	and    $0xfffffffe,%eax
  804868:	89 c2                	mov    %eax,%edx
  80486a:	8b 45 08             	mov    0x8(%ebp),%eax
  80486d:	01 d0                	add    %edx,%eax
  80486f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804872:	83 ec 0c             	sub    $0xc,%esp
  804875:	ff 75 e4             	pushl  -0x1c(%ebp)
  804878:	e8 16 ec ff ff       	call   803493 <get_block_size>
  80487d:	83 c4 10             	add    $0x10,%esp
  804880:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804886:	83 e8 08             	sub    $0x8,%eax
  804889:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80488c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80488f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804892:	75 08                	jne    80489c <realloc_block_FF+0xc5>
	{
		 return va;
  804894:	8b 45 08             	mov    0x8(%ebp),%eax
  804897:	e9 54 06 00 00       	jmp    804ef0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80489c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80489f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8048a2:	0f 83 e5 03 00 00    	jae    804c8d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8048a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048ab:	2b 45 0c             	sub    0xc(%ebp),%eax
  8048ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8048b1:	83 ec 0c             	sub    $0xc,%esp
  8048b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8048b7:	e8 f0 eb ff ff       	call   8034ac <is_free_block>
  8048bc:	83 c4 10             	add    $0x10,%esp
  8048bf:	84 c0                	test   %al,%al
  8048c1:	0f 84 3b 01 00 00    	je     804a02 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8048c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8048ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8048cd:	01 d0                	add    %edx,%eax
  8048cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8048d2:	83 ec 04             	sub    $0x4,%esp
  8048d5:	6a 01                	push   $0x1
  8048d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8048da:	ff 75 08             	pushl  0x8(%ebp)
  8048dd:	e8 02 ef ff ff       	call   8037e4 <set_block_data>
  8048e2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8048e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e8:	83 e8 04             	sub    $0x4,%eax
  8048eb:	8b 00                	mov    (%eax),%eax
  8048ed:	83 e0 fe             	and    $0xfffffffe,%eax
  8048f0:	89 c2                	mov    %eax,%edx
  8048f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8048f5:	01 d0                	add    %edx,%eax
  8048f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8048fa:	83 ec 04             	sub    $0x4,%esp
  8048fd:	6a 00                	push   $0x0
  8048ff:	ff 75 cc             	pushl  -0x34(%ebp)
  804902:	ff 75 c8             	pushl  -0x38(%ebp)
  804905:	e8 da ee ff ff       	call   8037e4 <set_block_data>
  80490a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80490d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804911:	74 06                	je     804919 <realloc_block_FF+0x142>
  804913:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804917:	75 17                	jne    804930 <realloc_block_FF+0x159>
  804919:	83 ec 04             	sub    $0x4,%esp
  80491c:	68 70 6b 80 00       	push   $0x806b70
  804921:	68 f6 01 00 00       	push   $0x1f6
  804926:	68 fd 6a 80 00       	push   $0x806afd
  80492b:	e8 c3 ce ff ff       	call   8017f3 <_panic>
  804930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804933:	8b 10                	mov    (%eax),%edx
  804935:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804938:	89 10                	mov    %edx,(%eax)
  80493a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80493d:	8b 00                	mov    (%eax),%eax
  80493f:	85 c0                	test   %eax,%eax
  804941:	74 0b                	je     80494e <realloc_block_FF+0x177>
  804943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804946:	8b 00                	mov    (%eax),%eax
  804948:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80494b:	89 50 04             	mov    %edx,0x4(%eax)
  80494e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804951:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804954:	89 10                	mov    %edx,(%eax)
  804956:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80495c:	89 50 04             	mov    %edx,0x4(%eax)
  80495f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804962:	8b 00                	mov    (%eax),%eax
  804964:	85 c0                	test   %eax,%eax
  804966:	75 08                	jne    804970 <realloc_block_FF+0x199>
  804968:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80496b:	a3 34 70 80 00       	mov    %eax,0x807034
  804970:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804975:	40                   	inc    %eax
  804976:	a3 3c 70 80 00       	mov    %eax,0x80703c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80497b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80497f:	75 17                	jne    804998 <realloc_block_FF+0x1c1>
  804981:	83 ec 04             	sub    $0x4,%esp
  804984:	68 df 6a 80 00       	push   $0x806adf
  804989:	68 f7 01 00 00       	push   $0x1f7
  80498e:	68 fd 6a 80 00       	push   $0x806afd
  804993:	e8 5b ce ff ff       	call   8017f3 <_panic>
  804998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80499b:	8b 00                	mov    (%eax),%eax
  80499d:	85 c0                	test   %eax,%eax
  80499f:	74 10                	je     8049b1 <realloc_block_FF+0x1da>
  8049a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049a4:	8b 00                	mov    (%eax),%eax
  8049a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049a9:	8b 52 04             	mov    0x4(%edx),%edx
  8049ac:	89 50 04             	mov    %edx,0x4(%eax)
  8049af:	eb 0b                	jmp    8049bc <realloc_block_FF+0x1e5>
  8049b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049b4:	8b 40 04             	mov    0x4(%eax),%eax
  8049b7:	a3 34 70 80 00       	mov    %eax,0x807034
  8049bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049bf:	8b 40 04             	mov    0x4(%eax),%eax
  8049c2:	85 c0                	test   %eax,%eax
  8049c4:	74 0f                	je     8049d5 <realloc_block_FF+0x1fe>
  8049c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049c9:	8b 40 04             	mov    0x4(%eax),%eax
  8049cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049cf:	8b 12                	mov    (%edx),%edx
  8049d1:	89 10                	mov    %edx,(%eax)
  8049d3:	eb 0a                	jmp    8049df <realloc_block_FF+0x208>
  8049d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049d8:	8b 00                	mov    (%eax),%eax
  8049da:	a3 30 70 80 00       	mov    %eax,0x807030
  8049df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049f2:	a1 3c 70 80 00       	mov    0x80703c,%eax
  8049f7:	48                   	dec    %eax
  8049f8:	a3 3c 70 80 00       	mov    %eax,0x80703c
  8049fd:	e9 83 02 00 00       	jmp    804c85 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804a02:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804a06:	0f 86 69 02 00 00    	jbe    804c75 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804a0c:	83 ec 04             	sub    $0x4,%esp
  804a0f:	6a 01                	push   $0x1
  804a11:	ff 75 f0             	pushl  -0x10(%ebp)
  804a14:	ff 75 08             	pushl  0x8(%ebp)
  804a17:	e8 c8 ed ff ff       	call   8037e4 <set_block_data>
  804a1c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  804a22:	83 e8 04             	sub    $0x4,%eax
  804a25:	8b 00                	mov    (%eax),%eax
  804a27:	83 e0 fe             	and    $0xfffffffe,%eax
  804a2a:	89 c2                	mov    %eax,%edx
  804a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  804a2f:	01 d0                	add    %edx,%eax
  804a31:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804a34:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804a39:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804a3c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804a40:	75 68                	jne    804aaa <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804a42:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a46:	75 17                	jne    804a5f <realloc_block_FF+0x288>
  804a48:	83 ec 04             	sub    $0x4,%esp
  804a4b:	68 18 6b 80 00       	push   $0x806b18
  804a50:	68 06 02 00 00       	push   $0x206
  804a55:	68 fd 6a 80 00       	push   $0x806afd
  804a5a:	e8 94 cd ff ff       	call   8017f3 <_panic>
  804a5f:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804a65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a68:	89 10                	mov    %edx,(%eax)
  804a6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a6d:	8b 00                	mov    (%eax),%eax
  804a6f:	85 c0                	test   %eax,%eax
  804a71:	74 0d                	je     804a80 <realloc_block_FF+0x2a9>
  804a73:	a1 30 70 80 00       	mov    0x807030,%eax
  804a78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a7b:	89 50 04             	mov    %edx,0x4(%eax)
  804a7e:	eb 08                	jmp    804a88 <realloc_block_FF+0x2b1>
  804a80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a83:	a3 34 70 80 00       	mov    %eax,0x807034
  804a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a8b:	a3 30 70 80 00       	mov    %eax,0x807030
  804a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a9a:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804a9f:	40                   	inc    %eax
  804aa0:	a3 3c 70 80 00       	mov    %eax,0x80703c
  804aa5:	e9 b0 01 00 00       	jmp    804c5a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804aaa:	a1 30 70 80 00       	mov    0x807030,%eax
  804aaf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804ab2:	76 68                	jbe    804b1c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804ab4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804ab8:	75 17                	jne    804ad1 <realloc_block_FF+0x2fa>
  804aba:	83 ec 04             	sub    $0x4,%esp
  804abd:	68 18 6b 80 00       	push   $0x806b18
  804ac2:	68 0b 02 00 00       	push   $0x20b
  804ac7:	68 fd 6a 80 00       	push   $0x806afd
  804acc:	e8 22 cd ff ff       	call   8017f3 <_panic>
  804ad1:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804ad7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804ada:	89 10                	mov    %edx,(%eax)
  804adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804adf:	8b 00                	mov    (%eax),%eax
  804ae1:	85 c0                	test   %eax,%eax
  804ae3:	74 0d                	je     804af2 <realloc_block_FF+0x31b>
  804ae5:	a1 30 70 80 00       	mov    0x807030,%eax
  804aea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804aed:	89 50 04             	mov    %edx,0x4(%eax)
  804af0:	eb 08                	jmp    804afa <realloc_block_FF+0x323>
  804af2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804af5:	a3 34 70 80 00       	mov    %eax,0x807034
  804afa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804afd:	a3 30 70 80 00       	mov    %eax,0x807030
  804b02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b0c:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804b11:	40                   	inc    %eax
  804b12:	a3 3c 70 80 00       	mov    %eax,0x80703c
  804b17:	e9 3e 01 00 00       	jmp    804c5a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804b1c:	a1 30 70 80 00       	mov    0x807030,%eax
  804b21:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804b24:	73 68                	jae    804b8e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804b26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804b2a:	75 17                	jne    804b43 <realloc_block_FF+0x36c>
  804b2c:	83 ec 04             	sub    $0x4,%esp
  804b2f:	68 4c 6b 80 00       	push   $0x806b4c
  804b34:	68 10 02 00 00       	push   $0x210
  804b39:	68 fd 6a 80 00       	push   $0x806afd
  804b3e:	e8 b0 cc ff ff       	call   8017f3 <_panic>
  804b43:	8b 15 34 70 80 00    	mov    0x807034,%edx
  804b49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b4c:	89 50 04             	mov    %edx,0x4(%eax)
  804b4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b52:	8b 40 04             	mov    0x4(%eax),%eax
  804b55:	85 c0                	test   %eax,%eax
  804b57:	74 0c                	je     804b65 <realloc_block_FF+0x38e>
  804b59:	a1 34 70 80 00       	mov    0x807034,%eax
  804b5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804b61:	89 10                	mov    %edx,(%eax)
  804b63:	eb 08                	jmp    804b6d <realloc_block_FF+0x396>
  804b65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b68:	a3 30 70 80 00       	mov    %eax,0x807030
  804b6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b70:	a3 34 70 80 00       	mov    %eax,0x807034
  804b75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804b78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b7e:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804b83:	40                   	inc    %eax
  804b84:	a3 3c 70 80 00       	mov    %eax,0x80703c
  804b89:	e9 cc 00 00 00       	jmp    804c5a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804b95:	a1 30 70 80 00       	mov    0x807030,%eax
  804b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804b9d:	e9 8a 00 00 00       	jmp    804c2c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ba5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804ba8:	73 7a                	jae    804c24 <realloc_block_FF+0x44d>
  804baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bad:	8b 00                	mov    (%eax),%eax
  804baf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804bb2:	73 70                	jae    804c24 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804bb8:	74 06                	je     804bc0 <realloc_block_FF+0x3e9>
  804bba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804bbe:	75 17                	jne    804bd7 <realloc_block_FF+0x400>
  804bc0:	83 ec 04             	sub    $0x4,%esp
  804bc3:	68 70 6b 80 00       	push   $0x806b70
  804bc8:	68 1a 02 00 00       	push   $0x21a
  804bcd:	68 fd 6a 80 00       	push   $0x806afd
  804bd2:	e8 1c cc ff ff       	call   8017f3 <_panic>
  804bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bda:	8b 10                	mov    (%eax),%edx
  804bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804bdf:	89 10                	mov    %edx,(%eax)
  804be1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804be4:	8b 00                	mov    (%eax),%eax
  804be6:	85 c0                	test   %eax,%eax
  804be8:	74 0b                	je     804bf5 <realloc_block_FF+0x41e>
  804bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bed:	8b 00                	mov    (%eax),%eax
  804bef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804bf2:	89 50 04             	mov    %edx,0x4(%eax)
  804bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bf8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804bfb:	89 10                	mov    %edx,(%eax)
  804bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c03:	89 50 04             	mov    %edx,0x4(%eax)
  804c06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804c09:	8b 00                	mov    (%eax),%eax
  804c0b:	85 c0                	test   %eax,%eax
  804c0d:	75 08                	jne    804c17 <realloc_block_FF+0x440>
  804c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804c12:	a3 34 70 80 00       	mov    %eax,0x807034
  804c17:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804c1c:	40                   	inc    %eax
  804c1d:	a3 3c 70 80 00       	mov    %eax,0x80703c
							break;
  804c22:	eb 36                	jmp    804c5a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804c24:	a1 38 70 80 00       	mov    0x807038,%eax
  804c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804c30:	74 07                	je     804c39 <realloc_block_FF+0x462>
  804c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c35:	8b 00                	mov    (%eax),%eax
  804c37:	eb 05                	jmp    804c3e <realloc_block_FF+0x467>
  804c39:	b8 00 00 00 00       	mov    $0x0,%eax
  804c3e:	a3 38 70 80 00       	mov    %eax,0x807038
  804c43:	a1 38 70 80 00       	mov    0x807038,%eax
  804c48:	85 c0                	test   %eax,%eax
  804c4a:	0f 85 52 ff ff ff    	jne    804ba2 <realloc_block_FF+0x3cb>
  804c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804c54:	0f 85 48 ff ff ff    	jne    804ba2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804c5a:	83 ec 04             	sub    $0x4,%esp
  804c5d:	6a 00                	push   $0x0
  804c5f:	ff 75 d8             	pushl  -0x28(%ebp)
  804c62:	ff 75 d4             	pushl  -0x2c(%ebp)
  804c65:	e8 7a eb ff ff       	call   8037e4 <set_block_data>
  804c6a:	83 c4 10             	add    $0x10,%esp
				return va;
  804c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  804c70:	e9 7b 02 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804c75:	83 ec 0c             	sub    $0xc,%esp
  804c78:	68 ed 6b 80 00       	push   $0x806bed
  804c7d:	e8 2e ce ff ff       	call   801ab0 <cprintf>
  804c82:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804c85:	8b 45 08             	mov    0x8(%ebp),%eax
  804c88:	e9 63 02 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804c90:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804c93:	0f 86 4d 02 00 00    	jbe    804ee6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804c99:	83 ec 0c             	sub    $0xc,%esp
  804c9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  804c9f:	e8 08 e8 ff ff       	call   8034ac <is_free_block>
  804ca4:	83 c4 10             	add    $0x10,%esp
  804ca7:	84 c0                	test   %al,%al
  804ca9:	0f 84 37 02 00 00    	je     804ee6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  804cb2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804cb5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804cb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804cbb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804cbe:	76 38                	jbe    804cf8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804cc0:	83 ec 0c             	sub    $0xc,%esp
  804cc3:	ff 75 08             	pushl  0x8(%ebp)
  804cc6:	e8 0c fa ff ff       	call   8046d7 <free_block>
  804ccb:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804cce:	83 ec 0c             	sub    $0xc,%esp
  804cd1:	ff 75 0c             	pushl  0xc(%ebp)
  804cd4:	e8 3a eb ff ff       	call   803813 <alloc_block_FF>
  804cd9:	83 c4 10             	add    $0x10,%esp
  804cdc:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804cdf:	83 ec 08             	sub    $0x8,%esp
  804ce2:	ff 75 c0             	pushl  -0x40(%ebp)
  804ce5:	ff 75 08             	pushl  0x8(%ebp)
  804ce8:	e8 ab fa ff ff       	call   804798 <copy_data>
  804ced:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804cf0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804cf3:	e9 f8 01 00 00       	jmp    804ef0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804cfb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804cfe:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804d01:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804d05:	0f 87 a0 00 00 00    	ja     804dab <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804d0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d0f:	75 17                	jne    804d28 <realloc_block_FF+0x551>
  804d11:	83 ec 04             	sub    $0x4,%esp
  804d14:	68 df 6a 80 00       	push   $0x806adf
  804d19:	68 38 02 00 00       	push   $0x238
  804d1e:	68 fd 6a 80 00       	push   $0x806afd
  804d23:	e8 cb ca ff ff       	call   8017f3 <_panic>
  804d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d2b:	8b 00                	mov    (%eax),%eax
  804d2d:	85 c0                	test   %eax,%eax
  804d2f:	74 10                	je     804d41 <realloc_block_FF+0x56a>
  804d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d34:	8b 00                	mov    (%eax),%eax
  804d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d39:	8b 52 04             	mov    0x4(%edx),%edx
  804d3c:	89 50 04             	mov    %edx,0x4(%eax)
  804d3f:	eb 0b                	jmp    804d4c <realloc_block_FF+0x575>
  804d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d44:	8b 40 04             	mov    0x4(%eax),%eax
  804d47:	a3 34 70 80 00       	mov    %eax,0x807034
  804d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d4f:	8b 40 04             	mov    0x4(%eax),%eax
  804d52:	85 c0                	test   %eax,%eax
  804d54:	74 0f                	je     804d65 <realloc_block_FF+0x58e>
  804d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d59:	8b 40 04             	mov    0x4(%eax),%eax
  804d5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d5f:	8b 12                	mov    (%edx),%edx
  804d61:	89 10                	mov    %edx,(%eax)
  804d63:	eb 0a                	jmp    804d6f <realloc_block_FF+0x598>
  804d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d68:	8b 00                	mov    (%eax),%eax
  804d6a:	a3 30 70 80 00       	mov    %eax,0x807030
  804d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d82:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804d87:	48                   	dec    %eax
  804d88:	a3 3c 70 80 00       	mov    %eax,0x80703c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804d8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804d93:	01 d0                	add    %edx,%eax
  804d95:	83 ec 04             	sub    $0x4,%esp
  804d98:	6a 01                	push   $0x1
  804d9a:	50                   	push   %eax
  804d9b:	ff 75 08             	pushl  0x8(%ebp)
  804d9e:	e8 41 ea ff ff       	call   8037e4 <set_block_data>
  804da3:	83 c4 10             	add    $0x10,%esp
  804da6:	e9 36 01 00 00       	jmp    804ee1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804dab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804dae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804db1:	01 d0                	add    %edx,%eax
  804db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804db6:	83 ec 04             	sub    $0x4,%esp
  804db9:	6a 01                	push   $0x1
  804dbb:	ff 75 f0             	pushl  -0x10(%ebp)
  804dbe:	ff 75 08             	pushl  0x8(%ebp)
  804dc1:	e8 1e ea ff ff       	call   8037e4 <set_block_data>
  804dc6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  804dcc:	83 e8 04             	sub    $0x4,%eax
  804dcf:	8b 00                	mov    (%eax),%eax
  804dd1:	83 e0 fe             	and    $0xfffffffe,%eax
  804dd4:	89 c2                	mov    %eax,%edx
  804dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  804dd9:	01 d0                	add    %edx,%eax
  804ddb:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804dde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804de2:	74 06                	je     804dea <realloc_block_FF+0x613>
  804de4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804de8:	75 17                	jne    804e01 <realloc_block_FF+0x62a>
  804dea:	83 ec 04             	sub    $0x4,%esp
  804ded:	68 70 6b 80 00       	push   $0x806b70
  804df2:	68 44 02 00 00       	push   $0x244
  804df7:	68 fd 6a 80 00       	push   $0x806afd
  804dfc:	e8 f2 c9 ff ff       	call   8017f3 <_panic>
  804e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e04:	8b 10                	mov    (%eax),%edx
  804e06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804e09:	89 10                	mov    %edx,(%eax)
  804e0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804e0e:	8b 00                	mov    (%eax),%eax
  804e10:	85 c0                	test   %eax,%eax
  804e12:	74 0b                	je     804e1f <realloc_block_FF+0x648>
  804e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e17:	8b 00                	mov    (%eax),%eax
  804e19:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804e1c:	89 50 04             	mov    %edx,0x4(%eax)
  804e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e22:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804e25:	89 10                	mov    %edx,(%eax)
  804e27:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e2d:	89 50 04             	mov    %edx,0x4(%eax)
  804e30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804e33:	8b 00                	mov    (%eax),%eax
  804e35:	85 c0                	test   %eax,%eax
  804e37:	75 08                	jne    804e41 <realloc_block_FF+0x66a>
  804e39:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804e3c:	a3 34 70 80 00       	mov    %eax,0x807034
  804e41:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804e46:	40                   	inc    %eax
  804e47:	a3 3c 70 80 00       	mov    %eax,0x80703c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804e50:	75 17                	jne    804e69 <realloc_block_FF+0x692>
  804e52:	83 ec 04             	sub    $0x4,%esp
  804e55:	68 df 6a 80 00       	push   $0x806adf
  804e5a:	68 45 02 00 00       	push   $0x245
  804e5f:	68 fd 6a 80 00       	push   $0x806afd
  804e64:	e8 8a c9 ff ff       	call   8017f3 <_panic>
  804e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e6c:	8b 00                	mov    (%eax),%eax
  804e6e:	85 c0                	test   %eax,%eax
  804e70:	74 10                	je     804e82 <realloc_block_FF+0x6ab>
  804e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e75:	8b 00                	mov    (%eax),%eax
  804e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e7a:	8b 52 04             	mov    0x4(%edx),%edx
  804e7d:	89 50 04             	mov    %edx,0x4(%eax)
  804e80:	eb 0b                	jmp    804e8d <realloc_block_FF+0x6b6>
  804e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e85:	8b 40 04             	mov    0x4(%eax),%eax
  804e88:	a3 34 70 80 00       	mov    %eax,0x807034
  804e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e90:	8b 40 04             	mov    0x4(%eax),%eax
  804e93:	85 c0                	test   %eax,%eax
  804e95:	74 0f                	je     804ea6 <realloc_block_FF+0x6cf>
  804e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e9a:	8b 40 04             	mov    0x4(%eax),%eax
  804e9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804ea0:	8b 12                	mov    (%edx),%edx
  804ea2:	89 10                	mov    %edx,(%eax)
  804ea4:	eb 0a                	jmp    804eb0 <realloc_block_FF+0x6d9>
  804ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ea9:	8b 00                	mov    (%eax),%eax
  804eab:	a3 30 70 80 00       	mov    %eax,0x807030
  804eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ec3:	a1 3c 70 80 00       	mov    0x80703c,%eax
  804ec8:	48                   	dec    %eax
  804ec9:	a3 3c 70 80 00       	mov    %eax,0x80703c
				set_block_data(next_new_va, remaining_size, 0);
  804ece:	83 ec 04             	sub    $0x4,%esp
  804ed1:	6a 00                	push   $0x0
  804ed3:	ff 75 bc             	pushl  -0x44(%ebp)
  804ed6:	ff 75 b8             	pushl  -0x48(%ebp)
  804ed9:	e8 06 e9 ff ff       	call   8037e4 <set_block_data>
  804ede:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  804ee4:	eb 0a                	jmp    804ef0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804ee6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804ef0:	c9                   	leave  
  804ef1:	c3                   	ret    

00804ef2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804ef2:	55                   	push   %ebp
  804ef3:	89 e5                	mov    %esp,%ebp
  804ef5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804ef8:	83 ec 04             	sub    $0x4,%esp
  804efb:	68 f4 6b 80 00       	push   $0x806bf4
  804f00:	68 58 02 00 00       	push   $0x258
  804f05:	68 fd 6a 80 00       	push   $0x806afd
  804f0a:	e8 e4 c8 ff ff       	call   8017f3 <_panic>

00804f0f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804f0f:	55                   	push   %ebp
  804f10:	89 e5                	mov    %esp,%ebp
  804f12:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804f15:	83 ec 04             	sub    $0x4,%esp
  804f18:	68 1c 6c 80 00       	push   $0x806c1c
  804f1d:	68 61 02 00 00       	push   $0x261
  804f22:	68 fd 6a 80 00       	push   $0x806afd
  804f27:	e8 c7 c8 ff ff       	call   8017f3 <_panic>

00804f2c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804f2c:	55                   	push   %ebp
  804f2d:	89 e5                	mov    %esp,%ebp
  804f2f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804f32:	8b 55 08             	mov    0x8(%ebp),%edx
  804f35:	89 d0                	mov    %edx,%eax
  804f37:	c1 e0 02             	shl    $0x2,%eax
  804f3a:	01 d0                	add    %edx,%eax
  804f3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f43:	01 d0                	add    %edx,%eax
  804f45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f4c:	01 d0                	add    %edx,%eax
  804f4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f55:	01 d0                	add    %edx,%eax
  804f57:	c1 e0 04             	shl    $0x4,%eax
  804f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804f64:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804f67:	83 ec 0c             	sub    $0xc,%esp
  804f6a:	50                   	push   %eax
  804f6b:	e8 2f e2 ff ff       	call   80319f <sys_get_virtual_time>
  804f70:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804f73:	eb 41                	jmp    804fb6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804f75:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804f78:	83 ec 0c             	sub    $0xc,%esp
  804f7b:	50                   	push   %eax
  804f7c:	e8 1e e2 ff ff       	call   80319f <sys_get_virtual_time>
  804f81:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804f84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f8a:	29 c2                	sub    %eax,%edx
  804f8c:	89 d0                	mov    %edx,%eax
  804f8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804f97:	89 d1                	mov    %edx,%ecx
  804f99:	29 c1                	sub    %eax,%ecx
  804f9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804fa1:	39 c2                	cmp    %eax,%edx
  804fa3:	0f 97 c0             	seta   %al
  804fa6:	0f b6 c0             	movzbl %al,%eax
  804fa9:	29 c1                	sub    %eax,%ecx
  804fab:	89 c8                	mov    %ecx,%eax
  804fad:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fb9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804fbc:	72 b7                	jb     804f75 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804fbe:	90                   	nop
  804fbf:	c9                   	leave  
  804fc0:	c3                   	ret    

00804fc1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804fc1:	55                   	push   %ebp
  804fc2:	89 e5                	mov    %esp,%ebp
  804fc4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804fce:	eb 03                	jmp    804fd3 <busy_wait+0x12>
  804fd0:	ff 45 fc             	incl   -0x4(%ebp)
  804fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804fd6:	3b 45 08             	cmp    0x8(%ebp),%eax
  804fd9:	72 f5                	jb     804fd0 <busy_wait+0xf>
	return i;
  804fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804fde:	c9                   	leave  
  804fdf:	c3                   	ret    

00804fe0 <__udivdi3>:
  804fe0:	55                   	push   %ebp
  804fe1:	57                   	push   %edi
  804fe2:	56                   	push   %esi
  804fe3:	53                   	push   %ebx
  804fe4:	83 ec 1c             	sub    $0x1c,%esp
  804fe7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804feb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804fef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ff3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804ff7:	89 ca                	mov    %ecx,%edx
  804ff9:	89 f8                	mov    %edi,%eax
  804ffb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804fff:	85 f6                	test   %esi,%esi
  805001:	75 2d                	jne    805030 <__udivdi3+0x50>
  805003:	39 cf                	cmp    %ecx,%edi
  805005:	77 65                	ja     80506c <__udivdi3+0x8c>
  805007:	89 fd                	mov    %edi,%ebp
  805009:	85 ff                	test   %edi,%edi
  80500b:	75 0b                	jne    805018 <__udivdi3+0x38>
  80500d:	b8 01 00 00 00       	mov    $0x1,%eax
  805012:	31 d2                	xor    %edx,%edx
  805014:	f7 f7                	div    %edi
  805016:	89 c5                	mov    %eax,%ebp
  805018:	31 d2                	xor    %edx,%edx
  80501a:	89 c8                	mov    %ecx,%eax
  80501c:	f7 f5                	div    %ebp
  80501e:	89 c1                	mov    %eax,%ecx
  805020:	89 d8                	mov    %ebx,%eax
  805022:	f7 f5                	div    %ebp
  805024:	89 cf                	mov    %ecx,%edi
  805026:	89 fa                	mov    %edi,%edx
  805028:	83 c4 1c             	add    $0x1c,%esp
  80502b:	5b                   	pop    %ebx
  80502c:	5e                   	pop    %esi
  80502d:	5f                   	pop    %edi
  80502e:	5d                   	pop    %ebp
  80502f:	c3                   	ret    
  805030:	39 ce                	cmp    %ecx,%esi
  805032:	77 28                	ja     80505c <__udivdi3+0x7c>
  805034:	0f bd fe             	bsr    %esi,%edi
  805037:	83 f7 1f             	xor    $0x1f,%edi
  80503a:	75 40                	jne    80507c <__udivdi3+0x9c>
  80503c:	39 ce                	cmp    %ecx,%esi
  80503e:	72 0a                	jb     80504a <__udivdi3+0x6a>
  805040:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805044:	0f 87 9e 00 00 00    	ja     8050e8 <__udivdi3+0x108>
  80504a:	b8 01 00 00 00       	mov    $0x1,%eax
  80504f:	89 fa                	mov    %edi,%edx
  805051:	83 c4 1c             	add    $0x1c,%esp
  805054:	5b                   	pop    %ebx
  805055:	5e                   	pop    %esi
  805056:	5f                   	pop    %edi
  805057:	5d                   	pop    %ebp
  805058:	c3                   	ret    
  805059:	8d 76 00             	lea    0x0(%esi),%esi
  80505c:	31 ff                	xor    %edi,%edi
  80505e:	31 c0                	xor    %eax,%eax
  805060:	89 fa                	mov    %edi,%edx
  805062:	83 c4 1c             	add    $0x1c,%esp
  805065:	5b                   	pop    %ebx
  805066:	5e                   	pop    %esi
  805067:	5f                   	pop    %edi
  805068:	5d                   	pop    %ebp
  805069:	c3                   	ret    
  80506a:	66 90                	xchg   %ax,%ax
  80506c:	89 d8                	mov    %ebx,%eax
  80506e:	f7 f7                	div    %edi
  805070:	31 ff                	xor    %edi,%edi
  805072:	89 fa                	mov    %edi,%edx
  805074:	83 c4 1c             	add    $0x1c,%esp
  805077:	5b                   	pop    %ebx
  805078:	5e                   	pop    %esi
  805079:	5f                   	pop    %edi
  80507a:	5d                   	pop    %ebp
  80507b:	c3                   	ret    
  80507c:	bd 20 00 00 00       	mov    $0x20,%ebp
  805081:	89 eb                	mov    %ebp,%ebx
  805083:	29 fb                	sub    %edi,%ebx
  805085:	89 f9                	mov    %edi,%ecx
  805087:	d3 e6                	shl    %cl,%esi
  805089:	89 c5                	mov    %eax,%ebp
  80508b:	88 d9                	mov    %bl,%cl
  80508d:	d3 ed                	shr    %cl,%ebp
  80508f:	89 e9                	mov    %ebp,%ecx
  805091:	09 f1                	or     %esi,%ecx
  805093:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  805097:	89 f9                	mov    %edi,%ecx
  805099:	d3 e0                	shl    %cl,%eax
  80509b:	89 c5                	mov    %eax,%ebp
  80509d:	89 d6                	mov    %edx,%esi
  80509f:	88 d9                	mov    %bl,%cl
  8050a1:	d3 ee                	shr    %cl,%esi
  8050a3:	89 f9                	mov    %edi,%ecx
  8050a5:	d3 e2                	shl    %cl,%edx
  8050a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8050ab:	88 d9                	mov    %bl,%cl
  8050ad:	d3 e8                	shr    %cl,%eax
  8050af:	09 c2                	or     %eax,%edx
  8050b1:	89 d0                	mov    %edx,%eax
  8050b3:	89 f2                	mov    %esi,%edx
  8050b5:	f7 74 24 0c          	divl   0xc(%esp)
  8050b9:	89 d6                	mov    %edx,%esi
  8050bb:	89 c3                	mov    %eax,%ebx
  8050bd:	f7 e5                	mul    %ebp
  8050bf:	39 d6                	cmp    %edx,%esi
  8050c1:	72 19                	jb     8050dc <__udivdi3+0xfc>
  8050c3:	74 0b                	je     8050d0 <__udivdi3+0xf0>
  8050c5:	89 d8                	mov    %ebx,%eax
  8050c7:	31 ff                	xor    %edi,%edi
  8050c9:	e9 58 ff ff ff       	jmp    805026 <__udivdi3+0x46>
  8050ce:	66 90                	xchg   %ax,%ax
  8050d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8050d4:	89 f9                	mov    %edi,%ecx
  8050d6:	d3 e2                	shl    %cl,%edx
  8050d8:	39 c2                	cmp    %eax,%edx
  8050da:	73 e9                	jae    8050c5 <__udivdi3+0xe5>
  8050dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8050df:	31 ff                	xor    %edi,%edi
  8050e1:	e9 40 ff ff ff       	jmp    805026 <__udivdi3+0x46>
  8050e6:	66 90                	xchg   %ax,%ax
  8050e8:	31 c0                	xor    %eax,%eax
  8050ea:	e9 37 ff ff ff       	jmp    805026 <__udivdi3+0x46>
  8050ef:	90                   	nop

008050f0 <__umoddi3>:
  8050f0:	55                   	push   %ebp
  8050f1:	57                   	push   %edi
  8050f2:	56                   	push   %esi
  8050f3:	53                   	push   %ebx
  8050f4:	83 ec 1c             	sub    $0x1c,%esp
  8050f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8050fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8050ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805103:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  805107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80510b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80510f:	89 f3                	mov    %esi,%ebx
  805111:	89 fa                	mov    %edi,%edx
  805113:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805117:	89 34 24             	mov    %esi,(%esp)
  80511a:	85 c0                	test   %eax,%eax
  80511c:	75 1a                	jne    805138 <__umoddi3+0x48>
  80511e:	39 f7                	cmp    %esi,%edi
  805120:	0f 86 a2 00 00 00    	jbe    8051c8 <__umoddi3+0xd8>
  805126:	89 c8                	mov    %ecx,%eax
  805128:	89 f2                	mov    %esi,%edx
  80512a:	f7 f7                	div    %edi
  80512c:	89 d0                	mov    %edx,%eax
  80512e:	31 d2                	xor    %edx,%edx
  805130:	83 c4 1c             	add    $0x1c,%esp
  805133:	5b                   	pop    %ebx
  805134:	5e                   	pop    %esi
  805135:	5f                   	pop    %edi
  805136:	5d                   	pop    %ebp
  805137:	c3                   	ret    
  805138:	39 f0                	cmp    %esi,%eax
  80513a:	0f 87 ac 00 00 00    	ja     8051ec <__umoddi3+0xfc>
  805140:	0f bd e8             	bsr    %eax,%ebp
  805143:	83 f5 1f             	xor    $0x1f,%ebp
  805146:	0f 84 ac 00 00 00    	je     8051f8 <__umoddi3+0x108>
  80514c:	bf 20 00 00 00       	mov    $0x20,%edi
  805151:	29 ef                	sub    %ebp,%edi
  805153:	89 fe                	mov    %edi,%esi
  805155:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805159:	89 e9                	mov    %ebp,%ecx
  80515b:	d3 e0                	shl    %cl,%eax
  80515d:	89 d7                	mov    %edx,%edi
  80515f:	89 f1                	mov    %esi,%ecx
  805161:	d3 ef                	shr    %cl,%edi
  805163:	09 c7                	or     %eax,%edi
  805165:	89 e9                	mov    %ebp,%ecx
  805167:	d3 e2                	shl    %cl,%edx
  805169:	89 14 24             	mov    %edx,(%esp)
  80516c:	89 d8                	mov    %ebx,%eax
  80516e:	d3 e0                	shl    %cl,%eax
  805170:	89 c2                	mov    %eax,%edx
  805172:	8b 44 24 08          	mov    0x8(%esp),%eax
  805176:	d3 e0                	shl    %cl,%eax
  805178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80517c:	8b 44 24 08          	mov    0x8(%esp),%eax
  805180:	89 f1                	mov    %esi,%ecx
  805182:	d3 e8                	shr    %cl,%eax
  805184:	09 d0                	or     %edx,%eax
  805186:	d3 eb                	shr    %cl,%ebx
  805188:	89 da                	mov    %ebx,%edx
  80518a:	f7 f7                	div    %edi
  80518c:	89 d3                	mov    %edx,%ebx
  80518e:	f7 24 24             	mull   (%esp)
  805191:	89 c6                	mov    %eax,%esi
  805193:	89 d1                	mov    %edx,%ecx
  805195:	39 d3                	cmp    %edx,%ebx
  805197:	0f 82 87 00 00 00    	jb     805224 <__umoddi3+0x134>
  80519d:	0f 84 91 00 00 00    	je     805234 <__umoddi3+0x144>
  8051a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8051a7:	29 f2                	sub    %esi,%edx
  8051a9:	19 cb                	sbb    %ecx,%ebx
  8051ab:	89 d8                	mov    %ebx,%eax
  8051ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8051b1:	d3 e0                	shl    %cl,%eax
  8051b3:	89 e9                	mov    %ebp,%ecx
  8051b5:	d3 ea                	shr    %cl,%edx
  8051b7:	09 d0                	or     %edx,%eax
  8051b9:	89 e9                	mov    %ebp,%ecx
  8051bb:	d3 eb                	shr    %cl,%ebx
  8051bd:	89 da                	mov    %ebx,%edx
  8051bf:	83 c4 1c             	add    $0x1c,%esp
  8051c2:	5b                   	pop    %ebx
  8051c3:	5e                   	pop    %esi
  8051c4:	5f                   	pop    %edi
  8051c5:	5d                   	pop    %ebp
  8051c6:	c3                   	ret    
  8051c7:	90                   	nop
  8051c8:	89 fd                	mov    %edi,%ebp
  8051ca:	85 ff                	test   %edi,%edi
  8051cc:	75 0b                	jne    8051d9 <__umoddi3+0xe9>
  8051ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8051d3:	31 d2                	xor    %edx,%edx
  8051d5:	f7 f7                	div    %edi
  8051d7:	89 c5                	mov    %eax,%ebp
  8051d9:	89 f0                	mov    %esi,%eax
  8051db:	31 d2                	xor    %edx,%edx
  8051dd:	f7 f5                	div    %ebp
  8051df:	89 c8                	mov    %ecx,%eax
  8051e1:	f7 f5                	div    %ebp
  8051e3:	89 d0                	mov    %edx,%eax
  8051e5:	e9 44 ff ff ff       	jmp    80512e <__umoddi3+0x3e>
  8051ea:	66 90                	xchg   %ax,%ax
  8051ec:	89 c8                	mov    %ecx,%eax
  8051ee:	89 f2                	mov    %esi,%edx
  8051f0:	83 c4 1c             	add    $0x1c,%esp
  8051f3:	5b                   	pop    %ebx
  8051f4:	5e                   	pop    %esi
  8051f5:	5f                   	pop    %edi
  8051f6:	5d                   	pop    %ebp
  8051f7:	c3                   	ret    
  8051f8:	3b 04 24             	cmp    (%esp),%eax
  8051fb:	72 06                	jb     805203 <__umoddi3+0x113>
  8051fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805201:	77 0f                	ja     805212 <__umoddi3+0x122>
  805203:	89 f2                	mov    %esi,%edx
  805205:	29 f9                	sub    %edi,%ecx
  805207:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80520b:	89 14 24             	mov    %edx,(%esp)
  80520e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805212:	8b 44 24 04          	mov    0x4(%esp),%eax
  805216:	8b 14 24             	mov    (%esp),%edx
  805219:	83 c4 1c             	add    $0x1c,%esp
  80521c:	5b                   	pop    %ebx
  80521d:	5e                   	pop    %esi
  80521e:	5f                   	pop    %edi
  80521f:	5d                   	pop    %ebp
  805220:	c3                   	ret    
  805221:	8d 76 00             	lea    0x0(%esi),%esi
  805224:	2b 04 24             	sub    (%esp),%eax
  805227:	19 fa                	sbb    %edi,%edx
  805229:	89 d1                	mov    %edx,%ecx
  80522b:	89 c6                	mov    %eax,%esi
  80522d:	e9 71 ff ff ff       	jmp    8051a3 <__umoddi3+0xb3>
  805232:	66 90                	xchg   %ax,%ax
  805234:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805238:	72 ea                	jb     805224 <__umoddi3+0x134>
  80523a:	89 d9                	mov    %ebx,%ecx
  80523c:	e9 62 ff ff ff       	jmp    8051a3 <__umoddi3+0xb3>
