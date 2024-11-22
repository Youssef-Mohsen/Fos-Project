
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
  800081:	68 a0 50 80 00       	push   $0x8050a0
  800086:	6a 1e                	push   $0x1e
  800088:	68 bc 50 80 00       	push   $0x8050bc
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
  8000d7:	e8 fe 2c 00 00       	call   802dda <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 d0 50 80 00       	push   $0x8050d0
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
  800103:	e8 d2 2c 00 00       	call   802dda <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 15 2d 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  800142:	68 2c 51 80 00       	push   $0x80512c
  800147:	e8 64 19 00 00       	call   801ab0 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 7c 2c 00 00       	call   802dda <sys_calculate_free_frames>
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
  800195:	68 60 51 80 00       	push   $0x805160
  80019a:	e8 11 19 00 00       	call   801ab0 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 7e 2c 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 d0 51 80 00       	push   $0x8051d0
  8001bb:	e8 f0 18 00 00       	call   801ab0 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 12 2c 00 00       	call   802dda <sys_calculate_free_frames>
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
  8001ff:	e8 d6 2b 00 00       	call   802dda <sys_calculate_free_frames>
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
  800237:	68 04 52 80 00       	push   $0x805204
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
  80027e:	e8 b2 2f 00 00       	call   803235 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 84 52 80 00       	push   $0x805284
  80029e:	e8 0d 18 00 00       	call   801ab0 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 2f 2b 00 00       	call   802dda <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 72 2b 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  8002f2:	68 a8 52 80 00       	push   $0x8052a8
  8002f7:	e8 b4 17 00 00       	call   801ab0 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 cc 2a 00 00       	call   802dda <sys_calculate_free_frames>
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
  800345:	68 dc 52 80 00       	push   $0x8052dc
  80034a:	e8 61 17 00 00       	call   801ab0 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 ce 2a 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 4c 53 80 00       	push   $0x80534c
  80036b:	e8 40 17 00 00       	call   801ab0 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 62 2a 00 00       	call   802dda <sys_calculate_free_frames>
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
  8003b8:	e8 1d 2a 00 00       	call   802dda <sys_calculate_free_frames>
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
  8003f0:	68 80 53 80 00       	push   $0x805380
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
  80043b:	e8 f5 2d 00 00       	call   803235 <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 00 54 80 00       	push   $0x805400
  80045b:	e8 50 16 00 00       	call   801ab0 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 bd 29 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  8004a9:	68 24 54 80 00       	push   $0x805424
  8004ae:	e8 fd 15 00 00       	call   801ab0 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 15 29 00 00       	call   802dda <sys_calculate_free_frames>
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
  8004fc:	68 58 54 80 00       	push   $0x805458
  800501:	e8 aa 15 00 00       	call   801ab0 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 17 29 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 c8 54 80 00       	push   $0x8054c8
  800522:	e8 89 15 00 00       	call   801ab0 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 ab 28 00 00       	call   802dda <sys_calculate_free_frames>
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
  80056d:	e8 68 28 00 00       	call   802dda <sys_calculate_free_frames>
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
  8005a5:	68 fc 54 80 00       	push   $0x8054fc
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
  8005f3:	e8 3d 2c 00 00       	call   803235 <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 7c 55 80 00       	push   $0x80557c
  800613:	e8 98 14 00 00       	call   801ab0 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 05 28 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  800669:	68 a0 55 80 00       	push   $0x8055a0
  80066e:	e8 3d 14 00 00       	call   801ab0 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 aa 27 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 d4 55 80 00       	push   $0x8055d4
  80068f:	e8 1c 14 00 00       	call   801ab0 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 3e 27 00 00       	call   802dda <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 81 27 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  8006f1:	68 08 56 80 00       	push   $0x805608
  8006f6:	e8 b5 13 00 00       	call   801ab0 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 cd 26 00 00       	call   802dda <sys_calculate_free_frames>
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
  800744:	68 3c 56 80 00       	push   $0x80563c
  800749:	e8 62 13 00 00       	call   801ab0 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 cf 26 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 ac 56 80 00       	push   $0x8056ac
  80076a:	e8 41 13 00 00       	call   801ab0 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 63 26 00 00       	call   802dda <sys_calculate_free_frames>
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
  8007fc:	e8 d9 25 00 00       	call   802dda <sys_calculate_free_frames>
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
  800834:	68 e0 56 80 00       	push   $0x8056e0
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
  800888:	e8 a8 29 00 00       	call   803235 <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 60 57 80 00       	push   $0x805760
  8008a8:	e8 03 12 00 00       	call   801ab0 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 25 25 00 00       	call   802dda <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 68 25 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  800909:	68 84 57 80 00       	push   $0x805784
  80090e:	e8 9d 11 00 00       	call   801ab0 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 b5 24 00 00       	call   802dda <sys_calculate_free_frames>
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
  80095c:	68 b8 57 80 00       	push   $0x8057b8
  800961:	e8 4a 11 00 00       	call   801ab0 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 b7 24 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 28 58 80 00       	push   $0x805828
  800982:	e8 29 11 00 00       	call   801ab0 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 4b 24 00 00       	call   802dda <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 8e 24 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 5c 58 80 00       	push   $0x80585c
  8009f1:	e8 ba 10 00 00       	call   801ab0 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 d2 23 00 00       	call   802dda <sys_calculate_free_frames>
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
  800a3f:	68 90 58 80 00       	push   $0x805890
  800a44:	e8 67 10 00 00       	call   801ab0 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 d4 23 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 00 59 80 00       	push   $0x805900
  800a65:	e8 46 10 00 00       	call   801ab0 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 68 23 00 00       	call   802dda <sys_calculate_free_frames>
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
  800ae5:	e8 f0 22 00 00       	call   802dda <sys_calculate_free_frames>
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
  800b1d:	68 34 59 80 00       	push   $0x805934
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
  800ba9:	e8 87 26 00 00       	call   803235 <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 b4 59 80 00       	push   $0x8059b4
  800bc9:	e8 e2 0e 00 00       	call   801ab0 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 04 22 00 00       	call   802dda <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 47 22 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
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
  800c35:	68 d8 59 80 00       	push   $0x8059d8
  800c3a:	e8 71 0e 00 00       	call   801ab0 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 89 21 00 00       	call   802dda <sys_calculate_free_frames>
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
  800c88:	68 0c 5a 80 00       	push   $0x805a0c
  800c8d:	e8 1e 0e 00 00       	call   801ab0 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 8b 21 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 7c 5a 80 00       	push   $0x805a7c
  800cae:	e8 fd 0d 00 00       	call   801ab0 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 1f 21 00 00       	call   802dda <sys_calculate_free_frames>
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
  800d3f:	e8 96 20 00 00       	call   802dda <sys_calculate_free_frames>
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
  800d77:	68 b0 5a 80 00       	push   $0x805ab0
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
  800e09:	e8 27 24 00 00       	call   803235 <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 30 5b 80 00       	push   $0x805b30
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
  800e5e:	68 54 5b 80 00       	push   $0x805b54
  800e63:	e8 48 0c 00 00       	call   801ab0 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 6a 1f 00 00       	call   802dda <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 ad 1f 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 f5 1b 00 00       	call   802a7f <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 93 1f 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 94 5b 80 00       	push   $0x805b94
  800ea6:	e8 05 0c 00 00       	call   801ab0 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 27 1f 00 00       	call   802dda <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 d4 5b 80 00       	push   $0x805bd4
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
  800f1e:	e8 12 23 00 00       	call   803235 <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 24 5c 80 00       	push   $0x805c24
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
  800f5d:	e8 78 1e 00 00       	call   802dda <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 bb 1e 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 03 1b 00 00       	call   802a7f <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 a1 1e 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 4c 5c 80 00       	push   $0x805c4c
  800f98:	e8 13 0b 00 00       	call   801ab0 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 35 1e 00 00       	call   802dda <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 8c 5c 80 00       	push   $0x805c8c
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
  801014:	e8 1c 22 00 00       	call   803235 <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 dc 5c 80 00       	push   $0x805cdc
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
  801053:	e8 82 1d 00 00       	call   802dda <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 c5 1d 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 0d 1a 00 00       	call   802a7f <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 ab 1d 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 04 5d 80 00       	push   $0x805d04
  80108e:	e8 1d 0a 00 00       	call   801ab0 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 3f 1d 00 00       	call   802dda <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 44 5d 80 00       	push   $0x805d44
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
  80113f:	e8 f1 20 00 00       	call   803235 <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 94 5d 80 00       	push   $0x805d94
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
  80117e:	e8 57 1c 00 00       	call   802dda <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 9a 1c 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 e2 18 00 00       	call   802a7f <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 80 1c 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 bc 5d 80 00       	push   $0x805dbc
  8011b9:	e8 f2 08 00 00       	call   801ab0 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 14 1c 00 00       	call   802dda <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 fc 5d 80 00       	push   $0x805dfc
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
  801238:	e8 f8 1f 00 00       	call   803235 <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 4c 5e 80 00       	push   $0x805e4c
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
  801277:	e8 5e 1b 00 00       	call   802dda <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 a1 1b 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 e9 17 00 00       	call   802a7f <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 87 1b 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 74 5e 80 00       	push   $0x805e74
  8012b2:	e8 f9 07 00 00       	call   801ab0 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 1b 1b 00 00       	call   802dda <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 b4 5e 80 00       	push   $0x805eb4
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
  8012f0:	e8 e5 1a 00 00       	call   802dda <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 28 1b 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 70 17 00 00       	call   802a7f <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 0e 1b 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 f8 5e 80 00       	push   $0x805ef8
  80132b:	e8 80 07 00 00       	call   801ab0 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 a2 1a 00 00       	call   802dda <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 38 5f 80 00       	push   $0x805f38
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
  8013aa:	e8 86 1e 00 00       	call   803235 <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 88 5f 80 00       	push   $0x805f88
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
  8013e9:	e8 ec 19 00 00       	call   802dda <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 2f 1a 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 77 16 00 00       	call   802a7f <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 15 1a 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 b0 5f 80 00       	push   $0x805fb0
  801424:	e8 87 06 00 00       	call   801ab0 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 a9 19 00 00       	call   802dda <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 f0 5f 80 00       	push   $0x805ff0
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
  801462:	e8 73 19 00 00       	call   802dda <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 b6 19 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 fe 15 00 00       	call   802a7f <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 9c 19 00 00       	call   802e25 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 40 60 80 00       	push   $0x806040
  80149d:	e8 0e 06 00 00       	call   801ab0 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 30 19 00 00       	call   802dda <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 80 60 80 00       	push   $0x806080
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
  801554:	e8 dc 1c 00 00       	call   803235 <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 d0 60 80 00       	push   $0x8060d0
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
  80159d:	68 f8 60 80 00       	push   $0x8060f8
  8015a2:	e8 09 05 00 00       	call   801ab0 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 d2 1a 00 00       	call   803081 <rsttst>
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
  8015d5:	68 66 61 80 00       	push   $0x806166
  8015da:	e8 56 19 00 00       	call   802f35 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 5d 19 00 00       	call   802f53 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 fc 1a 00 00       	call   8030fb <gettst>
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
  80162a:	68 71 61 80 00       	push   $0x806171
  80162f:	e8 01 19 00 00       	call   802f35 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 08 19 00 00       	call   802f53 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 a7 1a 00 00       	call   8030fb <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 83 1a 00 00       	call   8030e1 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 11 37 00 00       	call   804d7c <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 88 1a 00 00       	call   8030fb <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 7c 61 80 00       	push   $0x80617c
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
  80169f:	68 0c 62 80 00       	push   $0x80620c
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
  8016ba:	e8 e4 18 00 00       	call   802fa3 <sys_getenvindex>
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
  801728:	e8 fa 15 00 00       	call   802d27 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	68 60 62 80 00       	push   $0x806260
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
  801758:	68 88 62 80 00       	push   $0x806288
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
  801789:	68 b0 62 80 00       	push   $0x8062b0
  80178e:	e8 1d 03 00 00       	call   801ab0 <cprintf>
  801793:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801796:	a1 20 70 80 00       	mov    0x807020,%eax
  80179b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 08 63 80 00       	push   $0x806308
  8017aa:	e8 01 03 00 00       	call   801ab0 <cprintf>
  8017af:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	68 60 62 80 00       	push   $0x806260
  8017ba:	e8 f1 02 00 00       	call   801ab0 <cprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8017c2:	e8 7a 15 00 00       	call   802d41 <sys_unlock_cons>
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
  8017da:	e8 90 17 00 00       	call   802f6f <sys_destroy_env>
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
  8017eb:	e8 e5 17 00 00       	call   802fd5 <sys_exit_env>
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
  801814:	68 1c 63 80 00       	push   $0x80631c
  801819:	e8 92 02 00 00       	call   801ab0 <cprintf>
  80181e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801821:	a1 00 70 80 00       	mov    0x807000,%eax
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	50                   	push   %eax
  80182d:	68 21 63 80 00       	push   $0x806321
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
  801851:	68 3d 63 80 00       	push   $0x80633d
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
  801880:	68 40 63 80 00       	push   $0x806340
  801885:	6a 26                	push   $0x26
  801887:	68 8c 63 80 00       	push   $0x80638c
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
  801955:	68 98 63 80 00       	push   $0x806398
  80195a:	6a 3a                	push   $0x3a
  80195c:	68 8c 63 80 00       	push   $0x80638c
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
  8019c8:	68 ec 63 80 00       	push   $0x8063ec
  8019cd:	6a 44                	push   $0x44
  8019cf:	68 8c 63 80 00       	push   $0x80638c
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
  801a22:	e8 be 12 00 00       	call   802ce5 <sys_cputs>
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
  801a99:	e8 47 12 00 00       	call   802ce5 <sys_cputs>
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
  801ae3:	e8 3f 12 00 00       	call   802d27 <sys_lock_cons>
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
  801b03:	e8 39 12 00 00       	call   802d41 <sys_unlock_cons>
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
  801b4d:	e8 de 32 00 00       	call   804e30 <__udivdi3>
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
  801b9d:	e8 9e 33 00 00       	call   804f40 <__umoddi3>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	05 54 66 80 00       	add    $0x806654,%eax
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
  801cf8:	8b 04 85 78 66 80 00 	mov    0x806678(,%eax,4),%eax
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
  801dd9:	8b 34 9d c0 64 80 00 	mov    0x8064c0(,%ebx,4),%esi
  801de0:	85 f6                	test   %esi,%esi
  801de2:	75 19                	jne    801dfd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de4:	53                   	push   %ebx
  801de5:	68 65 66 80 00       	push   $0x806665
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
  801dfe:	68 6e 66 80 00       	push   $0x80666e
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
  801e2b:	be 71 66 80 00       	mov    $0x806671,%esi
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
  802836:	68 e8 67 80 00       	push   $0x8067e8
  80283b:	68 3f 01 00 00       	push   $0x13f
  802840:	68 0a 68 80 00       	push   $0x80680a
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
  802856:	e8 35 0a 00 00       	call   803290 <sys_sbrk>
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
  8028d1:	e8 3e 08 00 00       	call   803114 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 16                	je     8028f0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 7e 0d 00 00       	call   803663 <alloc_block_FF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	e9 8a 01 00 00       	jmp    802a7a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8028f0:	e8 50 08 00 00       	call   803145 <sys_isUHeapPlacementStrategyBESTFIT>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	0f 84 7d 01 00 00    	je     802a7a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	e8 17 12 00 00       	call   803b1f <alloc_block_BF>
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
  802953:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
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
  8029a0:	8b 04 85 60 70 80 00 	mov    0x807060(,%eax,4),%eax
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
  8029f7:	c7 04 85 60 70 80 00 	movl   $0x1,0x807060(,%eax,4)
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
  802a59:	89 04 95 60 70 88 00 	mov    %eax,0x887060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802a60:	83 ec 08             	sub    $0x8,%esp
  802a63:	ff 75 08             	pushl  0x8(%ebp)
  802a66:	ff 75 f0             	pushl  -0x10(%ebp)
  802a69:	e8 59 08 00 00       	call   8032c7 <sys_allocate_user_mem>
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
  802ab1:	e8 2d 08 00 00       	call   8032e3 <get_block_size>
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 60 1a 00 00       	call   804527 <free_block>
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
  802afc:	8b 04 85 60 70 88 00 	mov    0x887060(,%eax,4),%eax
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
  802b39:	c7 04 85 60 70 80 00 	movl   $0x0,0x807060(,%eax,4)
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
  802b59:	e8 4d 07 00 00       	call   8032ab <sys_free_user_mem>
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
  802b67:	68 18 68 80 00       	push   $0x806818
  802b6c:	68 84 00 00 00       	push   $0x84
  802b71:	68 42 68 80 00       	push   $0x806842
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
  802b8d:	75 07                	jne    802b96 <smalloc+0x19>
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	eb 74                	jmp    802c0a <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	39 d0                	cmp    %edx,%eax
  802bab:	73 02                	jae    802baf <smalloc+0x32>
  802bad:	89 d0                	mov    %edx,%eax
  802baf:	83 ec 0c             	sub    $0xc,%esp
  802bb2:	50                   	push   %eax
  802bb3:	e8 a8 fc ff ff       	call   802860 <malloc>
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802bbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc2:	75 07                	jne    802bcb <smalloc+0x4e>
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	eb 3f                	jmp    802c0a <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802bcb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802bcf:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd2:	50                   	push   %eax
  802bd3:	ff 75 0c             	pushl  0xc(%ebp)
  802bd6:	ff 75 08             	pushl  0x8(%ebp)
  802bd9:	e8 d4 02 00 00       	call   802eb2 <sys_createSharedObject>
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802be4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802be8:	74 06                	je     802bf0 <smalloc+0x73>
  802bea:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802bee:	75 07                	jne    802bf7 <smalloc+0x7a>
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf5:	eb 13                	jmp    802c0a <smalloc+0x8d>
	 cprintf("153\n");
  802bf7:	83 ec 0c             	sub    $0xc,%esp
  802bfa:	68 4e 68 80 00       	push   $0x80684e
  802bff:	e8 ac ee ff ff       	call   801ab0 <cprintf>
  802c04:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
  802c0f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 54 68 80 00       	push   $0x806854
  802c1a:	68 a4 00 00 00       	push   $0xa4
  802c1f:	68 42 68 80 00       	push   $0x806842
  802c24:	e8 ca eb ff ff       	call   8017f3 <_panic>

00802c29 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	68 78 68 80 00       	push   $0x806878
  802c37:	68 bc 00 00 00       	push   $0xbc
  802c3c:	68 42 68 80 00       	push   $0x806842
  802c41:	e8 ad eb ff ff       	call   8017f3 <_panic>

00802c46 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c46:	55                   	push   %ebp
  802c47:	89 e5                	mov    %esp,%ebp
  802c49:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 9c 68 80 00       	push   $0x80689c
  802c54:	68 d3 00 00 00       	push   $0xd3
  802c59:	68 42 68 80 00       	push   $0x806842
  802c5e:	e8 90 eb ff ff       	call   8017f3 <_panic>

00802c63 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802c63:	55                   	push   %ebp
  802c64:	89 e5                	mov    %esp,%ebp
  802c66:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 c2 68 80 00       	push   $0x8068c2
  802c71:	68 df 00 00 00       	push   $0xdf
  802c76:	68 42 68 80 00       	push   $0x806842
  802c7b:	e8 73 eb ff ff       	call   8017f3 <_panic>

00802c80 <shrink>:

}
void shrink(uint32 newSize)
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	68 c2 68 80 00       	push   $0x8068c2
  802c8e:	68 e4 00 00 00       	push   $0xe4
  802c93:	68 42 68 80 00       	push   $0x806842
  802c98:	e8 56 eb ff ff       	call   8017f3 <_panic>

00802c9d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802c9d:	55                   	push   %ebp
  802c9e:	89 e5                	mov    %esp,%ebp
  802ca0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802ca3:	83 ec 04             	sub    $0x4,%esp
  802ca6:	68 c2 68 80 00       	push   $0x8068c2
  802cab:	68 e9 00 00 00       	push   $0xe9
  802cb0:	68 42 68 80 00       	push   $0x806842
  802cb5:	e8 39 eb ff ff       	call   8017f3 <_panic>

00802cba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
  802cbd:	57                   	push   %edi
  802cbe:	56                   	push   %esi
  802cbf:	53                   	push   %ebx
  802cc0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ccc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ccf:	8b 7d 18             	mov    0x18(%ebp),%edi
  802cd2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802cd5:	cd 30                	int    $0x30
  802cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802cdd:	83 c4 10             	add    $0x10,%esp
  802ce0:	5b                   	pop    %ebx
  802ce1:	5e                   	pop    %esi
  802ce2:	5f                   	pop    %edi
  802ce3:	5d                   	pop    %ebp
  802ce4:	c3                   	ret    

00802ce5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  802cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802cf1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 00                	push   $0x0
  802cfc:	52                   	push   %edx
  802cfd:	ff 75 0c             	pushl  0xc(%ebp)
  802d00:	50                   	push   %eax
  802d01:	6a 00                	push   $0x0
  802d03:	e8 b2 ff ff ff       	call   802cba <syscall>
  802d08:	83 c4 18             	add    $0x18,%esp
}
  802d0b:	90                   	nop
  802d0c:	c9                   	leave  
  802d0d:	c3                   	ret    

00802d0e <sys_cgetc>:

int
sys_cgetc(void)
{
  802d0e:	55                   	push   %ebp
  802d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 02                	push   $0x2
  802d1d:	e8 98 ff ff ff       	call   802cba <syscall>
  802d22:	83 c4 18             	add    $0x18,%esp
}
  802d25:	c9                   	leave  
  802d26:	c3                   	ret    

00802d27 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 00                	push   $0x0
  802d2e:	6a 00                	push   $0x0
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	6a 03                	push   $0x3
  802d36:	e8 7f ff ff ff       	call   802cba <syscall>
  802d3b:	83 c4 18             	add    $0x18,%esp
}
  802d3e:	90                   	nop
  802d3f:	c9                   	leave  
  802d40:	c3                   	ret    

00802d41 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d41:	55                   	push   %ebp
  802d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d44:	6a 00                	push   $0x0
  802d46:	6a 00                	push   $0x0
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 04                	push   $0x4
  802d50:	e8 65 ff ff ff       	call   802cba <syscall>
  802d55:	83 c4 18             	add    $0x18,%esp
}
  802d58:	90                   	nop
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	6a 00                	push   $0x0
  802d6a:	52                   	push   %edx
  802d6b:	50                   	push   %eax
  802d6c:	6a 08                	push   $0x8
  802d6e:	e8 47 ff ff ff       	call   802cba <syscall>
  802d73:	83 c4 18             	add    $0x18,%esp
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
  802d7b:	56                   	push   %esi
  802d7c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d7d:	8b 75 18             	mov    0x18(%ebp),%esi
  802d80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	56                   	push   %esi
  802d8d:	53                   	push   %ebx
  802d8e:	51                   	push   %ecx
  802d8f:	52                   	push   %edx
  802d90:	50                   	push   %eax
  802d91:	6a 09                	push   $0x9
  802d93:	e8 22 ff ff ff       	call   802cba <syscall>
  802d98:	83 c4 18             	add    $0x18,%esp
}
  802d9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d9e:	5b                   	pop    %ebx
  802d9f:	5e                   	pop    %esi
  802da0:	5d                   	pop    %ebp
  802da1:	c3                   	ret    

00802da2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802da2:	55                   	push   %ebp
  802da3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	6a 00                	push   $0x0
  802db1:	52                   	push   %edx
  802db2:	50                   	push   %eax
  802db3:	6a 0a                	push   $0xa
  802db5:	e8 00 ff ff ff       	call   802cba <syscall>
  802dba:	83 c4 18             	add    $0x18,%esp
}
  802dbd:	c9                   	leave  
  802dbe:	c3                   	ret    

00802dbf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	ff 75 0c             	pushl  0xc(%ebp)
  802dcb:	ff 75 08             	pushl  0x8(%ebp)
  802dce:	6a 0b                	push   $0xb
  802dd0:	e8 e5 fe ff ff       	call   802cba <syscall>
  802dd5:	83 c4 18             	add    $0x18,%esp
}
  802dd8:	c9                   	leave  
  802dd9:	c3                   	ret    

00802dda <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802dda:	55                   	push   %ebp
  802ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 00                	push   $0x0
  802de1:	6a 00                	push   $0x0
  802de3:	6a 00                	push   $0x0
  802de5:	6a 00                	push   $0x0
  802de7:	6a 0c                	push   $0xc
  802de9:	e8 cc fe ff ff       	call   802cba <syscall>
  802dee:	83 c4 18             	add    $0x18,%esp
}
  802df1:	c9                   	leave  
  802df2:	c3                   	ret    

00802df3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 0d                	push   $0xd
  802e02:	e8 b3 fe ff ff       	call   802cba <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 0e                	push   $0xe
  802e1b:	e8 9a fe ff ff       	call   802cba <syscall>
  802e20:	83 c4 18             	add    $0x18,%esp
}
  802e23:	c9                   	leave  
  802e24:	c3                   	ret    

00802e25 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e25:	55                   	push   %ebp
  802e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 0f                	push   $0xf
  802e34:	e8 81 fe ff ff       	call   802cba <syscall>
  802e39:	83 c4 18             	add    $0x18,%esp
}
  802e3c:	c9                   	leave  
  802e3d:	c3                   	ret    

00802e3e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e3e:	55                   	push   %ebp
  802e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	6a 00                	push   $0x0
  802e49:	ff 75 08             	pushl  0x8(%ebp)
  802e4c:	6a 10                	push   $0x10
  802e4e:	e8 67 fe ff ff       	call   802cba <syscall>
  802e53:	83 c4 18             	add    $0x18,%esp
}
  802e56:	c9                   	leave  
  802e57:	c3                   	ret    

00802e58 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 11                	push   $0x11
  802e67:	e8 4e fe ff ff       	call   802cba <syscall>
  802e6c:	83 c4 18             	add    $0x18,%esp
}
  802e6f:	90                   	nop
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    

00802e72 <sys_cputc>:

void
sys_cputc(const char c)
{
  802e72:	55                   	push   %ebp
  802e73:	89 e5                	mov    %esp,%ebp
  802e75:	83 ec 04             	sub    $0x4,%esp
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 00                	push   $0x0
  802e88:	6a 00                	push   $0x0
  802e8a:	50                   	push   %eax
  802e8b:	6a 01                	push   $0x1
  802e8d:	e8 28 fe ff ff       	call   802cba <syscall>
  802e92:	83 c4 18             	add    $0x18,%esp
}
  802e95:	90                   	nop
  802e96:	c9                   	leave  
  802e97:	c3                   	ret    

00802e98 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802e98:	55                   	push   %ebp
  802e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 14                	push   $0x14
  802ea7:	e8 0e fe ff ff       	call   802cba <syscall>
  802eac:	83 c4 18             	add    $0x18,%esp
}
  802eaf:	90                   	nop
  802eb0:	c9                   	leave  
  802eb1:	c3                   	ret    

00802eb2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802eb2:	55                   	push   %ebp
  802eb3:	89 e5                	mov    %esp,%ebp
  802eb5:	83 ec 04             	sub    $0x4,%esp
  802eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ebb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ebe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ec1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	6a 00                	push   $0x0
  802eca:	51                   	push   %ecx
  802ecb:	52                   	push   %edx
  802ecc:	ff 75 0c             	pushl  0xc(%ebp)
  802ecf:	50                   	push   %eax
  802ed0:	6a 15                	push   $0x15
  802ed2:	e8 e3 fd ff ff       	call   802cba <syscall>
  802ed7:	83 c4 18             	add    $0x18,%esp
}
  802eda:	c9                   	leave  
  802edb:	c3                   	ret    

00802edc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	52                   	push   %edx
  802eec:	50                   	push   %eax
  802eed:	6a 16                	push   $0x16
  802eef:	e8 c6 fd ff ff       	call   802cba <syscall>
  802ef4:	83 c4 18             	add    $0x18,%esp
}
  802ef7:	c9                   	leave  
  802ef8:	c3                   	ret    

00802ef9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802efc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	51                   	push   %ecx
  802f0a:	52                   	push   %edx
  802f0b:	50                   	push   %eax
  802f0c:	6a 17                	push   $0x17
  802f0e:	e8 a7 fd ff ff       	call   802cba <syscall>
  802f13:	83 c4 18             	add    $0x18,%esp
}
  802f16:	c9                   	leave  
  802f17:	c3                   	ret    

00802f18 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802f18:	55                   	push   %ebp
  802f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	52                   	push   %edx
  802f28:	50                   	push   %eax
  802f29:	6a 18                	push   $0x18
  802f2b:	e8 8a fd ff ff       	call   802cba <syscall>
  802f30:	83 c4 18             	add    $0x18,%esp
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	6a 00                	push   $0x0
  802f3d:	ff 75 14             	pushl  0x14(%ebp)
  802f40:	ff 75 10             	pushl  0x10(%ebp)
  802f43:	ff 75 0c             	pushl  0xc(%ebp)
  802f46:	50                   	push   %eax
  802f47:	6a 19                	push   $0x19
  802f49:	e8 6c fd ff ff       	call   802cba <syscall>
  802f4e:	83 c4 18             	add    $0x18,%esp
}
  802f51:	c9                   	leave  
  802f52:	c3                   	ret    

00802f53 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f53:	55                   	push   %ebp
  802f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	50                   	push   %eax
  802f62:	6a 1a                	push   $0x1a
  802f64:	e8 51 fd ff ff       	call   802cba <syscall>
  802f69:	83 c4 18             	add    $0x18,%esp
}
  802f6c:	90                   	nop
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	6a 00                	push   $0x0
  802f77:	6a 00                	push   $0x0
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	50                   	push   %eax
  802f7e:	6a 1b                	push   $0x1b
  802f80:	e8 35 fd ff ff       	call   802cba <syscall>
  802f85:	83 c4 18             	add    $0x18,%esp
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 05                	push   $0x5
  802f99:	e8 1c fd ff ff       	call   802cba <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 06                	push   $0x6
  802fb2:	e8 03 fd ff ff       	call   802cba <syscall>
  802fb7:	83 c4 18             	add    $0x18,%esp
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 07                	push   $0x7
  802fcb:	e8 ea fc ff ff       	call   802cba <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_exit_env>:


void sys_exit_env(void)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 1c                	push   $0x1c
  802fe4:	e8 d1 fc ff ff       	call   802cba <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	90                   	nop
  802fed:	c9                   	leave  
  802fee:	c3                   	ret    

00802fef <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802fef:	55                   	push   %ebp
  802ff0:	89 e5                	mov    %esp,%ebp
  802ff2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ff5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ff8:	8d 50 04             	lea    0x4(%eax),%edx
  802ffb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	52                   	push   %edx
  803005:	50                   	push   %eax
  803006:	6a 1d                	push   $0x1d
  803008:	e8 ad fc ff ff       	call   802cba <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
	return result;
  803010:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803019:	89 01                	mov    %eax,(%ecx)
  80301b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	c9                   	leave  
  803022:	c2 04 00             	ret    $0x4

00803025 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	ff 75 10             	pushl  0x10(%ebp)
  80302f:	ff 75 0c             	pushl  0xc(%ebp)
  803032:	ff 75 08             	pushl  0x8(%ebp)
  803035:	6a 13                	push   $0x13
  803037:	e8 7e fc ff ff       	call   802cba <syscall>
  80303c:	83 c4 18             	add    $0x18,%esp
	return ;
  80303f:	90                   	nop
}
  803040:	c9                   	leave  
  803041:	c3                   	ret    

00803042 <sys_rcr2>:
uint32 sys_rcr2()
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	6a 1e                	push   $0x1e
  803051:	e8 64 fc ff ff       	call   802cba <syscall>
  803056:	83 c4 18             	add    $0x18,%esp
}
  803059:	c9                   	leave  
  80305a:	c3                   	ret    

0080305b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803067:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	6a 00                	push   $0x0
  803073:	50                   	push   %eax
  803074:	6a 1f                	push   $0x1f
  803076:	e8 3f fc ff ff       	call   802cba <syscall>
  80307b:	83 c4 18             	add    $0x18,%esp
	return ;
  80307e:	90                   	nop
}
  80307f:	c9                   	leave  
  803080:	c3                   	ret    

00803081 <rsttst>:
void rsttst()
{
  803081:	55                   	push   %ebp
  803082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 21                	push   $0x21
  803090:	e8 25 fc ff ff       	call   802cba <syscall>
  803095:	83 c4 18             	add    $0x18,%esp
	return ;
  803098:	90                   	nop
}
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8030a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030a7:	8b 55 18             	mov    0x18(%ebp),%edx
  8030aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030ae:	52                   	push   %edx
  8030af:	50                   	push   %eax
  8030b0:	ff 75 10             	pushl  0x10(%ebp)
  8030b3:	ff 75 0c             	pushl  0xc(%ebp)
  8030b6:	ff 75 08             	pushl  0x8(%ebp)
  8030b9:	6a 20                	push   $0x20
  8030bb:	e8 fa fb ff ff       	call   802cba <syscall>
  8030c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8030c3:	90                   	nop
}
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    

008030c6 <chktst>:
void chktst(uint32 n)
{
  8030c6:	55                   	push   %ebp
  8030c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	6a 00                	push   $0x0
  8030cf:	6a 00                	push   $0x0
  8030d1:	ff 75 08             	pushl  0x8(%ebp)
  8030d4:	6a 22                	push   $0x22
  8030d6:	e8 df fb ff ff       	call   802cba <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
	return ;
  8030de:	90                   	nop
}
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <inctst>:

void inctst()
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 23                	push   $0x23
  8030f0:	e8 c5 fb ff ff       	call   802cba <syscall>
  8030f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f8:	90                   	nop
}
  8030f9:	c9                   	leave  
  8030fa:	c3                   	ret    

008030fb <gettst>:
uint32 gettst()
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 24                	push   $0x24
  80310a:	e8 ab fb ff ff       	call   802cba <syscall>
  80310f:	83 c4 18             	add    $0x18,%esp
}
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
  803117:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	6a 00                	push   $0x0
  803122:	6a 00                	push   $0x0
  803124:	6a 25                	push   $0x25
  803126:	e8 8f fb ff ff       	call   802cba <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
  80312e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803131:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803135:	75 07                	jne    80313e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803137:	b8 01 00 00 00       	mov    $0x1,%eax
  80313c:	eb 05                	jmp    803143 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80313e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803143:	c9                   	leave  
  803144:	c3                   	ret    

00803145 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803145:	55                   	push   %ebp
  803146:	89 e5                	mov    %esp,%ebp
  803148:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	6a 00                	push   $0x0
  803155:	6a 25                	push   $0x25
  803157:	e8 5e fb ff ff       	call   802cba <syscall>
  80315c:	83 c4 18             	add    $0x18,%esp
  80315f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803162:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803166:	75 07                	jne    80316f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803168:	b8 01 00 00 00       	mov    $0x1,%eax
  80316d:	eb 05                	jmp    803174 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80316f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803174:	c9                   	leave  
  803175:	c3                   	ret    

00803176 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803176:	55                   	push   %ebp
  803177:	89 e5                	mov    %esp,%ebp
  803179:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80317c:	6a 00                	push   $0x0
  80317e:	6a 00                	push   $0x0
  803180:	6a 00                	push   $0x0
  803182:	6a 00                	push   $0x0
  803184:	6a 00                	push   $0x0
  803186:	6a 25                	push   $0x25
  803188:	e8 2d fb ff ff       	call   802cba <syscall>
  80318d:	83 c4 18             	add    $0x18,%esp
  803190:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803193:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803197:	75 07                	jne    8031a0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803199:	b8 01 00 00 00       	mov    $0x1,%eax
  80319e:	eb 05                	jmp    8031a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a5:	c9                   	leave  
  8031a6:	c3                   	ret    

008031a7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8031a7:	55                   	push   %ebp
  8031a8:	89 e5                	mov    %esp,%ebp
  8031aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 00                	push   $0x0
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 25                	push   $0x25
  8031b9:	e8 fc fa ff ff       	call   802cba <syscall>
  8031be:	83 c4 18             	add    $0x18,%esp
  8031c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8031c4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8031c8:	75 07                	jne    8031d1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8031ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8031cf:	eb 05                	jmp    8031d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8031d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d6:	c9                   	leave  
  8031d7:	c3                   	ret    

008031d8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8031d8:	55                   	push   %ebp
  8031d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8031db:	6a 00                	push   $0x0
  8031dd:	6a 00                	push   $0x0
  8031df:	6a 00                	push   $0x0
  8031e1:	6a 00                	push   $0x0
  8031e3:	ff 75 08             	pushl  0x8(%ebp)
  8031e6:	6a 26                	push   $0x26
  8031e8:	e8 cd fa ff ff       	call   802cba <syscall>
  8031ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f0:	90                   	nop
}
  8031f1:	c9                   	leave  
  8031f2:	c3                   	ret    

008031f3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031f3:	55                   	push   %ebp
  8031f4:	89 e5                	mov    %esp,%ebp
  8031f6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	6a 00                	push   $0x0
  803205:	53                   	push   %ebx
  803206:	51                   	push   %ecx
  803207:	52                   	push   %edx
  803208:	50                   	push   %eax
  803209:	6a 27                	push   $0x27
  80320b:	e8 aa fa ff ff       	call   802cba <syscall>
  803210:	83 c4 18             	add    $0x18,%esp
}
  803213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803216:	c9                   	leave  
  803217:	c3                   	ret    

00803218 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803218:	55                   	push   %ebp
  803219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80321b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	52                   	push   %edx
  803228:	50                   	push   %eax
  803229:	6a 28                	push   $0x28
  80322b:	e8 8a fa ff ff       	call   802cba <syscall>
  803230:	83 c4 18             	add    $0x18,%esp
}
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803238:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80323b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	6a 00                	push   $0x0
  803243:	51                   	push   %ecx
  803244:	ff 75 10             	pushl  0x10(%ebp)
  803247:	52                   	push   %edx
  803248:	50                   	push   %eax
  803249:	6a 29                	push   $0x29
  80324b:	e8 6a fa ff ff       	call   802cba <syscall>
  803250:	83 c4 18             	add    $0x18,%esp
}
  803253:	c9                   	leave  
  803254:	c3                   	ret    

00803255 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803255:	55                   	push   %ebp
  803256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803258:	6a 00                	push   $0x0
  80325a:	6a 00                	push   $0x0
  80325c:	ff 75 10             	pushl  0x10(%ebp)
  80325f:	ff 75 0c             	pushl  0xc(%ebp)
  803262:	ff 75 08             	pushl  0x8(%ebp)
  803265:	6a 12                	push   $0x12
  803267:	e8 4e fa ff ff       	call   802cba <syscall>
  80326c:	83 c4 18             	add    $0x18,%esp
	return ;
  80326f:	90                   	nop
}
  803270:	c9                   	leave  
  803271:	c3                   	ret    

00803272 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803272:	55                   	push   %ebp
  803273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803275:	8b 55 0c             	mov    0xc(%ebp),%edx
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	6a 00                	push   $0x0
  803281:	52                   	push   %edx
  803282:	50                   	push   %eax
  803283:	6a 2a                	push   $0x2a
  803285:	e8 30 fa ff ff       	call   802cba <syscall>
  80328a:	83 c4 18             	add    $0x18,%esp
	return;
  80328d:	90                   	nop
}
  80328e:	c9                   	leave  
  80328f:	c3                   	ret    

00803290 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803290:	55                   	push   %ebp
  803291:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	50                   	push   %eax
  80329f:	6a 2b                	push   $0x2b
  8032a1:	e8 14 fa ff ff       	call   802cba <syscall>
  8032a6:	83 c4 18             	add    $0x18,%esp
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	ff 75 0c             	pushl  0xc(%ebp)
  8032b7:	ff 75 08             	pushl  0x8(%ebp)
  8032ba:	6a 2c                	push   $0x2c
  8032bc:	e8 f9 f9 ff ff       	call   802cba <syscall>
  8032c1:	83 c4 18             	add    $0x18,%esp
	return;
  8032c4:	90                   	nop
}
  8032c5:	c9                   	leave  
  8032c6:	c3                   	ret    

008032c7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8032c7:	55                   	push   %ebp
  8032c8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	ff 75 0c             	pushl  0xc(%ebp)
  8032d3:	ff 75 08             	pushl  0x8(%ebp)
  8032d6:	6a 2d                	push   $0x2d
  8032d8:	e8 dd f9 ff ff       	call   802cba <syscall>
  8032dd:	83 c4 18             	add    $0x18,%esp
	return;
  8032e0:	90                   	nop
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	83 e8 04             	sub    $0x4,%eax
  8032ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8032f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8032fa:	c9                   	leave  
  8032fb:	c3                   	ret    

008032fc <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8032fc:	55                   	push   %ebp
  8032fd:	89 e5                	mov    %esp,%ebp
  8032ff:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	83 e8 04             	sub    $0x4,%eax
  803308:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80330b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	83 e0 01             	and    $0x1,%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	0f 94 c0             	sete   %al
}
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
  80331d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  803327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332a:	83 f8 02             	cmp    $0x2,%eax
  80332d:	74 2b                	je     80335a <alloc_block+0x40>
  80332f:	83 f8 02             	cmp    $0x2,%eax
  803332:	7f 07                	jg     80333b <alloc_block+0x21>
  803334:	83 f8 01             	cmp    $0x1,%eax
  803337:	74 0e                	je     803347 <alloc_block+0x2d>
  803339:	eb 58                	jmp    803393 <alloc_block+0x79>
  80333b:	83 f8 03             	cmp    $0x3,%eax
  80333e:	74 2d                	je     80336d <alloc_block+0x53>
  803340:	83 f8 04             	cmp    $0x4,%eax
  803343:	74 3b                	je     803380 <alloc_block+0x66>
  803345:	eb 4c                	jmp    803393 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  803347:	83 ec 0c             	sub    $0xc,%esp
  80334a:	ff 75 08             	pushl  0x8(%ebp)
  80334d:	e8 11 03 00 00       	call   803663 <alloc_block_FF>
  803352:	83 c4 10             	add    $0x10,%esp
  803355:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803358:	eb 4a                	jmp    8033a4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80335a:	83 ec 0c             	sub    $0xc,%esp
  80335d:	ff 75 08             	pushl  0x8(%ebp)
  803360:	e8 fa 19 00 00       	call   804d5f <alloc_block_NF>
  803365:	83 c4 10             	add    $0x10,%esp
  803368:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80336b:	eb 37                	jmp    8033a4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80336d:	83 ec 0c             	sub    $0xc,%esp
  803370:	ff 75 08             	pushl  0x8(%ebp)
  803373:	e8 a7 07 00 00       	call   803b1f <alloc_block_BF>
  803378:	83 c4 10             	add    $0x10,%esp
  80337b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80337e:	eb 24                	jmp    8033a4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803380:	83 ec 0c             	sub    $0xc,%esp
  803383:	ff 75 08             	pushl  0x8(%ebp)
  803386:	e8 b7 19 00 00       	call   804d42 <alloc_block_WF>
  80338b:	83 c4 10             	add    $0x10,%esp
  80338e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803391:	eb 11                	jmp    8033a4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803393:	83 ec 0c             	sub    $0xc,%esp
  803396:	68 d4 68 80 00       	push   $0x8068d4
  80339b:	e8 10 e7 ff ff       	call   801ab0 <cprintf>
  8033a0:	83 c4 10             	add    $0x10,%esp
		break;
  8033a3:	90                   	nop
	}
	return va;
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8033a7:	c9                   	leave  
  8033a8:	c3                   	ret    

008033a9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8033a9:	55                   	push   %ebp
  8033aa:	89 e5                	mov    %esp,%ebp
  8033ac:	53                   	push   %ebx
  8033ad:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8033b0:	83 ec 0c             	sub    $0xc,%esp
  8033b3:	68 f4 68 80 00       	push   $0x8068f4
  8033b8:	e8 f3 e6 ff ff       	call   801ab0 <cprintf>
  8033bd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8033c0:	83 ec 0c             	sub    $0xc,%esp
  8033c3:	68 1f 69 80 00       	push   $0x80691f
  8033c8:	e8 e3 e6 ff ff       	call   801ab0 <cprintf>
  8033cd:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d6:	eb 37                	jmp    80340f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8033d8:	83 ec 0c             	sub    $0xc,%esp
  8033db:	ff 75 f4             	pushl  -0xc(%ebp)
  8033de:	e8 19 ff ff ff       	call   8032fc <is_free_block>
  8033e3:	83 c4 10             	add    $0x10,%esp
  8033e6:	0f be d8             	movsbl %al,%ebx
  8033e9:	83 ec 0c             	sub    $0xc,%esp
  8033ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8033ef:	e8 ef fe ff ff       	call   8032e3 <get_block_size>
  8033f4:	83 c4 10             	add    $0x10,%esp
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	53                   	push   %ebx
  8033fb:	50                   	push   %eax
  8033fc:	68 37 69 80 00       	push   $0x806937
  803401:	e8 aa e6 ff ff       	call   801ab0 <cprintf>
  803406:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803409:	8b 45 10             	mov    0x10(%ebp),%eax
  80340c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803413:	74 07                	je     80341c <print_blocks_list+0x73>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	eb 05                	jmp    803421 <print_blocks_list+0x78>
  80341c:	b8 00 00 00 00       	mov    $0x0,%eax
  803421:	89 45 10             	mov    %eax,0x10(%ebp)
  803424:	8b 45 10             	mov    0x10(%ebp),%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	75 ad                	jne    8033d8 <print_blocks_list+0x2f>
  80342b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342f:	75 a7                	jne    8033d8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803431:	83 ec 0c             	sub    $0xc,%esp
  803434:	68 f4 68 80 00       	push   $0x8068f4
  803439:	e8 72 e6 ff ff       	call   801ab0 <cprintf>
  80343e:	83 c4 10             	add    $0x10,%esp

}
  803441:	90                   	nop
  803442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803445:	c9                   	leave  
  803446:	c3                   	ret    

00803447 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  803447:	55                   	push   %ebp
  803448:	89 e5                	mov    %esp,%ebp
  80344a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80344d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803450:	83 e0 01             	and    $0x1,%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 03                	je     80345a <initialize_dynamic_allocator+0x13>
  803457:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80345a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80345e:	0f 84 c7 01 00 00    	je     80362b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  803464:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  80346b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80346e:	8b 55 08             	mov    0x8(%ebp),%edx
  803471:	8b 45 0c             	mov    0xc(%ebp),%eax
  803474:	01 d0                	add    %edx,%eax
  803476:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80347b:	0f 87 ad 01 00 00    	ja     80362e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	0f 89 a5 01 00 00    	jns    803631 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80348c:	8b 55 08             	mov    0x8(%ebp),%edx
  80348f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	83 e8 04             	sub    $0x4,%eax
  803497:	a3 44 70 80 00       	mov    %eax,0x807044
     struct BlockElement * element = NULL;
  80349c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8034a3:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8034a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ab:	e9 87 00 00 00       	jmp    803537 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8034b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b4:	75 14                	jne    8034ca <initialize_dynamic_allocator+0x83>
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 4f 69 80 00       	push   $0x80694f
  8034be:	6a 79                	push   $0x79
  8034c0:	68 6d 69 80 00       	push   $0x80696d
  8034c5:	e8 29 e3 ff ff       	call   8017f3 <_panic>
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	74 10                	je     8034e3 <initialize_dynamic_allocator+0x9c>
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034db:	8b 52 04             	mov    0x4(%edx),%edx
  8034de:	89 50 04             	mov    %edx,0x4(%eax)
  8034e1:	eb 0b                	jmp    8034ee <initialize_dynamic_allocator+0xa7>
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	8b 40 04             	mov    0x4(%eax),%eax
  8034e9:	a3 30 70 80 00       	mov    %eax,0x807030
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 0f                	je     803507 <initialize_dynamic_allocator+0xc0>
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 40 04             	mov    0x4(%eax),%eax
  8034fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803501:	8b 12                	mov    (%edx),%edx
  803503:	89 10                	mov    %edx,(%eax)
  803505:	eb 0a                	jmp    803511 <initialize_dynamic_allocator+0xca>
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803524:	a1 38 70 80 00       	mov    0x807038,%eax
  803529:	48                   	dec    %eax
  80352a:	a3 38 70 80 00       	mov    %eax,0x807038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80352f:	a1 34 70 80 00       	mov    0x807034,%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353b:	74 07                	je     803544 <initialize_dynamic_allocator+0xfd>
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	eb 05                	jmp    803549 <initialize_dynamic_allocator+0x102>
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
  803549:	a3 34 70 80 00       	mov    %eax,0x807034
  80354e:	a1 34 70 80 00       	mov    0x807034,%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	0f 85 55 ff ff ff    	jne    8034b0 <initialize_dynamic_allocator+0x69>
  80355b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355f:	0f 85 4b ff ff ff    	jne    8034b0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803574:	a1 44 70 80 00       	mov    0x807044,%eax
  803579:	a3 40 70 80 00       	mov    %eax,0x807040
    end_block->info = 1;
  80357e:	a1 40 70 80 00       	mov    0x807040,%eax
  803583:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	83 c0 08             	add    $0x8,%eax
  80358f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	83 c0 04             	add    $0x4,%eax
  803598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80359b:	83 ea 08             	sub    $0x8,%edx
  80359e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8035a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	01 d0                	add    %edx,%eax
  8035a8:	83 e8 08             	sub    $0x8,%eax
  8035ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ae:	83 ea 08             	sub    $0x8,%edx
  8035b1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8035b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8035c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035ca:	75 17                	jne    8035e3 <initialize_dynamic_allocator+0x19c>
  8035cc:	83 ec 04             	sub    $0x4,%esp
  8035cf:	68 88 69 80 00       	push   $0x806988
  8035d4:	68 90 00 00 00       	push   $0x90
  8035d9:	68 6d 69 80 00       	push   $0x80696d
  8035de:	e8 10 e2 ff ff       	call   8017f3 <_panic>
  8035e3:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8035e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 0d                	je     803604 <initialize_dynamic_allocator+0x1bd>
  8035f7:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8035fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ff:	89 50 04             	mov    %edx,0x4(%eax)
  803602:	eb 08                	jmp    80360c <initialize_dynamic_allocator+0x1c5>
  803604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803607:	a3 30 70 80 00       	mov    %eax,0x807030
  80360c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360f:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361e:	a1 38 70 80 00       	mov    0x807038,%eax
  803623:	40                   	inc    %eax
  803624:	a3 38 70 80 00       	mov    %eax,0x807038
  803629:	eb 07                	jmp    803632 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80362b:	90                   	nop
  80362c:	eb 04                	jmp    803632 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80362e:	90                   	nop
  80362f:	eb 01                	jmp    803632 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803631:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  803632:	c9                   	leave  
  803633:	c3                   	ret    

00803634 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803634:	55                   	push   %ebp
  803635:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803637:	8b 45 10             	mov    0x10(%ebp),%eax
  80363a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	8d 50 fc             	lea    -0x4(%eax),%edx
  803643:	8b 45 0c             	mov    0xc(%ebp),%eax
  803646:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	83 e8 04             	sub    $0x4,%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	83 e0 fe             	and    $0xfffffffe,%eax
  803653:	8d 50 f8             	lea    -0x8(%eax),%edx
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	01 c2                	add    %eax,%edx
  80365b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365e:	89 02                	mov    %eax,(%edx)
}
  803660:	90                   	nop
  803661:	5d                   	pop    %ebp
  803662:	c3                   	ret    

00803663 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803663:	55                   	push   %ebp
  803664:	89 e5                	mov    %esp,%ebp
  803666:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	83 e0 01             	and    $0x1,%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	74 03                	je     803676 <alloc_block_FF+0x13>
  803673:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803676:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80367a:	77 07                	ja     803683 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80367c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803683:	a1 24 70 80 00       	mov    0x807024,%eax
  803688:	85 c0                	test   %eax,%eax
  80368a:	75 73                	jne    8036ff <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	83 c0 10             	add    $0x10,%eax
  803692:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803695:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80369c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80369f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a2:	01 d0                	add    %edx,%eax
  8036a4:	48                   	dec    %eax
  8036a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8036b0:	f7 75 ec             	divl   -0x14(%ebp)
  8036b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b6:	29 d0                	sub    %edx,%eax
  8036b8:	c1 e8 0c             	shr    $0xc,%eax
  8036bb:	83 ec 0c             	sub    $0xc,%esp
  8036be:	50                   	push   %eax
  8036bf:	e8 86 f1 ff ff       	call   80284a <sbrk>
  8036c4:	83 c4 10             	add    $0x10,%esp
  8036c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8036ca:	83 ec 0c             	sub    $0xc,%esp
  8036cd:	6a 00                	push   $0x0
  8036cf:	e8 76 f1 ff ff       	call   80284a <sbrk>
  8036d4:	83 c4 10             	add    $0x10,%esp
  8036d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8036da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036dd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8036e0:	83 ec 08             	sub    $0x8,%esp
  8036e3:	50                   	push   %eax
  8036e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036e7:	e8 5b fd ff ff       	call   803447 <initialize_dynamic_allocator>
  8036ec:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8036ef:	83 ec 0c             	sub    $0xc,%esp
  8036f2:	68 ab 69 80 00       	push   $0x8069ab
  8036f7:	e8 b4 e3 ff ff       	call   801ab0 <cprintf>
  8036fc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8036ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803703:	75 0a                	jne    80370f <alloc_block_FF+0xac>
	        return NULL;
  803705:	b8 00 00 00 00       	mov    $0x0,%eax
  80370a:	e9 0e 04 00 00       	jmp    803b1d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80370f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803716:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80371b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371e:	e9 f3 02 00 00       	jmp    803a16 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803729:	83 ec 0c             	sub    $0xc,%esp
  80372c:	ff 75 bc             	pushl  -0x44(%ebp)
  80372f:	e8 af fb ff ff       	call   8032e3 <get_block_size>
  803734:	83 c4 10             	add    $0x10,%esp
  803737:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	83 c0 08             	add    $0x8,%eax
  803740:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803743:	0f 87 c5 02 00 00    	ja     803a0e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	83 c0 18             	add    $0x18,%eax
  80374f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803752:	0f 87 19 02 00 00    	ja     803971 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803758:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80375b:	2b 45 08             	sub    0x8(%ebp),%eax
  80375e:	83 e8 08             	sub    $0x8,%eax
  803761:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803764:	8b 45 08             	mov    0x8(%ebp),%eax
  803767:	8d 50 08             	lea    0x8(%eax),%edx
  80376a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80376d:	01 d0                	add    %edx,%eax
  80376f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	83 c0 08             	add    $0x8,%eax
  803778:	83 ec 04             	sub    $0x4,%esp
  80377b:	6a 01                	push   $0x1
  80377d:	50                   	push   %eax
  80377e:	ff 75 bc             	pushl  -0x44(%ebp)
  803781:	e8 ae fe ff ff       	call   803634 <set_block_data>
  803786:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 40 04             	mov    0x4(%eax),%eax
  80378f:	85 c0                	test   %eax,%eax
  803791:	75 68                	jne    8037fb <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803793:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803797:	75 17                	jne    8037b0 <alloc_block_FF+0x14d>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 88 69 80 00       	push   $0x806988
  8037a1:	68 d7 00 00 00       	push   $0xd7
  8037a6:	68 6d 69 80 00       	push   $0x80696d
  8037ab:	e8 43 e0 ff ff       	call   8017f3 <_panic>
  8037b0:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8037b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037b9:	89 10                	mov    %edx,(%eax)
  8037bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	85 c0                	test   %eax,%eax
  8037c2:	74 0d                	je     8037d1 <alloc_block_FF+0x16e>
  8037c4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8037c9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8037cc:	89 50 04             	mov    %edx,0x4(%eax)
  8037cf:	eb 08                	jmp    8037d9 <alloc_block_FF+0x176>
  8037d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037d4:	a3 30 70 80 00       	mov    %eax,0x807030
  8037d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037dc:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8037e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037eb:	a1 38 70 80 00       	mov    0x807038,%eax
  8037f0:	40                   	inc    %eax
  8037f1:	a3 38 70 80 00       	mov    %eax,0x807038
  8037f6:	e9 dc 00 00 00       	jmp    8038d7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	75 65                	jne    803869 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803804:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803808:	75 17                	jne    803821 <alloc_block_FF+0x1be>
  80380a:	83 ec 04             	sub    $0x4,%esp
  80380d:	68 bc 69 80 00       	push   $0x8069bc
  803812:	68 db 00 00 00       	push   $0xdb
  803817:	68 6d 69 80 00       	push   $0x80696d
  80381c:	e8 d2 df ff ff       	call   8017f3 <_panic>
  803821:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803827:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803830:	8b 40 04             	mov    0x4(%eax),%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	74 0c                	je     803843 <alloc_block_FF+0x1e0>
  803837:	a1 30 70 80 00       	mov    0x807030,%eax
  80383c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80383f:	89 10                	mov    %edx,(%eax)
  803841:	eb 08                	jmp    80384b <alloc_block_FF+0x1e8>
  803843:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803846:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80384b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80384e:	a3 30 70 80 00       	mov    %eax,0x807030
  803853:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803856:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385c:	a1 38 70 80 00       	mov    0x807038,%eax
  803861:	40                   	inc    %eax
  803862:	a3 38 70 80 00       	mov    %eax,0x807038
  803867:	eb 6e                	jmp    8038d7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386d:	74 06                	je     803875 <alloc_block_FF+0x212>
  80386f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803873:	75 17                	jne    80388c <alloc_block_FF+0x229>
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	68 e0 69 80 00       	push   $0x8069e0
  80387d:	68 df 00 00 00       	push   $0xdf
  803882:	68 6d 69 80 00       	push   $0x80696d
  803887:	e8 67 df ff ff       	call   8017f3 <_panic>
  80388c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388f:	8b 10                	mov    (%eax),%edx
  803891:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803894:	89 10                	mov    %edx,(%eax)
  803896:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803899:	8b 00                	mov    (%eax),%eax
  80389b:	85 c0                	test   %eax,%eax
  80389d:	74 0b                	je     8038aa <alloc_block_FF+0x247>
  80389f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a2:	8b 00                	mov    (%eax),%eax
  8038a4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038a7:	89 50 04             	mov    %edx,0x4(%eax)
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b8:	89 50 04             	mov    %edx,0x4(%eax)
  8038bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	85 c0                	test   %eax,%eax
  8038c2:	75 08                	jne    8038cc <alloc_block_FF+0x269>
  8038c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8038c7:	a3 30 70 80 00       	mov    %eax,0x807030
  8038cc:	a1 38 70 80 00       	mov    0x807038,%eax
  8038d1:	40                   	inc    %eax
  8038d2:	a3 38 70 80 00       	mov    %eax,0x807038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8038d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038db:	75 17                	jne    8038f4 <alloc_block_FF+0x291>
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	68 4f 69 80 00       	push   $0x80694f
  8038e5:	68 e1 00 00 00       	push   $0xe1
  8038ea:	68 6d 69 80 00       	push   $0x80696d
  8038ef:	e8 ff de ff ff       	call   8017f3 <_panic>
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	74 10                	je     80390d <alloc_block_FF+0x2aa>
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803905:	8b 52 04             	mov    0x4(%edx),%edx
  803908:	89 50 04             	mov    %edx,0x4(%eax)
  80390b:	eb 0b                	jmp    803918 <alloc_block_FF+0x2b5>
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	8b 40 04             	mov    0x4(%eax),%eax
  803913:	a3 30 70 80 00       	mov    %eax,0x807030
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	8b 40 04             	mov    0x4(%eax),%eax
  80391e:	85 c0                	test   %eax,%eax
  803920:	74 0f                	je     803931 <alloc_block_FF+0x2ce>
  803922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803925:	8b 40 04             	mov    0x4(%eax),%eax
  803928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80392b:	8b 12                	mov    (%edx),%edx
  80392d:	89 10                	mov    %edx,(%eax)
  80392f:	eb 0a                	jmp    80393b <alloc_block_FF+0x2d8>
  803931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803934:	8b 00                	mov    (%eax),%eax
  803936:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394e:	a1 38 70 80 00       	mov    0x807038,%eax
  803953:	48                   	dec    %eax
  803954:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(new_block_va, remaining_size, 0);
  803959:	83 ec 04             	sub    $0x4,%esp
  80395c:	6a 00                	push   $0x0
  80395e:	ff 75 b4             	pushl  -0x4c(%ebp)
  803961:	ff 75 b0             	pushl  -0x50(%ebp)
  803964:	e8 cb fc ff ff       	call   803634 <set_block_data>
  803969:	83 c4 10             	add    $0x10,%esp
  80396c:	e9 95 00 00 00       	jmp    803a06 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	6a 01                	push   $0x1
  803976:	ff 75 b8             	pushl  -0x48(%ebp)
  803979:	ff 75 bc             	pushl  -0x44(%ebp)
  80397c:	e8 b3 fc ff ff       	call   803634 <set_block_data>
  803981:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803988:	75 17                	jne    8039a1 <alloc_block_FF+0x33e>
  80398a:	83 ec 04             	sub    $0x4,%esp
  80398d:	68 4f 69 80 00       	push   $0x80694f
  803992:	68 e8 00 00 00       	push   $0xe8
  803997:	68 6d 69 80 00       	push   $0x80696d
  80399c:	e8 52 de ff ff       	call   8017f3 <_panic>
  8039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	85 c0                	test   %eax,%eax
  8039a8:	74 10                	je     8039ba <alloc_block_FF+0x357>
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b2:	8b 52 04             	mov    0x4(%edx),%edx
  8039b5:	89 50 04             	mov    %edx,0x4(%eax)
  8039b8:	eb 0b                	jmp    8039c5 <alloc_block_FF+0x362>
  8039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bd:	8b 40 04             	mov    0x4(%eax),%eax
  8039c0:	a3 30 70 80 00       	mov    %eax,0x807030
  8039c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c8:	8b 40 04             	mov    0x4(%eax),%eax
  8039cb:	85 c0                	test   %eax,%eax
  8039cd:	74 0f                	je     8039de <alloc_block_FF+0x37b>
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 40 04             	mov    0x4(%eax),%eax
  8039d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039d8:	8b 12                	mov    (%edx),%edx
  8039da:	89 10                	mov    %edx,(%eax)
  8039dc:	eb 0a                	jmp    8039e8 <alloc_block_FF+0x385>
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8039e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fb:	a1 38 70 80 00       	mov    0x807038,%eax
  803a00:	48                   	dec    %eax
  803a01:	a3 38 70 80 00       	mov    %eax,0x807038
	            }
	            return va;
  803a06:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a09:	e9 0f 01 00 00       	jmp    803b1d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803a0e:	a1 34 70 80 00       	mov    0x807034,%eax
  803a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1a:	74 07                	je     803a23 <alloc_block_FF+0x3c0>
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	eb 05                	jmp    803a28 <alloc_block_FF+0x3c5>
  803a23:	b8 00 00 00 00       	mov    $0x0,%eax
  803a28:	a3 34 70 80 00       	mov    %eax,0x807034
  803a2d:	a1 34 70 80 00       	mov    0x807034,%eax
  803a32:	85 c0                	test   %eax,%eax
  803a34:	0f 85 e9 fc ff ff    	jne    803723 <alloc_block_FF+0xc0>
  803a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3e:	0f 85 df fc ff ff    	jne    803723 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	83 c0 08             	add    $0x8,%eax
  803a4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a4d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803a54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a5a:	01 d0                	add    %edx,%eax
  803a5c:	48                   	dec    %eax
  803a5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803a60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a63:	ba 00 00 00 00       	mov    $0x0,%edx
  803a68:	f7 75 d8             	divl   -0x28(%ebp)
  803a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6e:	29 d0                	sub    %edx,%eax
  803a70:	c1 e8 0c             	shr    $0xc,%eax
  803a73:	83 ec 0c             	sub    $0xc,%esp
  803a76:	50                   	push   %eax
  803a77:	e8 ce ed ff ff       	call   80284a <sbrk>
  803a7c:	83 c4 10             	add    $0x10,%esp
  803a7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803a82:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803a86:	75 0a                	jne    803a92 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  803a88:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8d:	e9 8b 00 00 00       	jmp    803b1d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803a92:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803a99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a9f:	01 d0                	add    %edx,%eax
  803aa1:	48                   	dec    %eax
  803aa2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803aa5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  803aad:	f7 75 cc             	divl   -0x34(%ebp)
  803ab0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab3:	29 d0                	sub    %edx,%eax
  803ab5:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ab8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803abb:	01 d0                	add    %edx,%eax
  803abd:	a3 40 70 80 00       	mov    %eax,0x807040
			end_block->info = 1;
  803ac2:	a1 40 70 80 00       	mov    0x807040,%eax
  803ac7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803acd:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803ad4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ad7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ada:	01 d0                	add    %edx,%eax
  803adc:	48                   	dec    %eax
  803add:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803ae0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ae8:	f7 75 c4             	divl   -0x3c(%ebp)
  803aeb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803aee:	29 d0                	sub    %edx,%eax
  803af0:	83 ec 04             	sub    $0x4,%esp
  803af3:	6a 01                	push   $0x1
  803af5:	50                   	push   %eax
  803af6:	ff 75 d0             	pushl  -0x30(%ebp)
  803af9:	e8 36 fb ff ff       	call   803634 <set_block_data>
  803afe:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803b01:	83 ec 0c             	sub    $0xc,%esp
  803b04:	ff 75 d0             	pushl  -0x30(%ebp)
  803b07:	e8 1b 0a 00 00       	call   804527 <free_block>
  803b0c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803b0f:	83 ec 0c             	sub    $0xc,%esp
  803b12:	ff 75 08             	pushl  0x8(%ebp)
  803b15:	e8 49 fb ff ff       	call   803663 <alloc_block_FF>
  803b1a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803b1d:	c9                   	leave  
  803b1e:	c3                   	ret    

00803b1f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803b1f:	55                   	push   %ebp
  803b20:	89 e5                	mov    %esp,%ebp
  803b22:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803b25:	8b 45 08             	mov    0x8(%ebp),%eax
  803b28:	83 e0 01             	and    $0x1,%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	74 03                	je     803b32 <alloc_block_BF+0x13>
  803b2f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803b32:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803b36:	77 07                	ja     803b3f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803b38:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803b3f:	a1 24 70 80 00       	mov    0x807024,%eax
  803b44:	85 c0                	test   %eax,%eax
  803b46:	75 73                	jne    803bbb <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	83 c0 10             	add    $0x10,%eax
  803b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803b51:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803b58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b5e:	01 d0                	add    %edx,%eax
  803b60:	48                   	dec    %eax
  803b61:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b67:	ba 00 00 00 00       	mov    $0x0,%edx
  803b6c:	f7 75 e0             	divl   -0x20(%ebp)
  803b6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b72:	29 d0                	sub    %edx,%eax
  803b74:	c1 e8 0c             	shr    $0xc,%eax
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	50                   	push   %eax
  803b7b:	e8 ca ec ff ff       	call   80284a <sbrk>
  803b80:	83 c4 10             	add    $0x10,%esp
  803b83:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803b86:	83 ec 0c             	sub    $0xc,%esp
  803b89:	6a 00                	push   $0x0
  803b8b:	e8 ba ec ff ff       	call   80284a <sbrk>
  803b90:	83 c4 10             	add    $0x10,%esp
  803b93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803b96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b99:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803b9c:	83 ec 08             	sub    $0x8,%esp
  803b9f:	50                   	push   %eax
  803ba0:	ff 75 d8             	pushl  -0x28(%ebp)
  803ba3:	e8 9f f8 ff ff       	call   803447 <initialize_dynamic_allocator>
  803ba8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803bab:	83 ec 0c             	sub    $0xc,%esp
  803bae:	68 ab 69 80 00       	push   $0x8069ab
  803bb3:	e8 f8 de ff ff       	call   801ab0 <cprintf>
  803bb8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803bc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803bc9:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803bd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803bd7:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bdf:	e9 1d 01 00 00       	jmp    803d01 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803bea:	83 ec 0c             	sub    $0xc,%esp
  803bed:	ff 75 a8             	pushl  -0x58(%ebp)
  803bf0:	e8 ee f6 ff ff       	call   8032e3 <get_block_size>
  803bf5:	83 c4 10             	add    $0x10,%esp
  803bf8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfe:	83 c0 08             	add    $0x8,%eax
  803c01:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c04:	0f 87 ef 00 00 00    	ja     803cf9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0d:	83 c0 18             	add    $0x18,%eax
  803c10:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c13:	77 1d                	ja     803c32 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c18:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c1b:	0f 86 d8 00 00 00    	jbe    803cf9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803c21:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803c27:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803c2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c2d:	e9 c7 00 00 00       	jmp    803cf9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803c32:	8b 45 08             	mov    0x8(%ebp),%eax
  803c35:	83 c0 08             	add    $0x8,%eax
  803c38:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c3b:	0f 85 9d 00 00 00    	jne    803cde <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803c41:	83 ec 04             	sub    $0x4,%esp
  803c44:	6a 01                	push   $0x1
  803c46:	ff 75 a4             	pushl  -0x5c(%ebp)
  803c49:	ff 75 a8             	pushl  -0x58(%ebp)
  803c4c:	e8 e3 f9 ff ff       	call   803634 <set_block_data>
  803c51:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803c54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c58:	75 17                	jne    803c71 <alloc_block_BF+0x152>
  803c5a:	83 ec 04             	sub    $0x4,%esp
  803c5d:	68 4f 69 80 00       	push   $0x80694f
  803c62:	68 2c 01 00 00       	push   $0x12c
  803c67:	68 6d 69 80 00       	push   $0x80696d
  803c6c:	e8 82 db ff ff       	call   8017f3 <_panic>
  803c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c74:	8b 00                	mov    (%eax),%eax
  803c76:	85 c0                	test   %eax,%eax
  803c78:	74 10                	je     803c8a <alloc_block_BF+0x16b>
  803c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7d:	8b 00                	mov    (%eax),%eax
  803c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c82:	8b 52 04             	mov    0x4(%edx),%edx
  803c85:	89 50 04             	mov    %edx,0x4(%eax)
  803c88:	eb 0b                	jmp    803c95 <alloc_block_BF+0x176>
  803c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8d:	8b 40 04             	mov    0x4(%eax),%eax
  803c90:	a3 30 70 80 00       	mov    %eax,0x807030
  803c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c98:	8b 40 04             	mov    0x4(%eax),%eax
  803c9b:	85 c0                	test   %eax,%eax
  803c9d:	74 0f                	je     803cae <alloc_block_BF+0x18f>
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	8b 40 04             	mov    0x4(%eax),%eax
  803ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ca8:	8b 12                	mov    (%edx),%edx
  803caa:	89 10                	mov    %edx,(%eax)
  803cac:	eb 0a                	jmp    803cb8 <alloc_block_BF+0x199>
  803cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ccb:	a1 38 70 80 00       	mov    0x807038,%eax
  803cd0:	48                   	dec    %eax
  803cd1:	a3 38 70 80 00       	mov    %eax,0x807038
					return va;
  803cd6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803cd9:	e9 24 04 00 00       	jmp    804102 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ce4:	76 13                	jbe    803cf9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803ce6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803ced:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803cf3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803cf9:	a1 34 70 80 00       	mov    0x807034,%eax
  803cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d05:	74 07                	je     803d0e <alloc_block_BF+0x1ef>
  803d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0a:	8b 00                	mov    (%eax),%eax
  803d0c:	eb 05                	jmp    803d13 <alloc_block_BF+0x1f4>
  803d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d13:	a3 34 70 80 00       	mov    %eax,0x807034
  803d18:	a1 34 70 80 00       	mov    0x807034,%eax
  803d1d:	85 c0                	test   %eax,%eax
  803d1f:	0f 85 bf fe ff ff    	jne    803be4 <alloc_block_BF+0xc5>
  803d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d29:	0f 85 b5 fe ff ff    	jne    803be4 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803d2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d33:	0f 84 26 02 00 00    	je     803f5f <alloc_block_BF+0x440>
  803d39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d3d:	0f 85 1c 02 00 00    	jne    803f5f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d46:	2b 45 08             	sub    0x8(%ebp),%eax
  803d49:	83 e8 08             	sub    $0x8,%eax
  803d4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d52:	8d 50 08             	lea    0x8(%eax),%edx
  803d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d58:	01 d0                	add    %edx,%eax
  803d5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d60:	83 c0 08             	add    $0x8,%eax
  803d63:	83 ec 04             	sub    $0x4,%esp
  803d66:	6a 01                	push   $0x1
  803d68:	50                   	push   %eax
  803d69:	ff 75 f0             	pushl  -0x10(%ebp)
  803d6c:	e8 c3 f8 ff ff       	call   803634 <set_block_data>
  803d71:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d77:	8b 40 04             	mov    0x4(%eax),%eax
  803d7a:	85 c0                	test   %eax,%eax
  803d7c:	75 68                	jne    803de6 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803d7e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803d82:	75 17                	jne    803d9b <alloc_block_BF+0x27c>
  803d84:	83 ec 04             	sub    $0x4,%esp
  803d87:	68 88 69 80 00       	push   $0x806988
  803d8c:	68 45 01 00 00       	push   $0x145
  803d91:	68 6d 69 80 00       	push   $0x80696d
  803d96:	e8 58 da ff ff       	call   8017f3 <_panic>
  803d9b:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  803da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da4:	89 10                	mov    %edx,(%eax)
  803da6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da9:	8b 00                	mov    (%eax),%eax
  803dab:	85 c0                	test   %eax,%eax
  803dad:	74 0d                	je     803dbc <alloc_block_BF+0x29d>
  803daf:	a1 2c 70 80 00       	mov    0x80702c,%eax
  803db4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803db7:	89 50 04             	mov    %edx,0x4(%eax)
  803dba:	eb 08                	jmp    803dc4 <alloc_block_BF+0x2a5>
  803dbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dbf:	a3 30 70 80 00       	mov    %eax,0x807030
  803dc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dc7:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803dcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd6:	a1 38 70 80 00       	mov    0x807038,%eax
  803ddb:	40                   	inc    %eax
  803ddc:	a3 38 70 80 00       	mov    %eax,0x807038
  803de1:	e9 dc 00 00 00       	jmp    803ec2 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de9:	8b 00                	mov    (%eax),%eax
  803deb:	85 c0                	test   %eax,%eax
  803ded:	75 65                	jne    803e54 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803def:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803df3:	75 17                	jne    803e0c <alloc_block_BF+0x2ed>
  803df5:	83 ec 04             	sub    $0x4,%esp
  803df8:	68 bc 69 80 00       	push   $0x8069bc
  803dfd:	68 4a 01 00 00       	push   $0x14a
  803e02:	68 6d 69 80 00       	push   $0x80696d
  803e07:	e8 e7 d9 ff ff       	call   8017f3 <_panic>
  803e0c:	8b 15 30 70 80 00    	mov    0x807030,%edx
  803e12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e15:	89 50 04             	mov    %edx,0x4(%eax)
  803e18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e1b:	8b 40 04             	mov    0x4(%eax),%eax
  803e1e:	85 c0                	test   %eax,%eax
  803e20:	74 0c                	je     803e2e <alloc_block_BF+0x30f>
  803e22:	a1 30 70 80 00       	mov    0x807030,%eax
  803e27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e2a:	89 10                	mov    %edx,(%eax)
  803e2c:	eb 08                	jmp    803e36 <alloc_block_BF+0x317>
  803e2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e31:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803e36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e39:	a3 30 70 80 00       	mov    %eax,0x807030
  803e3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e47:	a1 38 70 80 00       	mov    0x807038,%eax
  803e4c:	40                   	inc    %eax
  803e4d:	a3 38 70 80 00       	mov    %eax,0x807038
  803e52:	eb 6e                	jmp    803ec2 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803e54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e58:	74 06                	je     803e60 <alloc_block_BF+0x341>
  803e5a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e5e:	75 17                	jne    803e77 <alloc_block_BF+0x358>
  803e60:	83 ec 04             	sub    $0x4,%esp
  803e63:	68 e0 69 80 00       	push   $0x8069e0
  803e68:	68 4f 01 00 00       	push   $0x14f
  803e6d:	68 6d 69 80 00       	push   $0x80696d
  803e72:	e8 7c d9 ff ff       	call   8017f3 <_panic>
  803e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e7a:	8b 10                	mov    (%eax),%edx
  803e7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e7f:	89 10                	mov    %edx,(%eax)
  803e81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 0b                	je     803e95 <alloc_block_BF+0x376>
  803e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e92:	89 50 04             	mov    %edx,0x4(%eax)
  803e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e98:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ea0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ea3:	89 50 04             	mov    %edx,0x4(%eax)
  803ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ea9:	8b 00                	mov    (%eax),%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	75 08                	jne    803eb7 <alloc_block_BF+0x398>
  803eaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803eb2:	a3 30 70 80 00       	mov    %eax,0x807030
  803eb7:	a1 38 70 80 00       	mov    0x807038,%eax
  803ebc:	40                   	inc    %eax
  803ebd:	a3 38 70 80 00       	mov    %eax,0x807038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803ec2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ec6:	75 17                	jne    803edf <alloc_block_BF+0x3c0>
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	68 4f 69 80 00       	push   $0x80694f
  803ed0:	68 51 01 00 00       	push   $0x151
  803ed5:	68 6d 69 80 00       	push   $0x80696d
  803eda:	e8 14 d9 ff ff       	call   8017f3 <_panic>
  803edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee2:	8b 00                	mov    (%eax),%eax
  803ee4:	85 c0                	test   %eax,%eax
  803ee6:	74 10                	je     803ef8 <alloc_block_BF+0x3d9>
  803ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eeb:	8b 00                	mov    (%eax),%eax
  803eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef0:	8b 52 04             	mov    0x4(%edx),%edx
  803ef3:	89 50 04             	mov    %edx,0x4(%eax)
  803ef6:	eb 0b                	jmp    803f03 <alloc_block_BF+0x3e4>
  803ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803efb:	8b 40 04             	mov    0x4(%eax),%eax
  803efe:	a3 30 70 80 00       	mov    %eax,0x807030
  803f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f06:	8b 40 04             	mov    0x4(%eax),%eax
  803f09:	85 c0                	test   %eax,%eax
  803f0b:	74 0f                	je     803f1c <alloc_block_BF+0x3fd>
  803f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f10:	8b 40 04             	mov    0x4(%eax),%eax
  803f13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f16:	8b 12                	mov    (%edx),%edx
  803f18:	89 10                	mov    %edx,(%eax)
  803f1a:	eb 0a                	jmp    803f26 <alloc_block_BF+0x407>
  803f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1f:	8b 00                	mov    (%eax),%eax
  803f21:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f39:	a1 38 70 80 00       	mov    0x807038,%eax
  803f3e:	48                   	dec    %eax
  803f3f:	a3 38 70 80 00       	mov    %eax,0x807038
			set_block_data(new_block_va, remaining_size, 0);
  803f44:	83 ec 04             	sub    $0x4,%esp
  803f47:	6a 00                	push   $0x0
  803f49:	ff 75 d0             	pushl  -0x30(%ebp)
  803f4c:	ff 75 cc             	pushl  -0x34(%ebp)
  803f4f:	e8 e0 f6 ff ff       	call   803634 <set_block_data>
  803f54:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5a:	e9 a3 01 00 00       	jmp    804102 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803f5f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803f63:	0f 85 9d 00 00 00    	jne    804006 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803f69:	83 ec 04             	sub    $0x4,%esp
  803f6c:	6a 01                	push   $0x1
  803f6e:	ff 75 ec             	pushl  -0x14(%ebp)
  803f71:	ff 75 f0             	pushl  -0x10(%ebp)
  803f74:	e8 bb f6 ff ff       	call   803634 <set_block_data>
  803f79:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803f7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f80:	75 17                	jne    803f99 <alloc_block_BF+0x47a>
  803f82:	83 ec 04             	sub    $0x4,%esp
  803f85:	68 4f 69 80 00       	push   $0x80694f
  803f8a:	68 58 01 00 00       	push   $0x158
  803f8f:	68 6d 69 80 00       	push   $0x80696d
  803f94:	e8 5a d8 ff ff       	call   8017f3 <_panic>
  803f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9c:	8b 00                	mov    (%eax),%eax
  803f9e:	85 c0                	test   %eax,%eax
  803fa0:	74 10                	je     803fb2 <alloc_block_BF+0x493>
  803fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa5:	8b 00                	mov    (%eax),%eax
  803fa7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803faa:	8b 52 04             	mov    0x4(%edx),%edx
  803fad:	89 50 04             	mov    %edx,0x4(%eax)
  803fb0:	eb 0b                	jmp    803fbd <alloc_block_BF+0x49e>
  803fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb5:	8b 40 04             	mov    0x4(%eax),%eax
  803fb8:	a3 30 70 80 00       	mov    %eax,0x807030
  803fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc0:	8b 40 04             	mov    0x4(%eax),%eax
  803fc3:	85 c0                	test   %eax,%eax
  803fc5:	74 0f                	je     803fd6 <alloc_block_BF+0x4b7>
  803fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fca:	8b 40 04             	mov    0x4(%eax),%eax
  803fcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fd0:	8b 12                	mov    (%edx),%edx
  803fd2:	89 10                	mov    %edx,(%eax)
  803fd4:	eb 0a                	jmp    803fe0 <alloc_block_BF+0x4c1>
  803fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd9:	8b 00                	mov    (%eax),%eax
  803fdb:	a3 2c 70 80 00       	mov    %eax,0x80702c
  803fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff3:	a1 38 70 80 00       	mov    0x807038,%eax
  803ff8:	48                   	dec    %eax
  803ff9:	a3 38 70 80 00       	mov    %eax,0x807038
		return best_va;
  803ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804001:	e9 fc 00 00 00       	jmp    804102 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  804006:	8b 45 08             	mov    0x8(%ebp),%eax
  804009:	83 c0 08             	add    $0x8,%eax
  80400c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80400f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  804016:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804019:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80401c:	01 d0                	add    %edx,%eax
  80401e:	48                   	dec    %eax
  80401f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  804022:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804025:	ba 00 00 00 00       	mov    $0x0,%edx
  80402a:	f7 75 c4             	divl   -0x3c(%ebp)
  80402d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804030:	29 d0                	sub    %edx,%eax
  804032:	c1 e8 0c             	shr    $0xc,%eax
  804035:	83 ec 0c             	sub    $0xc,%esp
  804038:	50                   	push   %eax
  804039:	e8 0c e8 ff ff       	call   80284a <sbrk>
  80403e:	83 c4 10             	add    $0x10,%esp
  804041:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  804044:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  804048:	75 0a                	jne    804054 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80404a:	b8 00 00 00 00       	mov    $0x0,%eax
  80404f:	e9 ae 00 00 00       	jmp    804102 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  804054:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80405b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80405e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804061:	01 d0                	add    %edx,%eax
  804063:	48                   	dec    %eax
  804064:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  804067:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80406a:	ba 00 00 00 00       	mov    $0x0,%edx
  80406f:	f7 75 b8             	divl   -0x48(%ebp)
  804072:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  804075:	29 d0                	sub    %edx,%eax
  804077:	8d 50 fc             	lea    -0x4(%eax),%edx
  80407a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80407d:	01 d0                	add    %edx,%eax
  80407f:	a3 40 70 80 00       	mov    %eax,0x807040
				end_block->info = 1;
  804084:	a1 40 70 80 00       	mov    0x807040,%eax
  804089:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80408f:	83 ec 0c             	sub    $0xc,%esp
  804092:	68 14 6a 80 00       	push   $0x806a14
  804097:	e8 14 da ff ff       	call   801ab0 <cprintf>
  80409c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80409f:	83 ec 08             	sub    $0x8,%esp
  8040a2:	ff 75 bc             	pushl  -0x44(%ebp)
  8040a5:	68 19 6a 80 00       	push   $0x806a19
  8040aa:	e8 01 da ff ff       	call   801ab0 <cprintf>
  8040af:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8040b2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8040b9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8040bf:	01 d0                	add    %edx,%eax
  8040c1:	48                   	dec    %eax
  8040c2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8040c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8040c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8040cd:	f7 75 b0             	divl   -0x50(%ebp)
  8040d0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8040d3:	29 d0                	sub    %edx,%eax
  8040d5:	83 ec 04             	sub    $0x4,%esp
  8040d8:	6a 01                	push   $0x1
  8040da:	50                   	push   %eax
  8040db:	ff 75 bc             	pushl  -0x44(%ebp)
  8040de:	e8 51 f5 ff ff       	call   803634 <set_block_data>
  8040e3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8040e6:	83 ec 0c             	sub    $0xc,%esp
  8040e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8040ec:	e8 36 04 00 00       	call   804527 <free_block>
  8040f1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8040f4:	83 ec 0c             	sub    $0xc,%esp
  8040f7:	ff 75 08             	pushl  0x8(%ebp)
  8040fa:	e8 20 fa ff ff       	call   803b1f <alloc_block_BF>
  8040ff:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  804102:	c9                   	leave  
  804103:	c3                   	ret    

00804104 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  804104:	55                   	push   %ebp
  804105:	89 e5                	mov    %esp,%ebp
  804107:	53                   	push   %ebx
  804108:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80410b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  804119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80411d:	74 1e                	je     80413d <merging+0x39>
  80411f:	ff 75 08             	pushl  0x8(%ebp)
  804122:	e8 bc f1 ff ff       	call   8032e3 <get_block_size>
  804127:	83 c4 04             	add    $0x4,%esp
  80412a:	89 c2                	mov    %eax,%edx
  80412c:	8b 45 08             	mov    0x8(%ebp),%eax
  80412f:	01 d0                	add    %edx,%eax
  804131:	3b 45 10             	cmp    0x10(%ebp),%eax
  804134:	75 07                	jne    80413d <merging+0x39>
		prev_is_free = 1;
  804136:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80413d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804141:	74 1e                	je     804161 <merging+0x5d>
  804143:	ff 75 10             	pushl  0x10(%ebp)
  804146:	e8 98 f1 ff ff       	call   8032e3 <get_block_size>
  80414b:	83 c4 04             	add    $0x4,%esp
  80414e:	89 c2                	mov    %eax,%edx
  804150:	8b 45 10             	mov    0x10(%ebp),%eax
  804153:	01 d0                	add    %edx,%eax
  804155:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804158:	75 07                	jne    804161 <merging+0x5d>
		next_is_free = 1;
  80415a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  804161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804165:	0f 84 cc 00 00 00    	je     804237 <merging+0x133>
  80416b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80416f:	0f 84 c2 00 00 00    	je     804237 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  804175:	ff 75 08             	pushl  0x8(%ebp)
  804178:	e8 66 f1 ff ff       	call   8032e3 <get_block_size>
  80417d:	83 c4 04             	add    $0x4,%esp
  804180:	89 c3                	mov    %eax,%ebx
  804182:	ff 75 10             	pushl  0x10(%ebp)
  804185:	e8 59 f1 ff ff       	call   8032e3 <get_block_size>
  80418a:	83 c4 04             	add    $0x4,%esp
  80418d:	01 c3                	add    %eax,%ebx
  80418f:	ff 75 0c             	pushl  0xc(%ebp)
  804192:	e8 4c f1 ff ff       	call   8032e3 <get_block_size>
  804197:	83 c4 04             	add    $0x4,%esp
  80419a:	01 d8                	add    %ebx,%eax
  80419c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80419f:	6a 00                	push   $0x0
  8041a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8041a4:	ff 75 08             	pushl  0x8(%ebp)
  8041a7:	e8 88 f4 ff ff       	call   803634 <set_block_data>
  8041ac:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8041af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041b3:	75 17                	jne    8041cc <merging+0xc8>
  8041b5:	83 ec 04             	sub    $0x4,%esp
  8041b8:	68 4f 69 80 00       	push   $0x80694f
  8041bd:	68 7d 01 00 00       	push   $0x17d
  8041c2:	68 6d 69 80 00       	push   $0x80696d
  8041c7:	e8 27 d6 ff ff       	call   8017f3 <_panic>
  8041cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041cf:	8b 00                	mov    (%eax),%eax
  8041d1:	85 c0                	test   %eax,%eax
  8041d3:	74 10                	je     8041e5 <merging+0xe1>
  8041d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041d8:	8b 00                	mov    (%eax),%eax
  8041da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041dd:	8b 52 04             	mov    0x4(%edx),%edx
  8041e0:	89 50 04             	mov    %edx,0x4(%eax)
  8041e3:	eb 0b                	jmp    8041f0 <merging+0xec>
  8041e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e8:	8b 40 04             	mov    0x4(%eax),%eax
  8041eb:	a3 30 70 80 00       	mov    %eax,0x807030
  8041f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041f3:	8b 40 04             	mov    0x4(%eax),%eax
  8041f6:	85 c0                	test   %eax,%eax
  8041f8:	74 0f                	je     804209 <merging+0x105>
  8041fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041fd:	8b 40 04             	mov    0x4(%eax),%eax
  804200:	8b 55 0c             	mov    0xc(%ebp),%edx
  804203:	8b 12                	mov    (%edx),%edx
  804205:	89 10                	mov    %edx,(%eax)
  804207:	eb 0a                	jmp    804213 <merging+0x10f>
  804209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80420c:	8b 00                	mov    (%eax),%eax
  80420e:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804213:	8b 45 0c             	mov    0xc(%ebp),%eax
  804216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80421c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80421f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804226:	a1 38 70 80 00       	mov    0x807038,%eax
  80422b:	48                   	dec    %eax
  80422c:	a3 38 70 80 00       	mov    %eax,0x807038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804231:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804232:	e9 ea 02 00 00       	jmp    804521 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  804237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80423b:	74 3b                	je     804278 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80423d:	83 ec 0c             	sub    $0xc,%esp
  804240:	ff 75 08             	pushl  0x8(%ebp)
  804243:	e8 9b f0 ff ff       	call   8032e3 <get_block_size>
  804248:	83 c4 10             	add    $0x10,%esp
  80424b:	89 c3                	mov    %eax,%ebx
  80424d:	83 ec 0c             	sub    $0xc,%esp
  804250:	ff 75 10             	pushl  0x10(%ebp)
  804253:	e8 8b f0 ff ff       	call   8032e3 <get_block_size>
  804258:	83 c4 10             	add    $0x10,%esp
  80425b:	01 d8                	add    %ebx,%eax
  80425d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804260:	83 ec 04             	sub    $0x4,%esp
  804263:	6a 00                	push   $0x0
  804265:	ff 75 e8             	pushl  -0x18(%ebp)
  804268:	ff 75 08             	pushl  0x8(%ebp)
  80426b:	e8 c4 f3 ff ff       	call   803634 <set_block_data>
  804270:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804273:	e9 a9 02 00 00       	jmp    804521 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  804278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80427c:	0f 84 2d 01 00 00    	je     8043af <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  804282:	83 ec 0c             	sub    $0xc,%esp
  804285:	ff 75 10             	pushl  0x10(%ebp)
  804288:	e8 56 f0 ff ff       	call   8032e3 <get_block_size>
  80428d:	83 c4 10             	add    $0x10,%esp
  804290:	89 c3                	mov    %eax,%ebx
  804292:	83 ec 0c             	sub    $0xc,%esp
  804295:	ff 75 0c             	pushl  0xc(%ebp)
  804298:	e8 46 f0 ff ff       	call   8032e3 <get_block_size>
  80429d:	83 c4 10             	add    $0x10,%esp
  8042a0:	01 d8                	add    %ebx,%eax
  8042a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8042a5:	83 ec 04             	sub    $0x4,%esp
  8042a8:	6a 00                	push   $0x0
  8042aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8042ad:	ff 75 10             	pushl  0x10(%ebp)
  8042b0:	e8 7f f3 ff ff       	call   803634 <set_block_data>
  8042b5:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8042b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8042bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8042be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8042c2:	74 06                	je     8042ca <merging+0x1c6>
  8042c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8042c8:	75 17                	jne    8042e1 <merging+0x1dd>
  8042ca:	83 ec 04             	sub    $0x4,%esp
  8042cd:	68 28 6a 80 00       	push   $0x806a28
  8042d2:	68 8d 01 00 00       	push   $0x18d
  8042d7:	68 6d 69 80 00       	push   $0x80696d
  8042dc:	e8 12 d5 ff ff       	call   8017f3 <_panic>
  8042e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042e4:	8b 50 04             	mov    0x4(%eax),%edx
  8042e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042ea:	89 50 04             	mov    %edx,0x4(%eax)
  8042ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042f3:	89 10                	mov    %edx,(%eax)
  8042f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042f8:	8b 40 04             	mov    0x4(%eax),%eax
  8042fb:	85 c0                	test   %eax,%eax
  8042fd:	74 0d                	je     80430c <merging+0x208>
  8042ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  804302:	8b 40 04             	mov    0x4(%eax),%eax
  804305:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804308:	89 10                	mov    %edx,(%eax)
  80430a:	eb 08                	jmp    804314 <merging+0x210>
  80430c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80430f:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804314:	8b 45 0c             	mov    0xc(%ebp),%eax
  804317:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80431a:	89 50 04             	mov    %edx,0x4(%eax)
  80431d:	a1 38 70 80 00       	mov    0x807038,%eax
  804322:	40                   	inc    %eax
  804323:	a3 38 70 80 00       	mov    %eax,0x807038
		LIST_REMOVE(&freeBlocksList, next_block);
  804328:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80432c:	75 17                	jne    804345 <merging+0x241>
  80432e:	83 ec 04             	sub    $0x4,%esp
  804331:	68 4f 69 80 00       	push   $0x80694f
  804336:	68 8e 01 00 00       	push   $0x18e
  80433b:	68 6d 69 80 00       	push   $0x80696d
  804340:	e8 ae d4 ff ff       	call   8017f3 <_panic>
  804345:	8b 45 0c             	mov    0xc(%ebp),%eax
  804348:	8b 00                	mov    (%eax),%eax
  80434a:	85 c0                	test   %eax,%eax
  80434c:	74 10                	je     80435e <merging+0x25a>
  80434e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804351:	8b 00                	mov    (%eax),%eax
  804353:	8b 55 0c             	mov    0xc(%ebp),%edx
  804356:	8b 52 04             	mov    0x4(%edx),%edx
  804359:	89 50 04             	mov    %edx,0x4(%eax)
  80435c:	eb 0b                	jmp    804369 <merging+0x265>
  80435e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804361:	8b 40 04             	mov    0x4(%eax),%eax
  804364:	a3 30 70 80 00       	mov    %eax,0x807030
  804369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80436c:	8b 40 04             	mov    0x4(%eax),%eax
  80436f:	85 c0                	test   %eax,%eax
  804371:	74 0f                	je     804382 <merging+0x27e>
  804373:	8b 45 0c             	mov    0xc(%ebp),%eax
  804376:	8b 40 04             	mov    0x4(%eax),%eax
  804379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80437c:	8b 12                	mov    (%edx),%edx
  80437e:	89 10                	mov    %edx,(%eax)
  804380:	eb 0a                	jmp    80438c <merging+0x288>
  804382:	8b 45 0c             	mov    0xc(%ebp),%eax
  804385:	8b 00                	mov    (%eax),%eax
  804387:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80438c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80438f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804395:	8b 45 0c             	mov    0xc(%ebp),%eax
  804398:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80439f:	a1 38 70 80 00       	mov    0x807038,%eax
  8043a4:	48                   	dec    %eax
  8043a5:	a3 38 70 80 00       	mov    %eax,0x807038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8043aa:	e9 72 01 00 00       	jmp    804521 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8043af:	8b 45 10             	mov    0x10(%ebp),%eax
  8043b2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8043b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043b9:	74 79                	je     804434 <merging+0x330>
  8043bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8043bf:	74 73                	je     804434 <merging+0x330>
  8043c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043c5:	74 06                	je     8043cd <merging+0x2c9>
  8043c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8043cb:	75 17                	jne    8043e4 <merging+0x2e0>
  8043cd:	83 ec 04             	sub    $0x4,%esp
  8043d0:	68 e0 69 80 00       	push   $0x8069e0
  8043d5:	68 94 01 00 00       	push   $0x194
  8043da:	68 6d 69 80 00       	push   $0x80696d
  8043df:	e8 0f d4 ff ff       	call   8017f3 <_panic>
  8043e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e7:	8b 10                	mov    (%eax),%edx
  8043e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043ec:	89 10                	mov    %edx,(%eax)
  8043ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043f1:	8b 00                	mov    (%eax),%eax
  8043f3:	85 c0                	test   %eax,%eax
  8043f5:	74 0b                	je     804402 <merging+0x2fe>
  8043f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043fa:	8b 00                	mov    (%eax),%eax
  8043fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043ff:	89 50 04             	mov    %edx,0x4(%eax)
  804402:	8b 45 08             	mov    0x8(%ebp),%eax
  804405:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804408:	89 10                	mov    %edx,(%eax)
  80440a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80440d:	8b 55 08             	mov    0x8(%ebp),%edx
  804410:	89 50 04             	mov    %edx,0x4(%eax)
  804413:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804416:	8b 00                	mov    (%eax),%eax
  804418:	85 c0                	test   %eax,%eax
  80441a:	75 08                	jne    804424 <merging+0x320>
  80441c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80441f:	a3 30 70 80 00       	mov    %eax,0x807030
  804424:	a1 38 70 80 00       	mov    0x807038,%eax
  804429:	40                   	inc    %eax
  80442a:	a3 38 70 80 00       	mov    %eax,0x807038
  80442f:	e9 ce 00 00 00       	jmp    804502 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  804434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804438:	74 65                	je     80449f <merging+0x39b>
  80443a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80443e:	75 17                	jne    804457 <merging+0x353>
  804440:	83 ec 04             	sub    $0x4,%esp
  804443:	68 bc 69 80 00       	push   $0x8069bc
  804448:	68 95 01 00 00       	push   $0x195
  80444d:	68 6d 69 80 00       	push   $0x80696d
  804452:	e8 9c d3 ff ff       	call   8017f3 <_panic>
  804457:	8b 15 30 70 80 00    	mov    0x807030,%edx
  80445d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804460:	89 50 04             	mov    %edx,0x4(%eax)
  804463:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804466:	8b 40 04             	mov    0x4(%eax),%eax
  804469:	85 c0                	test   %eax,%eax
  80446b:	74 0c                	je     804479 <merging+0x375>
  80446d:	a1 30 70 80 00       	mov    0x807030,%eax
  804472:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804475:	89 10                	mov    %edx,(%eax)
  804477:	eb 08                	jmp    804481 <merging+0x37d>
  804479:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80447c:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804484:	a3 30 70 80 00       	mov    %eax,0x807030
  804489:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80448c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804492:	a1 38 70 80 00       	mov    0x807038,%eax
  804497:	40                   	inc    %eax
  804498:	a3 38 70 80 00       	mov    %eax,0x807038
  80449d:	eb 63                	jmp    804502 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80449f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8044a3:	75 17                	jne    8044bc <merging+0x3b8>
  8044a5:	83 ec 04             	sub    $0x4,%esp
  8044a8:	68 88 69 80 00       	push   $0x806988
  8044ad:	68 98 01 00 00       	push   $0x198
  8044b2:	68 6d 69 80 00       	push   $0x80696d
  8044b7:	e8 37 d3 ff ff       	call   8017f3 <_panic>
  8044bc:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8044c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c5:	89 10                	mov    %edx,(%eax)
  8044c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044ca:	8b 00                	mov    (%eax),%eax
  8044cc:	85 c0                	test   %eax,%eax
  8044ce:	74 0d                	je     8044dd <merging+0x3d9>
  8044d0:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8044d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8044d8:	89 50 04             	mov    %edx,0x4(%eax)
  8044db:	eb 08                	jmp    8044e5 <merging+0x3e1>
  8044dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044e0:	a3 30 70 80 00       	mov    %eax,0x807030
  8044e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044e8:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8044ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044f7:	a1 38 70 80 00       	mov    0x807038,%eax
  8044fc:	40                   	inc    %eax
  8044fd:	a3 38 70 80 00       	mov    %eax,0x807038
		}
		set_block_data(va, get_block_size(va), 0);
  804502:	83 ec 0c             	sub    $0xc,%esp
  804505:	ff 75 10             	pushl  0x10(%ebp)
  804508:	e8 d6 ed ff ff       	call   8032e3 <get_block_size>
  80450d:	83 c4 10             	add    $0x10,%esp
  804510:	83 ec 04             	sub    $0x4,%esp
  804513:	6a 00                	push   $0x0
  804515:	50                   	push   %eax
  804516:	ff 75 10             	pushl  0x10(%ebp)
  804519:	e8 16 f1 ff ff       	call   803634 <set_block_data>
  80451e:	83 c4 10             	add    $0x10,%esp
	}
}
  804521:	90                   	nop
  804522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804525:	c9                   	leave  
  804526:	c3                   	ret    

00804527 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  804527:	55                   	push   %ebp
  804528:	89 e5                	mov    %esp,%ebp
  80452a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80452d:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804532:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  804535:	a1 30 70 80 00       	mov    0x807030,%eax
  80453a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80453d:	73 1b                	jae    80455a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80453f:	a1 30 70 80 00       	mov    0x807030,%eax
  804544:	83 ec 04             	sub    $0x4,%esp
  804547:	ff 75 08             	pushl  0x8(%ebp)
  80454a:	6a 00                	push   $0x0
  80454c:	50                   	push   %eax
  80454d:	e8 b2 fb ff ff       	call   804104 <merging>
  804552:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804555:	e9 8b 00 00 00       	jmp    8045e5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80455a:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80455f:	3b 45 08             	cmp    0x8(%ebp),%eax
  804562:	76 18                	jbe    80457c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804564:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804569:	83 ec 04             	sub    $0x4,%esp
  80456c:	ff 75 08             	pushl  0x8(%ebp)
  80456f:	50                   	push   %eax
  804570:	6a 00                	push   $0x0
  804572:	e8 8d fb ff ff       	call   804104 <merging>
  804577:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80457a:	eb 69                	jmp    8045e5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80457c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804584:	eb 39                	jmp    8045bf <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  804586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804589:	3b 45 08             	cmp    0x8(%ebp),%eax
  80458c:	73 29                	jae    8045b7 <free_block+0x90>
  80458e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804591:	8b 00                	mov    (%eax),%eax
  804593:	3b 45 08             	cmp    0x8(%ebp),%eax
  804596:	76 1f                	jbe    8045b7 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  804598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80459b:	8b 00                	mov    (%eax),%eax
  80459d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8045a0:	83 ec 04             	sub    $0x4,%esp
  8045a3:	ff 75 08             	pushl  0x8(%ebp)
  8045a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8045a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8045ac:	e8 53 fb ff ff       	call   804104 <merging>
  8045b1:	83 c4 10             	add    $0x10,%esp
			break;
  8045b4:	90                   	nop
		}
	}
}
  8045b5:	eb 2e                	jmp    8045e5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8045b7:	a1 34 70 80 00       	mov    0x807034,%eax
  8045bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045c3:	74 07                	je     8045cc <free_block+0xa5>
  8045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045c8:	8b 00                	mov    (%eax),%eax
  8045ca:	eb 05                	jmp    8045d1 <free_block+0xaa>
  8045cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d1:	a3 34 70 80 00       	mov    %eax,0x807034
  8045d6:	a1 34 70 80 00       	mov    0x807034,%eax
  8045db:	85 c0                	test   %eax,%eax
  8045dd:	75 a7                	jne    804586 <free_block+0x5f>
  8045df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045e3:	75 a1                	jne    804586 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8045e5:	90                   	nop
  8045e6:	c9                   	leave  
  8045e7:	c3                   	ret    

008045e8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8045e8:	55                   	push   %ebp
  8045e9:	89 e5                	mov    %esp,%ebp
  8045eb:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8045ee:	ff 75 08             	pushl  0x8(%ebp)
  8045f1:	e8 ed ec ff ff       	call   8032e3 <get_block_size>
  8045f6:	83 c4 04             	add    $0x4,%esp
  8045f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8045fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  804603:	eb 17                	jmp    80461c <copy_data+0x34>
  804605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80460b:	01 c2                	add    %eax,%edx
  80460d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804610:	8b 45 08             	mov    0x8(%ebp),%eax
  804613:	01 c8                	add    %ecx,%eax
  804615:	8a 00                	mov    (%eax),%al
  804617:	88 02                	mov    %al,(%edx)
  804619:	ff 45 fc             	incl   -0x4(%ebp)
  80461c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80461f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804622:	72 e1                	jb     804605 <copy_data+0x1d>
}
  804624:	90                   	nop
  804625:	c9                   	leave  
  804626:	c3                   	ret    

00804627 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804627:	55                   	push   %ebp
  804628:	89 e5                	mov    %esp,%ebp
  80462a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80462d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804631:	75 23                	jne    804656 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  804633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804637:	74 13                	je     80464c <realloc_block_FF+0x25>
  804639:	83 ec 0c             	sub    $0xc,%esp
  80463c:	ff 75 0c             	pushl  0xc(%ebp)
  80463f:	e8 1f f0 ff ff       	call   803663 <alloc_block_FF>
  804644:	83 c4 10             	add    $0x10,%esp
  804647:	e9 f4 06 00 00       	jmp    804d40 <realloc_block_FF+0x719>
		return NULL;
  80464c:	b8 00 00 00 00       	mov    $0x0,%eax
  804651:	e9 ea 06 00 00       	jmp    804d40 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  804656:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80465a:	75 18                	jne    804674 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80465c:	83 ec 0c             	sub    $0xc,%esp
  80465f:	ff 75 08             	pushl  0x8(%ebp)
  804662:	e8 c0 fe ff ff       	call   804527 <free_block>
  804667:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80466a:	b8 00 00 00 00       	mov    $0x0,%eax
  80466f:	e9 cc 06 00 00       	jmp    804d40 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  804674:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804678:	77 07                	ja     804681 <realloc_block_FF+0x5a>
  80467a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804681:	8b 45 0c             	mov    0xc(%ebp),%eax
  804684:	83 e0 01             	and    $0x1,%eax
  804687:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80468a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80468d:	83 c0 08             	add    $0x8,%eax
  804690:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804693:	83 ec 0c             	sub    $0xc,%esp
  804696:	ff 75 08             	pushl  0x8(%ebp)
  804699:	e8 45 ec ff ff       	call   8032e3 <get_block_size>
  80469e:	83 c4 10             	add    $0x10,%esp
  8046a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8046a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046a7:	83 e8 08             	sub    $0x8,%eax
  8046aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8046ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8046b0:	83 e8 04             	sub    $0x4,%eax
  8046b3:	8b 00                	mov    (%eax),%eax
  8046b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8046b8:	89 c2                	mov    %eax,%edx
  8046ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8046bd:	01 d0                	add    %edx,%eax
  8046bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8046c2:	83 ec 0c             	sub    $0xc,%esp
  8046c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8046c8:	e8 16 ec ff ff       	call   8032e3 <get_block_size>
  8046cd:	83 c4 10             	add    $0x10,%esp
  8046d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8046d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8046d6:	83 e8 08             	sub    $0x8,%eax
  8046d9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8046dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046df:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8046e2:	75 08                	jne    8046ec <realloc_block_FF+0xc5>
	{
		 return va;
  8046e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e7:	e9 54 06 00 00       	jmp    804d40 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8046ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8046f2:	0f 83 e5 03 00 00    	jae    804add <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8046f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046fb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8046fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804701:	83 ec 0c             	sub    $0xc,%esp
  804704:	ff 75 e4             	pushl  -0x1c(%ebp)
  804707:	e8 f0 eb ff ff       	call   8032fc <is_free_block>
  80470c:	83 c4 10             	add    $0x10,%esp
  80470f:	84 c0                	test   %al,%al
  804711:	0f 84 3b 01 00 00    	je     804852 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804717:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80471a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80471d:	01 d0                	add    %edx,%eax
  80471f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804722:	83 ec 04             	sub    $0x4,%esp
  804725:	6a 01                	push   $0x1
  804727:	ff 75 f0             	pushl  -0x10(%ebp)
  80472a:	ff 75 08             	pushl  0x8(%ebp)
  80472d:	e8 02 ef ff ff       	call   803634 <set_block_data>
  804732:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804735:	8b 45 08             	mov    0x8(%ebp),%eax
  804738:	83 e8 04             	sub    $0x4,%eax
  80473b:	8b 00                	mov    (%eax),%eax
  80473d:	83 e0 fe             	and    $0xfffffffe,%eax
  804740:	89 c2                	mov    %eax,%edx
  804742:	8b 45 08             	mov    0x8(%ebp),%eax
  804745:	01 d0                	add    %edx,%eax
  804747:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80474a:	83 ec 04             	sub    $0x4,%esp
  80474d:	6a 00                	push   $0x0
  80474f:	ff 75 cc             	pushl  -0x34(%ebp)
  804752:	ff 75 c8             	pushl  -0x38(%ebp)
  804755:	e8 da ee ff ff       	call   803634 <set_block_data>
  80475a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80475d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804761:	74 06                	je     804769 <realloc_block_FF+0x142>
  804763:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804767:	75 17                	jne    804780 <realloc_block_FF+0x159>
  804769:	83 ec 04             	sub    $0x4,%esp
  80476c:	68 e0 69 80 00       	push   $0x8069e0
  804771:	68 f6 01 00 00       	push   $0x1f6
  804776:	68 6d 69 80 00       	push   $0x80696d
  80477b:	e8 73 d0 ff ff       	call   8017f3 <_panic>
  804780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804783:	8b 10                	mov    (%eax),%edx
  804785:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804788:	89 10                	mov    %edx,(%eax)
  80478a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80478d:	8b 00                	mov    (%eax),%eax
  80478f:	85 c0                	test   %eax,%eax
  804791:	74 0b                	je     80479e <realloc_block_FF+0x177>
  804793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804796:	8b 00                	mov    (%eax),%eax
  804798:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80479b:	89 50 04             	mov    %edx,0x4(%eax)
  80479e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8047a4:	89 10                	mov    %edx,(%eax)
  8047a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047ac:	89 50 04             	mov    %edx,0x4(%eax)
  8047af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047b2:	8b 00                	mov    (%eax),%eax
  8047b4:	85 c0                	test   %eax,%eax
  8047b6:	75 08                	jne    8047c0 <realloc_block_FF+0x199>
  8047b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8047bb:	a3 30 70 80 00       	mov    %eax,0x807030
  8047c0:	a1 38 70 80 00       	mov    0x807038,%eax
  8047c5:	40                   	inc    %eax
  8047c6:	a3 38 70 80 00       	mov    %eax,0x807038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8047cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8047cf:	75 17                	jne    8047e8 <realloc_block_FF+0x1c1>
  8047d1:	83 ec 04             	sub    $0x4,%esp
  8047d4:	68 4f 69 80 00       	push   $0x80694f
  8047d9:	68 f7 01 00 00       	push   $0x1f7
  8047de:	68 6d 69 80 00       	push   $0x80696d
  8047e3:	e8 0b d0 ff ff       	call   8017f3 <_panic>
  8047e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047eb:	8b 00                	mov    (%eax),%eax
  8047ed:	85 c0                	test   %eax,%eax
  8047ef:	74 10                	je     804801 <realloc_block_FF+0x1da>
  8047f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047f4:	8b 00                	mov    (%eax),%eax
  8047f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047f9:	8b 52 04             	mov    0x4(%edx),%edx
  8047fc:	89 50 04             	mov    %edx,0x4(%eax)
  8047ff:	eb 0b                	jmp    80480c <realloc_block_FF+0x1e5>
  804801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804804:	8b 40 04             	mov    0x4(%eax),%eax
  804807:	a3 30 70 80 00       	mov    %eax,0x807030
  80480c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80480f:	8b 40 04             	mov    0x4(%eax),%eax
  804812:	85 c0                	test   %eax,%eax
  804814:	74 0f                	je     804825 <realloc_block_FF+0x1fe>
  804816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804819:	8b 40 04             	mov    0x4(%eax),%eax
  80481c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80481f:	8b 12                	mov    (%edx),%edx
  804821:	89 10                	mov    %edx,(%eax)
  804823:	eb 0a                	jmp    80482f <realloc_block_FF+0x208>
  804825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804828:	8b 00                	mov    (%eax),%eax
  80482a:	a3 2c 70 80 00       	mov    %eax,0x80702c
  80482f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804832:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80483b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804842:	a1 38 70 80 00       	mov    0x807038,%eax
  804847:	48                   	dec    %eax
  804848:	a3 38 70 80 00       	mov    %eax,0x807038
  80484d:	e9 83 02 00 00       	jmp    804ad5 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  804852:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804856:	0f 86 69 02 00 00    	jbe    804ac5 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80485c:	83 ec 04             	sub    $0x4,%esp
  80485f:	6a 01                	push   $0x1
  804861:	ff 75 f0             	pushl  -0x10(%ebp)
  804864:	ff 75 08             	pushl  0x8(%ebp)
  804867:	e8 c8 ed ff ff       	call   803634 <set_block_data>
  80486c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80486f:	8b 45 08             	mov    0x8(%ebp),%eax
  804872:	83 e8 04             	sub    $0x4,%eax
  804875:	8b 00                	mov    (%eax),%eax
  804877:	83 e0 fe             	and    $0xfffffffe,%eax
  80487a:	89 c2                	mov    %eax,%edx
  80487c:	8b 45 08             	mov    0x8(%ebp),%eax
  80487f:	01 d0                	add    %edx,%eax
  804881:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804884:	a1 38 70 80 00       	mov    0x807038,%eax
  804889:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80488c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804890:	75 68                	jne    8048fa <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804892:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804896:	75 17                	jne    8048af <realloc_block_FF+0x288>
  804898:	83 ec 04             	sub    $0x4,%esp
  80489b:	68 88 69 80 00       	push   $0x806988
  8048a0:	68 06 02 00 00       	push   $0x206
  8048a5:	68 6d 69 80 00       	push   $0x80696d
  8048aa:	e8 44 cf ff ff       	call   8017f3 <_panic>
  8048af:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  8048b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048b8:	89 10                	mov    %edx,(%eax)
  8048ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048bd:	8b 00                	mov    (%eax),%eax
  8048bf:	85 c0                	test   %eax,%eax
  8048c1:	74 0d                	je     8048d0 <realloc_block_FF+0x2a9>
  8048c3:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8048c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048cb:	89 50 04             	mov    %edx,0x4(%eax)
  8048ce:	eb 08                	jmp    8048d8 <realloc_block_FF+0x2b1>
  8048d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048d3:	a3 30 70 80 00       	mov    %eax,0x807030
  8048d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048db:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8048e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048ea:	a1 38 70 80 00       	mov    0x807038,%eax
  8048ef:	40                   	inc    %eax
  8048f0:	a3 38 70 80 00       	mov    %eax,0x807038
  8048f5:	e9 b0 01 00 00       	jmp    804aaa <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8048fa:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8048ff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804902:	76 68                	jbe    80496c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804904:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804908:	75 17                	jne    804921 <realloc_block_FF+0x2fa>
  80490a:	83 ec 04             	sub    $0x4,%esp
  80490d:	68 88 69 80 00       	push   $0x806988
  804912:	68 0b 02 00 00       	push   $0x20b
  804917:	68 6d 69 80 00       	push   $0x80696d
  80491c:	e8 d2 ce ff ff       	call   8017f3 <_panic>
  804921:	8b 15 2c 70 80 00    	mov    0x80702c,%edx
  804927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80492a:	89 10                	mov    %edx,(%eax)
  80492c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80492f:	8b 00                	mov    (%eax),%eax
  804931:	85 c0                	test   %eax,%eax
  804933:	74 0d                	je     804942 <realloc_block_FF+0x31b>
  804935:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80493a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80493d:	89 50 04             	mov    %edx,0x4(%eax)
  804940:	eb 08                	jmp    80494a <realloc_block_FF+0x323>
  804942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804945:	a3 30 70 80 00       	mov    %eax,0x807030
  80494a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80494d:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804952:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804955:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80495c:	a1 38 70 80 00       	mov    0x807038,%eax
  804961:	40                   	inc    %eax
  804962:	a3 38 70 80 00       	mov    %eax,0x807038
  804967:	e9 3e 01 00 00       	jmp    804aaa <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80496c:	a1 2c 70 80 00       	mov    0x80702c,%eax
  804971:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804974:	73 68                	jae    8049de <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804976:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80497a:	75 17                	jne    804993 <realloc_block_FF+0x36c>
  80497c:	83 ec 04             	sub    $0x4,%esp
  80497f:	68 bc 69 80 00       	push   $0x8069bc
  804984:	68 10 02 00 00       	push   $0x210
  804989:	68 6d 69 80 00       	push   $0x80696d
  80498e:	e8 60 ce ff ff       	call   8017f3 <_panic>
  804993:	8b 15 30 70 80 00    	mov    0x807030,%edx
  804999:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80499c:	89 50 04             	mov    %edx,0x4(%eax)
  80499f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a2:	8b 40 04             	mov    0x4(%eax),%eax
  8049a5:	85 c0                	test   %eax,%eax
  8049a7:	74 0c                	je     8049b5 <realloc_block_FF+0x38e>
  8049a9:	a1 30 70 80 00       	mov    0x807030,%eax
  8049ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049b1:	89 10                	mov    %edx,(%eax)
  8049b3:	eb 08                	jmp    8049bd <realloc_block_FF+0x396>
  8049b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049b8:	a3 2c 70 80 00       	mov    %eax,0x80702c
  8049bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049c0:	a3 30 70 80 00       	mov    %eax,0x807030
  8049c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049ce:	a1 38 70 80 00       	mov    0x807038,%eax
  8049d3:	40                   	inc    %eax
  8049d4:	a3 38 70 80 00       	mov    %eax,0x807038
  8049d9:	e9 cc 00 00 00       	jmp    804aaa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8049de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8049e5:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8049ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8049ed:	e9 8a 00 00 00       	jmp    804a7c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049f5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8049f8:	73 7a                	jae    804a74 <realloc_block_FF+0x44d>
  8049fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049fd:	8b 00                	mov    (%eax),%eax
  8049ff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804a02:	73 70                	jae    804a74 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804a08:	74 06                	je     804a10 <realloc_block_FF+0x3e9>
  804a0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804a0e:	75 17                	jne    804a27 <realloc_block_FF+0x400>
  804a10:	83 ec 04             	sub    $0x4,%esp
  804a13:	68 e0 69 80 00       	push   $0x8069e0
  804a18:	68 1a 02 00 00       	push   $0x21a
  804a1d:	68 6d 69 80 00       	push   $0x80696d
  804a22:	e8 cc cd ff ff       	call   8017f3 <_panic>
  804a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a2a:	8b 10                	mov    (%eax),%edx
  804a2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a2f:	89 10                	mov    %edx,(%eax)
  804a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a34:	8b 00                	mov    (%eax),%eax
  804a36:	85 c0                	test   %eax,%eax
  804a38:	74 0b                	je     804a45 <realloc_block_FF+0x41e>
  804a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a3d:	8b 00                	mov    (%eax),%eax
  804a3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a42:	89 50 04             	mov    %edx,0x4(%eax)
  804a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804a4b:	89 10                	mov    %edx,(%eax)
  804a4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804a53:	89 50 04             	mov    %edx,0x4(%eax)
  804a56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a59:	8b 00                	mov    (%eax),%eax
  804a5b:	85 c0                	test   %eax,%eax
  804a5d:	75 08                	jne    804a67 <realloc_block_FF+0x440>
  804a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804a62:	a3 30 70 80 00       	mov    %eax,0x807030
  804a67:	a1 38 70 80 00       	mov    0x807038,%eax
  804a6c:	40                   	inc    %eax
  804a6d:	a3 38 70 80 00       	mov    %eax,0x807038
							break;
  804a72:	eb 36                	jmp    804aaa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804a74:	a1 34 70 80 00       	mov    0x807034,%eax
  804a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804a80:	74 07                	je     804a89 <realloc_block_FF+0x462>
  804a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a85:	8b 00                	mov    (%eax),%eax
  804a87:	eb 05                	jmp    804a8e <realloc_block_FF+0x467>
  804a89:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8e:	a3 34 70 80 00       	mov    %eax,0x807034
  804a93:	a1 34 70 80 00       	mov    0x807034,%eax
  804a98:	85 c0                	test   %eax,%eax
  804a9a:	0f 85 52 ff ff ff    	jne    8049f2 <realloc_block_FF+0x3cb>
  804aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804aa4:	0f 85 48 ff ff ff    	jne    8049f2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804aaa:	83 ec 04             	sub    $0x4,%esp
  804aad:	6a 00                	push   $0x0
  804aaf:	ff 75 d8             	pushl  -0x28(%ebp)
  804ab2:	ff 75 d4             	pushl  -0x2c(%ebp)
  804ab5:	e8 7a eb ff ff       	call   803634 <set_block_data>
  804aba:	83 c4 10             	add    $0x10,%esp
				return va;
  804abd:	8b 45 08             	mov    0x8(%ebp),%eax
  804ac0:	e9 7b 02 00 00       	jmp    804d40 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804ac5:	83 ec 0c             	sub    $0xc,%esp
  804ac8:	68 5d 6a 80 00       	push   $0x806a5d
  804acd:	e8 de cf ff ff       	call   801ab0 <cprintf>
  804ad2:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  804ad8:	e9 63 02 00 00       	jmp    804d40 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804add:	8b 45 0c             	mov    0xc(%ebp),%eax
  804ae0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804ae3:	0f 86 4d 02 00 00    	jbe    804d36 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804ae9:	83 ec 0c             	sub    $0xc,%esp
  804aec:	ff 75 e4             	pushl  -0x1c(%ebp)
  804aef:	e8 08 e8 ff ff       	call   8032fc <is_free_block>
  804af4:	83 c4 10             	add    $0x10,%esp
  804af7:	84 c0                	test   %al,%al
  804af9:	0f 84 37 02 00 00    	je     804d36 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b02:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804b05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804b08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804b0b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804b0e:	76 38                	jbe    804b48 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804b10:	83 ec 0c             	sub    $0xc,%esp
  804b13:	ff 75 08             	pushl  0x8(%ebp)
  804b16:	e8 0c fa ff ff       	call   804527 <free_block>
  804b1b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804b1e:	83 ec 0c             	sub    $0xc,%esp
  804b21:	ff 75 0c             	pushl  0xc(%ebp)
  804b24:	e8 3a eb ff ff       	call   803663 <alloc_block_FF>
  804b29:	83 c4 10             	add    $0x10,%esp
  804b2c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804b2f:	83 ec 08             	sub    $0x8,%esp
  804b32:	ff 75 c0             	pushl  -0x40(%ebp)
  804b35:	ff 75 08             	pushl  0x8(%ebp)
  804b38:	e8 ab fa ff ff       	call   8045e8 <copy_data>
  804b3d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804b40:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804b43:	e9 f8 01 00 00       	jmp    804d40 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804b4b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804b4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804b51:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804b55:	0f 87 a0 00 00 00    	ja     804bfb <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804b5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b5f:	75 17                	jne    804b78 <realloc_block_FF+0x551>
  804b61:	83 ec 04             	sub    $0x4,%esp
  804b64:	68 4f 69 80 00       	push   $0x80694f
  804b69:	68 38 02 00 00       	push   $0x238
  804b6e:	68 6d 69 80 00       	push   $0x80696d
  804b73:	e8 7b cc ff ff       	call   8017f3 <_panic>
  804b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b7b:	8b 00                	mov    (%eax),%eax
  804b7d:	85 c0                	test   %eax,%eax
  804b7f:	74 10                	je     804b91 <realloc_block_FF+0x56a>
  804b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b84:	8b 00                	mov    (%eax),%eax
  804b86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b89:	8b 52 04             	mov    0x4(%edx),%edx
  804b8c:	89 50 04             	mov    %edx,0x4(%eax)
  804b8f:	eb 0b                	jmp    804b9c <realloc_block_FF+0x575>
  804b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b94:	8b 40 04             	mov    0x4(%eax),%eax
  804b97:	a3 30 70 80 00       	mov    %eax,0x807030
  804b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b9f:	8b 40 04             	mov    0x4(%eax),%eax
  804ba2:	85 c0                	test   %eax,%eax
  804ba4:	74 0f                	je     804bb5 <realloc_block_FF+0x58e>
  804ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ba9:	8b 40 04             	mov    0x4(%eax),%eax
  804bac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804baf:	8b 12                	mov    (%edx),%edx
  804bb1:	89 10                	mov    %edx,(%eax)
  804bb3:	eb 0a                	jmp    804bbf <realloc_block_FF+0x598>
  804bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bb8:	8b 00                	mov    (%eax),%eax
  804bba:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804bd2:	a1 38 70 80 00       	mov    0x807038,%eax
  804bd7:	48                   	dec    %eax
  804bd8:	a3 38 70 80 00       	mov    %eax,0x807038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804bdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804be3:	01 d0                	add    %edx,%eax
  804be5:	83 ec 04             	sub    $0x4,%esp
  804be8:	6a 01                	push   $0x1
  804bea:	50                   	push   %eax
  804beb:	ff 75 08             	pushl  0x8(%ebp)
  804bee:	e8 41 ea ff ff       	call   803634 <set_block_data>
  804bf3:	83 c4 10             	add    $0x10,%esp
  804bf6:	e9 36 01 00 00       	jmp    804d31 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804bfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804bfe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804c01:	01 d0                	add    %edx,%eax
  804c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804c06:	83 ec 04             	sub    $0x4,%esp
  804c09:	6a 01                	push   $0x1
  804c0b:	ff 75 f0             	pushl  -0x10(%ebp)
  804c0e:	ff 75 08             	pushl  0x8(%ebp)
  804c11:	e8 1e ea ff ff       	call   803634 <set_block_data>
  804c16:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804c19:	8b 45 08             	mov    0x8(%ebp),%eax
  804c1c:	83 e8 04             	sub    $0x4,%eax
  804c1f:	8b 00                	mov    (%eax),%eax
  804c21:	83 e0 fe             	and    $0xfffffffe,%eax
  804c24:	89 c2                	mov    %eax,%edx
  804c26:	8b 45 08             	mov    0x8(%ebp),%eax
  804c29:	01 d0                	add    %edx,%eax
  804c2b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804c2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c32:	74 06                	je     804c3a <realloc_block_FF+0x613>
  804c34:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804c38:	75 17                	jne    804c51 <realloc_block_FF+0x62a>
  804c3a:	83 ec 04             	sub    $0x4,%esp
  804c3d:	68 e0 69 80 00       	push   $0x8069e0
  804c42:	68 44 02 00 00       	push   $0x244
  804c47:	68 6d 69 80 00       	push   $0x80696d
  804c4c:	e8 a2 cb ff ff       	call   8017f3 <_panic>
  804c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c54:	8b 10                	mov    (%eax),%edx
  804c56:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804c59:	89 10                	mov    %edx,(%eax)
  804c5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804c5e:	8b 00                	mov    (%eax),%eax
  804c60:	85 c0                	test   %eax,%eax
  804c62:	74 0b                	je     804c6f <realloc_block_FF+0x648>
  804c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c67:	8b 00                	mov    (%eax),%eax
  804c69:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804c6c:	89 50 04             	mov    %edx,0x4(%eax)
  804c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c72:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804c75:	89 10                	mov    %edx,(%eax)
  804c77:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c7d:	89 50 04             	mov    %edx,0x4(%eax)
  804c80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804c83:	8b 00                	mov    (%eax),%eax
  804c85:	85 c0                	test   %eax,%eax
  804c87:	75 08                	jne    804c91 <realloc_block_FF+0x66a>
  804c89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804c8c:	a3 30 70 80 00       	mov    %eax,0x807030
  804c91:	a1 38 70 80 00       	mov    0x807038,%eax
  804c96:	40                   	inc    %eax
  804c97:	a3 38 70 80 00       	mov    %eax,0x807038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804c9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ca0:	75 17                	jne    804cb9 <realloc_block_FF+0x692>
  804ca2:	83 ec 04             	sub    $0x4,%esp
  804ca5:	68 4f 69 80 00       	push   $0x80694f
  804caa:	68 45 02 00 00       	push   $0x245
  804caf:	68 6d 69 80 00       	push   $0x80696d
  804cb4:	e8 3a cb ff ff       	call   8017f3 <_panic>
  804cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cbc:	8b 00                	mov    (%eax),%eax
  804cbe:	85 c0                	test   %eax,%eax
  804cc0:	74 10                	je     804cd2 <realloc_block_FF+0x6ab>
  804cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cc5:	8b 00                	mov    (%eax),%eax
  804cc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804cca:	8b 52 04             	mov    0x4(%edx),%edx
  804ccd:	89 50 04             	mov    %edx,0x4(%eax)
  804cd0:	eb 0b                	jmp    804cdd <realloc_block_FF+0x6b6>
  804cd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cd5:	8b 40 04             	mov    0x4(%eax),%eax
  804cd8:	a3 30 70 80 00       	mov    %eax,0x807030
  804cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ce0:	8b 40 04             	mov    0x4(%eax),%eax
  804ce3:	85 c0                	test   %eax,%eax
  804ce5:	74 0f                	je     804cf6 <realloc_block_FF+0x6cf>
  804ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cea:	8b 40 04             	mov    0x4(%eax),%eax
  804ced:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804cf0:	8b 12                	mov    (%edx),%edx
  804cf2:	89 10                	mov    %edx,(%eax)
  804cf4:	eb 0a                	jmp    804d00 <realloc_block_FF+0x6d9>
  804cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cf9:	8b 00                	mov    (%eax),%eax
  804cfb:	a3 2c 70 80 00       	mov    %eax,0x80702c
  804d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d13:	a1 38 70 80 00       	mov    0x807038,%eax
  804d18:	48                   	dec    %eax
  804d19:	a3 38 70 80 00       	mov    %eax,0x807038
				set_block_data(next_new_va, remaining_size, 0);
  804d1e:	83 ec 04             	sub    $0x4,%esp
  804d21:	6a 00                	push   $0x0
  804d23:	ff 75 bc             	pushl  -0x44(%ebp)
  804d26:	ff 75 b8             	pushl  -0x48(%ebp)
  804d29:	e8 06 e9 ff ff       	call   803634 <set_block_data>
  804d2e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804d31:	8b 45 08             	mov    0x8(%ebp),%eax
  804d34:	eb 0a                	jmp    804d40 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804d36:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804d40:	c9                   	leave  
  804d41:	c3                   	ret    

00804d42 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804d42:	55                   	push   %ebp
  804d43:	89 e5                	mov    %esp,%ebp
  804d45:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804d48:	83 ec 04             	sub    $0x4,%esp
  804d4b:	68 64 6a 80 00       	push   $0x806a64
  804d50:	68 58 02 00 00       	push   $0x258
  804d55:	68 6d 69 80 00       	push   $0x80696d
  804d5a:	e8 94 ca ff ff       	call   8017f3 <_panic>

00804d5f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804d5f:	55                   	push   %ebp
  804d60:	89 e5                	mov    %esp,%ebp
  804d62:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804d65:	83 ec 04             	sub    $0x4,%esp
  804d68:	68 8c 6a 80 00       	push   $0x806a8c
  804d6d:	68 61 02 00 00       	push   $0x261
  804d72:	68 6d 69 80 00       	push   $0x80696d
  804d77:	e8 77 ca ff ff       	call   8017f3 <_panic>

00804d7c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804d7c:	55                   	push   %ebp
  804d7d:	89 e5                	mov    %esp,%ebp
  804d7f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804d82:	8b 55 08             	mov    0x8(%ebp),%edx
  804d85:	89 d0                	mov    %edx,%eax
  804d87:	c1 e0 02             	shl    $0x2,%eax
  804d8a:	01 d0                	add    %edx,%eax
  804d8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804d93:	01 d0                	add    %edx,%eax
  804d95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804d9c:	01 d0                	add    %edx,%eax
  804d9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804da5:	01 d0                	add    %edx,%eax
  804da7:	c1 e0 04             	shl    $0x4,%eax
  804daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804dad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804db4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804db7:	83 ec 0c             	sub    $0xc,%esp
  804dba:	50                   	push   %eax
  804dbb:	e8 2f e2 ff ff       	call   802fef <sys_get_virtual_time>
  804dc0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804dc3:	eb 41                	jmp    804e06 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804dc5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804dc8:	83 ec 0c             	sub    $0xc,%esp
  804dcb:	50                   	push   %eax
  804dcc:	e8 1e e2 ff ff       	call   802fef <sys_get_virtual_time>
  804dd1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804dd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804dda:	29 c2                	sub    %eax,%edx
  804ddc:	89 d0                	mov    %edx,%eax
  804dde:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804de7:	89 d1                	mov    %edx,%ecx
  804de9:	29 c1                	sub    %eax,%ecx
  804deb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804df1:	39 c2                	cmp    %eax,%edx
  804df3:	0f 97 c0             	seta   %al
  804df6:	0f b6 c0             	movzbl %al,%eax
  804df9:	29 c1                	sub    %eax,%ecx
  804dfb:	89 c8                	mov    %ecx,%eax
  804dfd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804e00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  804e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804e0c:	72 b7                	jb     804dc5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804e0e:	90                   	nop
  804e0f:	c9                   	leave  
  804e10:	c3                   	ret    

00804e11 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804e11:	55                   	push   %ebp
  804e12:	89 e5                	mov    %esp,%ebp
  804e14:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804e17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804e1e:	eb 03                	jmp    804e23 <busy_wait+0x12>
  804e20:	ff 45 fc             	incl   -0x4(%ebp)
  804e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804e26:	3b 45 08             	cmp    0x8(%ebp),%eax
  804e29:	72 f5                	jb     804e20 <busy_wait+0xf>
	return i;
  804e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804e2e:	c9                   	leave  
  804e2f:	c3                   	ret    

00804e30 <__udivdi3>:
  804e30:	55                   	push   %ebp
  804e31:	57                   	push   %edi
  804e32:	56                   	push   %esi
  804e33:	53                   	push   %ebx
  804e34:	83 ec 1c             	sub    $0x1c,%esp
  804e37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804e3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804e3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804e43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804e47:	89 ca                	mov    %ecx,%edx
  804e49:	89 f8                	mov    %edi,%eax
  804e4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804e4f:	85 f6                	test   %esi,%esi
  804e51:	75 2d                	jne    804e80 <__udivdi3+0x50>
  804e53:	39 cf                	cmp    %ecx,%edi
  804e55:	77 65                	ja     804ebc <__udivdi3+0x8c>
  804e57:	89 fd                	mov    %edi,%ebp
  804e59:	85 ff                	test   %edi,%edi
  804e5b:	75 0b                	jne    804e68 <__udivdi3+0x38>
  804e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  804e62:	31 d2                	xor    %edx,%edx
  804e64:	f7 f7                	div    %edi
  804e66:	89 c5                	mov    %eax,%ebp
  804e68:	31 d2                	xor    %edx,%edx
  804e6a:	89 c8                	mov    %ecx,%eax
  804e6c:	f7 f5                	div    %ebp
  804e6e:	89 c1                	mov    %eax,%ecx
  804e70:	89 d8                	mov    %ebx,%eax
  804e72:	f7 f5                	div    %ebp
  804e74:	89 cf                	mov    %ecx,%edi
  804e76:	89 fa                	mov    %edi,%edx
  804e78:	83 c4 1c             	add    $0x1c,%esp
  804e7b:	5b                   	pop    %ebx
  804e7c:	5e                   	pop    %esi
  804e7d:	5f                   	pop    %edi
  804e7e:	5d                   	pop    %ebp
  804e7f:	c3                   	ret    
  804e80:	39 ce                	cmp    %ecx,%esi
  804e82:	77 28                	ja     804eac <__udivdi3+0x7c>
  804e84:	0f bd fe             	bsr    %esi,%edi
  804e87:	83 f7 1f             	xor    $0x1f,%edi
  804e8a:	75 40                	jne    804ecc <__udivdi3+0x9c>
  804e8c:	39 ce                	cmp    %ecx,%esi
  804e8e:	72 0a                	jb     804e9a <__udivdi3+0x6a>
  804e90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804e94:	0f 87 9e 00 00 00    	ja     804f38 <__udivdi3+0x108>
  804e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  804e9f:	89 fa                	mov    %edi,%edx
  804ea1:	83 c4 1c             	add    $0x1c,%esp
  804ea4:	5b                   	pop    %ebx
  804ea5:	5e                   	pop    %esi
  804ea6:	5f                   	pop    %edi
  804ea7:	5d                   	pop    %ebp
  804ea8:	c3                   	ret    
  804ea9:	8d 76 00             	lea    0x0(%esi),%esi
  804eac:	31 ff                	xor    %edi,%edi
  804eae:	31 c0                	xor    %eax,%eax
  804eb0:	89 fa                	mov    %edi,%edx
  804eb2:	83 c4 1c             	add    $0x1c,%esp
  804eb5:	5b                   	pop    %ebx
  804eb6:	5e                   	pop    %esi
  804eb7:	5f                   	pop    %edi
  804eb8:	5d                   	pop    %ebp
  804eb9:	c3                   	ret    
  804eba:	66 90                	xchg   %ax,%ax
  804ebc:	89 d8                	mov    %ebx,%eax
  804ebe:	f7 f7                	div    %edi
  804ec0:	31 ff                	xor    %edi,%edi
  804ec2:	89 fa                	mov    %edi,%edx
  804ec4:	83 c4 1c             	add    $0x1c,%esp
  804ec7:	5b                   	pop    %ebx
  804ec8:	5e                   	pop    %esi
  804ec9:	5f                   	pop    %edi
  804eca:	5d                   	pop    %ebp
  804ecb:	c3                   	ret    
  804ecc:	bd 20 00 00 00       	mov    $0x20,%ebp
  804ed1:	89 eb                	mov    %ebp,%ebx
  804ed3:	29 fb                	sub    %edi,%ebx
  804ed5:	89 f9                	mov    %edi,%ecx
  804ed7:	d3 e6                	shl    %cl,%esi
  804ed9:	89 c5                	mov    %eax,%ebp
  804edb:	88 d9                	mov    %bl,%cl
  804edd:	d3 ed                	shr    %cl,%ebp
  804edf:	89 e9                	mov    %ebp,%ecx
  804ee1:	09 f1                	or     %esi,%ecx
  804ee3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804ee7:	89 f9                	mov    %edi,%ecx
  804ee9:	d3 e0                	shl    %cl,%eax
  804eeb:	89 c5                	mov    %eax,%ebp
  804eed:	89 d6                	mov    %edx,%esi
  804eef:	88 d9                	mov    %bl,%cl
  804ef1:	d3 ee                	shr    %cl,%esi
  804ef3:	89 f9                	mov    %edi,%ecx
  804ef5:	d3 e2                	shl    %cl,%edx
  804ef7:	8b 44 24 08          	mov    0x8(%esp),%eax
  804efb:	88 d9                	mov    %bl,%cl
  804efd:	d3 e8                	shr    %cl,%eax
  804eff:	09 c2                	or     %eax,%edx
  804f01:	89 d0                	mov    %edx,%eax
  804f03:	89 f2                	mov    %esi,%edx
  804f05:	f7 74 24 0c          	divl   0xc(%esp)
  804f09:	89 d6                	mov    %edx,%esi
  804f0b:	89 c3                	mov    %eax,%ebx
  804f0d:	f7 e5                	mul    %ebp
  804f0f:	39 d6                	cmp    %edx,%esi
  804f11:	72 19                	jb     804f2c <__udivdi3+0xfc>
  804f13:	74 0b                	je     804f20 <__udivdi3+0xf0>
  804f15:	89 d8                	mov    %ebx,%eax
  804f17:	31 ff                	xor    %edi,%edi
  804f19:	e9 58 ff ff ff       	jmp    804e76 <__udivdi3+0x46>
  804f1e:	66 90                	xchg   %ax,%ax
  804f20:	8b 54 24 08          	mov    0x8(%esp),%edx
  804f24:	89 f9                	mov    %edi,%ecx
  804f26:	d3 e2                	shl    %cl,%edx
  804f28:	39 c2                	cmp    %eax,%edx
  804f2a:	73 e9                	jae    804f15 <__udivdi3+0xe5>
  804f2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804f2f:	31 ff                	xor    %edi,%edi
  804f31:	e9 40 ff ff ff       	jmp    804e76 <__udivdi3+0x46>
  804f36:	66 90                	xchg   %ax,%ax
  804f38:	31 c0                	xor    %eax,%eax
  804f3a:	e9 37 ff ff ff       	jmp    804e76 <__udivdi3+0x46>
  804f3f:	90                   	nop

00804f40 <__umoddi3>:
  804f40:	55                   	push   %ebp
  804f41:	57                   	push   %edi
  804f42:	56                   	push   %esi
  804f43:	53                   	push   %ebx
  804f44:	83 ec 1c             	sub    $0x1c,%esp
  804f47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804f4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  804f4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804f53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804f57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804f5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804f5f:	89 f3                	mov    %esi,%ebx
  804f61:	89 fa                	mov    %edi,%edx
  804f63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804f67:	89 34 24             	mov    %esi,(%esp)
  804f6a:	85 c0                	test   %eax,%eax
  804f6c:	75 1a                	jne    804f88 <__umoddi3+0x48>
  804f6e:	39 f7                	cmp    %esi,%edi
  804f70:	0f 86 a2 00 00 00    	jbe    805018 <__umoddi3+0xd8>
  804f76:	89 c8                	mov    %ecx,%eax
  804f78:	89 f2                	mov    %esi,%edx
  804f7a:	f7 f7                	div    %edi
  804f7c:	89 d0                	mov    %edx,%eax
  804f7e:	31 d2                	xor    %edx,%edx
  804f80:	83 c4 1c             	add    $0x1c,%esp
  804f83:	5b                   	pop    %ebx
  804f84:	5e                   	pop    %esi
  804f85:	5f                   	pop    %edi
  804f86:	5d                   	pop    %ebp
  804f87:	c3                   	ret    
  804f88:	39 f0                	cmp    %esi,%eax
  804f8a:	0f 87 ac 00 00 00    	ja     80503c <__umoddi3+0xfc>
  804f90:	0f bd e8             	bsr    %eax,%ebp
  804f93:	83 f5 1f             	xor    $0x1f,%ebp
  804f96:	0f 84 ac 00 00 00    	je     805048 <__umoddi3+0x108>
  804f9c:	bf 20 00 00 00       	mov    $0x20,%edi
  804fa1:	29 ef                	sub    %ebp,%edi
  804fa3:	89 fe                	mov    %edi,%esi
  804fa5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804fa9:	89 e9                	mov    %ebp,%ecx
  804fab:	d3 e0                	shl    %cl,%eax
  804fad:	89 d7                	mov    %edx,%edi
  804faf:	89 f1                	mov    %esi,%ecx
  804fb1:	d3 ef                	shr    %cl,%edi
  804fb3:	09 c7                	or     %eax,%edi
  804fb5:	89 e9                	mov    %ebp,%ecx
  804fb7:	d3 e2                	shl    %cl,%edx
  804fb9:	89 14 24             	mov    %edx,(%esp)
  804fbc:	89 d8                	mov    %ebx,%eax
  804fbe:	d3 e0                	shl    %cl,%eax
  804fc0:	89 c2                	mov    %eax,%edx
  804fc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  804fc6:	d3 e0                	shl    %cl,%eax
  804fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  804fcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  804fd0:	89 f1                	mov    %esi,%ecx
  804fd2:	d3 e8                	shr    %cl,%eax
  804fd4:	09 d0                	or     %edx,%eax
  804fd6:	d3 eb                	shr    %cl,%ebx
  804fd8:	89 da                	mov    %ebx,%edx
  804fda:	f7 f7                	div    %edi
  804fdc:	89 d3                	mov    %edx,%ebx
  804fde:	f7 24 24             	mull   (%esp)
  804fe1:	89 c6                	mov    %eax,%esi
  804fe3:	89 d1                	mov    %edx,%ecx
  804fe5:	39 d3                	cmp    %edx,%ebx
  804fe7:	0f 82 87 00 00 00    	jb     805074 <__umoddi3+0x134>
  804fed:	0f 84 91 00 00 00    	je     805084 <__umoddi3+0x144>
  804ff3:	8b 54 24 04          	mov    0x4(%esp),%edx
  804ff7:	29 f2                	sub    %esi,%edx
  804ff9:	19 cb                	sbb    %ecx,%ebx
  804ffb:	89 d8                	mov    %ebx,%eax
  804ffd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805001:	d3 e0                	shl    %cl,%eax
  805003:	89 e9                	mov    %ebp,%ecx
  805005:	d3 ea                	shr    %cl,%edx
  805007:	09 d0                	or     %edx,%eax
  805009:	89 e9                	mov    %ebp,%ecx
  80500b:	d3 eb                	shr    %cl,%ebx
  80500d:	89 da                	mov    %ebx,%edx
  80500f:	83 c4 1c             	add    $0x1c,%esp
  805012:	5b                   	pop    %ebx
  805013:	5e                   	pop    %esi
  805014:	5f                   	pop    %edi
  805015:	5d                   	pop    %ebp
  805016:	c3                   	ret    
  805017:	90                   	nop
  805018:	89 fd                	mov    %edi,%ebp
  80501a:	85 ff                	test   %edi,%edi
  80501c:	75 0b                	jne    805029 <__umoddi3+0xe9>
  80501e:	b8 01 00 00 00       	mov    $0x1,%eax
  805023:	31 d2                	xor    %edx,%edx
  805025:	f7 f7                	div    %edi
  805027:	89 c5                	mov    %eax,%ebp
  805029:	89 f0                	mov    %esi,%eax
  80502b:	31 d2                	xor    %edx,%edx
  80502d:	f7 f5                	div    %ebp
  80502f:	89 c8                	mov    %ecx,%eax
  805031:	f7 f5                	div    %ebp
  805033:	89 d0                	mov    %edx,%eax
  805035:	e9 44 ff ff ff       	jmp    804f7e <__umoddi3+0x3e>
  80503a:	66 90                	xchg   %ax,%ax
  80503c:	89 c8                	mov    %ecx,%eax
  80503e:	89 f2                	mov    %esi,%edx
  805040:	83 c4 1c             	add    $0x1c,%esp
  805043:	5b                   	pop    %ebx
  805044:	5e                   	pop    %esi
  805045:	5f                   	pop    %edi
  805046:	5d                   	pop    %ebp
  805047:	c3                   	ret    
  805048:	3b 04 24             	cmp    (%esp),%eax
  80504b:	72 06                	jb     805053 <__umoddi3+0x113>
  80504d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805051:	77 0f                	ja     805062 <__umoddi3+0x122>
  805053:	89 f2                	mov    %esi,%edx
  805055:	29 f9                	sub    %edi,%ecx
  805057:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80505b:	89 14 24             	mov    %edx,(%esp)
  80505e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805062:	8b 44 24 04          	mov    0x4(%esp),%eax
  805066:	8b 14 24             	mov    (%esp),%edx
  805069:	83 c4 1c             	add    $0x1c,%esp
  80506c:	5b                   	pop    %ebx
  80506d:	5e                   	pop    %esi
  80506e:	5f                   	pop    %edi
  80506f:	5d                   	pop    %ebp
  805070:	c3                   	ret    
  805071:	8d 76 00             	lea    0x0(%esi),%esi
  805074:	2b 04 24             	sub    (%esp),%eax
  805077:	19 fa                	sbb    %edi,%edx
  805079:	89 d1                	mov    %edx,%ecx
  80507b:	89 c6                	mov    %eax,%esi
  80507d:	e9 71 ff ff ff       	jmp    804ff3 <__umoddi3+0xb3>
  805082:	66 90                	xchg   %ax,%ax
  805084:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805088:	72 ea                	jb     805074 <__umoddi3+0x134>
  80508a:	89 d9                	mov    %ebx,%ecx
  80508c:	e9 62 ff ff ff       	jmp    804ff3 <__umoddi3+0xb3>
